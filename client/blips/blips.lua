CreateThread(function()
    for _, blip in pairs(Blips) do
        local b = AddBlipForCoord(blip.coords)

        SetBlipSprite(b, blip.sprite)
        SetBlipDisplay(b, 4)
        SetBlipScale(b, blip.scale)
        SetBlipColour(b, blip.color)
        SetBlipAsShortRange(b, blip.shortRange)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blip.label)
        EndTextCommandSetBlipName(b)
    end
end)
