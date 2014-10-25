// not finished
// will be used for testing and making the KV system work

#pragma semicolon 1

//#include <smlib>

#include <sdktools>


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

new Handle:g_hItemNumber;
new Handle:g_h_ItemCategorys;
new Handle:g_hItemPluginName;
new Handle:g_hItemTranslationFile;
new Handle:g_hItemLongName;
new Handle:g_hItemShortDesc;
new Handle:g_hItemLongDesc;
new Handle:g_hItemCost;
new Handle:g_hItemClass;
new Handle:g_hItemBuyName;
new Handle:g_hItemTeam;
new Handle:g_hItemBuffName;
new Handle:g_hItemBuffValue;

/*
enum TFClassType
{
	TFClass_Unknown = 0,
	TFClass_Scout,
	TFClass_Sniper,
	TFClass_Soldier,
	TFClass_DemoMan,
	TFClass_Medic,
	TFClass_Heavy,
	TFClass_Pyro,
	TFClass_Spy,
	TFClass_Engineer
};*/

stock const String:TFClassTypeString[][] = {
					"all",
					"scout",
					"sniper",
					"soldier",
					"demoman",
					"medic",
					"heavy",
					"pyro",
					"spy",
					"engineer"
};

//=============================================================================
// OnPluginStart
//=============================================================================
public OnPluginStart()
{
	RegConsoleCmd("rpgtest",RPG_TESTING_CONFIG,"rpgtest");
	//RegConsoleCmd("rpgtest2",RPG_TESTING_2,"rpgtest2");

	//	new Array[X][2]
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
}
/*
public Action:RPG_TESTING_2(client,args)
{
	decl String:pluginName[80];
	GetPluginFilename(INVALID_HANDLE, pluginName, 80);
	File_GetFileName(pluginName, pluginName, 80);
	ReplaceString(pluginName, 80, ".smx", "", false);

	PrintToChatAll(pluginName);
}*/

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

	if(Load_ITEMS_ConfigurationFile())
	{
		new String:path[256];
		BuildPath(Path_SM, path, sizeof(path), "logs/rpgtest2.log");

		new String:TmpBuffer[192];

		for(new i = 0; i < GetArraySize(g_hItemNumber); i++)
		{
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
			g_hItemTeam = CreateArray(ByteCountToCells(16)); //string
			g_hItemBuffName = CreateArray(ByteCountToCells(16)); //string
			g_hItemBuffValue = CreateArray(1);
			*/

			GetArrayString(g_h_ItemCategorys, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - category %s",i,TmpBuffer);

			GetArrayString(g_hItemPluginName, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - plugin %s",i,TmpBuffer);

			GetArrayString(g_hItemTranslationFile, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - translation %s",i,TmpBuffer);

			GetArrayString(g_hItemLongName, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - longname %s",i,TmpBuffer);

			GetArrayString(g_hItemShortDesc, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - shortdesc %s",i,TmpBuffer);

			GetArrayString(g_hItemLongDesc, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - longdesc %s",i,TmpBuffer);

			LogToFile(path, "Item# %d - cost %d",i,GetArrayCell(g_hItemCost, i));

			LogToFile(path, "Item# %d - class %d",i,GetArrayCell(g_hItemClass, i));

			GetArrayString(g_hItemBuyName, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - buyname %s",i,TmpBuffer);

			LogToFile(path, "Item# %d - team %d",i,GetArrayCell(g_hItemTeam, i));

			GetArrayString(g_hItemBuffName, i, TmpBuffer, sizeof(TmpBuffer));
			LogToFile(path, "Item# %d - buffname %s",i,TmpBuffer);

			LogToFile(path, "Item# %d - buffvalue %d",i,GetArrayCell(g_hItemBuffValue, i));
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
	decl String:sSectionBuffer[32];
	decl String:sSubKeyBuffer[32];

	decl String:sTempBuffer[64];

	new bool:found=false;

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

	return true;
}
