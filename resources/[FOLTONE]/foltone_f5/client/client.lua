local timout = false
local function setTimeout(time)
    timout = true
    SetTimeout(time, function()
        timout = false
    end)
end
local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
local function confirmation()
    local result = KeyboardInput(_U("confirmation"), "", 10)
    if result then
        if string.lower(result) == string.lower(_U("valid_confirmation")) then
            return true
        else
            return false
        end
    else
        return false
    end
end
local function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = -1
    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            distance = #(playerCoords - targetCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = player
                closestDistance = distance
            end
            if closestPlayer ~= -1 then
                if distance <= 3.0 then
                    DrawMarker(2, targetCoords.x, targetCoords.y, targetCoords.z + 1, 0, 0, 0, 0, 180.0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 155, false, true, 2, false, false, true, false)
                end
            end
        end
    end
    return closestPlayer, targetCoords, distance
end
local function playAnimation(lib, anim)
    RequestAnimDict(lib)
    while not HasAnimDictLoaded(lib) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
    Wait(1500)
    ClearPedTasks(PlayerPedId())
end

local FoltonePersonalMenu = {
    countIndexItemList = {},
    itemSelected = nil,
    ammoIndexWeaponList = {},
    weaponSelected = nil,
    listMoneyOptionIndex = 1,
    listMoneyOption = {
        _U("give_money"),
        _U("drop_money")
    },
    listPaperOptionIndex = 1,
    listPaperOption = {
        _U("look_paper"),
        _U("show_paper")
    },

    listClothingIndex = 1,
    listClothing = {
        _U("top"),
        _U("bulletproof"),
        _U("harms"),
        _U("pants"),
        _U("shoes"),
    },
    listAccessoriesIndex = 1,
    listAccessories = {
        _U("glasses"),
        _U("mask"),
        _U("ears"),
        _U("helmet"),
        _U("bag"),
        _U("bracelet"),
        _U("watch"),
        _U("chain"),
    },

    doorsListName = {
        _U("front_left_door"),
        _U("front_right_door"),
        _U("back_left_door"),
        _U("back_right_door"),
        _U("hood"),
        _U("trunk")
    },
    doorsList = {},
    indexdoorsList = 1,
    windowsListName = {
        _U("front_left_window"),
        _U("front_right_window"),
        _U("back_left_window"),
        _U("back_right_window")
    },
    indexwindowsList = 1,
    windowsList = {},

    speedLimiterEnabled = false,
    speedLimitIndex = 1,
    speedLimitList = {
        "30",
        "50",
        "70",
        "80",
        "90",
        "110",
        "130",
        "150"
    },
    keySelected = nil,
    listVoiceOptionIndex = 1,
    listVoiceOption = {
        _U("voice_whisper"),
        _U("voice_normal"),
        _U("voice_cry")
    }
}
local function getVehicleDoorsList(vehicle)
    FoltonePersonalMenu.doorsList = {}
    for i=0, 6 do
        if GetVehicleDoorAngleRatio(vehicle, i) then
            table.insert(FoltonePersonalMenu.doorsList, i)
        end
    end
end
local function getVehicleWindowsList(vehicle)
    FoltonePersonalMenu.windowsList = {}
    for i=0, 3 do
        if IsVehicleWindowIntact(vehicle, i) then
            table.insert(FoltonePersonalMenu.windowsList, i)
        end
    end
end
local function engineStatus(vehicle)
    if GetIsVehicleEngineRunning(vehicle) then
        return _U("vehicle_engine_on")
    else
        return _U("vehicle_engine_off")
    end
end
local function speedLimiterStatus()
    if FoltonePersonalMenu.speedLimiterEnabled then
        return _U("enabled")
    else
        return _U("disabled")
    end
end

local function getAmmoType(weapon)
    local weapon = GetHashKey(weapon)
    local type = GetWeapontypeGroup(weapon)
    if type == 416676503 then
        return "AMMO_PISTOL"
    elseif type == 3337201093 or type == -957766203 then
        return "AMMO_SMG"
    elseif type == 860033945 then
        return "AMMO_SHOTGUN"
    elseif type == 970310034 then
        return "AMMO_RIFLE"
    elseif type == 1159398588 then
        return "AMMO_MG"
    elseif type == 3082541095 or type == -1212426201 then
        return "AMMO_SNIPER"
    elseif type == 2725924767 then
        return "AMMO_FIREWORK"
    else
        return false
    end
end

