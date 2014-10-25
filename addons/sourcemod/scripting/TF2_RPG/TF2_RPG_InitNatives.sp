// TF2_RPG_InitNatives.sp

//=============================================================================
// TF2_RPG_InitNatives
//=============================================================================
public bool:TF2_RPG_InitNatives()
{
	TF2_RPG_PlayerClass_InitNatives();
	TF2_RPG_Misc_Natives_InitNatives();
	TF2_RPG_ShopItem_Engine_InitNatives();

	return true;
}
