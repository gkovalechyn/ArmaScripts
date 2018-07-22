/*
Spawns a vehicle fire at the location provided. This function needs to be called on each client.
Parameters:
	0 - The vehicle that is on fire
Returns:
	Array of vehicles that are the particle sources.
*/
private _veh = _this select 0;

private _ps1 = "#particlesource" createVehicleLocal (getPos _veh);
private _ps2 = "#particlesource" createVehicleLocal (getPos _veh);
private _ps3 = "#particlesource" createVehicleLocal (getPos _veh);

_ps1 setParticleCircle [0, [0, 0, 0]];
_ps1 setParticleRandom [0.2, [1, 1, 0], [0.5, 0.5, 0], 1, 0.5, [0, 0, 0, 0], 0, 0];
_ps1 setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 2, 6], "", "Billboard", 1, 1, [0, 0, 0], [0, 0, 0.5], 1, 1, 0.9, 0.3, [1.5], [[1, 0.7, 0.7, 0.5]], [1], 0, 0, "", "", _veh];
_ps1 setDropInterval 0.03;


_ps2 setParticleCircle [0, [0, 0, 0]];
_ps2 setParticleRandom [0, [0, 0, 0], [0.33, 0.33, 0], 0, 0.25, [0.05, 0.05, 0.05, 0.05], 0, 0];
_ps2 setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 0, 1], "", "Billboard", 1, 10, [0, 0, 0.5], [0, 0, 2.9], 1, 1.275, 1, 0.066, [4, 5, 10, 10], [[0.3, 0.3, 0.3, 0.33], [0.4, 0.4, 0.4, 0.33], [0.2, 0.2, 0, 0]], [0, 1], 1, 0, "", "", _veh];
_ps2 setDropInterval 0.5;

_ps3 setParticleCircle [0, [0, 0, 0]];
_ps3 setParticleRandom [0, [0, 0, 0], [0.5, 0.5, 0], 0, 0.25, [0.05, 0.05, 0.05, 0.05], 0, 0];
_ps3 setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 3, 1], "", "Billboard", 1, 15, [0, 0, 0.5], [0, 0, 2.9], 1, 1.275, 1, 0.066, [4, 5, 10, 10], [[0.1, 0.1, 0.1, 0.75], [0.4, 0.4, 0.4, 0.5], [1, 1, 1, 0.2]], [0], 1, 0, "", "", _veh];
_ps3 setDropInterval 0.25;

[_ps1, _ps2, _ps3];