/**
Garrisons AI inside a building
parameters:
	0 - The building to be garrissoned. (See https://community.bistudio.com/wiki/nearestBuilding)	
	1 - An array of units that should be garrisoned inside the building. This parameter can be:
		A group
		An array of units.

Examples:
	private _building = nearestBuilding (getPos marker);
	private _group = [...] call BIS_fnc_spawnGroup;
	[_builduing, _group] call GKO_fnc_garrisonBuilding;



	private _building = nearestBuilding (getPos marker);
	private _group = createGroup east;
	private _units = [
		(_group createUnit ["Type", getPos marker, [], 0, "NONE"]),
		(_group createUnit ["Type", getPos marker, [], 0, "NONE"]),
		(_group createUnit ["Type", getPos marker, [], 0, "NONE"]),
		(_group createUnit ["Type", getPos marker, [], 0, "NONE"])
	];
	[_building, _units] call GKO_fnc_garrisonBuilding;
*/	