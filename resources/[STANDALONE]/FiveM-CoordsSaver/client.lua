
RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = ""..coords.x..", "..coords.y..", "..coords.z..""
	})
end)


RegisterCommand('coordsxyz', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = "x = "..coords.x..", y = "..coords.y..", z = "..coords.z..""
	})
end)

RegisterCommand('coordsh', function(source, args, rawCommand)
	local coords = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		coords = "h = "..coords
	})
end)