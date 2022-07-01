ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local MenuAmunation = RageUI.CreateMenu("", 'Amunation', nil, nil, "foltone", "amu");
local item = RageUI.CreateSubMenu(MenuAmunation, "Item", "Item")
local armeblanche = RageUI.CreateSubMenu(MenuAmunation, "Armes blanches", "Armes blanches")
local arme = RageUI.CreateSubMenu(MenuAmunation, "Armes", "Armes")

local ListIndex = 1;
local ListPay = {
    "Liquide",
    "Banque",
}
local Trigger = 'foltone:achatliquide'
local Trigger2 = 'foltone:achatliquide2'

ppa = false

function RageUI.PoolMenus:FoltoneAmunation()
	MenuAmunation:IsVisible(function(Items)
        Items:AddList("Mode de paiement", ListPay, ListIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				ListIndex = Index;
			end
            if (Index) == 1 then
                Trigger = 'foltone:achatliquide'
                Trigger2 = 'foltone:achatliquide2'
            end
            if (Index) == 2 then
                Trigger = 'foltone:achatbanque'
                Trigger2 = 'foltone:achatbanque2'
            end
		end)
        Items:AddButton("Item", nil, { IsDisabled = false }, function(onSelected)
        end, item)
        Items:AddButton("Armes blanches", nil, { IsDisabled = false }, function(onSelected)
        end, armeblanche)
        ESX.TriggerServerCallback('foltone:checkppa', function(cb)            
            if cb then
                ppa = true 
            else 
                ppa = false   
            end
        end)
        if ppa then
            Items:AddButton("Armes", nil, { IsDisabled = false }, function(onSelected)
            end, arme)
        else
            Items:AddButton("Armes", "vous devez posséder un permis", { IsDisabled = true }, function(onSelected)
            end, arme)
        end
	end, function(Panels)
	end)
    item:IsVisible(function(Items)
        for k, v in pairs(FoltoneAmunation.ItemsList) do
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
    end, function()
    end)
    armeblanche:IsVisible(function(Items)
        for k, v in pairs(FoltoneAmunation.ArmesBlancheList) do
            Items:AddButton(v.Label, nil, {RightLabel = "~g~"..v.Price.."$", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent(Trigger2, v)
                end
            end)
        end
    end, function()
    end)
    arme:IsVisible(function(Items)
        for k, v in pairs(FoltoneAmunation.ArmesList) do
            Items:AddButton(v.Label, nil, {RightLabel = "~g~"..v.Price.."$", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    TriggerServerEvent(Trigger2, v)
                end
            end)
        end
    end, function()
    end)
end

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneAmunation.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distance <= 2.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~r~[E]~s~ pour parler à ~r~l'armurier", 1) 
                if IsControlJustPressed(1, 51) then
					RageUI.Visible(MenuAmunation, not RageUI.Visible(MenuAmunation))
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
    DecorRegister("Yay", 4)
    PedAmunation = nil
    function LoadModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(500)
		end
	end
	for k, v in pairs(FoltoneAmunation.Position) do
        --ped
        LoadModel("cs_josef")
        PedAmunation = CreatePed(2, GetHashKey("cs_josef"), v.x, v.y, v.z, v.h, 0, 0)
        DecorSetInt(PedAmunation, "Yay", 5431)
        FreezeEntityPosition(PedAmunation, 1)
        TaskStartScenarioInPlace(PedAmunation, "WORLD_HUMAN_CLIPBOARD", 0, false)
        SetEntityInvincible(PedAmunation, true)
        SetBlockingOfNonTemporaryEvents(PedAmunation, 1)
	
        --blip
		local BlipAmunation = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipAmunation, 110)
		SetBlipScale (BlipAmunation, 0.75)
		SetBlipColour(BlipAmunation, 1)
		SetBlipAsShortRange(BlipAmunation, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Amunation')
		EndTextCommandSetBlipName(BlipAmunation)
	end
end)