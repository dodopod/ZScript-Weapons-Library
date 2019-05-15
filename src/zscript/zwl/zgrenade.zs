class ZGrenade : Actor
{
    int ttd;

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

        if (--ttd == 0) SetStateLabel("Death");
    }

    void ZWL_SetTimer(int tics)
    {
        ttd = tics;
    }
}