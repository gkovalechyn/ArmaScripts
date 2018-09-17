/*
	Creates a helicopter at the given position and paradrops the unit inside it in the given area. After the drop the helicopter will return to the spawn position and be deleted;

	Parameters:
		0 - (string) Helicopter classname.
		1 - (unit) The helicopter pilot.
		2 - (Position) Where the helicopter will spawn.
		3 - (Position) Where the helicopter will paradrop the units inside it.
		4 - (number) How far early should the drop start.
		5 - The units that will paradrop.
			This can be:
			(array) An array of Groups (Give a name to the group in the editor and place them here) or spawn them yourself.
			(array) An array of units.
	
	Return:
		NONE

	Locality:
		Can be called anywhere, but should be called on the server.
*/

#define TRIGGER_AREA_RADIUS 1000

private _helicopterClassname = _this select 0;

private _spawnPos = _this select 2;
private _dest = _this select 3;


if ((_spawnPos select 2) < 30) then {
	_spawnPos set [2, 30];
};

private _units = _this select 5;

if ((_units select 0) isEqualType grpNull) then {
	private _arr = [];

	{
		_arr = _arr append (units _x);
	}forEach _units;

	_units = _arr;
};

//Create a helicopter and crew
private _helicopter = createVehicle [_helicopterClassname, _spawnPos, [], 0, "FLY"];
private _direction = vectorNormalized (_dest vectorDiff _spawnPos);

private _crew = _this select 1;
private _crewGroup = group _crew;

_crew moveInDriver _helicopter;
_helicopter setVelocity [0, 0, 25];
_helicopter setPos _spawnPos;

_helicopter addBackpackCargoGlobal ["B_Parachute", 24];

{
	_x moveInCargo _helicopter;
}forEach _units;

//Create a trigger to trigger the units being ejected from the helicopter
_direction = _direction vectorMultiply (_this select 4);

private _directionAngle = [0, 1, 0] vectorCos _direction;
_directionAngle = acos _directionAngle;

private _trigger = createTrigger ["EmptyDetector", (_dest vectorAdd _direction), false];
_trigger setTriggerArea [TRIGGER_AREA_RADIUS, 200, _directionAngle, false];

//Set the helicopter waypoints
private _waypoint = _crewGroup addWaypoint [_dest, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";

_direction = _direction vectorMultiply -200;
private _waypoint2 = _crewGroup addWaypoint[(_dest vectorAdd _direction), 0];

private _waypoint3 = _crewGroup addWaypoint[_spawnPos, 0];
_waypoint3 setWaypointStatements ["true", "{deleteVehicle _x} forEach (thisList + [vehicle this])"];

//Wait until the helicopter reaches the trigger area and then paradrop everybody
[_helicopter, _trigger, _crew] spawn {
	private _helo = _this select 0;
	private _trigger = _this select 1;
	private _pilot = _this select 2;

	waitUntil {
		sleep 0.5;
		((getPos _helo) inArea _trigger) || (!alive _helicopter)
	};
	
	if (!alive _helicopter) exitWith {};
	
	{
		private _unit = _x;

		if (alive _unit && (_unit != _pilot)) then {
			[_unit] call GKO_fnc_paradropUnit;
			sleep 0.5
		};

	}forEach (crew _helo);
};