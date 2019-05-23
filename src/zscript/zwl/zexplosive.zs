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

    void ZWL_Explode(int damage,
        int distance,
        int fullDamageDistance = 0,
        Name damageType = 'None',
        int flags = ZXF_HurtSource)
    {
        bool alert = !(flags & ZXF_NoAlert);
        flags &= ~ZXF_NoAlert;
        flags |= XF_ExplicitDamageType;

        if (damageType == 'None') damageType = self.damageType;
        A_Explode(damage, distance, flags, alert, fullDamageDistance, 0, 0, "", damageType);
    }

    void ZWL_HitscanShrapnel(
        int damage,
        int fragCount,
        int spread = 180,
        int range = 8192,
        Name damageType = 'None',
        Class<Actor> puffType = "ZBulletPuff",
        Vector3 offset = (0, 0, 0),
        double angleOfs = 0,
        double pitchOfs = 0,
        int flags = 0)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            double fragAngle, fragPitch;
            [fragAngle, fragPitch] = BulletAngle(spread, angle + angleOfs, pitch + pitchOfs);
            LineAttack(
                fragAngle,
                range,
                fragPitch,
                damage,
                damageType,
                puffType,
                LAF_NoRandomPuffZ,
                null,
                offset.z,
                offset.x,
                offset.y);
        }
    }

    void ZWL_ProjectileShrapnel(
        Class<Actor> fragType,
        int fragCount,
        double spread = 180,
        Vector3 offset = (0, 0, 0),
        double angleOfs = 0,
        double pitchOfs = 0,
        int flags = 0)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            double fragAngle, fragPitch;
            [fragAngle, fragPitch] = BulletAngle(spread, angle + angleOfs, pitch + pitchOfs);

            let frag = SpawnMissileAngle(fragType, fragAngle, 0);
            frag.Vel3dFromAngle(frag.speed, fragAngle, fragPitch);
            frag.SetOrigin(frag.pos + offset, false);
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


    // Returns random angle and pitch within cone
    // I have no idea if there's a better way of doing this ¯\_(ツ)_/¯
    // Params:
    //  - accuracy: maximum angle b/w cone's axis, and bullet trajectory
    //  - angle: angle of axis
    //  - pitch: pitch of axis
    double, double BulletAngle(double accuracy, double angle, double pitch)
    {
        Vector3 v = (0, 0, 0);

        if (accuracy > 10)
        {
            // Generate random vector in sphere section
            Vector3 axis = (Cos(pitch) * Cos(angle), Cos(pitch) * Sin(angle), -Sin(pitch));
            while (v == (0, 0, 0) || v.Length() > 1 || ACos(axis dot v.Unit()) > accuracy)
            {
                v = (FRandom(-1, 1), FRandom(-1, 1), FRandom(-1, 1));
            }

            // Extract angle and pitch from trajectory
            angle = VectorAngle(v.x, v.y);
            pitch = -ASin(v.z / v.Length());
        }
        else if (accuracy > 0)
        {
            // Generate random vector in sphere around end of axis
            double r = Sin(accuracy);
            while (v == (0, 0, 0) || v.Length() > r)
            {
                v = (FRandom(-r, r), FRandom(-r, r), FRandom(-r, r));
            }

            Vector3 axis = (Cos(pitch) * Cos(angle), Cos(pitch) * Sin(angle), -Sin(pitch));
            v += axis;

            // Extract angle and pitch from trajectory
            angle = VectorAngle(v.x, v.y);
            pitch = -ASin(v.z / v.Length());
        }

        return angle, pitch;
    }
}
}