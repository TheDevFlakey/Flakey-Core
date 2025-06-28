local function saveNeed(fullId, key, value)
    setKvp(fullId, key, value)
    if playerDataCache[fullId] then
        playerDataCache[fullId][key] = value
    end
end

-- Decrease hunger and thirst every 60 seconds
CreateThread(function()
    while true do
        Wait(60000)
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            local baseId = GetPlayerIdentifier(playerId, 0)
            -- Find the actual character ID in cache
            for cacheId, data in pairs(playerDataCache) do
                if cacheId:find(baseId, 1, true) == 1 then
                    local newHunger = math.max(0, data.hunger - 1)
                    local newThirst = math.max(0, data.thirst - 1)

                    saveNeed(cacheId, "hunger", newHunger)
                    saveNeed(cacheId, "thirst", newThirst)
                    Player(src).state:set("hunger", newHunger, true)
                    Player(src).state:set("thirst", newThirst, true)
                end
            end
        end
    end
end)

RegisterNetEvent("flakeyCore:addHunger", function(amount)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    for cacheId, data in pairs(playerDataCache) do
        if cacheId:find(baseId, 1, true) == 1 then
            local newHunger = math.min(100, data.hunger + amount)
            saveNeed(cacheId, "hunger", newHunger)
            Player(src).state:set("hunger", newHunger, true)
            break
        end
    end
end)

RegisterNetEvent("flakeyCore:addThirst", function(amount)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    for cacheId, data in pairs(playerDataCache) do
        if cacheId:find(baseId, 1, true) == 1 then
            local newThirst = math.min(100, data.thirst + amount)
            saveNeed(cacheId, "thirst", newThirst)
            Player(src).state:set("thirst", newHunger, true)
            break
        end
    end
end)

RegisterNetEvent("flakeyCore:setHunger", function(amount)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    local clamped = math.max(0, math.min(100, amount))
    for cacheId in pairs(playerDataCache) do
        if cacheId:find(baseId, 1, true) == 1 then
            saveNeed(cacheId, "hunger", clamped)
            Player(src).state:set("hunger", clamped, true)
            break
        end
    end
end)

RegisterNetEvent("flakeyCore:setThirst", function(amount)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    local clamped = math.max(0, math.min(100, amount))
    for cacheId in pairs(playerDataCache) do
        if cacheId:find(baseId, 1, true) == 1 then
            saveNeed(cacheId, "thirst", clamped)
            Player(src).state:set("thirst", clamped, true)
            break
        end
    end
end)

RegisterCommand("resetNeeds", function(source, args, rawCommand)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    for cacheId in pairs(playerDataCache) do
        if cacheId:find(baseId, 1, true) == 1 then
            saveNeed(cacheId, "hunger", 100)
            saveNeed(cacheId, "thirst", 100)
            Player(src).state:set("hunger", 100, true)
            Player(src).state:set("thirst", 100, true)
            break
        end
    end
end, false)