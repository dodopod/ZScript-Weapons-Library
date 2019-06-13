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
    Vector3 spawnPos;

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


    override void BeginPlay()
    {
        Super.BeginPlay();
        spawnPos = pos;
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
        trail.spawnPos = spawnPos;
    }

    override void Tick()
    {
        if (trail)
        {
            trail.SetOrigin(pos, false);
            trail.vel = vel;
        }

        Super.Tick();
    }

    override void OnDestroy()
    {
        if (trail) trail.Destroy();
        Super.OnDestroy();
    }
}


class ZTracerTrail : ZTrail
{
    double lengthFactor;
    Color headColor, tailColor;
    double spacing;
    Vector3 spawnPos;

    override void Tick()
    {
        Vector3 trailEnd = pos - lengthFactor * vel;
        if ((trailEnd - pos).Length() > (spawnPos - pos).Length()) trailEnd = spawnPos;

        DrawSegment(pos, trailEnd, headColor, tailColor, scale.x, 0, alpha, -1, spacing, 1, vel, (0, 0, 0), -1,
                    0, PF_FullBright);

        Super.Tick();
    }
}


class ZMeshTracer : ZBullet
{
    ZMeshTracerTrail trail;


    Default
    {
        Scale 32;
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

        trail = ZMeshTracerTrail(Spawn("ZMeshTracerTrail", pos));
        trail.scale.x = scale.x;
        trail.scale.y = scale.y;
    }

    override void Tick()
    {
        if (trail)
        {
            trail.SetOrigin(pos, false);
            trail.vel = vel;
            trail.angle = angle;
        }

        Super.Tick();
    }

    override void OnDestroy()
    {
        if (trail) trail.Destroy();
        Super.OnDestroy();
    }
}

class ZMeshTracerTrail : ZTrail
{
    Default
    {
        RenderStyle "Add";
    }

    States
    {
    Spawn:
        TRAC A 1;
        Loop;
    }
}