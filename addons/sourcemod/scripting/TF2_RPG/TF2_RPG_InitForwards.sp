// TF2_RPG_InitForwards.sp

//=============================================================================
// TF2_RPG_InitForwards
//=============================================================================
public bool:TF2_RPG_InitForwards()
{
	TF2_RPG_CommandHook_Forwards();
	TF2_RPG_ShopItem_Engine_Forwards();
	TF2_RPG_PlayerClass_Forwards();
	return true;
}
