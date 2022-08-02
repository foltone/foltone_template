local personalf5 = {
	ItemSelected = {},
	ItemIndex = {},
	WeaponData = {},
	Ped = PlayerPedId(),
	billing = {},
	bank = nil,
    sale = nil,
	handsUp = false,
}

local accounts = {}

local PlayerProps = {}

local societymoney, societymoney2 = nil, nil

local weight = {}

local stylevide = { BackgroundColor={255, 255, 255, 0}, Line = {250, 250 ,250, 250}, Line2 = {250, 250 ,250, 250}}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()

	RefreshMoney()

	personalf5.WeaponData = ESX.GetWeaponList()

	for i = 1, #personalf5.WeaponData, 1 do
		if personalf5.WeaponData[i].name == 'WEAPON_UNARMED' then
			personalf5.WeaponData[i] = nil
		else
			personalf5.WeaponData[i].hash = GetHashKey(personalf5.WeaponData[i].name)
		end
	end
	personalf5.Menu = false
end)


----- menu f5 ---

local Foltonef5 = RageUI.CreateMenu("Menu Interaction", 'Menu F5');
Foltonef5.EnableMouse = false;

local inventaire = RageUI.CreateSubMenu(Foltonef5, "Inventaire", "Inventaire")
local inventaireselec = RageUI.CreateSubMenu(inventaire, "Gestion", "Gestion")

local armes = RageUI.CreateSubMenu(Foltonef5, "Armes", "Armes")
local armesselec = RageUI.CreateSubMenu(armes, "Gestion", "Gestion")

local portefeuille = RageUI.CreateSubMenu(Foltonef5, "Portefeuille", "Portefeuille")
local facture = RageUI.CreateSubMenu(portefeuille, "Facture", "Facture")
local papiers = RageUI.CreateSubMenu(portefeuille, "Papiers", "Papiers")
local gestionsos = RageUI.CreateSubMenu(portefeuille, "Societé", "Societe")
local liquide = RageUI.CreateSubMenu(portefeuille, "Gestion", "Gestion")
local sale = RageUI.CreateSubMenu(portefeuille, "Gestion", "Gestion")

local vehicule = RageUI.CreateSubMenu(Foltonef5, "Vehicule", "Vehicule")
local apparenceveh = RageUI.CreateSubMenu(vehicule, "Gestion", "Gestion")
local porte = RageUI.CreateSubMenu(apparenceveh, "Porte", "Porte")
local fenetre = RageUI.CreateSubMenu(apparenceveh, "Fenetre", "Fenetre")
local extra = RageUI.CreateSubMenu(apparenceveh, "Extra", "Extra")
local limitateur = RageUI.CreateSubMenu(vehicule, "Limitateur", "Limitateur")

local vetementaccessoire = RageUI.CreateSubMenu(Foltonef5, "Vetement", "Vetement | Accessoire")
local vetement = RageUI.CreateSubMenu(vetementaccessoire, "Vetement", "Vetement")
local accessoire = RageUI.CreateSubMenu(vetementaccessoire, "Accessoire", "Accessoire")

--------------- Event ---------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('foltone:Weapon_addAmmoToPedC')
AddEventHandler('foltone:Weapon_addAmmoToPedC', function(value, quantity)
  local weaponHash = GetHashKey(value)

    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
end)


function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
  
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    	Citizen.Wait(500)
    end
  
    if UpdateOnscreenKeyboard() ~= 2 then
    	local result = GetOnscreenKeyboardResult()
    	Citizen.Wait(500)
    	return result
    else
    	Citizen.Wait(500)
    	return nil
    end
end

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
		end
	end
end)

function CheckQuantity(number)
	number = tonumber(number)
  
	if type(number) == 'number' then
	  number = ESX.Math.Round(number)
  
	  if number > 0 then
		return true, number
	  end
	end
  
	return false, number
end

--------------- fin event ---------------


Keys.Register("F5", "F5", "Test", function()
	ESX.TriggerServerCallback('foltone:getWeight', function(playerWeight)
		print(playerWeight)
		weight = playerWeight
	end)
	RefreshMoney()
	RageUI.Visible(Foltonef5, not RageUI.Visible(Foltonef5))
end)

