class ZExplosive : Actor
{
    enum EExplosionFlags
    {
        ZXF_HurtSource  = XF_HurtSource,
        ZXF_NotMissile  = XF_NotMissile,
        ZXF_NoSplash    = XF_NoSplash,
        ZXF_ThrustZ     = XF_ThrustZ,
        ZXF_NoAlert     = XF_ThrustZ << 1
    }

    enum EShrapnelFlags
    {
        ZSF_Horizontal  = 1 << 0,
        ZSF_NotMissile  = 1 << 1
    }

    enum EProximityFlags
    {
        ZPF_DetectEnemies = 1 << 0,
        ZPF_DetectFriends = 1 << 1
    }

    int explosiveFlags;


    Flagdef AutoCountdown: explosiveFlags, 0;
    Flagdef StickToFloors: explosiveFlags, 1;
    Flagdef StickToWalls: explosiveFlags, 2;
    Flagdef StickToCeilings: explosiveFlags, 3; // TODO: StickToActors


    Default
    {
        Projectile;
    }


    override void Tick()
    {
        Super.Tick();

        if (bAutoCountdown && reactionTime > 0) A_Countdown();

        if (bStickToFloors && blockingFloor)
        {
            bStickToFloors = false;
            bMoveWithSector = true;
            vel = (0, 0, 0);

            SetStateLabel("Stick.Floor");
        }

        if (bStickToCeilings && blockingCeiling)
        {
            bStickToCeilings = false;
            bNoGravity = true;
            vel = (0, 0, 0);

            SetStateLabel("Stick.Ceiling");
        }

        if (bStickToWalls && blockingLine)
        {
            bStickToWalls = false;
            bNoGravity = true;
            vel = (0, 0, 0);

            SetStateLabel("Stick.Wall");
        }
    }

    void ZWL_Explode(int damage, int distance, int fullDamageDistance = 0, Name damageType = 'None',
                     int flags = ZXF_HurtSource)
    {
        bool alert = !(flags & ZXF_NoAlert);
        flags &= ~ZXF_NoAlert;
        flags |= XF_ExplicitDamageType;

        if (damageType == 'None') damageType = self.damageType;
        A_Explode(damage, distance, flags, alert, fullDamageDistance, 0, 0, "", damageType);
    }

    void ZWL_HitscanShrapnel(int damage, int fragCount, int range = 8192, Name damageType = 'None',
                             Class<Actor> puffType = "ZBulletPuff", int flags = 0)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            // Bad way to generate random angles
            double fragPitch = (flags & ZSF_Horizontal) ? 0 : FRandom(-90, 90);
            double fragAngle = FRandom(-180, 180);
            LineAttack(fragAngle, range, fragPitch, damage, damageType, puffType, LAF_NoRandomPuffZ);
        }
    }

    void ZWL_ProjectileShrapnel(Class<Actor> fragType, int fragCount, int flags = 0)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            // Bad way to generate random angles
            double fragPitch = (flags & ZSF_Horizontal) ? 0 : FRandom(-90, 90);
            double fragAngle = FRandom(-180, 180);
            let frag = SpawnMissileAngle(fragType, fragAngle, fragPitch);

            if (frag && !(flags & ZSF_NotMissile)) frag.target = target;
        }
    }

    // TODO: absolute flags, offset
    State ZWL_Tripwire(StateLabel st = "Death", double angleOfs = 0, double pitchOfs = 0, int range = 8192)
    {
        FLineTraceData trace;
        LineTrace(angle + angleOfs, range, pitch + pitchOfs, data: trace);

        if (trace.hitType == Trace_HitActor)
        {
            A_PlaySound(deathSound);
            return ResolveState(st);
        }

        return ResolveState(null);
    }

    State ZWL_Proximity(int range, StateLabel st = "Death", int flags = ZPF_DetectEnemies)
    {
        let it = BlockThingsIterator.Create(self, range);
        while (it.Next())
        {

            if (Distance3D(it.thing) < range && CheckSight(it.thing))
            {
                let src = target ? target : Actor(self);
                if (flags & ZPF_DetectEnemies && src.isHostile(it.thing)
                    || flags & ZPF_DetectFriends && src.isFriend(it.thing))
                {
                    A_PlaySound(deathSound);
                    return ResolveState(st);
                }
            }
        }

        return ResolveState(null);
    }
}