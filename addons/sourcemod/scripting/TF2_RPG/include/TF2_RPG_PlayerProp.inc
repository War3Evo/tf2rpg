// TF2_RPG_PlayerProp.inc

//Basically Instance variables for the Player Class
enum RPGPlayerProp
{
	bool:bPutInServer,

	iMoney,

	iMaxHP,

	bIsDucking,

	bool:bXPLoaded,
	bool:bSpawnedOnce, //if player has spawned once
	Float:fsqlStartLoadXPTime,

	Float:fLastChangeTeamTime,
	bool:bStatefulSpawn, //set true if spawn is a non repeated spawn. set to true on join and death, set false after spawn forward is finished.
}

native RPGSetPlayerProp(client,RPGPlayerProp:property,any:value);
native any:RPGGetPlayerProp(client,RPGPlayerProp:property);

stock bool:IsValidPlayer(client,bool:check_alive=false,bool:alivecheckbyhealth=false) {
	if(client>0 && client<=MaxClients && IsClientConnected(client) && IsClientInGame(client))
	{
		if(check_alive && !IsPlayerAlive(client))
		{
			return false;
		}
		if(alivecheckbyhealth&&GetClientHealth(client)<1) {
			return false;
		}
		return true;
	}
	return false;
}
