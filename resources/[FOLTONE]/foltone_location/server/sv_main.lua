ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_location:rentVehicle", function(source, cb, price, pay)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        if pay == 1 then
            xPlayer.removeMoney(price)
            cb(true)
        elseif pay == 2 then
            xPlayer.removeAccountMoney("bank", price)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)
