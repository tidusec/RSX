local Effects = require(script.Effects)

local Worlds = {
	["Spawn"] = {Requirement = 0,WorldBoost = 1, WorldColor = Color3.fromRGB(200, 255, 170),WorldEffect = function() Effects.SetDefaultEffects() end}, -- Requirement in Rank
	["Forest"] = {Requirement = 5,WorldBoost = 2, WorldColor = Color3.fromRGB(92, 223, 82),WorldEffect = function() Effects.SetForestEffects() end},
	["Frosty"] = {Requirement = 9, WorldBoost = 3, WorldColor = Color3.fromRGB(85, 255, 255),WorldEffect = function() Effects.SetFrostyEffects() end},
	["Mine"] = {Requirement = 13, WorldBoost = 5, WorldColor = Color3.fromRGB(111, 111, 111),WorldEffect = function() Effects.SetMineEffects() end},
	["Aqua"] = {Requirement = 17, WorldBoost = 6, WorldColor = Color3.fromRGB(8, 119, 255),WorldEffect = function() Effects.SetAquaEffects() end},
	["Steampunk"] = {Requirement = 21, WorldBoost = 8, WorldColor = Color3.fromRGB(132, 70, 7),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Sakura"] = {Requirement = 26, WorldBoost = 10, WorldColor = Color3.fromRGB(255, 144, 211),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Candy"] = {Requirement = 30, WorldBoost = 12, WorldColor = Color3.fromRGB(255, 0, 255),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Toxic"] = {Requirement = 34, WorldBoost = 15, WorldColor = Color3.fromRGB(85, 255, 0),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Medieval"] = {Requirement = 38, WorldBoost = 18, WorldColor = Color3.fromRGB(85, 170, 255),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Volcanic"] = {Requirement = 42, WorldBoost = 21, WorldColor = Color3.fromRGB(255, 85, 0),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Farm"] = {Requirement = 46, WorldBoost = 25, WorldColor = Color3.fromRGB(85, 170, 0),WorldEffect = function() Effects.SetDefaultEffects() end},
	["Glacier"] = {Requirement = 50, WorldBoost = 28, WorldColor = Color3.fromRGB(0, 170, 255),WorldEffect = function() Effects.SetDefaultEffects() end},
}

return Worlds
