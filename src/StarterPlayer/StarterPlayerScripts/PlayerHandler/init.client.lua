local PlayerFunctions = require(script.PlayerFunctions)
local Player = game.Players.LocalPlayer

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value

PlayerFunctions.AntiAfk()
PlayerFunctions.CreateSettings()
PlayerFunctions.CreateEvents()
PlayerFunctions.CreateChests()