local config = lib.require('config')
local UTILS = lib.require('modules.utils')
local LAST_CAM_UTILS = lib.require('modules.lastcam')

local IsControlJustReleased     = IsControlJustReleased
local IsControlJustPressed      = IsControlJustPressed
local GetFollowPedCamViewMode   = GetFollowPedCamViewMode
local SetPlayerCanDoDriveBy     = SetPlayerCanDoDriveBy

local function vehicleLoop()
    Wait(500)
    CreateThread(function()
        LAST_CAM_UTILS.setLastCam() -- save last cam before entering vehicle. if aiming is enabled and driver/passenger fpp is disabled, this will be overridden quickly

        while IsPedInAnyVehicle(cache.ped, false) do
            local isDriver = (cache.seat == -1)
            local forceDriver = (isDriver and config.forceDrivingFPP)
            local forcePassenger = (not isDriver and config.forceAllPassengersFPP)
            local isAiming = UTILS.isPlayerAiming()

            if config.forceVehicleAimingFPP and FPPVehicleWeapon then
                if IsControlJustPressed(0, 25) then
                    LAST_CAM_UTILS.setLastCam()
                elseif IsControlJustReleased(0, 25) then
                    LAST_CAM_UTILS.resetPlayerCam(false)
                end
            end

            if (isAiming and FPPVehicleWeapon) or forceDriver or forcePassenger then
                UTILS.setCamByVehicleType(4)
            end

            Wait(1)
        end
    end)
end

-- prevent player from shooting while entering vehicle until they have stopped aiming
-- workaround for fixing an "exploit" to fpp
local function aimingWhileEntering()
    local canShoot = false
    CreateThread(function()
        while true do
            local isAiming = UTILS.isPlayerAiming()
            canShoot = (not isAiming)

            SetPlayerCanDoDriveBy(cache.playerId, canShoot)
            if canShoot then break end

            Wait(10)
        end
    end)
end

SetPlayerCanDoDriveBy(cache.playerId, true)

lib.onCache('seat', function(newSeat)
    if not newSeat then
        LAST_CAM_UTILS.resetPlayerCam(true) -- reset cam on exit
        return
    end

    local isDriver = (newSeat == -1)

    if config.forceVehicleAimingFPP or (isDriver and config.forceDrivingFPP) or (not isDriver and config.forceAllPassengersFPP) then
        local isAiming = config.forceVehicleAimingFPP and FPPVehicleWeapon or false
        if isAiming then -- prevent exploit
            aimingWhileEntering()
        end

        vehicleLoop()
    end
end)
