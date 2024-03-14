Config = {
	Locale = "fr",

	CallESX = function (method, args, cb)
		ESX = exports["es_extended"]:getSharedObject()
	end,

	key = "F5", -- Key to open the menu

	ShopWebSite = "https://foltone-store.tebex.io/",

	job2 = true, -- If you want to use a second job, set it to true

	speedUnit = "km/h", -- km/h or mph

	nakedSkin = {
		tshirt_1 = 15, tshirt_2 = 0,
		torso_1 = 15, torso_2 = 0,
		bproof_1 = 0, bproof_2 = 0,
		decals_1 = 0, decals_2 = 0,
		arms = 15,
		pants_1 = 61, pants_2 = 0,
		shoes_1 = 34, shoes_2 = 0,
		mask_1 = 0, mask_2 = 0,
		helmet_1 = -1, helmet_2 = 0,
		chain_1 = 0, chain_2 = 0,
		ears_1 = -1, ears_2 = 0,
		glasses_1 = 5, glasses_2 = 0,
		chain_1 = 0, chain_2 = 0,
		bproof_1 = 0, bproof_2 = 0,
		watch_1 = -1, watch_2 = 0,
		bracelets_1 = -1, bracelets_2 = 0,
		bag_1 = 0, bag_2 = 0,
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
