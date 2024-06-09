Config = {
    Locale = "fr",

    PriceSaveClothes = 5000,
    PriceBuyHelmet = 500,
    PriceBuyGlasses = 500,
    PriceBuyEars = 500,
    PriceBuyMask = 500,

    ClothesShopPositions = {
        vector3(72.25, -1399.10, 29.37),
        vector3(-703.77, -152.25, 37.41),
        vector3(-167.86, -298.96, 39.73),
        vector3(428.69, -800.10, 29.49),
        vector3(-829.41, -1073.71, 11.32),
        vector3(-1447.79, -242.46, 49.82),
        vector3(11.63, 6514.22, 30.87),
        vector3(123.64, -219.44, 54.56),
        vector3(1696.29, 4829.31, 42.06),
        vector3(618.09, 2759.62, 42.09),
        vector3(1190.55, 2713.44, 38.22),
        vector3(-1193.42, -772.26, 17.32),
        vector3(-3172.49, 1048.13, 10.86),
        vector3(-1108.44, 2708.92, 19.11)
    },

    HelmetPositions = {
        vector3(81.49, -1400.59, 29.38),
        vector3(-705.77, -158.90, 37.41),
        vector3(-161.30, -295.69, 39.74),
        vector3(419.29, -800.59, 29.48),
        vector3(-824.30, -1081.69, 11.33),
        vector3(-1454.80, -242.89, 49.81),
        vector3(4.69, 6520.89, 31.89),
        vector3(120.99, -223.19, 54.55),
        vector3(1689.59, 4818.79, 42.07),
        vector3(613.89, 2749.89, 42.09),
        vector3(1189.50, 2703.89, 38.23),
        vector3(-1204.00, -774.39, 17.32),
        vector3(-3164.21, 1054.71, 20.87),
        vector3(-1103.10, 2700.50, 19.12)
    },

    GlassesPositions = {
        vector3(75.20, -1391.10, 29.39),
        vector3(-713.10, -160.10, 37.41),
        vector3(-156.10, -300.50, 39.74),
        vector3(425.40, -807.80, 29.50),
        vector3(-820.80, -1072.90, 11.33),
        vector3(-1458.00, -236.70, 49.80),
        vector3(3.50, 6511.50, 31.89),
        vector3(131.30, -212.30, 54.55),
        vector3(1694.90, 4820.80, 42.07),
        vector3(613.90, 2768.80, 42.09),
        vector3(1198.60, 2711.00, 38.23),
        vector3(-1188.20, -764.50, 17.33),
        vector3(-3173.10, 1038.20, 20.87),
        vector3(-1100.40, 2712.40, 19.12)
    },

    EarsPositions = {
        vector3(80.30, -1389.40, 29.39),
        vector3(-163.00, -301.99, 39.73),
        vector3(420.70, -809.60, 29.50),
        vector3(-817.00, -1075.90, 11.33),
        vector3(-1451.30, -238.20, 49.82),
        vector3(-0.70, 6513.60, 31.89),
        vector3(123.40, -207.99, 54.55),
        vector3(1687.30, 4827.60, 42.07),
        vector3(622.80, 2749.20, 42.09),
        vector3(1199.99, 2705.40, 38.23),
        vector3(-1199.90, -782.50, 17.34),
        vector3(-3171.80, 1059.60, 20.87),
        vector3(-1095.60, 2709.20, 19.11)
    },

    MaskPosition = {
        vector3(-1337.03, -1277.39, 4.87),
    },

    BannerDictionary = "shopui_title_lowendfashion2",
    BannerName = "shopui_title_lowendfashion2",

    BlipClotheShop = {
        Sprite = 73,
        Color = 47,
        Scale = 0.8,
        Display = 4,
        Name = "Magasin de vêtements"
    },

    BlipMask = {
        Sprite = 362,
        Color = 2,
        Scale = 0.8,
        Display = 4,
        Name = "Magasin de masques"
    },

    Notification = function(message)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(false, false)
    end,
    DisplayText = function(text)
        SetTextComponentFormat("STRING")
        AddTextComponentString(text)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end,
    Marker = function(position, radius)
        DrawMarker(1, position.x, position.y, position.z - 1.0, 0, 0, 0, 0, 0, 0, radius * 2.0, radius * 2.0, 0.3, 243, 156, 18, 200, false, true, 2, false, nil, nil, false)
    end
}
