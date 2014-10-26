// TF2_RPG_ShopItem_Engine.sp

// ShopItem Engine will store all shopitem information for retrieval later

//new Handle:g_hShopItemNumber;

public TF2_RPG_ShopItem_Engine_OnPluginStart()
{
	LoadTranslations("tf2_rpg.shopmenu.phrases.txt");
	LoadTranslations("tf2_rpg.item_categories.phrases.txt");
}

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

/*
 * Theory:  probably do not need this function, will probably just load the whole configuration and
 * call a function with that configuration before a item is purchased to see if it is bought or not
 *
public OnRegisterShopItem(const String:plugin_name[], const String:item_long_name[], const String:short_description[], const String:long_description[], cost, class, item_buy_name, const String:buff_name[], any:value)
{
	if(StrEqual(ThisPluginName,plugin_name))
	{
		new TmpItemNum=0;
		TmpItemNum=RPG_CreateShopItem(item_buy_name, item_long_name, short_description, long_description, cost, buff_name, value);
		if(TmpItemNum>0)
		{
			AddShopItemNumber(g_hShopItemNumber, TmpItemNum);
		}
	}
}*/

public TF2_RPG_ShopItem_Engine_InitNatives()
{
	CreateNative("RPG_GetItemIdByBuyname",Native_RPG_GetItemIdByBuyname);

	CreateNative("RPG_GetItemsLoaded",Native_GetItemsLoaded);

	CreateNative("RPG_GetItemName",Native_RPG_GetItemName);
	CreateNative("RPG_GetItemBuyname",Native_RPG_GetItemBuyname);
	CreateNative("RPG_GetItemShortDesc",Native_RPG_GetItemShortDesc);
	CreateNative("RPG_GetItemDescription",Native_RPG_GetItemDescription);

	CreateNative("RPG_GetItemCost",Native_RPG_GetItemCost);

	CreateNative("RPG_GetItemCategory",Native_RPG_GetItemCategory);

	CreateNative("RPG_GetItemClass",Native_RPG_GetItemClass);

	CreateNative("RPG_GetItemTeam",Native_RPG_GetItemTeam);
}

