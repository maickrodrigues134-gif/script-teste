-- ====================================
-- MEME SEA AUTOFARM - VELOCITY EDITION
-- ====================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local config = {
    autoFarm = true,
    autoAttack = true,
    autoDodge = true,
    autoHeal = true,
    farmSpeed = 1,
    showUI = true,
}

-- STATS
local stats = {
    kills = 0,
    coins = 0,
    powers = 0,
    startTime = tick(),
}

local farmActive = false

-- ===== UI CREATION =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MemeSea_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0, 15, 0, 15)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🌊 MEME SEA AUTOFARM"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Status Display
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -10, 0, 70)
statusLabel.Position = UDim2.new(0, 5, 0, 50)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "🔴 PARADO\n\nKills: 0\nMoedas: 0\nPoderes: 0"
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- Stats Display
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "Stats"
statsLabel.Size = UDim2.new(1, -10, 0, 100)
statsLabel.Position = UDim2.new(0, 5, 0, 130)
statsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
statsLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
statsLabel.TextSize = 11
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextWrapped = true
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Text = "📊 STATS\n\nHP: 0/0\nTempo: 0m 0s\nVelocidade: 1x"
statsLabel.Parent = mainFrame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 6)
statsCorner.Parent = statsLabel

-- Start Button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(1, -10, 0, 40)
startButton.Position = UDim2.new(0, 5, 0, 240)
startButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.TextSize = 14
startButton.Font = Enum.Font.GothamBold
startButton.Text = "▶ INICIAR [F]"
startButton.Parent = mainFrame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 6)
startCorner.Parent = startButton

-- Help Label
local helpLabel = Instance.new("TextLabel")
helpLabel.Size = UDim2.new(1, -10, 0, 95)
helpLabel.Position = UDim2.new(0, 5, 0, 290)
helpLabel.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
helpLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
helpLabel.TextSize = 10
helpLabel.Font = Enum.Font.Gotham
helpLabel.TextWrapped = true
helpLabel.TextXAlignment = Enum.TextXAlignment.Left
helpLabel.Text = "⌨️ CONTROLES:\n\n[F] Iniciar/Parar\n[H] Auto Heal\n[P] Power Farm\n[R] Reset Stats"
helpLabel.Parent = mainFrame

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 6)
helpCorner.Parent = helpLabel

-- ===== FUNCTIONS =====

local function findNearbyEnemies()
    local enemies = {}
    for _, obj in pairs(game.Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= character then
            local hasHumanoid = obj:FindFirstChild("Humanoid")
            local hasRoot = obj:FindFirstChild("HumanoidRootPart")
            
            if hasHumanoid and hasRoot then
                local distance = (rootPart.Position - hasRoot.Position).Magnitude
                if distance < 100 and distance > 5 then
                    table.insert(enemies, {
                        model = obj,
                        humanoid = hasHumanoid,
                        root = hasRoot,
                        distance = distance
                    })
                end
            end
        end
    end
    
    table.sort(enemies, function(a, b) return a.distance < b.distance end)
    return enemies
end

local function moveToward(targetPos)
    local direction = (targetPos - rootPart.Position).Unit
    humanoid:Move(direction * 3, false)
end

local function useSkill(keyCode)
    pcall(function()
        local inputObject = Instance.new("InputObject")
        inputObject.KeyCode = keyCode
        inputObject.UserInputType = Enum.UserInputType.Keyboard
        UserInputService:SendKeyEvent(true, keyCode, false)
        wait(0.05)
        UserInputService:SendKeyEvent(false, keyCode, false)
    end)
end

local function farmCombat()
    local enemies = findNearbyEnemies()
    
    if #enemies > 0 then
        local target = enemies[1]
        moveToward(target.root.Position)
        
        -- Auto attack
        if config.autoAttack and math.random(1, 100) > 40 then
            local skills = {
                Enum.KeyCode.E,
                Enum.KeyCode.R,
                Enum.KeyCode.T,
                Enum.KeyCode.I,
            }
            useSkill(skills[math.random(1, #skills)])
        end
        
        -- Auto dodge
        if config.autoDodge and math.random(1, 100) > 70 then
            useSkill(Enum.KeyCode.Q)
        end
        
        stats.kills = stats.kills + 1
    end
end

local function autoHeal()
    if not config.autoHeal then return end
    if humanoid.Health > humanoid.MaxHealth * 0.4 then return end
    
    -- Tenta usar item de cura
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:lower():find("heal") or item.Name:lower():find("potion") then
                pcall(function()
                    item:Activate()
                end)
                break
            end
        end
    end
end

-- ===== MAIN LOOP =====
RunService.Heartbeat:Connect(function()
    if not farmActive then return end
    
    pcall(function()
        farmCombat()
        autoHeal()
    end)
end)

-- ===== UI UPDATE LOOP =====
local lastUpdate = tick()
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate < 0.5 then return end
    lastUpdate = tick()
    
    local elapsedTime = tick() - stats.startTime
    local minutes = math.floor(elapsedTime / 60)
    local seconds = math.fmod(elapsedTime, 60)
    
    if farmActive then
        statusLabel.Text = string.format(
            "🟢 FARM ATIVO\n\nKills: %d\nMoedas: %d\nPoderes: %d",
            stats.kills,
            stats.coins,
            stats.powers
        )
    else
        statusLabel.Text = string.format(
            "🔴 PARADO\n\nKills: %d\nMoedas: %d\nPoderes: %d",
            stats.kills,
            stats.coins,
            stats.powers
        )
    end
    
    statsLabel.Text = string.format(
        "📊 STATS\n\nHP: %.0f/%.0f\nTempo: %dm %ds\nVelocidade: %dx",
        humanoid.Health,
        humanoid.MaxHealth,
        minutes,
        math.floor(seconds),
        config.farmSpeed
    )
end)

-- ===== BUTTON EVENTS =====
startButton.MouseButton1Click:Connect(function()
    farmActive = not farmActive
    
    if farmActive then
        startButton.Text = "⏹ PARAR [F]"
        startButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        stats.startTime = tick()
        print("✅ FARM INICIADO!")
    else
        startButton.Text = "▶ INICIAR [F]"
        startButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        print("❌ FARM PARADO!")
    end
end)

-- ===== KEYBOARD CONTROLS =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        startButton:FireAllChildren()
        startButton:TriggerEvent("MouseButton1Click")
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        config.autoHeal = not config.autoHeal
        print("Auto Heal: " .. (config.autoHeal and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.P then
        config.autoAttack = not config.autoAttack
        print("Power Farm: " .. (config.autoAttack and "ON" or "OFF"))
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        stats.kills = 0
        stats.coins = 0
        stats.powers = 0
        stats.startTime = tick()
        print("✓ STATS RESETADOS!")
    end
end)

-- ===== CHARACTER RESPAWN =====
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    print("✓ Respawnado! Farm continuando...")
end)

-- ===== STARTUP =====
print("╔═════════════════════════════════════╗")
print("║ 🌊 MEME SEA AUTOFARM - VELOCITY    ║")
print("║ Carregado com sucesso!             ║")
print("╚═════════════════════════════════════╝")
print("")
print("⌨️ CONTROLES:")
print("  [F] - Iniciar/Parar Farm")
print("  [H] - Toggle Auto Heal")
print("  [P] - Toggle Attack")
print("  [R] - Reset Stats")
print("")
print("✅ Script pronto! Pressione [F] para iniciar")
