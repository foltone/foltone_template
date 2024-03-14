Config.CallESX()

ESX.RegisterServerCallback("foltone_f5:getPlayerData", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {
        inventory = xPlayer.getInventory(),
        weight = xPlayer.getWeight(),
        loadout = xPlayer.getLoadout(),
        bank = xPlayer.getAccount("bank").money,
        money = xPlayer.getAccount("money").money,
        black_money = xPlayer.getAccount("black_money").money,
        job_name = xPlayer.job.name,
        job_label = xPlayer.job.label,
        grade_label = xPlayer.job.grade_label,
        grade_name = xPlayer.job.grade_name,
        societyMoney = nil,
        societyMoney2 = nil,
        job2_name = nil,
        job2_label = nil,
        grade2_label = nil,
        grade2_name = nil,
        keys = nil
    }
    if Config.job2 then
        data.job2_name = xPlayer.job2.name
        data.job2_label = xPlayer.job2.label
        data.grade2_label = xPlayer.job2.grade_label
        data.grade2_name = xPlayer.job2.grade_name
    end
    cb(data)
end)

ESX.RegisterServerCallback("foltone_f5:getPlayerInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {
        inventory = xPlayer.getInventory(),
        weight = xPlayer.getWeight()
    }
    cb(data)
end)
ESX.RegisterServerCallback("foltone_f5:getPlayerLoadout", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = xPlayer.getLoadout()
    cb(data)
end)
ESX.RegisterServerCallback("foltone_f5:getPlayerMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {
        bank = xPlayer.getAccount("bank").money,
        money = xPlayer.getAccount("money").money,
        black_money = xPlayer.getAccount("black_money").money
    }
    cb(data)
end)

