-- server/money.lua

RegisterCommand("setcash", function(source, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    if not target or not amount then return end

    local id = GetPlayerIdentifier(target, 0)
    local data = GetPlayerData(id)
    if data then
        data.cash = amount
        TriggerClientEvent("flakeyCore:updateMoneyUI", target, data.cash, data.bank)
    end
end, true)

RegisterCommand("setbank", function(source, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    if not target or not amount then return end

    local id = GetPlayerIdentifier(target, 0)
    local data = GetPlayerData(id)
    if data then
        data.bank = amount
        TriggerClientEvent("flakeyCore:updateMoneyUI", target, data.cash, data.bank)
    end
end, true)

RegisterNetEvent("flakeyCore:addCash", function(amount)
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    local data = GetPlayerData(id)
    if data then
        data.cash = data.cash + amount
        TriggerClientEvent("flakeyCore:updateMoneyUI", src, data.cash, data.bank)
    end
end)

RegisterNetEvent("flakeyCore:removeCash", function(amount)
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    local data = GetPlayerData(id)
    if data then
        data.cash = math.max(0, data.cash - amount)
        TriggerClientEvent("flakeyCore:updateMoneyUI", src, data.cash, data.bank)
    end
end)

RegisterNetEvent("flakeyCore:addBank", function(amount)
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    local data = GetPlayerData(id)
    if data then
        data.bank = data.bank + amount
        TriggerClientEvent("flakeyCore:updateMoneyUI", src, data.cash, data.bank)
    end
end)

RegisterNetEvent("flakeyCore:removeBank", function(amount)
    local src = source
    local id = GetPlayerIdentifier(src, 0)
    local data = GetPlayerData(id)
    if data then
        data.bank = math.max(0, data.bank - amount)
        TriggerClientEvent("flakeyCore:updateMoneyUI", src, data.cash, data.bank)
    end
end)