Config.CallESX()

local playerLoaded = false
local playerData = {}

local function updateInventory()
    ESX.TriggerServerCallback("foltone_f5:getPlayerInventory", function(data)
        playerData.inventory = data.inventory
        playerData.weight = data.weight
    end)
end
local function updateLoadout()
    ESX.TriggerServerCallback("foltone_f5:getPlayerLoadout", function(data)
        playerData.loadout = data
    end)
end
local function updateMoney()
    ESX.TriggerServerCallback("foltone_f5:getPlayerMoney", function(data)
        playerData.money = data.money
        playerData.bank = data.bank
        playerData.black_money = data.black_money
    end)
end
local function updateLicenses()
    ESX.TriggerServerCallback("esx_license:getLicenses", function(licenses)
        playerData.licenses = licenses
    end, GetPlayerServerId(PlayerId()))
end
local function updateBills()
    ESX.TriggerServerCallback("esx_billing:getBills", function(bills)
        playerData.bills = bills
    end)
end
local function updateSocyetMoney()
    ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
        playerData.societyMoney = money
    end, playerData.job_name)
end
local function updateSocyetMoney2()
    ESX.TriggerServerCallback("esx_society:getSocietyMoney", function(money)
        playerData.societyMoney2 = money
    end, playerData.job2_name)
end
local function updateKeys()
    ESX.TriggerServerCallback("foltone_vehiclelock:getMyKeys", function(data)
        playerData.keys = data
    end)
end

