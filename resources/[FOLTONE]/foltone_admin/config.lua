Config = {
    Locale = "fr",

    UseFoltoneSanction = false, -- https://forum.cfx.re/t/paid-standlone-admin-command-ban-kick-jail-fr-en/5157088

    openKey = "F10", -- F10

    teleport_list = {
        { name = "Police Station", coords = vector3(432.2, -981.8, 30.7) },
        { name = "Hospital", coords = vector3(296.8, -583.9, 43.1) },
        { name = "Mechanic", coords = vector3(-350.5, -133.5, 39.0) },
    },

    moneyTypes = {
        ["money"] = {
            label = "Cash",
            name = "money",
        },
        ["bank"] = {
            label = "Dirty Cash",
            name = "bank",
        },
        ["blackmoney"] = {
            label = "Black Money",
            name = "black_money",
        },
    },

    CallESX = function()
        ESX = exports["es_extended"]:getSharedObject()
    end,
    Notification = function(msg)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
}
