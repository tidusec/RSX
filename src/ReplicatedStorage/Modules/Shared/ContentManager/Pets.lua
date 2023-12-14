--// Pet Info

local Pets = {
	-- special pets (not obtainable here)
	["Multiple parts pet"] = {Rarity = "Special", Multiplier = 1},
	["Cooler"] = {Rarity = "Special", Multiplier = 69},
	["Coolier"] = {Rarity = "Special", Multiplier = 69},
	["NewStyle"] = {Rarity = "Special", Multiplier = 69},
	["NewStyleGold"] = {Rarity = "Special", Multiplier = 69},
	["NewStyleWhiteandBlack"] = {Rarity = "Special", Multiplier = 69},

	["Mr Pennybags"] = {Rarity = "Robux", Multiplier = 10000},

	["Yin Yang"] = {Rarity = "Robux", Multiplier = 80000},
	["Frost Monster"] = {Rarity = "Robux", Multiplier = 200000},
	["Galactus"] = {Rarity = "Robux", Multiplier = 1e6},

	["Mystical Gem"] = {Rarity = "Robux", Multiplier = 2.5e7},
	["Golden Overlord"] = {Rarity = "Robux", Multiplier = 1e8},

	["Spin Master"] = {Rarity = "Legendary", Multiplier = 300},

	["Golden Dog"] = {Rarity = "Robux", Multiplier = 5000000},
	["Golden King Dragon"] = {Rarity = "Robux", Multiplier = 20000000},
	["Golden Gem"] = {Rarity = "Robux", Multiplier = 250000000},
	["Shiny Star"] = {Rarity = "Robux", Multiplier = 7.5e8},


	["Dog"] = {Rarity = "Common", Multiplier = 1.1},
	["Cat"] = {Rarity = "Uncommon", Multiplier = 1.3},
	["Bunny"] = {Rarity = "Rare", Multiplier = 1.8},
	["Duck"] = {Rarity = "Rare", Multiplier = 2.2},
	["Chicken"] = {Rarity = "Rare", Multiplier = 2.2},
	["King Dog"] = {Rarity = "Secret", Multiplier = 500000, Image = "https://cdn.discordapp.com/attachments/955361035836063745/1094229180046131211/royal_dog.png"},
	["King Cat"] = {Rarity = "Secret", Multiplier = 1000000, Image = "https://cdn.discordapp.com/attachments/884209200115372073/1114571716103000205/royal_cat.png"},

	["Pig"] = {Rarity = "Common", Multiplier = 3.5},
	["Spider"] = {Rarity = "Uncommon", Multiplier = 4.8},
	["Dragon"] = {Rarity = "Rare", Multiplier = 7.5},

	["Deer"] = {Rarity = "Common", Multiplier = 15},
	["Bear"] = {Rarity = "Uncommon", Multiplier = 24},
	["Bull"] = {Rarity = "Rare", Multiplier = 35},
	["Squirrel"] = {Rarity = "Epic", Multiplier = 60},
	["Forest Dragon"] = {Rarity = "Legendary", Multiplier = 250},

	["Frozen Bunny"] = {Rarity = "Common", Multiplier = 150},
	["Polar Bear"] = {Rarity = "Uncommon", Multiplier = 275},
	["Penguin"] = {Rarity = "Rare", Multiplier = 450},
	["Snowman"] = {Rarity = "Epic", Multiplier = 650},
	["Snow Dragon"] = {Rarity = "Legendary", Multiplier = 1500},

	["Frozen Unicorn"] = {Rarity = "Robux", Multiplier = 75000},

	["Builder Dog"] = {Rarity = "Common", Multiplier = 1250},
	["Builder Cat"] = {Rarity = "Uncommon", Multiplier = 1800},
	["Builder Bunny"] = {Rarity = "Rare", Multiplier = 2800},
	["Gem Master"] = {Rarity = "Epic", Multiplier = 4200},
	["Gem Reaper"] = {Rarity = "Legendary", Multiplier = 8500},

	["Aqua Dog"] = {Rarity = "Common", Multiplier = 4500},
	["Aqua Cat"] = {Rarity = "Uncommon", Multiplier = 6500},
	["Shark"] = {Rarity = "Rare", Multiplier = 8900},
	["Jellyfish"] = {Rarity = "Epic", Multiplier = 12000},
	["Aqua Dragon"] = {Rarity = "Legendary", Multiplier = 50000},
	["Aqua Butterfly"] = {Rarity = "Legendary", Multiplier = 225000},

	["Steampunk Dog"] = {Rarity = "Common", Multiplier = 27000},
	["Steampunk Cat"] = {Rarity = "Uncommon", Multiplier = 42000},
	["Steampunk Robot"] = {Rarity = "Rare", Multiplier = 55000},
	["Steampunk Dragon"] = {Rarity = "Epic", Multiplier = 75000},
	["Steampunk Worker"] = {Rarity = "Legendary", Multiplier = 310000},
	["Steampunk Lord"] = {Rarity = "Legendary", Multiplier = 2.5e6},
	["Steampunk Clock"] = {Rarity = "Secret", Multiplier = 1.25e7, Image = "https://cdn.discordapp.com/attachments/955361035836063745/1095027758112964769/secretclock.png"},

	["Ninja Dog"] = {Rarity = "Common", Multiplier = 82500},
	["Ninja Cat"] = {Rarity = "Uncommon", Multiplier = 126000},
	["Panda"] = {Rarity = "Rare", Multiplier = 165500},
	["Sensei"] = {Rarity = "Epic", Multiplier = 225000},
	["Ninja Master"] = {Rarity = "Legendary", Multiplier = 1e6},
	["Sakura Dragon"] = {Rarity = "Legendary", Multiplier = 8e6},
	["Bowl Of Noodles"] = {Rarity = "Secret", Multiplier = 5.5e7, Image = "https://cdn.discordapp.com/attachments/987451249022599218/1104429714438881433/secretsakura.png"},

	["Candy Dog"] = {Rarity = "Common", Multiplier = 176000},
	["Candy Cat"] = {Rarity = "Uncommon", Multiplier = 275000},
	["Lolipop"] = {Rarity = "Rare", Multiplier = 358000},
	["Ice Cream Sandwich"] = {Rarity = "Epic", Multiplier = 473000},
	["Chocolate Bar"] = {Rarity = "Legendary", Multiplier = 1.76e6},
	["Chocolate Demon"] = {Rarity = "Legendary", Multiplier = 1.375e7},
	["Ice Cream Sundae"] = {Rarity = "Secret", Multiplier = 1.1e8, Image = "https://cdn.discordapp.com/attachments/955361035836063745/1114480513684615228/full.png"},

	["Toxic Dog"] = {Rarity = "Common", Multiplier = 330000},
	["Toxic Cat"] = {Rarity = "Uncommon", Multiplier = 512000},
	["Toxic Spider"] = {Rarity = "Rare", Multiplier = 675000},
	["Toxic Bat"] = {Rarity = "Epic", Multiplier = 900000},
	["Toxic Fairy"] = {Rarity = "Legendary", Multiplier = 3.5e6},
	["Toxic Demon"] = {Rarity = "Legendary", Multiplier = 2.55e7},
	["Radioactive Barrel"] = {Rarity = "Secret", Multiplier = 2e8, Image = "https://cdn.discordapp.com/attachments/884209200115372073/1119352448386089092/1.png"},

	["Medieval Dog"] = {Rarity = "Common", Multiplier = 740000},
	["Medieval Cat"] = {Rarity = "Uncommon", Multiplier = 1150000},
	["Medieval Dragon"] = {Rarity = "Rare", Multiplier = 1640000},
	["Royal Knight"] = {Rarity = "Epic", Multiplier = 2150000},
	["Dark Knight"] = {Rarity = "Legendary", Multiplier = 7.875e6},
	["Medieval Spirit"] = {Rarity = "Legendary", Multiplier = 5.75e7},
	["Medieval Emperor"] = {Rarity = "Secret", Multiplier = 5.25e8, Image = "https://cdn.discordapp.com/attachments/987451249022599218/1129797747239833691/medieval_egg.png"},

	--// Event/Special pets
	["1M Dog"] = {Rarity = "Common", Multiplier = 18},
	["1M Cat"] = {Rarity = "Rare", Multiplier = 32},
	["1M Pig"] = {Rarity = "Epic", Multiplier = 63},
	["1M Dragon"] = {Rarity = "Legendary", Multiplier = 325},

	["1M Bunny"] = {Rarity = "Common", Multiplier = 124000},
	["1M Spider"] = {Rarity = "Uncommon", Multiplier = 190000},
	["1M Prince"] = {Rarity = "Rare", Multiplier = 250000},
	["1M Bat"] = {Rarity = "Epic", Multiplier = 330000},
	["1M Terror"] = {Rarity = "Legendary", Multiplier = 1.25e6},
	["1M Fairy"] = {Rarity = "Legendary", Multiplier = 1e7},
	["1M Mythical Jewl"] = {Rarity = "Secret", Multiplier = 8e7, Image = "https://cdn.discordapp.com/attachments/987451249022599218/1109533001030828163/lucadabest.png"},

	["Summer Cat"] = {Rarity = "Common", Multiplier = 495000}, -- 1.5x toxic
	["Summer Dog"] = {Rarity = "Uncommon", Multiplier = 768000},
	["Sand Castle"] = {Rarity = "Rare", Multiplier = 1012500},
	["Flying Sand Castle"] = {Rarity = "Epic", Multiplier = 1350000},
	["Water Overlord"] = {Rarity = "Legendary", Multiplier = 5.25e6},
	["Sun Fury"] = {Rarity = "Legendary", Multiplier = 3.825e7},
	["Sun Implosion"] = {Rarity = "Secret", Multiplier = 3.25e8, Image = "https://cdn.discordapp.com/attachments/884209200115372073/1124073035666817064/summer_secret.png"},

	["Shadowed Master"] = {Rarity = "Special", Multiplier = 5e7},
	["Elemental Phoenix"] = {Rarity = "Special", Multiplier = 2.5e8},

	["2m Dog"] = {Rarity = "Common", Multiplier = 54},
	["2m Cat"] = {Rarity = "Rare", Multiplier = 96},
	["2m Pig"] = {Rarity = "Epic", Multiplier = 189},
	["2m Dragon"] = {Rarity = "Legendary", Multiplier = 975},

	["2m Bunny"] = {Rarity = "Common", Multiplier = 2220000},
	["2m Spider"] = {Rarity = "Uncommon", Multiplier = 3450000},
	["2m Goblin"] = {Rarity = "Rare", Multiplier = 4920000},
	["2m Magic Dragon"] = {Rarity = "Epic", Multiplier = 6450000},
	["2m Mysterious Raider"] = {Rarity = "Legendary", Multiplier = 23625000},
	["2m Enchanted Overlord"] = {Rarity = "Legendary", Multiplier = 172500000},
	["2m Enchanted Mythical Gem"] = {Rarity = "Secret", Multiplier = 2500000000, Image = "https://cdn.discordapp.com/attachments/1134106407050948730/1134128780944867409/2m_secret.png"},

	["Beach Ball Dog"] = {Rarity = "Common", Multiplier = 3300000},
	["Beach Ball Cat"] = {Rarity = "Uncommon", Multiplier = 5170000},
	["Beach Ball Bunny"] = {Rarity = "Rare", Multiplier = 7420000},
	["Beach Ball Bull"] = {Rarity = "Epic", Multiplier = 9700000},
	["Beach Ball Dragon"] = {Rarity = "Legendary", Multiplier = 35200000},
	["Beach Ball Demon"] = {Rarity = "Legendary", Multiplier = 258700000},
	["Beach Ball Gem"] = {Rarity = "Secret", Multiplier = 3750000000, Image = "https://media.discordapp.net/attachments/1102050939772342402/1139967601288695920/beach_ball_egg_secret_1.png"},
	["Beach Ball Reaper"] = {Rarity = "Secret", Multiplier = 18750000000, Image = "https://cdn.discordapp.com/attachments/1102050939772342402/1139967585648115843/beach_ball_egg_secret_2.png"},

	["Volcanic Dog"] = {Rarity = "Common", Multiplier = 4200000},
	["Volcanic Cat"] = {Rarity = "Uncommon", Multiplier = 6720000},
	["Volcanic Bunny"] = {Rarity = "Rare", Multiplier = 8900000},
	["Volcanic Chicken"] = {Rarity = "Epic", Multiplier = 12600000},
	["Basalt Bat"] = {Rarity = "Legendary", Multiplier = 45700000},
	["Basalt Demon"] = {Rarity = "Legendary", Multiplier = 335400000},
	["Magma Spirit"] = {Rarity = "Secret", Multiplier = 4850000000, Image = "https://cdn.discordapp.com/attachments/141280589476003890/1144792767260794951/secret_1_volcanic.png"},
	["Painite Spirit"] = {Rarity = "Secret", Multiplier = 8850000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1144792767952867348/secret_2_volcanic.png"},
	["Volcanic Eruption"] = {Rarity = "Secret", Multiplier = 24370000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1144792766635855872/secret_3_volcanic.png"},
	
	["Farmer Dog"] = {Rarity = "Common", Multiplier = 12000000},
	["Farmer Cat"] = {Rarity = "Uncommon", Multiplier = 18520000},
	["Farmer Pig"] = {Rarity = "Rare", Multiplier = 27000000},
	["Farmer Cow"] = {Rarity = "Epic", Multiplier = 35000000},
	["Farmer Dragon"] = {Rarity = "Legendary", Multiplier = 150000000},
	["Wheat Overlord"] = {Rarity = "Legendary", Multiplier = 1200000000},
	["Bejeweled Farmer"] = {Rarity = "Secret", Multiplier = 20000000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1150010508167090196/farm_secret_1.png"},
	["Farm Explosion"] = {Rarity = "Secret", Multiplier = 100000000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1150010507529568266/farm_secret_2.png"},
	
	["Ice Dog"] = {Rarity = "Common", Multiplier = 33000000},
	["Ice Cat"] = {Rarity = "Uncommon", Multiplier = 56000000},
	["Ice Bunny"] = {Rarity = "Rare", Multiplier = 87000000},
	["Ice Spider"] = {Rarity = "Epic", Multiplier = 115000000},
	["Ice Dragon"] = {Rarity = "Legendary", Multiplier = 450000000},
	["Ice Legend"] = {Rarity = "Legendary", Multiplier = 3600000000},
	["Ice Storm"] = {Rarity = "Secret", Multiplier = 60000000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1155079933564043264/glacier_secret_1.png?ex=6513fc04&is=6512aa84&hm=6ced89de595cc2f8dc3c07fa2996132fde5d7938ec15704406eda55f3ec77dd2&"},
	["Ice Blizzard"] = {Rarity = "Secret", Multiplier = 300000000000, Image = "https://cdn.discordapp.com/attachments/1141280589476003890/1155079933060714566/glacier_secret_2.png?ex=6513fc04&is=6512aa84&hm=d66b0d7cc424404208c70c801de9c6b8af9a8b5d6c5a276602b002ea1412a3d1&"},
	
	["2.5M Bunny"] = {Rarity = "Common", Multiplier = 60000000},
	["2.5M Prince"] = {Rarity = "Uncommon", Multiplier = 100000000},
	["2.5M Spider"] = {Rarity = "Rare", Multiplier = 180000000},
	["2.5M Bat"] = {Rarity = "Epic", Multiplier = 230000000},
	["2.5M Terror"] = {Rarity = "Legendary", Multiplier = 900000000},
	["2.5M Demon"] = {Rarity = "Legendary", Multiplier = 7000000000},
	["2.5M Gem"] = {Rarity = "Secret", Multiplier = 500000000000, Image = "https://media.discordapp.net/attachments/1141280589476003890/1162467995839381545/2.5m.png?ex=653c0baf&is=652996af&hm=39c14a4ba1c0d7e8cc6b8fb386242bd8285a2338efce22f30b19c69b58290631&=&width=683&height=683"},

	["2.5M Dog"] = {Rarity = "Common", Multiplier = 62},
	["2.5M Cat"] = {Rarity = "Rare", Multiplier = 126},
	["2.5M Pig"] = {Rarity = "Epic", Multiplier = 425},
	["2.5M Dragon"] = {Rarity = "Legendary", Multiplier = 1234},
	
	
	["Tropical Dog"] = {Rarity = "Common", Multiplier = 67},
	["Tropical Cat"] = {Rarity = "Rare", Multiplier = 123},
	["Tropical Bunny"] = {Rarity = "Epic", Multiplier = 264},
	
	["Warrior Dog"] = {Rarity = "Special", Multiplier = 1000000},

	-- for me : when next egg comes do 4x toxic
	
	["Cosmic Star"] = {Rarity = "Special", Multiplier = 350000000000},

	["Bronze Prestige Dragon"] = {Rarity = "Special", Multiplier = "???"},
	["Silver Prestige Dragon"] = {Rarity = "Special", Multiplier = "???"},
	["Golden Prestige Dragon"] = {Rarity = "Special", Multiplier = "???"},
	
	-- {Halloween Stuff}
	-- Pumpkin egg
	["Pumpkin Dog"] = {Rarity = "Common", Multiplier = {CandyMultiplier = 1.5, Multiplier = 2}, Type = "CandyCorn"},
	["Pumpkin Cat"] = {Rarity = "Rare", Multiplier = {CandyMultiplier = 2, Multiplier = 5}, Type = "CandyCorn"},
	["Pumpkin Bunny"] = {Rarity = "Epic", Multiplier = {CandyMultiplier = 3, Multiplier = 10}, Type = "CandyCorn"},
	["Pumpkin Dragon"] = {Rarity = "Legendary", Multiplier = {CandyMultiplier = 6, Multiplier = 20}, Type = "CandyCorn"},
	
	--// other
	["Monstrous Star"] = {Rarity = "Special", Multiplier = {CandyMultiplier = 200, Multiplier = 50000000}, Type = "CandyCorn"},
	["Inferno Gem"] = {Rarity = "Special", Multiplier = {CandyMultiplier = 250, Multiplier = 500000000}, Type = "CandyCorn"},
	
	-- Devil egg
	["Ghost"] = {Rarity = "Common",  Multiplier = {CandyMultiplier = 3, Multiplier = 10}, Type = "CandyCorn"},
	["Devil Bat"] = {Rarity = "Rare", Multiplier = {CandyMultiplier = 6, Multiplier = 100}, Type = "CandyCorn"},
	["Devil Overlord"] = {Rarity = "Epic", Multiplier = {CandyMultiplier = 10, Multiplier = 1000}, Type = "CandyCorn"},
	["Devil Aura"] = {Rarity = "Legendary",Multiplier = {CandyMultiplier = 25, Multiplier = 10000}, Type = "CandyCorn"},
	["Graveyard Spirit"] = {Rarity = "Legendary", Multiplier = {CandyMultiplier = 100, Multiplier = 100000}, Type = "CandyCorn"},
	["Ghostly Empowerment"] = {Rarity = "Secret", Multiplier = {CandyMultiplier = 500, Multiplier = 1000000000000}, Type = "CandyCorn",  Image = "https://media.discordapp.net/attachments/1104433753960480818/1162676933700620308/halloween_pet.png?ex=653cce46&is=652a5946&hm=4f3292494eead0ed093fe1b40f8ac94e9b2fd335579329bedd21de7157686b44&=&width=683&height=683"},
	
	["Phantom Dog"] = {Rarity = "Common",  Multiplier = {CandyMultiplier = 6, Multiplier = 50}, Type = "CandyCorn"},
	["Phantom Cat"] = {Rarity = "Rare", Multiplier = {CandyMultiplier = 12, Multiplier = 500}, Type = "CandyCorn"},
	["Phantom Bunny"] = {Rarity = "Epic", Multiplier = {CandyMultiplier = 20, Multiplier = 5000}, Type = "CandyCorn"},
	["Phantom Dragon"] = {Rarity = "Legendary",Multiplier = {CandyMultiplier = 50, Multiplier = 50000}, Type = "CandyCorn"},
	["Phantom Demon"] = {Rarity = "Legendary", Multiplier = {CandyMultiplier = 200, Multiplier = 500000}, Type = "CandyCorn"},
	["Phantom Spirit"] = {Rarity = "Secret", Multiplier = {CandyMultiplier = 1000, Multiplier = 1000000000000}, Type = "CandyCorn",  Image = "https://cdn.discordapp.com/attachments/884209200115372073/1169982513985372230/hall1.png?ex=65576220&is=6544ed20&hm=0cbe26539d99b2eddec0aa4b4e11ef920b80a8cc94147391bc77940ddf9ef79d&"},
	["Phantom Overlord"] = {Rarity = "Secret", Multiplier = {CandyMultiplier = 2500, Multiplier = 5000000000000}, Type = "CandyCorn",  Image = "https://cdn.discordapp.com/attachments/884209200115372073/1169982512785797220/hall2.png?ex=65576220&is=6544ed20&hm=feb61569f06b26b1146a119dadd09c2abbc908f56ba9b74d97fd5c48c8630234&"},
	
	
	-- 3M pets
	["3M Bunny"] = {Rarity = "Common", Multiplier = 90000000},
	["3M Prince"] = {Rarity = "Uncommon", Multiplier = 150000000},
	["3M Spider"] = {Rarity = "Rare", Multiplier = 270000000},
	["3M Bat"] = {Rarity = "Epic", Multiplier = 310000000},
	["3M Terror"] = {Rarity = "Legendary", Multiplier = 1400000000},
	["3M Legend"] = {Rarity = "Secret", Multiplier = 600000000000, Image = "https://media.discordapp.net/attachments/1141280589476003890/1162467995839381545/2.5m.png?ex=653c0baf&is=652996af&hm=39c14a4ba1c0d7e8cc6b8fb386242bd8285a2338efce22f30b19c69b58290631&=&width=683&height=683"},
	["3M Winged Jewl"] = {Rarity = "Secret", Multiplier = 3000000000000, Image = "https://media.discordapp.net/attachments/1141280589476003890/1162467995839381545/2.5m.png?ex=653c0baf&is=652996af&hm=39c14a4ba1c0d7e8cc6b8fb386242bd8285a2338efce22f30b19c69b58290631&=&width=683&height=683"},

	["3M Dog"] = {Rarity = "Common", Multiplier = 71},
	["3M Cat"] = {Rarity = "Rare", Multiplier = 142},
	["3M Pig"] = {Rarity = "Epic", Multiplier = 500},
	["3M Dragon"] = {Rarity = "Legendary", Multiplier = 1623},

}

return Pets
