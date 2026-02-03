-- 🌊 UI MODULE - Interface de Usuário

local ui = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local screenGui = nil

--- Cria a interface
function ui.create()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MemeSea_AutoFarm_UI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 380, 0, 550)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    mainFrame.BorderSizePixel = 2
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🌊 MEME SEA AUTOFARM"
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleLabel
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 0, 60)
    statusLabel.Position = UDim2.new(0, 5, 0, 60)
    statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextWrapped = true
    statusLabel.Text = "🔴 PARADO"
    statusLabel.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusLabel
    
    -- Stats Label
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Name = "StatsLabel"
    statsLabel.Size = UDim2.new(1, -10, 0, 200)
    statsLabel.Position = UDim2.new(0, 5, 0, 130)
    statsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    statsLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    statsLabel.TextSize = 12
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextWrapped = true
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.Text = "📊 STATS\nPoderes: 0\nMoedas: 0\nBestas: 0\nTempo: 0m 0s"
    statsLabel.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 6)
    statsCorner.Parent = statsLabel
    
    -- Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -10, 0, 40)
    toggleButton.Position = UDim2.new(0, 5, 0, 340)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = "▶ INICIAR [F]"
    toggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- Help Label
    local helpLabel = Instance.new("TextLabel")
    helpLabel.Size = UDim2.new(1, -10, 0, 100)
    helpLabel.Position = UDim2.new(0, 5, 0, 390)
    helpLabel.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    helpLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
    helpLabel.TextSize = 11
    helpLabel.Font = Enum.Font.Gotham
    helpLabel.TextWrapped = true
    helpLabel.TextXAlignment = Enum.TextXAlignment.Left
    helpLabel.Text = "⌨️ CONTROLES:\n[F] Farm ON/OFF\n[H] Auto Heal\n[P] Power Farm\n[R] Reset Stats\n[U] Hide UI"
    helpLabel.Parent = mainFrame
    
    local helpCorner = Instance.new("UICorner")
    helpCorner.CornerRadius = UDim.new(0, 6)
    helpCorner.Parent = helpLabel
    
    screenGui.Enabled = true
end

--- Atualiza status
function ui.updateStatus(status)
    if not screenGui then return end
    
    local statusLabel = screenGui:FindFirstChild("MainFrame"):FindFirstChild("StatusLabel")
    if statusLabel then
        statusLabel.Text = status
    end
end

--- Atualiza stats
function ui.updateStats(stats)
    if not screenGui then return end
    
    local statsLabel = screenGui:FindFirstChild("MainFrame"):FindFirstChild("StatsLabel")
    if statsLabel then
        statsLabel.Text = string.format(
            "📊 STATS\nPoderes: %d\nMoedas: %d\nBestas: %d\nHP: %d/%d\nTempo: %s\nAlvo: %s",
            stats.powersObtained or 0,
            stats.coinsCollected or 0,
            stats.beastsDefeated or 0,
            stats.playerHP or 0,
            stats.playerMaxHP or 0,
            stats.elapsedTime or "0m 0s",
            stats.currentTarget or "Procurando..."
        )
    end
end

--- Mostra UI
function ui.show()
    if screenGui then screenGui.Enabled = true end
end

--- Esconde UI
function ui.hide()
    if screenGui then screenGui.Enabled = false end
end

return ui