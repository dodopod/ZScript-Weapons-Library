class RifleBullet : ZTracer
{
    Default
    {
        Speed 400;
        Damage 16;
        ZTracer.Colors 0xff6666, 0x440000;

        +StrifeDamage
    }

    States
    {
    Spawn:
        TNT1 A 1 Light("RedTracerGlow");
        Loop;
    }
}


class RifleCasing : ZCasing
{
    Default
    {
        Scale 0.18;
        BounceSound "weapons/casing1";
    }

    States
    {
    Spawn:
        CAS7 ABCDEFGH 2;
        Loop;
    Death:
        CAS7 G -1;
        Stop;
    }
}


class ZSniperRifle : ZWeapon
{
    double zoomFactor;

    Default
    {
        Scale 0.8;
        AttackSound "weapons/sniperFire";
        Weapon.SelectionOrder 1000;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 10;
        Weapon.AmmoType "Clip";
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        zoomFactor = 1.0;
    }

    States
    {
    Ready:
        SNPG A 1 ZWL_WeaponReady;
        Loop;

    Deselect:
        TNT1 A 0
        {
            invoker.zoomFactor = 1.0;
            A_ZoomFactor(1.0, Zoom_Instant);
        }
        SNPG A 1 A_Lower;
        Wait;
    Select:
        SNPG A 1 A_Raise;
        Wait;

    Fire:
        TNT1 A 0
        {
            if (invoker.zoomFactor > 1)
                return ResolveState("Zoom.Fire");
            return ResolveState(null);
        }

        SNPF A 2 Bright
        {
            ZWL_FireProjectile("RifleBullet", 1, -1, null, 1, (0, 8, 0));
            A_Light(2);
        }
        SNPF B 2 Bright A_Light(1);
        SNPF CDE 3 A_Light(0);
        SNPG ABC 3;
        SNPG DEF 2;
        SNPG H 2 A_PlaySound("weapons/sniperBolt1", CHAN_Body);
        SNPG IJ 2;
        SNPG K 3 ZWL_EjectCasing("RifleCasing", false, -45, 4, 8, (24, 8, -10));
        SNPG JI 2;
        SNPG H 2 A_PlaySound("weapons/sniperBolt2", CHAN_Body);
        SNPG FED 3;
        SNPG CB 4;
        Goto Ready;

    Zoom:
        SNPS A 4
        {
            if (invoker.zoomFactor == 1)
                invoker.zoomFactor = 4;
            else if (invoker.zoomFactor == 4)
                invoker.zoomFactor = 8;
            else
                invoker.zoomFactor = 1;

            A_ZoomFactor(invoker.zoomFactor);
            Console.Printf("%dx", invoker.zoomFactor);

            if (invoker.zoomFactor == 1)
                return ResolveState("Ready");
            return ResolveState(null);
        }
        // Fallthrough
    Zoom.Scope:
        SNPS A 1 ZWL_WeaponReady;
        Loop;
    Zoom.Fire:
        SNPS A 2
        {
            ZWL_FireProjectile("RifleBullet", 0, -1, null, 1, (0, 0, 8));
            A_Light(2);
        }
        SNPS A 2 A_Light(1);
        SNPS A 24 A_Light(0);
        SNPS A 6 A_PlaySound("weapons/sniperBolt1", CHAN_Body);
        SNPS A 7 ZWL_EjectCasing("RifleCasing");
        SNPS A 19 A_PlaySound("weapons/sniperBolt2", CHAN_Body);
        Goto Zoom.Scope;

    Spawn:
        SNPP A -1;
        Stop;
    }
}