local personalMenu = RageUI.CreateMenu(_U("title_f5_menu"), _U("subtitle_f5_menu"));
local inventoryMenu = RageUI.CreateSubMenu(personalMenu, _U("title_inventory_menu"), _U("subtitle_inventory_menu"));
local optionItem = RageUI.CreateSubMenu(inventoryMenu, _U("title_option_menu"), _U("subtitle_option_menu"));
local loadoutMenu = RageUI.CreateSubMenu(personalMenu, _U("title_loadout_menu"), _U("subtitle_loadout_menu"));
local optionWeapon = RageUI.CreateSubMenu(loadoutMenu, _U("title_option_menu"), _U("subtitle_option_menu"));
local walletMenu = RageUI.CreateSubMenu(personalMenu, _U("title_wallet_menu"), _U("subtitle_wallet_menu"));
local billMenu = RageUI.CreateSubMenu(personalMenu, _U("title_bill_menu"), _U("subtitle_bill_menu"));
local societyMenu = RageUI.CreateSubMenu(personalMenu, _U("title_job_menu"), _U("subtitle_job_menu"));
local organizationMenu = RageUI.CreateSubMenu(personalMenu, _U("title_job2_menu"), _U("subtitle_job2_menu"));
local clothingMenu = RageUI.CreateSubMenu(personalMenu, _U("title_clothing_menu"), _U("subtitle_clothing_menu"));
local vehicleMenu = RageUI.CreateSubMenu(personalMenu, _U("title_vehicle_menu"), _U("subtitle_vehicle_menu"));
local keysMenu = RageUI.CreateSubMenu(personalMenu, _U("title_keys_menu"), _U("subtitle_keys_menu"));
local keysOptionMenu = RageUI.CreateSubMenu(keysMenu, _U("title_option_menu"), _U("subtitle_option_menu"));
local open = false
function RageUI.PoolMenus:PersonalMenu()
    function personalMenu.Closed()
        open = false
    end
    personalMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_id", GetPlayerServerId(PlayerId())))
        Items:AddButton(_U("inventory"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            if onSelected then
                updateInventory()
            end
        end, inventoryMenu)
        Items:AddButton(_U("loadout"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            if onSelected then
                updateLoadout()
            end
        end, loadoutMenu)
        Items:AddButton(_U("wallet"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            if onSelected then
                updateMoney()
                updateLicenses()
            end
        end, walletMenu)
        Items:AddButton(_U("bill_button"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            if onSelected then
                updateBills()
            end
        end, billMenu)
        if playerData.job_name and playerData.grade_name == "boss" then
            Items:AddButton(_U("society"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
                if onSelected then
                    updateSocyetMoney()
                end
            end, societyMenu)
        else
            Items:AddButton(_U("society"), nil, { IsDisabled = true }, function(onSelected)
            end)
        end
        if Config.job2 then
            if playerData.job2_name and playerData.grade2_name == "boss" then
                Items:AddButton(_U("organization"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
                    if onSelected then
                        updateSocyetMoney2()
                    end
                end, organizationMenu)
            else
                Items:AddButton(_U("organization"), nil, { IsDisabled = true }, function(onSelected)
                end)
            end
        end
        Items:AddButton(_U("clothing"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
        end, clothingMenu)
        local playerDriving = IsPedInAnyVehicle(PlayerPedId(), false)
        if playerDriving then
            Items:AddButton(_U("vehicle"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            end, vehicleMenu)
        else
            Items:AddButton(_U("vehicle"), nil, { IsDisabled = true }, function(onSelected)
            end)
        end
        Items:AddButton(_U("keys"), nil, { RightLabel = ">>>", IsDisabled = false }, function(onSelected)
            if onSelected then
                updateKeys()
            end
        end, keysMenu)
        Items:AddList(_U("voice"), FoltonePersonalMenu.listVoiceOption, FoltonePersonalMenu.listVoiceOption[FoltonePersonalMenu.listVoiceOptionIndex], FoltonePersonalMenu.listVoiceOptionIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listVoiceOptionIndex = Index
            end
            if onSelected then
                if Index == 1 then
                    NetworkSetTalkerProximity(0.5)
                elseif Index == 2 then
                    NetworkSetTalkerProximity(10.0)
                elseif Index == 3 then
                    NetworkSetTalkerProximity(30.0)
                end
            end
        end)
    end, function(Panels)
    end)
    inventoryMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_inventory_weigth", playerData.weight))
        if playerData.inventory then
            for i = 1, #playerData.inventory, 1 do
                local countList = {}
                if playerData.inventory[i].count > 0 then
                    table.insert(FoltonePersonalMenu.countIndexItemList, 1)
                    for j = 1, playerData.inventory[i].count, 1 do
                        table.insert(countList, j)
                    end
                    Items:AddList(string.format("%s (%s)", playerData.inventory[i].label, playerData.inventory[i].count), countList, countList[FoltonePersonalMenu.countIndexItemList[i]], FoltonePersonalMenu.countIndexItemList[i], nil, {}, function(Index, onSelected, onListChange)
                        if onListChange then
                            FoltonePersonalMenu.countIndexItemList[i] = Index
                        end
                        if onSelected then
                            FoltonePersonalMenu.itemSelected = { name = playerData.inventory[i].name, label = playerData.inventory[i].label, count = Index }
                        end
                    end, optionItem)
                end
            end
        end
    end, function(Panels)
    end)
    optionItem:IsVisible(function(Items)
        Items:AddButton(_U("use"), nil, { IsDisabled = timout }, function(onSelected)
            if onSelected then
                setTimeout(500)
                TriggerServerEvent("esx:useItem", FoltonePersonalMenu.itemSelected.name)
                Wait(250)
                updateInventory()
            end
        end)
        Items:AddButton(_U("give"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_standard", FoltonePersonalMenu.itemSelected.name, FoltonePersonalMenu.itemSelected.count)
                        Wait(250)
                        updateInventory()
                        RageUI.GoBack()
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            end
        end)
        Items:AddButton(_U("drop"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if onSelected then
                setTimeout(500)
                TriggerServerEvent("esx:removeInventoryItem", "item_standard", FoltonePersonalMenu.itemSelected.name, FoltonePersonalMenu.itemSelected.count)
                Wait(250)
                updateInventory()
                RageUI.GoBack()
            end
        end)
        Items:AddButton(_U("destroy"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if onSelected then
                if confirmation() then
                    setTimeout(500)
                    TriggerServerEvent("foltone_f5:destroyItem", FoltonePersonalMenu.itemSelected.name)
                    Wait(250)
                    updateInventory()
                    RageUI.GoBack()
                end
            end
        end)
    end, function(Panels)
    end)

    loadoutMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_loadout"))
        if playerData.loadout then
            for i = 1, #playerData.loadout, 1 do
                local ammoList = {}
                if playerData.loadout[i].ammo then
                    table.insert(FoltonePersonalMenu.ammoIndexWeaponList, 1)
                    if playerData.loadout[i].ammo == 0 then
                        table.insert(ammoList, 0)
                    else
                        for j = 1, playerData.loadout[i].ammo, 1 do
                            table.insert(ammoList, j)
                        end
                    end
                    
                    Items:AddList(string.format("%s (%s)", playerData.loadout[i].label, playerData.loadout[i].ammo), ammoList, ammoList[FoltonePersonalMenu.ammoIndexWeaponList[i]], FoltonePersonalMenu.ammoIndexWeaponList[i], nil, {}, function(Index, onSelected, onListChange)
                        if onListChange then
                            FoltonePersonalMenu.ammoIndexWeaponList[i] = Index
                        end
                        if onSelected then
                            FoltonePersonalMenu.weaponSelected = { name = playerData.loadout[i].name, label = playerData.loadout[i].label, ammo = Index }
                        end
                    end, optionWeapon)
                end
            end
        end
    end, function(Panels)
    end)
    optionWeapon:IsVisible(function(Items)
        local ammoType = getAmmoType(FoltonePersonalMenu.weaponSelected.name)
        Items:AddButton(_U("give_weapon"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_weapon", FoltonePersonalMenu.weaponSelected.name, FoltonePersonalMenu.weaponSelected.count)
                        Wait(250)
                        updateLoadout()
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            end
        end)
        if ammoType then
            Items:AddButton(_U("give_ammo"), nil, { IsDisabled = timout }, function(onSelected)
                local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
                if onSelected then
                    if closestPlayer ~= -1 then
                        if distance <= 3.0 then
                            TriggerServerEvent("foltone_f5:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_ammo", ammoType, FoltonePersonalMenu.weaponSelected.ammo, FoltonePersonalMenu.weaponSelected.count)
                            Wait(250)
                            updateLoadout()
                        else
                            Config.Notification(_U("no_players_nearby"))
                        end
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end)
        end
        Items:AddButton(_U("drop_weapon"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if onSelected then
                setTimeout(500)
                TriggerServerEvent("esx:removeInventoryItem", "item_weapon", FoltonePersonalMenu.weaponSelected.name, FoltonePersonalMenu.weaponSelected.count)
                Wait(250)
                updateLoadout()
                RageUI.GoBack()
            end
        end)
        -- do not work need to fix es_extended
        -- if ammoType then
        --     Items:AddButton(_U("drop_ammo"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
        --         if onSelected then
        --             setTimeout(500)
        --             TriggerServerEvent("esx:removeInventoryItem", "item_ammo", ammoType, FoltonePersonalMenu.ammoIndexWeaponList[FoltonePersonalMenu.weaponSelected.name])
        --             Wait(250)
        --             updateLoadout()
        --         end
        --     end)
        -- end
        Items:AddButton(_U("destroy"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if onSelected then
                if confirmation() then
                    setTimeout(500)
                    TriggerServerEvent("foltone_f5:destroyWeapon", FoltonePersonalMenu.weaponSelected.name)
                    Wait(250)
                    updateLoadout()
                    RageUI.GoBack()
                end
            end
        end)
    end, function(Panels)
    end)

    walletMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_money"))
        Items:AddButton(_U("bank", playerData.bank), nil, { RightBadge = RageUI.BadgeStyle.Lock }, function(onSelected)
        end)
        Items:AddList(_U("money", playerData.money), FoltonePersonalMenu.listMoneyOption, FoltonePersonalMenu.listMoneyOption[FoltonePersonalMenu.listMoneyOptionIndex], FoltonePersonalMenu.listMoneyOptionIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listMoneyOptionIndex = Index
            end
            local closestPlayer, closestPlayerCoords, distance
            if FoltonePersonalMenu.listMoneyOptionIndex == 1 then
                closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            else
                closestPlayer = -1
            end
            if onSelected and FoltonePersonalMenu.listMoneyOptionIndex == 1 then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        local amount = KeyboardInput(_U("amount"), "", 10)
                        if amount then
                            local amount = tonumber(amount)
                            if amount then
                                TriggerServerEvent("foltone_f5:giveAccount", "money", GetPlayerServerId(closestPlayer), amount)
                                Wait(250)
                                updateMoney()
                            end
                        end
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            elseif onSelected and FoltonePersonalMenu.listMoneyOptionIndex == 2 then
                local amount = KeyboardInput(_U("amount"), "", 10)
                if amount then
                    local amount = tonumber(amount)
                    if amount then
                        TriggerServerEvent("esx:removeInventoryItem", "item_account", "money", amount)
                        Wait(250)
                        updateMoney()
                    end
                end
            end
        end)
        Items:AddList(_U("black_money", playerData.black_money), FoltonePersonalMenu.listMoneyOption, FoltonePersonalMenu.listMoneyOption[FoltonePersonalMenu.listMoneyOptionIndex], FoltonePersonalMenu.listMoneyOptionIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listMoneyOptionIndex = Index
            end
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected and FoltonePersonalMenu.listMoneyOptionIndex == 1 then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        local amount = KeyboardInput(_U("amount"), "", 10)
                        if amount then
                            local amount = tonumber(amount)
                            if amount then
                                TriggerServerEvent("foltone_f5:giveAccount", "black_money", GetPlayerServerId(closestPlayer), amount)
                                Wait(250)
                                updateMoney()
                            end
                        end
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            elseif onSelected and FoltonePersonalMenu.listMoneyOptionIndex == 2 then
                local amount = KeyboardInput(_U("amount"), "", 10)
                if amount then
                    local amount = tonumber(amount)
                    if amount then
                        TriggerServerEvent("esx:removeInventoryItem", "item_account", "black_money", amount)
                        Wait(250)
                        updateMoney()
                    end
                end
            end
        end)
        Items:AddSeparator(_U("your_paper"))
        Items:AddList(_U("id_card"), FoltonePersonalMenu.listPaperOption, FoltonePersonalMenu.listPaperOption[FoltonePersonalMenu.listPaperOptionIndex], FoltonePersonalMenu.listPaperOptionIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listPaperOptionIndex = Index
            end
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if Index == 1 then
                    TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                else
                    if closestPlayer ~= -1 then
                        if distance <= 3.0 then
                            TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(closestPlayer), GetPlayerServerId(PlayerId()))
                        else
                            Config.Notification(_U("no_players_nearby"))
                        end
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        if playerData.licenses then
            for i = 1, #playerData.licenses, 1 do
                Items:AddList(playerData.licenses[i].label, FoltonePersonalMenu.listPaperOption, FoltonePersonalMenu.listPaperOption[FoltonePersonalMenu.listPaperOptionIndex], FoltonePersonalMenu.listPaperOptionIndex, nil, {}, function(Index, onSelected, onListChange)
                    if onListChange then
                        FoltonePersonalMenu.listPaperOptionIndex = Index
                    end
                    local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
                    if onSelected then
                        if Index == 1 then
                            TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), playerData.licenses[i].type)
                        else
                            if closestPlayer ~= -1 then
                                if distance <= 3.0 then
                                    TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(closestPlayer), GetPlayerServerId(PlayerId()), playerData.licenses[i].type)
                                else
                                    Config.Notification(_U("no_players_nearby"))
                                end
                            else
                                Config.Notification(_U("no_players_nearby"))
                            end
                        end
                    end
                end)
            end
        end
    end, function(Panels)
    end)
    billMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_bills"))
        if playerData.bills then
            for i = 1, #playerData.bills, 1 do
                Items:AddButton(_U("bill", playerData.bills[i].label, playerData.bills[i].amount), nil, { IsDisabled = timout }, function(onSelected)
                    if onSelected then
                        setTimeout(500)
                        local amount = playerData.bills[i].amount
                        TriggerServerEvent("esx_billing:payBill", playerData.bills[i].id)
                        ESX.TriggerServerCallback("esx_billing:getBills", function(bills)
                            playerData.bills = bills
                        end)
                    end
                end)
            end
        end
    end, function(Panels)
    end)
    societyMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("boss_option", playerData.job_label))
        Items:AddButton(_U("society_money", playerData.societyMoney), nil, { IsDisabled = false }, function(onSelected)
        end)
        Items:AddButton(_U("recruit"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:recruit", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        Items:AddButton(_U("promote"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:promote", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        Items:AddButton(_U("demote"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:demote", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        Items:AddButton(_U("fire"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if closestPlayer ~= -1 then
                local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
                if onSelected then
                    if closestPlayer ~= -1 then
                        if distance <= 3.0 then
                            setTimeout(500)
                            TriggerServerEvent("foltone_f5:fire", GetPlayerServerId(closestPlayer))
                        else
                            Config.Notification(_U("no_players_nearby"))
                        end
                    end
                end
            end
        end)
    end, function(Panels)
    end)
    organizationMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("boss_option", playerData.job2_label))
        Items:AddButton(_U("society_money", playerData.societyMoney2), nil, { IsDisabled = false }, function(onSelected)
        end)
        Items:AddButton(_U("recruit"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:recruit2", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            end
        end)
        Items:AddButton(_U("promote"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:promote2", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        Items:AddButton(_U("demote"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:demote2", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
        Items:AddButton(_U("fire"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:fire2", GetPlayerServerId(closestPlayer))
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                end
            end
        end)
    end, function(Panels)
    end)
    clothingMenu:IsVisible(function(Items)
        local playerPed = PlayerPedId()
        Items:AddSeparator(_U("your_clothing"))
        Items:AddList(_U("put_remove_cothes"), FoltonePersonalMenu.listClothing, FoltonePersonalMenu.listClothing[FoltonePersonalMenu.listClothingIndex], FoltonePersonalMenu.listClothingIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listClothingIndex = Index
            end
            if onSelected then
                if FoltonePersonalMenu.listClothing[FoltonePersonalMenu.listClothingIndex] == _U("top") then
                    playAnimation("clothingtie", "try_tie_negative_a")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.torso_1 ~= skin2.torso_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["tshirt_1"] = skin1.tshirt_1, ["tshirt_2"] = skin1.tshirt_2, ["torso_1"] = skin1.torso_1, ["torso_2"] = skin1.torso_2, ["arms"] = skin1.arms});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["tshirt_1"] = Config.nakedSkin.tshirt_1, ["tshirt_2"] = Config.nakedSkin.tshirt_2, ["torso_1"] = Config.nakedSkin.torso_1, ["torso_2"] = Config.nakedSkin.torso_2, ["arms"] = Config.nakedSkin.arms});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listClothing[FoltonePersonalMenu.listClothingIndex] == _U("bulletproof") then
                    playAnimation("clothingtie", "try_tie_negative_a")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.bproof_1 ~= skin2.bproof_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bproof_1"] = skin1.bproof_1, ["bproof_2"] = skin1.bproof_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bproof_1"] = Config.nakedSkin.bproof_1, ["bproof_2"] = Config.nakedSkin.bproof_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listClothing[FoltonePersonalMenu.listClothingIndex] == _U("pants") then
                    playAnimation("random@domestic", "pickup_low")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.pants_1 ~= skin2.pants_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["pants_1"] = skin1.pants_1, ["pants_2"] = skin1.pants_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["pants_1"] = Config.nakedSkin.pants_1, ["pants_2"] = Config.nakedSkin.pants_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listClothing[FoltonePersonalMenu.listClothingIndex] == _U("shoes") then
                    playAnimation("random@domestic", "pickup_low")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.shoes_1 ~= skin2.shoes_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["shoes_1"] = skin1.shoes_1, ["shoes_2"] = skin1.shoes_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["shoes_1"] = Config.nakedSkin.shoes_1, ["shoes_2"] = Config.nakedSkin.shoes_2});
                            end
                        end)
                    end)
                end
            end
        end)
        Items:AddSeparator(_U("your_accessories"))
        Items:AddList(_U("put_remove_accessories"), FoltonePersonalMenu.listAccessories, FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex], FoltonePersonalMenu.listAccessoriesIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
                FoltonePersonalMenu.listAccessoriesIndex = Index
            end
            if onSelected then
                if FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("glasses") then
                    playAnimation("clothingspecs", "take_off")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.glasses_1 ~= skin2.glasses_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["glasses_1"] = skin1.glasses_1, ["glasses_2"] = skin1.glasses_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["glasses_1"] = Config.nakedSkin.glasses_1, ["glasses_2"] = Config.nakedSkin.glasses_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("mask") then
                    playAnimation("mp_masks@standard_car@ds@", "put_on_mask")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.mask_1 ~= skin2.mask_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["mask_1"] = skin1.mask_1, ["mask_2"] = skin1.mask_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["mask_1"] = Config.nakedSkin.mask_1, ["mask_2"] = Config.nakedSkin.mask_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("ears") then
                    playAnimation("mp_cp_stolen_tut", "b_think")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.ears_1 ~= skin2.ears_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["ears_1"] = skin1.ears_1, ["ears_2"] = skin1.ears_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["ears_1"] = Config.nakedSkin.ears_1, ["ears_2"] = Config.nakedSkin.ears_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("helmet") then
                    playAnimation("missheist_agency2ahelmet", "take_off_helmet_stand")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.helmet_1 ~= skin2.helmet_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["helmet_1"] = skin1.helmet_1, ["helmet_2"] = skin1.helmet_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["helmet_1"] = Config.nakedSkin.helmet_1, ["helmet_2"] = Config.nakedSkin.helmet_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("bag") then
                    playAnimation("clothingtie", "try_tie_negative_a")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.bags_1 ~= skin2.bags_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bags_1"] = skin1.bags_1, ["bags_2"] = skin1.bags_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bags_1"] = Config.nakedSkin.bags_1, ["bags_2"] = Config.nakedSkin.bags_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("bracelet") then
                    playAnimation("nmt_3_rcm-10", "cs_nigel_dual")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.bracelets_1 ~= skin2.bracelets_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bracelets_1"] = skin1.bracelets_1, ["bracelets_2"] = skin1.bracelets_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["bracelets_1"] = Config.nakedSkin.bracelets_1, ["bracelets_2"] = Config.nakedSkin.bracelets_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("watch") then
                    playAnimation("nmt_3_rcm-10", "cs_nigel_dual")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.watches_1 ~= skin2.watches_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["watches_1"] = skin1.watches_1, ["watches_2"] = skin1.watches_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["watches_1"] = Config.nakedSkin.watches_1, ["watches_2"] = Config.nakedSkin.watches_2});
                            end
                        end)
                    end)
                elseif FoltonePersonalMenu.listAccessories[FoltonePersonalMenu.listAccessoriesIndex] == _U("chain") then
                    playAnimation("clothingtie", "try_tie_negative_a")
                    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin1)
                        TriggerEvent("skinchanger:getSkin", function(skin2)
                            if skin1.chain_1 ~= skin2.chain_1 then
                                TriggerEvent("skinchanger:loadClothes", skin2, {["chain_1"] = skin1.chain_1, ["chain_2"] = skin1.chain_2});
                            else
                                TriggerEvent("skinchanger:loadClothes", skin2, {["chain_1"] = Config.nakedSkin.chain_1, ["chain_2"] = Config.nakedSkin.chain_2});
                            end
                        end)
                    end)
                end
            end
        end)
    end, function(Panels)
    end)
    vehicleMenu:IsVisible(function(Items)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local playerDriving = IsPedInAnyVehicle(playerPed, false)
        if vehicle ~= 0 and playerDriving then
            getVehicleDoorsList(vehicle)
            Items:AddList(_U("open_close_doors"), FoltonePersonalMenu.doorsListName, FoltonePersonalMenu.doorsListName[FoltonePersonalMenu.indexdoorsList], FoltonePersonalMenu.indexdoorsList,  nil, { IsDisabled = timeout }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    FoltonePersonalMenu.indexdoorsList = Index;
                end
                if onSelected then
                    if GetVehicleDoorAngleRatio(vehicle, FoltonePersonalMenu.indexdoorsList-1) > 0.0 then
                        SetVehicleDoorShut(vehicle, FoltonePersonalMenu.indexdoorsList-1, false)
                    else
                        SetVehicleDoorOpen(vehicle, FoltonePersonalMenu.indexdoorsList-1, false, false)
                    end
                end
            end)
            getVehicleWindowsList(vehicle)
            Items:AddList(_U("open_close_wondows"), FoltonePersonalMenu.windowsListName, FoltonePersonalMenu.windowsListName[FoltonePersonalMenu.indexwindowsList], FoltonePersonalMenu.indexwindowsList,  nil, { IsDisabled = timeout }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    FoltonePersonalMenu.indexwindowsList = Index;
                end
                if onSelected then
                    if IsVehicleWindowIntact(vehicle, FoltonePersonalMenu.indexwindowsList-1) then
                        RollDownWindow(vehicle, FoltonePersonalMenu.indexwindowsList-1)
                    else
                        RollUpWindow(vehicle, FoltonePersonalMenu.indexwindowsList-1)
                    end
                end
            end)
            Items:AddSeparator(_U("engine_options"))
            Items:AddButton(_U("engine_on_of"), nil, {RightLabel = engineStatus(vehicle), IsDisabled = false }, function(onSelected)
                if onSelected then
                    if GetIsVehicleEngineRunning(vehicle) then
                        SetVehicleEngineOn(vehicle, false, false, true)
                    else
                        SetVehicleEngineOn(vehicle, true, false, true)
                    end
                end
            end)
            Items:AddSeparator(_U("speed_options"))
            Items:AddButton(_U("disable_speed_limiter"), nil, {RightLabel = speedLimiterStatus(), IsDisabled = false }, function(onSelected)
                if onSelected and FoltonePersonalMenu.speedLimiterEnabled then
                    FoltonePersonalMenu.speedLimiterEnabled = false
                    SetEntityMaxSpeed(vehicle, 9999.0)
                end
            end)
            Items:AddList(_U("speed_limit"), FoltonePersonalMenu.speedLimitList, FoltonePersonalMenu.speedLimitList[FoltonePersonalMenu.speedLimitIndex], FoltonePersonalMenu.speedLimitIndex,  nil, { IsDisabled = timeout }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    FoltonePersonalMenu.speedLimitIndex = Index;
                end
                if onSelected then
                    FoltonePersonalMenu.speedLimiterEnabled = true
                    local speed = tonumber(FoltonePersonalMenu.speedLimitList[FoltonePersonalMenu.speedLimitIndex])
                    if Config.speedUnit == "km/h" then
                        speed = speed / 3.6
                    elseif Config.speedUnit == "mph" then
                        speed = speed / 2.237
                    end
                    if speed then
                        SetEntityMaxSpeed(vehicle, speed)
                    end
                end
            end)
        end
    end, function(Panels)
    end)

    keysMenu:IsVisible(function(Items)
        Items:AddSeparator(_U("your_keys"))
        if playerData.keys then
            for i = 1, #playerData.keys, 1 do
                local label = playerData.keys[i].label
                if label == "" or label == nil then
                    label = _U("no_name")
                end
                Items:AddButton(_U("name_key", label, playerData.keys[i].plate), nil, { IsDisabled = timout }, function(onSelected)
                    if onSelected then
                        FoltonePersonalMenu.keySelected = playerData.keys[i]
                    end
                end, keysOptionMenu)
            end
        end
    end, function(Panels)
    end)
    keysOptionMenu:IsVisible(function(Items)
        Items:AddButton(_U("rename_key"), nil, { RightLabel = ">", IsDisabled = timout }, function(onSelected)
            if onSelected then
                local name = KeyboardInput(_U("name"), "", 10)
                if name then
                    TriggerServerEvent("foltone_vehiclelock:renameKey", FoltonePersonalMenu.keySelected.id, name)
                    Wait(250)
                    updateKeys()
                end
            end
        end)
        Items:AddButton(_U("give_key"), nil, { IsDisabled = timout }, function(onSelected)
            local closestPlayer, closestPlayerCoords, distance = GetClosestPlayer()
            if onSelected then
                if closestPlayer ~= -1 then
                    if distance <= 3.0 then
                        setTimeout(500)
                        TriggerServerEvent("foltone_f5:giveKey", GetPlayerServerId(closestPlayer), FoltonePersonalMenu.keySelected.plate)
                    else
                        Config.Notification(_U("no_players_nearby"))
                    end
                else
                    Config.Notification(_U("no_players_nearby"))
                end
            end
        end)
        Items:AddButton(_U("destroy"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = timout }, function(onSelected)
            if onSelected then
                if confirmation() then
                    setTimeout(500)
                    TriggerServerEvent("foltone_vehiclelock:removeKey", FoltonePersonalMenu.keySelected.id)
                    Wait(250)
                    updateKeys()
                    RageUI.GoBack()
                end
            end
        end)
    end, function(Panels)
    end)
