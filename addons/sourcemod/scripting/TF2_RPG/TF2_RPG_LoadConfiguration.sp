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

public bool:Load_XP_ConfigurationFile()
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


// not complete yet
public bool:Load_ITEMS_ConfigurationFile()
{
	decl String:path[1024];

	BuildPath(Path_SM,path,sizeof(path),"configs/tf2_rpg_shopitems.cfg");

	/* Return true if an update was available. */
	new Handle:kv = CreateKeyValues("TF2_RPG_SHOPMENU1");

	if (!FileToKeyValues(kv, path))
	{
		CloseHandle(kv);
		return false;
	}

	KvRewind(kv);

	ClearArray(g_hItemNumber);
	ClearArray(g_h_ItemCategorys);
	ClearArray(g_hItemPluginName);
	ClearArray(g_hItemLongName);
	ClearArray(g_hItemShortDesc);
	ClearArray(g_hItemLongDesc);
	ClearArray(g_hItemCost);
	ClearArray(g_hItemClass);
	ClearArray(g_hItemBuyName);
	ClearArray(g_hItemBuffName);
	ClearArray(g_hItemValue);

/*
	g_hItemNumber = CreateArray(1);
	g_h_ItemCategorys = CreateArray(ByteCountToCells(64)); //string
	g_hItemPluginName = CreateArray(ByteCountToCells(64)); //string
	g_hItemLongName = CreateArray(ByteCountToCells(32)); //string
	g_hItemShortDesc = CreateArray(ByteCountToCells(32)); //string
	g_hItemLongDesc = CreateArray(ByteCountToCells(192)); //string
	g_hItemCost = CreateArray(1);
	g_hItemClass = CreateArray(1);
	g_hItemBuyName = CreateArray(ByteCountToCells(16)); //string
	g_hItemBuffName = CreateArray(ByteCountToCells(16)); //string
	g_hItemValue = CreateArray(1);
*/
	decl String:sSectionBuffer[32];
	decl String:sSubKeyBuffer[32];

	decl String:sTempBuffer[64];

	do
	{
		// You can read the section/key name by using KvGetSectionName here.

		if(KvGetSectionName(kv, sSectionBuffer, sizeof(sSectionBuffer)))
		{
			PrintToServer("Loading item.. %s",sSectionBuffer);
			PushArrayCell(g_hItemNumber, GetArraySize(g_hItemNumber)+1);

			if (KvGotoFirstSubKey(kv, false))
			{
				// Current key is a section. Browse it recursively.
				do
				{
					if(KvGetSectionName(kv, sSubKeyBuffer, sizeof(sSubKeyBuffer)))
					{
						if(StrEqual(sSubKeyBuffer,"plugin_name"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemPluginName, sTempBuffer); // needs work
						}
						else if(StrEqual(sSubKeyBuffer,"item_category"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemPluginName, sTempBuffer); // needs work
						}
						else if(StrEqual(sSubKeyBuffer,"translation_file"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemPluginName, sTempBuffer); // needs work
						}
						else if(StrEqual(sSubKeyBuffer,"item_long_name"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemLongName, sTempBuffer);
						}
						else if(StrEqual(sSubKeyBuffer,"short_description"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemShortDesc, sTempBuffer);
						}
						else if(StrEqual(sSubKeyBuffer,"long_description"))
						{
							KvGetString(kv, sSubKeyBuffer, sTempBuffer, sizeof(sTempBuffer));
							PushStackString(g_hItemLongDesc, sTempBuffer);
						}
						else if(StrEqual(sSubKeyBuffer,"cost"))
						{
							PushArrayCell(g_hItemCost, KvGetNum(kv, sSubKeyBuffer));
						}
					}
				} while (KvGotoNextKey(kv, false));
				KvGoBack(kv);
			}
		}
	} while (KvGotoNextKey(kv, false));


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
