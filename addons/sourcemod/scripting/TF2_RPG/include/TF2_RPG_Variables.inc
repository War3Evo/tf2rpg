// TF2_RPG_Variables.inc

stock dummy; //variable for dummies! Use this where ever u want for a dummy return
stock String:dummystr[32]; //just a dummy string!

new dummyreturn; //for your not used return values

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

