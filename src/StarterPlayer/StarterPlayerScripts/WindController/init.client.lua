local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local WIND_DIRECTION = Vector3.new(1,0,0.3)
local WIND_SPEED = 20
local WIND_POWER = 0.5
local SHAKE_RADIUS = 120

local WindLines = require(script.WindLines)

WindLines:Init({
	Direction = WIND_DIRECTION;
	Speed = WIND_SPEED;
	Lifetime = 1.5;
	SpawnRate = 11;
})