class ZRocket : ZExplosive
{
    Default
    {
        Health 1;
        Radius 11;
		Height 8;
		Speed 20;
		Damage 20;
		SeeSound "weapons/rocklf";
		DeathSound "weapons/rocklx";
		Obituary "$OB_MPROCKET";

        +RocketTrail
        +Shootable
        +NoBlood
        +HitOwner
        -NoBlockMap
    }

	States
	{
	Spawn:
		MISL A 1 Bright
        {
            ZWL_LaserGuidedMissile(2);

            if (GetAge() > 10 * ticRate)
            {
                bRocketTrail = false;
                bNoGravity = false;
                return ResolveState("NoFuel");
            }

            return ResolveState(null);
        }
		Loop;
    NoFuel:
        MISL A 1;
        Loop;
	Death:
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	}
}

class ZRocketLauncher : ZWeapon replaces RocketLauncher
{
	Default
	{
		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOAUTOFIRE
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
	}

	States
	{
	Ready:
		MISG A 1
        {
            A_LaserSight();
            ZWL_WeaponReady();
        }
		Loop;
	Deselect:
		MISG A 1 A_Lower;
		Loop;
	Select:
		MISG A 1 A_Raise;
		Loop;
	Fire:
		MISG B 8
        {
            A_LaserSight();
            A_GunFlash();
        }
		MISG B 12
        {
            A_LaserSight();
            ZWL_FireProjectile("ZRocket", 3);
        }
		Goto InFlight;
	Flash:
		MISF A 3 Bright A_Light1;
		MISF B 4 Bright;
		MISF CD 4 Bright A_Light2;
		Goto LightDone;
    InFlight:
		MISG A 1
        {
            A_LaserSight();

            let it = ThinkerIterator.Create("ZRocket", Stat_Default);
            ZRocket mo;
            while (mo = ZRocket(it.Next()))
            {
                if (mo.target = self)
                {
                    return ResolveState(null);
                }
            }

            ZWL_CheckReload();
            return ResolveState("Ready");
        }
        Loop;
	Spawn:
		LAUN A -1;
		Stop;
	}

    action void A_LaserSight()
    {
        double zOffset = (height / 2 + PlayerPawn(self).attackZOffset) * player.crouchFactor;
        FLineTraceData trace;
        LineTrace(angle, 8192, pitch, 0, zOffset, data: trace);

        Vector3 laserOfs = trace.hitLocation - pos;
        A_SpawnParticle("Red", SPF_FullBright, 8, 8, 0, laserOfs.x - 1, laserOfs.y, laserOfs.z);
    }
}