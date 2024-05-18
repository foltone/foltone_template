Config.CallESX()

local playersList = {}

RegisterServerEvent("foltone_admin_menu:healPlayer")
AddEventHandler("foltone_admin_menu:healPlayer", function(target)
    TriggerClientEvent("esx_basicneeds:healPlayer", target)
end)

ESX.RegisterServerCallback("foltone_admin_menu:getPlayers", function(source, cb)
    local players = {}
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {
            id = xPlayer.source,
            name = xPlayer.getName()
        })
    end
    cb(players)
end)

ESX.RegisterServerCallback("foltone_admin_menu:getPlayerData", function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
    local data = {
        name = xPlayer.getName(),
        job = xPlayer.getJob(),
        inventory = xPlayer.getInventory(),
        weapons = xPlayer.getLoadout(),
        money = xPlayer.getAccount(Config.moneyTypes["money"].name).money,
        bank = xPlayer.getAccount(Config.moneyTypes["bank"].name).money,
        blackmoney = xPlayer.getAccount(Config.moneyTypes["blackmoney"].name).money,
        group = xPlayer.getGroup()
    }
    cb(data)
end)

ESX.RegisterServerCallback("foltone_admin_menu:getStaffCount", function(source, cb)
    local staffCount = 0
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
            staffCount = staffCount + 1
        end
    end
    cb(staffCount)
end)

RegisterServerEvent("foltone_admin_menu:updateValues")
AddEventHandler("foltone_admin_menu:updateValues", function()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
            TriggerClientEvent("foltone_admin_menu:receiveValues", xPlayers[i])
        end
    end
end)

RegisterServerEvent("foltone_admin_menu:sendMessage")
AddEventHandler("foltone_admin_menu:sendMessage", function(target, message)
    TriggerClientEvent("foltone_admin_menu:receiveMessage", target, message)
end)

RegisterServerEvent("foltone_admin_menu:removeAccountMoney")
AddEventHandler("foltone_admin_menu:removeAccountMoney", function(target, account, money)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.removeAccountMoney(account, money)
    TriggerClientEvent("foltone_admin_menu:notification", source, _U("money_remove", money, account))
end)

RegisterServerEvent("foltone_admin_menu:giveAccountMoney")
AddEventHandler("foltone_admin_menu:giveAccountMoney", function(target, account, money)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.addAccountMoney(account, money)
    TriggerClientEvent("foltone_admin_menu:notification", source, _U("money_add", money, account))
end)

RegisterServerEvent("foltone_admin_menu:removeItem")
AddEventHandler("foltone_admin_menu:removeItem", function(target, item, count)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.removeInventoryItem(item, count)
    TriggerClientEvent("foltone_admin_menu:notification", source, _U("item_remove", count, item))
end)

RegisterServerEvent("foltone_admin_menu:giveItem")
AddEventHandler("foltone_admin_menu:giveItem", function(target, item, count)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.addInventoryItem(item, count)
    TriggerClientEvent("foltone_admin_menu:notification", source, _U("item_add", count, item))
end)

RegisterServerEvent("foltone_admin_menu:removeWeapon")
AddEventHandler("foltone_admin_menu:removeWeapon", function(target, weapon)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.removeWeapon(weapon)
    TriggerClientEvent("foltone_admin_menu:notification", source, _U("weapon_remove", weapon))
end)

local ticketsList = {}
local svTicketPermId = 0

local function addTicket(_source, message)
    svTicketPermId = svTicketPermId + 1
    local ticket = {
        permid = svTicketPermId,
        id = _source,
        name = GetPlayerName(_source),
        message = message,
        admin = 0,
        closed = false
    }
    table.insert(ticketsList, ticket)
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end

AddEventHandler("playerDropped", function(reason)
    local _source = source
    for i = 1, #ticketsList do
        if ticketsList[i].id == _source then
            table.remove(ticketsList, i)
            break
        end
    end
end)

