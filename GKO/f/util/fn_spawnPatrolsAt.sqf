/*
	Spawns the given group at the given positions. The spawned groups will patrol a circle around each spawn position with the given radius.

	Parameters:
		0 - (array) Array of positions or objects where the groups will spawn. This can be an array of position or objects whose positions will be used. Or a mix of both.
		1 - (number) Radius of the patrol area of the groups.
		2 - (side) The side of the groups to spawn
		3 - (group) Anything that is accepted by BIS_fnc_spawnGroup
		4 - (number) [OPTIONAL] The delay between each group spawning (Default: 5 seconds).
	Return:
		NONE

	Locality:
		Can be called anywhere, but should be called on the server.
*/

_this spawn {
	private _radius = _this select 1;
	private _side = _this select 2;
	private _group = _this select 3;
	private _delay = _this select 4;

	private _delay = 5;

	if ((count _this) > 4) then {
		_delay = _this select 4;
	};

	{
		private _pos = _x;
		
		if (typeName _pos == "OBJECT") then {
			_pos = getPos _pos;
		};

		[
			_side,
			_group,
			_pos,
			_pos,
			_radius
		] spawn GKO_fnc_spawnPatrolGroup;

		sleep _delay;
	} forEach (_this select 0);
};