end

Keys.Register(Config.key, Config.key, "Open the personal menu", function()
    if not open and not timout then
        setTimeout(750)
        ESX.TriggerServerCallback("foltone_f5:getPlayerData", function(data)
            open = true
            playerData = data
            RageUI.Visible(personalMenu, not RageUI.Visible(personalMenu))
        end)
    end
end)

RegisterNetEvent("foltone_f5:notification")
AddEventHandler("foltone_f5:notification", function(text)
    Config.Notification(text)
end)
RegisterNetEvent("foltone_f5:advancedNotification")
AddEventHandler("foltone_f5:advancedNotification", function(title, subject, msg, icon, iconType)
    Config.AddvancedNotification(title, subject, msg, icon, iconType)
end)
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    playerLoaded = true
end)
RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    if playerLoaded then
        playerData.job = job.name
        playerData.grade = job.grade_label
    end
end)
RegisterNetEvent("esx:setJob2")
AddEventHandler("esx:setJob2", function(job2)
    if playerLoaded then
        playerData.job2 = job2.name
        playerData.grade2 = job2.grade_label
    end
end)
RegisterNetEvent("foltone_f5:refreshPlayerMoney")
AddEventHandler("foltone_f5:refreshPlayerMoney", function(data)
    playerData.money = data.money
    playerData.bank = data.bank
    playerData.black_money = data.black_money
end)
