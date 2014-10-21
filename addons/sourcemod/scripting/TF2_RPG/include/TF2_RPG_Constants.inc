// TF2_RPG_Constants.inc

// The "MAXPLAYERS" in clients.inc is 65 and for TF2 we don't have more than 32, so why waste space?
#define MAXPLAYERSCUSTOM 34   //+2 of real for normal servers, add +X number of HLTV slots

/*
enum TFClassType
{
	TFClass_Unknown = 0,
	TFClass_Scout,
	TFClass_Sniper,
	TFClass_Soldier,
	TFClass_DemoMan,
	TFClass_Medic,
	TFClass_Heavy,
	TFClass_Pyro,
	TFClass_Spy,
	TFClass_Engineer
};*/

#define MAXCLASSES 10 // there is actually 9, but need 10 because of the "unknown" variable in TFClassType

