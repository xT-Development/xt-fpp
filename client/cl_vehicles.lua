local config = require 'config'
local playerState = LocalPlayer.state
local IsControlJustReleased =   IsControlJustReleased
local GetFollowPedCamViewMode = GetFollowPedCamViewMode

local function vehicleLoop(vehicle)
    Wait(500)
    while (cache.vehicle == vehicle) do
        local isDriver = (cache.seat == -1)
        local forceDriver = (isDriver and config.forceDrivingFPP)
        local forcePassenger = (not isDriver and config.forceAllPassengersFPP)
        local isAiming = config.forceVehicleAimingFPP and (FPPVehicleWeapon and isPlayerAiming()) or false
        local currentCam = getCamByVehicleType()

        if forceDriver or forcePassenger or isAiming and currentCam ~= 4 then
            setCamByVehicleType(4)
        else
            if config.forceVehicleAimingFPP and IsControlJustReleased(0, 25) then
                resetPlayerCam(playerState.lastCam, false)
            end
        end

        Wait(1)
    end
end

local function aimingWhileEntering()
    CreateThread(function()
        while true do
            local isAiming = (FPPVehicleWeapon and isPlayerAiming()) and true or false
            if isAiming then
                DisablePlayerFiring(cache.playerId)
            else break end
            Wait(1)
        end
    end)
end

lib.onCache('vehicle', function(value)
    if not config.forceDrivingFPP and not config.forceAllPassengersFPP and not config.forceVehicleAimingFPP then
        return
    end

    if not cache.vehicle and value then
        local isAiming = config.forceVehicleAimingFPP and (FPPVehicleWeapon and isPlayerAiming()) or false
        if isAiming then
            aimingWhileEntering()
        end

        setLastCam()
        vehicleLoop(value)
    else
        resetPlayerCam(playerState.lastCam, true)
    end
end)