/*
Spawns a big smoke pillar at the location provided. This function needs to be called on each client.
Parameters:
	0 - The location of the smoke pillar
Returns:
	The vehicle that is the particle source;
*/
private _ps = "#particlesource" createVehicleLocal (_this select 0);
_ps setParticleCircle [0, [0, 0, 0]];
_ps setParticleRandom [0, [0.5, 0.5, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_ps setParticleParams [["\Ca\Data\ParticleEffects\FireAndSmokeAnim\SmokeAnim.p3d", 8, 1, 6], "", "Billboard", 1, 8, [0, 0, 0], [0, 0, 4.5], 0, 10, 7.9, 0.5, [4, 12, 20], [[0.1, 0.1, 0.1, 0.8], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.125], 1, 0, "", "", _ps];
_ps setDropInterval 0.1;

_ps;