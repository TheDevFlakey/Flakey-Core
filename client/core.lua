local playerData = {}

exports.spawnmanager:setAutoSpawn(false)
exports.spawnmanager:spawnPlayer({
    x = -270.0,
    y = -957.0,
    z = 31.2,
    heading = 250.0,
    model = `mp_m_freemode_01`
}, function()
    TriggerServerEvent("flakeyCore:playerJoined")
end)

RegisterNetEvent("flakeyCore:loadPlayer", function(data)
    local ped = PlayerPedId()

    -- TELEPORT HERE
    if data.position then
        SetEntityCoords(ped, data.position.x, data.position.y, data.position.z, false, false, false, false)
    end

    SetEntityHealth(ped, data.health or 200)

    playerData.hunger = data.hunger or 100
    playerData.thirst = data.thirst or 100
    LocalPlayer.state:set("hunger", playerData.hunger, true)
    LocalPlayer.state:set("thirst", playerData.thirst, true)    

    TriggerEvent("flakeyCore:updateMoneyUI", data.cash, data.bank)
end)

RegisterNetEvent("flakeyCore:updateMoneyUI", function(cash, bank)
    print("Cash: $" .. cash .. " | Bank: $" .. bank)
end)

Citizen.CreateThread(function()
    while true do
        Wait(20000) -- every 20 seconds
        local coords = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())

        TriggerServerEvent("flakeyCore:updateLastKnownPosition", {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = heading
        })
    end
end)

RegisterNetEvent("flakeyCore:spawnPlayer", function(position)
    local ped = PlayerPedId()
    SetEntityCoords(ped, position.x, position.y, position.z, false, false, false, false)
end)

RegisterCommand("logout", function(source, args, rawCommand)
    TriggerServerEvent("flakeyCore:logout", GetEntityCoords(PlayerPedId()))
end, false)
