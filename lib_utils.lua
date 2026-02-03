-- 🌊 UTILS MODULE - Funções Utilitárias

local utils = {}

--- Calcula distância
function utils.distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

--- Gera delay aleatório
function utils.randomDelay(min, max)
    return math.random(min * 1000, max * 1000) / 1000
end

--- Verifica se está perto
function utils.isNearby(pos1, pos2, radius)
    return utils.distance(pos1, pos2) < radius
end

--- Anti-ban delay
function utils.antibanDelay(baseDelay)
    local jitter = math.random(-20, 20) / 100
    return baseDelay + jitter
end

--- Log com timestamp
function utils.log(message)
    local timestamp = os.date("%H:%M:%S")
    print("[" .. timestamp .. "] " .. message)
end

--- Procura recursivamente
function utils.findDescendant(parent, name)
    for _, child in pairs(parent:GetDescendants()) do
        if child.Name == name then
            return child
        end
    end
    return nil
end

return utils