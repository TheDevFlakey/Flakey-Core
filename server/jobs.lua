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

-- Assign job and grade to player
RegisterNetEvent("flakeyCore:setJob", function(jobName, grade)
    local src = source
    local cid = activeCharacter[src]
    local data = cid and playerDataCache[cid]

    if data and jobList[jobName] and jobList[jobName].grades[grade] then
        data.job = jobName
        data.grade = grade

        local label = jobList[jobName].label .. " - " .. jobList[jobName].grades[grade].name
        TriggerClientEvent("flakeyCore:jobChanged", src, jobName, label)
    end
end)

-- Admin command to set a player's job and grade
RegisterCommand("setjob", function(source, args)
    if #args < 3 then
        print("Usage: /setjob [playerSrc] [job] [grade]")
        return
    end

    local targetSrc = tonumber(args[1])
    local jobName = args[2]
    local grade = tonumber(args[3])

    if not targetSrc or not jobList[jobName] or not jobList[jobName].grades[grade] then
        print("Invalid job or grade")
        return
    end

    local cid = activeCharacter[targetSrc]
    local data = cid and playerDataCache[cid]

    if data then
        data.job = jobName
        data.grade = grade

        local label = jobList[jobName].label .. " - " .. jobList[jobName].grades[grade].name
        TriggerClientEvent("flakeyCore:jobChanged", targetSrc, jobName, label)
        print("Set job for player", targetSrc, "to", label)
    end
end, true)

-- Get current job info
function GetPlayerJob(cid)
    local data = playerDataCache[cid]
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
            local cid = activeCharacter[tonumber(playerId)]
            local data = cid and playerDataCache[cid]

            if data then
                local _, _, _, gradeData = GetPlayerJob(cid)
                if gradeData and gradeData.paycheck > 0 then
                    data.bank = data.bank + gradeData.paycheck
                    TriggerClientEvent("flakeyCore:updateMoneyUI", playerId, data.cash, data.bank)
                    TriggerClientEvent("chat:addMessage", playerId, {
                        args = { "Paycheck", "You received $" .. gradeData.paycheck .. " as a " .. gradeData.name }
                    })
                end
            end
        end
    end
end)
