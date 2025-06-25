RegisterNetEvent("flakeyCore:savePedData", function(pedData)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)

    for fullId, data in pairs(playerDataCache) do
        if fullId:find(baseId, 1, true) == 1 then
            updatePlayerField(fullId, "ped", json.encode(pedData))
            playerDataCache[fullId].ped = pedData
            break
        end
    end
end)

AddEventHandler("flakeyCore:playerLoaded", function(source)
    local baseId = GetPlayerIdentifier(source, 0)

    for fullId, data in pairs(playerDataCache) do
        if fullId:find(baseId, 1, true) == 1 then
            TriggerClientEvent("flakeyCore:loadPedData", source, data.ped)
            break
        end
    end
end)
