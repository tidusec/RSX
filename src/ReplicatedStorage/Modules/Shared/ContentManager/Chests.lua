local Chests = {
	["Daily"] = {
		Cooldown = 86400,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "Gems", Amount = 500,},
			[2] = {Type = "Number", Folder = "Data", Stat = "Boost"},
		},
		Text = "Succesfully claimed Gems & %s",
		Requirement = function(Player)
			return true
		end,
		World = "Spawn", -- important for anti cheat
	},
	["Group"] = {
		Cooldown = 14400,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "Gems", Amount = 200,},
		},
		Text = "Succesfully claimed Gems",
		Requirement = function(Player)
			return Player:IsInGroup(12554523)
		end,
		World = "Spawn", -- important for anti cheat
	},
	["Mine"] = {
		Cooldown = 18000,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "Boost"},
		},
		Text = "Succesfully claimed %s",
		Requirement = function(Player)
			return true
		end,
		World = "Mine", -- important for anti cheat
	},
	["Forest"] = {
		Cooldown = 14400,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "Boost"},
		},
		Text = "Succesfully claimed %s",
		Requirement = function(Player)
			return true
		end,
		World = "Forest", -- important for anti cheat
	},
	["Toxic"] = {
		Cooldown = 28800,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "Boost"},
		},
		Text = "Succesfully claimed %s",
		Requirement = function(Player)
			return true
		end,
		World = "Toxic", -- important for anti cheat
	},
	
	["Sinister Valley"] = {
		Cooldown = 28800,
		Reward = {
			[1] = {Type = "Number", Folder = "Data", Stat = "CandyCorn", Amount = 200},
		},
		Text = "Succesfully claimed 200 CandyCorn",
		Requirement = function(Player)
			return true
		end,
		World = "Sinister Valley", -- important for anti cheat
	},
}
--x2StarsAvailable
return Chests
