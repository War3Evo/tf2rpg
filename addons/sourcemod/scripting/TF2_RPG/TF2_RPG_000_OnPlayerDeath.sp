// TF2_RPG_000_OnPlayerDeath.sp

public TF2_RPG_000_OnPlayerDeath_OnPluginStart()
{
	if(!HookEventEx("player_death",RPG_PlayerDeathEvent,EventHookMode_Pre))
	{
		//PrintToServer("[TF2 RPG] Could not hook the player_death event.");
		SetFailState("[TF2 RPG] Could not hook the player_death event.");
		//return false;
	}
}

public Action:RPG_PlayerDeathEvent(Handle:event,const String:name[],bool:dontBroadcast)
{
	new uid_victim = GetEventInt(event, "userid");
	new uid_attacker = GetEventInt(event, "attacker");
	//new uid_entity = GetEventInt(event, "entityid");

	new victimIndex = 0;
	new attackerIndex = 0;

	new victim = GetClientOfUserId(uid_victim);
	new attacker = GetClientOfUserId(uid_attacker);

	new distance=0;
	new attacker_hpleft=0;

	//new String:weapon[32];
	//GetEventString(event, "weapon", weapon, 32);
	//ReplaceString(weapon, 32, "WEAPON_", "");

	if(victim>0&&attacker>0)
	{
		//Get the distance
		new Float:victimLoc[3];
		new Float:attackerLoc[3];
		GetClientAbsOrigin(victim,victimLoc);
		GetClientAbsOrigin(attacker,attackerLoc);
		distance = RoundToNearest(FloatDiv(calcDistance(victimLoc[0],attackerLoc[0], victimLoc[1],attackerLoc[1], victimLoc[2],attackerLoc[2]),12.0));

		attacker_hpleft = GetClientHealth(attacker);

	}


	if(uid_attacker>0){
		attackerIndex=GetClientOfUserId(uid_attacker);
	}

	if(uid_victim>0){
		victimIndex=GetClientOfUserId(uid_victim);
	}

	new bool:deadringereath=false;
	if(uid_victim>0)
	{
		new deathFlags = GetEventInt(event, "death_flags");
		if (deathFlags & 32) //TF_DEATHFLAG_DEADRINGER
		{
			deadringereath=true;
			//DP("dead ringer kill");

			new assister=GetClientOfUserId(GetEventInt(event,"assister"));

			if(victimIndex!=attackerIndex&&IsValidPlayer(attackerIndex))
			{
				if(GetClientTeam(attackerIndex)!=GetClientTeam(victimIndex))
				{
					decl String:weapon[64];
					GetEventString(event,"weapon",weapon,sizeof(weapon));
					//new bool:is_hs,bool:is_melee;
					//is_hs=(GetEventInt(event,"customkill")==1);
					//DP("wep %s",weapon);
					//is_melee=RPGIsDamageFromMelee(weapon);
					if(assister>=0)
					{
						// give fake points and stuff to assister
					}
					// give fake points and stuff
				}
			}
		}
		else
		{
			RPGDoLevelCheck(victimIndex);
		}
	}

	if(bHasDiedThisFrame[victimIndex]>0){
		return Plugin_Handled;
	}
	bHasDiedThisFrame[victimIndex]++;
	//lastly
	//DP("died? %d",bHasDiedThisFrame[victimIndex]);
	if(victimIndex&&!deadringereath) //forward to all other plugins last
	{
		//pre death event, internal event

		OnRPGEventDeath(victimIndex,attackerIndex,distance,attacker_hpleft);

		SetPlayerProp(victimIndex,bStatefulSpawn,true);//next spawn shall be stateful

	}
	return Plugin_Continue;
}

// filtered for dead ringer:
public OnRPGEventDeath(victimIndex,attackerIndex,distance,attacker_hpleft)
{
	// Handle Death Events
}
