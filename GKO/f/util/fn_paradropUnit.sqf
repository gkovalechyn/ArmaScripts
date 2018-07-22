/*
	Makes the given unit leave the current vehicle and enter a parachute at the altitude the unit is.

	Parameters:
		0 - (Object) The unit that will be paradropped

	Return:
		NONE

	Locality:
		Can be called anywhere, but should be called on the server.

*/

_this spawn {
	private _unit = _this select 0;

	_unit allowDamage false;

	unassignVehicle _unit;
	moveOut _unit;

	sleep 0.5;

	_unit allowDamage true;

	private _parachute = createVehicle ["Steerable_Parachute_F", getPosATL _unit, [], 0, "NONE"];


	_parachute setPosATL (getPosATL _unit);
	_parachute setVelocity (velocity _unit);

	[_unit, _parachute] remoteExecCall ["GKO_fnc_moveInDriver", (owner _unit)];
};