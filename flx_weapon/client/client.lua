---@diagnostic disable-next-line: missing-parameter
RegisterCommand('weapon', function(source, args)
    local weaponName = args[1] or 'pistol'
    local weaponAmmo = args[2] or 999

    if not IsWeaponValid(weaponName) then
        TriggerEvent('chat:addMessage', {
            args = {'oh, ' .. weaponName .. ' is not a valid weapon'}
        })

        return
    end

    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, weaponName, weaponAmmo, false, true)

end)