return {
	-- Tier 1
	["None"] = {
		["Reward"] = 1;
		["Title"] = "",
		["Animated"] = false,
		["Color"] ={},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 0
	};
	["Fan"] = {
		["Reward"] = 1.25;
		["Title"] = "Fan",
		["Animated"] = false,
		["Color"] ={ Color3.fromRGB(205, 223, 255)},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 3600
	};
	["LoyalFan"] = {
		["Reward"] = 1.25;
		["Title"] = "Loyal Fan",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(171, 203, 255)},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 18000
	};
	["DevotedFan"] = {
		["Reward"] = 1.25;
		["Animated"] = false,
		["Title"] = "Devoted Fan",
		["Color"] = {Color3.fromRGB(151, 184, 255)},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 54000
	};
	["StarRookie"] = {
		["Reward"] = 1.25;
		["Title"] = "Star Rookie",
		["Animated"] = false,
		["Color"] ={ Color3.fromRGB(255, 96, 96)},
		["Stat"] = "StarsCollected",
		["DataType"] = "Number",
		["Requiement"] = 100
	};
	["StarBeginner"] = {
		["Reward"] = 1.25;
		["Title"] = "Star Beginner",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(255, 180, 89)},
		["Stat"] = "StarsCollected",
		["DataType"] = "Number",
		["Requiement"] = 500
	};
	["StarIntermediate"] = {
		["Reward"] = 1.25;
		["Title"] = "Star Intermediate",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(255, 255, 89)},
		["Stat"] = "StarsCollected",
		["DataType"] = "Number",
		["Requiement"] = 1000
	};
	["RookieHatcher"] = {
		["Reward"] = 1.25;
		["Title"] = "Rookie Hatcher",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(210, 255, 250)},
		["Stat"] = "Eggs Opened",
		["DataType"] = "Number",
		["Requiement"] = 100
	};
	["PetLover"] = {
		["Reward"] = 1.25;
		["Title"] = "Pet Lover",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(144, 255, 255)},
		["Stat"] = "Eggs Opened",
		["DataType"] = "Number",
		["Requiement"] = 1000
	};

	-- Tier 2
	["AmazingFan"] = {
		["Reward"] = 1.5;
		["Title"] = "Amazing Fan",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(129, 169, 255)},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 90000
	};
	["DedicatedFan"] = {
		["Reward"] = 1.5;
		["Title"] = "Dedicated Fan",
		["Animated"] = false,
		["Color"] ={ Color3.fromRGB(67, 101, 255)},
		["Stat"] = "Time",
		["DataType"] = "Time",
		["Requiement"] = 180000
	};
	["StarAdvanced"] = {
		["Reward"] = 1.5;
		["Title"] = "Star Advanced",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(197, 255, 90)},
		["Stat"] = "StarsCollected",
		["DataType"] = "Number",
		["Requiement"] = 5000
	};
	["StarExpert"] = {
		["Reward"] = 1.5;
		["Title"] = "Star Expert",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(82, 255, 88)},
		["Stat"] = "StarsCollected",
		["DataType"] = "Number",
		["Requiement"] = 15000
	};
	["PetEnthusiast"] = {
		["Reward"] = 1.5;
		["Title"] = "Pet Enthusiast",
		["Animated"] = false,
		["Color"] = {Color3.fromRGB(103, 118, 255)},
		["Stat"] = "Eggs Opened",
		["DataType"] = "Number",
		["Requiement"] = 5000
	};
	["PetFanatic"] = {
		["Reward"] = 1.5;
		["Title"] = "Pet Fanatic",
		["Animated"] = false,
		["Color"] = { Color3.fromRGB(189, 108, 255)},
		["Stat"] = "Eggs Opened",
		["DataType"] = "Number",
		["Requiement"] = 10000
	};

	-- Tier 3
	["OneInAMillion"] = {
		["Reward"] = 2;
		["Title"] = "One In A Million",
		["Animated"] = true,
		["Color"] = {
			Color3.fromHex("#ff1592"),
			Color3.fromHex("#d52cff"),
			Color3.fromHex("#865dff"),
			Color3.fromHex("#c437ff"),
			Color3.fromHex("#ba2bde"),
			Color3.fromHex("#ff1592")
		};
		["Stat"] = "Secrets Hatched",
		["DataType"] = "Number",
		["Requiement"] = 10
	};

	-- Tier 4
	["HalloweenLover"] = {
		["Reward"] = 2.5;
		["Title"] = "Halloween Lover",
		["Animated"] = true,
		["Color"] = {
			Color3.fromHex("#e9804d"),
			Color3.fromHex("#ffb949"),

		};
		["Stat"] = "HalloweenClaim",
		["DataType"] = "Boolean",
		["Requiement"] = true
	};
	-- Limited
	["Developer"] = {
		["GroupReward"] = true,
		["Reward"] = 1;
		["Title"] = "Developer",
		["GroupRankID"] = 251;
		["Animated"] = true,
		["Color"] = {
			Color3.fromHex("#ff5858"),
			Color3.fromHex("#ffa45a"),
			Color3.fromHex("#67ffc5"),
			Color3.fromHex("#ff975a"),
			Color3.fromHex("#ff5858"),
		};
	};
}