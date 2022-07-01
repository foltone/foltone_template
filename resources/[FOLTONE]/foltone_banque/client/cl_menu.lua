ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        local target, distance = ESX.Game.GetClosestPlayer()


		Citizen.Wait(500)
	end

end)

local MenuBanque = RageUI.CreateMenu("Banque", 'Banque');
local deposer = RageUI.CreateSubMenu(MenuBanque, "Déposer", "MENU")
local retirer = RageUI.CreateSubMenu(MenuBanque, "Retirer", "MENU")

local accounts = {}

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
		end
	end
end)

function RageUI.PoolMenus:Foltone()
    
    MenuBanque:IsVisible(function(Items)
        for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'bank'  then
                Items:AddSeparator("Banque : ~b~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$")
			end
			if ESX.PlayerData.accounts[i].name == 'money'  then
                Items:AddSeparator("Liquide : ~g~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$")
			end
		end

        Items:AddButton("Déposer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, deposer)
        Items:AddButton("Retirer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, retirer)
    end, function(Panels)
    end)
    
    deposer:IsVisible(function(Items)
        Items:AddButton("Personnalisé", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local sommeDepose = KeyboardInput("Montant à déposer :", "", 8)
                sommeDepose = tonumber(sommeDepose)
                if sommeDepose > 0 then
                    TriggerServerEvent("foltone_banque:deposer", sommeDepose)
                else
                    ESX.ShowNotification("Somme Invalide")
                end
            end
        end)
        Items:AddButton("~g~1000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeDepose = 1000
                TriggerServerEvent("foltone_banque:deposer", sommeDepose)
            end
        end)
        Items:AddButton("~g~2500$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeDepose = 2500
                TriggerServerEvent("foltone_banque:deposer", sommeDepose)
            end
        end)
        Items:AddButton("~g~5000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeDepose = 5000
                TriggerServerEvent("foltone_banque:deposer", sommeDepose)
            end
        end)
	end, function()
	end)
    retirer:IsVisible(function(Items)
        Items:AddButton("Personnalisé", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local sommeRetire = KeyboardInput("Montant à retirer :", "", 8)
                sommeRetire = tonumber(sommeRetire)
                TriggerServerEvent('foltone_banque:retirer', sommeRetire)
            end
        end)
        Items:AddButton("~g~1000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeRetire = 1000
                TriggerServerEvent('foltone_banque:retirer', sommeRetire)
            end
        end)
        Items:AddButton("~g~2500$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeRetire = 2500
                TriggerServerEvent('foltone_banque:retirer', sommeRetire)
            end
        end)
        Items:AddButton("~g~5000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                sommeRetire = 5000
                TriggerServerEvent('foltone_banque:retirer', sommeRetire)
            end
        end)
	end, function()
	end)
end

Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneBanque.PositionBanque) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distance <= 1.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour accéder à la ~g~banque", 1) 
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("foltone_banque:pf", fct)
                    TriggerServerEvent("foltone_banque:banque", fct)
					RageUI.Visible(MenuBanque, not RageUI.Visible(MenuBanque))
                end
            elseif distance < 5 then
                RageUI.CloseAll()
            end
        end
        for k, v in pairs(FoltoneBanque.PositionATM) do
			local distanceatm = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distanceatm <= 1.0 then
				wait = 0
				ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour accéder à ~g~l'atm", 1) 
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("foltone_banque:pf", fct)
                    TriggerServerEvent("foltone_banque:banque", fct)
					RageUI.Visible(MenuBanque, not RageUI.Visible(MenuBanque))
                end
            elseif distanceatm < 5 then
                RageUI.CloseAll()
            end
        end
        Citizen.Wait(wait)
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
 AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ' :')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
            
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        blockinput = false
        return nil
    end
end

Citizen.CreateThread(function()
	for k, v in pairs(FoltoneBanque.PositionBanque) do
		local BlipBanque = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipBanque, 108)
		SetBlipScale (BlipBanque, 0.8)
		SetBlipColour(BlipBanque, 2)
		SetBlipAsShortRange(BlipBanque, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Banque')
		EndTextCommandSetBlipName(BlipBanque)
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(FoltoneBanque.PositionATM) do
		local BlipAtm = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipAtm, 108)
		SetBlipScale (BlipAtm, 0.3)
		SetBlipColour(BlipAtm, 2)
		SetBlipAsShortRange(BlipAtm, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('ATM')
		EndTextCommandSetBlipName(BlipAtm)
	end
end)
