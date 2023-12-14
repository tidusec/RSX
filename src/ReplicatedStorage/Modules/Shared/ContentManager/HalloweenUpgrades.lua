return {
	["Prices"] = {
		["Pet"] = 2_000_000,
		["GemBoost"] = 50_000,
		["StarBoost"] = 50_000,
		["LuckBoost"] = 50_000,
	},
	
	["OriginalAmount"] = {
		["Pet"] = 7,
		["GemBoost"] = 5,
		["StarBoost"] = 5,
		["LuckBoost"] = 5,
	},
	
	["Upgrades"] = {
		-- this is the halloween upgrade shop, these cost candy corn
		["StarUpgrade"] = {
			Max = 25,
			Boost = "x%s > x%s",
			Title = "Get More Stars",
			Prices = function(UpgradeVal) 
				return {Price = math.round(1.3^(UpgradeVal) * 25), Reward = 1 + (UpgradeVal/80)}
			end,
		},
		["LuckUpgrade"] = {
			Max = 10,
			Boost = "x%s > x%s",
			Title = "More Pet Luck",
			Prices = function(UpgradeVal) 
				return {Price = 10 ^ UpgradeVal * 100, Reward = UpgradeVal * 0.25 + 1}
			end,
		},
		["GemUpgrade"] = {
			Max = 25,
			Boost = "x%s > x%s",
			Title = "Get More Gems",
			Prices = function(UpgradeVal) 
				return {Price = math.round(1.3^(UpgradeVal) * 40), Reward = 1 + (UpgradeVal/133)}
			end,
		},
	},
}