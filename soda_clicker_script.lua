-- Script para Peça de Cola (Soda Clicker)
-- Clicker automatizado com sistema de upgrades

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local clicksPerSecond = 1
local autoClickEnabled = false
local multiplier = 1

-- Interface de controle
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SodaClickerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Botão principal
local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0, 200, 0, 50)
mainButton.Position = UDim2.new(0, 10, 0, 10)
mainButton.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 20
mainButton.Font = Enum.Font.GothamBold
mainButton.Text = "Auto Click: OFF"
mainButton.Parent = screenGui

-- Botão para aumentar velocidade
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 200, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 70)
speedButton.BackgroundColor3 = Color3.fromRGB(0, 153, 76)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20
speedButton.Font = Enum.Font.GothamBold
speedButton.Text = "Velocidade: 1x"
speedButton.Parent = screenGui

-- Label de informações
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(0, 200, 0, 100)
infoLabel.Position = UDim2.new(0, 10, 0, 130)
infoLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Text = "Cliques/s: 1\nMultiplicador: 1x\n[T] - Toggle Auto\n[Y] - Speed+"
infoLabel.Parent = screenGui

-- Função de clique automático
local function performClick()
    local button = mouse.Target
    if button and button.Parent then
        local clickEvent = button:FindFirstChild("ClickDetector") or button.Parent:FindFirstChild("ClickDetector")
        if clickEvent then
            clickEvent:FireServer()
        end
    end
end

-- Clique automático
RunService.Heartbeat:Connect(function()
    if autoClickEnabled then
        for i = 1, clicksPerSecond do
            performClick()
            wait(1 / (clicksPerSecond * 60))
        end
    end
end)

-- Toggle Auto Click com T
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        autoClickEnabled = not autoClickEnabled
        mainButton.Text = autoClickEnabled and "Auto Click: ON" or "Auto Click: OFF"
        mainButton.BackgroundColor3 = autoClickEnabled and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(0, 102, 204)
    end
    
    if input.KeyCode == Enum.KeyCode.Y then
        clicksPerSecond = math.min(clicksPerSecond + 1, 10)
        speedButton.Text = "Velocidade: " .. clicksPerSecond .. "x"
        infoLabel.Text = "Cliques/s: " .. clicksPerSecond .. "\nMultiplicador: " .. multiplier .. "x\n[T] - Toggle Auto\n[Y] - Speed+"
    end
    
    if input.KeyCode == Enum.KeyCode.U then
        clicksPerSecond = math.max(clicksPerSecond - 1, 1)
        speedButton.Text = "Velocidade: " .. clicksPerSecond .. "x"
        infoLabel.Text = "Cliques/s: " .. clicksPerSecond .. "\nMultiplicador: " .. multiplier .. "x\n[T] - Toggle Auto\n[Y] - Speed+"
    end
end)

-- Botões da interface
mainButton.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    mainButton.Text = autoClickEnabled and "Auto Click: ON" or "Auto Click: OFF"
    mainButton.BackgroundColor3 = autoClickEnabled and Color3.fromRGB(255, 85, 0) or Color3.fromRGB(0, 102, 204)
end)

speedButton.MouseButton1Click:Connect(function()
    clicksPerSecond = math.min(clicksPerSecond + 1, 10)
    speedButton.Text = "Velocidade: " .. clicksPerSecond .. "x"
end)

print("✓ Script de Peça de Cola carregado!")
print("Controles:")
print("[T] - Ativar/Desativar Auto Click")
print("[Y] - Aumentar velocidade")
print("[U] - Diminuir velocidade")