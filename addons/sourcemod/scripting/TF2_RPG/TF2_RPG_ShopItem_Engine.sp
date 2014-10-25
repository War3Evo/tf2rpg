// TF2_RPG_ShopItem_Engine.sp

// ShopItem Engine will store all shopitem information for retrieval later

new Handle:g_hShopItemNumber;

public TF2_RPG_ShopItem_Engine_OnPluginStart()
{
	LoadTranslations("tf2_rpg.shopmenu.phrases.txt");
	LoadTranslations("tf2_rpg.item_categories.phrases.txt");

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
}

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

public TF2_RPG_ShopItem_Engine_Forwards()
{
	//
	g_hOnCanPurchaseItem	= CreateGlobalForward("OnCanPurchaseItem", ET_Hook, Param_String, Param_Cell, Param_String, Param_Cell);
	g_hOnItemPurchase		= CreateGlobalForward("OnItemPurchase", ET_Hook, Param_String, Param_Cell, Param_String, Param_Cell);
	g_hOnItemLost			= CreateGlobalForward("OnItemLost", ET_Hook, Param_String, Param_Cell, Param_String, Param_Cell);
}

ShowMenuShopCategory(client)
{
	new Handle:shopMenu = CreateMenu(RPG_ShopMenuCategory_Sel);
	SetMenuExitButton(shopMenu, true);
	//new currency = RPG_GetCurrency(client);

	new String:title[300];
	Format(title,sizeof(title), "%T\n", "[TF2 RPG] Browse the itemshop. You have {amount}/{amount} items", client, 0, 3);
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", client, title, 0, 100);
	//Format(title, sizeof(title), "%s%s", title, currencyName);

	SetMenuTitle(shopMenu,title);

	new TFClassType:SearchClass=TFClass_Unknown;

	new CurrentClass=TF2_GetPlayerClass(client);

	decl String:category[64];
	decl String:linestr[96];

	new Handle:h_TempItemCategorys = CreateArray(ByteCountToCells(64));

	for(new i = 0; i < GetArraySize(g_hItemNumber); i++)
	{
		SearchClass = TFClassType:GetArrayCell(g_hItemClass, i);
		if(SearchClass==TFClass_Unknown || SearchClass==CurrentClass)
		{
			GetArrayString(g_h_ItemCategorys, i, category, sizeof(category));

			if ((FindStringInArray(h_ItemCategorys, category) >= 0) || StrEqual(category, ""))
			continue;
			else
			PushArrayString(h_ItemCategorys, category);
		}
	}

	// fill the menu with the categorys
	while(GetArraySize(h_ItemCategorys))
	{
		GetArrayString(h_ItemCategorys, 0, category, sizeof(category));

		Format(linestr,sizeof(linestr), "%T", category, client);

		AddMenuItem(shopMenu, category, linestr, ITEMDRAW_DEFAULT);
		RemoveFromArray(h_ItemCategorys, 0);
	}

	CloseHandle(h_ItemCategorys);

	DisplayMenu(shopMenu,client,20);
}

