// TF2_RPG_000_OnGameFrame.sp

public OnGameFrame()
{
	for(new i=1;i<MAXPLAYERSCUSTOM;i++){
		bHasDiedThisFrame[i]=0;
	}
}
