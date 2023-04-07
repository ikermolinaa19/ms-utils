local vehicleDensityMultiplier = 0.5
local pedDensityMultiplier = 0.5
local disableCops = true
local disableDispatch = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- These natives have to be called every frame.
        SetVehicleDensityMultiplierThisFrame(vehicleDensityMultiplier) -- set traffic density to 0 
        SetRandomVehicleDensityMultiplierThisFrame(vehicleDensityMultiplier) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
        SetParkedVehicleDensityMultiplierThisFrame(vehicleDensityMultiplier) -- set random parked vehicles (parked car scenarios) to 0
        SetPedDensityMultiplierThisFrame(pedDensityMultiplier) -- set npc/ai peds density to 0
        SetScenarioPedDensityMultiplierThisFrame(pedDensityMultiplier, pedDensityMultiplier) -- set random npc/ai peds or scenario peds to 0
        if disableDispatch then
            for i = 1, 12 do
                EnableDispatchService(i, false)
            end
        end
        if disableCops then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
            SetCreateRandomCops(false) -- disable random cops walking/driving around.
            SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
            SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
        end
        if vehicleDensityMultiplier == 0 then
            SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
            SetRandomBoats(false) -- Stop random boats from spawning in the water.
            local playerPed = PlayerPedId()
            local x,y,z = GetEntityCoords(playerPed)
            ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
        end
    end
end)
