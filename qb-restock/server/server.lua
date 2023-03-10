---@diagnostic disable: undefined-global
local QBCore = exports['qb-core']:GetCoreObject()
local VehicleList = {}

local function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

RegisterServerEvent('cardealer:server:removemony', function(data, vehicle)
    vehicle = data.vehicle
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local steamname = GetPlayerName(src)
local discount = round(data.price * Config.discount)
    if Player.PlayerData.money.cash >= discount  then
        TriggerClientEvent("car:client:create_blip", src, data.vehicle)  
        Player.Functions.RemoveMoney("cash", discount)
        TriggerClientEvent('QBCore:Notify', src, 'Vehicle Successfully Bought', "success")   
    else
        TriggerClientEvent('QBCore:Notify', src, 'You Dont Have Enough Money !', "error")              
    end
end)



RegisterServerEvent('cardealer:owncar', function(k, vehicle)
        local stock = nil
        local car = vehicle
        local isthere = false
        local buycar = MySQL.query.await('SELECT * FROM vehicle_stock WHERE car = ?', { vehicle })
        for r, s in pairs(buycar) do
            if s.car == vehicle then
                stock = s.stock
--              print(s.stock)
                MySQL.query('UPDATE vehicle_stock SET stock = ? WHERE car = ?', {stock + 1 , vehicle})
                print("updated", vehicle)
                print(s.car, 'exists') 
                isthere = true
            end
        end
        if isthere then
            return
        else
            print('inserted', vehicle) 
            MySQL.insert('INSERT INTO vehicle_stock (car, stock) VALUES (?, ?)', { vehicle, 1 })
        end
end)



RegisterNetEvent('qb-stock:server:updatestock', function(data)
    for k, v in pairs(QBCore.Shared.Vehicles) do
        local found = false
        local dbcar = MySQL.query.await('SELECT * FROM vehicle_stock WHERE car = ?', { k })
        for r, t in pairs(dbcar) do
            if t.car == k then
                print(t.car, 'exists')
                found = true
            end
        end
        if not found then
            print('inserted', k)
            MySQL.insert('INSERT INTO vehicle_stock (car, stock) VALUES (?, ?)', { k, 0, },
                function(insert)
                end)
        end
    end
end) 



local function pdsendLogs (message)
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest('https://discord.com/api/webhooks/1083827004920561714/i7STkfP8LH9OUQNB3oicvByuUTgJLX1frMG4OlShG2FSp4XwwiZOR_j-81v_SjGlPkkp', function(err, text, headers) end, 'POST', json.encode({ content = message }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('qb-stock')
AddEventHandler('qb-stock', function(message)
pdsendLogs(message)
end)


RegisterNetEvent('qb-stock:server:discord', function(name, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playername = Player.PlayerData.name
    local playerlicense =Player.PlayerData.license    
    local cid = Player.PlayerData.citizenid  
    local job = Player.PlayerData.job.name
    local rank = Player.PlayerData.job.grade.level  
    local firstname =  Player.PlayerData.charinfo.firstname 
    local lastname =  Player.PlayerData.charinfo.lastname
        TriggerEvent('qb-stock', '```diff\n- Bought a car\n```\n```css\n[Sender]: "Nissan"\n[Reciever]: '..playername..'\n[Charname]: '..firstname..'\n[CharLastname]: '..lastname..'\n[Cid]: '..cid..'\n[License]: '..playerlicense..'\n[Job]: '..job..'\n[rank]: '..rank..'```\n')       
end)

