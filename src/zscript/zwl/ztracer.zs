/*
    This is a modified version of Belmondo's tracer script.

	TRACER SYSTEM FOR ZSCRIPT 2.4 | APRIL 7TH 2017
	AUTHOR: (DENIS) BELMONDO

	USAGE: make a new class, inherit from ZTracer and change the properties as
		   you wish.

	you may use this in your project. just leave this comment at the top of
	this script and give credit please! thank you :^)

*/

class ZTracer : ZBullet
{
    ZTracerTrail trail;

    double tailLength;
    double particleScale;
    double particleSpacing;
    Color headColor, tailColor;

    Property TailLength : tailLength;
    Property ParticleScale : particleScale;
    Property ParticleSpacing : particleSpacing;
    Property Colors : headColor, tailColor;


    Default
    {
        ZBullet.AirFriction 1.0;
        ZTracer.TailLength 1.0;
        ZTracer.ParticleScale 4.0;
        ZTracer.ParticleSpacing 1.0;
        ZTracer.Colors 0xffff73, 0x9b5b13;
    }

    States
    {
    Spawn:
        TNT1 A 1 Light("TracerGlow");
        Loop;
    }


    override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        trail = ZTracerTrail(Spawn("ZTracerTrail", pos));
        trail.lengthFactor = tailLength;
        trail.scale.x = particleScale;
        trail.spacing = particleSpacing;
        trail.headColor = headColor;
        trail.tailColor = tailColor;
        trail.bNoGravity = bNoGravity;
        trail.vel = vel;
    }

    override void Tick()
    {
        Super.Tick();

        if (trail)
        {
            trail.SetOrigin(pos, false);
            trail.vel = vel;
        }
    }

    override void OnDestroy()
    {
        trail.Destroy();

        Super.OnDestroy();
    }
}


class ZTracerTrail : ZTrail
{
    double lengthFactor;
    Color headColor, tailColor;
    double spacing;

    override void Tick()
    {
        Super.Tick();

        DrawSegment(pos, pos - lengthFactor * vel, headColor, tailColor, scale.x, 0, alpha, -1, spacing, 1, vel, (0, 0, 0), -1,
                    0, PF_FullBright);
    }
}