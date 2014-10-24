// TF2_RPG_000_OnPluginStart.sp

public Plugin:myinfo=
{
	name="TF2 RPG OnPluginStart",
	author=AUTHORS,
	description="TF2 RPG Core Plugins",
	version=VERSION_NUM,
};

//=============================================================================
// OnPluginStart
//=============================================================================
public OnPluginStart()
{

	PrintToServer("--------------------------OnPluginStart----------------------\n[TF2 RPG] Plugin Loading...");

	if(GetExtensionFileStatus("sdkhooks.ext") < 1)
		SetFailState("SDK Hooks is not loaded.");

	//RPGSource_Database_OnPluginStart();
	TF2_RPG_LoadConfiguration_OnPluginStart();
	TF2_RPG_000_OnPlayerDeath_OnPluginStart();
	TF2_RPG_ShopItem_Engine_OnPluginStart();
	TF2_RPG_CommandHook_OnPluginStart();

	PrintToServer("[TF2 RPG] Plugin finished loading.\n-------------------END OnPluginStart-------------------");
}
