--// Setup

local LocalPlayer = game.Players.LocalPlayer

repeat task.wait() until LocalPlayer:FindFirstChild("Loaded") and LocalPlayer.Loaded.Value -- Player Loaded

--// Load the rest
local HUD = require(script.HUD)
HUD:Init()

--// Load the randoms
local Controllers = require(script.Controllers)
Controllers:Init()

--// Load Frames
local Frames = require(script.Frames)
Frames:Init()