function RageUI.PoolMenus:Example()
	Foltonef5:IsVisible(function(Items)

		-- Items:AddButton("Inventaire", nil, {Color = {HightLightColor = { 255, 255, 255, 255}}, {BackgroundColor ={ 255, 255, 255, 255}}, RightLabel = ">", IsDisabled = false }, function(onSelected)
	
		-- end, inventaire)
		Items:AddSeparator("~b~Votre ID : ~o~"..GetPlayerServerId(PlayerId()))

		Items:AddButton("Inventaire", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, inventaire)

		Items:AddButton("Armes", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, armes)

		Items:AddButton("Portefeuille", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, portefeuille)

		Items:AddButton("Vehicule", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, vehicule)

		Items:AddButton("Vetement | Accessoire", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, vetementaccessoire)

	end, function(Panels)
	end)

--------------- inventaire ---------------
	inventaire:IsVisible(function(Items)
		ESX.TriggerServerCallback('foltone:getWeight', function(playerWeight)
			weight = playerWeight
		end)
		Items:AddSeparator("~b~Poids : ~r~"..weight..'Kg ~s~/ ~r~'..ESX.PlayerData.maxWeight..'Kg')

		ESX.PlayerData = ESX.GetPlayerData()
		local countInventaire = 0;
		for i = 1, #ESX.PlayerData.inventory do
			if ESX.PlayerData.inventory[i].count > 0 then
				countInventaire = countInventaire + ESX.PlayerData.inventory[i].count
				Items:AddButton('[~b~' ..ESX.PlayerData.inventory[i].count.. '~s~] - ~s~' ..ESX.PlayerData.inventory[i].label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						personalf5.ItemSelected = ESX.PlayerData.inventory[i]
					end
				end, inventaireselec)
			end
		end
		if countInventaire == 0 then
			RageUI.Line(stylevide, "~r~Inventaire vide")
		end
	end, function()
	end)

	inventaireselec:IsVisible(function(Items)
		Items:AddButton("Utiliser", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if personalf5.ItemSelected.usable then
					TriggerServerEvent('esx:useItem', personalf5.ItemSelected.name)
				else
					ESX.ShowNotification("L'items n'est pas utilisable")
				end
			end
		end)
		Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				local sonner,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez donner", "Nombres d'items que vous voulez donner", '', 10))
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				local pPed = GetPlayerPed(-1)
				local coords = GetEntityCoords(pPed)
				local x,y,z = table.unpack(coords)
				DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
				if sonner then
					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)
						if IsPedOnFoot(closestPed) then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', personalf5.ItemSelected.name, quantity)
							else
								ESX.ShowNotification("Nombres d'items invalid!")
							end
					else
						ESX.ShowNotification("Aucun joueur proche!")
					end
				end
			end
		end)
		Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if personalf5.ItemSelected.canRemove then
					local post,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez jeter", "Nombres d'items que vous voulez jeter", '', 10))
					if post then
						if not IsPedSittingInAnyVehicle(PlayerPed) then
							TriggerServerEvent('esx:removeInventoryItem', 'item_standard', personalf5.ItemSelected.name, quantity)
						end
					end
				end
			end
		end)
	end, function()
	end)
--------------- fin inventaire ---------------

