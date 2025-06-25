local jobList = {
    unemployed = {
        label = "Unemployed",
        grades = {
            [0] = { name = "Unemployed", paycheck = 0 }
        }
    },
    police = {
        label = "Police",
        grades = {
            [0] = { name = "Cadet", paycheck = 100 },
            [1] = { name = "Officer", paycheck = 200 },
            [2] = { name = "Sergeant", paycheck = 300 },
            [3] = { name = "Lieutenant", paycheck = 400 },
            [4] = { name = "Chief", paycheck = 500 }
        }
    },
    garbage = {
        label = "Garbage Collector",
        grades = {
            [0] = { name = "Worker", paycheck = 80 },
            [1] = { name = "Supervisor", paycheck = 120 }
        }
    },
    delivery = {
        label = "Delivery Driver",
        grades = {
            [0] = { name = "Driver", paycheck = 100 },
            [1] = { name = "Senior Driver", paycheck = 140 }
        }
    },
    mechanic = {
        label = "Mechanic",
        grades = {
            [0] = { name = "Apprentice", paycheck = 90 },
            [1] = { name = "Technician", paycheck = 130 },
            [2] = { name = "Foreman", paycheck = 170 }
        }
    }
}

-- Helper: Find full ID from base Steam ID
local function getFullIdentifier(baseId)
    for fullId in pairs(playerDataCache) do
        if fullId:find(baseId, 1, true) == 1 then
            return fullId
        end
    end
    return nil
end

-- Assign job and grade to player
RegisterNetEvent("flakeyCore:setJob", function(jobName, grade)
    local src = source
    local baseId = GetPlayerIdentifier(src, 0)
    local fullId = getFullIdentifier(baseId)
    local data = fullId and playerDataCache[fullId]

    if data and jobList[jobName] and jobList[jobName].grades[grade] then
        playerDataCache[fullId].job = jobName
        playerDataCache[fullId].grade = grade

        local label = jobList[jobName].label .. " - " .. jobList[jobName].grades[grade].name
        TriggerClientEvent("flakeyCore:jobChanged", src, jobName, label)
    end
end)

-- Admin command to set a player's job and grade
RegisterCommand("setjob", function(source, args)
    if #args < 3 then
        print("Usage: /setjob [id] [job] [grade]")
        return
    end

    local targetId = tonumber(args[1])
    local jobName = args[2]
    local grade = tonumber(args[3])

    if not targetId or not jobList[jobName] or not jobList[jobName].grades[grade] then
        print("Invalid job or grade")
        return
    end

    local baseId = GetPlayerIdentifier(targetId, 0)
    local fullId = getFullIdentifier(baseId)
    local data = fullId and playerDataCache[fullId]

    if data then
        playerDataCache[fullId].job = jobName
        playerDataCache[fullId].grade = grade
        local label = jobList[jobName].label .. " - " .. jobList[jobName].grades[grade].name
        TriggerClientEvent("flakeyCore:jobChanged", targetId, jobName, label)
        print("Set job for player", targetId, "to", label)
    end
end, true)

-- Get current job info
function GetPlayerJob(identifier)
    local data = playerDataCache[identifier]
    if data and data.job then
        local job = jobList[data.job]
        local grade = data.grade or 0
        local gradeData = job and job.grades and job.grades[grade]
        return data.job, job, grade, gradeData
    end
    return "unemployed", jobList.unemployed, 0, jobList.unemployed.grades[0]
end

-- Paycheck payout every 10 minutes
CreateThread(function()
    while true do
        Wait(600000) -- 10 minutes

        for _, playerId in ipairs(GetPlayers()) do
            local baseId = GetPlayerIdentifier(playerId, 0)
            local fullId = getFullIdentifier(baseId)
            local data = fullId and playerDataCache[fullId]

            if data then
                local _, _, _, gradeData = GetPlayerJob(fullId)
                if gradeData and gradeData.paycheck > 0 then
                    playerDataCache[fullId].bank = data.bank + gradeData.paycheck
                    TriggerClientEvent("flakeyCore:updateMoneyUI", playerId, data.cash, data.bank)
                    TriggerClientEvent("chat:addMessage", playerId, {
                        args = { "Paycheck", "You received $" .. gradeData.paycheck .. " as a " .. gradeData.name }
                    })
                end
            end
        end
    end
end)
