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
local transferer = RageUI.CreateSubMenu(MenuBanque, "Transférer", "MENU")

portefeuille = 0
compte = 0
iban2 = nil
montant2 = nil

function RageUI.PoolMenus:Foltone()
    
    MenuBanque:IsVisible(function(Items)
        Items:AddSeparator("IBAN : "..GetPlayerServerId(PlayerId()))
        Items:AddSeparator("Argent liquide : ~g~"..portefeuille.."$")
        Items:AddSeparator("Argent banque : ~g~"..compte.."$")

        Items:AddButton("Déposer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, deposer)
        Items:AddButton("Retirer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, retirer)
        Items:AddButton("Transférer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, transferer)
    end, function(Panels)
    end)
    
    deposer:IsVisible(function(Items)
        Items:AddButton("Personnalisé", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local depose = KeyboardInput("Montant à déposer :", "", 8)
                depose = tonumber(depose)
                TriggerServerEvent('deposer', depose)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~1000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                depose = 1000
                TriggerServerEvent('deposer', depose)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~2500$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                depose = 2500
                TriggerServerEvent('deposer', depose)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~5000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                depose = 5000
                TriggerServerEvent('deposer', depose)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
	end, function()
	end)
    retirer:IsVisible(function(Items)
        Items:AddButton("Personnalisé", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local retire = KeyboardInput("Montant à retirer :", "", 8)
                retire = tonumber(retire)
                TriggerServerEvent('foltone_banque:retirer', retire)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~1000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                retire = 1000
                TriggerServerEvent('foltone_banque:retirer', retire)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~2500$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                retire = 2500
                TriggerServerEvent('foltone_banque:retirer', retire)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
        Items:AddButton("~g~5000$", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                retire = 5000
                TriggerServerEvent('foltone_banque:retirer', retire)
                TriggerServerEvent("foltone_banque:pf", fct)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
	end, function()
	end)
    transferer:IsVisible(function(Items)
        Items:AddButton("IBAN : ", nil, {RightLabel = ibanf, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local iban = KeyboardInput("IBAN (ID) du destinataire", "", 4)
                if iban == nil then
                    ESX.ShowNotification("IBAN Invalide")
                else
                    iban2 = tonumber(iban)
                    ibanf = "~b~"..iban2..""
                end
            end
        end)
        Items:AddButton("Montant : ~g~", nil, {RightLabel = montantf, IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local montant = KeyboardInput("Montant à transférer", "", 8)
                if montant == nil then
                    ESX.ShowNotification("Montant Invalide")
                else
                    montant2 = tonumber(montant)
                    montantf = "~g~"..montant2.."$"
                end
            end
        end)
        Items:AddButton("Valider", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent('transfere', iban2, montant2)
                TriggerServerEvent("foltone_banque:banque", fct)
            end
        end)
	end, function()
	end)
end


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

RegisterNetEvent("foltone_banque:portefeuille") AddEventHandler("foltone_banque:portefeuille", function(money, cash) portefeuille = tonumber(money) end)
RegisterNetEvent("foltone_banque:compte") AddEventHandler("foltone_banque:compte", function(money, cash) compte = tonumber(money) end)


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
