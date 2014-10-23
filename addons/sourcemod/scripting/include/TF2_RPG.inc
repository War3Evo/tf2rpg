// TF2_RPG.inc

#if defined _TF2_RPG_included
 #endinput
#endif
#define _TF2_RPG_included

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

/**
 *
 * @param plugin_name			the plugin name without path and extension
 * @param client				client index.
 * @param buff_name				the name of the buff
 * @param value					any value
 *
 * @return						return Plugin_Handled if player can purchase item.
 *
 */
forward Action:OnItemPurchase(const String:plugin_name[], client, const String:buff_name[], any:value)

/**
 *
 * @param plugin_name			the plugin name without path and extension
 * @param client				client index.
 * @param buff_name				the name of the buff
 * @param value					any value
 *
 * @noreturn
 *
 */
forward OnItemLost(const String:plugin_name[], client, const String:buff_name[], any:value)

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

/*
 * May remove, keeping for future reference
 *
stock AddShopItemNumber(Handle:handleArray, TheArray[1])
{
	// Make sure it is a duplicate
	new TmpBuffer[1];
	for(new i = 0; i < GetArraySize(handleArray); i++)
	{

		GetArrayArray(handleArray, i, TmpBuffer);
		// If first number is duplicate, return
		if(TheArray[0] == TmpBuffer[0])
		{
			return i;
		}
	}
	PushArrayCell(handleArray, TheArray);

	return -1;
}*/

/**
 * Gets the Base name of a path.
 * Examples:
 * blub.txt -> "blub.txt"
 * /sourcemod/extensions/example.ext.so -> "example.ext.so"
 *
 * @param path			File path
 * @param buffer		String buffer array
 * @param size			Size of string buffer
 * @noreturn
 */
stock bool:File_GetBaseName(const String:path[], String:buffer[], size)
{
	if (path[0] == '\0') {
		buffer[0] = '\0';
		return;
	}

	new pos_start = FindCharInString(path, '/', true);

	if (pos_start == -1) {
		pos_start = FindCharInString(path, '\\', true);
	}

	pos_start++;

	strcopy(buffer, size, path[pos_start]);
}

/**
 * Gets the File name of a path.
 * blub.txt -> "blub"
 * /sourcemod/extensions/example.ext.so -> "example.ext"
 *
 * @param path			File path
 * @param buffer		String buffer array
 * @param size			Size of string buffer
 * @noreturn
 */
stock bool:File_GetFileName(const String:path[], String:buffer[], size)
{
	if (path[0] == '\0') {
		buffer[0] = '\0';
		return;
	}

	File_GetBaseName(path, buffer, size);

	new pos_ext = FindCharInString(buffer, '.', true);

	if (pos_ext != -1) {
		buffer[pos_ext] = '\0';
	}
}

stock GetPluginName(String:buffer[],maxlength)
{
	decl String:pluginName[80];
	GetPluginFilename(INVALID_HANDLE, pluginName, maxlength);
	File_GetFileName(pluginName, pluginName, maxlength)
	ReplaceString(pluginName, maxlength, ".smx", "", false);
	strcopy(buffer, 80, pluginName);
}

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
