Config = {
    Locale = "fr",

    Price = 75,

    BarberShopPositions = {
        vector3(-821.66, -186.88, 37.56),
        vector3(133.79, -1710.73, 29.29),
        vector3(-1286.89, -1116.39, 6.99),
        vector3(1933.14, 3726.11, 32.84),
        vector3(1208.80, -470.87, 66.20),
        vector3(-30.73, -148.62, 57.07),
        vector3(-280.50, 6231.64, 31.69)
    },

    Blip = {
        Sprite = 71,
        Color = 47,
        Scale = 0.8,
        Display = 4,
        Name = "Barber Shop"
    },

    Notification = function(message)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
}
