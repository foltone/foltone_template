ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('foltone:achatliquide')
AddEventHandler('foltone:achatliquide', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= (item.Price*item.Index) then
		xPlayer.addInventoryItem(item.Value, item.Index, 1)
        xPlayer.removeMoney(item.Price*item.Index)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)


RegisterServerEvent('foltone:achatbanque')
AddEventHandler('foltone:achatbanque', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local BanqueJoueur = xPlayer.getAccount("bank").money
    if BanqueJoueur >= (item.Price*item.Index) then
		xPlayer.addInventoryItem(item.Value, item.Index, 1)
        xPlayer.removeAccountMoney("bank", item.Price*item.Index)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez d'argent en banque!", '', 'CHAR_BLOCKED', 9)
    end
end)


RegisterServerEvent('foltone:achatliquide2')
AddEventHandler('foltone:achatliquide2', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= (item.Price) then
		xPlayer.addWeapon(item.Value, 20)
        xPlayer.removeMoney(item.Price)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)

RegisterServerEvent('foltone:achatbanque2')
AddEventHandler('foltone:achatbanque2', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local BanqueJoueur = xPlayer.getAccount("bank").money
    if BanqueJoueur >= (item.Price) then
		xPlayer.addWeapon(item.Value, 20)
        xPlayer.removeAccountMoney("bank", item.Price)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez d'argent en banque!", '', 'CHAR_BLOCKED', 9)
    end
end)




function CheckLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

ESX.RegisterServerCallback('foltone:checkppa', function(source, cb, type)
    CheckLicense(source, 'weapon', cb)
end)