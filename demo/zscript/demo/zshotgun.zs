class ShotgunCasing : ZCasing
{
    Default
    {
        Scale 0.24;
        BounceSound "weapons/casing2";
    }

    States
    {
    Spawn:
        REDC ABCDEFGH 2;
        Loop;
    Death:
        REDC G -1;
        Stop;
    }
}

class ShotgunPellet : ZTracer
{
    Default
    {
        Speed 100;
        Damage 5;
        +NoGravity
    }
}

class ShotgunShell : ZShell
{
    Default
    {
        ZShell.PelletType "ShotgunPellet";
        ZShell.PelletCount 7;
        ZShell.Spread 5;
    }
}


class ZShotgun : ZWeapon replaces Shotgun
{
    Default
	{
		Weapon.SelectionOrder 1300;
		Weapon.AmmoUse 1;
		Weapon.AmmoType "Shell";
        Weapon.AmmoGive 8;

        ZWeapon.MagazineSize 7;
        ZWeapon.ReloadSound "weapons/shellLoad";
        ZWeapon.ClickSound "weapons/emptyClick";

		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";

        AttackSound "weapons/shotgf";
	}

	States
	{
	Ready:
		SHTG A 1 ZWL_WeaponReady(ZRF_ExtraRound);
		Loop;

	Deselect:
		SHTG A 1 A_Lower;
		Loop;

	Select:
		SGUW A 2 ZWL_QuickRaise();
        SGUN ABCDEF 2;
		Goto Ready;

	Fire:
		SHTF A 2 Bright
        {
            //ZWL_FireHitscan(2, 5 * Random(1, 3), pellets:7, spread:5);
            ZWL_FireProjectile("ShotgunShell", 3);
            A_Light(1);
        }
		SHTF B 2 A_Light(0);
		SHTF CDEF 2;
        SHTG B 2 ZWL_CheckReload();
        SHTG CDEFG 2;
        SHTG H 2 ZWL_EjectCasing("ShotgunCasing");
        SHTG IJIHGFEDCB 2;
        Goto Ready;

    Reload:
        TNT1 A 0 ZWL_JumpIfEmpty("Reload.Empty");
        SHTG BCDEFG 2;
        // Fallthrough
    Reload.Loop:
        SHTR ABCDE 2;
        SHTR F 2 ZWL_Reload(1);
        SHTR GH 2;
        SHTR I 2;
        SHTR I 0 ZWL_JumpIfReloaded("Reload.End", true, true);
        Loop;
    Reload.End:
        SHTG GFEDCB 2;
        Goto Ready;

    Reload.Empty:
        SHTG BCDEFG 2;
        // Fallthrough
    Reload.Empty.Loop:
        SHTR ABCDE 2;
        SHTR F 2 ZWL_Reload(1);
        SHTR GH 2;
        SHTR I 2;
        SHTR I 0 ZWL_JumpIfReloaded("Reload.Empty.End", true);
        Loop;
    Reload.Empty.End:
        SHTG BCDEFG 2;
        SHTG H 2
        {
            ZWL_EjectCasing("ShotgunCasing");
            A_PlaySound("weapons/shotgr", CHAN_WEAPON);
        }
        SHTG IJIHGFEDCB 2;
        Goto Ready;

	Spawn:
		SHOT A -1;
		Stop;
	}
}