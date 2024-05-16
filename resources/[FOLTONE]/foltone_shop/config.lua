Config = {
	Locale = "fr",

	PedModel = "mp_m_shopkeep_01",

	ShopBlip = {
		id = 52,
		color = 2,
		scale = 0.8,
		label = "Superette",
	},

	AisleProductList = {
		[1] = {
			Label = "Foods",
			{
				name = "bread",
				label = "Bain",
				price = 5,
			},
			{
				name = "chips",
				label = "Chips",
				price = 5,
			},
			{
				name = "chocolate",
				label = "Chocolate",
				price = 5,
			},
			{
				name = "sandwich",
				label = "Sandwich",
				price = 5,
			},
			{
				name = "hamburger",
				label = "Hamburger",
				price = 5,
			},
			{
				name = "donut",
				label = "Donut",
				price = 5,
			}
		},
		[2] = {
			Label = "Soda",
			{
				name = "water",
				label = "Water",
				price = 5,
			},
			{
				name = "cola",
				label = "Cola",
				price = 5,
			},
			{
				name = "milk",
				label = "Milk",
				price = 5,
			},
			{
				name = "coffee",
				label = "Coffee",
				price = 5,
			},
			{
				name = "tea",
				label = "Tea",
				price = 5,
			},
			{
				name = "icetea",
				label = "Ice Tea",
				price = 5,
			},
			{
				name = "orangejuice",
				label = "Orange Juice",
				price = 5,
			},
			{
				name = "applejuice",
				label = "Apple Juice",
				price = 5,
			},
			{
				name = "energyjuice",
				label = "Energy Juice",
				price = 5,
			}
		},
		[3] = {
			Label = "Alcool",
			{
				name = "beer",
				label = "Beer",
				price = 5,
			},
			{
				name = "vodka",
				label = "Vodka",
				price = 5,
			},
			{
				name = "wine",
				label = "Wine",
				price = 5,
			},
			{
				name = "whisky",
				label = "Whisky",
				price = 5,
			},
			{
				name = "rhum",
				label = "Rhum",
				price = 5,
			},
			{
				name = "tequila",
				label = "Tequila",
				price = 5,
			}
		},
		[4] = {
			Label = "Others",
			{
				name = "cigarette",
				label = "Cigarette",
				price = 5,
			},
			{
				name = "lighter",
				label = "Lighter",
				price = 5,
			},
			{
				name = "phone",
				label = "Phone",
				price = 5,
			},
		},
	},

	ShopsList = {
		{ position = vector4(24.34, -1345.39, 28.49, 270.00), type = "24/7" },
		{ position = vector4(372.92, 328.22, 102.56, 250.00), type = "24/7" },
		{ position = vector4(2555.28, 380.81, 107.62, 0.00), type = "24/7" },
		{ position = vector4(-3040.61, 583.87, 6.90, 10.00), type = "24/7" },
		{ position = vector4(-3244.21, 1000.03, 11.83, 350.00), type = "24/7" },
		{ position = vector4(549.38, 2669.43, 41.15, 95.00), type = "24/7" },
		{ position = vector4(1959.13, 3741.43, 31.34, 300.00), type = "24/7" },
		{ position = vector4(2676.51, 3280.14, 54.24, 328.00), type = "24/7" },
		{ position = vector4(1728.55, 6416.79, 34.03, 245.00), type = "24/7" },
		{ position = vector4(1134.06, -982.82, 45.41, 275.00), type = "24/7" },
		{ position = vector4(-1221.68, -908.30, 11.32, 30.00), type = "24/7" },
		{ position = vector4(-1486.55, -377.76, 39.16, 135.00), type = "24/7" },
		{ position = vector4(-2966.32, 391.18, 14.04, 85.00), type = "24/7" },
		{ position = vector4(1165.55, 2710.91, 37.15, 180.00), type = "24/7" },
		{ position = vector4(1392.58, 3606.36, 33.98, 200.00), type = "24/7" },
		{ position = vector4(-47.51, -1758.79, 28.42, 48.00), type = "ltd" },
		{ position = vector4(1164.96, -324.00, 68.20, 97.00), type = "ltd" },
		{ position = vector4(-705.95, -914.82, 18.21, 90.00), type = "ltd" },
		{ position = vector4(-1819.31, 793.28, 137.08, 130.00), type = "ltd" },
		{ position = vector4(1697.01, 4923.58, 41.06, 325.00), type = "ltd" },
	},

	Notification = function (text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(false, false)
	end,
	AddvancedNotification = function (title, subject, msg, icon, iconType)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(msg)
		SetNotificationMessage(icon, icon, true, iconType, title, subject)
		DrawNotification(false, true)
	end,
	DisplayHelpText = function (text)
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end,
}
