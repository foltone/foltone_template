ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("foltone_banque:deposer")
AddEventHandler("foltone_banque:deposer", function(somme)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= somme then
        xPlayer.removeMoney(somme)
        xPlayer.addAccountMoney('bank', somme)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', 'Fleeca Bank', "Vous avez déposé ~g~"..somme.."$", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)

RegisterServerEvent("foltone_banque:retirer")
AddEventHandler("foltone_banque:retirer", function(somme)
    local xPlayer = ESX.GetPlayerFromId(source)
    local BanqueJoueur = xPlayer.getAccount("bank").money
    if BanqueJoueur >= somme then
        xPlayer.removeAccountMoney('bank', somme)
        xPlayer.addMoney(somme)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque', 'Fleeca Bank', "Vous avez retiré ~g~"..somme.."$", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez d'argent en banque!", '', 'CHAR_BLOCKED', 9)
    end
end)
