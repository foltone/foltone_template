ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("foltone_tattooshop:getPlayerTattoos", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.getIdentifier()
    }, function(result)
        if result[1] then
            cb(json.decode(result[1].tattoos))
        else
            cb({})
        end
    end)
end)

RegisterServerEvent("foltone_tattooshop:buyTattoo")
AddEventHandler("foltone_tattooshop:buyTattoo", function(tattoos, price)
    local _source = source
    if price ~= Config.Price then
        DropPlayer(_source, "Cheater")
        return
    end
    local positionFound = false
    for k, v in pairs(Config.TattooShopPositions) do
        if #(vector3(v.x, v.y, v.z) - GetEntityCoords(GetPlayerPed(_source))) < 2.0 then
            positionFound = true
            break
        end
    end
    if not positionFound then
        DropPlayer(_source, "Cheater")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= Config.Price then
        xPlayer.removeMoney(Config.Price)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.getIdentifier()
        }, function(result)
            if result[1] then
                MySQL.Async.execute("UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier", {
                    ["@identifier"] = xPlayer.getIdentifier(),
                    ["@tattoos"] = json.encode(tattoos)
                })
            else
                MySQL.Async.execute("INSERT INTO users (identifier, tattoos) VALUES (@identifier, @tattoos)", {
                    ["@identifier"] = xPlayer.getIdentifier(),
                    ["@tattoos"] = json.encode(tattoos)
                })
            end
        end)
        TriggerClientEvent("foltone_tattooshop:notification", _source, Trad("you_bought_tattoo", Config.Price))
    else
        DropPlayer(_source, "Cheater")
    end
end)

RegisterServerEvent("foltone_tattooshop:removeTattoo")
AddEventHandler("foltone_tattooshop:removeTattoo", function(tattoos)
    local _source = source
    local positionFound = false
    for k, v in pairs(Config.TattooShopPositions) do
        if #(vector3(v.x, v.y, v.z) - GetEntityCoords(GetPlayerPed(_source))) < 2.0 then
            positionFound = true
            break
        end
    end
    if not positionFound then
        DropPlayer(_source, "Cheater")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.execute("UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.getIdentifier(),
        ["@tattoos"] = json.encode(tattoos)
    })
    TriggerClientEvent("foltone_tattooshop:notification", _source, Trad("you_removed_tattoo"))
end)
