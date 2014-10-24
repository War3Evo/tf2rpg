// TF2_RPG_Misc_Natives.sp

public Plugin:myinfo=
{
	name="TF2 RPG Misc Natives",
	author=AUTHORS,
	description="TF2 RPG Core Plugins",
	version=VERSION_NUM,
};

public TF2_RPG_Misc_Natives_InitNatives()
{
	CreateNative("RPG_GetVar",Native_RPG_GetVar);
	CreateNative("RPG_SetVar",Native_RPG_SetVar);
}

public Native_RPG_GetVar(Handle:plugin,numParams){
	return _:RPGVarArr[RPGVar:GetNativeCell(1)];
}
public Native_RPG_SetVar(Handle:plugin,numParams){
	RPGVarArr[RPGVar:GetNativeCell(1)]=GetNativeCell(2);
}
