/*
	Makes a unit play an animation that will be stopped once the unit goes into combat.

	Parameters:
		0 - (Object) The unit
		1 - (String) The animation
		2 - [OPTIONAL] (String) The equipment level. (Default: "FULL")

	Return:
		NONE

	Locality:
		Must be called on the server, the effect will be broadcast to all connected clients.

	Examples:
	[_unit, "STAND1"] call GKO_fnc_ambientAnim;

	[_unit, "STAND1", "NONE"] call GKO_fnc_ambientAnim;
*/

private _unit = _this select 0;
private _animation = _this select 1;
private _equipmentLevel = "FULL";

if (count _this > 2) then {
	_equipmentLevel = _this select 2;
};

[_unit, _animation, _equipmentLevel] remoteExec ["BIS_fnc_ambientAnim", 0, true];

if (isServer) then {
	[_unit] spawn {
		private _unit = _this select 0;

		waitUntil {
			sleep 5;
			behaviour _unit == "COMBAT";
		};

		[_unit] remoteExec ["BIS_fnc_ambientAnim__terminate", 0, true];
	};
};