class TripwireTrail : ZLaser
{
    Default
    {
        Alpha 0.5;
        Scale 2;
        ZLaser.Spacing 0.5;
    }
}

class LiveMine : ZExplosive
{
    Default
    {
        Height 8;
        Radius 8;
        Health 1;
        DeathSound "weapons/GrenadeExplode";
        BounceSound "weapons/MineLand";

        -NoGravity
        -NoBlockMap
        +NoBlood
        +Shootable
        +RollSprite
        +DontFall
        +HitOwner
        +ZExplosive.StickToFloors
        +ZExplosive.StickToWalls
        +ZExplosive.StickToCeilings
        +ZExplosive.StickToActors
    }

    States
    {
    Spawn:
        LMIN A 1;
        Loop;
    Stick.Wall:
        LMIN A 0
        {
            roll += 90;
            pitch = 90;
        }
    // Fallthrough
    Stick:
        LMIN A 20;
    // Fallthrough
    Armed:
        LMIN B 1
        {
            let mis = Spawn("TripwireTrail", pos + (0, 0, height / 2));
            mis.target = self;
            mis.angle = angle;
            mis.pitch = pitch - 90;

            return ZWL_Tripwire(pitchOfs: -90);

            //return ZWL_Proximity(128, "Death", ZPF_DetectEnemies | ZPF_DetectFriends);
        }
        Loop;
    Death:
        /*
        LMIN ABABAB 4;
        LMIN ABABAB 2;
        LMIN ABABAB 1;
        */
        EXP4 A 1 Bright
        {
            A_PlaySound("weapons/GrenadeExplode");
            ZWL_Explode(80, 256);
            ZWL_ProjectileShrapnel("GrenadeFragment", 8, 20, pitchOfs: -90);
        }
        EXP4 CEGIKMOQSUWY 1 Bright;
        Stop;
    }
}

class ZLandMine : ZWeapon
{
    Default
    {
        AttackSound "weapons/MineThrow";

        Weapon.AmmoType1 "GrenadeAmmo";
        Weapon.AmmoGive1 1;
        Weapon.AmmoUse1 1;
    }

    States
    {
    Spawn:
        LMIN A 1;
        Loop;
    Select:
        MINE A 1 A_Raise;
        Wait;
    Deselect:
        TNT1 A 0 ZWL_JumpIfEmpty("Deselect.Empty");
        MINE A 1 A_Lower;
        Wait;
    Deselect.Empty:
        MIN3 A 1 A_Lower;
        Wait;
    Ready:
        MINE A 1 ZWL_WeaponReady;
        Loop;
    Fire:
        MINE GFEDCB 2;
        MIN3 L 1 ZWL_FireProjectile("LiveMine", 0, speed: 8, flags: ZPF_AddPlayerVel);
        MIN3 KJIHGFECB 1;
        MIN3 A 1 ZWL_CheckReload;
        Goto Ready;
    }
}