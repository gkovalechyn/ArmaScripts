/*
	Spawns a group at a given position that will patrol around the spawn position.

	Parameters:
		0 - (Side) The side of the group that will spawn
		1 - (Group) The group that can be will be spawned. (Anything that can be spawned by BIS_fnc_spawnGroup)
		2 - (Postion) Where the group will spawn.
		3 - (Postion) The center of the area the group will spawn.
		4 - (number) The radius of the area the ai will patrol.
	Return:
		NONE

	Locality:
		Can be called anywhere, but should be called on the server.
*/
#define WAYPOINT_COUNT 6

private _side = _this select 0;
private _groupToSpawn = _this select 1;
private _spawnPos = _this select 2;
private _center = _this select 3;
private _radius = _this select 4;

private _group = [_spawnPos, _side, _groupToSpawn] call BIS_fnc_spawnGroup;

_group deleteGroupWhenEmpty true;

for "_i" from 0 to (WAYPOINT_COUNT - 1) step 1 do {
	private _waypoint = _group addWaypoint [_center, _radius];

	if (_i == 0) then {
		_waypoint setWaypointSpeed "LIMITED";
		_waypoint setWaypointBehaviour "SAFE";
		_waypoint setWaypointType "MOVE";
	};

	if (_i == (WAYPOINT_COUNT - 1)) then{
		_waypoint setWaypointType "CYCLE";
	};
};