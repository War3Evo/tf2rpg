// TF2_RPG.inc

#if defined _TF2_RPG_included
 #endinput
#endif
#define _TF2_RPG_included

#undef REQUIRE_EXTENSIONS
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <sdktools_functions>
#include <tf2>
#include <tf2_stocks>
#include <morecolors>
#include <keyvalues>
#include <tf2attributes>

#include "TF2_RPG/include/TF2_RPG_Constants"
#include "TF2_RPG/include/TF2_RPG_PlayerProp"

// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives
// natives natives natives natives natives natives natives natives natives natives natives natives natives natives

native RPG_SetLevel(client, race, level);
native RPG_GetLevel(client, race);


// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards
// forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards forwards


/*
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 * STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
 */


stock Float:calcDistance(Float:x1,Float:x2,Float:y1,Float:y2,Float:z1,Float:z2){
	//Distance between two 3d points
	new Float:dx = x1-x2;
	new Float:dy = y1-y2;
	new Float:dz = z1-z2;

	return(SquareRoot(dx*dx + dy*dy + dz*dz));
}

stock Float:TF2_GetClassSpeed(TFClassType:class)
{
		switch (class)
		{
				case TFClass_Scout:     return 400.0;
				case TFClass_Soldier:   return 240.0;
				case TFClass_DemoMan:   return 280.0;
				case TFClass_Medic:     return 320.0;
				case TFClass_Pyro:      return 300.0;
				case TFClass_Spy:       return 300.0;
				case TFClass_Engineer:  return 300.0;
				case TFClass_Sniper:    return 300.0;
				case TFClass_Heavy:     return 230.0;
		}
		return 0.0;
}
stock TF2_GetCurrentWeaponClass(client, String:name[], maxlength)
{
	if( client > 0 )
	{
		new index = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if (index > 0)
			GetEntityNetClass(index, name, maxlength);
	}
}
stock TF2_GetHealingTarget(client)
{
	new String:classname[64];
	TF2_GetCurrentWeaponClass(client, classname, sizeof(classname));

	if( StrEqual(classname, "CWeaponMedigun") )
	{
		new index = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if( GetEntProp(index, Prop_Send, "m_bHealing") == 1 )
		{
			return GetEntPropEnt(index, Prop_Send, "m_hHealingTarget");
		}
	}

	return -1;
}
stock TF_SetUberLevel(client, Float:uberlevel)
{
	new index = GetPlayerWeaponSlot(client, 1);
	if (index > 0)
		SetEntPropFloat(index, Prop_Send, "m_flChargeLevel", uberlevel*0.01);
}
stock Float:TF_GetUberLevel(client)
{
	new index = GetPlayerWeaponSlot(client, 1);
	if (index > 0)
		return GetEntPropFloat(index, Prop_Send, "m_flChargeLevel")*100.0;
	else
		return 0.0;
}
stock TF_SetCloakLevel(client, Float:cloaklevel)
{
	//new index = GetPlayerWeaponSlot(client, 1);
	//if (index > 0)
	if (ValidPlayer(client))
		SetEntPropFloat(client, Prop_Send, "m_flCloakMeter", cloaklevel);
}
stock Float:TF_GetCloakLevel(client)
{
	//new index = GetPlayerWeaponSlot(client, 1);
	if (ValidPlayer(client))
		return GetEntPropFloat(client, Prop_Send, "m_flCloakMeter");
	else
		return 0.0;
}

stock bool:IS_PLAYER(x)
{
	if(x>0&&x<=MaxClients)
	return true;
	return false;
}

stock bool:TF2_RPG_Chance(Float:chancepercent=1.0) {
	return (GetRandomFloat(0.0,1.0)<=chancepercent);
}

stock Float:GetPlayerDistance(client1,client2) {
	static Float:vec1[3];
	static Float:vec2[3];
	GetClientAbsOrigin(client1,vec1);
	GetClientAbsOrigin(client2,vec2);
	return GetVectorDistance(vec1,vec2);
}
stock bool:IsSpying(client)
{
	// Can a class really be disguised if not SPY?  or cloaked if not spy??
	if(TF2_GetPlayerClass(client)==TFClass_Spy)
	{
		return (TF2_IsPlayerInCondition(client,TFCond_Disguising)||TF2_IsPlayerInCondition(client,TFCond_Disguised) || TF2_IsPlayerInCondition(client,TFCond_Cloaked));
	}
	return false;
}
stock GetApparentTeam(client) {
	new team = GetClientTeam(client);
	if (Spying(client)) {
		if (team == 2)
			team++;
		else if (team == 3)
			team--;
	}
	return team;
}
/**
 * Prints Message to server and all chat
 * For debugging prints
 */
stock DP(const String:szMessage[], any:...)
{

	decl String:szBuffer[1000];

	VFormat(szBuffer, sizeof(szBuffer), szMessage, 2);
	PrintToServer("[DebugP %d] %s",RoundFloat(GetGameTime())%100, szBuffer);
	PrintToChatAll("[DebugP %d] %s",RoundFloat(GetGameTime())%100, szBuffer);

}

/**
 * returns the larger integer of the two
 */
stock IntMax(one, two) {
	return one > two ? one : two;
}

// Other Includes

#include "TF2_RPG/include/TF2_RPG_Money"


public SharedPlugin:__pl_TF2_RPG =
{
	name = "TF2_RPG",
	file = "TF2_RPG.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_TF2_RPG_SetNTVOptional()
{
	//MarkNativeAsOptional("native_here");
	MarkNativeAsOptional("RPG_SetXP");
	MarkNativeAsOptional("RPG_GetXP");

	MarkNativeAsOptional("RPG_SetLevel");
	MarkNativeAsOptional("RPG_GetLevel");
}
#endif
