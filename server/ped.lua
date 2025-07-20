RegisterNetEvent("flakeyCore:savePedData", function(pedData)
    local src = source
    local cid = activeCharacter[src]
    local data = cid and playerDataCache[cid]

    if data then
        updatePlayerField(cid, "ped", json.encode(pedData))
        data.ped = pedData
    end
end)

AddEventHandler("flakeyCore:playerLoaded", function(source)
    local cid = activeCharacter[source]
    local data = cid and playerDataCache[cid]

    if data then
        TriggerClientEvent("flakeyCore:loadPedData", source, data.ped)
    end
end)
