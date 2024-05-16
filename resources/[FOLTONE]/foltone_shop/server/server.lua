ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("foltone_shop:buyItem")
AddEventHandler("foltone_shop:buyItem", function(item, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= price then
        if xPlayer.canCarryItem(item, 1) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(item, 1)
            TriggerClientEvent("foltone_shop:notification", _source, _U("bought", ESX.GetItemLabel(item), price))
        else
            TriggerClientEvent("foltone_shop:notification", _source, _U("not_enough_space"))
        end
    else
        TriggerClientEvent("foltone_shop:notification", _source, _U("not_enough_money"))
    end
end)
