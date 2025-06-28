SupressedVehicles = {
	[`pbus`] = true,
	[`polmav`] = true,
    [`firetruk`] = true,
    [`ambulance`] = true,
    [`taco`] = true,
    [`policeb`] = true,
    [`akula`] = true,
    [`annihilator`] = true,
    [`buzzard`] = true,
    [`buzzard2`] = true,
    [`cargobob`] = true,
    [`cargobob2`] = true,
    [`cargobob3`] = true,
    [`cargobob4`] = true,
    [`frogger`] = true,
    [`frogger2`] = true,
    [`havok`] = true,
    [`hunter`] = true,
    [`maverick`] = true,
    [`savage`] = true,
    [`seasparrow`] = true,
    [`skylift`] = true,
    [`supervolito`] = true,
    [`supervolito2`] = true,
    [`swift`] = true,
    [`swift2`] = true,
    [`valkyrie`] = true,
    [`valkyrie2`] = true,
    [`volatus`] = true,
    [`annihilator2`] = true,
    [`seasparrow2`] = true,
    [`seasparrow3`] = true,
    [`alphaz1`] = true,
    [`avenger`] = true,
    [`avenger2`] = true,
    [`besra`] = true,
    [`blimp`] = true,
    [`blimp2`] = true,
    [`blimp3`] = true,
    [`bombushka`] = true,
    [`cargoplane`] = true,
    [`cuban800`] = true,
    [`dodo`] = true,
    [`duster`] = true,
    [`howard`] = true,
    [`hydra`] = true,
    [`jet`] = true,
    [`lazer`] = true,
    [`luxor`] = true,
    [`luxor2`] = true,
    [`mammatus`] = true,
    [`microlight`] = true,
    [`miljet`] = true,
    [`mogul`] = true,
    [`molotok`] = true,
    [`nimbus`] = true,
    [`nokotoa`] = true,
    [`pyro`] = true,
    [`rogue`] = true,
    [`seabreeze`] = true,
    [`shamal`] = true,
    [`starling`] = true,
    [`strikeforce`] = true,
    [`stunt`] = true,
    [`titan`] = true,
    [`tula`] = true,
    [`velum`] = true,
    [`velum2`] = true,
    [`vestra`] = true,
    [`volatol`] = true,
    [`alkonost`] = true
}

SupressedScenarioTypes = {
    "WORLD_VEHICLE_AMBULANCE",
    "WORLD_VEHICLE_FIRE_TRUCK",
    "WORLD_VEHICLE_POLICE_BIKE",
    "WORLD_VEHICLE_POLICE_CAR",
    "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
    "CODE_HUMAN_POLICE_CROWD_CONTROL",
    "CODE_HUMAN_POLICE_INVESTIGATE",
    "WORLD_VEHICLE_MILITARY_PLANES_SMALL", -- Zancudo Small Planes
    "WORLD_VEHICLE_MILITARY_PLANES_BIG", -- Zancudo Big Planes
}

SupressedScenarioGroups = {
    "ALAMO_PLANES",
    "BLIMP",
    "Grapeseed_Planes",
    "LSA_Planes",
    "Sandy_Planes",
    "ng_planes"
}

local SetVehicleDensityMultiplierThisFrame = SetVehicleDensityMultiplierThisFrame
local SetRandomVehicleDensityMultiplierThisFrame = SetRandomVehicleDensityMultiplierThisFrame
local SetParkedVehicleDensityMultiplierThisFrame = SetParkedVehicleDensityMultiplierThisFrame
local SetScenarioPedDensityMultiplierThisFrame = SetScenarioPedDensityMultiplierThisFrame
local SetPedDensityMultiplierThisFrame = SetPedDensityMultiplierThisFrame

CreateThread(function()

    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)

    SetRandomTrains(false)
    SetRandomBoats(true)
    SetGarbageTrucks(false)
    SetMaxWantedLevel(0)
    for dispatchService=1, 15 do EnableDispatchService(dispatchService, false) end

    RemoveVehiclesFromGeneratorsInArea(335.2616 - 300.0, -1432.455 - 300.0, 46.51 - 300.0, 335.2616 + 300.0, -1432.455 + 300.0, 46.51 + 300.0) -- central los santos medical center
    RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0) -- police station mission row
    RemoveVehiclesFromGeneratorsInArea(316.79 - 300.0, -592.36 - 300.0, 43.28 - 300.0, 316.79 + 300.0, -592.36 + 300.0, 43.28 + 300.0) -- pillbox
    RemoveVehiclesFromGeneratorsInArea(-2150.44 - 500.0, 3075.99 - 500.0, 32.8 - 500.0, -2150.44 + 500.0, -3075.99 + 500.0, 32.8 + 500.0) -- military
    RemoveVehiclesFromGeneratorsInArea(-1108.35 - 300.0, 4920.64 - 300.0, 217.2 - 300.0, -1108.35 + 300.0, 4920.64 + 300.0, 217.2 + 300.0) -- nudist
    RemoveVehiclesFromGeneratorsInArea(-458.24 - 300.0, 6019.81 - 300.0, 31.34 - 300.0, -458.24 + 300.0, 6019.81 + 300.0, 31.34 + 300.0) -- police station paleto
    RemoveVehiclesFromGeneratorsInArea(1854.82 - 300.0, 3679.4 - 300.0, 33.82 - 300.0, 1854.82 + 300.0, 3679.4 + 300.0, 33.82 + 300.0) -- police station sandy
    RemoveVehiclesFromGeneratorsInArea(-724.46 - 300.0, -1444.03 - 300.0, 5.0 - 300.0, -724.46 + 300.0, -1444.03 + 300.0, 5.0 + 300.0) -- REMOVE CHOPPERS WOW

    while true do
        Wait(0)

        local vehicleDensity = 0.7
        SetVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(vehicleDensity)

        local pedDensity = 0.8
        SetScenarioPedDensityMultiplierThisFrame(vehicleDensity, vehicleDensity)
        SetPedDensityMultiplierThisFrame(pedDensity)
    end
end)

CreateThread(function()
	while true do
		for model in pairs(SupressedVehicles) do
            SetVehicleModelIsSuppressed(model, true)
        end
        for i=1, #SupressedScenarioTypes do
            SetScenarioTypeEnabled(SupressedScenarioTypes[i], false)
        end
        for i=1, #SupressedScenarioGroups do
            SetScenarioGroupEnabled(SupressedScenarioGroups[i], false)
        end
		Wait(10000)
	end
end)