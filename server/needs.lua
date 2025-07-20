-- Save need to KVP + memory
local function saveNeed(cid, key, value)
    setKvp(cid, key, value)
    if playerDataCache[cid] then
        playerDataCache[cid][key] = value
    end
end

-- Decrease hunger and thirst every 60 seconds
CreateThread(function()
    while true do
        Wait(60000)
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            local cid = activeCharacter[src]
            local data = cid and playerDataCache[cid]
            if data then
                local newHunger = math.max(0, data.hunger - 1)
                local newThirst = math.max(0, data.thirst - 1)

                saveNeed(cid, "hunger", newHunger)
                saveNeed(cid, "thirst", newThirst)

                Player(src).state:set("hunger", newHunger, true)
                Player(src).state:set("thirst", newThirst, true)
            end
        end
    end
end)

RegisterNetEvent("flakeyCore:addHunger", function(amount)
    local src = source
    local cid = activeCharacter[src]
    local data = cid and playerDataCache[cid]
    if data then
        local newHunger = math.min(100, data.hunger + amount)
        saveNeed(cid, "hunger", newHunger)
        Player(src).state:set("hunger", newHunger, true)
    end
end)

RegisterNetEvent("flakeyCore:addThirst", function(amount)
    local src = source
    local cid = activeCharacter[src]
    local data = cid and playerDataCache[cid]
    if data then
        local newThirst = math.min(100, data.thirst + amount)
        saveNeed(cid, "thirst", newThirst)
        Player(src).state:set("thirst", newThirst, true)
    end
end)

RegisterNetEvent("flakeyCore:setHunger", function(amount)
    local src = source
    local cid = activeCharacter[src]
    local clamped = math.max(0, math.min(100, amount))
    if cid then
        saveNeed(cid, "hunger", clamped)
        Player(src).state:set("hunger", clamped, true)
    end
end)

RegisterNetEvent("flakeyCore:setThirst", function(amount)
    local src = source
    local cid = activeCharacter[src]
    local clamped = math.max(0, math.min(100, amount))
    if cid then
        saveNeed(cid, "thirst", clamped)
        Player(src).state:set("thirst", clamped, true)
    end
end)

RegisterCommand("resetNeeds", function(source, args, rawCommand)
    local src = source
    local cid = activeCharacter[src]
    if cid then
        saveNeed(cid, "hunger", 100)
        saveNeed(cid, "thirst", 100)
        Player(src).state:set("hunger", 100, true)
        Player(src).state:set("thirst", 100, true)
    end
end, false)
