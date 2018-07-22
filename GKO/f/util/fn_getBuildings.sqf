/*
Based on https://github.com/Wolfenswan/ws_fnc/blob/master/Tools/fn_collectBuildings.sqf

GKO_fnc_getBuildings

Gets all useable buildings (have building positions) in given radius

USAGE
	Minimal
		[center,radius] call GKO_fnc_getBuildings
	Full
		[center,radius,bool] call GKO_fnc_getBuildings

PARAMETERS
	1. (position) Center from where to check - can be marker, object, location
	2.   (number) Radius in which to check
	3.  (boolean) Get buildings without any positions

RETURNS
	Array of useable buildings
*/

/*
private _pos = (_this select 0);
private _radius = _this select 1;
private _flag1 = if (count _this > 2) then {_this select 2} else {false};

private _buildings = [];

//Fill buildings array with classes shared by both games
{
	_buildings append nearObjects [_pos, [_x], _radius];
} forEach ["Fortress", "House", "House_Small", "Church"];


{
	_buildings append nearObjects [_pos, [_x], _radius];
} forEach ["Ruins_F","BagBunker_base_F","Stall_base_F","Shelter_base_F"];


if (_flag1) then {
	{
		_bp = _x buildingPos 0;
 		if (str _bp == "[0,0,0]" || typeName _bp != typeName []) then {_buildings = _buildings - [_x]};
	} forEach _buildings;
};


_buildings