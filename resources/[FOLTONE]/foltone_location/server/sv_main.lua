ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_location:rentVehicle", function(source, cb, price, pay)
    local xPlayer = ESX.GetPlayerFromId(source)
    if pay == 1 then
        if xPlayer.getAccount("money").money >= price then
            xPlayer.removeAccountMoney("money", price)
            cb(true)
        else
            cb(false)
        end
    elseif pay == 2 then
        if xPlayer.getAccount("bank").money >= price then
            xPlayer.removeAccountMoney("bank", price)
            cb(true)
        else
            cb(false)
        end
    end
end)
