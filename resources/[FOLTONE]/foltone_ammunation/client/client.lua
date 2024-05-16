ESX = exports["es_extended"]:getSharedObject()

local FoltoneAmmunation = {
    Timout = false,
    AisleSelected = 1,
    AmmunationSelected = 1
}

local function setTimout(time)
    FoltoneAmmunation.Timout = true
    SetTimeout(time, function()
        FoltoneAmmunation.Timout = false
    end)
end

local menuAmmunation = RageUI.CreateMenu(nil, _U("subtitle_ammunation_menu"), nil, nil, "shopui_title_gunclub", "shopui_title_gunclub");
local aisleMenuAmmunation = RageUI.CreateSubMenu(menuAmmunation, nil, _U("subtitle_ammunation_menu"), nil, nil, "shopui_title_gunclub", "shopui_title_gunclub");
local open = false
function RageUI.PoolMenus:FoltoneAmmunationMenu()
    function menuAmmunation.Closed()
        open = false
    end
    menuAmmunation:IsVisible(function(Items)
        if not ESX.PlayerData.WeaponLicense then
            Items:AddButton(_U("weapon_license"), nil, { RightLabel = string.format("~g~%s$", Config.LicensePrice) }, function(onSelected)
                if onSelected then
                    ESX.TriggerServerCallback("foltone_ammunation:boughtLicense", function(ok)
                        if ok then
                            ESX.PlayerData.WeaponLicense = true
                        else
                            ESX.PlayerData.WeaponLicense = false
                        end
                    end)
                end
            end)
        end
        for i = 1, #Config.AisleProductList do
            local aisle = Config.AisleProductList[i]
            if aisle.RequireLicense and not ESX.PlayerData.WeaponLicense then
                Items:AddButton(aisle.Label, nil, { RightBadge = RageUI.BadgeStyle.Lock }, function(onSelected)
                    if onSelected then
                        Config.Notification(_U("need_license"))
                    end
                end)
            else
                Items:AddButton(aisle.Label, nil, { RightLabel = "→" }, function(onSelected)
                    if onSelected then
                        FoltoneAmmunation.AisleSelected = i
                    end
                end, aisleMenuAmmunation)
            end
        end
    end, function(Panels)
    end)
    aisleMenuAmmunation:IsVisible(function(Items)
        for i = 1, #Config.AisleProductList[FoltoneAmmunation.AisleSelected] do
            local item = Config.AisleProductList[FoltoneAmmunation.AisleSelected][i]
            Items:AddButton(item.label, nil, { RightLabel = string.format("~g~%s$", item.price) }, function(onSelected)
                if onSelected then
                    TriggerServerEvent("foltone_ammunation:buyItem", item.type, item.name, item.price)
                end
            end)
        end
    end, function(Panels)
    end)
end

CreateThread(function()
    while not ESX.PlayerLoaded do
        Wait(500)
    end

    RequestModel(GetHashKey(Config.PedModel))
    while not HasModelLoaded(GetHashKey(Config.PedModel)) do
        Wait(500)
    end
    for i = 1, #Config.AmmunationsList do
        local ammunation = Config.AmmunationsList[i]
        local ped = CreatePed(4, GetHashKey(Config.PedModel), ammunation.x, ammunation.y, ammunation.z, ammunation.w, false, true)
        SetBlockingOfNonTemporaryEvents(ped, 1)
        FreezeEntityPosition(ped, true)
        local blip = AddBlipForCoord(ammunation.x, ammunation.y, ammunation.z)
        SetBlipSprite(blip, Config.AmmunationBlip.id)
        SetBlipScale(blip, Config.AmmunationBlip.scale)
        SetBlipColour(blip, Config.AmmunationBlip.color)
        SetBlipDisplay(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.AmmunationBlip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    while true do
        wait = 750
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerScoping = IsPlayerFreeAiming(PlayerId())
        for i = 1, #Config.AmmunationsList do
            local ammunation = Config.AmmunationsList[i]
            local distance = #(playerCoords - vector3(ammunation.x, ammunation.y, ammunation.z))
            if distance <= 2.0 and not open then
                wait = 0
                Config.DisplayHelpText(_U("press_to_ammunation"))
                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback("esx_license:checkLicense", function(hasLicense)
                        if hasLicense then
                            ESX.PlayerData.WeaponLicense = true
                        else
                            ESX.PlayerData.WeaponLicense = false
                        end
                        RageUI.Visible(menuAmmunation, not RageUI.Visible(menuAmmunation))
                        AmmunationSelected = i
                        open = true
                    end, GetPlayerServerId(PlayerId()), "weapon")
                end
            elseif distance > 2.0 and open and AmmunationSelected == i then
                wait = 0
                RageUI.CloseAll()
                open = false
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    ESX.PlayerLoaded = true
end)
RegisterNetEvent("foltone_ammunation:notification")
AddEventHandler("foltone_ammunation:notification", function(message)
    Config.Notification(message)
end)
