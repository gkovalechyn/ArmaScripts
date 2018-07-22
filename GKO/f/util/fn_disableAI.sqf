/*
	Disables the AI of the given unit.

	Parameters:
		0 - (object) The unit whose AI should be disabled.
		1 - (Array | string) Which AI should be disabled. (See: https://community.bistudio.com/wiki/disableAI)
	
	Return:
		NONE

	Locality:
		MUST be executed where the unit is local.

	Examples:
		[_unit, "PATH"] remoteExecCall ["GKO_fnc_disableAI", owner _unit];

		[_unit, ["PATH", "COVER", "FSM"]] remoteExecCall ["GKO_fnc_disableAI", owner _unit];
*/

if ([] isEqualType (_this select 1)) then {
	private _unit = _this select 0;
	
	{
		_unit disableAI _x;
	} forEach (_this select 1);
} else {
	(_this select 0) disableAI (_this select 1);
};
