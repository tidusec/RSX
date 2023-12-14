	return {
	[1] = {
		Max = 100,
		Boost = "x%s > x%s",
		Title = "Get More Stars",
		Prices = function(UpgradeVal) 
			return {Price = math.round(1.25^(UpgradeVal) * 25), Reward = 1.1^(UpgradeVal)}
		end,
	},
	[2] = {
		Max = 10,
		Boost = "x%s > x%s",
		Title = "More Pet Luck",
		Prices = function(UpgradeVal) 
			return {Price = 100 ^ UpgradeVal * 1000, Reward = UpgradeVal * 0.25 + 1}
		end,
	},
	[3] = {
		Max = 100,
		Boost = "x%s > x%s",
		Title = "Get More Gems",
		Prices = function(UpgradeVal) 
			return {Price = math.round(1.3^(UpgradeVal) * 40), Reward = 1.1^(UpgradeVal)}
		end,
	},
	[4] = {
		Max = "Unlockable",
		Boost = "%s > %s",
		Title = "Extra pet equip",
		Price = 50000, 
		Reward = 1
	},
	[5] = {
		Max = 12,
		Boost = "x%s > x%s",
		Title = "Hatch Speed",
		Prices = function(UpgradeVal) 
			return {Price = math.round((UpgradeVal+1) * 150), Reward = 0.05 * (UpgradeVal) + 1}
		end,
	},
	[6] = {
		Max = 40,
		Boost = "+%s > +%s",
		Title = "Walkspeed",
		Prices = function(UpgradeVal) 
			return {Price = math.round(1.25^(UpgradeVal) * 10), Reward = UpgradeVal}
		end,
	},
	[7] = {
		Max = 75,
		Boost = "+%s > +%s",
		Title = "Max Combo",
		Prices = function(UpgradeVal)
			return {Price = math.round(1.1^(UpgradeVal) * 250), Reward = 0.1 * UpgradeVal}
		end,
	},
	[8] = {
		Max = "Unlockable",
		Boost = "%s > %s",
		Title = "Auto Craft",
		Price = 5e5, 
		Reward = 1,
	},
}