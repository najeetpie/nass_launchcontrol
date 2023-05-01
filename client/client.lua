RegisterCommand("lc", function(source, args, rawCommand)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local shouldBreak = false
    if vehicle then
        local rpmlim = 0.8
        if Config.Cars[GetEntityModel(vehicle)] then
            rpmlim = (Config.Cars[GetEntityModel(vehicle)].launchrpm / 10000)
        end
        local savedVehTraction = GetVehicleHandlingFloat(vehicle,'CHandlingData','fLowSpeedTractionLossMult')
        SendNUIMessage({event = "launchControlEBrake"})
        Wait(500)
        
        while not IsControlPressed(0, 22) do
            Wait(10)
            if (not IsControlPressed(0, 22) and IsControlPressed(0, 71)) or (GetVehiclePedIsIn(PlayerPedId(), false) == nil) then
                notify("error", "Launch Control", "Launch Control Failed", 5000)
                SendNUIMessage({event = "launchControlFailed"})
                shouldBreak = true
                break
            end
        end

       
        SendNUIMessage({event = "launchControlPressGas"})
        while GetVehicleCurrentRpm(vehicle) < rpmlim - 0.02 do
            Wait(10)
            if (not IsControlPressed(0, 22) and IsControlPressed(0, 71)) or (GetVehiclePedIsIn(PlayerPedId(), false) == nil) then
                notify("error", "Launch Control", "Launch Control Failed", 5000)
                SendNUIMessage({event = "launchControlFailed"})
                shouldBreak = true
                break
            end
        end
        time = 850
        while time > 1 do
            if shouldBreak then
                shouldBreak = false
                break
            end
            Wait(1)
            SetVehicleCurrentRpm(vehicle, rpmlim)
            time = time - 7
            if GetVehicleCurrentRpm(vehicle) < rpmlim - 0.02 or not IsControlPressed(0, 71) or not IsControlPressed(0, 22) then
                notify("error", "Launch Control", "Launch Control Failed", 5000)
                SendNUIMessage({event = "launchControlFailed"})
                break
            end
        end

        if IsControlPressed(0, 22) and IsControlPressed(0, 71) then
            
            notify("checkmark", "Launch Control", "Launch Control Ready", 5000)
            while IsControlPressed(0, 22) do
                Wait(1)
                SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult",tonumber(0.0))
                SetVehicleCurrentRpm(vehicle, rpmlim)
            end
        end
        Wait(1000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
        SendNUIMessage({event = "launchControlFailed"})
    else
        notify("error", "Missing Vehicle", "You must be in a vehicle", 3000)
    end
end)
--fLowSpeedTractionLossMult
local tractionControls = {}
RegisterCommand("tc", function(source, args, rawCommand)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and PlayerPedId() == GetPedInVehicleSeat(vehicle,-1) then
        if tractionControls[vehicle] then
            SetVehicleHandlingFloat(vehicle, "CHandlingData","fTractionLossMult",tractionControls[vehicle][0])
            SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult",tractionControls[vehicle][1])

            notify("alert", "Traction Control", "Turning On Traction Control",5000)
            SendNUIMessage({event = "turnOn"})
            tractionControls[vehicle] = nil
        else
            tractionControls[vehicle] = {GetVehicleHandlingFloat(vehicle, 'CHandlingData','fTractionLossMult'), GetVehicleHandlingFloat(vehicle, 'CHandlingData','fLowSpeedTractionLossMult')}

            local tractLoss = 3
            local lowSpeedTractLoss = 1.5
            if Config.Cars[GetEntityModel(vehicle)] then
                tractLoss = (Config.Cars[GetEntityModel(vehicle)].tractionControlValue)
                lowSpeedTractLoss = (Config.Cars[GetEntityModel(vehicle)].lowSpeedTractionControlValue)
            end
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionLossMult", tonumber(tractLoss))
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", tonumber(lowSpeedTractLoss))

            notify("alert", "Traction Control", "Turning Off Traction Control", 5000)
            SendNUIMessage({event = "turnOff"})
        end
        Citizen.CreateThread(function()
            while tractionControls[vehicle] do
                Wait(100)
                
                if not IsPedSittingInAnyVehicle(PlayerPedId()) or not (PlayerPedId() == GetPedInVehicleSeat(vehicle,-1)) then
                    SendNUIMessage({event = "turnOn"})
                    tractionControls[vehicle] = nil
                end
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	for k,v in pairs(tractionControls) do
		SetVehicleHandlingFloat(k, "CHandlingData","fTractionLossMult",v)
	end
end)


function notify(type, title, msg, time)
    if GetResourceState('nass_notifications') == 'started' then
        exports["nass_notifications"]:ShowNotification(type, title, msg, time)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(0, 1)
    end
end
