/*
	Spawns an animal at the given position.

	More info: https://community.bistudio.com/wiki/Arma_3_Animals:_Override_Default_Animal_Behaviour_Via_Script
	
	Parameters:
		0 - The animal type. It can be:
			"Goat"
			"Sheep"
			"Dog"
			"Rabbit"
			"Cockerel"
			"Hen"
			"Snake"
		1 - (Position) Where the animal should spawn.
	Return:
		(Object) The animal that was spawned.

	Locality:
		Can be called anywhere, but should be called on the server.
*/

private _animalClass = "Goat_Random_F";

switch((_this select 0)) do {
	case "Sheep": {
		_animalClass = "Sheep_Random_F";
	};
	case "Dog": {
		_animalClass = "FIN_Random_F";
	};
	case "Rabbit": {
		_animalClass = "Rabbit_F";
	};
	case "Cockerel": {
		_animalClass = "Cock_Random_F";
	};
	case "Hen": {
		_animalClass = "Hen_Random_F";
	};
	case "Snake": {
		_animalClass = "Snake_Random_F";
	};
};

(createAgent [_animalClass, (_this select 1), [], 0, "CAN_COLLIDE"]);