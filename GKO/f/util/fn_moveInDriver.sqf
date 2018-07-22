/*
	Moves a unit into the driver seat of a vehicle.
	
	Parameters:
		0 - (Object) The unit that should be moved.
		1 - (Object) The vehicle that the unit will enter.

	Return:
		NONE

	Locality:
		This MUST be executed where the unit is local.

	Example:
		[_unit, _vehicle] remoteExecCall ["GKO_fnc_moveInDriver", owner _unit];
*/

(_this select 0) moveInDriver (_this select 1);