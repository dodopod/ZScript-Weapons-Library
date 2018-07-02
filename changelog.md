Changelog
=========

Upcoming
--------
### Added
* Bullet projectiles
* Bullet drop
* Selective fire
* Bullets can pass through enemies.
* Weapons can be given properties governing accuracy damage, etc. which serve
  as default arguments for attack functions.
* Casings and bullet holes on ceilings/floors fade when there are too many of
  them.

0.1.0
-----
### Added
* Conical bullet spread
* Automatic weapons can be set to fire at a fixed rate, even one not divisible
  by a whole number of tics.
* Shotguns have both accuracy, which determines the general direction pellets
  will go, and spread, which determines how widely they spread apart.
* Weapons can eject bullet casings.
* Weapons can be reloaded in several ways, including:
    * Separate animation for reloading while gun is empty;
    * Ammo remaining in magazine can be discarded (realistic), or kept (like in
      most games);
    * Rounds can be reloaded one at a time;
    * An extra round in the chamber can be simulated.
* Bullets leave holes in floors/ceilings.
* Automatic weapon attack sounds can be 3-part loops, with an attack, sustain,
  and release
* Weapons can fire tracer rounds at intervals
* Custom status bar showing ammo remaining in weapon.
