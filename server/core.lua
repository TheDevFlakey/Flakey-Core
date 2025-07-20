-- core_server.lua

playerDataCache = {}  -- maps cid to character data
activeCharacter = {}  -- maps player source to cid
playerCidMap = {}     -- maps player source to cid (for quick lookup)

exports('playerDataCache', function() return playerDataCache end)
exports('activeCharacter', function() return activeCharacter end)
exports("getSourceFromCID", function(cid)
    for src, character in pairs(activeCharacter) do
        if character == cid then
            return src
        end
    end
    return nil
end)

-- Utility function for KVP
function getKvp(cid, key, default)
    local val = GetResourceKvpString(cid .. ":" .. key)
    return val and json.decode(val) or default
end

function setKvp(cid, key, data)
    SetResourceKvp(cid .. ":" .. key, json.encode(data))
end

-- Generate next available character ID
function generateId()
    local query = [[
        SELECT MIN(cid + 1) AS next_id
        FROM flakey_players
        WHERE cid >= 1000
        AND NOT EXISTS (SELECT NULL FROM flakey_players u2 WHERE u2.cid = flakey_players.cid + 1)
    ]]
    return MySQL.scalar.await(query) or 1000
end

-- Ensure player data exists
local function ensurePlayerData(cid)
    local result = exports.oxmysql:query_async('SELECT * FROM flakey_players WHERE cid = ?', { cid })

    if result[1] then
        result[1].health = getKvp(cid, "health", 200)
        result[1].hunger = getKvp(cid, "hunger", 100)
        result[1].thirst = getKvp(cid, "thirst", 100)
        result[1].height = tonumber(result[1].height) or 180
        return result[1]
    else
        local defaultData = {
            cid = cid,
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

        exports.oxmysql:insert_async([[INSERT INTO flakey_players 
            (cid, cash, bank, position, ped, name, dob, gender, height, job, grade) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]], {
            cid, defaultData.cash, defaultData.bank, defaultData.position,
            defaultData.ped, defaultData.name, defaultData.dob, defaultData.gender,
            defaultData.height, defaultData.job, defaultData.grade
        })

        setKvp(cid, "health", defaultData.health)
        setKvp(cid, "hunger", defaultData.hunger)
        setKvp(cid, "thirst", defaultData.thirst)

        return defaultData
    end
end

-- Character selection
RegisterNetEvent("flakeyCore:selectCharacter", function(cid)
    local src = source
    local data = ensurePlayerData(cid)

    activeCharacter[src] = cid
    playerCidMap[src] = cid
    playerDataCache[cid] = data

    data.position = json.decode(data.position)
    data.ped = json.decode(data.ped)

    Player(src).state:set("health", data.health, true)
    Player(src).state:set("hunger", data.hunger, true)

    TriggerClientEvent("flakeyCore:loadPlayer", src, data)
    TriggerClientEvent("flakeyCore:loadPedData", src, data.ped)
    TriggerClientEvent("flakeyCore:playerLoaded", src)
end)

RegisterNetEvent("flakeyCore:savePlayerPosition", function(pos)
    local src = source
    local cid = activeCharacter[src]
    if cid and playerDataCache[cid] then
        playerDataCache[cid].position = pos
    end
end)

RegisterNetEvent("flakeyCore:updateLastKnownPosition", function(pos)
    local src = source
    local cid = activeCharacter[src]
    if cid and playerDataCache[cid] then
        playerDataCache[cid].position = pos
    end
end)

RegisterNetEvent("flakeyCore:updateNeed", function(type, value)
    local src = source
    local cid = activeCharacter[src]
    if cid and playerDataCache[cid] then
        playerDataCache[cid][type] = value
        setKvp(cid, type, value)
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local cid = activeCharacter[src]
    local data = cid and playerDataCache[cid]
    if not data then return end

    local pos = data.position or { x = -270.0, y = -957.0, z = 31.2, heading = 250.0 }

    exports.oxmysql:update_async([[UPDATE flakey_players SET
        cash = ?, bank = ?, position = ?, ped = ?,
        name = ?, dob = ?, gender = ?, height = ?, job = ?, grade = ?
        WHERE cid = ?]], {
        data.cash, data.bank, json.encode(pos), json.encode(data.ped),
        data.name, data.dob, data.gender, data.height, data.job, data.grade, cid
    })

    setKvp(cid, "health", data.health)
    setKvp(cid, "hunger", data.hunger)
    setKvp(cid, "thirst", data.thirst)

    activeCharacter[src] = nil
    playerCidMap[src] = nil
    playerDataCache[cid] = nil
end)

RegisterNetEvent("flakeyCore:createCharacter", function(charData)
    local src = source
    local cid = generateId()
    local fivemId = GetPlayerIdentifier(src, 0)

    local defaultPos = json.encode({ x = -270.0, y = -957.0, z = 31.2, heading = 250.0 })
    local defaultPed = json.encode({ model = `mp_m_freemode_01`, components = {}, props = {} })

    exports.oxmysql:insert_async([[INSERT INTO flakey_players (
        cid, fivem_id, cash, bank, position, ped, name, dob, gender, height, job, grade
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]], {
        cid,
        fivemId,
        1000,
        5000,
        defaultPos,
        defaultPed,
        charData.name,
        charData.dob,
        charData.gender,
        tonumber(charData.height) or 180,
        "unemployed",
        0
    })

    setKvp(cid, "health", 200)
    setKvp(cid, "hunger", 100)
    setKvp(cid, "thirst", 100)

    TriggerClientEvent("flakey_multichar:characterCreated", src, true, cid)
end)


RegisterNetEvent("flakeyCore:playerJoined", function()
    local src = source
    local fivemId = GetPlayerIdentifier(src, 0)

    if not fivemId then
        print("flakeyCore: No valid identifier found for player " .. src)
        return
    end

    local result = exports.oxmysql:query_async(
        'SELECT * FROM flakey_players WHERE fivem_id = ?', 
        { fivemId }
    )

    if #result == 0 then
        TriggerClientEvent("flakey_multichar:showCreateCharacter", src)
    else
        TriggerClientEvent("flakey_multichar:loadCharacters", src, result)
    end
end)

RegisterNetEvent("flakeyCore:deleteCharacter", function(cid)
    local src = source

    exports.oxmysql:execute_async('DELETE FROM flakey_players WHERE cid = ?', { cid })

    playerDataCache[cid] = nil
    if activeCharacter[src] == cid then
        activeCharacter[src] = nil
        playerCidMap[src] = nil
    end

    TriggerClientEvent("flakey_multichar:characterDeleted", src, cid)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for src, cid in pairs(activeCharacter) do
            local data = playerDataCache[cid]
            if not data then return end

            local pos = data.position or { x = -270.0, y = -957.0, z = 31.2, heading = 250.0 }

            setKvp(cid, "health", data.health)
            setKvp(cid, "hunger", data.hunger)
            setKvp(cid, "thirst", data.thirst)
            activeCharacter[src] = nil
            playerCidMap[src] = nil
            playerDataCache[cid] = nil

            exports.oxmysql:update_async([[UPDATE flakey_players SET
                cash = ?, bank = ?, position = ?, ped = ?,
                name = ?, dob = ?, gender = ?, height = ?, job = ?, grade = ?
                WHERE cid = ?]], {
                data.cash, data.bank, json.encode(pos), json.encode(data.ped),
                data.name, data.dob, data.gender, data.height, data.job, data.grade, cid
            })
        end
    end
end)