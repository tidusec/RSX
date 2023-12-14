return {
	[1] = {
		Color = Color3.fromRGB(255, 255, 105),
		Boost = "x%s Stars",
		Title = "Stars",
		Description = "Get more stars per collect!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(15 + UpgradeVal * 5), Reward = UpgradeVal * 0.25 + 1}
		end,
		Substraction = 5
	},
	[2] = {
		Color = Color3.fromRGB(55, 188, 255),
		Boost = "x%s Gems",
		Title = "Gems",
		Description = "Get more gems (stacks!)",
		Prices = function(UpgradeVal) 
			return {Price = math.round(15 + UpgradeVal * 5), Reward = UpgradeVal * 0.25 + 1}
		end,
		Substraction = 5
	},
	[3] = {
		Color = Color3.fromRGB(255, 55, 55),
		Boost = "x%s Pet Multi",
		Title = "Pet Multi",
		Description = "All pet multipliers are increased!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(15 + UpgradeVal * 5), Reward = (UpgradeVal * 0.25 + 1)}
		end,
		Substraction = 5
	},
	[4] = {
		Color = Color3.fromRGB(255, 104, 44),
		Boost = "x%s Rank Multi",
		Title = "Rank Multi",
		Description = "All rank multipliers are increased!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(20 + UpgradeVal * 5), Reward = UpgradeVal * 0.25 + 1}
		end,
		Substraction = 6
	},
	[5] = {
		Color = Color3.fromRGB(95, 255, 108),
		Boost = "+%s Min Boost Time",
		Title = "Boost Time",
		Description = "All boost durations are increased!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(20 + UpgradeVal * 10), Reward = UpgradeVal * 3}
		end,
		Substraction = 10
	},
	[6] = {
		Color = Color3.fromRGB(255, 126, 103),
		Boost = "+%s Pet Equips",
		Title = "Pet Equips",
		Description = "Equip more pets than before!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(28 + UpgradeVal * 10), Reward = UpgradeVal}
		end,
		Substraction = 9
	},
	[7] = {
		Color = Color3.fromRGB(115, 0, 255),
		Boost = "x%s Secret Luck",
		Title = "Secret Luck",
		Description = "Higher chance to hatch secret pets!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(26 + UpgradeVal * 10), Reward = UpgradeVal * 0.05 + 1}
		end,
		Substraction = 7
	},
	[8] = {
		Color = Color3.fromRGB(255, 190, 124),
		Boost = "+%s Pet Storage",
		Title = "Pet Storage",
		Description = "Get more inventory storage!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(16 + UpgradeVal * 15), Reward = UpgradeVal * 15}
		end,
		Substraction = 10
	},
	[9] = {
		Color = Color3.fromRGB(5, 255, 163),
		Boost = "Skip %s Ranks",
		Title = "Rank Skip",
		Description = "Skip multiple ranks if you have enough!!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(31 + UpgradeVal * 10), Reward = UpgradeVal + 1}
		end,
		Substraction = 15
	},
	[10] = {
		Color = Color3.fromRGB(27, 154, 58),
		Boost = "x%s Luck",
		Title = "Luck",
		Description = "Higher chance to hatch legendary pets!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(20 + UpgradeVal * 6), Reward = UpgradeVal * 0.05 + 1}
		end,
		Substraction = 6
	},
	[11] = {
		Color = Color3.fromRGB(87, 118, 101),
		Boost = "+%s Luck Combo",
		Title = "Luck Combo",
		Description = "Increases max luck combo!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(18 + UpgradeVal * 3), Reward = UpgradeVal * 0.05}
		end,
		Substraction = 3
	},
	[12] = {
		Color = Color3.fromRGB(127, 0, 0),
		Boost = "x%s Secret Star Boost",
		Title = "Secret Star Boost",
		Description = "Increases amount gained from secret stars!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(22 + UpgradeVal * 4), Reward = UpgradeVal * 0.05 + 1}
		end,
		Substraction = 4
	},
	-- Halloween perk for more candycorn
	[13] = {
		Color = Color3.fromRGB(232, 127, 6),
		Boost = "x%s CandyCorn",
		Title = "CandyCorn",
		Description = "Increases amount gained from Candycorn!",
		Prices = function(UpgradeVal) 
			return {Price = math.round(15 + UpgradeVal * 5), Reward = UpgradeVal * 0.25 + 1} -- reward formula is 1 > 1.25 > 1.5 ....
		end,
		Substraction = 7,
		HideFromShop = true -- if this is true it wont shop up in the rotation, but it will still exist
	}
}