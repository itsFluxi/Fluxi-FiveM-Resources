-- Turn on fuel consumption
SetFuelConsumptionState(true)

-- Set global fuel consumption rate multiplier to 2x the standard
local globalFuelConsumptionRateMultiplier = 2.0
SetFuelConsumptionRateMultiplier(globalFuelConsumptionRateMultiplier)

-- Main loop to handle fuel consumption
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Check every second

        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            -- Check if the vehicle uses fuel
            if DoesVehicleUseFuel(vehicle) then
                -- Get current RPM and time step
                local rpm = GetVehicleCurrentRpm(vehicle)
                local timeStep = GetFrameTime()

                -- Get vehicle-specific fuel consumption rate multiplier
                local vehicleFuelConsumptionRateMultiplier = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolConsumptionRate")

                -- Calculate fuel consumption
                local fuelConsumption = timeStep * rpm * vehicleFuelConsumptionRateMultiplier * globalFuelConsumptionRateMultiplier

                -- Get current fuel level
                local currentFuelLevel = GetVehicleFuelLevel(vehicle)

                -- Decrease fuel level based on consumption
                local newFuelLevel = currentFuelLevel - fuelConsumption

                -- Ensure fuel level doesn't go below 0
                if newFuelLevel < 0 then
                    newFuelLevel = 0
                    -- Optionally, you can stop the vehicle if fuel is 0
                    SetVehicleEngineOn(vehicle, false, true, true)
                end

                -- Set new fuel level
                SetVehicleFuelLevel(vehicle, newFuelLevel)
            end
        end
    end
end)
