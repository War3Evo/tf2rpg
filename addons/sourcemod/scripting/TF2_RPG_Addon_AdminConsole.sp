// TF2_RPG_Addon_AdminConsole.sp

#include <TF2_RPG>

public Plugin:myinfo=
{
	name="TF2 RPG Admin Console",
	author="TF2 RPG TEAM",
	description="TF2 RPG Addon Plugins",
	version="1.0",
};

public OnPluginStart()
{
	RegConsoleCmd("rpg_setmoney",TF2_RPG_COMMAND_SetMoney,"Set a player's money count");

	LoadTranslations("tf2_rpg.phrases.txt");
}

public Action:TF2_RPG_COMMAND_SetMoney(client,args)
{
	if(client!=0&&CheckCommandAccess(client,"rpg_set_money",ADMFLAG_ROOT,false))
	{
		ReplyToCommand(client,"No Access");
	}
	else if(args!=2)
		PrintToConsole(client,"%T","[TF2RPG] The syntax of the command is: rpg_setmoney <player> <money>",client);
	else
	{
		decl String:match[64];
		GetCmdArg(1,match,sizeof(match));
		decl String:buf[32];
		GetCmdArg(2,buf,sizeof(buf));

		new String:adminname[64];
		if(client!=0)
			GetClientName(client,adminname,sizeof(adminname));
		else
			adminname="Console";
		new money=StringToInt(buf);

		new String:target_name[MAX_TARGET_LENGTH];
		new target_list[MAXPLAYERSCUSTOM], target_count;
		new bool:tn_is_ml;

		if ((target_count = ProcessTargetString(match, client, target_list, MAXPLAYERSCUSTOM, COMMAND_FILTER_CONNECTED, target_name, sizeof(target_name), tn_is_ml)) <= 0)
		{
			ReplyToTargetError(client, target_count);
			return Plugin_Handled;
		}

		for(new x=0;x<target_count;x++)
		{
			decl String:name[64];
			GetClientName(target_list[x],name,sizeof(name));

			RPGSetPlayerProp(target_list[x],iMoney,money);

			PrintToConsole(client,"%T","[TF2RPG] You just set player {player} money to {amount}",client,name,money);
			RPG_ChatMessage(target_list[x],"%T","Admin {player} set your money to {amount}",target_list[x],adminname,money);
		}
	}
	return Plugin_Handled;
}
