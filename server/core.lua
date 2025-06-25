-- core_server.lua
playerDataCache = {} -- maps charId to character data
activeCharacter = {}  -- maps player source to charId

-- Utility function for KVP
function getKvp(identifier, key, default)
    local val = GetResourceKvpString(identifier .. ":" .. key)
    return val and json.decode(val) or default
end

function setKvp(identifier, key, data)
    SetResourceKvp(identifier .. ":" .. key, json.encode(data))
end

-- Build character-specific identifier
function getCharacterId(src, slot)
    local base = GetPlayerIdentifier(src, 0)
    return ("%s|%s"):format(base, slot)
end

-- Ensure player data exists in cache
local function ensurePlayerData(identifier)
    local result = exports.oxmysql:query_async('SELECT * FROM flakey_players WHERE identifier = ?', { identifier })

    if result[1] then
        result[1].health = getKvp(identifier, "health", 200)
        result[1].hunger = getKvp(identifier, "hunger", 100)
        result[1].thirst = getKvp(identifier, "thirst", 100)
        result[1].name = result[1].name or "John Doe"
        result[1].dob = result[1].dob or "2000-01-01"
        result[1].gender = result[1].gender or "male"
        result[1].height = tonumber(result[1].height) or 180
        result[1].job = result[1].job or "unemployed"
        result[1].grade = tonumber(result[1].grade) or 0
        return result[1]
    else
        local defaultData = {
            identifier = identifier,
            cash = 1000,
            bank = 5000,
            position = json.encode({ x = -270.0, y = -957.0, z = 31.2, heading = 250.0 }),
            ped = json.encode({ model = `mp_m_freemode_01`, components = {}, props = {} }),
            name = "John Doe",
            dob = "2000-01-01",
            gender = "male",
            height = 180,
            health = 200,
            hunger = 100,
            thirst = 100,
            job = "unemployed",
            grade = 0
        }

        exports.oxmysql:insert_async([[INSERT INTO flakey_players (identifier, cash, bank, position, ped, name, dob, gender, height, job, grade)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]], {
            identifier, defaultData.cash, defaultData.bank, defaultData.position,
            defaultData.ped, defaultData.name, defaultData.dob, defaultData.gender,
            defaultData.height, defaultData.job, defaultData.grade
        })

        setKvp(identifier, "health", defaultData.health)
        setKvp(identifier, "hunger", defaultData.hunger)
        setKvp(identifier, "thirst", defaultData.thirst)

        return defaultData
    end
end

-- Called when character is selected
RegisterNetEvent("flakeyCore:selectCharacter", function(slot)
    local src = source
    local charId = getCharacterId(src, slot)
    local data = ensurePlayerData(charId)

    activeCharacter[src] = charId
    playerDataCache[charId] = data

    data.position = json.decode(data.position)
    data.ped = json.decode(data.ped)

    TriggerClientEvent("flakeyCore:loadPlayer", src, data)
    TriggerClientEvent("flakeyCore:loadPedData", src, data.ped)
    TriggerClientEvent("flakeyCore:playerLoaded", src)
end)

-- Save player position
RegisterNetEvent("flakeyCore:savePlayerPosition", function(pos)
    local src = source
    local charId = activeCharacter[src]
    if charId and playerDataCache[charId] then
        playerDataCache[charId].position = pos
    end
end)

RegisterNetEvent("flakeyCore:updateLastKnownPosition", function(pos)
    local src = source
    local charId = activeCharacter[src]
    if charId and playerDataCache[charId] then
        playerDataCache[charId].position = pos
    end
end)

RegisterNetEvent("flakeyCore:updateNeed", function(type, value)
    local src = source
    local charId = activeCharacter[src]
    if charId and playerDataCache[charId] then
        playerDataCache[charId][type] = value
        setKvp(charId, type, value)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local charId = activeCharacter[src]
    local data = charId and playerDataCache[charId]
    if not data then return end

    local pos = data.position or { x = -270.0, y = -957.0, z = 31.2, heading = 250.0 }

    exports.oxmysql:update_async([[UPDATE flakey_players SET
        cash = ?, bank = ?, position = ?, ped = ?,
        name = ?, dob = ?, gender = ?, height = ?, job = ?, grade = ?
        WHERE identifier = ?]], {
        data.cash, data.bank, json.encode(pos), json.encode(data.ped),
        data.name, data.dob, data.gender, data.height, data.job, data.grade, charId
    })

    setKvp(charId, "health", data.health)
    setKvp(charId, "hunger", data.hunger)
    setKvp(charId, "thirst", data.thirst)

    activeCharacter[src] = nil
    playerDataCache[charId] = nil
end)
