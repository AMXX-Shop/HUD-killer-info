#include <amxmodx>
#include <reapi> // comment out this line if you don't want use Reapi module

#if !defined _reapi_included
#include <hamsandwich>
#endif

#pragma semicolon 1

enum any:HUD_STRUCT {
	RED, GREEN, BLUE, Float:X, Float:Y, Float:TIME
}

new const HUD_DATA[HUD_STRUCT] = {0, 100, 200, 0.72, 0.80, 8.0}; // HUD message settings (see HUD_STRUCT)

new g_HudSyncObj;

public plugin_init() {
	register_plugin("HUD killer info", "0.3", "Subb98");

	register_dictionary("hud_killer_info.txt");

	#if defined _reapi_included
	RegisterHookChain(RG_CBasePlayer_Killed, "FwdKilledPost", 1);
	#else
	RegisterHam(Ham_Killed, "player", "FwdKilledPost", 1);
	#endif

	g_HudSyncObj = CreateHudSyncObj();
}

public FwdKilledPost(const Victim, const Killer) {
	if(is_user_alive(Killer)) {
		new Name[32];
		get_user_name(Killer, Name, charsmax(Name));

		set_hudmessage(HUD_DATA[RED], HUD_DATA[GREEN], HUD_DATA[BLUE], HUD_DATA[X], HUD_DATA[Y], .holdtime = HUD_DATA[TIME], .channel = -1);
		ShowSyncHudMsg(Victim, g_HudSyncObj, "%L", Victim, "HKI_MSG", Name, get_user_health(Killer), get_user_armor(Killer));
	}
}
