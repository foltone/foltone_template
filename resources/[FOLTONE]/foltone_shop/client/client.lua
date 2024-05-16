ESX = exports["es_extended"]:getSharedObject()

local FoltoneShop = {
    Timout = false,
    BannerDictionary = "shopui_title_conveniencestore",
    BannerName = "shopui_title_conveniencestore",
    AisleSelected = 1,
    ShopSelected = 1
}

local function setTimout(time)
    FoltoneShop.Timout = true
    SetTimeout(time, function()
        FoltoneShop.Timout = false
    end)
end

local menuShop = RageUI.CreateMenu(nil, _U("subtitle_shop_menu"), nil, nil, FoltoneShop.BannerDictionary, FoltoneShop.BannerName);
local aisleMenuShop = RageUI.CreateSubMenu(menuShop, nil, _U("subtitle_shop_menu"), nil, nil, FoltoneShop.BannerDictionary, FoltoneShop.BannerName);
local open = false
function RageUI.PoolMenus:FoltoneShopMenu()
    function menuShop.Closed()
        open = false
    end
    menuShop:IsVisible(function(Items)
        for i = 1, #Config.AisleProductList do
            local aisle = Config.AisleProductList[i]
            Items:AddButton(aisle.Label, nil, { RightLabel = "→" }, function(onSelected)
                if onSelected then
                    FoltoneShop.AisleSelected = i
                end
            end, aisleMenuShop)
        end
    end, function(Panels)
    end)
    aisleMenuShop:IsVisible(function(Items)
        for i = 1, #Config.AisleProductList[FoltoneShop.AisleSelected] do
            local item = Config.AisleProductList[FoltoneShop.AisleSelected][i]
            Items:AddButton(item.label, nil, { RightLabel = string.format("~g~%s$", item.price) }, function(onSelected)
                if onSelected then
                    TriggerServerEvent("foltone_shop:buyItem", item.name, item.price)
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
    for i = 1, #Config.ShopsList do
        local shop = Config.ShopsList[i]
        local ped = CreatePed(4, GetHashKey(Config.PedModel), shop.position.x, shop.position.y, shop.position.z, shop.position.w, false, true)
        SetBlockingOfNonTemporaryEvents(ped, 1)
        FreezeEntityPosition(ped, true)
        local blip = AddBlipForCoord(shop.position.x, shop.position.y, shop.position.z)
        SetBlipSprite(blip, Config.ShopBlip.id)
        SetBlipScale(blip, Config.ShopBlip.scale)
        SetBlipColour(blip, Config.ShopBlip.color)
        SetBlipDisplay(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.ShopBlip.label)
        EndTextCommandSetBlipName(blip)
    end
    
    while true do
        wait = 750
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerScoping = IsPlayerFreeAiming(PlayerId())
        for i = 1, #Config.ShopsList do
            local shop = Config.ShopsList[i]
            local distance = #(playerCoords - vector3(shop.position.x, shop.position.y, shop.position.z))
            if distance <= 2.0 and not open then
                wait = 0
                Config.DisplayHelpText(_U("press_to_shop"))
                if IsControlJustPressed(0, 38) then
                    if shop.type == "24/7" then
                        FoltoneShop.BannerDictionary = "shopui_title_conveniencestore"
                        FoltoneShop.BannerName = "shopui_title_conveniencestore"
                    elseif shop.type == "ltd" then
                        FoltoneShop.BannerDictionary = "shopui_title_gasstation"
                        FoltoneShop.BannerName = "shopui_title_gasstation"
                    end
                    menuShop = RageUI.CreateMenu(nil, _U("subtitle_shop_menu"), nil, nil, FoltoneShop.BannerDictionary, FoltoneShop.BannerName);
                    aisleMenuShop = RageUI.CreateSubMenu(menuShop, nil, _U("subtitle_shop_menu"), nil, nil, FoltoneShop.BannerDictionary, FoltoneShop.BannerName);
                    RageUI.Visible(menuShop, not RageUI.Visible(menuShop))
                    ShopSelected = i
                    open = true
                end
            elseif distance > 2.0 and open and ShopSelected == i then
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
RegisterNetEvent("foltone_shop:notification")
AddEventHandler("foltone_shop:notification", function(message)
    Config.Notification(message)
end)
