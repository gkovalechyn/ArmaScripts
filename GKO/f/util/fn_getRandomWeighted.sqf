/*
	Returns a random element from the given array based on the weights for each array item supplied.

	Parameters:
		0 - (Array) Array of items from which the item will be selected
		1 - (Array) Array of weights for each item of the array.
			The array weights must be between 0 and 1 and must all add up to 1
	
	Return:
		(any) An element from the array provided.

	Locality:
		NONE

	Example:
		private _values = [1, 2, 3];
		private _weights = [0.5, 0.25, 0.25];

		private _selected = [_values, _weights] call GKO_fnc_getRandomWeighted;
*/

private _items = _this select 0;
private _weights = _this select 1;

private _val = _items select 0;
private _weightSum = 0;

private _random = random 1;

for "_i" from 0 to (count _items - 1) step 1 do {
	_weightSum = _weightSum + (_weights select _i);

	if (_weightSum < _random) exitWith {
		_val = (_items select _i);
	};
};


_val;