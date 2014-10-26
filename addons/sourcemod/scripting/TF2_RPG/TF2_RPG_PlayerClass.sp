// TF2_RPG_PlayerClass.sp

public Plugin:myinfo=
{
	name="TF2 RPG PlayerClass",
	author="TF2 RPG Team",
	description="TF2 RPG Core Plugins",
	version=VERSION_NUM,
};

new p_xp[MAXPLAYERSCUSTOM][MAXCLASSES];
new p_level[MAXPLAYERSCUSTOM][MAXCLASSES];

new playerOwnsItem[MAXPLAYERSCUSTOM][MAXITEMS];


public TF2_RPG_PlayerClass_InitNatives()
{
	CreateNative("RPG_SetLevel",Native_RPG_SetLevel);
	CreateNative("RPG_GetLevel",Native_RPG_GetLevel);

	CreateNative("RPG_SetXP",Native_RPG_SetXP);
	CreateNative("RPG_GetXP",Native_RPG_GetXP);

	//CreateNative("RPGGetTotalLevels",Native_RPGGetTotalLevels);

	CreateNative("RPGSetPlayerProp",Native_RPGSetPlayerProp);
	CreateNative("RPGGetPlayerProp",Native_RPGGetPlayerProp);

	CreateNative("RPG_GetOwnsItem",Native_RPG_GetOwnsItem);
}

public TF2_RPG_PlayerClass_Forwards()
{
	g_hOnItemGain			= CreateGlobalForward("OnItemGain", ET_Ignore, Param_Cell, Param_Cell);
	g_hOnItemLost			= CreateGlobalForward("OnItemLost", ET_Ignore, Param_Cell, Param_Cell);
}

stock SetLevel(client,class,level)
{
	if (client > 0 && client <= MaxClients && class > 0 && class < MAXCLASSES)
	{
		p_level[client][class]=level;
		return 1;
	}
	return 0;
}

public Native_RPG_SetLevel(Handle:plugin,numParams){
	new client = GetNativeCell(1);
	new class = GetNativeCell(2);
	new level = GetNativeCell(3);
	return SetLevel(client,class,level);
}

public Native_RPG_GetLevel(Handle:plugin,numParams){
	new client = GetNativeCell(1);
	new class = GetNativeCell(2);
	if (client > 0 && client <= MaxClients && class > 0 && class < MAXCLASSES)
	{
		new level=p_level[client][class];
		//if(level>GetClassMaxLevel(class))
			//level=GetClassMaxLevel(class);
		return level;
	}
	//else
	return 0;
}

stock SetXP(client,class,xp)
{
	if (client > 0 && client <= MaxClients && class > 0 && class < MAXCLASSES)
	{
		p_xp[client][class]=xp;
		return 1;
	}
	return 0;
}

public Native_RPG_SetXP(Handle:plugin,numParams){
	return SetXP(GetNativeCell(1),GetNativeCell(2),GetNativeCell(3));
}

stock GetXP(client,class)
{
	if (client > 0 && client <= MaxClients && class > 0 && class < MAXCLASSES)
		return p_xp[client][class];
	else
		return 0;
}
public Native_RPG_GetXP(Handle:plugin,numParams){
	new client = GetNativeCell(1);
	new class = GetNativeCell(2);
	return GetXP(client,class);
}

stock GetPlayerProp(client,RPGPlayerProp:property)
{
	if (client > 0 && client <= MaxClients)
	{
		return p_properties[client][property];
	}
	else
		return 0;
}

public Native_RPGGetPlayerProp(Handle:plugin,numParams)
{
	return GetPlayerProp(GetNativeCell(1),RPGPlayerProp:GetNativeCell(2));
}

stock SetPlayerProp(client,RPGPlayerProp:property,any:value)
{
	if (client > 0 && client <= MaxClients)
	{
		p_properties[client][property]=value;
	}
}

public Native_RPGSetPlayerProp(Handle:plugin,numParams){
	SetPlayerProp(GetNativeCell(1),RPGPlayerProp:GetNativeCell(2),any:GetNativeCell(3));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// NATIVES && FORWARD
///////////////////////////////////////////////////////////////////////////////////////////////////
stock xRPG_ClearAllOwnsItem(client)
{
	if(client<0 || client>MaxClients) return;
	for(new i=0; i<=MaxAllowedItems; i++)
	{
		playerOwnsItem[client][i]=0;
	}
}

stock bool:xRPG_GetOwnsItem(client, itemid)
{
	if(client<0 || client>MaxClients) return false;
	if(itemid<=0 || itemid>ItemsLoaded) return false;
	for(new i=0; i<=MaxAllowedItems; i++)
	{
		if(playerOwnsItem[client][i]==itemid) return true;
	}
	return false;
}

public Native_RPG_GetOwnsItem(Handle:plugin,numParams)
{
	if(numParams<2) return false;
	return xRPG_GetOwnsItem(GetNativeCell(1), GetNativeCell(2));
}

stock xRPG_SetOwnsItem(client, itemid, bool:SetOwnsItem)
{
	if(client<0 || client>MaxClients) return 0;
	if(itemid<=0 || itemid>ItemsLoaded) return 0;
	if(SetOwnsItem==true && xRPG_GetOwnsItem(client, itemid)==false)
	{
		for(new i=0; i<=MaxAllowedItems; i++)
		{
			if(playerOwnsItem[client][i]==0)
			{
				playerOwnsItem[client][i]=itemid;

				Call_StartForward(g_hOnItemGain);
				Call_PushCell(client);
				Call_PushCell(itemid);
				Call_Finish(dummy);
				break;
			}
		}
	}
	else if(SetOwnsItem==false)
	{
		for(new i=0; i<=MaxAllowedItems; i++)
		{
			if(playerOwnsItem[client][i]==itemid)
			{
				Call_StartForward(g_hOnItemLost);
				Call_PushCell(client);
				Call_PushCell(itemid);
				Call_Finish(dummy);

				playerOwnsItem[client][i]=0;
			}
		}
	}
	return 1;
}

public Native_RPG_SetOwnsItem(Handle:plugin,numParams)
{
	if(numParams<3) return;
	xRPG_SetOwnsItem(GetNativeCell(1), GetNativeCell(2), bool:GetNativeCell(3));
}
