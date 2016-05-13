// FILE: Birthdate_NewSoldierFromPOIListener.uc
//
// Listener for completing points of interest that award 1+ soldiers

class Birthdate_NewSoldierFromPOIListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIAlert Alert;
	local XComGameStateHistory History;
	local XComGameState_PointOfInterest POIState;

	local StateObjectReference RewardRef;
	local XComGameState_Reward RewardState;

	local XComGameState_Unit Unit;

	Alert = UIAlert(Screen);

	if(none == Alert)
	{
		return;
	}

	// it doesn't like an equality comparison here?
	switch(Alert.eAlert)
	{
		case eAlert_ScanComplete:
			History = `XCOMHISTORY;
			POIState = XComGameState_PointOfInterest(History.GetGameStateForObjectID(Alert.POIRef.ObjectID));

			// check if the POI awards any units
			foreach POIState.RewardRefs(RewardRef)
			{
				RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRef.ObjectID));
				if(none != RewardState)
				{
					Unit = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
					if(none != Unit)
					{
						class'AssignNewBirthday'.static.CheckUnit(Unit);
					}
				}
			}
			break;
	}
}


defaultproperties
{
	ScreenClass = UIAlert;
}