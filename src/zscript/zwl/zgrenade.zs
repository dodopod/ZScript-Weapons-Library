class ZGrenade : Actor
{
    enum EExplosionFlags
    {
        ZXF_HurtSource  = XF_HurtSource,
        ZXF_NotMissile  = XF_NotMissile,
        ZXF_NoSplash    = XF_NoSplash,
        ZXF_ThrustZ     = XF_ThrustZ,
        ZXF_NoAlert     = XF_ThrustZ << 1
    }


    Default
    {
        BounceType "Grenade";
        BounceFactor 0.5;
        WallBounceFactor 0.5;

        +Dropoff
        +NoBlockMap
    }


    override void Tick()
    {
        Super.Tick();
        if (reactionTime > 0) A_Countdown();
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
                             Class<Actor> puffType = "ZBulletPuff", bool horizontal = false)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            // Bad way to generate random angles
            double fragPitch = horizontal ? 0 : FRandom(-90, 90);
            double fragAngle = FRandom(-180, 180);
            LineAttack(fragAngle, range, fragPitch, damage, damageType, puffType, LAF_NoRandomPuffZ);
        }
    }

    void ZWL_ProjectileShrapnel(Class<Actor> fragType, int fragCount, bool horizontal = false)
    {
        for (int i = 0; i < fragCount; ++i)
        {
            // Bad way to generate random angles
            double fragPitch = horizontal ? 0 : FRandom(-90, 90);
            double fragAngle = FRandom(-180, 180);
            let frag = SpawnMissileAngle(fragType, fragAngle, fragPitch);

            if (frag) frag.target = target;
        }
    }
}