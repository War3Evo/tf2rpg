// TF2_RPG_Variables.inc

stock dummy; //variable for dummies! Use this where ever u want for a dummy return
stock String:dummystr[32]; //just a dummy string!

new dummyreturn; //for your not used return values

new bHasDiedThisFrame[MAXPLAYERSCUSTOM];
/**********************
 * prevent double kills if the same player in the same frame,
 * like killed by skill damage is one kill message, killed by original damge is another death message,
 * woudl cause double xp kill, because skill damage is actually dealt first (nested)
 */

new bool:FirstTimeMapStart=false;

//==============================
// DATABASE
//==============================
new Handle:hDB;
new TF2_RPG_SQLType:g_SQLType;

//=============================
// PlayerClass
//=============================
new p_properties[MAXPLAYERSCUSTOM][RPGPlayerProp];

//=============================
// LoadConfiguartion
//=============================

new Handle:g_hWeaponsXP;
new Handle:g_hLevel_Progression;

