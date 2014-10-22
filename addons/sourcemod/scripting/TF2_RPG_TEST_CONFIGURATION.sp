// not finished
// will be used for testing and making the KV system work

#pragma semicolon 1


public Plugin:myinfo=
{
	name="TF2 RPG test",
	author="El Diablo",
	description="blah",
	version="1.0",
	url = "http://www.war3evo.info/"
};

new Handle:g_hWeaponsXP;
new Handle:g_hLevel_Progression;

//=============================================================================
// OnPluginStart
//=============================================================================
public OnPluginStart()
{
	RegConsoleCmd("rpgtest",RPG_TESTING_CONFIG,"rpgtest");

	//	new Array[X][2]
	g_hWeaponsXP = CreateArray(2);
	g_hLevel_Progression = CreateArray(2);
}

public Action:RPG_TESTING_CONFIG(client,args)
{
	if(ParseFile())
	{
		new String:path[256];
		BuildPath(Path_SM, path, sizeof(path), "logs/rpgtest.log");

		new TmpBuffer[2];

		for(new i = 0; i < GetArraySize(g_hLevel_Progression); i++)
		{

			GetArrayArray(g_hLevel_Progression, i, TmpBuffer);
			LogToFile(path, "Level %d --- XP Required %d",TmpBuffer[0],TmpBuffer[1]);
		}
		for(new i = 0; i < GetArraySize(g_hWeaponsXP); i++)
		{

			GetArrayArray(g_hWeaponsXP, i, TmpBuffer);
			LogToFile(path, "Weapon # %d --- XP Gainned %d",TmpBuffer[0],TmpBuffer[1]);
		}

	}

	return Plugin_Handled;
}

AddArray(Handle:handleArray, TheArray[2])
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

bool:ParseFile()
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
