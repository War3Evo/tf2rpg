// TF2_RPG_000_OnPluginStart.sp

//=============================================================================
// OnPluginStart
//=============================================================================
public OnPluginStart()
{

	PrintToServer("--------------------------OnPluginStart----------------------\n[TF2 RPG] Plugin Loading...");

	if(GetExtensionFileStatus("sdkhooks.ext") < 1)
		SetFailState("SDK Hooks is not loaded.");

	RPGSource_Database_OnPluginStart();

	PrintToServer("[TF2 RPG] Plugin finished loading.\n-------------------END OnPluginStart-------------------");
}
