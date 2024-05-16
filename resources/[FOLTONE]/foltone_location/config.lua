Config = {
	Locale = "fr",

	LocationList = {
		{
			PedModel = "a_m_y_stbla_02",
			PedPosition = vector4(-490.89, -670.71, 31.88, 180.0),
			PreviewPosition = vector4(-491.25161743164, -668.66125488281, 32.721645355225, 270.0),
			VehiclesList = {
				{ name = "Panto", model = "panto", price = 500},
				{ name = "Blista", model = "blista", price = 1000},
			},
			SpawnVehiclePositions = { -- You can add more positions if you want (the spwan vehicle where there's space)
				vector4(-487.02786254883, -668.38403320312, 32.678913116455, 270.0),
				vector4(-483.02786254883, -668.38403320312, 32.678913116455, 270.0),
				vector4(-480.02786254883, -668.38403320312, 32.678913116455, 270.0),
				vector4(-477.02786254883, -668.38403320312, 32.678913116455, 270.0),
			},
			Blip = {
				Enable = true,
				Sprite = 225,
				Color = 5,
				Scale = 0.8,
				Name = "Location",
			}
		},
	},

	CallESX = function()
		ESX = exports["es_extended"]:getSharedObject()
	end,
	Notification = function(message)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(false, false)
    end,
    AdvancedNotification = function(title, subject, msg, icon, iconType)
        SetNotificationTextEntry("STRING")
        AddTextComponentSubstringPlayerName(msg)
        SetNotificationMessage(icon, icon, false, iconType, title, subject)
        DrawNotification(false, true)
    end,
    DisplayText = function(message)
        SetTextComponentFormat("STRING")
        AddTextComponentString(message)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end,
    Marker = function(coords, r, g, b)
        DrawMarker(6, coords.x, coords.y, coords.z - 0.98, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, r, g, b, 150, false, false, 2, false, false, false, false)
    end,
}