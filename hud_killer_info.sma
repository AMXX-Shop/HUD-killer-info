#include <amxmodx>
#include <reapi> // comment out this line if you don't want use Reapi module

#if !defined _reapi_included
#include <hamsandwich>
#endif

#pragma semicolon 1

#define SHOW_DAMAGE // comment out this line if you don't want display the damage

#if defined SHOW_DAMAGE
new Float:g_Damage[33];
#endif

enum any:HUD_STRUCT {
	RED, GREEN, BLUE, Float:X, Float:Y, Float:TIME
}

new const HUD_DATA[HUD_STRUCT] = {0, 100, 200, 0.72, 0.78, 8.0}; // HUD message settings (see HUD_STRUCT)

new g_HudSyncObj;

public plugin_init() {
	register_plugin("HUD killer info", "0.4", "Subb98");

	register_dictionary("hud_killer_info.txt");

	#if defined SHOW_DAMAGE
	register_event("HLTV", "EventHLTV", "a", "1=0", "2=0");

	#if defined _reapi_included
	RegisterHookChain(RG_CBasePlayer_TakeDamage, "FwdTakeDamage", 1);
	#else
	RegisterHam(Ham_TakeDamage, "FwdTakeDamage", 1);
	#endif

	#endif

	#if defined _reapi_included
	RegisterHookChain(RG_CBasePlayer_Killed, "FwdKilledPost", 1);
	#else
	RegisterHam(Ham_Killed, "player", "FwdKilledPost", 1);
	#endif

	g_HudSyncObj = CreateHudSyncObj();
}

#if defined SHOW_DAMAGE
public client_putinserver(id) {
	g_Damage[id] = 0.0;
}

public EventHLTV() {
	arrayset(_:g_Damage, _:0.0, sizeof g_Damage);
}

public FwdTakeDamage(const Victim, const Inflictor, const Attacker, const Float:Damage) {
	if(Attacker && Attacker != Victim && is_user_alive(Attacker)) {
		g_Damage[Attacker] += Damage;
	}
}
#endif

public FwdKilledPost(const Victim, const Killer) {
	if(is_user_alive(Killer)) {
		new Name[32];
		get_user_name(Killer, Name, charsmax(Name));

		set_hudmessage(HUD_DATA[RED], HUD_DATA[GREEN], HUD_DATA[BLUE], HUD_DATA[X], HUD_DATA[Y], .holdtime = HUD_DATA[TIME], .channel = -1);

		#if defined SHOW_DAMAGE
		ShowSyncHudMsg(Victim, g_HudSyncObj, "%L^n%L", Victim, "HKI_MSG", Name, get_user_health(Killer), get_user_armor(Killer), Victim, "HKI_DMG", g_Damage[Victim]);
		#else
		ShowSyncHudMsg(Victim, g_HudSyncObj, "%L", Victim, "HKI_MSG", Name, get_user_health(Killer), get_user_armor(Killer));
		#endif
	}
}
