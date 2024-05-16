ESX = exports["es_extended"]:getSharedObject()

local listPlaceTake = {}

ESX.RegisterServerCallback("foltone_barbershop:check_place_enable", function(source, cb, chair)
    local enable = true
    for k, v in pairs(listPlaceTake) do
        if v == chair then
            enable = false
        end
    end
    cb(enable)
end)

ESX.RegisterServerCallback("foltone_barbershop:pay", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.Price then
        xPlayer.removeMoney(Config.Price)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("foltone_barbershop:get_place")
AddEventHandler("foltone_barbershop:get_place", function(chair)
    table.insert(listPlaceTake, chair)
end)

RegisterServerEvent("foltone_barbershop:remove_place")
AddEventHandler("foltone_barbershop:remove_place", function(chair)
    for k, v in pairs(listPlaceTake) do
        if v == chair then
            table.remove(listPlaceTake, k)
        end
    end
end)
