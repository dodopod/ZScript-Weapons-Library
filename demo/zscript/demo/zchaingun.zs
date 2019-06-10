class ChaingunLink : ZCasing
{
    Default
    {
        Scale 0.07;
    }

    States
    {
    Spawn:
        BULN ABCDE 2;
        Loop;
    Death:
        BULN E -1;
        Stop;
    }
}

class ChaingunTracer : ZTracer
{
    Default
    {
        Speed 100;
        ZBullet.AirFriction 1;
        +NoGravity
    }
}


class ZChaingun : ZWeapon replaces Chaingun
{
    bool spinning;

	Default
	{
		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";

        ZWeapon.AttackSustain "weapons/minigunLoop", 0.175*sec;
        ZWeapon.AttackRelease "weapons/minigunRelease";
        ZWeapon.ClickSound "weapons/emptyClick";

		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
	}

	States
	{
	Ready:
		CHAG A 1 ZWL_WeaponReady;
		Loop;
	Deselect:
        TNT1 A 0
        {
            if (invoker.spinning)
                return ResolveState("SpinDown");

            return ResolveState(null);
        }
		CHAG A 1 A_Lower;
		Loop;
	Select:
		MGRS ABCDE 2 ZWL_QuickRaise;
		Goto Ready;
	Fire:
        CHAG A 2
        {
            A_PlaySound("weapons/minigunSpinUp", CHAN_Body);
            invoker.spinning = true;
        }
        CHAG BCD 2;
        TNT1 A 0 ZWL_ReFire;
        Goto SpinDown;
    Hold:
        CHAF A 1 Bright
        {
            A_PlaySound("weapons/minigunSpin", CHAN_Body, looping:true);
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(2);
        }
        CHAG BCD 1 ZWL_ReFire("Hold2");
		Goto SpinDown;
    Hold2:
        CHAF B 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(1);
        }
        CHAG CD 1 ZWL_ReFire("Hold3");
		Goto SpinDown;
    Hold3:
        CHAF C 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(0);
        }
        CHAG D 1 ZWL_ReFire("Hold4");
		Goto SpinDown;
    Hold4:
        CHAF D 1 Bright
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(2);
        }
        CHAG A 0 ZWL_ReFire("Hold5");
		Goto SpinDown;
    Hold5:
        CHAF E 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(1);
        }
        CHAG BCD 1 ZWL_ReFire("Hold6");
		Goto SpinDown;
    Hold6:
        CHAF F 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(0);
        }
        CHAG CD 1 ZWL_ReFire("Hold7");
		Goto SpinDown;
    Hold7:
        CHAF G 1 Bright
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(2);
        }
        CHAG D 1 ZWL_ReFire("Hold8");
		Goto SpinDown;
    Hold8:
        CHAF H 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(1);
        }
        CHAG A 0 ZWL_ReFire("Hold9");
		Goto SpinDown;
    Hold9:
        CHAF I 1
        {
            ZWL_FireHitscan(0, 5 * Random(1, 3), -1, invoker.RoundCount(3000 * rpm), 2, tracerType:"ChaingunTracer", tracerFreq:9);
            ZWL_EjectCasing("RifleCasing", true, -23, 8, 16, (24, 0, -16));
            ZWL_EjectCasing("ChaingunLink", true, -23, 8, 16, (24, 0, -16));
            A_Light(0);
        }
        CHAG BCD 1 ZWL_ReFire;
		Goto SpinDown;
    SpinDown:
        CHAG A 1
        {
            ZWL_StopAttackLoop();
            A_PlaySound("weapons/minigunSpinDown", CHAN_Body);
        }
        CHAG BCDABCDABCDABCD 1;
        CHAG ABCD 2;
        TNT1 A 0
        {
            invoker.spinning = false;
        }
        Goto Ready;
	Spawn:
		MNGN A -1;
		Stop;
	}
}