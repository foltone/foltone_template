local timout = false
local function setTimout(time)
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
local function set2dText(text)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(0, true)
end

Config.CallESX()

local playersList = {}
local playerSelected;

local function refreshPlayers()
    ESX.TriggerServerCallback("foltone_admin_menu:getPlayers", function(data)
        playersList = data
    end)
end

local function reFreshPlayerSelectedData()
    ESX.TriggerServerCallback("foltone_admin_menu:getPlayerData", function(data)
        playerSelected.data = data
    end, playerSelected.id)
end

local ticketsList = {}
local ticketSelected;

local function refreshTickets()
    TriggerServerEvent("foltone_admin_menu:getTickets")
end

local mainAdminmenu = RageUI.CreateMenu(_U("admin_menu_title"), _U("admin_menu_title"))
local menuPlayersList = RageUI.CreateSubMenu(mainAdminmenu, _U("players_list_menu"), _U("players_list_submenu"))
local menuOptions = RageUI.CreateSubMenu(mainAdminmenu, _U("options_menu_title"), _U("options_menu_subtitle"))
local menuVehicle = RageUI.CreateSubMenu(mainAdminmenu, _U("vehicle_menu_title"), _U("vehicle_menu_subtitle"))
local menuTicket = RageUI.CreateSubMenu(mainAdminmenu, _U("ticket_menu_title"), _U("ticket_menu_subtitle"))

local playerOption = RageUI.CreateSubMenu(menuPlayersList, _U("player_option_menu_title"), _U("player_option_menu_subtitle"))
local playerSearch = RageUI.CreateSubMenu(playerOption, _U("player_option_menu_title"), _U("player_option_menu_subtitle"))

local ticketList = RageUI.CreateSubMenu(menuTicket, _U("ticket_list_menu_title"), _U("ticket_list_menu_subtitle"))
local myTicketList = RageUI.CreateSubMenu(menuTicket, _U("my_ticket_menu_title"), _U("my_ticket_menu_subtitle"))
local closeTicketList = RageUI.CreateSubMenu(menuTicket, _U("close_ticket_menu_title"), _U("close_ticket_menu_subtitle"))
local optionTicket = RageUI.CreateSubMenu(menuTicket, _U("option_ticket_menu_title"), _U("option_ticket_menu_subtitle"))

local serviceStatue = false
local showFreeTicketsStatue = false
local ListIndex = 1;

local function updateNuiValues()
    local ticketsCount = 0
    for k, v in pairs(ticketsList) do
        if v.admin == nil or v.admin <= 0 then
            ticketsCount = ticketsCount + 1
        end
    end
    ESX.TriggerServerCallback("foltone_admin_menu:getStaffCount", function(staffCount)
        SendNUIMessage({
            type = "update",
            users = #playersList,
            staff = staffCount,
            ticket = ticketsCount
        })
    end)
end
local function updateNuiElement(element, value)
    SendNUIMessage({
        type = "updateElement",
        element = element,
        disable = value
    })
end

local ListSearchOptionIndex = 1;
local ListSearchOption = {
    _U("remove"),
    _U("give")
}

local function resetVars()
    ticketSelected = nil
    ListIndex = 1
end

local spectateActive = false
local lastCoords = nil
local function startStopSpectatePlayer(target)
    local playerPed = PlayerPedId()
    if spectateActive then
        local playerCoords = GetEntityCoords(playerPed, false);
        lastCoords = playerCoords
        FreezeEntityPosition(playerPed, true)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, false)
        SetEveryoneIgnorePlayer(playerPed, true)
        SetPoliceIgnorePlayer(playerPed, true)
        SetEntityInvincible(playerPed, true)
        CreateThread(function()
            while spectateActive do
                SetEntityVelocity(playerPed, 0.01, 0.01, 0.01)
                local targetPed = GetPlayerPed(target)
                local targetCoords = GetEntityCoords(targetPed, false);
                SetEntityCoordsNoOffset(playerPed, targetCoords.x, targetCoords.y, targetCoords.z + 1.5, false, false, false)
                SetEntityHeading(playerPed, GetEntityHeading(targetPed))
                Wait(0)
            end
        end)
        
    else
        SetEntityCoords(playerPed, lastCoords.x, lastCoords.y, lastCoords.z + 1, false, false, false)
        FreezeEntityPosition(playerPed, false)
        SetEntityCollision(playerPed, true, true)
        SetEntityVisible(playerPed, true, true)
        SetEveryoneIgnorePlayer(playerPed, false)
        SetPoliceIgnorePlayer(playerPed, false)
        SetEntityInvincible(playerPed, false)
    end
end

local noclipActive = false
local function getCamDirection(plyPed)
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords =
		vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end