--------------- armes ---------------
	armes:IsVisible(function(Items)
		for i = 1, #personalf5.WeaponData, 1 do
			if HasPedGotWeapon(PlayerPedId(), personalf5.WeaponData[i].hash, false) then
				local ammo = GetAmmoInPedWeapon(PlayerPedId(), personalf5.WeaponData[i].hash);
				if ammo == 0 then
					ammo = ammo + 1
				end
				Items:AddButton('[~b~' ..ammo.. '~s~] - ~s~' ..personalf5.WeaponData[i].label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						personalf5.ItemSelected = personalf5.WeaponData[i]
					end
				end, armesselec)
			end
		end
	end, function()
	end)

	armesselec:IsVisible(function(Items)
		Items:AddButton("Donner des munition", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				local post, quantity = CheckQuantity(KeyboardInput('Nombre de munitions', 'Nombre de munitions'), '', 10)
				if post then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)
						local pPed = GetPlayerPed(-1)
						local coords = GetEntityCoords(pPed)
						local x,y,z = table.unpack(coords)
						DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)

						if IsPedOnFoot(closestPed) then
							local ammo = GetAmmoInPedWeapon(personalf5.Ped, personalf5.ItemSelected.hash)

							if ammo > 0 then
								if quantity <= ammo and quantity >= 0 then
									local finalAmmo = math.floor(ammo - quantity)
									SetPedAmmo(personalf5.Ped, personalf5.ItemSelected.name, finalAmmo)

									TriggerServerEvent('foltone:Weapon_addAmmoToPedS', GetPlayerServerId(closestPlayer), personalf5.ItemSelected.name, quantity)
									ESX.ShowNotification('Vous avez donné '..quantity..' munitions à : '..closestPlayer, quantity, GetPlayerName(closestPlayer))
								else
									ESX.ShowNotification('Vous ne possédez pas autant de munitions')
								end
							else
								ESX.ShowNotification("Vous n'avez pas de munition")
							end
						else
							ESX.ShowNotification('Vous ne pouvez pas donner des munitions dans un véhicule', personalf5.ItemSelected.label)
						end
					else
						ESX.ShowNotification('Aucun joueur proche !')
					end
				else
					ESX.ShowNotification('Nombre de munition invalid')
				end
			end
		end)
		Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestDistance ~= -1 and closestDistance <= 3 then
					local closestPed = GetPlayerPed(closestPlayer)
					local pPed = GetPlayerPed(-1)
					local coords = GetEntityCoords(pPed)
					local x,y,z = table.unpack(coords)
					DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
			
					if IsPedOnFoot(closestPed) then
						local ammo = GetAmmoInPedWeapon(personalf5.Ped, personalf5.ItemSelected.hash)
						TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', personalf5.ItemSelected.name, ammo)
					else
						ESX.ShowNotification('Impossible de donner une arme dans un véhicule', personalf5.ItemSelected.label)
					end
				else
					ESX.ShowNotification('Aucun joueur proche !')
				end
			end
		end)
		Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if IsPedOnFoot(personalf5.Ped) then
					TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', personalf5.ItemSelected.name)
					--RageUI.CloseAll()
				else
					ESX.ShowNotification("Impossible de jeter l'armes dans un véhicule", mpersonalf5enu.ItemSelected.label)
				end
			end
		end)
	end, function()
	end)
--------------- fin armes ---------------

