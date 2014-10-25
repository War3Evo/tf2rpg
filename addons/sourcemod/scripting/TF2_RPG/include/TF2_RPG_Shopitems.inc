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
forward Action:OnCanPurchaseItem(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value)

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
forward Action:OnItemPurchase(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value)

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
forward OnItemLost(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value)


////////////////////////////////////////////////////////////////////////////////
// NATIVES
////////////////////////////////////////////////////////////////////////////////

/**
 * Gets item index by item's shortname
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return					item index
 */
native RPG_GetItemIdByBuyname(String:ret[],maxlen,translatedfor=0);

/**
 * Gets item name by item index
 * @param itemid			Item Index
 * @param ret[]				returns Item Name
 * @param maxlen			maxlength of ret[]
 * @param translatedfor		client or 0 for server engine default translation
 * @return
 */
native RPG_GetItemName(itemid,String:ret[],maxlen,translatedfor=0);

