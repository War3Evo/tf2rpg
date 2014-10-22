// TF2_RPG_LoadConfiguration.sp


public Plugin:myinfo=
{
	name="TF2 RPG Load Configuration",
	author=AUTHORS,
	description="TF2 RPG Core Plugins",
	version=VERSION_NUM,
};

public TF2_RPG_LoadConfiguration_OnPluginStart()
{
	g_hWeaponsXP = CreateArray(2);
	g_hLevel_Progression = CreateArray(2);
}

stock AddArray(Handle:handleArray, TheArray[2])
{
	// Make sure it is a duplicate
	new TmpBuffer[2];
	for(new i = 0; i < GetArraySize(handleArray); i++)
	{

		GetArrayArray(handleArray, i, TmpBuffer);
		// If first number is duplicate, overwrite
		if(TheArray[0] == TmpBuffer[0])
		{
			SetArrayArray(handleArray, i, TheArray);
			return i;
		}
	}
	PushArrayArray(handleArray, TheArray);

	return -1;
}

public bool:LoadConfigurationFile()
{
	decl String:path[1024];

	BuildPath(Path_SM,path,sizeof(path),"configs/tf2_rpg_xp.cfg");

	/* Return true if an update was available. */
	new Handle:kv = CreateKeyValues("TF2_RPG_XP");

	if (!FileToKeyValues(kv, path))
	{
		CloseHandle(kv);
		return false;
	}

	ClearArray(g_hWeaponsXP);
	ClearArray(g_hLevel_Progression);

	new String:sBuffer[16];

	new KvArray[2];

	if (KvJumpToKey(kv, "level_progression"))
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				KvGetSectionName(kv, sBuffer, sizeof(sBuffer));

				KvArray[0] = StringToInt(sBuffer);

				KvArray[1] = KvGetNum(kv, NULL_STRING);

				AddArray(g_hLevel_Progression, KvArray);

			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}

		KvGoBack(kv);
	}

	if (KvJumpToKey(kv, "weapons"))
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				KvGetSectionName(kv, sBuffer, sizeof(sBuffer));

				KvArray[0] = StringToInt(sBuffer);

				KvArray[1] = KvGetNum(kv, NULL_STRING);

				AddArray(g_hWeaponsXP, KvArray);

			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}

		KvGoBack(kv);
	}
	CloseHandle(kv);

	return true;
}