--------------- porte feuille ---------------
	portefeuille:IsVisible(function(Items)

		if ESX.PlayerData.job.label ~= nil then
			Items:AddSeparator("~b~Métier : ~o~"..ESX.PlayerData.job.label)
		end

		Items:AddButton("Facture", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, facture)

		Items:AddButton("Papiers", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		end, papiers)

		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
			Items:AddButton("Gestion societé : ~o~"..ESX.PlayerData.job.label, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			end, gestionsos)
		end
		
		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'bank'  then
				Items:AddButton("Banque : ~b~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = "", IsDisabled = false }, function(onSelected)
				end)
			end
			if ESX.PlayerData.accounts[i].name == 'money'  then
				Items:AddButton("Liquide : ~g~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, liquide)
			end
			if ESX.PlayerData.accounts[i].name == 'black_money'  then
				Items:AddButton("Sale : ~r~".. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. "$", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, sale)
			end
		end
		
	end, function()
	end)

	facture:IsVisible(function(Items)
		ESX.TriggerServerCallback('VInventory:billing', function(bills) personalf5.billing = bills end)
		if #personalf5.billing == 0 then
			RageUI.Line(stylevide, "~r~Aucune facture")
		end
		for i = 1, #personalf5.billing, 1 do
			Items:AddButton(personalf5.billing[i].label, nil, { RightLabel = '[~g~$' .. ESX.Math.GroupDigits(personalf5.billing[i].amount.."~s~] →"), IsDisabled = false }, function(onSelected)
				if (onSelected) then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
					ESX.TriggerServerCallback('VInventory:billing', function(bills) personalf5.billing = bills end)
					end, personalf5.billing[i].id)
				end
			end)
		end
	end, function()
	end)

	papiers:IsVisible(function(Items)
		Items:AddList("Carte d'identitée", Papier.liste, Papier.carteidentite.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				Papier.carteidentite.Index = Index;
			end
			if (onSelected) then
				Papier.carteidentite[Index]()
			end
		end)
		Items:AddList("Permis de conduire", Papier.liste, Papier.permis.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				Papier.permis.Index = Index;
			end
			if (onSelected) then
				Papier.permis[Index]()
			end
		end)
		Items:AddList("Permis de port d'arme", Papier.liste, Papier.ppa.Index, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				Papier.ppa.Index = Index;
			end
			if (onSelected) then
				Papier.ppa[Index]()
			end
		end)
	end, function()
	end)
	
	gestionsos:IsVisible(function(Items)
		if societymoney ~= nil then
			Items:AddSeparator("Societé : ~o~"..societymoney.."$")
		end
		Items:AddButton("Recruter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification('Aucun joueur proche')
					else
						TriggerServerEvent('foltone:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
					end
				else
					ESX.ShowNotification('Vous n\'avez pas les droits')
				end
			end
		end)
	
		Items:AddButton("virer", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification('Aucun joueur proche')
					else
						TriggerServerEvent('foltone:Boss_virerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification('Vous n\'avez pas les droits')
				end
			end
		end)
	
		Items:AddButton("Promouvoir", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification('Aucun joueur proche')
					else
						TriggerServerEvent('foltone:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
				end
				else
					ESX.ShowNotification('Vous n\'avez pas les droits')
				end
			end
		end)
	
		Items:AddButton("Destituer", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
			if (onSelected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification('Aucun joueur proche')
					else
						TriggerServerEvent('foltone:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification('Vous n\'avez pas les droits')
				end
			end
		end)
	end, function()
	end)

	liquide:IsVisible(function(Items)
		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'money' then
				Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local money, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", "Somme d'argent que vous voulez donner", '', 10))
							if money then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)
		
							if not IsPedSittingInAnyVehicle(closestPed) then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
							else
							   ESX.ShowNotification('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles')
							end
						else
						   ESX.ShowNotification('Aucun joueur proche !')
						end
						else
						ESX.ShowNotification('Somme invalid')
						end
					end
				end)
			end
		end
		
		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'money' then
				Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local money, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", "Somme d'argent que vous voulez jeter", '', 10))
						if money then
							if not IsPedSittingInAnyVehicle(PlayerPed) then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
							else
								ESX.ShowNotification('Vous pouvez pas jeter de l\'argent')
							end
						else
							ESX.ShowNotification('Somme Invalid')
						end
					end
				end)
			end
		end
	end, function()
	end)

	sale:IsVisible(function(Items)
		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'black_money' then
				Items:AddButton("Donner", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", "Somme d'argent que vous voulez donner", '', 10))
							if black then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)
	
							if not IsPedSittingInAnyVehicle(closestPed) then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
								--RageUI.CloseAll()
							else
							   ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
							end
						else
						   ESX.ShowNotification('Aucun joueur proche !')
						end
						else
							ESX.ShowNotification('Somme invalid')
						end
					end
				end)
			end
		end
	
		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'black_money' then
				Items:AddButton("Jeter", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", "Somme d'argent que vous voulez jeter", '', 10))
						if black then
							if not IsPedSittingInAnyVehicle(PlayerPed) then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
						-- RageUI.CloseAll()
							else
								ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
							end
						else
							ESX.ShowNotification('Somme Invalid')
						end
					end
				end)
			end
		end
	end, function()
	end)

--------------- fin porte feuille ---------------

