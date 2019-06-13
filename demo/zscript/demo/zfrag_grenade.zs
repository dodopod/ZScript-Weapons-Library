class GrenadeFragment : ZMeshTracer
{
    Default
    {
        Speed 32;
        ZBullet.AirFriction 1;
    }
}

class LiveGrenade : ZExplosive
{
    Default
    {
        Radius 16;
        Height 8;
        Health 1;
        BounceType "Grenade";
        BounceFactor 0.5;
        WallBounceFactor 0.5;

        BounceSound "weapons/grenadeBounce";
        DeathSound "weapons/grenadeExplode";
        ReactionTime 3 * ticRate;

        -NoGravity
        -Missile
        -NoTeleport
        -NoBlockMap
        +HitOwner
        +Shootable
        +ZExplosive.AutoCountdown
    }

    States
    {
    Spawn:
        HGN1 ABCDEF 2
        {
            if (vel.Length() < 4) return ResolveState("Idle");
            return ResolveState(null);
        }
        Loop;
    Idle:
        HGN1 B 2
        {
            if (vel.Length() >= 4) return ResolveState("Spawn");
            return ResolveState(null);
        }
        Loop;
    Death:
        EXP4 A 1 Bright
        {
            ZWL_Explode(80, 256);
            //ZWL_HitscanShrapnel(10, 8, 512, flags:ZSF_Horizontal);
            ZWL_ProjectileShrapnel("GrenadeFragment", 64, flags: ZSF_AddParentVel);
        }
        EXP4 CEGIKMOQSUWY 1 Bright;
        Stop;
    }
}


class GrenadeAmmo : Ammo
{
    Default
    {
        Inventory.MaxAmount 10;
    }
}


class ZFragGrenade : ZWeapon
{
    Default
    {
        AttackSound "weapons/grenadeThrow";
        ZWeapon.MaxCharge 10;
        Weapon.AmmoType1 "GrenadeAmmo";
        Weapon.AmmoGive1 1;
        Weapon.AmmoUse1 1;
    }

    States
    {
    Spawn:
        GNA1 A -1;
        Loop;
    Select:
        HGRN A 1 A_Raise;
        Loop;
    Deselect:
        TNT1 A 0 ZWL_JumpIfEmpty("Deselect.Empty");
        HGRN A 1 A_Lower;
        Loop;
    Deselect.Empty:
        TNT1 A 1 ZWL_QuickLower;
        Loop;
    Ready:
        HGRN A 1 ZWL_WeaponReady;
        Loop;
    Fire:
        HGRN A 1
        {
            A_PlaySound("weapons/grenadePin");
            ZWL_ResetCharge();
        }
        HGRN BCDEFGHIJKLMNOP 1;
        Goto Hold + 1;
    Hold:
        HGRN Q 3 ZWL_Charge();
        HGT2 B 1 ZWL_Refire;
        HGT2 C 2 ZWL_FireProjectile("LiveGrenade", 0, speed: 5 * invoker.chargeLevel + 4, flags: ZPF_AddPlayerVel);
        HGT2 CDEFGHI 2;
        HGT2 J 2 A_CheckReload;
        HGRN QPONMLKJIHGDCB 1;
        Goto Ready;
    }
}