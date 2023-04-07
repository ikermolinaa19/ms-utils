local playerDistances = {}
local disPlayerNames = 10.0 -- Ajusta este valor para establecer la distancia a la que son visibles los nombres de los jugadores.
local verid = false -- Establece false si no quieres mostrar los nombres de los jugadores.
local myId = GetPlayerServerId(PlayerId()) -- Obtiene el ID del jugador local.

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("verids", function(source) 
    if verid then
        ESX.ShowNotification("Has desactivado la visión de las IDs")
        verid = false
    else
        ESX.ShowNotification("Has activado la visión de las IDs")
        verid = true
    end
end)

local function DrawText3D(position, text, r, g, b) 
    local onScreen, _x, _y = World3dToScreen2d(position.x, position.y, position.z+1)
    if not onScreen then
        return
    end
    
    local dist = #(GetGameplayCamCoords()-position)
    local fov = (1/GetGameplayCamFov())*100
    local scale = (1/dist) * 2 * fov
    
    if not useCustomScale then
        scale = scale * 0.55
    else 
        scale = scale * customScale
    end
    
    SetTextScale(0.0*scale, scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

Citizen.CreateThread(function()
    Wait(500)
    
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed and targetPed ~= PlayerPedId() then
                local distance = playerDistances[id] or #(GetEntityCoords(targetPed) - GetEntityCoords(PlayerPedId()))
                playerDistances[id] = distance
                
                if distance < disPlayerNames then
                    local targetPedCords = GetEntityCoords(targetPed)
                    
                    if NetworkIsPlayerTalking(id) then
                        DrawText3D(targetPedCords, GetPlayerServerId(id), 79,255,86)
                    elseif verid then
                        DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
                    end
                end
            end
        end
        
        -- Muestra el ID del jugador local.
        if verid then
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            DrawText3D(myCoords, myId, 255, 255, 255)
        end
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed and targetPed ~= playerPed then
                local distance = #(playerCoords - GetEntityCoords(targetPed))
                playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)