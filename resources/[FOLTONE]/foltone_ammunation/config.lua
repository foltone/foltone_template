Config = {
	Locale = "fr",

	PedModel = "cs_josef",

	AmmunationBlip = {
		id = 110,
		color = 1,
		scale = 0.8,
		label = "Ammunation",
	},

	LicensePrice = 5000,

	AisleProductList = {
		[1] = {
			Label = "Stabbing weapon",
			RequireLicense = false,
			{
				name = "weapon_knife",
				label = "Knife",
				price = 1000,
				type = "weapon",
			},
			{
				name = "weapon_switchblade",
				label = "Switchblade",
				price = 1500,
				type = "weapon",
			},
			{
				name = "weapon_golfclub",
				label = "Golf club",
				price = 3500,
				type = "weapon",
			},
		},
		[2] = {
			Label = "Pistol",
			RequireLicense = true,
			{
				name = "weapon_pistol",
				label = "Pistol",
				price = 5000,
				type = "weapon",
			},
			{
				name = "weapon_combatpistol",
				label = "Combat pistol",
				price = 7500,
				type = "weapon",
			},
			{
				name = "weapon_appistol",
				label = "AP pistol",
				price = 10000,
				type = "weapon",
			},
		},
		[3] = {
			Label = "Munitions",
			RequireLicense = false,
			{
				name = "bread",
				label = "Bread",
				price = 500,
				type = "item",
			},
			{
				name = "clip_pistol",
				label = "Pistol clip",
				price = 500,
				type = "item",
			},
			{
				name = "clip_rifle",
				label = "Rifle clip",
				price = 1000,
				type = "item",
			},
			{
				name = "clip_shotgun",
				label = "Shotgun clip",
				price = 1500,
				type = "item",
			},
		},
	},

	AmmunationsList = {
		vector4(-3173.287109375, 1089.1707763672, 19.838724136353, 245.00),
		vector4(2566.9833984375, 292.4499206543, 107.73484802246, 0.00),
		vector4(23.563344955444, -1105.8112792969, 28.797029495239, 155.00),
		vector4(253.70231628418, -51.294452667236, 68.941055297852, 80.00),
		vector4(-330.99523925781, 6085.7470703125, 30.454765319824, 222.00),
		vector4(1692.9166259766, 3761.7578125, 33.70531463623, 225.00),
		vector4(-661.47637939453, -933.38336181641, 20.829214096069, 175.00),
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
