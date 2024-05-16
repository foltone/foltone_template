ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_bank:getPlayerAccounts", function(source, cb)
    cb(ESX.GetPlayerFromId(source).xPlayer.getAccounts())
end)

ESX.RegisterServerCallback("foltone_bank:withdrawMoney", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("bank").money >= amount then
        xPlayer.removeAccountMoney("bank", amount)
        xPlayer.addAccountMoney("money", amount)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("foltone_bank:depositMoney", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("money").money >= amount then
        xPlayer.removeAccountMoney("money", amount)
        xPlayer.addAccountMoney("bank", amount)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("foltone_bank:transferMoney", function(source, cb, amount, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local players = ESX.GetPlayers()
    local targetPlayer = nil
    for i = 1, #players do
        if players[i] == target then
            targetPlayer = ESX.GetPlayerFromId(target)
            break
        end
    end
    if targetPlayer then
        if xPlayer.getAccount("bank").money >= amount then
            xPlayer.removeAccountMoney("bank", amount)
            targetPlayer.addAccountMoney("bank", amount)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)
