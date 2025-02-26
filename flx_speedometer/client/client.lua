-- Configuration table for UI customization
local uiConfig = {
    speed = { x = 0.9, y = 0.8, scale = 0.5, color = { r = 255, g = 255, b = 255, a = 255 } },
    gear = { x = 0.9, y = 0.85, scale = 0.5, color = { r = 255, g = 255, b = 255, a = 255 } },
    rpm = { x = 0.9, y = 0.9, scale = 0.5, color = { r = 255, g = 255, b = 255, a = 255 } },
    fuel = { x = 0.9, y = 0.95, scale = 0.5, color = { r = 255, g = 255, b = 255, a = 255 } },
    engineHealthIcon = { x = 0.85, y = 0.75, scale = 0.03, color = { r = 255, g = 0, b = 0, a = 255 } },
    headlightsIcon = { x = 0.85, y = 0.8, scale = 0.03, color = { r = 255, g = 255, b = 255, a = 255 } },
    seatbeltIcon = { x = 0.85, y = 0.85, scale = 0.03, color = { r = 255, g = 255, b = 0, a = 255 } }
}

function text(content, x, y, scale, color)
    SetTextFont(1)
    SetTextProportional(true)
    SetTextScale(scale, scale)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(x, y)
end

function drawIcon(dict, icon, x, y, scale, color)
    while not HasStreamedTextureDictLoaded(dict) do
        Wait(0)
    end
    DrawSprite(dict, icon, x, y, scale, scale, 0.0, color.r, color.g, color.b, color.a)
end

CreateThread(function()
    while true do
        Wait(0)

        local playerId = PlayerPedId()
        local playerVehicle = GetVehiclePedIsIn(playerId, false)

        if playerVehicle ~= 0 then
            if GetPedInVehicleSeat(playerVehicle, -1) == playerId then
                -- Speed in mph
                local speed = GetEntitySpeed(playerVehicle) * 2.2369
                text("Speed: " .. math.floor(speed), uiConfig.speed.x, uiConfig.speed.y, uiConfig.speed.scale, uiConfig.speed.color)
        
                -- Current gear
                local gear = GetVehicleCurrentGear(playerVehicle)
                text("Gear: " .. gear, uiConfig.gear.x, uiConfig.gear.y, uiConfig.gear.scale, uiConfig.gear.color)
        
                -- Engine revs
                local rpm = GetVehicleCurrentRpm(playerVehicle) * 100
                text("RPM: " .. math.floor(rpm), uiConfig.rpm.x, uiConfig.rpm.y, uiConfig.rpm.scale, uiConfig.rpm.color)
        
                -- Vehicle health
                local engineHealth = GetVehicleEngineHealth(playerVehicle)
                if engineHealth <= 250 then
                    drawIcon("commonmenu", "shop_box_blankb", uiConfig.engineHealthIcon.x, uiConfig.engineHealthIcon.y, uiConfig.engineHealthIcon.scale, uiConfig.engineHealthIcon.color)
                end

                -- Get current fuel level and max fuel capacity
            local currentFuelLevel = GetVehicleFuelLevel(playerVehicle)
            local maxFuelLevel = GetVehicleHandlingFloat(playerVehicle, "CHandlingData", "fPetrolTankVolume")
            if maxFuelLevel <= 0 then
                maxFuelLevel = 65.0 -- Default to 65 liters if not set
            end

            -- Calculate fuel percentage
            local fuelPercentage = (currentFuelLevel / maxFuelLevel) * 100

            -- Display fuel percentage
            text(string.format("Fuel: %.1f%%", fuelPercentage), uiConfig.fuel.x, uiConfig.fuel.y, uiConfig.fuel.scale, uiConfig.fuel.color)
            end
        end
    end
end)