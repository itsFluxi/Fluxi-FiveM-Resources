RegisterCommand('dv', function(source, args)
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    if playerVehicle ~= 0 then
        -- Player is in a vehicle, delete the current vehicle
        SetEntityAsMissionEntity(playerVehicle, true, true)
        DeleteVehicle(playerVehicle)
    end
end)