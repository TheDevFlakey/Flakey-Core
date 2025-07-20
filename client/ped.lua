function ApplyFullPedData(data)
    local model = data.model

    -- Convert string to hash if needed
    if type(model) == "string" then
        model = GetHashKey(model)
    end

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    -- Set model and reset ped
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    local ped = PlayerPedId()

    -- Prevent invisible ped by resetting variations
    SetPedDefaultComponentVariation(ped)

    -- Apply components (clothes)
    for k, v in pairs(data.components or {}) do
        SetPedComponentVariation(ped, tonumber(k), v.drawable, v.texture, v.palette or 2)
    end

    -- Apply props (hats, glasses, etc.)
    for k, v in pairs(data.props or {}) do
        ClearPedProp(ped, tonumber(k))
        SetPedPropIndex(ped, tonumber(k), v.prop, v.texture, true)
    end

    if not data.components or next(data.components) == nil then
        -- Apply default outfit
        SetPedComponentVariation(ped, 0, 0, 0, 2)
        SetPedComponentVariation(ped, 3, 15, 0, 2)
        SetPedComponentVariation(ped, 4, 14, 0, 2)
        SetPedComponentVariation(ped, 6, 34, 0, 2)
        SetPedComponentVariation(ped, 8, 15, 0, 2)
    end
end

-- Called by server when loading ped
RegisterNetEvent("flakeyCore:loadPedData", function(data)
    if data then ApplyFullPedData(data) end
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, true)
    SetEntityInvincible(playerPed, false)
    FreezeEntityPosition(playerPed, false)
end)
