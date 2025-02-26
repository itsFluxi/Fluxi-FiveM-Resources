-- Notifications

function showNotification(message, colour, flash, saveToBrief)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(colour)
    EndTextCommandThefeedPostTicker(flash, saveToBrief)

end

---@diagnostic disable-next-line: missing-parameter
RegisterCommand("testNotification", function(_, _, rawCommand)
    showNotification(
        rawCommand,
        150,
        false,
        false
    )
end)



-- Advanced Notifications

function showAdvancedNotification(message, sender, subject, textureDict, iconType, colour, saveToBrief)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    ThefeedSetNextPostBackgroundColor(colour)
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
    EndTextCommandThefeedPostTicker(false, saveToBrief)

end

---@diagnostic disable-next-line: missing-parameter
RegisterCommand("testAdvancedNotification", function(_, _, rawCommand)
    showAdvancedNotification(
        rawCommand,
        "This is Sender",
        "This is Subject",
        "CHAR_AMMUNATION",
        8,
        150,
        false
    )
end)


-- Alerts
function showAlert(message, beep, duration)
    AddTextEntry("CH_ALERT", message)
    
    BeginTextCommandDisplayHelp("CH_ALERT")
    EndTextCommandDisplayHelp(0, false, beep, duration)
end

---@diagnostic disable-next-line: missing-parameter
RegisterCommand("testAlert", function(_, _, rawCommand)
    showAlert(
        rawCommand,
        true,
        -1
    )
end)



-- Markers
---@diagnostic disable-next-line: missing-parameter
RegisterCommand("testMarker", function()
    CreateThread(function()
        local start = GetGameTimer()

        while GetGameTimer() < (start + 10000) do
        Wait(0)
            local playerCoordinates = GetEntityCoords(PlayerPedId())
---@diagnostic disable-next-line: missing-parameter
    DrawMarker(
        6,
        playerCoordinates.x,
        playerCoordinates.y,
        playerCoordinates.z,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0,
        110,
        60,
        180,
        true,
        true,
        2
        )
        end
    end)
end)



-- Subtitles
function showSubtitle(message, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

RegisterCommand("testSubtitle", function(_, _, rawCommand)
        showSubtitle(
            rawCommand,
            10000
        )
end)

-- Busy Spinners

function showBusySpinner(message)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandBusyspinnerOn(5)    
end

function hideBusySpinner()
    BusyspinnerOff()
    
end

RegisterCommand("testBusySpinner", function(_, _, rawCommand)
    if rawCommand == "testBusySpinner" then
        hideBusySpinner()
    else
        showBusySpinner(rawCommand)
    end
end)

-- Text Input
function getTextInput(title, inputLength)
    AddTextEntry("CH_INPUT", title)
    DisplayOnscreenKeyboard(1, "CH_INPUT", " ", " ", " ", " ", " ", inputLength)

    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0)
    end
    
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()

        Citizen.Wait(0)

        return result
    else
        Citizen.Wait(0)

        return nil
    end
end

RegisterCommand("testInput", function(_, _, rawCommand)
    local result = getTextInput(rawCommand, 63)

    showNotification(result, 180, false, false)
end)