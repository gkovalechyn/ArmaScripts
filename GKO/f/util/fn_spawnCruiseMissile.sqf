/*
Based on:
https://gist.github.com/barbuse/251d491476de6a28ef3e16c1661d6b68

Parameters:
	0 - (object or position) Target.
	1 - (position) Launch position.
	2 - (Vehicle name) Missile type
	3 - (number) Flying height above ground
	4 - (number) Missile speed
	5 - (number) [OPTIONAL] Turning rate (degrees per second) default: 120
	5 - (number) [OPTIONAL] Terminal guidance activation distance
	6 - (code) [OPTIONAL] code to be called once the missile is destroyed or has reached its target.
		Passed parameters:
			0 - The last position the missile was at before it was destroyed. It may have reached its target or not.

	Return:
		NONE
	
	Locality:
		Can be called anywhere, but should be called on the server.

	Example:
		private _callback = {
			private _lp = _this select 0;
			_payload = 600;
			[_lp, _payload] call RHS_fnc_ss21_nuke;
		};

		private _pos = getPos baseCenter;
		_pos set [2, (_pos select 2) + 10];

		[wave3AttackPos1, _pos, "RHS_9M79B", 300, 300, 180, 300, _callback] spawn GKO_fnc_spawnCruiseMissile;
*/

#define MODE_NORMAL 0
#define MODE_TERMINAL 1

#define UPDATES_PER_SECOND 10

private _target = _this select 0;
private _startPos = _this select 1;
private _missileType = _this select 2;
private _missileHeight = _this select 3;
private _missileSpeed = _this select 4;
private _turningRate = 120;
private _reachedCallback = nil;

private _updateInterval = 1 / UPDATES_PER_SECOND;
//private _terminalGuidanceDistance = 200;
private _terminalGuidanceDistance = _missileSpeed;

if ((count _this > 5)) then {
	_turningRate = _this select 5;
};

if ((count _this > 6)) then {
	_terminalGuidanceDistance = _this select 6;
};

if ((count _this > 7)) then {
	_reachedCallback = _this select 7;
};

private _missile = _missileType createVehicle _startPos;

private _lastMissilePos = getPos _missile;

private _launchTime = 1;
private _endLaunchTime = time + _launchTime;

private _mode = MODE_NORMAL;
private _hasReachedTheTarget = false;

while {time < _endLaunchTime} do {
	private _percentage = 1 - ((_endLaunchTime - time) / _launchTime);
	private _vel = [0, _missileSpeed, _percentage * _percentage] call BIS_fnc_lerp;

	[_missile, 90, 0] call BIS_fnc_setPitchBank;
	_missile setVelocity [0, 0, _vel];

	sleep _updateInterval;
};

private _contineCondition = {
	if ((typename _target) == "OBJECT") exitWith{
		alive _target
	};
	
	true
};

