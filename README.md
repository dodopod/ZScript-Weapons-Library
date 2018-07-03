ZScript Weapons Library
=======================

The **ZScript Weapons Library** (ZWL) attempts to ease the creation of weapons
with features beyond those present in the original Doom engine games. These
sorts of features typically have convoluted implementations in Decorate+ACS,
containing dozens of states beginning with `TNT1 A 0`, and dummy inventory
items serving the purpose of variables. All of this can be greatly simplified
in (G)ZDoom using ZScript.

Features of ZWL include:
* Reloading
* Bullet casings
* Conical bullet spread
* Decals on floors/ceilings
* Damage types for hitscan weapons (w/o custom bullet puffs)
* Automatic rate-of-fire management
* Looping AttackSound for automatic weapons

ZWL is licensed under the [MIT License](LICENSE). The bullet chip sprites come
from GZDoom, and may be licensed differently.
