// FILE: Birthdate_MissionRewardsListener.uc
//
// Hook for personnel that are generated as mission rewards

class Birthdate_MissionRewardsListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIMissionSummary MissionScreen;
	local XComGameStateHistory History;
	local XComGameState_MissionSite Mission;
	local XComGameState_Reward RewardState;
	local array<StateObjectReference> Rewards;
	local int i;
	//local X2RewardTemplate RewardTemplate;
	local XComGameState_Unit Unit;

	MissionScreen = UIMissionSummary(Screen);
	if(none == MissionScreen)
	{
		return;
	}
	History = `XCOMHISTORY;
	// since MissionRef is still set for UIRewardsRecap (which appears later), it should be good here
	Mission = XComGameState_MissionSite(History.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	if(none == Mission)
	{
		return;
	}

	Rewards = Mission.Rewards;

	// find personnel rewards
	for(i = 0; i < Rewards.Length; ++i)
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(Rewards[i].ObjectID));
		if(none != RewardState)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
			// don't touch council soldiers, since they aren't newly generated
			if(none != Unit && 'Reward_SoldierCouncil' != RewardState.GetMyTemplateName())
			{
				class'AssignNewBirthday'.static.CheckUnit(Unit);
			}
		}
	}
}


defaultproperties
{
	// rewards are cleaned up by the time UIRewardsRecap is shown in strategy
	// making it a bit harder to determine what the mission granted
	// so use a UI for the end of tactical missions
	ScreenClass = UIMissionSummary;
}