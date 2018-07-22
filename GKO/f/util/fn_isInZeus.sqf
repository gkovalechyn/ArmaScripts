/*
	Checks if the current player is in zeus.

	Parameters:
		NONE

	Returns:
		True if the zeus interface is open, false otherwise. Will return true even if the user is in the pause screen.

	Locality:
		Must be executed on a player, not on the server or headless client.
	
	Example:
		private _isInZeus = [] call GKO_fnc_isInZeus;
*/

#define ZEUS_DISPLAY_ID 312
(!isNull (findDisplay ZEUS_DISPLAY_ID));