--------------- vehicule ---------------
	vehicule:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
				Items:AddButton("Gestion apparence", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, apparenceveh)
				Items:AddButton("Limitateur", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, limitateur)
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

	apparenceveh:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
				Items:AddButton("Porte", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, porte)
				Items:AddButton("Fenêtre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, fenetre)
				Items:AddButton("Extra", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				end, extra)
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

	porte:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
				if vehicle.angledoor(0) then 
					Items:AddButton("~r~Fermé~s~ la porte avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(0)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ la porte avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(0)
						end
					end)
				end
				if vehicle.angledoor(1) then 
					Items:AddButton("~r~Fermé~s~ la porte avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(1)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ la porte avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(1)
						end
					end)
				end
				if vehicle.angledoor(2) then 
					Items:AddButton("~r~Fermé~s~ la porte arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(2)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ la porte arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(2)
						end
					end)
				end
				if vehicle.angledoor(3) then 
					Items:AddButton("~r~Fermé~s~ la porte arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(3)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ la porte arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(3)
						end
					end)
				end
				if vehicle.angledoor(4) then 
					Items:AddButton("~r~Fermé~s~ le capot", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(4)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ le capot", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(4)
						end
					end)
				end
				if vehicle.angledoor(5) then 
					Items:AddButton("~r~Fermé~s~ le coffre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.closedoor(5)
						end
					end)
				else
					Items:AddButton("~g~Ouvrir~s~ le coffre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
						if (onSelected) then
							vehicle.opendoor(5)
						end
					end)
				end
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

	fenetre:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
			Items:AddButton("~g~Descendre~s~ la fenêtre avant gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					vehicle.downwindo(0)
				end
			end)
			Items:AddButton("~g~Descendre~s~ la fenêtre avant droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					vehicle.downwindo(1)
				end
			end)
			Items:AddButton("~g~Descendre~s~ la fenêtre arrière gauche", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					vehicle.downwindo(2)
				end
			end)
			Items:AddButton("~g~Descendre~s~ la fenêtre arrière droite", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					vehicle.downwindo(3)
				end
			end)

			Items:AddButton("~r~Monter~s~ toute les fenetres", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					vehicle.upwindo(0)
					vehicle.upwindo(1)
					vehicle.upwindo(2)
					vehicle.upwindo(3)
				end
			end)
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

	extra:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
				for i = 1, 9 do
					if DoesExtraExist(pVeh, i) then
						if IsVehicleExtraTurnedOn(pVeh, i) then
							Items:AddButton("~r~Désactiver~s~ l'extra " .. i, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
								if (onSelected) then
									SetVehicleExtra(pVeh, i, true)
								end
							end)
						else
							Items:AddButton("~g~Activer~s~ l'extra " .. i, nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
								if (onSelected) then
									SetVehicleExtra(pVeh, i, false)
								end
							end)
						end
					end
				end
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

	limitateur:IsVisible(function(Items)
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		CarSpeed = GetEntitySpeed(plyVehicle) * 3.6
		if pInVeh then
			local pVeh = GetVehiclePedIsIn(pPed, false)
			local isInRightSeat = GetPedInVehicleSeat(pVeh, -1) == pPed
			if isInRightSeat then
				Items:AddButton("Limitation ~o~personalisé", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local speedlimit = KeyboardInput("Rentrer une vitesse", "Rentrer une vitesse")
						if speedlimit ~= "" then
							SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speedlimit/3.7)
						end
					end
				end)
				Items:AddButton("Limitation ~g~30km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 8.1)
					end
				end)
				Items:AddButton("Limitation ~g~50km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 13.7)
					end
				end)
				Items:AddButton("Limitation ~g~80km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 22.0)
					end
				end)
				Items:AddButton("Limitation ~g~120km/h", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 33.0)
					end
				end)
				Items:AddButton("~r~Désactiver la limitation", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
					if (onSelected) then
						SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
					end
				end)
			else
				RageUI.Line(stylevide, "~r~Vous devez etre conducteur d'un vehicule")
			end
		else
			RageUI.Line(stylevide, "~r~Vous n'etes pas dans un vehicule")
		end
	end, function()
	end)

