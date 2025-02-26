-- List of fuel pump prop hashes
local fuelPumps = {
    1339433404, -- prop_gas_pump_1a
    1694452750, -- prop_gas_pump_1b
    1933174915, -- prop_gas_pump_1c
    2287735495, -- prop_gas_pump_1d
    -462817101, -- prop_vintage_pump
    -- Add more fuel pump hashes as needed
}

-- Function to check if player is near a fuel pump
function isNearFuelPump()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for _, pumpHash in ipairs(fuelPumps) do
        local pump = GetClosestObjectOfType(playerCoords, 2.0, pumpHash, false, false, false)
        if DoesEntityExist(pump) then
            return true, pump
        end
    end
    return false, nil
end

-- Function to check if player is near their vehicle
function isNearVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerCoords, 3.0, 0, 71) -- 71 is the flag for cars
    if DoesEntityExist(vehicle) then
        return true, vehicle
    end
    return false, nil
end

-- Function to display notification
function showNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Function to refuel the vehicle
function refuelVehicle(vehicle)
    local playerPed = PlayerPedId()
    local currentFuelLevel = GetVehicleFuelLevel(vehicle)
    local maxFuelLevel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
    local refuelTime = 30000 -- 30 seconds to refuel from empty to full

    -- Calculate the percentage of the tank that is empty
    local emptyPercentage = (maxFuelLevel - currentFuelLevel) / maxFuelLevel

    -- Adjust refuelTime based on the empty percentage
    local adjustedRefuelTime = refuelTime * emptyPercentage

    -- Ensure a minimum refuel time of 5 seconds
    local minimumRefuelTime = 5000
    adjustedRefuelTime = math.max(adjustedRefuelTime, minimumRefuelTime)

    -- Load animation dictionary
    function LoadAnimDict(dict)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end

    -- Play pumping gas animation
    LoadAnimDict("missfam4")
    TaskPlayAnim(playerPed, "missfam4", "base", 2.0, 8.0, -1, 50, 0, false, false, false)
 
    -- Create and attach gas pump prop
    local propHash = GetHashKey("prop_cs_fuel_nozle")
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Citizen.Wait(0)
    end
    local prop = CreateObject(propHash, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.1, 0.0, 0.0, 30.0, 90.0, 180.0, true, true, false, true, 1, true)

    local startTime = GetGameTimer()

    while GetGameTimer() - startTime < adjustedRefuelTime do
        Citizen.Wait(0) -- Check every frame for more immediate updates
        local elapsedTime = GetGameTimer() - startTime
        local newFuelLevel = currentFuelLevel + ((elapsedTime / adjustedRefuelTime) * (maxFuelLevel - currentFuelLevel))
        SetVehicleFuelLevel(vehicle, newFuelLevel)
    end

    SetVehicleFuelLevel(vehicle, maxFuelLevel)
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

    -- Stop animation and remove prop
    ClearPedTasks(playerPed)
    DeleteObject(prop)
end

-- Main loop to handle refueling
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Check every frame

        local playerPed = PlayerPedId()
        local isNearPump, pump = isNearFuelPump()
        local isNearVeh, vehicle = isNearVehicle()

        if isNearPump and isNearVeh then
            showNotification("Press E to refuel your vehicle")

            if IsControlJustPressed(0, 38) then -- E key
                refuelVehicle(vehicle)
            end
        end
    end
end)