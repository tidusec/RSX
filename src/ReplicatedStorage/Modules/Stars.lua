	local module = {
	["Spawns"] = {
		["Spawn"] = {
			MaxSpawn = 250,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 1},
				[2] = {Chance = 24, Multiplier = 2},
				[3] = {Chance = 15, Multiplier = 3},
				[4] = {Chance = 10, Multiplier = 5, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 1000},
			}
		},
		["Forest"] = {
			MaxSpawn = 80,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 2},
				[2] = {Chance = 24, Multiplier = 4},
				[3] = {Chance = 15, Multiplier = 6},
				[4] = {Chance = 10, Multiplier = 7, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 2000},
			}
		},
		["Frosty"] = {
			MaxSpawn = 100,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 5},
				[2] = {Chance = 24, Multiplier = 8},
				[3] = {Chance = 15, Multiplier = 12},
				[4] = {Chance = 10, Multiplier = 9, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 5000},
			}
		},
		["Mine"] = {
			MaxSpawn = 80,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 10},
				[2] = {Chance = 24, Multiplier = 15},
				[3] = {Chance = 15, Multiplier = 25},
				[4] = {Chance = 10, Multiplier = 11, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 10000},
			}
		},
		["Aqua"] = {
			MaxSpawn = 100,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 30},
				[2] = {Chance = 24, Multiplier = 60},
				[3] = {Chance = 15, Multiplier = 90},
				[4] = {Chance = 10, Multiplier = 14, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 30000},
			}
		},
		["Steampunk"] = {
			MaxSpawn = 90,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 40},
				[2] = {Chance = 24, Multiplier = 80},
				[3] = {Chance = 15, Multiplier = 120},
				[4] = {Chance = 10, Multiplier = 17, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 80000},
			}
		},
		["Sakura"] = {
			MaxSpawn = 100,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 50},
				[2] = {Chance = 24, Multiplier = 100},
				[3] = {Chance = 15, Multiplier = 150},
				[4] = {Chance = 10, Multiplier = 22, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 100000},
			}
		},
		["Candy"] = {
			MaxSpawn = 150,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 60},
				[2] = {Chance = 24, Multiplier = 120},
				[3] = {Chance = 15, Multiplier = 180},
				[4] = {Chance = 10, Multiplier = 26, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 240000},
			}
		},
		["Toxic"] = {
			MaxSpawn = 150,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 70},
				[2] = {Chance = 24, Multiplier = 140},
				[3] = {Chance = 15, Multiplier = 210},
				[4] = {Chance = 10, Multiplier = 30, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 280000},
			}
		},
		["Medieval"] = {
			MaxSpawn = 150,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 80},
				[2] = {Chance = 24, Multiplier = 160},
				[3] = {Chance = 15, Multiplier = 240},
				[4] = {Chance = 10, Multiplier = 35, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 320000},
			}
		},
		["Volcanic"] = {
			MaxSpawn = 125,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 90},
				[2] = {Chance = 24, Multiplier = 180},
				[3] = {Chance = 15, Multiplier = 270},
				[4] = {Chance = 10, Multiplier = 41, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 360000},
			}
		},
		["Farm"] = {
			MaxSpawn = 125,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 110},
				[2] = {Chance = 24, Multiplier = 200},
				[3] = {Chance = 15, Multiplier = 300},
				[4] = {Chance = 10, Multiplier = 45, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 400000},
			}
		},
		["Glacier"] = {
			MaxSpawn = 155,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 130},
				[2] = {Chance = 24, Multiplier = 240},
				[3] = {Chance = 15, Multiplier = 350},
				[4] = {Chance = 10, Multiplier = 49, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 440000},
			}
		},
		["Sinister Valley"] = {
			MaxSpawn = 125,
			Stars = {
				[1] = {Chance = 50.99, Multiplier = 1},
				[2] = {Chance = 24, Multiplier = 2},
				[3] = {Chance = 15, Multiplier = 4},
				[4] = {Chance = 10, Multiplier = 10, Type = "Gem"},
				[5] = {Chance = 0.01, Multiplier = 1000},
			}
		},
		--["Summer"] = {
		--	MaxSpawn = 125,
		--	Stars = {
		--		[1] = {Chance = 76.99, Multiplier = 80},
		--		[2] = {Chance = 15, Multiplier = 160},
		--		[3] = {Chance = 5, Multiplier = 240},
		--		[4] = {Chance = 3, Multiplier = 35, Type = "Gem"},
		--		[5] = {Chance = 0.01, Multiplier = 320000},
		--	}
		--},
	},
	
	["Config"] = {
		MaxCombo = 3,
	}
}

return module
