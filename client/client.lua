local lastEKeyPressTime = 0
local eCooldownDuration = 2000 -- Cooldown duration for E key in milliseconds (adjust as needed)

function LaunchControl()
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
                SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
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
                SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
                shouldBreak = true
                break
            end
        end
        time = 850
        while time > 1 do
            Wait(1)
            SetVehicleCurrentRpm(vehicle, rpmlim)
            time = time - 7
            if shouldBreak or GetVehicleCurrentRpm(vehicle) < rpmlim - 0.02 or not IsControlPressed(0, 71) or not IsControlPressed(0, 22) then
                shouldBreak = false
                break
            end
        end
        
        notify("checkmark", "Launch Control", "Launch Control Ready", 5000)
        if IsControlPressed(0, 22) and IsControlPressed(0, 71) then
                SetHornEnabled(vehicle, false)
                SendNUIMessage({event = "bump"})
                while IsControlPressed(0, 22) and IsControlPressed(0, 71) do
                    if IsControlPressed(0, 38) then -- Check if "E" key is pressed
                        SetVehicleCurrentRpm(vehicle, rpmlim)
                        print('Bump')
                        local forwardForce = 120.0 -- Adjust this value as needed for the desired force
                        ApplyForceToEntity(vehicle, 0, 0.00, forwardForce, 0.0, 0.0, 0.0, 0.0, true, true, true, true, true, true)
                        Wait(100) -- Adjust this wait time as needed
                        DisableControlAction(0, 38, true)
                        Citizen.Wait(100)
                        DisableControlAction(0, 38, true)
                    end
                    Wait(1)
                    SetVehicleCurrentRpm(vehicle, rpmlim)
                end
         
        end
        
        Wait(1000)
        SetHornEnabled(vehicle, true)
        SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
        SendNUIMessage({event = "launchControlFailed"})
    else
        notify("error", "Missing Vehicle", "You must be in a vehicle", 3000)
    end
end


RegisterCommand('lc', function()
    LaunchControl(source, args, rawCommand)
end)
    


local isCooldown = false -- Add this variable to track cooldown status

function linelock(source, args, rawCommand)
    if isCooldown then -- Check if cooldown is active
        notify("error", "LineLock", 'Tires are still cooling down', 5000)
        return -- Exit the function if cooldown is active
    end
    
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not vehicle then
        notify("error", "LineLock", 'You need to be in a vehicle to perform this action', 5000)
        return
    end
    
    local rpmlim = 0.8
    if Config.Cars[GetEntityModel(vehicle)] then
        rpmlim = Config.Cars[GetEntityModel(vehicle)].launchrpm / 10000
    end
    local savedVehTraction = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')
    SendNUIMessage({event = "burnout"})
    Wait(500)

    Citizen.CreateThread(function()
        local startTime = Timestep()
        local wKeyPressed = false -- Flag to track if the "W" key is pressed
        local rain = GetRainLevel()
        local snow = GetSnowLevel()
        
        -- Wait until "W" key is pressed
        while true do
            if IsControlPressed(0, 32) then -- 32 is the control code for the "W" key
                wKeyPressed = true
                SetVehicleBurnout(vehicle, true)
                SetVehicleCurrentRpm(vehicle, rpmlim) -- Set RPM here
                break -- Exit the loop once the "W" key is pressed
            end
            Wait(0)
        end

        -- Timer loop starts only after "W" key is pressed
        local time = 1000
        while time > 1 do
            if shouldBreak then
                shouldBreak = false
                break
            end
    
            Wait(1)
            SetVehicleCurrentRpm(vehicle, rpmlim)
            time = time - 1
            if Config.RollingBurnout then
                if time == 800 then
                    if Config.Limiter then
                        rpmlim = 1 -- Disable RPM here
                    end
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", 3.0)
                    SetVehicleBurnout(vehicle, false)
                end
            end
            if time == 700 then 
                notify("success", "LineLock", 'Tires are Hot and Sticky', 5000)
            end

            if time >= 700 and IsControlJustReleased(0, 32) then
                notify("error", "Linelock", 'Tires still cold', 7500)
                SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
                SetVehicleBurnout(vehicle, false)
                shouldBreak = true
                print(savedVehTraction)
            elseif time <= 700 and IsControlJustReleased(0, 32) then
                shouldBreak = true
                isCooldown = true -- Set cooldown status to true
                SetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", 0.0)
                SetVehicleBurnout(vehicle, false)
                Wait(40000)
                notify("info", "Linelock", 'Tires cooled down', 7500)
                SetVehicleHandlingFloat(vehicle, "CHandlingData","fLowSpeedTractionLossMult", savedVehTraction)
                isCooldown = false -- Reset cooldown status
                print(savedVehTraction)
            end
        end
    end)
end

RegisterCommand('lc2', function()
    linelock(source, args, rawCommand)
end)

    
RegisterNetEvent('linelockClient')
AddEventHandler('linelockClient', function()
    linelock(source, args, rawCommand)
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
    elseif GetResourceState('17mov_Hud') == 'started' then
        if type == "checkmark" or "alert" then
            type = "success"
        end
        exports["17mov_Hud"]:ShowNotification(msg, type, title, 7500)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(0, 1)
    end
end