while {alive _missile && _contineCondition} do {
	private _missilePos = getPos _missile;
	private _targetASL = objNull;
	private _missileASL = getPosASL _missile;

	if ((typename _target) == "OBJECT") then {
		_targetASL = getPosASL _target;
	} else {
		_targetASL = _target;
	};

	private _vectorToTarget = vectorNormalized (_targetASL vectorDiff _missileASL);
	private _nextTargetPosition = _missilePos vectorAdd (_vectorToTarget vectorMultiply (_missileSpeed * _updateInterval));
	private _nextTargetAGL = ASLToAGL _nextTargetPosition;

	private _stepTurningRate = _turningRate / UPDATES_PER_SECOND;

	private _vectorToNextPosition = [0, 0, 0];

	if (_mode != MODE_TERMINAL) then {
		private _xyPos = [_missilePos select 0, _missilePos select 1, 0];
		private _xyTarget = [_targetASL select 0, _targetASL select 1, 0];

		if ((_xyPos vectorDistance _xyTarget) < _terminalGuidanceDistance) then {
			_mode = MODE_TERMINAL;
		};
	};


	switch (_mode) do{
		case MODE_NORMAL: {
			if ((_nextTargetAGL select 2) < _missileHeight) then {
				_nextTargetAGL set [2, _missileHeight];
			}else {
				_nextTargetAGL set [2, [(_nextTargetAGL select 2), _missileHeight, _updateInterval] call BIS_fnc_lerp];
			};

			_vectorToNextPosition = vectorNormalized (_nextTargetAGL vectorDiff _missilePos);
		};

		case MODE_TERMINAL: {
			_vectorToNextPosition = vectorNormalized (_targetASL vectorDiff _missileASL);
			/*
			private _missileASL = getPosASL _missile;
			private _targetASL = getPosASL _target;

			private _xyPos = [_missilePos select 0, _missilePos select 1, 0];
			private _xyTarget = getPos _target;

			_xyTarget set [2, 0];

			private _percentage =  (_xyPos vectorDistance _xyTarget) / _terminalGuidanceDistance;
			private _targetPos = getPos _target;
			private _zDifference = (_targetASL select 2) - (_missileASL select 2);

			_percentage = [_percentage, 0, 1] call BIS_fnc_clamp;

			systemChat str _zDifference;

			private _finalHeight = _missilePos select 2;
			_finalHeight = _finalHeight + _zDifference * (1 - _percentage);

			_nextTargetPosition set [2, _finalHeight];
			systemChat str _nextTargetPosition;
			*/
		};
	};



	private _currentDirection = vectorNormalized (velocity _missile);	

	//_finalSpeed = [_currentSpeed, _finalSpeed, 0.001] call BIS_fnc_lerpVector;
	
	private _angle =  acos(_currentDirection vectorCos _vectorToNextPosition);
	private _toTurn = _angle;

	if (_angle == 0) then {
		_toTurn = 1;
		_angle = 1;
	};

	if (_toTurn > _stepTurningRate) then{
		_toTurn = _stepTurningRate;
	};

	

	//systemChat format ["Angle: %1", _angle];
	//systemChat format ["To turn: %1", _toTurn];
	//systemChat format ["Percentage: %1", (_toTurn / _angle)];

	private _finalDirection = [_currentDirection, _vectorToNextPosition, _toTurn / _angle] call BIS_fnc_lerpVector;

	//_finalSpeed set [0, [(_currentSpeed select 0), (_finalSpeed select 0), _toTurn / _angle] call BIS_fnc_lerp];
	//_finalSpeed set [1, [(_currentSpeed select 1), (_finalSpeed select 1), _toTurn / _angle] call BIS_fnc_lerp];
	//_finalSpeed set [2, [(_currentSpeed select 2), (_finalSpeed select 2), _toTurn / _angle] call BIS_fnc_lerp];

	//systemChat format ["Difference: %1 (%2)", _finalDirection vectorDiff _currentDirection, vectorMagnitude (_finalDirection vectorDiff _currentDirection)];

	_missile setVectorDir _finalDirection;

	private _finalSpeed = (_finalDirection vectorMultiply _missileSpeed);

	_missile setVelocity _finalSpeed;


	/* The pitch adjustment just fucks everything up for some reason
	private _oldPitchBank = _missile call BIS_fnc_getPitchBank;
	private _newPitch = asin(_vectorToNextPosition select 2);

	_newPitch = [_oldPitchBank select 0, _newPitch, 0.01] call BIS_fnc_lerp;

	[_missile, _newPitch, 0] call BIS_fnc_setPitchBank;
	*/

	_lastMissilePos = getPos _missile;

	if((_missileASL distance _targetASL) < 3) then {
		_hasReachedTheTarget = true;
	};

	sleep _updateInterval;
};

if (!isNil "_reachedCallback") then {
	[_lastMissilePos, _hasReachedTheTarget] call _reachedCallback;
};
