// TF2_RPG_Addon_ShopItems.sp

/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * TF2_RPG written by The TF2_RPG Team
 * All rights reserved.
*/

#pragma semicolon 1

// Always inlude this file for your addon plugins:
#include <TF2_RPG>

// Must always put this in your addons for shopitems:
new String:ThisPluginName[80];

public Plugin:myinfo =
{
	name = "RPG - Default Shopitems Engine Addon",
	author = "TF2 RPG Team",
	description = "Bring a shopitems to tf2 rpg.",
	version = "0.2.1",
};

public OnPluginStart()
{
	// Must always put this in your addons for shopitems:
	GetPluginName(ThisPluginName,sizeof(ThisPluginName));
}

// will add later
//public OnAddSound(sound_priority)
//{
	//if(sound_priority==PRIORITY_TOP)
	//{
		//RPG_AddSound(Ring_Purchase_Sound);
	//}
//}
public Action:OnCanPurchaseItem(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value)
{
	if(StrEqual(ThisPluginName,plugin_name))
	{
		// debug message
		RPG_ChatMessage(client, "OnCanPurchaseItem %s", buff_name);
	}
	return Plugin_Continue;
}

public Action:OnItemPurchase(ItemIndex, const String:plugin_name[], client, const String:buff_name[], any:value)
{
	if(StrEqual(ThisPluginName,plugin_name))
	{
		// apply buff to player and keep up with it
		RPG_ChatMessage(client, "OnItemPurchase %s", buff_name);

		return Plugin_Handled;
	}
	return Plugin_Continue;
}

//deactivate passives , client may have disconnected
public OnItemLost(client, ItemIndex)
{
	DP("OnItemLost client %d item %d",client, ItemIndex);
}

public OnItemGain(client, ItemIndex)
{
	DP("OnItemGain client %d item %d",client, ItemIndex);
}
