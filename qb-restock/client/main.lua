QBCore = exports['qb-core']:GetCoreObject()

local purchasedvehicle = nil
local pickupblip = nil


RegisterCommand('setstock', function()
    TriggerServerEvent('qb-stock:server:updatestock')
end)


--------------------- NEW CODE

exports['qb-target']:AddBoxZone("BuyVehicle", vector3(-9.96, -1078.14, 26.67), 0.6, 5, {
	name = "Buy_Vehicle",
	heading = 340,
	debugPoly = true,
    minZ=25.67,
    maxZ=28.67,
}, {
	options = {
		{
            type = "client",
            event = "qb-restock:client:openmenu",
			icon = "fas fa-sign-in-alt",
			label = "Buy Vehicle",
 			job = "qb-restock",
		},
	},
	distance = 2.5
})

RegisterNetEvent('qb-restock:client:openmenu', function()
    local categomenu = {}
    local categmenu = {
        {
            header = ('Catagories'),
            icon = "fa-solid fa-angle-left",
            params = {
                event = 'qb-restock:client:homeMenu'
            }
        }
    }
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if type(QBCore.Shared.Vehicles[k]["shops"]) == 'table' then
            for _, shops in pairs(QBCore.Shared.Vehicles[k]["shops"]) do
                if shops == inshop then
                    categomenu[v.category] = v.category
                end
            end
        elseif QBCore.Shared.Vehicles[k]["shops"] == inshop then
            categomenu[v.category] = v.category
        end
    end
    for k, v in pairs(categomenu) do
        categmenu[#categmenu + 1] = {
            header = k,
            icon = "fa-solid fa-circle",
            params = {
                event = 'qb-restock:client:openVehCats',
                args = {
                    catName = k
                }
            }
        }
    end
    exports['qb-menu']:openMenu(categmenu)
end)

RegisterNetEvent('qb-restock:client:openVehCats', function(data)
    local carMenu = {
        {
            header = ('Close'),
            icon = "fa-solid fa-angle-left",
            params = {
                event = 'qb-restock:client:vehCategories'
            }
        }
    }
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if QBCore.Shared.Vehicles[k]["category"] == data.catName then
                carMenu[#carMenu + 1] = {
                    header = v.name,
                    txt = ('Price = ') .. v.price,
                    icon = "fa-solid fa-car-side",
                    params = {
                        isServer = true,
                        event = "qb-restock:server:removemony",
                        args = {
                            price = v.price,
                            vehicle = v.model,
                        }
                    }
                }
        end
    end
    exports['qb-menu']:openMenu(carMenu)
end)

RegisterNetEvent('qb-restock:client:create_blip', function(vehicle)
    onmission = true
    ccarid = k
    local coords = Config.pickupblip
        pickupblip = AddBlipForCoord(vector3(coords.x,coords.y,coords.z))
        SetBlipSprite(pickupblip, 1)
        SetBlipDisplay(pickupblip, 2)
        SetBlipScale(pickupblip, 1.0)
        SetBlipAsShortRange(pickupblip, false)
        SetBlipColour(pickupblip, 0)
        BeginTextCommandSetBlipName("Drop off")
        EndTextCommandSetBlipName(pickupblip)
        SetBlipRoute(pickupblip, true)
    ondelivery = true
    plate = splate
    TriggerEvent("qb-restock:client:buycar", vehicle)
    TriggerEvent("qb-restock:client:checkdistance")
   
end)


local spawnedcar = nil

RegisterNetEvent('qb-restock:client:buycar', function(vehicle)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    local veh = CreateVehicle(
		vehicle,
		Config.carspawn.x,      -- X
		Config.carspawn.y,      -- Y
		Config.carspawn.z,      -- Z
		0,                      -- H
		true,
		true
    )
    PlayerData = QBCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
        spawnedcar = vehicle
        local src = source
        SetEntityAsMissionEntity(veh, true, true)
        local plate = GetVehicleNumberPlateText(veh)
        while not plate do
            Wait(1)
        end
        purchasedvehicle = plate
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys',plate)
    end)



RegisterNetEvent('qb-restock:client:removeblip', function(data)
    RemoveBlip(pickupblip)
    pickupblip = nil
end)

RegisterNetEvent('qb-restock:client:removedeleveryblip', function(data)
    RemoveBlip(deliveryBlip)
    deliveryBlip = nil
end)


------------ vehicle pickup
CreateThread(function()
    RegisterNetEvent('qb-restock:client:checkdistance', function(coords, k)
        while ondelivery do
            Citizen.Wait(1)
            local pos = GetEntityCoords(PlayerPedId(), true)
            local coords = Config.pickupblip
            if #(pos - vector3(coords.x,coords.y,coords.z)) < 5 then
                TriggerEvent('qb-restock:client:removeblip')
                TriggerEvent('qb-restock:client:create_delevery_blip', k)
                ondelivery = false
                dropoff = true
                break
            end
        end
    end)
end)


------------ Blip for delevery 
CreateThread(function()
    RegisterNetEvent('qb-restock:client:checkdeleverydistance', function(coords, vehicle)
        while true do
            Citizen.Wait(1)
            veh = GetVehiclePedIsIn(PlayerPedId())
            local pos = GetEntityCoords(PlayerPedId(), true)
            if #(pos - vector3(coords.x, coords.y, coords.z)) < 5 then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    if GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())) == purchasedvehicle then
                        TriggerEvent('qb-restock:client:removedeleveryblip')
                        ondelivery = false
                        dropoff = true
                        TriggerEvent('qb-restock:client:addtostock', data, vehicle, svehicle)
                        break
                    else
                        print("TRIED TO EXPLOIT")
                    end
                end
            end
        end
    end)
end)


RegisterNetEvent('qb-restock:client:create_delevery_blip', function(k)
    onmission = true
    ccarid = k
    local coords = Config.deliveryblip
        deliveryBlip = AddBlipForCoord(vector3(coords.x,coords.y,coords.z))
        SetBlipSprite(deliveryBlip, 1)
        SetBlipDisplay(deliveryBlip, 2)
        SetBlipScale(deliveryBlip, 1.0)
        SetBlipAsShortRange(deliveryBlip, true)
        SetBlipColour(deliveryBlip, 0)
        BeginTextCommandSetBlipName("Drop off")
        EndTextCommandSetBlipName(deliveryBlip)
        SetBlipRoute(deliveryBlip, true)
    ondelivery = true
    plate = splate
    svehicle = vehicle
    TriggerEvent('qb-restock:client:checkdeleverydistance',coords, k)
end)



RegisterNetEvent('qb-restock:client:addtostock', function(data, vehicle, svehicle)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    DeleteVehicle(vehicle)
    TriggerServerEvent('qb-restock:owncar',data, spawnedcar, svehicle)
end)



RegisterCommand('checkstock', function()
    QBCore.Functions.TriggerCallback('test:server:checkstock', function(stock)
        for _, v in pairs(stock) do
            if v.car == 'sultan' then
                print(v.stock)
            end
        end
    end)
end)
