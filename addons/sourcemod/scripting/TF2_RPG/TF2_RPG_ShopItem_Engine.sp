// TF2_RPG_ShopItem_Engine.sp

// ShopItem Engine will store all shopitem information for retrieval later

new Handle:g_hShopItemNumber;

public TF2_RPG_ShopItem_Engine_OnPluginStart()
{
	g_hItemNumber = CreateArray(1);
	g_h_ItemCategorys = CreateArray(ByteCountToCells(64)); //string
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

public TF2_RPG_Item_InitNatives()
{
	//
}

ShowMenuShopCategory(client)
{
	//SetTrans(client);
	new Handle:shopMenu = CreateMenu(RPG_ShopMenuCategory_Sel);
	SetMenuExitButton(shopMenu, true);
	new currency = RPG_GetCurrency(client);

	new String:title[300];
	Format(title,sizeof(title), "%T\n", "[TF2 RPG] Browse the itemshop. You have {amount}/{amount} items", GetTrans(), GetClientItemsOwned(client),iGetMaxShopitemsPerPlayer(client));
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", GetTrans(), title, currency, GetMaxCurrency(client));
	Format(title, sizeof(title), "%s%s", title, currencyName);

	SetMenuTitle(shopMenu,title);

	new TFClassType:SearchClass=TFClass_Unknown;

	new CurrentClass=TF2_GetPlayerClass(client);

	decl String:category[64];
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

		AddMenuItem(shopMenu, category, category, ITEMDRAW_DEFAULT);
		RemoveFromArray(h_ItemCategorys, 0);
	}

	CloseHandle(h_ItemCategorys);

	DisplayMenu(shopMenu,client,20);
}

ShowMenuShop(client, const String:category[]="")
{
	SetTrans(client);
	new Handle:shopMenu=CreateMenu(RPG_ShopMenu_Selected);
	SetMenuExitButton(shopMenu,true);

	new currency=RPG_GetCurrency(client);

	new String:title[300];
	decl String:currencyName[MAX_CURRENCY_NAME];
	RPG_GetCurrencyName(currency, currencyName, sizeof(currencyName));

	Format(title,sizeof(title), "%T\n", "[TF2 RPG] Browse the itemshop. You have {amount}/{amount} items", GetTrans(), GetClientItemsOwned(client),iGetMaxShopitemsPerPlayer(client));
	Format(title,sizeof(title), "%s%T", title, "Your current balance: {amount}/{maxamount}", GetTrans(), title, currency, GetMaxCurrency(client));
	Format(title, sizeof(title), "%s%s", title, currencyName);

	SetMenuTitle(shopMenu,title);

	new String:itemname[64];
	new String:itembuf[4];
	new String:linestr[96];
	new String:itemcategory[64];
	new String:itemshortdesc[256];
	new cost;
	new bool:useCategory = GetConVarBool(hUseCategorysCvar);
	//new BackButton=0;
	if (useCategory)
	{
		AddMenuItem(shopMenu,"-1","[Return to Categories]");
	}

	for(new i = 0; i < GetArraySize(g_hItemNumber); i++)
	{
		SearchClass = TFClassType:GetArrayCell(g_hItemClass, i);
		if(SearchClass==TFClass_Unknown || SearchClass==CurrentClass)
		{
			GetArrayString(g_h_ItemCategorys, i, itemcategory, sizeof(itemcategory));

			if (StrEqual(category, itemcategory))
			{
				// add item


				AddMenuItem(shopMenu,itembuf,linestr,ITEMDRAW_DEFAULT);
			}
		}
	}

	DisplayMenu(shopMenu,client,20);
}