local function startStopNoclip()
    CreateThread(function()
        local playerPed = PlayerPedId()
	    local NoclipSpeed = 3
        if noclipActive then
            FreezeEntityPosition(playerPed, true)
            SetEntityCollision(playerPed, false, false)
            SetEntityVisible(playerPed, false, false)
            SetEveryoneIgnorePlayer(playerPed, true)
            SetPoliceIgnorePlayer(playerPed, true)
        elseif not noclipActive then
            FreezeEntityPosition(playerPed, false)
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true, true)
            SetEveryoneIgnorePlayer(playerPed, false)
            SetPoliceIgnorePlayer(playerPed, false)
        end
        while noclipActive do
            local playerCoords = GetEntityCoords(playerPed, false)
            local camCoords = getCamDirection(playerPed)
            SetEntityVelocity(playerPed, 0.01, 0.01, 0.01)
            local speedMultiplicator = 1
            if IsControlPressed(0, 60) then
                speedMultiplicator = 0.3
            end
            if IsControlPressed(0, 21) then
                speedMultiplicator = 5
            end
            if IsControlPressed(0, 32) then
                playerCoords = playerCoords + (NoclipSpeed * speedMultiplicator * camCoords)
            end
            if IsControlPressed(0, 269) then
                playerCoords = playerCoords - (NoclipSpeed * speedMultiplicator * camCoords)
            end
            SetEntityCoordsNoOffset(playerPed, playerCoords, true, true, true)
            set2dText(_U("help_noclip"))
            Wait(0)
        end
    end)
end
local invincibilityActive = false
local invisibleActive = false
local playersNamesActive = false
local gamerTags = {}
local function startStopNames()
    if playersNamesActive then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, false);
        local isInRightSeat = GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed
        local isDead = IsEntityDead(playerPed)
        for _,v in pairs(GetActivePlayers()) do
            local otherPed = GetPlayerPed(v);
            if #(playerCoords - GetEntityCoords(otherPed, false)) < 250.0 then
                gamerTags[v] = CreateFakeMpGamerTag(otherPed, string.format("[%s] - %s", GetPlayerServerId(v), GetPlayerName(v)), true, false, "", 0);
                SetMpGamerTagAlpha(gamerTags[v], 0, 255);
                SetMpGamerTagAlpha(gamerTags[v], 2, 255);
                SetMpGamerTagAlpha(gamerTags[v], 4, 255);
                SetMpGamerTagAlpha(gamerTags[v], 7, 255);
                SetMpGamerTagAlpha(gamerTags[v], 8, 255);
                if isInRightSeat then
                    SetMpGamerTagVisibility(gamerTags[v], 8, 255);
                    SetMpGamerTagColour(gamerTags[v], 8, 162);
                else
                    SetMpGamerTagVisibility(gamerTags[v], 8, 0);
                end
                SetMpGamerTagVisibility(gamerTags[v], 0, true);
                SetMpGamerTagVisibility(gamerTags[v], 2, true);
                SetMpGamerTagVisibility(gamerTags[v], 4, NetworkIsPlayerTalking(v));
                if NetworkIsPlayerTalking(otherPed) then
                    SetMpGamerTagHealthBarColour(gamerTags[v], 211);
                else
                    SetMpGamerTagHealthBarColour(gamerTags[v], 0);
                end
            else
                RemoveMpGamerTag(gamerTags[v]);
                gamerTags[v] = nil;
            end
        end
    else
        for _,v in pairs(gamerTags) do
            RemoveMpGamerTag(v);
        end
        gamerTags = {}
    end
end
local playersBlipsActive = false
local playersBlips = {}
local function startStopBlips()
    if playersBlipsActive then
        CreateThread(function()
            while playersBlipsActive do
                for k, v in pairs(GetActivePlayers()) do
                    local playerPed = GetPlayerPed(v)
                    local blip = nil
                    if not playersBlips[v] then
                        blip = AddBlipForEntity(playerPed)
                        SetBlipSprite(blip, 1)
                        SetBlipColour(blip, 2)
                        playersBlips[v] = blip
                    end
                    blip = playersBlips[v]
                    local playerCoords = GetEntityCoords(playerPed, false);
                    SetBlipCoords(blip, playerCoords)
                    SetBlipNameToPlayerName(blip, v)
                    Wait(0)
                end
            end
        end)
    else
        for k, v in pairs(playersBlips) do
            RemoveBlip(v);
            playersBlips[k] = nil;
        end
    end
end
local armorActive = false

local function getClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed, false);
    local closestVehicle = nil
    closestVehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, 0, 70)
    local vehicleCoords = GetEntityCoords(closestVehicle, false);
    DrawMarker(2, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.5, 0, 0, 0, 0, 180.0, 0, 0.3, 0.3, 0.3, 114, 204, 114, 255, false, true, 2, false, false, false, false)
    return closestVehicle
end
local clearZoneList = {
    5,
    10,
    20,
    50,
    100
}
local clearZoneIndex = 1;
local function getVehiclesInArea(coords, area)
    local vehicles = {}
    for k, v in pairs(GetGamePool("CVehicle")) do
        local vehicleCoords = GetEntityCoords(v, false);
        if #(coords - vehicleCoords) < area then
            table.insert(vehicles, v)
        end
    end
    return vehicles
