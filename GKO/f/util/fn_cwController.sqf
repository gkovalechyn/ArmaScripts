//Continuous warfare controller
//Continuously spawns AI that keep attacking the given position(s)
//
//Parameters:
// 0 - (integer) Amount of AI to keep alive
// 1 - (side) The side of the units that will be spawned;
// 2 - (array) Groups that should be spawned (Any format that is accepted by BIS_fnc_spawnGroup)
// 3 - (Array) Positions where the groups can spawn
// 4 - (array) Positions that the groups will attack
// 5 - (number) [OPTIONAL] Safe distance for spawning. Once a spot to spawn the units is selected, if there are any playable units
//		within this distance of that point the spawn will not happen. To disable it pass a value lower than 0.
// 6 - (array) [OPTIONAL] Weights of the groups that will spawn
// 		If not provided, each group has the same chance of spawning.
//		The values should be between 0 and 1 and should add up to 1 (Meaning 100%).
//
// 7- (array) [OPTIONAL] Callback array. Array that contains all the callbacks. If you pass the callback array, callback 0 MUST
//			be defined, only callback 1 can be passed nil to be ignored.
//
// 		Callback 0 - Code that returns true or false signifying if the controller should be stopped.
//			return value: true means keep spawning the AI while false will stop spawning more.
//				If false is returned, to start spawning again a new CWController needs to be spawned.
//			Parameters passed:
//				_this select 0 - The total amount of AI that have been spawned so far.
//
//		Callback 1 - Code that will be called after each group is spawned.
//			Parameters passed:
//				_this select 0 - The Group that was spawned
//				_this select 1 - The groups waypoint. A SAD waypoint to one of the positions that the group can attack.
//
//
//Examples:
/*
[
	60,
	east,
	[getPos spawnpoint1, getPos spawnpoint2],
	[
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySection"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Group"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Patrol")
	]
] spawn GKO_fnc_cwController;

[
	60,
	east,
	[getPos spawnpoint1, getPos spawnpoint2],
	[
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySection"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Group"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Patrol")
	],
	-1, //Ignore the safe distance
	[0.2, 0.2, 0.6]
] spawn GKO_fnc_cwController;

[
	60,
	east,
	[getPos spawnpoint1, getPos spawnpoint2],
	[
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySection"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Group"),
		(configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Patrol")
	],
	100, //A circle with radius 100 around the selected spawnpoint must have no players for it to be able to spawn units in it
	[0.2, 0.2, 0.6],
	[
		{
			private _continueSpawning = (_this select 0) < 60; //Stop spawning AI if more than 60 have been spawned
			_continueSpawning
		},

		{
			private _group = _this select 0;
			private _waypoint = _this select 1;
			private _leader = leader _group;

			_leader setDamage 1; //Kill the leader of each group spawned
			_waypoint setWaypointSpeed "FULL";
		}
	]

] spawn GKO_fnc_cwController;
*/

private _maxAI = _this select 0;
private _side = _this select 1;
private _groups = _this select 2;
private _spawnpoints = _this select 3;
private _attackPositions =  _this select 4;
private _weights = [];
private _condition = {true};
private _groupCallback = nil;
private _safeSpawnDistance = -1;

//Optional parameter initialization
if ((count _this) > 5) then {
	_safeSpawnDistance = (_this select 5) * (_this select 5);
};

if ((count _this) > 6) then {
	_weights = _this select 6;
} else {
	private _weight = 1 / (count _groups);

	for "_i" from 1 to (count _groups) step 1 do{
		_weights pushBack _weight;
	};
};

if ((count _this) > 7) then {
	private _callbackArray = _this select 7;
	_condition = _callbackArray select 0;
	_groupCallback = _callbackArray select 1;
};
//End of optional parameter initialization

//private variables
private _spawnedGroups = [];
private _totalSpawnedAI = 0; 

while {([_totalSpawnedAI] call _condition)} do {
	private _aliveAICount = 0;
	private _aliveGroups = [];
	private _retryCount = 0;

	{
		if (({alive _x} count units _x) > 0) then {
			_aliveAICount = _aliveAICount + ({alive _x} count units _x);
			_aliveGroups pushBack _x;
		} else {
			deleteGroup _x;
		};
	} forEach _spawnedGroups;

	while {(_aliveAICount < _maxAI) && (_retryCount < 3)} do {
		private _spawnPosition = selectRandom _spawnpoints;
		private _isSpawnSafe = true;

		if (_safeSpawnDistance > 0) then {
			{
				if (alive _x) then {
					private _pos = getPos _x;
					if ((_pos vectorDistanceSqr _spawnPosition) < _safeSpawnDistance) exitWith {
						_isSpawnSafe = false;
					};
				};

				sleep 0.1;
			} forEach (allPlayers - entities "HeadlessClient_F");
		};

		if (_isSpawnSafe) then {
			private _selectedGroup = _groups selectRandomWeighted _weights;
			private _spawnedGroup = [_spawnPosition, _side, _selectedGroup] call BIS_fnc_spawnGroup;
			private _waypoint = objNull;

			if ((count _attackPositions) > 0) then {
				private _attackPosition = selectRandom _attackPositions;
				_waypoint = _spawnedGroup addWaypoint [_attackPosition, 50];

				_waypoint setWaypointType "SAD";
				_waypoint setWaypointSpeed "FULL";
				_waypoint setWaypointCombatMode "RED";
				_waypoint setWaypointBehaviour "AWARE";
			};

			_aliveGroups pushBack _spawnedGroup;
			_aliveAICount = _aliveAICount + (count units _spawnedGroup);
			_totalSpawnedAI = _totalSpawnedAI + (count units _spawnedGroup);

			if (!isNil "_groupCallback") then {
				[_spawnedGroup, _waypoint] call _groupCallback;
			};
		}else{
			_retryCount = _retryCount + 1;
		};

		sleep 5;
	};

	_spawnedGroups = _aliveGroups;

	sleep 60;
};