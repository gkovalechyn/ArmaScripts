/* 
	Tries to delete all empty groups
	Parameters:
		NONE

	Return:
		NONE

	Locality:
		Must be executed on all computers.

	Example:
		[] remoteExec ["GKO_fnc_cleanupEmptyGroups"];
*/

{
	if (count units _x == 0) then {
		deleteGroup _x;
	};
} forEach allGroups;