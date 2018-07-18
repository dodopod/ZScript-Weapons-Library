Changelog
=========

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
[ztracer]: https://forum.zdoom.org/viewtopic.php?f=37&t=56821