public TF2_RPG_ShopItem_Engine_Forwards()
{
	//
	g_hOnCanPurchaseItem	= CreateGlobalForward("OnCanPurchaseItem", ET_Hook, Param_Cell, Param_String, Param_Cell, Param_String, Param_Any);
	g_hOnItemPurchase		= CreateGlobalForward("OnItemPurchase", ET_Hook, Param_Cell, Param_String, Param_Cell, Param_String, Param_Any);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// SHOPMENU
///////////////////////////////////////////////////////////////////////////////////////////////////

ShowMenuShopCategory(client)
{
	new Handle:shopMenu = CreateMenu(RPG_ShopMenuCategory_Sel);
	SetMenuExitButton(shopMenu, true);
	//new currency = RPG_GetCurrency(client);

	new String:title[300];
	Format(title,sizeof(title), "%T\n", "[TF2RPG] Browse the itemshop. You have {amount}/{amount} items", client, 0, 3);
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", client, GetPlayerProp(client,iMoney), MaxCurrency);
	//Format(title, sizeof(title), "%s%s", title, currencyName);

	SetMenuTitle(shopMenu,title);

	new TFClassType:SearchClass=TFClass_Unknown;

	new TFClassType:CurrentClass=TF2_GetPlayerClass(client);

	decl String:category[64];
	decl String:linestr[96];

	new Handle:h_TempItemCategorys = CreateArray(ByteCountToCells(64));

	for(new i = 1; i <= ItemsLoaded; i++)
	{
		SearchClass = TFClassType:GetArrayCell(g_hItemClass, i);
		if(SearchClass==TFClass_Unknown || SearchClass==CurrentClass)
		{
			GetArrayString(g_h_ItemCategorys, i, category, sizeof(category));

			if ((FindStringInArray(h_TempItemCategorys, category) >= 0) || StrEqual(category, ""))
			continue;
			else
			PushArrayString(h_TempItemCategorys, category);
		}
	}

	// fill the menu with the categorys
	while(GetArraySize(h_TempItemCategorys))
	{
		GetArrayString(h_TempItemCategorys, 0, category, sizeof(category));

		Format(linestr,sizeof(linestr), "%T", category, client);

		AddMenuItem(shopMenu, category, linestr, ITEMDRAW_DEFAULT);
		RemoveFromArray(h_TempItemCategorys, 0);
	}

	CloseHandle(h_TempItemCategorys);

	DisplayMenu(shopMenu,client,20);
}

public RPG_ShopMenuCategory_Sel(Handle:menu, MenuAction:action, client, selection)
{
	if(action==MenuAction_Select)
	{
		if(IsValidPlayer(client))
		{
			decl String:SelectionInfo[64];
			decl String:SelectionDispText[256];
			new SelectionStyle;
			GetMenuItem(menu, selection, SelectionInfo, sizeof(SelectionInfo), SelectionStyle, SelectionDispText,sizeof(SelectionDispText));

			ShowMenuShop(client, SelectionInfo);
		}
	}
	if(action==MenuAction_End)
	{
		CloseHandle(menu);
	}
}

ShowMenuShop(client, const String:category[]="")
{
	new Handle:shopMenu=CreateMenu(RPG_ShopMenu_Selected);
	SetMenuExitButton(shopMenu,true);

	new CurrentCurrency=GetPlayerProp(client,iMoney);

	new TFClassType:CurrentClass=TF2_GetPlayerClass(client);

	decl String:title[300];
	//decl String:currencyName[MAX_CURRENCY_NAME];
	//RPG_GetCurrencyName(currency, currencyName, sizeof(currencyName));

	Format(title,sizeof(title), "%T\n", "[TF2RPG] Browse the itemshop. You have {amount}/{amount} items", client, 0, 3);
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", client, CurrentCurrency, MaxCurrency);
	//Format(title, sizeof(title), "%s%s ", title, CurrencyName);

	SetMenuTitle(shopMenu,title);

	decl String:itemname[64];
	decl String:itembuf[4];
	decl String:linestr[96];
	decl String:itemcategory[64];
	decl String:itemshortdesc[32];
	new cost;
	//new bool:useCategory = GetConVarBool(hUseCategorysCvar);
	//new BackButton=0;
	//if (useCategory)
	//{
	AddMenuItem(shopMenu,"-1","[Return to Categories]");
	//}

	new TFClassType:SearchClass;

	for(new i = 1; i <= ItemsLoaded; i++)
	{
		SearchClass = TFClassType:GetArrayCell(g_hItemClass, i);
		if(SearchClass==TFClass_Unknown || SearchClass==CurrentClass)
		{
			GetArrayString(g_h_ItemCategorys, i, itemcategory, sizeof(itemcategory));

			if (StrEqual(category, itemcategory))
			{
				// add item
				xRPG_GetItemName(i,itemname,sizeof(itemname),client);

				cost=RPG_GetItemCost(i);
				if(xRPG_GetOwnsItem(client,i))
				{
					Format(linestr,sizeof(linestr), ">%s - %d", itemname, cost);
				}
				else
				{
					Format(linestr,sizeof(linestr), "%s - %d", itemname, cost);
				}

				xRPG_GetItemShortDesc(i,itemshortdesc,sizeof(itemshortdesc),client);

				Format(linestr,sizeof(linestr),"%s\n%s",linestr,itemshortdesc);

				Format(itembuf,sizeof(itembuf),"%d",i);

				AddMenuItem(shopMenu,itembuf,linestr,ITEMDRAW_DEFAULT);
			}
		}
	}

	DisplayMenu(shopMenu,client,20);
}

public RPG_ShopMenu_Selected(Handle:menu,MenuAction:action,client,selection)
{
	if(action==MenuAction_Select)
	{
		if(IsValidPlayer(client))
		{
			decl String:SelectionInfo[4];
			decl String:SelectionDispText[256];
			new SelectionStyle;
			GetMenuItem(menu,selection,SelectionInfo,sizeof(SelectionInfo),SelectionStyle, SelectionDispText,sizeof(SelectionDispText));
			new itemIndex=StringToInt(SelectionInfo);
			//new bool:useCategory = GetConVarBool(hUseCategorysCvar);
			//if(item==-1&&useCategory)
			if(itemIndex==-1)
			{
				ShowMenuShopCategory(client);
			}
			else
			{
				RPG_TryToBuyItem(client,itemIndex,true);
			}
		}
	}
	if(action==MenuAction_End)
	{
		CloseHandle(menu);
	}
}

stock bool:RPG_TryToBuyItem(client,ItemIndex,bool:reshowmenu=true)
{
	if(ItemIndex>ItemsLoaded)
	{
		LogError("item>ItemsLoaded item = %d and other = %d",ItemIndex,ItemsLoaded);
		return false;
	}

	decl String:sPluginName[64];
	decl String:BuffName[16];

	GetArrayString(g_hItemPluginName, ItemIndex, sPluginName, sizeof(sPluginName));
	GetArrayString(g_hItemBuffName, ItemIndex, BuffName, sizeof(BuffName));

	new any:BuffValue=GetArrayCell(g_hItemBuffValue, ItemIndex);

	new Action:returnVal=Plugin_Continue;
	Call_StartForward(g_hOnCanPurchaseItem);
	Call_PushCell(ItemIndex);
	Call_PushString(sPluginName);
	Call_PushCell(client);
	Call_PushString(BuffName);
	Call_PushCell(BuffValue);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return false;
	}

	new any:ItemCost=GetArrayCell(g_hItemCost, ItemIndex);

	new credits=GetPlayerProp(client,iMoney);

	decl String:itemname[32];
	GetArrayString(g_hItemLongName, ItemIndex, itemname, sizeof(itemname));

	if(ItemCost>credits)
	{
		RPG_ChatMessage(client,"%T","You cannot afford {itemname}", client, itemname);
		return false;
	}
	else
	{
		credits-=ItemCost;
		SetPlayerProp(client,iMoney,credits);
	}

	returnVal=Plugin_Continue;
	Call_StartForward(g_hOnItemPurchase);
	Call_PushCell(ItemIndex);
	Call_PushString(sPluginName);
	Call_PushCell(client);
	Call_PushString(BuffName);
	Call_PushCell(BuffValue);
	Call_Finish(Action:returnVal);
	if(returnVal == Plugin_Handled)
	{
		xRPG_SetOwnsItem(client,ItemIndex,true);
		RPG_ChatMessage(client,"%T","You have successfully purchased {itemname}", client, itemname);
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// SHOPMENU ITEMS INFO
///////////////////////////////////////////////////////////////////////////////////////////////////

ShowMenuItemsinfo(client)
{
	new Handle:itemsinfoMenu=CreateMenu(ShowMenuItemsinfoSelected);
	SetMenuExitButton(itemsinfoMenu,true);

	decl String:title[64];

	Format(title,sizeof(title), "%T\n", "[TF2RPG] Shopmenu items", client);
	SetMenuTitle(itemsinfoMenu,title);

	decl String:linestr[64];
	decl String:itembuf[4];
	decl String:itemname[64];

	for(new i = 1; i <= ItemsLoaded; i++)
	{
		// add item
		xRPG_GetItemName(i,itemname,sizeof(itemname),client);

		if(xRPG_GetOwnsItem(client,i))
		{
			Format(linestr,sizeof(linestr), ">%s", itemname);
		}
		else
		{
			Format(linestr,sizeof(linestr), "%s", itemname);
		}

		Format(itembuf,sizeof(itembuf),"%d",i);

		AddMenuItem(itemsinfoMenu,itembuf,linestr,ITEMDRAW_DEFAULT);
	}

	DisplayMenu(itemsinfoMenu,client,MENU_TIME_FOREVER);
}

public ShowMenuItemsinfoSelected(Handle:menu,MenuAction:action,client,selection)
{
	if(action==MenuAction_Select)
	{
		decl String:SelectionInfo[4];
		decl String:SelectionDispText[256];
		new SelectionStyle;
		GetMenuItem(menu,selection,SelectionInfo,sizeof(SelectionInfo),SelectionStyle, SelectionDispText,sizeof(SelectionDispText));
		new itemnum=StringToInt(SelectionInfo);
		if(itemnum>0&&itemnum<=ItemsLoaded)
			ShowMenuItemsinfo2(client,itemnum);
	}
	if(action==MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public ShowMenuItemsinfo2(client,itemnum)
{
	new Handle:itemsinfoMenu=CreateMenu(ShowMenuItemsinfo2Selected);
	SetMenuExitButton(itemsinfoMenu,true);

	decl String:linestr[300];
	decl String:itemname[64];
	decl String:buyname[16];
	decl String:itemDescription[192];
	decl String:itemTeamname[16];

	xRPG_GetItemName(itemnum,itemname,sizeof(itemname),client);
	xRPG_GetItemBuyname(itemnum,buyname,sizeof(buyname));
	xRPG_GetItemDescription(itemnum,itemDescription,sizeof(itemDescription),client);

	//Format(str,sizeof(str),"%T\n%s","[War3Evo] Item: {item} (identifier: {id})",client,str,shortname,str2);
	Format(linestr,sizeof(linestr),"%T","[TF2RPG] Item: {item} (Buy Name: {buyname})",client,itemname,buyname);

	xRPG_GetTeamName(xRPG_GetItemTeam(itemnum), itemTeamname, sizeof(itemTeamname));

	Format(linestr,sizeof(linestr),"%s\nTeam: %s",linestr,itemTeamname);

	new _:ClassName = _:xRPG_GetItemClass(itemnum);

	Format(linestr,sizeof(linestr),"%s\nClass: %s",linestr,TFClassTypeString[ClassName]);

	Format(linestr,sizeof(linestr),"%s\n%s",linestr,itemDescription);

	SetMenuTitle(itemsinfoMenu,linestr);

	Format(linestr,sizeof(linestr),"Back");
	AddMenuItem(itemsinfoMenu,"-1",linestr);

	DisplayMenu(itemsinfoMenu,client,120); //was MENU_TIME_FOREVER, but felt some people may not have 0 binded?
}
public ShowMenuItemsinfo2Selected(Handle:menu,MenuAction:action,client,selection)
{
	if(action==MenuAction_Select)
	{
		ShowMenuItemsinfo(client);
	}
	if(action==MenuAction_End)
	{
		CloseHandle(menu);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// NATIVES && xSTOCKS (internal stocks)
///////////////////////////////////////////////////////////////////////////////////////////////////

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

// RPG_GetItemIdByBuyname(String:itemBuyname[]);											RPG_GetItemIdByBuyname
stock xRPG_GetItemIdByBuyname(String:itemBuyname[])
{
	decl String:TmpBuffer[16];
	new i;
	for(i = 0; i <= ItemsLoaded; i++)
	{
		if(i==0) continue;
		GetArrayString(g_hItemBuyName, i, TmpBuffer, sizeof(TmpBuffer));
		if(StrEqual(itemBuyname,TmpBuffer))
		{
			break;
		}
	}
	return i;
}

public Native_RPG_GetItemIdByBuyname(Handle:plugin,numParams)
{
	if(numParams<1) return 0;
	decl String:TMPbuffer[16];
	GetNativeString(1, TMPbuffer, sizeof(TMPbuffer));
	return xRPG_GetItemIdByBuyname(TMPbuffer);
}

// RPG_GetItemName(itemid,String:ret[],maxlen,translatedfor=0);								RPG_GetItemName
stock xRPG_GetItemName(itemid,String:ret[],maxlen,translatedfor=0)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	decl String:TmpBuffer[32],String:ReturnBuffer[32];
	GetArrayString(g_hItemLongName, itemid, TmpBuffer, sizeof(TmpBuffer));
	Format(ReturnBuffer,sizeof(ReturnBuffer), "%T", TmpBuffer, translatedfor);
	strcopy(ret, maxlen, ReturnBuffer);
}

public Native_RPG_GetItemName(Handle:plugin,numParams)
{
	if(numParams<4) return;
	decl String:TMPbuffer[32];
	xRPG_GetItemName(GetNativeCell(1),TMPbuffer,sizeof(TMPbuffer),GetNativeCell(4));
	SetNativeString(2, TMPbuffer, GetNativeCell(3));
}

// RPG_GetItemBuyname(itemid,String:ret[],maxlen);											RPG_GetItemBuyname
stock xRPG_GetItemBuyname(itemid,String:ret[],maxlen)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	decl String:ReturnBuffer[16];
	GetArrayString(g_hItemBuyName, itemid, ReturnBuffer, sizeof(ReturnBuffer));
	strcopy(ret, maxlen, ReturnBuffer);
}

public Native_RPG_GetItemBuyname(Handle:plugin,numParams)
{
	if(numParams<3) return;
	decl String:TMPbuffer[16];
	xRPG_GetItemBuyname(GetNativeCell(1),TMPbuffer,sizeof(TMPbuffer));
	SetNativeString(2, TMPbuffer, GetNativeCell(3));
}

// RPG_GetItemShortDesc(itemid,String:ret[],maxlen,translatedfor=0);						RPG_GetItemShortDesc
stock xRPG_GetItemShortDesc(itemid,String:ret[],maxlen,translatedfor=0)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	decl String:TmpBuffer[32],String:ReturnBuffer[32];
	GetArrayString(g_hItemShortDesc, itemid, TmpBuffer, sizeof(TmpBuffer));
	Format(ReturnBuffer,sizeof(ReturnBuffer), "%T", TmpBuffer, translatedfor);
	strcopy(ret, maxlen, ReturnBuffer);
}

public Native_RPG_GetItemShortDesc(Handle:plugin,numParams)
{
	if(numParams<4) return;
	decl String:TMPbuffer[32];
	xRPG_GetItemShortDesc(GetNativeCell(1),TMPbuffer,sizeof(TMPbuffer),GetNativeCell(4));
	SetNativeString(2, TMPbuffer, GetNativeCell(3));
}

// RPG_GetItemDescription(itemid,String:ret[],maxlen,translatedfor=0);						RPG_GetItemDescription
stock xRPG_GetItemDescription(itemid,String:ret[],maxlen,translatedfor=0)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	decl String:TmpBuffer[192],String:ReturnBuffer[192];
	GetArrayString(g_hItemLongDesc, itemid, TmpBuffer, sizeof(TmpBuffer));
	Format(ReturnBuffer,sizeof(ReturnBuffer), "%T", TmpBuffer, translatedfor);
	strcopy(ret, maxlen, ReturnBuffer);
}

public Native_RPG_GetItemDescription(Handle:plugin,numParams)
{
	if(numParams<4) return;
	decl String:TMPbuffer[192];
	xRPG_GetItemDescription(GetNativeCell(1),TMPbuffer,sizeof(TMPbuffer),GetNativeCell(4));
	SetNativeString(2, TMPbuffer, GetNativeCell(3));
}

// RPG_GetItemCost(itemid);																	RPG_GetItemCost
stock xRPG_GetItemCost(itemid)
{
	if(itemid<=0 || itemid>ItemsLoaded) return 0;
	return GetArrayCell(g_hItemCost, itemid);
}

public Native_RPG_GetItemCost(Handle:plugin,numParams)
{
	if(numParams<1) return 0;
	return xRPG_GetItemCost(GetNativeCell(1));
}

// RPG_GetItemTeam(itemid);																	RPG_GetItemTeam
stock xRPG_GetItemTeam(itemid)
{
	if(itemid<=0 || itemid>ItemsLoaded) return 0;
	return GetArrayCell(g_hItemTeam, itemid);
}

stock xRPG_GetTeamName(itemid, String:sTeamName[], MaxLength)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	new teamnum = GetArrayCell(g_hItemTeam, itemid);
	if(teamnum==2)
	{
		strcopy(sTeamName, MaxLength, "red");
	}
	else if(teamnum==3)
	{
		strcopy(sTeamName, MaxLength, "blue");
	}
	else
	{
		strcopy(sTeamName, MaxLength, "any");
	}
}

public Native_RPG_GetItemTeam(Handle:plugin,numParams)
{
	if(numParams<1) return 0;
	return xRPG_GetItemTeam(GetNativeCell(1));
}

// RPG_GetItemCategory(itemid,String:ret[],maxlen);											RPG_GetItemCategory
stock xRPG_GetItemCategory(itemid,String:ret[],maxlen,translatedfor=0)
{
	if(itemid<=0 || itemid>ItemsLoaded) return;
	decl String:TmpBuffer[64],String:ReturnBuffer[64];
	GetArrayString(g_h_ItemCategorys, itemid, TmpBuffer, sizeof(TmpBuffer));
	Format(ReturnBuffer,sizeof(ReturnBuffer), "%T", TmpBuffer, translatedfor);
	strcopy(ret, maxlen, ReturnBuffer);
}

public Native_RPG_GetItemCategory(Handle:plugin,numParams)
{
	if(numParams<4) return;
	decl String:TMPbuffer[64];
	xRPG_GetItemCategory(GetNativeCell(1),TMPbuffer,sizeof(TMPbuffer),GetNativeCell(4));
	SetNativeString(2, TMPbuffer, GetNativeCell(3));
}

// RPG_GetItemClass(itemid);																	RPG_GetItemClass
stock TFClassType:xRPG_GetItemClass(itemid)
{
	if(itemid<=0 || itemid>ItemsLoaded) return TFClass_Unknown;
	new iClassID=GetArrayCell(g_hItemClass, itemid);
	if(iClassID<0 || iClassID>9) return TFClass_Unknown;
	return TFClassType:iClassID;
}

public Native_RPG_GetItemClass(Handle:plugin,numParams)
{
	if(numParams<1) return 0;
	return _:xRPG_GetItemClass(GetNativeCell(1));
}

// Native_GetItemsLoaded();																		Native_GetItemsLoaded
public Native_GetItemsLoaded(Handle:plugin,numParams)
{
	return ItemsLoaded;
}

