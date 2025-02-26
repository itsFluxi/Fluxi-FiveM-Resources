-- command to go to another player
RegisterCommand('goto', function(_, args)
    local targetId = args[1]

    if not targetId then
        TriggerEvent('chat:addMessage', {
            args = {'Target ID required', },
        })

        return
    end

    
end)


-- command to bring a player to us
RegisterCommand('summon', function(_, args)
    local targetId = args[1]

    if not targetId then
        TriggerEvent('chat:addMessage', {
            args = {'Target ID required', },
        })

        return
    end

end)

-- event to teleport to a location
RegisterNetEvent('flx_teleport:teleport', function (targetCoordinates)
    local playerPed = PlayerPedId()

    SetEntityCoords(playerPed, targetCoordinates)
    
end)