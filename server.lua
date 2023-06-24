local SYNC_ON_SERVER = 'fs-slaping:SyncOn_Server'
local SYNC_ON_CLIENT = 'fs-slaping:SyncOn_Client'
local SYNC_GIFFLE = 'fs-slaping:SyncGiffle'
local SYNC_ANIMATION = 'fs-slaping:SyncAnimation'

RegisterServerEvent(SYNC_ON_SERVER)
RegisterServerEvent(SYNC_GIFFLE)

AddEventHandler(SYNC_ON_SERVER, function()
    TriggerClientEvent(SYNC_ON_CLIENT, -1, source)
end)

AddEventHandler(SYNC_GIFFLE, function(netID)
    TriggerClientEvent(SYNC_ANIMATION, netID)
end)
