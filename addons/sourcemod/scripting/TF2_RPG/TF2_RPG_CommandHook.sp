// TF2_RPG_CommandHook.sp

public Plugin:myinfo=
{
	name="TF2 RPG Command Hooks",
	author=AUTHORS,
	description="RPG Core Plugins",
	version=VERSION,
};

new Handle:g_hOnRPGSayChatPre;
new Handle:g_hOnOnRPGSayTeamChatPre;

public TF2_RPG_CommandHook_Forwards()
{
	g_hOnOnRPGSayChatPre       = CreateGlobalForward("OnRPGSayChatPre", ET_Hook, Param_Cell, Param_String);
	g_hOnOnRPGSayTeamChatPre       = CreateGlobalForward("OnRPGSayTeamChatPre", ET_Hook, Param_Cell, Param_String);
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
	Call_StartForward(g_hOnOnRPGSayChatPre);
	Call_PushCell(client);
	Call_PushStringEx(arg1,sizeof(arg1),SM_PARAM_STRING_COPY,SM_PARAM_COPYBACK);
	Call_Finish(Action:returnVal);
	if(returnVal != Plugin_Continue)
	{
		return Plugin_Handled;
	}

	if(Internal_RPG_SayCommand(client,arg1))
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

	if(Internal_RPG_SayCommand(client,arg1))
	{
		returnblocking = Plugin_Handled;
	}

	return returnblocking;
}


bool:Internal_RPG_SayCommand(client,String:arg1[256])
{
	new top_num;

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
}

