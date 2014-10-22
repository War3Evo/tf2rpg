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
new Handle:g_hLevelXP;

//=============================================================================
// OnPluginStart
//=============================================================================
public OnPluginStart()
{
	RegConsoleCmd("rpgtest",RPG_TESTING_CONFIG,"testing");

	//	new Array[X][2]
	g_hWeaponsXP = CreateArray(2);
	g_hLevelXP = CreateArray(2);
}

public Action:RPG_TESTING_CONFIG(client,args)
{
	if(ParseFile())
	{

	}

	return Plugin_Handled;
}

AddStringToNumber(Handle:handleString, const String:key[], Handle:handlePoints, iPoints)
{
	new String:TmpStr[32];
	for(new i = 0; i < GetArraySize(handleString); i++)
	{

		GetArrayString(handleString, i, TmpStr, sizeof(TmpStr));
		// If duplicate, overwrite
		if(strcmp(TmpStr, key) == 0)
		{
			SetArrayCell(handlePoints, i, iPoints);
			return i;
		}
	}
	PushArrayString(handleString, key);
	PushArrayCell(handlePoints, iPoints);
	//DP("String: %s Number: %d",key,iPoints);

	return -1;
}

bool:ParseFile()
{
	decl String:path[1024],String:vip_map_file_path[1024];

	GetConVarString("configs/tf2_rpg_xp.cfg", vip_map_file_path, sizeof(vip_map_file_path));

	BuildPath(Path_SM,path,sizeof(path),vip_map_file_path);

	/* Return true if an update was available. */
	new Handle:kv = CreateKeyValues("TF2_RPG_XP");

	if (!FileToKeyValues(kv, path))
	{
		CloseHandle(kv);
		return false;
	}

	ClearArray(g_hWeaponsXP);
	ClearArray(g_hLevelXP);

	new String:sBuffer[32];

	if (KvJumpToKey(kv, "level_progression"))
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				KvGetSectionName(kv, sBuffer, sizeof(sBuffer));

				// if yes
				KvGetNum(kv, NULL_STRING, defvalue=0);
				if(KvGetYesOrNo(kv, NULL_STRING,false))
				{
					AddStringOnly(g_h, sBuffer);
				}
			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}

		KvGoBack(kv);
	}

	CloseHandle(kv);

	return true;
}
