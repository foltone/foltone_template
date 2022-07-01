function SetData()
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(players, player)
    end

    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~b~foltone~s~ V2 - ~b~ID : ~s~" .. id .. " ~b~Discord :~s~ discord.gg/X9ReemrhKh")
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        SetData()
    end
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_LEAVE", "~r~Se déconnecter de foltone~s~")
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_QUIT", "~r~Quitter FiveM")
end)