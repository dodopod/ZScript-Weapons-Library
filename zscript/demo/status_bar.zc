class ZStatusBar : DoomStatusBar
{
    override void Draw(int state, double ticFrac)
    {
        Super.Draw(state, ticFrac);

        // Yes, I'm just drawing over the number that's already there
        if (state == HUD_Fullscreen)
        {
            let ammoType1 = GetCurrentAmmo();
            let weapon = ZWeapon(cplayer.readyWeapon);
            if (ammoType1 && weapon && weapon.magazineSize > 0)
            {
                DrawString(mHUDFont, StringStruct.Format("%d %d", weapon.ammoCount, ammoType1.amount), (-30, -20),
                           DI_TEXT_ALIGN_RIGHT);
            }
        }
    }
}