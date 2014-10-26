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

	g_hItemNumber = CreateArray(1);
	g_h_ItemCategorys = CreateArray(ByteCountToCells(64)); //string
	g_hItemPluginName = CreateArray(ByteCountToCells(64)); //string
	g_hItemTranslationFile = CreateArray(ByteCountToCells(64)); //string
	g_hItemLongName = CreateArray(ByteCountToCells(32)); //string
	g_hItemShortDesc = CreateArray(ByteCountToCells(32)); //string
	g_hItemLongDesc = CreateArray(ByteCountToCells(192)); //string
	g_hItemCost = CreateArray(1);
	g_hItemClass = CreateArray(1);
	g_hItemBuyName = CreateArray(ByteCountToCells(16)); //string
	g_hItemTeam = CreateArray(ByteCountToCells(16)); //string
	g_hItemBuffName = CreateArray(ByteCountToCells(16)); //string
	g_hItemBuffValue = CreateArray(1);

	Load_XP_ConfigurationFile();

	if(!Load_ITEMS_ConfigurationFile())
	{
		LogError("[TF2RPG] configs/tf2_rpg_shopitems.cfg not correctly setup or missing file");
		SetFailState("[TF2RPG] ERROR With configs/tf2_rpg_shopitems.cfg configuration file!");
	}
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
	ClearArray(g_hItemTranslationFile);
	ClearArray(g_hItemLongName);
	ClearArray(g_hItemShortDesc);
	ClearArray(g_hItemLongDesc);
	ClearArray(g_hItemCost);
	ClearArray(g_hItemClass);
	ClearArray(g_hItemBuyName);
	ClearArray(g_hItemTeam);
	ClearArray(g_hItemBuffName);
	ClearArray(g_hItemBuffValue);

	decl String:sSectionBuffer[64];
	decl String:sSubKeyBuffer[64];

	decl String:sTempBuffer[192];

	new bool:found=false;

	//NO ITEM ZERO
	PushArrayCell(g_hItemNumber, GetArraySize(g_hItemNumber)+1);
	PushArrayString(g_hItemPluginName, "zero item");
	PushArrayString(g_h_ItemCategorys, "zero item");
	PushArrayString(g_hItemTranslationFile, "zero item");
	PushArrayString(g_hItemLongName, "zero item");
	PushArrayString(g_hItemShortDesc, "zero item");
	PushArrayString(g_hItemLongDesc, "zero item");
	PushArrayCell(g_hItemCost, 0);
	PushArrayCell(g_hItemClass, 0);
	PushArrayString(g_hItemBuyName, "zero item");
	PushArrayCell(g_hItemTeam, 0);
	PushArrayString(g_hItemBuffName, "zero item");
	PushArrayCell(g_hItemBuffValue, 0);

	do
	{
		// You can read the section/key name by using KvGetSectionName here.
		//PrintToChatAll("do loop\n");

		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				if(KvGetSectionName(kv, sSectionBuffer, sizeof(sSectionBuffer)))
				{
					//PrintToChatAll(sSectionBuffer);
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
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemPluginName, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"item_category"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_h_ItemCategorys, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"translation_file"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemTranslationFile, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"item_long_name"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemLongName, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"short_description"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemShortDesc, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"long_description"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemLongDesc, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"cost"))
								{
									PushArrayCell(g_hItemCost, KvGetNum(kv, NULL_STRING));
								}
								else if(StrEqual(sSubKeyBuffer,"class"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									found=false;
									for (new i = 0; i < sizeof(TFClassTypeString); i++)
									{
										if(StrEqual(TFClassTypeString[i],sTempBuffer))
										{
											found=true;
											PushArrayCell(g_hItemClass, i);
											break;
										}
									}
									if(!found)
									{
										PushArrayCell(g_hItemClass, 0);
									}
								}
								else if(StrEqual(sSubKeyBuffer,"item_buy_name"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemBuyName, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"team"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									if(StrEqual(sTempBuffer,"red"))
									{
										PushArrayCell(g_hItemTeam, 2);
									}
									else if(StrEqual(sTempBuffer,"blue"))
									{
										PushArrayCell(g_hItemTeam, 3);
									}
									else
									{
										PushArrayCell(g_hItemTeam, 0);
									}
								}
								else if(StrEqual(sSubKeyBuffer,"item_buff_name"))
								{
									KvGetString(kv, NULL_STRING, sTempBuffer, sizeof(sTempBuffer));
									PushArrayString(g_hItemBuffName, sTempBuffer);
								}
								else if(StrEqual(sSubKeyBuffer,"item_buff_value"))
								{
									PushArrayCell(g_hItemBuffValue, KvGetNum(kv, NULL_STRING));
								}
							}
						} while (KvGotoNextKey(kv, false));
						KvGoBack(kv);
					}
				}
			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}
	} while (KvGotoNextKey(kv, false));

	//PrintToChatAll("Finished");

	CloseHandle(kv);

/*
	g_hItemNumber = CreateArray(1);
	g_h_ItemCategorys = CreateArray(ByteCountToCells(64)); //string
	g_hItemPluginName = CreateArray(ByteCountToCells(64)); //string
	g_hItemTranslationFile = CreateArray(ByteCountToCells(64)); //string
	g_hItemLongName = CreateArray(ByteCountToCells(32)); //string
	g_hItemShortDesc = CreateArray(ByteCountToCells(32)); //string
	g_hItemLongDesc = CreateArray(ByteCountToCells(192)); //string
	g_hItemCost = CreateArray(1);
	g_hItemClass = CreateArray(1);
	g_hItemBuyName = CreateArray(ByteCountToCells(16)); //string
	g_hItemTeam = CreateArray(1);
	g_hItemBuffName = CreateArray(ByteCountToCells(16)); //string
	g_hItemBuffValue = CreateArray(1);
*/

	// Make sure we loaded the configuration file correctly
	if(GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemPluginName)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemTranslationFile)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemLongName)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemShortDesc)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemLongDesc)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemCost)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemClass)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemBuyName)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemTeam)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemBuffName)
	&&GetArraySize(g_h_ItemCategorys)==GetArraySize(g_hItemBuffValue))
	{
		ItemsLoaded = GetArraySize(g_hItemNumber) - 1;

		return true;
	}
	return false;
}
