// TF2_RPG_CommandHook.sp

public Plugin:myinfo=
{
	name="TF2 RPG Command Hooks",
	author="TF2 RPG TEAM",
	description="RPG Core Plugins",
	version="1.0",
};

new Handle:g_hOnRPGSayChatPre;
new Handle:g_hOnRPGSayTeamChatPre;
new Handle:g_hOnRPGSayAllChatPre;

public TF2_RPG_CommandHook_Forwards()
{
	g_hOnRPGSayChatPre       = CreateGlobalForward("OnRPGSayChatPre", ET_Hook, Param_Cell, Param_String);
	g_hOnRPGSayTeamChatPre       = CreateGlobalForward("OnRPGSayTeamChatPre", ET_Hook, Param_Cell, Param_String);
	g_hOnRPGSayAllChatPre       = CreateGlobalForward("OnRPGSayAllChatPre", ET_Hook, Param_Cell, Param_String);
}

public TF2_RPG_CommandHook_OnPluginStart()
{
	RegConsoleCmd("say",RPG_SayCommand);
	RegConsoleCmd("say_team",RPG_TeamSayCommand);
}

public Action:RPG_SayCommand(client,args)
{
	decl String:arg1[192]; //was 70
	//decl String:msg[256]; //was 70
	GetCmdArg(1,arg1,sizeof(arg1));
	//GetCmdArgString(msg, sizeof(msg));
	//StripQuotes(msg);
	//DP("GetCmdArg %s",arg1);
	//DP("GetCmdArgString %s",msg);

	new Action:returnblocking=Plugin_Continue;

	// pre-hook forward here
	new Action:returnVal=Plugin_Continue;
	Call_StartForward(g_hOnRPGSayChatPre);
	Call_PushCell(client);
	Call_PushStringEx(arg1,sizeof(arg1),SM_PARAM_STRING_COPY,SM_PARAM_COPYBACK);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return Plugin_Handled;
	}

	returnVal=Plugin_Continue;
	Call_StartForward(g_hOnRPGSayAllChatPre);
	Call_PushCell(client);
	Call_PushStringEx(arg1,sizeof(arg1),SM_PARAM_STRING_COPY,SM_PARAM_COPYBACK);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return Plugin_Handled;
	}

	if(xRPG_SayCommand(client,arg1))
	{
		returnblocking=Plugin_Handled;
	}
	return returnblocking;
}

public Action:RPG_TeamSayCommand(client,args)
{
	decl String:arg1[192]; //was 70
	//decl String:msg[256]; // was 70

	GetCmdArg(1,arg1,sizeof(arg1));
	//GetCmdArgString(msg, sizeof(msg));
	//StripQuotes(msg);

	new Action:returnblocking=Plugin_Continue;

	// pre-hook forward here
	new Action:returnVal=Plugin_Continue;
	Call_StartForward(g_hOnRPGSayTeamChatPre);
	Call_PushCell(client);
	Call_PushStringEx(arg1,sizeof(arg1),SM_PARAM_STRING_COPY,SM_PARAM_COPYBACK);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return Plugin_Handled;
	}

	returnVal=Plugin_Continue;
	Call_StartForward(g_hOnRPGSayAllChatPre);
	Call_PushCell(client);
	Call_PushStringEx(arg1,sizeof(arg1),SM_PARAM_STRING_COPY,SM_PARAM_COPYBACK);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return Plugin_Handled;
	}

	if(xRPG_SayCommand(client,arg1))
	{
		returnblocking = Plugin_Handled;
	}

	return returnblocking;
}


bool:xRPG_SayCommand(client,String:ChatString[192])
{
	//new top_num;

	//new bool:returnblocking = (GetConVarInt(Cvar_ChatBlocking)>0)?true:false;

	new RPGChatBlock:eCommandCheck;
	new RPGChatBlock:eCommandCheck2;

	eCommandCheck=CommandCheck(ChatString,"showxp");
	eCommandCheck2=CommandCheck(ChatString,"xp");
	if(eCommandCheck==RPGTrue || eCommandCheck2==RPGTrue)
	{
		//RPG_ShowXP(client);
		return false;
	}
	else if(eCommandCheck==RPGBlock || eCommandCheck2==RPGBlock)
	{
		//RPG_ShowXP(client);
		return true;
	}

	eCommandCheck=CommandCheck(ChatString,"shopmenu");
	eCommandCheck2=CommandCheck(ChatString,"sh1");
	if(eCommandCheck==RPGTrue || eCommandCheck2==RPGTrue)
	{
		ShowMenuShopCategory(client);
		return false;
	}
	else if(eCommandCheck==RPGBlock || eCommandCheck2==RPGBlock)
	{
		ShowMenuShopCategory(client);
		return true;
	}

	return false;
}

