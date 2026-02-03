-- 🌊 FARM MODULE - Lógica de Farm

local farm = {}

--- Coleta recursos
function farm.collectResources(resources, config)
    if not resources or #resources == 0 then return end
    
    local nearest = resources[1]
    if not nearest or not nearest.object or not nearest.object.HumanoidRootPart then
        return
    end
    
    -- Move to resource
    local direction = (nearest.object.HumanoidRootPart.Position - _G.rootPart.Position).Unit
    _G.humanoid:Move(direction * 3, false)
    
    return nearest
end

--- Sistema de combate
function farm.engageTarget(target, config)
    if not target or not target.object then return end
    
    local targetRoot = target.object:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Move to target
    local direction = (targetRoot.Position - _G.rootPart.Position).Unit
    _G.humanoid:Move(direction * 3, false)
    
    return target
end

--- Equipa melhor poder
function farm.equipBestPower()
    -- Implementación de equipo de mejor poder
    if _G.config.autoEquipPowers then
        -- Lógica específica del juego
    end
end

return farm