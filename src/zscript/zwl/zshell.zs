class ZShell : ZExplosive
{
    class<Actor> pelletType;
    int pelletCount;
    double spread;

    Property PelletType: pelletType;
    Property PelletCount: pelletCount;
    Property Spread: spread;

    States
    {
    Spawn:
        TNT1 A 0 NoDelay ZWL_ProjectileShrapnel(pelletType, pelletCount, spread);
        Stop;
    }
}