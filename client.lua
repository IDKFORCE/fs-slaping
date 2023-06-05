local QBCore = exports['qb-core']:GetCoreObject()

local VolumeOfTheSlap = 0.1

function getPlayers()
    local playerList = {}
    for i = 0, 256 do
        local player = GetPlayerFromServerId(i)
        if NetworkIsPlayerActive(player) then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function getNearPlayer()
    local players = getPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterNetEvent('fs-slaping:SyncOn_Client')
AddEventHandler('fs-slaping:SyncOn_Client', function(playerNetId)
    local lCoords = GetEntityCoords(PlayerPedId())
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if (distIs <= 2.0001) then
        SendNUIMessage({
            slapsound     = 'slapsound',
            VolumeOfTheSlap   = VolumeOfTheSlap
        })
    end
end)

RegisterNetEvent('fs-slaping:SyncAnimation')
AddEventHandler('fs-slaping:SyncAnimation', function(playerNetId)
    Wait(250)
    TriggerServerEvent("fs-slaping:SyncOn_Server")
    SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, 0, 0, 0)
    QBCore.Functions.Notify('You have just been slapped..', 'success')
end)

function ChargementAnimation(donnees)
    while (not HasAnimDictLoaded(donnees)) do 
        RequestAnimDict(donnees)
        Wait(5)
    end
end

CreateThread(function()
    local player = PlayerPedId()
    while true do
      Wait(0)
      if IsControlPressed(1, 21) and IsControlJustPressed(1, 47) then -- shift + G
        local target, distance = getNearPlayer()
        if distance > 0 and distance < 2 then
          if IsPedArmed(player, 7) then
            SetCurrentPedWeapon(player, GetHashKey('WEAPON_UNARMED'), true)
          end
          if not IsEntityDead(player) then
            ChargementAnimation("melee@unarmed@streamed_variations")
            TaskPlayAnim(player, "melee@unarmed@streamed_variations", "plyr_takedown_front_slap", 8.0, 1.0, 1500, 1, 0, 0, 0, 0)
            TriggerServerEvent("fs-slaping:SyncGiffle", GetPlayerServerId(target))
          end
        else
          QBCore.Functions.Notify('There Is Nobody Near By..', 'error')
        end
      end
    end
  end)