RegisterServerEvent("foltone_admin_menu:addTicket")
AddEventHandler("foltone_admin_menu:addTicket", function(message)
    local _source = source
    local ticketId = 0
    for i = 1, #ticketsList do
        if ticketsList[i].id == _source then
            ticketId = ticketsList[i].permid
            TriggerClientEvent("foltone_admin_menu:notification", _source, _U("ticket_already_exist"))
            return
        end
    end
    addTicket(_source, message)
    TriggerClientEvent("foltone_admin_menu:notification", _source, _U("ticket_submitted"))
    if Config.UseFoltoneSanction then
        TriggerEvent("foltone_sanction:sendTicket", ticketId, message)
    end
end)

RegisterServerEvent("foltone_admin_menu:getTickets")
AddEventHandler("foltone_admin_menu:getTickets", function()
    local _source = source
    TriggerClientEvent("foltone_admin_menu:receiveTickets", _source, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:deleteTicket")
AddEventHandler("foltone_admin_menu:deleteTicket", function(id)
    for i = 1, #ticketsList do
        if ticketsList[i].permid == id then
            table.remove(ticketsList, i)
            break
        end
    end
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:takeTicket")
AddEventHandler("foltone_admin_menu:takeTicket", function(id)
    local _source = source
    for i = 1, #ticketsList do
        if ticketsList[i].permid == id then
            ticketsList[i].admin = _source
            break
        end
    end
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:giveupTicket")
AddEventHandler("foltone_admin_menu:giveupTicket", function(id)
    for i = 1, #ticketsList do
        if ticketsList[i].permid == id then
            ticketsList[i].admin = nil
            break
        end
    end
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:closeTicket")
AddEventHandler("foltone_admin_menu:closeTicket", function(id)
    for i = 1, #ticketsList do
        if ticketsList[i].permid == id then
            ticketsList[i].closed = true
            ticketsList[i].admin = nil
            break
        end
    end
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:openTicket")
AddEventHandler("foltone_admin_menu:openTicket", function(id)
    for i = 1, #ticketsList do
        if ticketsList[i].permid == id then
            ticketsList[i].closed = false
            break
        end
    end
    TriggerClientEvent("foltone_admin_menu:receiveTickets", -1, ticketsList)
end)

RegisterServerEvent("foltone_admin_menu:teleportPlayerTo")
AddEventHandler("foltone_admin_menu:teleportPlayerTo", function(player, coords)
    TriggerClientEvent("foltone_admin_menu:setPlayerCoords", player, coords)
end)

RegisterServerEvent("foltone_admin_menu:setAction")
AddEventHandler("foltone_admin_menu:setAction", function(player, action)
    if action == "revive" then
        TriggerClientEvent("foltone_admin_menu:revivePlayer", player)
    elseif action == "armor" then
        TriggerClientEvent("foltone_admin_menu:armorPlayer", player)
    elseif action == "kill" then
        TriggerClientEvent("foltone_admin_menu:killPlayer", player)
    elseif action == "freeze" then
        TriggerClientEvent("foltone_admin_menu:freezePlayer", player)
    elseif action == "unfreeze" then
        TriggerClientEvent("foltone_admin_menu:unfreezePlayer", player)
    end
end)

RegisterServerEvent("foltone_admin_menu:armorPlayer")
AddEventHandler("foltone_admin_menu:armorPlayer", function(player)
    TriggerClientEvent("foltone_admin_menu:armorPlayer", player)
end)

RegisterServerEvent("foltone_admin_menu:killPlayer")
AddEventHandler("foltone_admin_menu:killPlayer", function(player)
    TriggerClientEvent("foltone_admin_menu:killPlayer", player)
end)

RegisterServerEvent("foltone_admin_menu:freezeUnfreezePlayer")
AddEventHandler("foltone_admin_menu:freezeUnfreezePlayer", function(player)
    TriggerClientEvent("foltone_admin_menu:freezeUnfreezePlayer", player)
end)

RegisterServerEvent("foltone_admin_menu:kickPlayer")
AddEventHandler("foltone_admin_menu:kickPlayer", function(player, reason)
    DropPlayer(player, reason)
end)

RegisterServerEvent("foltone_admin_menu:banPlayer")
AddEventHandler("foltone_admin_menu:banPlayer", function(player, reason)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getGroup() == "admin" then
        TriggerEvent("BanSql:ICheat", reason, player)
    end
end)