--------------- fin vehicule ---------------

--------------- vetement accessoire ---------------

vetementaccessoire:IsVisible(function(Items)
	Items:AddButton("Vetement", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
		end
	end, vetement)
	Items:AddButton("Accessoire", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
		end
	end, accessoire)
end, function()
end)

vetement:IsVisible(function(Items)
	Items:AddButton("Heau", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingtie', 'try_tie_negative_a');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.torso_1 ~= skin2.torso_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['tshirt_1'] = skin1.tshirt_1, ['tshirt_2'] = skin1.tshirt_2, ['torso_1'] = skin1.torso_1, ['torso_2'] = skin1.torso_2, ['arms'] = skin1.arms});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 15, ['torso_2'] = 0, ['arms'] = 15});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Gilet Par-Balles", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingtie', 'try_tie_negative_a');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.bproof_1 ~= skin2.bproof_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['bproof_1'] = skin1.bproof_1, ['bproof_2'] = skin1.bproof_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['bproof_1'] = 0, ['bproof_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Calque", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingtie', 'try_tie_negative_a');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.decals_1 ~= skin2.decals_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['decals_1'] = skin1.decals_1, ['decals_2'] = skin1.decals_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['decals_1'] = -1, ['decals_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Bras", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('missmic4', 'michael_tux_fidget');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.arms ~= skin2.arms then
						TriggerEvent('skinchanger:loadClothes', skin2, {['arms'] = skin1.arms});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['arms'] = 15});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Pantalon", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('re@construction', 'out_of_breath');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.pants_1 ~= skin2.pants_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['pants_1'] = skin1.pants_1, ['pants_2'] = skin1.pants_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['pants_1'] = 21, ['pants_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Chaussures", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('random@domestic', 'pickup_low');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.sex == 0 then
						if skin1.shoes_1 ~= skin2.shoes_1 then
							TriggerEvent('skinchanger:loadClothes', skin2, {['shoes_1'] = skin1.shoes_1, ['shoes_2'] = skin1.shoes_2});
						else
							TriggerEvent('skinchanger:loadClothes', skin2, {['shoes_1'] = 34, ['shoes_2'] = 0});
						end
					else
						if skin1.shoes_1 ~= skin2.shoes_1 then
							TriggerEvent('skinchanger:loadClothes', skin2, {['shoes_1'] = skin1.shoes_1, ['shoes_2'] = skin1.shoes_2});
						else
							TriggerEvent('skinchanger:loadClothes', skin2, {['shoes_1'] = 35, ['shoes_2'] = 0});
						end
					end
				end)
			end)
		end
	end)
end, function()
end)

accessoire:IsVisible(function(Items)
	Items:AddButton("Chapeau", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('missheist_agency2ahelmet', 'take_off_helmet_stand');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.helmet_1 ~= skin2.helmet_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['helmet_1'] = skin1.helmet_1, ['helmet_2'] = skin1.helmet_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['helmet_1'] = -1, ['helmet_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Mask", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('mp_masks@standard_car@ds@', 'put_on_mask');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.mask_1 ~= skin2.mask_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['mask_1'] = skin1.mask_1, ['mask_2'] = skin1.mask_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['mask_1'] = 0, ['mask_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Oreille", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('mp_cp_stolen_tut', 'b_think');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.ears_1 ~= skin2.ears_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['ears_1'] = skin1.ears_1, ['ears_2'] = skin1.ears_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['ears_1'] = -1, ['ears_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Lunette", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingspecs', 'take_off');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.glasses_1 ~= skin2.glasses_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['glasses_1'] = skin1.glasses_1, ['glasses_2'] = skin1.glasses_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['glasses_1'] = 0, ['glasses_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Chaine", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingtie', 'try_tie_negative_a');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.chain_1 ~= skin2.chain_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['chain_1'] = skin1.chain_1, ['chain_2'] = skin1.chain_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['chain_1'] = 0, ['chain_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Bracelets", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('nmt_3_rcm-10', 'cs_nigel_dual-10');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.bracelets_1 ~= skin2.bracelets_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['bracelets_1'] = skin1.bracelets_1, ['bracelets_2'] = skin1.bracelets_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['bracelets_1'] = -1, ['bracelets_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Montre", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('nmt_3_rcm-10', 'cs_nigel_dual-10');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.watches_1 ~= skin2.watches_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['watches_1'] = skin1.watches_1, ['watches_2'] = skin1.watches_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['watches_1'] = -1, ['watches_2'] = 0});
					end
				end)
			end)
		end
	end)
	Items:AddButton("Sac", nil, { RightLabel = ">", IsDisabled = false }, function(onSelected)
		if (onSelected) then
			startAnimation('clothingtie', 'try_tie_neutral_a');
			Citizen.Wait(1000);
			ClearPedTasks(PlayerPedId());
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin1)
				TriggerEvent('skinchanger:getSkin', function(skin2)
					if skin1.bags_1 ~= skin2.bags_1 then
						TriggerEvent('skinchanger:loadClothes', skin2, {['bags_1'] = skin1.bags_1, ['bags_2'] = skin1.bags_2});
					else
						TriggerEvent('skinchanger:loadClothes', skin2, {['bags_1'] = 0, ['bags_2'] = 0});
					end
				end)
			end)
		end
	end)
