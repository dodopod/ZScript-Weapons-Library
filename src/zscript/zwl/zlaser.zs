class ZLaser : ZTrail
{
    Color colour;
    double spacing;
    double lifetime;
    double fadeStep;
    double sizeStep;
    double range;

    Property Color : colour;
    Property Spacing : spacing;
    Property Lifetime : lifetime;
    Property Range : range;
    Property FadeStep : fadeStep;
    Property SizeStep : sizeStep;

    Default
    {
        Speed 0.001;  // This is a hack to find the pitch

        ZLaser.Color "red";
        ZLaser.Spacing 1;
        ZLaser.Lifetime 1;
        ZLaser.Range 8192;
        ZLaser.FadeStep -1;
        ZLaser.SizeStep 0;
    }

    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        // Find beam endpoint
        // Projectiles are fired w/ pitch = 0, but we can find the real pitch from our velocity
        if (target) pitch = -ATan2(vel.z, vel.xy.Length());

        Actor mo = target ? target : Actor(self);
        FLineTraceData traceData;
        mo.LineTrace(angle, range, pitch, data: traceData);

        DrawSegment(pos, traceData.hitLocation, colour, colour, scale.x, -1, alpha, -1, spacing, lifetime, (0, 0, 0),
                    (0, 0, 0), fadeStep, sizeStep, PF_FullBright);

        Destroy();
    }
}