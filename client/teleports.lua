ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local teleportMarkers = {
    {
        name = "[E] Concesionario VIP",
        origin = vector3(-1362.2573, -472.1020, 31.5957), 
        destination = vector3(-1388.3496, -484.3169, 77.2001),
    },
    {
        name = "[E] Salir a la calle",
        origin = vector3(-1388.3496, -484.3169, 78.2001),
        destination = vector3(-1362.2573, -472.1020, 30.5957), 
    }
}

local lastHelpNotificationTime = 0 -- nueva variable

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, marker in ipairs(teleportMarkers) do
            local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), marker.origin, true)
            if PlayerPedId() and IsPedOnFoot(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), false) and dist < 1.5 then
                DrawMarker(1, marker.origin.x, marker.origin.y, marker.origin.z-0.99, 0, 0, 0, 0, 0, 0, 1.75, 1.75, 0.1, 255, 255, 255, 200, 0, 1, 0, 1, 0, 0, 0)
                local currentTime = GetGameTimer() -- nueva línea
                if IsControlJustPressed(1, 38) then
                    SetEntityCoords(PlayerPedId(), marker.destination.x, marker.destination.y, marker.destination.z)
                    Citizen.Wait(500)
                    DrawMarker(1, marker.destination.x, marker.destination.y, marker.destination.z-0.99, 0, 0, 0, 0, 0, 0, 1.75, 1.75, 0.1, 255, 255, 255, 200, 0, 1, 0, 1, 0, 0, 0)
                else
                    if currentTime - lastHelpNotificationTime >= 1000 then -- actualizado
                        ESX.ShowHelpNotification(marker.name)
                        lastHelpNotificationTime = currentTime
                    end
                end
            elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), marker.destination, true) < 4.6 then
                DrawMarker(1, marker.destination.x, marker.destination.y, marker.destination.z-0.99, 0, 0, 0, 0, 0, 0, 1.75, 1.75, 0.1, 255, 255, 255, 200, 0, 1, 0, 1, 0, 0, 0)
            else
                DrawMarker(1, marker.origin.x, marker.origin.y, marker.origin.z-0.99, 0, 0, 0, 0, 0, 0, 1.75, 1.75, 0.1, 255, 255, 255, 200, 0, 0, 0, 1, 0, 0, 0)
            end
        end
    end
end)
