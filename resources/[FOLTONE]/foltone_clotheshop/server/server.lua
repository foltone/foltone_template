ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_clotheshop:pay", function(source, cb, name, clothes)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("money").money >= Config.PriceSaveClothes then
        xPlayer.removeAccountMoney("money", Config.PriceSaveClothes)
        MySQL.Async.execute("INSERT INTO user_clothes (identifier, name, clothes) VALUES (@identifier, @name, @clothes) ON DUPLICATE KEY UPDATE clothes = @clothes", {
            ["@identifier"] = xPlayer.identifier,
            ["@name"] = name,
            ["@clothes"] = json.encode(clothes)
        }, function(rowsChanged)
            cb(true, _U("new_clothes_saved", name))
        end)
    else
        cb(false, _U("not_enough_money"))
    end
end)

ESX.RegisterServerCallback("foltone_clotheshop:haveAmount", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount("money").money >= Config.PriceSaveClothes then
        xPlayer.removeAccountMoney("money", Config.PriceSaveClothes)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("foltone_clotheshop:delete", function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM user_clothes WHERE identifier = @identifier AND id = @id", {
        ["@identifier"] = xPlayer.identifier,
        ["@id"] = id
    }, function(rowsChanged)
        cb(_U("clothes_deleted"))
    end)
end)

ESX.RegisterServerCallback("foltone_clotheshop:rename", function(source, cb, id, name, newName)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("UPDATE user_clothes SET name = @newName WHERE identifier = @identifier AND id = @id", {
        ["@identifier"] = xPlayer.identifier,
        ["@id"] = id,
        ["@newName"] = newName
    }, function(rowsChanged)
        cb(_U("clothes_renamed", name, newName))
    end)
end)

ESX.RegisterServerCallback("foltone_clotheshop:getClothes", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM user_clothes WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local data = {}
            for i = 1, #result, 1 do
                table.insert(data, {
                    ["id"] = result[i].id,
                    ["name"] = result[i].name,
                    ["clothes"] = json.decode(result[i].clothes)
                })
            end
            cb(data)
        else
            cb({})
        end
    end)
end)
