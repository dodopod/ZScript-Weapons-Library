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

    void ZWL_HitscanShrapnel(int damage, int fragCount, Name damageType = 'None', Class<Actor> puffType = "BulletPuff")
    {
    }

    void ZWL_ProjectileShrapnel(Class<Actor> missileType, int fragCount)
    {
    }
}