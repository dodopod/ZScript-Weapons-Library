class ZWeaponPlayer : DoomPlayer
{
    Default
    {
        Player.StartItem "ZPistol";
        Player.StartItem "Fist";
        Player.StartItem "Clip", 50;

        Player.WeaponSlot 2, "ZPistol";
        Player.WeaponSlot 3, "ZShotgun", "ZSuperShotgun";
        Player.WeaponSlot 4, "ZSniperRifle", "ZChaingun";
        Player.WeaponSlot 5, "ZRocketLauncher", "ZFragGrenade", "ZLandMine";
        Player.WeaponSlot 6, "ZPlasmaRifle";
    }
}