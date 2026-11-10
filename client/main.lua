local isWheelOpen = false

local function openWheel()
    if isWheelOpen or IsPauseMenuActive() then return end

    local playerItems = exports.ox_inventory:GetPlayerItems()
    local slotsData = {}

    for i = 1, 5 do
        local foundItem = nil
        if playerItems then
            for _, item in pairs(playerItems) do
                if item and item.slot == i then
                    local ammoText = nil
                    if item.metadata and item.metadata.ammo then
                        ammoText = tostring(item.metadata.ammo)
                    end

                    foundItem = {
                        slot = item.slot,
                        name = item.name,
                        label = item.label,
                        count = item.count,
                        ammo = ammoText
                    }
                    break
                end
            end
        end
        slotsData[i] = foundItem
    end

    isWheelOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)

    SendNUIMessage({
        action = 'openWheel',
        items = slotsData,
        theme = {
            primaryColor = Config.PrimaryColor,
            primaryColorGlow = Config.PrimaryColorGlow,
            slotBg = Config.SlotBackgroundColor,
            slotBgHover = Config.SlotBackgroundColorHover,
            border = Config.BorderColor
        }
    })

    CreateThread(function()
        while isWheelOpen do
            Wait(0)

            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)

            if not IsDisabledControlPressed(0, 37) and not IsControlPressed(0, 37) then
                SendNUIMessage({
                    action = 'requestClose'
                })
                break
            end
        end
    end)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isWheelOpen = false
    cb('ok')

    if not data or not data.selected then return end

    if data.selected.type == 'unarmed' then
        TriggerEvent('ox_inventory:disarm')
    elseif data.selected.type == 'item' and data.selected.slot then
        exports.ox_inventory:useSlot(data.selected.slot)
    end
end)

RegisterCommand('+openItemWheel', function()
    openWheel()
end, false)

RegisterCommand('-openItemWheel', function()
end, false)

RegisterKeyMapping('+openItemWheel', 'Ouvrir la roue d\'items', 'keyboard', 'TAB')
