
---

```lua name=main.lua url=https://github.com/maickrodrigues134-gif/meme-sea-autofarm/blob/main/main.lua
-- 🌊 MEME SEA AUTOFARM v2.0.0 🌊
-- Professional Grade Script
-- Made with ❤️ by maickrodrigues134-gif

-- ===== SERVICES =====
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- ===== SETUP =====
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Load Config
local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/maickrodrigues134-gif/meme-sea-autofarm/main/config.lua"))()

-- Load Modules
local farm = loadstring(game:HttpGet("https://raw.githubusercontent.com/maickrodrigues134-gif/meme-sea-autofarm/main/lib/farm.lua"))()
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/maickrodrigues134-gif/meme-sea-autofarm/main/lib/ui.lua"))()
local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/maickrodrigues134-gif/meme-sea-autofarm/main/lib/utils.lua"))()

-- ===== GLOBAL STATE =====
local scriptState = {
    farmActive = false,
    autoAttackActive = false,
    autoDodgeActive = false,
    autoHealActive = false,
    powerFarmActive = false,
    
    stats = {
        coinsCollected = 0,
        powersObtained = 0,
        beastsDefeated = 0,
        xpGained = 0,
        startTime = tick(),
    },
    
    currentTarget = nil,
    lastActionTime = {},
}

-- ===== CONSTANTS =====
local POWER_RARITIES = {
    Common = {colors = {Color3.fromRGB(255, 255, 255)}, value = 1},
    Uncommon = {colors = {Color3.fromRGB(0, 255, 0)}, value = 2},
    Rare = {colors = {Color3.fromRGB(0, 0, 255)}, value = 3},
    Legendary = {colors = {Color3.fromRGB(255, 215, 0)}, value = 4},
}

local BEAST_NAMES = {"Beast", "Meme Beast", "Enemy", "Creature"}

-- ===== CORE FUNCTIONS =====

--- Encuentra potencias disponibles cerca del jugador
local function findNearbyPowers()
    local powers = {}
    local farmRadius = config.farmRadius or 100
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local distance = (rootPart.Position - obj.HumanoidRootPart.Position).Magnitude
            if distance < farmRadius and distance > 5 then
                table.insert(powers, {
                    object = obj,
                    distance = distance,
                    name = obj.Name,
                })
            end
        end
    end
    
    table.sort(powers, function(a, b) return a.distance < b.distance end)
    return powers
end

--- Encuentra enemigos cercanos
local function findNearbyEnemies()
    local enemies = {}
    local farmRadius = config.farmRadius or 100
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= character then
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                local distance = (rootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if distance < farmRadius and distance > 5 then
                    table.insert(enemies, {
                        object = obj,
                        humanoid = obj.Humanoid,
                        distance = distance,
                    })
                end
            end
        end
    end
    
    table.sort(enemies, function(a, b) return a.distance < b.distance end)
    return enemies
end

--- Move hacia objetivo
local function moveToward(targetPos)
    local direction = (targetPos - rootPart.Position).Unit
    humanoid:Move(direction * 3, false)
end

--- Usa habilidad con delay anti-ban
local function useSkill(key)
    if not config.autoAttack then return end
    
    local lastTime = scriptState.lastActionTime[key] or 0
    if tick() - lastTime < (config.clickDelay or 0.1) then return end
    
    local success = pcall(function()
        UserInputService:SendKeyEvent(true, Enum.KeyCode[key], false)
        wait(config.clickDelay or 0.1)
        UserInputService:SendKeyEvent(false, Enum.KeyCode[key], false)
    end)
    
    scriptState.lastActionTime[key] = tick()
    return success
end

--- Farm de poderes
local function farmPowers()
    if not config.autoFarm then return end
    
    local powers = findNearbyPowers()
    
    if #powers > 0 then
        local nearestPower = powers[1]
        moveToward(nearestPower.object.HumanoidRootPart.Position)
        
        if nearestPower.distance < 10 then
            scriptState.stats.powersObtained = scriptState.stats.powersObtained + 1
            
            if config.debugMode then
                print("⚡ Poder obtido: " .. nearestPower.name)
            end
        end
    end
end

--- Combate automático
local function autoCombat()
    if not config.autoAttack then return end
    
    local enemies = findNearbyEnemies()
    
    if #enemies > 0 then
        scriptState.currentTarget = enemies[1]
        local target = enemies[1]
        
        moveToward(target.object.HumanoidRootPart.Position)
        
        -- Use random skills
        local skills = {"E", "R", "T", "I"}
        local randomSkill = skills[math.random(1, #skills)]
        useSkill(randomSkill)
        
        if config.autoDodge and math.random(1, 100) > 60 then
            useSkill("Q")
        end
    end
end

--- Curación automática
local function autoHeal()
    if not config.autoHeal then return end
    if humanoid.Health > humanoid.MaxHealth * 0.5 then return end
    
    if config.debugMode then
        print("💊 Curando... HP: " .. humanoid.Health)
    end
end

--- Main Loop de Farm
local farmConnection = RunService.Heartbeat:Connect(function()
    if not scriptState.farmActive then return end
    
    pcall(function()
        if config.autoFarm then farmPowers() end
        if config.autoAttack then autoCombat() end
        if config.autoHeal then autoHeal() end
    end)
end)

--- Update de Stats
local statsConnection = RunService.Heartbeat:Connect(function()
    if not scriptState.farmActive then return end
    
    if tick() - (scriptState.lastStatsUpdate or 0) >= 1 then
        scriptState.lastStatsUpdate = tick()
        
        local elapsedTime = tick() - scriptState.stats.startTime
        local minutes = math.floor(elapsedTime / 60)
        local seconds = math.fmod(elapsedTime, 60)
        
        if config.showUI then
            ui.updateStats({
                farmActive = scriptState.farmActive,
                powersObtained = scriptState.stats.powersObtained,
                coinsCollected = scriptState.stats.coinsCollected,
                beastsDefeated = scriptState.stats.beastsDefeated,
                xpGained = scriptState.stats.xpGained,
                elapsedTime = string.format("%dm %ds", minutes, math.floor(seconds)),
                currentTarget = scriptState.currentTarget and scriptState.currentTarget.object.Name or "Procurando...",
                playerHP = math.floor(humanoid.Health),
                playerMaxHP = math.floor(humanoid.MaxHealth),
            })
        end
    end
end)

-- ===== KEYBOARD CONTROLS =====

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        scriptState.farmActive = not scriptState.farmActive
        scriptState.stats.startTime = tick()
        
        if config.showUI then
            ui.updateStatus(scriptState.farmActive and "🟢 FARM ATIVO" or "🔴 FARM PARADO")
        end
        
        print(scriptState.farmActive and "✅ Farm iniciado!" or "❌ Farm parado!")
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        config.autoHeal = not config.autoHeal
        print("Cura automática: " .. (config.autoHeal and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.P then
        config.autoFarm = not config.autoFarm
        print("Farm de poderes: " .. (config.autoFarm and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        scriptState.stats = {
            coinsCollected = 0,
            powersObtained = 0,
            beastsDefeated = 0,
            xpGained = 0,
            startTime = tick(),
        }
        print("✓ Estatísticas resetadas!")
    end
    
    if input.KeyCode == Enum.KeyCode.U then
        config.showUI = not config.showUI
        if config.showUI then
            ui.show()
        else
            ui.hide()
        end
    end
end)

-- ===== CHARACTER RESPAWN =====

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    scriptState.stats.startTime = tick()
    print("✓ Personagem respawnado, farm continuando...")
end)

-- ===== CLEANUP =====

game:BindToClose(function()
    farmConnection:Disconnect()
    statsConnection:Disconnect()
    print("Script desativado com sucesso!")
end)

-- ===== STARTUP MESSAGE =====

print("╔═══════════════════════════════════════╗")
print("║ 🌊 MEME SEA AUTOFARM v2.0.0          ║")
print("║ Professional Grade Script             ║")
print("║ Carregado com sucesso!                ║")
print("╚═══════════════════════════════════════╝")
print("")
print("⌨️  CONTROLES:")
print("  [F] - Iniciar/Parar Farm")
print("  [H] - Toggle Auto Heal")
print("  [P] - Toggle Power Farm")
print("  [R] - Resetar Stats")
print("  [U] - Alternar UI")
print("")
print("🎮 Customize em: config.lua")
print("📊 UI ativa e pronta!")
print("")

if config.debugMode then
    print("🔍 DEBUG MODE ATIVADO - Veja logs detalhados")
end

-- Initialize UI
if config.showUI then
    ui.create()
end

print("✅ Script pronto! Pressione [F] para iniciar.")
