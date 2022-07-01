ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('foltone_location:AchatLiquide')
AddEventHandler('foltone_location:AchatLiquide', function(model, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= (price) then
        xPlayer.removeMoney(price)
        TriggerClientEvent("foltone_location:achatconfirme", _source, model)
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Information!', 'Banque', '~g~Achat effectué!', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Information!', "Banque", "~r~Pas assez de liquide!", 'CHAR_BLOCKED', 9)
    end
end)


RegisterServerEvent('foltone_location:AchatBanque')
AddEventHandler('foltone_location:AchatBanque', function(model, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local ArgentBanque = xPlayer.getAccount("bank").money
    if ArgentBanque >= (price) then
        xPlayer.removeAccountMoney("bank", price)
        TriggerClientEvent("foltone_location:achatconfirme", _source, model)
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', _source, 'Information!', "~r~Pas assez d'argent en banque!", '', 'CHAR_BLOCKED', 9)
    end
end)