RegisterServerEvent("foltone_f5:destroyItem")
AddEventHandler("foltone_f5:destroyItem", function(item, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item, count)
    TriggerClientEvent("foltone_f5:notification", _source, _U("you_destroyed", count, item))
end)
RegisterServerEvent("foltone_f5:destroyWeapon")
AddEventHandler("foltone_f5:destroyWeapon", function(weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeWeapon(weapon)
    TriggerClientEvent("foltone_f5:notification", _source, _U("you_destroyed", 1, weapon))
end)

RegisterServerEvent("foltone_f5:giveAccount")
AddEventHandler("foltone_f5:giveAccount", function(account, target, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.getAccount(account).money >= amount then
        xPlayer.removeAccountMoney(account, amount)
        xTarget.addAccountMoney(account, amount)
        TriggerClientEvent("foltone_f5:advancedNotification", _source, "Maze Bank", _U("transfer"), _U("you_gave_to", amount, GetPlayerName(target)), "CHAR_BANK_MAZE", 1)
        TriggerClientEvent("foltone_f5:advancedNotification", target, "Maze Bank", _U("transfer"), _U("you_got_from", amount, GetPlayerName(_source)), "CHAR_BANK_MAZE", 1)
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_enough_money"))
    end
    local data = {
        bank = xPlayer.getAccount("bank").money,
        money = xPlayer.getAccount("money").money,
        black_money = xPlayer.getAccount("black_money").money
    }
    TriggerClientEvent("foltone_f5:refreshPlayerMoney", _source, data)
end)

RegisterServerEvent("foltone_f5:recruit")
AddEventHandler("foltone_f5:recruit", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job.grade_name == "boss" then
        local job = xPlayer.job.name
        xTarget.setJob(job, 0)
        TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("recruit"), _U("recruit"), _U("you_recruited", GetPlayerName(target)), "CHAR_SOCIAL_CLUB", 1)
        TriggerClientEvent("foltone_f5:advancedNotification", target, _U("recruit"), _U("recruit"), _U("you_have_been_recruited", job), "CHAR_SOCIAL_CLUB", 1)
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:promote")
AddEventHandler("foltone_f5:promote", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job.grade_name == "boss" then
        if xPlayer.job.name == xTarget.job.name then
            local newGrade = xTarget.job.grade + 1
            if newGrade <= xPlayer.job.grade then
                xTarget.setJob(xPlayer.job.name, newGrade)
                TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("promote"), _U("promote"), _U("you_promoted", GetPlayerName(target), xTarget.job.grade_label), "CHAR_SOCIAL_CLUB", 1)
                TriggerClientEvent("foltone_f5:advancedNotification", target, _U("promote"), _U("promote"), _U("you_have_been_promoted", xTarget.job.grade_label), "CHAR_SOCIAL_CLUB", 1)
            else
                TriggerClientEvent("foltone_f5:notification", _source, _U("max_grade"))
            end
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:demote")
AddEventHandler("foltone_f5:demote", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job.grade_name == "boss" then
        if xPlayer.job.name == xTarget.job.name then
            local newGrade = xTarget.job.grade - 1
            if newGrade >= 0 then
                xTarget.setJob(xPlayer.job.name, newGrade)
                TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("demote"), _U("demote"), _U("you_demoted", GetPlayerName(target), xTarget.job.grade_label), "CHAR_SOCIAL_CLUB", 1)
                TriggerClientEvent("foltone_f5:advancedNotification", target, _U("demote"), _U("demote"), _U("you_have_been_demoted", xTarget.job.grade_label), "CHAR_SOCIAL_CLUB", 1)
            else
                TriggerClientEvent("foltone_f5:notification", _source, _U("min_grade"))
            end
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:fire")
AddEventHandler("foltone_f5:fire", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job.grade_name == "boss" then
        if xPlayer.job.name == xTarget.job.name then
            xTarget.setJob("unemployed", 0)
            TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("fire"), _U("fire"), _U("you_fired", GetPlayerName(target)), "CHAR_SOCIAL_CLUB", 1)
            TriggerClientEvent("foltone_f5:advancedNotification", target, _U("fire"), _U("fire"), _U("you_have_been_fired"), "CHAR_SOCIAL_CLUB", 1)
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:recruit2")
AddEventHandler("foltone_f5:recruit2", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job2.grade_name == "boss" then
        local job = xPlayer.job2.name
        xTarget.setJob2(job, 0)
        TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("recruit"), _U("recruit"), _U("you_recruited", GetPlayerName(target)), "CHAR_SOCIAL_CLUB", 1)
        TriggerClientEvent("foltone_f5:advancedNotification", target, _U("recruit"), _U("recruit"), _U("you_have_been_recruited", job), "CHAR_SOCIAL_CLUB", 1)
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:promote2")
AddEventHandler("foltone_f5:promote2", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job2.grade_name == "boss" then
        if xPlayer.job2.name == xTarget.job2.name then
            local newGrade = xTarget.job2.grade + 1
            if newGrade <= xPlayer.job2.grade then
                xTarget.setJob2(xPlayer.job2.name, newGrade)
                TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("promote"), _U("promote"), _U("you_promoted", GetPlayerName(target), xTarget.job2.grade_label), "CHAR_SOCIAL_CLUB", 1)
                TriggerClientEvent("foltone_f5:advancedNotification", target, _U("promote"), _U("promote"), _U("you_have_been_promoted", xTarget.job2.grade_label), "CHAR_SOCIAL_CLUB", 1)
            else
                TriggerClientEvent("foltone_f5:notification", _source, _U("max_grade"))
            end
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:demote2")
AddEventHandler("foltone_f5:demote2", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job2.grade_name == "boss" then
        if xPlayer.job2.name == xTarget.job2.name then
            local newGrade = xTarget.job2.grade - 1
            if newGrade >= 0 then
                xTarget.setJob2(xPlayer.job2.name, newGrade)
                TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("demote"), _U("demote"), _U("you_demoted", GetPlayerName(target), xTarget.job2.grade_label), "CHAR_SOCIAL_CLUB", 1)
                TriggerClientEvent("foltone_f5:advancedNotification", target, _U("demote"), _U("demote"), _U("you_have_been_demoted", xTarget.job2.grade_label), "CHAR_SOCIAL_CLUB", 1)
            else
                TriggerClientEvent("foltone_f5:notification", _source, _U("min_grade"))
            end
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)

RegisterServerEvent("foltone_f5:fire2")
AddEventHandler("foltone_f5:fire2", function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job2.grade_name == "boss" then
        if xPlayer.job2.name == xTarget.job2.name then
            xTarget.setJob2("unemployed", 0)
            TriggerClientEvent("foltone_f5:advancedNotification", _source, _U("fire"), _U("fire"), _U("you_fired", GetPlayerName(target)), "CHAR_SOCIAL_CLUB", 1)
            TriggerClientEvent("foltone_f5:advancedNotification", target, _U("fire"), _U("fire"), _U("you_have_been_fired"), "CHAR_SOCIAL_CLUB", 1)
        else
            TriggerClientEvent("foltone_f5:notification", _source, _U("not_same_job"))
        end
    else
        TriggerClientEvent("foltone_f5:notification", _source, _U("not_boss"))
    end
end)
