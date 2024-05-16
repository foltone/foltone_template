ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_ammunation:boughtLicense", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("money").money >= Config.LicensePrice then
        xPlayer.removeAccountMoney("money", Config.LicensePrice)
        TriggerEvent("esx_license:addLicense", source, "weapon")
        TriggerClientEvent("foltone_ammunation:notification", source, _U("bought", _U("weapon_license"), Config.LicensePrice))
        cb(true)
    else
        TriggerClientEvent("foltone_ammunation:notification", source, _U("not_enough_money"))
        cb(false)
    end
end)

RegisterServerEvent("foltone_ammunation:buyItem")
AddEventHandler("foltone_ammunation:buyItem", function(type, name, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getAccount("money").money >= price then
        if type == "weapon" then
            if xPlayer.hasWeapon(name) then
                TriggerClientEvent("foltone_ammunation:notification", _source, _U("already_have_this_weapon", ESX.GetWeaponLabel(name)))
                return
            end
            xPlayer.addWeapon(name, 12)
            TriggerClientEvent("foltone_ammunation:notification", _source, _U("bought", ESX.GetWeaponLabel(name), price))
        elseif xPlayer.canCarryItem(name, 1) then
            xPlayer.addInventoryItem(name, 1)
            TriggerClientEvent("foltone_ammunation:notification", _source, _U("bought", ESX.GetItemLabel(item), price))
        else
            TriggerClientEvent("foltone_ammunation:notification", _source, _U("not_enough_space"))
            return
        end
    else
        TriggerClientEvent("foltone_ammunation:notification", _source, _U("not_enough_money"))
    end
end)
