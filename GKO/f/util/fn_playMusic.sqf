/*
	Plays music on all clients.

	Parameters:
		0 - The music.

	Return:
		NONE
	
	Locality:
		Can be called anywhere and the music will be played on all clients. But for safety it only should be called on the server.

	Example:

		["Fallout"] call GKO_fnc_playMusic;
*/

_this remoteExecCall ["playMusic"];