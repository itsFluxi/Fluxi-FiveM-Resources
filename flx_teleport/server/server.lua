RegisterNetEvent('flx_teleport:goto', function (targetId)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local targetPed = GetPlayerPed(targetId)

    if targetPed <= 0 then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'sorry ' .. targetId .. ' does not seem to be online.',},
        })

        return
    end

    local targetPos = GetEntityCoords(targetPed)

    SetEntityCoords(playerPed, targetPos)
end)

RegisterNetEvent('flx_teleport:summon', function (targetId)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local playerPos = GetEntityCoords(playerPed)
    local targetPed = GetPlayerPed(targetId)

    if targetPed <= 0 then
        TriggerClientEvent('chat:addMessage', playerId, {
            args = {'sorry ' .. targetId .. ' does not seem to be online.',},
        })

        return
    end

    SetEntityCoords(targetPed, playerPos)
end)