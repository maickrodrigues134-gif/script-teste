-- 🌊 MEME SEA AUTOFARM - CONFIG.LUA
-- Personalize todas as configurações aqui

return {
    -- ===== FARM SETTINGS =====
    autoFarm = true,                    -- Ativa farm automático
    farmRadius = 150,                   -- Raio de detecção (metros)
    targetRarity = "Legendary",         -- Common, Uncommon, Rare, Legendary
    
    -- ===== COMBAT SETTINGS =====
    autoAttack = true,                  -- Ataque automático
    autoDodge = true,                   -- Esquiva automática
    dodgeChance = 60,                   -- % chance de esquivar
    autoHeal = true,                    -- Cura automática
    healThreshold = 0.5,                -- Cura quando HP < 50%
    
    -- ===== DELAY SETTINGS (anti-ban) =====
    clickDelay = 0.1,                   -- Delay entre ataques (segundos)
    moveDelay = 0.05,                   -- Delay entre movimentos
    actionDelay = 0.15,                 -- Delay entre ações
    
    -- ===== POWER SETTINGS =====
    autoEquipPowers = true,             -- Auto-equipa melhores poderes
    maxPowersHeld = 4,                  -- Máximo de poderes no inventário
    
    -- ===== UI SETTINGS =====
    showUI = true,                      -- Mostra dashboard
    uiPosition = "TopLeft",             -- TopLeft, TopRight, BottomLeft, BottomRight
    uiScale = 1.0,                      -- Tamanho da UI (0.5 a 2.0)
    
    -- ===== DEBUG SETTINGS =====
    debugMode = false,                  -- Mostra mensagens detalhadas
    logActions = true,                  -- Log de ações no console
    verbose = false,                    -- Mensagens extra detalhadas
}