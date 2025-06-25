RegisterNetEvent("flakeyCore:jobChanged", function(jobName, label)
    local src = source
    print("Job changed for player " .. src .. ": " .. jobName .. " - " .. label)
end)