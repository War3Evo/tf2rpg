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

new TransClient;

new RPGVarArr[RPGVar];

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

//=============================
// Shop Items
//=============================

new Handle:g_hItemNumber;
new Handle:g_h_ItemCategorys;
new Handle:g_hItemLongName;
new Handle:g_hItemShortDesc;
new Handle:g_hItemLongDesc;
new Handle:g_hItemCost;
new Handle:g_hItemClass;
new Handle:g_hItemBuyName;
new Handle:g_hItemBuffName;
new Handle:g_hItemValue;

