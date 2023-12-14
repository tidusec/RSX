--// All the egg information

local Eggs = {
	["Basic"] = {
		Cost = 100,
		Order = 1,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Dog", Type = 1, Rarity = 45, Secret = false},
			[2] = {Name = "Cat", Type = 1, Rarity = 27, Secret = false},
			[3] = {Name = "Bunny", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Chicken", Type = 1, Rarity = 12, Secret = false},
			--[5] = {Name = "King Dog", Type = 1, Rarity = 1000, Secret = true}, -- its limited
			--[6] = {Name = "Multiple parts pet", Type = 1, Rarity = 1000, Secret = false}
		}
	},

	["Rare"] = {
		Cost = 5000,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Pig", Type = 1, Rarity = 55, Secret = false},
			[2] = {Name = "Spider", Type = 1, Rarity = 27, Secret = false},
			[3] = {Name = "Dragon", Type = 1, Rarity = 18, Secret = false},
		}
	},

	["Robux"] = {
		Cost = 149,
		Order = 500,
		World = "Spawn",
		Currency = "R$",
		ProductID = 1378818478 ,
		Pets = {
			[1] = {Name = "Mr Pennybags", Type = 1, Rarity = 100, Secret = false}
		}
	},

	["Forest"] = {
		Cost = 250000,
		Order = 3,
		World = "Forest",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Deer", Type = 1, Rarity = 43, Secret = false},
			[2] = {Name = "Bear", Type = 1, Rarity = 31, Secret = false},
			[3] = {Name = "Bull", Type = 1, Rarity = 17, Secret = false},
			[4] = {Name = "Squirrel", Type = 1, Rarity = 8, Secret = false},
			[5] = {Name = "Forest Dragon", Type = 1, Rarity = 1, Secret = false},
		}
	},

	["Frost"] = {
		Cost = 5e8,
		Order = 4,
		World = "Frosty",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Frozen Bunny", Type = 1, Rarity = 51, Secret = false},
			[2] = {Name = "Polar Bear", Type = 1, Rarity = 28, Secret = false},
			[3] = {Name = "Penguin", Type = 1, Rarity = 15, Secret = false},
			[4] = {Name = "Snowman", Type = 1, Rarity = 5.5, Secret = false},
			[5] = {Name = "Snow Dragon", Type = 1, Rarity = 0.5, Secret = false},
		}
	},

	["Ice"] = {
		Cost = 199,
		Order = 500,
		World = "Spawn",
		Currency = "R$",
		ProductID = 1544514853 ,
		Pets = {
			[1] = {Name = "Frozen Unicorn", Type = 1, Rarity = 100, Secret = false}
		}
	},

	["Mine"] = {
		Cost = 1e12,
		Order = 5,
		World = "Mine",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Builder Dog", Type = 1, Rarity = 54, Secret = false},
			[2] = {Name = "Builder Cat", Type = 1, Rarity = 26, Secret = false},
			[3] = {Name = "Builder Bunny", Type = 1, Rarity = 14, Secret = false},
			[4] = {Name = "Gem Master", Type = 1, Rarity = 5.5, Secret = false},
			[5] = {Name = "Gem Reaper", Type = 1, Rarity = 0.5, Secret = false},
		}
	},

	["Aqua"] = {
		Cost = 2.5e14,
		Order = 6,
		World = "Aqua",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Aqua Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Aqua Cat", Type = 1, Rarity = 25, Secret = false},
			[3] = {Name = "Shark", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Jellyfish", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Aqua Dragon", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Aqua Butterfly", Type = 1, Rarity = 0.01, Secret = false},
		}
	},

	["Gear"] = {
		Cost = 5e17,
		Order = 7,
		World = "Steampunk",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Steampunk Dog", Type = 1, Rarity = 48, Secret = false},
			[2] = {Name = "Steampunk Cat", Type = 1, Rarity = 28, Secret = false},
			[3] = {Name = "Steampunk Robot", Type = 1, Rarity = 17, Secret = false},
			[4] = {Name = "Steampunk Dragon", Type = 1, Rarity = 6.75, Secret = false},
			[5] = {Name = "Steampunk Worker", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Steampunk Lord", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Steampunk Clock", Type = 1, Rarity = 0.0005, Secret = true},
		}
	},

	["Sakura"] = { -- if this is here the convert didnt work
		Cost = 5e20,
		World = "Sakura",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Ninja Dog", Type = 1, Rarity = 48, Secret = false},
			[2] = {Name = "Ninja Cat", Type = 1, Rarity = 28, Secret = false},
			[3] = {Name = "Panda", Type = 1, Rarity = 17, Secret = false},
			[4] = {Name = "Sensei", Type = 1, Rarity = 6.75, Secret = false},
			[5] = {Name = "Ninja Master", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Sakura Dragon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Bowl Of Noodles", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},

	["Candy"] = {
		Cost = 1e23,
		World = "Candy",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Candy Dog", Type = 1, Rarity = 50, Secret = false},
			[2] = {Name = "Candy Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Lolipop", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Ice Cream Sandwich", Type = 1, Rarity = 4.8, Secret = false},
			[5] = {Name = "Chocolate Bar", Type = 1, Rarity = 0.2, Secret = false},
			[6] = {Name = "Chocolate Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Ice Cream Sundae", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},

	["Toxic"] = {
		Cost = 1e24,
		World = "Toxic",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Toxic Dog", Type = 1, Rarity = 49, Secret = false},
			[2] = {Name = "Toxic Cat", Type = 1, Rarity = 31, Secret = false},
			[3] = {Name = "Toxic Spider", Type = 1, Rarity = 15, Secret = false},
			[4] = {Name = "Toxic Bat", Type = 1, Rarity = 4.8, Secret = false},
			[5] = {Name = "Toxic Fairy", Type = 1, Rarity = 0.2, Secret = false},
			[6] = {Name = "Toxic Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Radioactive Barrel", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},

	["Medieval"] = {
		Cost = 1e25,
		World = "Medieval",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Medieval Dog", Type = 1, Rarity = 49, Secret = false},
			[2] = {Name = "Medieval Cat", Type = 1, Rarity = 31, Secret = false},
			[3] = {Name = "Medieval Dragon", Type = 1, Rarity = 15, Secret = false},
			[4] = {Name = "Royal Knight", Type = 1, Rarity = 4.8, Secret = false},
			[5] = {Name = "Dark Knight", Type = 1, Rarity = 0.2, Secret = false},
			[6] = {Name = "Medieval Spirit", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Medieval Emperor", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},
	
	["Volcano"] = {
		Cost = 1e27, 
		World = "Volcanic",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Volcanic Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Volcanic Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Volcanicl Bunny", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Volcanic Chicken", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Basalt Bat", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Basalt Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Magma Spirit", Type = 1, Rarity = 0.0002, Secret = true},
			[8] = {Name = "Painite Spirit", Type = 1, Rarity = 0.0002, Secret = true},
			[9] = {Name = "Volcanic Eruption", Type = 1, Rarity = 0.00001, Secret = true},
		}
	},

	--// Event

	["Starter 1M"] = {
		Cost = 25000,
		Order = 9,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "1M Dog", Type = 1, Rarity = 52, Secret = false},
			[2] = {Name = "1M Cat", Type = 1, Rarity = 36, Secret = false},
			[3] = {Name = "1M Pig", Type = 1, Rarity = 11, Secret = false},
			[4] = {Name = "1M Dragon", Type = 1, Rarity = 1, Secret = false},
		}
	},


	["Pro 1M"] = {
		Cost = 2.5e20, 
		Order = 10,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "1M Bunny", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "1M Spider", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "1M Prince", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "1M Bat", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "1M Terror", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "1M Fairy", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "1M Mythical Jewl", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},

	["Summer"] = {
		Cost = 2.5e23, 
		Order = 11,
		World = "Summer",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Summer Cat", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Summer Dog", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Sand Castle", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Flying Sand Castle", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Water Overlord", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Sun Fury", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Sun Implosion", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},
	
	["Starter 2m"] = {
		Cost = 100000, 
		Order = 12,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "2m Dog", Type = 1, Rarity = 52, Secret = false},
			[2] = {Name = "2m Cat", Type = 1, Rarity = 36, Secret = false},
			[3] = {Name = "2m Pig", Type = 1, Rarity = 11, Secret = false},
			[4] = {Name = "2m Dragon", Type = 1, Rarity = 1, Secret = false},
		}
	},
	
	["Pro 2m"] = {
		Cost = 2.5e24, 
		Order = 13,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "2m Bunny", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "2m Spider", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "2m Goblin", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "2m Magic Dragon", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "2m Mysterious Raider", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "2m Enchanted Overlord", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "2m Enchanted Mythical Gem", Type = 1, Rarity = 0.0002, Secret = true},
		}
	},
	
	["Summer1"] = {
		Cost = 150000, 
		Order = 12,
		World = "Summer",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Tropical Dog", Type = 1, Rarity = 54, Secret = false},
			[2] = {Name = "Tropical Cat", Type = 1, Rarity = 36, Secret = false},
			[3] = {Name = "Tropical Bunny", Type = 1, Rarity = 10, Secret = false},
		}
	},

	["Summer2"] = {
		Cost = 1e25, 
		Order = 13,
		World = "Summer",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Beach Ball Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Beach Ball Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Beach Ball Bunny", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Beach Ball Bull", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Beach Ball Dragon", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Beach Ball Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Beach Ball Gem", Type = 1, Rarity = 0.0002, Secret = true},
			[8] = {Name = "Beach Ball Reaper", Type = 1, Rarity = 0.00001, Secret = true},
		}
	},
	["Volcanic"] = {
		Cost = 1e28, 
		Order = 14,
		World = "Volcanic",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Volcanic Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Volcanic Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Volcanic Bunny", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Volcanic Chicken", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Basalt Bat", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Basalt Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Magma Spirit", Type = 1, Rarity = 0.0002, Secret = true},
			[8] = {Name = "Painite Spirit", Type = 1, Rarity = 0.00001, Secret = true},
			[9] = {Name = "Volcanic Eruption", Type = 1, Rarity = 0.000001, Secret = true},
		}
	},
	["Farmer"] = {
		Cost = 1e30, 
		Order = 14,
		World = "Farm",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Farmer Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Farmer Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Farmer Pig", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Farmer Cow", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Farmer Dragon", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Wheat Overlord", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Bejeweled Farmer", Type = 1, Rarity = 0.0002, Secret = true},
			[8] = {Name = "Farm Explosion", Type = 1, Rarity = 0.00001, Secret = true},
		}
	},
	["Glacier"] = {
		Cost = 1e32, 
		Order = 15,
		World = "Glacier",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "Ice Dog", Type = 1, Rarity = 47, Secret = false},
			[2] = {Name = "Ice Cat", Type = 1, Rarity = 29, Secret = false},
			[3] = {Name = "Ice Bunny", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "Ice Spider", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "Ice Dragon", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "Ice Legend", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "Ice Storm", Type = 1, Rarity = 0.0002, Secret = true},
			[8] = {Name = "Ice Blizzard", Type = 1, Rarity = 0.00001, Secret = true},
		}
	},
	
	["Pro 2.5M"] = {
		Cost = 2.5e30, 
		Order = 17,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "2.5M Bunny", Type = 1, Rarity = 47, Secret = false},
			[3] = {Name = "2.5M Prince", Type = 1, Rarity = 29, Secret = false},
			[2] = {Name = "2.5M Spider", Type = 1, Rarity = 16, Secret = false},
			[4] = {Name = "2.5M Bat", Type = 1, Rarity = 7.75, Secret = false},
			[5] = {Name = "2.5M Terror", Type = 1, Rarity = 0.24, Secret = false},
			[6] = {Name = "2.5M Demon", Type = 1, Rarity = 0.01, Secret = false},
			[7] = {Name = "2.5M Gem", Type = 1, Rarity = 0.0002, Secret = true}, 
		}
	},
	
	["Starter 2.5M"] = {
		Cost = 500000, 
		Order = 16,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "2.5M Dog", Type = 1, Rarity = 52, Secret = false},
			[2] = {Name = "2.5M Cat", Type = 1, Rarity = 36, Secret = false},
			[3] = {Name = "2.5M Pig", Type = 1, Rarity = 12, Secret = false},
			[4] = {Name = "2.5M Dragon", Type = 1, Rarity = 1, Secret = false},
		}
	},
	
	["Pro 3M"] = {
		Cost = 2.5e32, 
		Order = 21,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "3M Bunny", Type = 1, Rarity = 47, Secret = false},
			[3] = {Name = "3M Prince", Type = 1, Rarity = 29, Secret = false},
			[2] = {Name = "3M Spider", Type = 1, Rarity = 7.75, Secret = false},
			[4] = {Name = "3M Bat", Type = 1, Rarity = 1, Secret = false},
			[5] = {Name = "3M Terror", Type = 1, Rarity = 0.01, Secret = false},
			[6] = {Name = "3M Legend", Type = 1, Rarity = 0.0002, Secret = true},
			[7] = {Name = "3M Winged Jewl", Type = 1, Rarity = 0.00001, Secret = true}, 
		}
	},

	["Starter 3M"] = {
		Cost = 800000, 
		Order = 20,
		World = "Spawn",
		Currency = "Stars",
		Pets = {
			[1] = {Name = "3M Dog", Type = 1, Rarity = 52, Secret = false},
			[2] = {Name = "3M Cat", Type = 1, Rarity = 36, Secret = false},
			[3] = {Name = "3M Pig", Type = 1, Rarity = 12, Secret = false},
			[4] = {Name = "3M Dragon", Type = 1, Rarity = 1, Secret = false},
		}
	},
}

return Eggs
