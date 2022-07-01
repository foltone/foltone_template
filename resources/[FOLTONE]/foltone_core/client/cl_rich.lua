Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(976919124112466000)
		SetDiscordRichPresenceAsset('polia')
        SetDiscordRichPresenceAssetText('foltone template')
        SetDiscordRichPresenceAssetSmall('polia')
        SetDiscordRichPresenceAssetSmallText('foltone template')
		SetDiscordRichPresenceAction(0, "Discord", "https://discord.com/invite/X9ReemrhKh")
        --SetDiscordRichPresenceAction(1, "Se connecter", "fivem://connect/cfx.re/join/")
		Citizen.Wait(500)
	end
end)