end, function()
end)
--------------- fin vetement accessoire ---------------

end

--------------- porte feuille ---------------

Papier = {
    liste = {
        'Regarder',
        'Montrer'
    },
    carteidentite =  {

        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId())) end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		    if closestDistance ~= -1 and closestDistance <= 3.0 then
		        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
		    else
			    ESX.ShowNotification("Aucun joueur a proximité")
		    end
        end
    },
    permis = {
        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
            else
                ESX.ShowNotification("Aucun joueur a proximité")
            end
        end,
    },
    ppa = {
        Index = 1,
        [1] = function()TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')end,
        [2] = function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification("Aucun joueur a proximité")
            end
        end,
    },
}

--------------- fin porte feuille ---------------

--------------- vehicule ---------------

local limit, speedLimitActive, door, hood, chest = "Aucune Limitation", false, 1, 1, 1

function angledoor(arg)
	return GetVehicleDoorAngleRatio(vehicle.currentVehicle(), arg) > 0.0
end

vehicle = {

    ped = function()
        return GetPlayerPed(-1)
    end,

    currentVehicle = function()
        return GetVehiclePedIsIn(GetPlayerPed(-1), false)
    end,

    Temp = function ()
         return GetVehicleEngineTemperature(vehicle.currentVehicle())
    end,

    Health = function ()
        return GetVehicleEngineHealth(vehicle.currentVehicle())
    end,

    vehicleOn = function ()
        return SetVehicleEngineOn(vehicle.currentVehicle(), true, false, true)
    end,
    
    vehicleOff = function ()
        return SetVehicleEngineOn(vehicle.currentVehicle(), false, false, true)
    end,

    Oil = function ()
        return GetVehicleOilLevel(vehicle.currentVehicle())
    end,

    vehicleengine = function ()
        return GetIsVehicleEngineRunning(vehicle.currentVehicle())
    end,
    

    pedinvehicle = function()
        return  IsPedSittingInAnyVehicle( vehicle.ped() )
    end,

    angledoor = function(arg)
        return GetVehicleDoorAngleRatio(vehicle.currentVehicle(), arg) > 0.0
        
    end,

    opendoor = function(arg)
        return SetVehicleDoorOpen(vehicle.currentVehicle(), arg, false)
    end,

    closedoor = function(arg)
        return SetVehicleDoorShut(vehicle.currentVehicle(), arg, false)
    end,

    downwindo = function(arg)
          window = RollDownWindow(vehicle.currentVehicle(),arg) 
    end,

    upwindo = function(arg)
        return RollUpWindow(vehicle.currentVehicle(),arg)
    end,
}

--------------- fin vehicule ---------------

--------------- vetement accessoire ---------------

function startAnimation(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

--------------- fin vetement accessoire ---------------
