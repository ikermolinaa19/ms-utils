ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function SetRP()
    local name = GetPlayerName(PlayerId())
    local players = ESX.Game.GetPlayers()
    local jugadores = 0
    for k,v in ipairs(players) do
      jugadores = jugadores + 1
    end
    SetRichPresence(jugadores.. " jugadores")
    SetDiscordAppId('1093667881146917044')
    SetDiscordRichPresenceAsset('paraisoroleplay')
    SetDiscordRichPresenceAssetText('Paraiso RP')
    SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/")
end

Citizen.CreateThread(function()

    SetRP()

    while true do
        Citizen.Wait(2500)
        SetRP()
    end

end)