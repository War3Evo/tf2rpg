// TF2_RPG.sp

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

#include <TF2_RPG>

#include "TF2_RPG/include/TF2_RPG_Version_Info.inc"
#include "TF2_RPG/include/TF2_RPG_Variables.inc"

#include "TF2_RPG/TF2_RPG_InitForwards.sp"
#include "TF2_RPG/TF2_RPG_InitNatives.sp"

#include "TF2_RPG/TF2_RPG_PlayerClass.sp"

public Plugin:myinfo=
{
	name="TF2 RPG",
	author=AUTHORS,
	description="A simple RPG plugin for TF2 !",
	version=VERSION_NUM,
	url = "http://www.sourcemod.net/"
};

//=============================================================================
// AskPluginLoad2
//=============================================================================
public APLRes:AskPluginLoad2(Handle:plugin,bool:late,String:error[],err_max)
{
	PrintToServer("");
	PrintToServer("");
	PrintToServer("######## ########  #######     ########  ########   ######   ");
	PrintToServer("   ##    ##       ##     ##    ##     ## ##     ## ##    ##  ");
	PrintToServer("   ##    ##              ##    ##     ## ##     ## ##        ");
	PrintToServer("   ##    ######    #######     ########  ########  ##   #### ");
	PrintToServer("   ##    ##       ##           ##   ##   ##        ##    ##  ");
	PrintToServer("   ##    ##       ##           ##    ##  ##        ##    ##  ");
	PrintToServer("   ##    ##       #########    ##     ## ##         ######   ");
	PrintToServer("");
	PrintToServer("");

	new String:version[64];
	Format(version,sizeof(version),"%s by %s",VERSION_NUM,AUTHORS);
	CreateConVar("TF2_RPG_Version",version,"TF2 RPG version.",FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	if(!TF2_RPG_InitNatives())
	{
		LogError("[TF2_RPG] There was a failure in creating the native based functions, definately halting.");
		return APLRes_Failure;
	}

	PrintToServer("PASSED TF2_RPG_InitNatives");

	if(!TF2_RPG_InitForwards())
	{
		LogError("[TF2_RPG] There was a failure in creating the forward based functions, definately halting.");
		return APLRes_Failure;
	}

	PrintToServer("PASSED TF2_RPG_InitForwards");

	RegPluginLibrary("TF2_RPG");

//#if defined _steamtools_included
	//MarkNativeAsOptional("Steam_SetGameDescription");
//#endif

	return APLRes_Success;
}
//=============================================================================
// OnAllPluginsLoaded
//=============================================================================
public OnAllPluginsLoaded()
{
	PrintToServer("OnAllPluginsLoaded");
	ConnectDB();
}
//=============================================================================
// OnMapStart
//=============================================================================
public OnMapStart()
{
	PrintToServer("OnMapStart");

	if(!FirstTimeMapStart)
	{
		LoadTranslations("TF2_RPG.phrases.txt");
	}

	FirstTimeMapStart=true;

	// Call Functions for OnMapStart() here
}
//=============================================================================
// OnMapEnd
//=============================================================================

public OnMapEnd()
{
	// Call Functions for OnMapEnd() here
}

