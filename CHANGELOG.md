Changelog
=========

[v0.3.0][v0.3.0]
------
### Added
* Explosive class
    * Proximity and tripwire triggers
    * Laser-guidance function
    * HitOwner flag doesn't activate until outside player
    * Can stick to floors, ceilings, walls, and actors
    * Projectile and hitscan shrapnel functions
* 3D model tracer (provided by [Nash Muhandes][tracer mesh]).
* Single ZScript include (i.e. zscript/zwl/zwl.zs).
* Laser, lightning, and railgun trails for hitscan attacks.
* Speed and damage parameters for `ZWL_FireProjectile`

### Changed
* New bullet spread calculation (allowing 360 degree spread).
* ZScript file extension changed from .zc to .zs.

### Fixed
* Particle tracers no longer appear through player's back.
* Tracers no longer move strangely when hitting a wall/ceiling.
* Tracers now aim at same spot as hitscan attacks.
* Casings and tracers take view height into account when crouching or standing
  in liquid.

[v0.2.0][v0.2.0]
------
### Added
* Bullet class that is affected by gravity.
* Particle based tracers (based on [Belmondo's implementation][ztracer]).
* Projectile weapons now have accuracy, just like hitscan.
* Projectile weapons can fire tracers at regular intervals.
* Weapon.AmmoGive1 property places ammo in a weapon's magazine, if it has one.
* Projectiles can borrow player velocity.

### Removed
* Reload.Empty state.
* ZWeapon.AmmoCount property. Use Weapon.AmmoGive, instead.

### Fixed
* Flat decals no longer float in the air when fired at moving platforms.
* Flat decals and casings disappear when corresponding CVars are decreased.
* Flat decals angle themselves properly on slopes.

v0.1.0
------
### Added
* Conical bullet spread. It even stays conical when looking up.
* Automatic weapons can be set to fire at a fixed rate, even one not divisible
  by a whole number of tics.
* Shotguns have both accuracy, which determines the general direction pellets
  will go, and spread, which determines how widely they spread apart.
* A bullet casing class and eject function.
* A class for decals that appear on floors/ceilings, and a bullet puff class
  that spawns them.
* A flexible reloading system.
* Automatic weapons can also have a looping attack sound with an attack,
  sustain, and release.
* Semi-automatic fire.

[v0.2.0]: https://gitlab.com/dodopod/zscript-weapons-library/compare/v0.1.0...v0.2.0
[v0.3.0]: https://gitlab.com/dodopod/zscript-weapons-library/compare/v0.2.0...v0.3.0
[ztracer]: https://forum.zdoom.org/viewtopic.php?f=37&t=56821
[tracer mesh]: https://forum.zdoom.org/viewtopic.php?p=1073359#p1073359
