// TF2_RPG_Shopitems.inc

////////////////////////////////////////////////////////////////////////////////
// FOWARDS
////////////////////////////////////////////////////////////////////////////////

/**
 *
 * @param ItemIndex				This index will change when you restart server or reload shop items
 * @param plugin_name			the plugin name without path and extension
 * @param client				client index.
 * @param buff_name				the name of the buff
 * @param value					any value
 *
 * @return						return Plugin_Handled if denied purchase.
 *
 */
forward Action:OnCanPurchaseItem(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value);

/**
 *
 * @param ItemIndex				This index will change when you restart server or reload shop items
 * @param plugin_name			the plugin name without path and extension
 * @param client				client index.
 * @param buff_name				the name of the buff
 * @param value					any value
 *
 * @return						return Plugin_Handled if plugin accepted purchase.
 *
 */
forward Action:OnItemPurchase(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value);

/**
 *
 * @param ItemIndex				This index will change when you restart server or reload shop items
 * @param plugin_name			the plugin name without path and extension
 * @param client				client index.
 * @param buff_name				the name of the buff
 * @param value					any value
 *
 * @noreturn
 *
 */
forward OnItemLost(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value);


////////////////////////////////////////////////////////////////////////////////
// NATIVES
////////////////////////////////////////////////////////////////////////////////

/** (TF2_RPG_PlayerClass.sp)
 * Gets if client owns item or not
 *
 * @param client			client index
 * @param itemid			itemid index
 * @return					returns true is client owns item
 */
native bool:RPG_GetOwnsItem(client, itemid);

/** (TF2_RPG_PlayerClass.sp)
 * Sets if client owns item or not
 *
 * @param client			client index
 * @param itemid			itemid index
 * @param OwnsItem			set true if player owns itemid, otherwise set false
 * @return					returns true if item can be set, otherwise they may have too many items
 */
native bool:RPG_SetOwnsItem(client, itemid, bool:OwnsItem);

/**
 * Gets number of items loaded
 * ItemsLoaded = GetArraySize(g_hItemNumber) - 1;
 *
 * @return					Items Loaded
 */
native RPG_GetItemsLoaded();

/**
 * Gets item index by item's shortname
 * @param itemBuyname[]		the item buyname to search for
 * @return					item index
 */
native RPG_GetItemIdByBuyname(String:itemBuyname[]);

/**
 * Gets item name by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return					returns true if successful
 */
native bool:RPG_GetItemName(itemid,String:ret[],maxlen=32,translatedfor=0);

/**
 * Gets item buyname by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @return					returns true if successful
 */
native bool:RPG_GetItemBuyname(itemid,String:ret[],maxlen=16);

/**
 * Gets item short description by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return					returns true if successful
 */
native bool:RPG_GetItemShortDesc(itemid,String:ret[],maxlen=32,translatedfor=0);

/**
 * Gets item full description by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return					returns true if successful
 */
native bool:RPG_GetItemDescription(itemid,String:ret[],maxlen=192,translatedfor=0);

/**
 * Gets the item cost.
 *
 * @param itemid			The item that you want the cost of.
 * @return					the cost of the item
 */
native RPG_GetItemCost(itemid);

/**
 * Gets item category name by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return					returns true if successful
 */
native bool:RPG_GetItemCategory(itemid,String:ret[],maxlen=64,translatedfor=0);

/**
 * Gets the item class.
 *
 * @param itemid			The item that you want the class of.
 * @return					the class of the item
 */
native TFClassType:RPG_GetItemClass(itemid);
