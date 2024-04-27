return {
    -- Vehicle Driver / Passengers FPP Configs --
    forceDrivingFPP = false,                        -- Force FPP while driving
    forceAllPassengersFPP = false,                  -- Force passengers into FPP

    -- Aiming Weapons in Vehicle FPP Configs --
    forceVehicleAimingFPP = true,                   -- Force FPP while aiming in vehicle
    forceAllWeaponsVehicleAimingFPP = true,         -- All weapons force FPP while aiming in a vehicle
    forceVehicleAimingWeapons = {                   -- If forceAllWeaponsVehicleAimingFPP is false, only these weapons force FPP while aiming in a vehicle
        `WEAPON_PISTOL`,
        `WEAPON_COMBATPISTOL`,
        `WEAPON_APPISTOL`,
        `WEAPON_COMBATPDW`,
        `WEAPON_MACHINEPISTOL`,
        `WEAPON_MICROSMG`,
        `WEAPON_MINISMG`,
        `WEAPON_PISTOL_MK2`,
        `WEAPON_SNSPISTOL`,
        `WEAPON_SNSPISTOL_MK2`,
        `WEAPON_VINTAGEPISTOL`,
    },

    -- Aiming Weapons on Foot FPP Configs --
    forceAimingFPP = true,                          -- Force FPP while aiming
    forceAllWeaponsFPP = false,                     -- Force FPP while aiming for all weapons
    forceAimingWeapons = {                          -- If forceAllWeaponsFPP is false, only these weapons force FPP while aiming
        `WEAPON_PISTOL`,
        `WEAPON_COMBATPISTOL`,
        `WEAPON_APPISTOL`,
        `WEAPON_COMBATPDW`,
        `WEAPON_MACHINEPISTOL`,
        `WEAPON_MICROSMG`,
        `WEAPON_MINISMG`,
        `WEAPON_PISTOL_MK2`,
        `WEAPON_SNSPISTOL`,
        `WEAPON_SNSPISTOL_MK2`,
        `WEAPON_VINTAGEPISTOL`,
    },
}