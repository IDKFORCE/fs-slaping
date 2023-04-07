RegisterServerEvent('fs-slaping:SyncOn_Server')
AddEventHandler('fs-slaping:SyncOn_Server', function()
    TriggerClientEvent('fs-slaping:SyncOn_Client', -1, source)
end)

RegisterServerEvent('fs-slaping:SyncGiffle')
AddEventHandler('fs-slaping:SyncGiffle', function(netID)
    TriggerClientEvent('fs-slaping:SyncAnimation', netID)
end)