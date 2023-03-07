ESX = exports["es_extended"]:getSharedObject()

local MenuLtd = RageUI.CreateMenu("", 'LTD', nil, nil, "foltone", "ltd");
local Menu24 = RageUI.CreateMenu("", '24/7', nil, nil, "foltone", "24-7");

local ListIndex = 1;
local ListPay = {
    "Liquide",
    "Banque",
}

local Trigger = 'foltone:achatliquide'

function RageUI.PoolMenus:FoltoneShop()
    if ActiveSuperette == true then
        MenuLtd:IsVisible(function(Items)
            Items:AddList("Mode de paiement", ListPay, ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    ListIndex = Index;
                end
                if (Index) == 1 then
                    Trigger = 'foltone:achatliquide'
                end
                if (Index) == 2 then
                    Trigger = 'foltone:achatbanque'
                end
            end)
            for k, v in pairs(FoltoneSuperette.ItemsList) do
                Items:AddList(v.Label, {1,2,3,4,5,6,7,8,9,10}, v["Index"], nil, {RightLabel = "~g~"..v.Price.."$", IsDisabled = false }, function(Index, onSelected, onListChange)
                    if (onListChange) then
                        v["Index"] = Index;
                    end
                    if (Index) == Index then
                        if (onSelected) then
                            TriggerServerEvent(Trigger, v)
                        end
                    end
                end)
            end
        end, function(Panels)
        end)


        Menu24:IsVisible(function(Items)
            Items:AddList("Mode de paiement", ListPay, ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    ListIndex = Index;
                end
                if (Index) == 1 then
                    Trigger = 'foltone:achatliquide'
                end
                if (Index) == 2 then
                    Trigger = 'foltone:achatbanque'
                end
            end)
            for k, v in pairs(FoltoneSuperette.ItemsList) do
                Items:AddList(v.Label, {1,2,3,4,5,6,7,8,9,10}, v["Index"], nil, {RightLabel = "~g~"..v.Price.."$", IsDisabled = false }, function(Index, onSelected, onListChange)
                    if (onListChange) then
                        v["Index"] = Index;
                    end
                    if (Index) == Index then
                        if (onSelected) then
                            TriggerServerEvent(Trigger, v)
                        end
                    end
                end)
            end
        end, function(Panels)
        end)
    end
end


Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneSuperette.Pos24) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distance <= 2.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour parler à ~g~l'épicier", 1) 
                if IsControlJustPressed(1, 51) then
					RageUI.Visible(Menu24, not RageUI.Visible(Menu24))
                end
            elseif distance < 5 then
                RageUI.CloseAll()
            end
        end
        Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneSuperette.Posltd) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distance <= 2.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour parler à ~g~l'épicier", 1) 
                if IsControlJustPressed(1, 51) then
					RageUI.Visible(MenuLtd, not RageUI.Visible(MenuLtd))
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
    DecorRegister("Yay", 4)
    PedSuperette = nil
    function LoadModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(500)
		end
	end
	for k, v in pairs(FoltoneSuperette.Posltd) do
        --ped
        LoadModel("mp_m_shopkeep_01")
        PedSuperette = CreatePed(2, GetHashKey("mp_m_shopkeep_01"), v.x, v.y, v.z, v.h, 0, 0)
        DecorSetInt(PedSuperette, "Yay", 5431)
        FreezeEntityPosition(PedSuperette, 1)
        TaskStartScenarioInPlace(PedSuperette, "WORLD_HUMAN_CLIPBOARD", 0, false)
        SetEntityInvincible(PedSuperette, true)
        SetBlockingOfNonTemporaryEvents(PedSuperette, 1)
        --blip
		local BlipSuperette = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipSuperette, 52)
		SetBlipScale (BlipSuperette, 0.8)
		SetBlipColour(BlipSuperette, 2)
		SetBlipAsShortRange(BlipSuperette, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Superette')
		EndTextCommandSetBlipName(BlipSuperette)
	end
    for k, v in pairs(FoltoneSuperette.Pos24) do
        --ped
        LoadModel("mp_m_shopkeep_01")
        PedSuperette = CreatePed(2, GetHashKey("mp_m_shopkeep_01"), v.x, v.y, v.z, v.h, 0, 0)
        DecorSetInt(PedSuperette, "Yay", 5431)
        FreezeEntityPosition(PedSuperette, 1)
        TaskStartScenarioInPlace(PedSuperette, "WORLD_HUMAN_CLIPBOARD", 0, false)
        SetEntityInvincible(PedSuperette, true)
        SetBlockingOfNonTemporaryEvents(PedSuperette, 1)
        --blip
		local BlipSuperette = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipSuperette, 52)
		SetBlipScale (BlipSuperette, 0.8)
		SetBlipColour(BlipSuperette, 2)
		SetBlipAsShortRange(BlipSuperette, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Superette')
		EndTextCommandSetBlipName(BlipSuperette)
	end
end)