end

local function playerOptions()
    Items:AddButton(_U("player_search_button"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
        if onSelected then
            reFreshPlayerSelectedData()
        end
    end, playerSearch)
    Items:Line()
    Items:CheckBox(_U("spectate_player"), nil, spectateActive, { Style = 1 }, function(onSelected, IsChecked)
        if (onSelected) then
            spectateActive = IsChecked
            updateNuiElement("spectate", spectateActive)
            startStopSpectatePlayer(playerSelected.player)
            if spectateActive then
                Config.Notification(_U("spectate_active"))
            else
                Config.Notification(_U("spectate_desactive"))
            end
        end
    end)
    Items:AddButton(_U("send_message"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
        if (onSelected) then
            local message = KeyboardInput("Message", "", 300)
            if message ~= nil and message ~= "" then
                TriggerServerEvent("foltone_admin_menu:sendMessage", playerSelected.id, _U("staff_message", message))
            else
                Config.Notification(_U("no_message"))
            end
        end
    end)
    Items:AddList(_U("teleport_player_to"), Config.teleport_list, Config.teleport_list[ListIndex].name, ListIndex, nil, {RightLabel = "", IsDisabled = false }, function(Index, onSelected, onListChange)
        if (onListChange) then
            ListIndex = Index
        end
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:teleportPlayerTo", playerSelected.id, Config.teleport_list[ListIndex].coords)
        end
    end)
    Items:AddButton(_U("bring_player"), nil, { RightBadge = RageUI.BadgeStyle.Player, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:teleportPlayerTo", playerSelected.id, GetEntityCoords(PlayerPedId()))
        end
    end)
    Items:AddButton(_U("go_to_player"), nil, { RightBadge = RageUI.BadgeStyle.Player, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            local targetCoords = GetEntityCoords(GetPlayerPed(playerSelected.player), false);
            SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z + 1, false, false, false, false)
        end
    end)
    Items:AddButton(_U("revive_player"), nil, { RightBadge = RageUI.BadgeStyle.Heart, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("esx_ambulancejob:revive", playerSelected.id)
        end
    end)
    Items:AddButton(_U("heal_player"), nil, { RightBadge = RageUI.BadgeStyle.Heart, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:healPlayer", playerSelected.id)
        end
    end)
    Items:AddButton(_U("armor_player"), nil, { RightBadge = RageUI.BadgeStyle.Armor, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:armorPlayer", playerSelected.id)
        end
    end)
    Items:AddButton(_U("kill_player"), nil, { RightBadge = RageUI.BadgeStyle.Dead, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:killPlayer", playerSelected.id)
        end
    end)
    Items:AddButton(_U("freeze_unfreeze_player"), nil, { RightBadge = RageUI.BadgeStyle.BoatPickup, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            TriggerServerEvent("foltone_admin_menu:freezeUnfreezePlayer", playerSelected.id)
        end
    end)
    Items:AddButton(_U("kick_player"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            local reason = KeyboardInput("Raison", "", 10)
            if reason ~= nil and reason ~= "" then
                if Config.UseFoltoneSanction then
                    TriggerServerEvent("foltone_sanction:kickPlayer", playerSelected.id, reason)
                else
                    TriggerServerEvent("foltone_admin_menu:kickPlayer", playerSelected.id, reason)
                end
                RageUI.GoBack()
            else
                Config.Notification(_U("no_reason"))
            end
            RageUI.GoBack()
        end
    end)
    Items:AddButton(_U("ban_player"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
        if (onSelected) then
            local reason = KeyboardInput("Raison", "", 10)
            local time = nil
            if Config.UseFoltoneSanction then
                time = KeyboardInput("Temps (1h, 1d, 1m)", "", 10)
            end
            if reason ~= nil and reason ~= "" then
                if Config.UseFoltoneSanction then
                    if time ~= nil and time ~= "" then
                        TriggerServerEvent("foltone_sanction:banPlayer", playerSelected.id, time, reason)
                    else
                        Config.Notification(_U("no_time"))
                    end
                else
                    TriggerServerEvent("foltone_admin_menu:banPlayer", playerSelected.id, reason)
                end
                RageUI.GoBack()
            else
                Config.Notification(_U("no_reason"))
            end
            RageUI.GoBack()
        end
    end)
    if Config.UseFoltoneSanction then
        Items:AddButton(_U("jail_player"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local reason = KeyboardInput("Raison", "", 10)
                local time = KeyboardInput("Temps minutes (5)", "", 10)
                if reason ~= nil and reason ~= "" then
                    if time ~= nil and time ~= "" then
                        TriggerServerEvent("foltone_sanction:jailPlayer", playerSelected.id, time, reason)
                    else
                        Config.Notification(_U("no_time"))
                    end
                    RageUI.GoBack()
                else
                    Config.Notification(_U("no_reason"))
                end
                RageUI.GoBack()
            end
        end)
        Items:AddButton(_U("unjail_player"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("foltone_sanction:unjailPlayer", playerSelected.id)
                RageUI.GoBack()
            end
        end)
    end
end
local function playerSearchs()
    Items:AddSeparator(_U("player_name", playerSelected.name))
    Items:AddSeparator(_U("player_job", playerSelected.data.job.label, playerSelected.data.job.grade_label))
    Items:AddSeparator(_U("money_separator"))
    Items:AddList(_U("player_money", playerSelected.data.money), ListSearchOption, ListSearchOption[ListSearchOptionIndex], ListSearchOptionIndex, nil, {RightLabel = "", IsDisabled = timout }, function(Index, onSelected, onListChange)
        if (onListChange) then
            ListSearchOptionIndex = Index
        end
        if (onSelected) then
            local amount = KeyboardInput("Montant à " .. ListSearchOption[ListSearchOptionIndex], "", 10)
            if amount ~= nil and amount ~= "" then
                amount = tonumber(amount)
                if type(amount) ~= "number" then
                    Config.Notification(_U("invalid_amount"))
                else
                    if amount < 0 then
                        Config.Notification(_U("invalid_amount"))
                    else
                        if ListSearchOptionIndex == 1 then
                            TriggerServerEvent("foltone_admin_menu:removeAccountMoney", playerSelected.id, Config.moneyTypes["money"].name, amount)
                        else
                            TriggerServerEvent("foltone_admin_menu:giveAccountMoney", playerSelected.id, Config.moneyTypes["money"].name, amount)
                        end
                        reFreshPlayerSelectedData()
                        setTimout(500)
                    end
                end
            else
                Config.Notification(_U("invalid_amount"))
            end
        end
    end)
    Items:AddList(_U("player_bank", playerSelected.data.bank), ListSearchOption, ListSearchOption[ListSearchOptionIndex], ListSearchOptionIndex, nil, {RightLabel = "", IsDisabled = timout }, function(Index, onSelected, onListChange)
        if (onListChange) then
            ListSearchOptionIndex = Index
        end
        if (onSelected) then
            local amount = KeyboardInput("Montant à " .. ListSearchOption[ListSearchOptionIndex], "", 10)
            if amount ~= nil and amount ~= "" then
                amount = tonumber(amount)
                if type(amount) ~= "number" then
                    Config.Notification(_U("invalid_amount"))
                else
                    if amount < 0 then
                        Config.Notification(_U("invalid_amount"))
                    else
                        if ListSearchOptionIndex == 1 then
                            TriggerServerEvent("foltone_admin_menu:removeAccountMoney", playerSelected.id, Config.moneyTypes["bank"].name, amount)
                        else
                            TriggerServerEvent("foltone_admin_menu:giveAccountMoney", playerSelected.id, Config.moneyTypes["bank"].name, amount)
                        end
                        reFreshPlayerSelectedData()
                        setTimout(500)
                    end
                end
            else
                Config.Notification(_U("invalid_amount"))
            end
        end
    end)
    Items:AddList(_U("player_black_money", playerSelected.data.blackmoney), ListSearchOption, ListSearchOption[ListSearchOptionIndex], ListSearchOptionIndex, nil, {RightLabel = "", IsDisabled = timout }, function(Index, onSelected, onListChange)
        if (onListChange) then
            ListSearchOptionIndex = Index
        end
        if (onSelected) then
            local amount = KeyboardInput("Montant à " .. ListSearchOption[ListSearchOptionIndex], "", 10)
            if amount ~= nil and amount ~= "" then
                amount = tonumber(amount)
                if type(amount) ~= "number" then
                    Config.Notification(_U("invalid_amount"))
                else
                    if amount < 0 then
                        Config.Notification(_U("invalid_amount"))
                    else
                        if ListSearchOptionIndex == 1 then
                            TriggerServerEvent("foltone_admin_menu:removeAccountMoney", playerSelected.id, Config.moneyTypes["blackmoney"].name, amount)
                        else
                            TriggerServerEvent("foltone_admin_menu:giveAccountMoney", playerSelected.id, Config.moneyTypes["blackmoney"].name, amount)
                        end
                        reFreshPlayerSelectedData()
                        setTimout(500)
                    end
                end
            else
                Config.Notification(_U("invalid_amount"))
            end
        end
    end)
    Items:AddSeparator(_U("player_inventory"))
    for k, v in pairs(playerSelected.data.inventory) do
        if v.count > 0 then
            Items:AddList(_U("player_inventory_item", v.count, v.label), ListSearchOption, ListSearchOption[ListSearchOptionIndex], ListSearchOptionIndex, nil, {RightLabel = "", IsDisabled = timout }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    ListSearchOptionIndex = Index
                end
                if (onSelected) then
                    local amount = KeyboardInput("Montant à " .. ListSearchOption[ListSearchOptionIndex], "", 10)
                    if amount ~= nil and amount ~= "" then
                        amount = tonumber(amount)
                        if type(amount) ~= "number" then
                            Config.Notification(_U("invalid_amount"))
                        else
                            if amount < 0 then
                                Config.Notification(_U("invalid_amount"))
                            else
                                if ListSearchOptionIndex == 1 then
                                    TriggerServerEvent("foltone_admin_menu:removeItem", playerSelected.id, v.name, amount)
                                else
                                    TriggerServerEvent("foltone_admin_menu:giveItem", playerSelected.id, v.name, amount)
                                end
                                reFreshPlayerSelectedData()
                                setTimout(500)
                            end
                        end
                    else
                        Config.Notification(_U("no_reason"))
                    end
                end
            end)
        end
    end
    Items:AddSeparator(_U("player_weapon"))
    for k, v in pairs(playerSelected.data.weapons) do
        Items:AddButton(_U("player_inventory_weapon", v.label), nil, { RightLabel = _U("remove"), IsDisabled = timout }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("foltone_admin_menu:removeWeapon", playerSelected.id, v.name, v.ammo)
                reFreshPlayerSelectedData()
                setTimout(500)
            end
        end)
    end
end

function RageUI.PoolMenus:FoltoneAdmin()
    mainAdminmenu:IsVisible(function(Items)
        Items:CheckBox(_U("service_statue"), nil, serviceStatue, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                serviceStatue = IsChecked
                if IsChecked then
                    SendNUIMessage({
                        type = "show",
                        users = #playersList,
                        staff = 1,
                        ticket = #ticketsList
                    })
                else
                    SendNUIMessage({
                        type = "hide"
                    })
                end
                if Config.UseFoltoneSanction then
                    TriggerServerEvent("foltone_sanction:serviceStatue", serviceStatue)
                end
            end
        end)
        if serviceStatue then
            Items:Line()
            Items:AddButton(_U("players_list_button"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if onSelected then
                    refreshPlayers()
                end
            end, menuPlayersList)
            Items:AddButton(_U("options_button"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            end, menuOptions)
            Items:AddButton(_U("vehicle_button"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            end, menuVehicle)
            Items:AddButton(_U("ticketmenu_button"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if onSelected then
                    refreshPlayers()
                    refreshTickets()
                end
            end, menuTicket)
        end
    end, function()
    end)

    menuPlayersList:IsVisible(function(Items)
        Items:AddButton(_U("refresh_players"), nil, { RightLabel = "↓", IsDisabled = timout }, function(onSelected)
            if (onSelected) then
                setTimout(1000)
                refreshPlayers()
            end
        end)
        Items:AddButton(_U("search_by_id"), nil, { RightLabel = ">", IsDisabled = timout }, function(onSelected)
            if (onSelected) then
                local id = KeyboardInput("ID", "", 10)
                if id ~= nil and id ~= "" then
                    id = tonumber(id)
                    if type(id) ~= "number" then
                        Config.Notification(_U("invalid_id"))
                    else
                        if id < 0 then
                            Config.Notification(_U("invalid_id"))
                        else
                            for k, v in pairs(playersList) do
                                local playerServerId = tonumber(v.id)
                                local player = GetPlayerFromServerId(playerServerId)
                                local playerServerName = GetPlayerName(player)
                                if playerServerId == tonumber(id) then
                                    playerSelected = {
                                        id = playerServerId,
                                        player = player,
                                        name = playerServerName,
                                        data = nil
                                    }
                                    reFreshPlayerSelectedData()
                                    Wait(250)
                                    RageUI.NextMenu = playerOption
                                end
                            end
                            Config.Notification(_U("invalid_id"))
                        end
                    end
                else
                    Config.Notification(_U("invalid_id"))
                end
            end
        end)
        Items:Line()
        for k, v in pairs(playersList) do
            local playerServerId = tonumber(v.id)
            local player = GetPlayerFromServerId(playerServerId)
            local playerServerName = GetPlayerName(player)
            Items:AddButton(_U("player_button", playerServerId, playerServerName), nil, { RightLabel = ">", IsDisabled = timout }, function(onSelected)
                if (onSelected) then
                    playerSelected = {
                        id = playerServerId,
                        player = player,
                        name = playerServerName,
                        data = nil
                    }
                    reFreshPlayerSelectedData()
                    Wait(250)
                    RageUI.NextMenu = playerOption
                end
            end, playerOption)
        end
    end, function()
    end)
    playerOption:IsVisible(function(Items)
        Items:AddSeparator(_U("player_separator", playerSelected.id, playerSelected.name))
        playerOptions()
    end, function()
    end)
    playerSearch:IsVisible(function(Items)
        playerSearchs()
    end, function()
    end)

    menuOptions:IsVisible(function(Items)
        Items:CheckBox(_U("active_noclip"), nil, noclipActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                noclipActive = IsChecked
                updateNuiElement("noclip", noclipActive)
                startStopNoclip()
                if noclipActive then
                    Config.Notification(_U("noclip_active"))
                else
                    Config.Notification(_U("noclip_desactive"))
                end
            end
        end)
        Items:CheckBox(_U("invincibility"), nil, invincibilityActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                invincibilityActive = IsChecked
                updateNuiElement("invincibility", invincibilityActive)
                if noclipActive then
                    Config.Notification(_U("you_are_invincible"))
                    SetEntityInvincible(PlayerPedId(), true)
                else
                    Config.Notification(_U("you_are_uninvincible"))
                    SetEntityInvincible(PlayerPedId(), false)
                end
            end
        end)
        Items:CheckBox(_U("invisible"), nil, invisibleActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                invisibleActive = IsChecked
                updateNuiElement("invisible", invisibleActive)
                if invisibleActive then
                    Config.Notification(_U("you_are_invisible"))
                    SetEntityVisible(PlayerPedId(), false, false)
                else
                    Config.Notification(_U("you_are_uninvisible"))
                    SetEntityVisible(PlayerPedId(), true, true)
                end
            end
        end)
        Items:CheckBox(_U("players_names"), nil, playersNamesActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                playersNamesActive = IsChecked
                updateNuiElement("playersNames", playersNamesActive)
                startStopNames()
                if playersNamesActive then
                    Config.Notification(_U("players_names_active"))
                else
                    Config.Notification(_U("players_names_desactive"))
                end
            end
        end)
        Items:CheckBox(_U("players_blips"), nil, playersBlipsActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                playersBlipsActive = IsChecked
                updateNuiElement("playersBlips", playersBlipsActive)
                startStopBlips()
                if playersBlipsActive then
                    Config.Notification(_U("players_blips_active"))
                else
                    Config.Notification(_U("players_blips_desactive"))
                end
            end
        end)
        Items:AddButton(_U("heal"), nil, { IsDisabled = false, RightBadge = RageUI.BadgeStyle.Heart }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("foltone_admin_menu:healPlayer", PlayerId())
            end
        end)
        Items:AddButton(_U("revive"), nil, { IsDisabled = false, RightBadge = RageUI.BadgeStyle.Heart }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("esx_ambulancejob:revive", PlayerId())
            end
        end)
        Items:CheckBox(_U("armor"), nil, armorActive, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                armorActive = IsChecked
                if armorActive then
                    Config.Notification(_U("you_gate_armor"))
                    SetPedArmour(PlayerPedId(), 100)
                else
                    Config.Notification(_U("you_are_unarmor"))
                    SetPedArmour(PlayerPedId(), 0)
                end
            end
        end)
    end, function()
    end)

    menuVehicle:IsVisible(function(Items)
        Items:AddButton(_U("spawn_vehicle"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local vehicle = KeyboardInput("Nom du véhicule", "", 10)
                if vehicle ~= nil and vehicle ~= "" then
                    vehicle = string.lower(vehicle)
                    local model = GetHashKey(vehicle)
                    if IsModelInCdimage(model) and IsModelAVehicle(model) then
                        RequestModel(model)
                        repeat Wait(0) until HasModelLoaded(model)
                        local playerPed = PlayerPedId()
                        local coords = GetEntityCoords(playerPed, false)
                        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
                        SetPedIntoVehicle(playerPed, vehicle, -1)
                        SetEntityAsNoLongerNeeded(vehicle)
                        SetModelAsNoLongerNeeded(model)
                        SetVehicleOnGroundProperly(vehicle)
                        SetVehicleNumberPlateText(vehicle, "ADMIN")
                    end
                else
                    Config.Notification(_U("invalid_vehicle"))
                end
            end
        end)
        Items:AddButton(_U("repair_vehicle"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            local vehicle = getClosestVehicle()
            if (onSelected) then
                print(vehicle)
                if vehicle ~= 0 and vehicle ~= nil then
                    NetworkRequestControlOfEntity(vehicle)
                    repeat Wait(0) until NetworkHasControlOfEntity(vehicle)
                    SetVehicleFixed(vehicle)
                    SetVehicleDirtLevel(vehicle, 0.0)
                else
                    Config.Notification(_U("no_vehicle"))
                end
            end
        end)
        Items:AddButton(_U("flip_vehicle"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            local vehicle = getClosestVehicle()
            if (onSelected) then
                if vehicle ~= 0 and vehicle ~= nil then
                    NetworkRequestControlOfEntity(vehicle)
                    repeat Wait(0) until NetworkHasControlOfEntity(vehicle)
                    local vehicleCoords = GetEntityCoords(vehicle, false);
                    local heading = GetEntityHeading(vehicle)
                    SetEntityCoords(vehicle, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1, false, false, false, false)
                    SetEntityHeading(vehicle, heading)
                else
                    Config.Notification(_U("no_vehicle"))
                end
            end
        end)
        Items:AddButton(_U("freeze_unfreeze_vehicle"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            local vehicle = getClosestVehicle()
            if (onSelected) then
                if vehicle ~= 0 and vehicle ~= nil then
                    NetworkRequestControlOfEntity(vehicle)
                    repeat Wait(0) until NetworkHasControlOfEntity(vehicle)
                    FreezeEntityPosition(vehicle, not IsEntityPositionFrozen(vehicle))
                else
                    Config.Notification(_U("no_vehicle"))
                end
            end
        end)
        Items:AddButton(_U("delete_vehicle"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            local vehicle = getClosestVehicle()
            if (onSelected) then
                if vehicle ~= 0 and vehicle ~= nil then
                    NetworkRequestControlOfEntity(vehicle)
                    repeat Wait(0) until NetworkHasControlOfEntity(vehicle)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteVehicle(vehicle)
                else
                    Config.Notification(_U("no_vehicle"))
                end
            end
        end)
        Items:AddList(_U("cleat_vehicle_zone"), clearZoneList, clearZoneList, clearZoneIndex, nil, {RightLabel = "", IsDisabled = false }, function(Index, onSelected, onListChange)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, false);
            DrawMarker(1, playerCoords.x, playerCoords.y, playerCoords.z - 0.98, 0, 0, 0, 0, 0, 0, clearZoneList[clearZoneIndex]+0.0, clearZoneList[clearZoneIndex]+0.0, 0.5, 255, 0, 0, 255, false, true, 2, false, false, false, false)
            if (onListChange) then
                clearZoneIndex = Index
            end
            if (onSelected) then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed, false);
                local vehicles = getVehiclesInArea(playerCoords, clearZoneList[clearZoneIndex] / 2)
                for k, v in pairs(vehicles) do
                    NetworkRequestControlOfEntity(v)
                    repeat Wait(0) until NetworkHasControlOfEntity(v)
                    SetEntityAsMissionEntity(v, true, true)
                    DeleteVehicle(v)
                end
            end
        end)
    end, function()
    end)

    menuTicket:IsVisible(function(Items)
        Items:AddButton(_U("available_ticket"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                refreshTickets()
                refreshPlayers()
            end
        end, ticketList)
        Items:AddButton(_U("my_ticket"), nil, { RightLabel = ">", IsDisabled = false, LeftBadge = RageUI.BadgeStyle.Player }, function(onSelected)
        end, myTicketList)
        Items:AddButton(_U("ticket_close"), nil, { RightLabel = ">", IsDisabled = false, LeftBadge = RageUI.BadgeStyle.Lock }, function(onSelected)
        end, closeTicketList)
    end, function()
    end)
    ticketList:IsVisible(function(Items)
        Items:CheckBox(_U("show_free_ticket"), nil, showFreeTicketsStatue, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                showFreeTicketsStatue = IsChecked
            end
        end)
        for k, v in pairs(ticketsList) do
            if (v.admin == nil or v.admin <= 0) and v.closed ~= true then
                Items:AddButton(_U("ticket_button", v.permid, v.name), _U("press_enter_get_ticket"), { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        TriggerServerEvent("foltone_admin_menu:takeTicket", v.permid)
                        if Config.UseFoltoneSanction then
                            TriggerServerEvent("foltone_sanction:takeTicket", v.permid)
                        end
                        ticketSelected = v
                        for k, v in pairs(playersList) do
                            local player = GetPlayerFromServerId(v.id)
                            if GetPlayerServerId(player) == ticketSelected.id then
                                playerSelected = {
                                    id = GetPlayerServerId(player),
                                    player = player,
                                    name = GetPlayerName(player),
                                    data = nil
                                }
                                reFreshPlayerSelectedData()
                                Wait(250)
                                RageUI.NextMenu = optionTicket
                            end
                        end
                    end
                end, optionTicket)
            elseif v.admin and (v.admin > 0) and showFreeTicketsStatue ~= true then
                Items:AddButton(_U("ticket_button", v.permid, v.name), _U("take_by", GetPlayerName(GetPlayerFromServerId(v.admin))), { RightLabel = ">", IsDisabled = true }, function(onSelected)
                end)
            end
        end
    end, function()
    end)
    myTicketList:IsVisible(function(Items)
        for k, v in pairs(ticketsList) do
            if v.admin == GetPlayerServerId(PlayerId()) and v.closed == false then
                Items:AddButton(_U("ticket_button", v.permid, v.name), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        ticketSelected = v
                    end
                end, optionTicket)
            end
        end
    end, function(Panels)
    end)
    closeTicketList:IsVisible(function(Items)
        for k, v in pairs(ticketsList) do
            if v.closed == true then
                Items:AddButton(_U("ticket_button", v.permid, v.name), _U("press_enter_get_ticket"), { RightLabel = ">", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        ticketSelected = v
                    end
                end, optionTicket)
            end
        end
    end, function(Panels)
    end)
    optionTicket:IsVisible(function(Items)
        Items:AddSeparator(_U("ticket_separator", ticketSelected.permid, ticketSelected.name))
        
        Items:AddButton(_U("ticket_message"), ticketSelected.message, { IsDisabled = false }, function(onSelected)
        end)

        playerOptions()

        if ticketSelected.closed == true then
            Items:AddButton(_U("open_ticket"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_admin_menu:openTicket", ticketSelected.permid)
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)

            Items:AddButton(_U("open_take_ticket"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_admin_menu:openTicket", ticketSelected.permid)
                    TriggerServerEvent("foltone_admin_menu:takeTicket", ticketSelected.permid)
                    if Config.UseFoltoneSanction then
                        TriggerServerEvent("foltone_sanction:takeTicket", v.permid)
                    end
                    refreshTickets()
                end
            end)
        else
            Items:AddButton(_U("giveup_ticket"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_admin_menu:giveupTicket", ticketSelected.permid)
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)

            Items:AddButton(_U("close_ticket"), nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent("foltone_admin_menu:closeTicket", ticketSelected.permid)
                    if Config.UseFoltoneSanction then
                        TriggerServerEvent("foltone_sanction:closeTicket", ticketSelected.permid)
                    end
                    resetVars()
                    refreshTickets()
                    RageUI.GoBack()
                end
            end)
        end

        Items:AddButton(_U("delete_ticket"), nil, { RightBadge = RageUI.BadgeStyle.Alert, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent("foltone_admin_menu:deleteTicket", ticketSelected.permid)
                if Config.UseFoltoneSanction then
                    TriggerServerEvent("foltone_sanction:deleteTicket", ticketSelected.permid)
                end
                resetVars()
                refreshTickets()
                RageUI.GoBack()
            end
        end)

    end, function()
    end)
end

Keys.Register(Config.openKey, Config.openKey, "Open Admin Menu", function()
    if not timout then
        setTimout(500)
        ESX.TriggerServerCallback("foltone_admin_menu:getPlayerData", function(data)
            local group = data.group
            if group == "mod" or group == "admin" or group == "superadmin" or group == "owner" or group == "_dev" then
                RageUI.Visible(mainAdminmenu, not RageUI.Visible(mainAdminmenu))
            end
        end, GetPlayerServerId(PlayerId()))
    end
end)


RegisterCommand("report", function(source, args, rawCommand)
    if args == nil or args[1] == nil then
        Config.Notification(_U("no_reason"))
        return
    else
        for v, v in pairs(ticketsList) do
            if v.id == _source and v.closed ~= true then
                Config.Notification(_U("ticket_already_exist"))
                return
            end
        end
        TriggerServerEvent("foltone_admin_menu:addTicket", table.concat(args, " "))
    end
end, false)

CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/report", "Report a player", {
        { name="reason", help="Reason of the report" }
    })
end)

RegisterNetEvent("foltone_admin_menu:receiveTickets")
AddEventHandler("foltone_admin_menu:receiveTickets", function(tickets)
    ticketsList = tickets
    if serviceStatue then
        SendNUIMessage({
            type = "updateTicket",
            ticket = #ticketsList
        })
    end
end)
RegisterNetEvent("foltone_admin_menu:receiveMessage")
AddEventHandler("foltone_admin_menu:receiveMessage", function(message)
    SendNUIMessage({
        type = "message",
        message = message
    })
end)
RegisterNetEvent("foltone_admin_menu:setPlayerCoords")
AddEventHandler("foltone_admin_menu:setPlayerCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)
RegisterNetEvent("foltone_admin_menu:notification")
AddEventHandler("foltone_admin_menu:notification", function(text)
    Config.Notification(text)
end)
RegisterNetEvent("foltone_admin_menu:armorPlayer")
AddEventHandler("foltone_admin_menu:armorPlayer", function()
    local playerPed = PlayerPedId()
    Config.Notification(_U("you_gate_armor"))
    SetPedArmour(playerPed, 100)
end)
RegisterNetEvent("foltone_admin_menu:killPlayer")
AddEventHandler("foltone_admin_menu:killPlayer", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 0)
end)
RegisterNetEvent("foltone_admin_menu:freezeUnfreezePlayer")
AddEventHandler("foltone_admin_menu:freezeUnfreezePlayer", function()
    local playerPed = PlayerPedId()
    if IsEntityPositionFrozen(playerPed) then
        Config.Notification(_U("you_are_unfreeze"))
        FreezeEntityPosition(playerPed, false)
    else
        Config.Notification(_U("you_are_freeze"))
        FreezeEntityPosition(playerPed, true)
    end
end)
RegisterNetEvent("foltone_admin_menu:openMenu")
AddEventHandler("foltone_admin_menu:openMenu", function()
    refreshPlayers()
    refreshTickets()
    RageUI.Visible(mainAdminmenu, not RageUI.Visible(mainAdminmenu))
end)
RegisterNetEvent("foltone_admin_menu:receiveValues")
AddEventHandler("foltone_admin_menu:receiveValues", function()
    refreshPlayers()
    refreshTickets()
    Wait(1000)
    updateNuiValues()
end)
RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
    Wait(1000)
    TriggerServerEvent("foltone_admin_menu:updateValues")
end)