public RPG_ShopMenuCategory_Sel(Handle:menu, MenuAction:action, client, selection)
{
	if(action==MenuAction_Select)
	{
		if(ValidPlayer(client))
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

	new currency=RPG_GetCurrency(client);

	new String:title[300];
	decl String:currencyName[MAX_CURRENCY_NAME];
	RPG_GetCurrencyName(currency, currencyName, sizeof(currencyName));

	Format(title,sizeof(title), "%T\n", "[TF2 RPG] Browse the itemshop. You have {amount}/{amount} items", client, 0, 3);
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", client, title, 0, 100));
	Format(title, sizeof(title), "%s%s", title, currencyName);

	SetMenuTitle(shopMenu,title);

	new String:itemname[64];
	new String:itembuf[4];
	new String:linestr[96];
	new String:itemcategory[64];
	new String:itemshortdesc[256];
	new cost;
	//new bool:useCategory = GetConVarBool(hUseCategorysCvar);
	//new BackButton=0;
	//if (useCategory)
	//{
	AddMenuItem(shopMenu,"-1","[Return to Categories]");
	//}

	for(new i = 0; i < GetArraySize(g_hItemNumber); i++)
	{
		SearchClass = TFClassType:GetArrayCell(g_hItemClass, i);
		if(SearchClass==TFClass_Unknown || SearchClass==CurrentClass)
		{
			GetArrayString(g_h_ItemCategorys, i, itemcategory, sizeof(itemcategory));

			if (StrEqual(category, itemcategory))
			{
				// add item
				GetArrayString(g_hItemLongName, i, itemcategory, sizeof(itemcategory));

				Format(linestr,sizeof(linestr), "%T", itemcategory, client);

				Format(itembuf,sizeof(itembuf),"%d",i);

				AddMenuItem(shopMenu,itembuf,linestr,ITEMDRAW_DEFAULT);
			}
		}
	}

	DisplayMenu(shopMenu,client,20);
}

public War3Source_ShopMenu_Selected(Handle:menu,MenuAction:action,client,selection)
{
	if(action==MenuAction_Select)
	{
		if(ValidPlayer(client))
		{
			decl String:SelectionInfo[4];
			decl String:SelectionDispText[256];
			new SelectionStyle;
			GetMenuItem(menu,selection,SelectionInfo,sizeof(SelectionInfo),SelectionStyle, SelectionDispText,sizeof(SelectionDispText));
			new item=StringToInt(SelectionInfo);
			new bool:useCategory = GetConVarBool(hUseCategorysCvar);
			//if(item==-1&&useCategory)
			if(item==-1)
			{
				ShowMenuShopCategory(client);
			}
			else
			{
				RPG_TryToBuyItem(client,item,true);
			}

		}
	}
	if(action==MenuAction_End)
	{
		CloseHandle(menu);
	}
}

stock bool:RPG_TryToBuyItem(client,item,bool:reshowmenu=true)
{
	if(item>=GetArraySize(g_hItemNumber))
	{
		LogError("item>=GetArraySize(g_hItemNumber) item = %d and other = %d",item,GetArraySize(g_hItemNumber));
		return false;
	}

	decl String:sPluginName[64];
	decl String:BuffName[16];

	GetArrayString(g_hItemPluginName, item, sPluginName, sizeof(sPluginName));
	GetArrayString(g_hItemBuffName, item, BuffName, sizeof(BuffName));

	new any:BuffValue=GetArrayCell(g_hItemValue, item);

	new Action:returnblocking=Plugin_Continue;
	Call_StartForward(g_hOnCanPurchaseItem);
	Call_PushCell(item);
	Call_PushString(sPluginName);
	Call_PushCell(client);
	Call_PushString(BuffName);
	Call_PushCell(BuffValue);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return false;
	}

	new any:ItemCost=GetArrayCell(g_hItemCost, item);

	new credits=GetPlayerProp(client,iPlayerMoney);

	decl String:itemname[32];
	GetArrayString(g_hItemLongName, item, itemname, sizeof(itemname));

	if(ItemCost>credits)
	{
		RPG_ChatMessage(client,"%T","You cannot afford {itemname}", client, itemname);
		return false;
	}
	else
	{
		credits-=ItemCost;
		SetPlayerProp(client,iPlayerMoney,credits);
	}

	returnblocking=Plugin_Continue;
	Call_StartForward(g_hOnItemPurchase);
	Call_PushCell(item);
	Call_PushString(sPluginName);
	Call_PushCell(client);
	Call_PushString(BuffName);
	Call_PushCell(BuffValue);
	Call_Finish(Action:returnVal);
	if(returnVal == Plugin_Handled)
	{
		RPG_ChatMessage(client,"%T","You have successfully purchased {itemname}", client, itemname);
		return true;
	}

	return false;
}
