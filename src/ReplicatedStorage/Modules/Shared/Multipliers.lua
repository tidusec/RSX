local Multipliers = {}

local RS = game:GetService("ReplicatedStorage")
local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local StarModule = require(Modules.Stars)
local HalloweenUpgrades = require(RS.Modules.Shared.ContentManager.HalloweenUpgrades)



function Multipliers.GetPetMulti(Player, Pet) 

	local Multiplier = Content.Perks[3].Prices(Player.Data.Perk3.Value).Reward
	
	if Content.Enchantments[Pet.Enchantment.Value] and Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
		Multiplier *= Content.Enchantments[Pet.Enchantment.Value].Boost
	end
	
	return Multiplier
end

function Multipliers.GetStarMultiplier(Player, Tier)
	print(Player.PetMulti.Value)
	local Multiplier = (Player.PetMulti.Value + Player.PetMulti3.Value) * Content.Perks[3].Prices(Player.Data.Perk3.Value).Reward
	Multiplier *= Content.Upgrades[1].Prices(Player.Data.Upgrade1.Value).Reward
	Multiplier *= require(game.ReplicatedStorage.Modules.Worlds)[Player.World.Value].WorldBoost
	if Tier then
		Multiplier *= StarModule.Spawns[Player.World.Value].Stars[Tier].Multiplier
	else
		Multiplier *= StarModule.Spawns[Player.World.Value].Stars[1].Multiplier
	end
	Multiplier *= Content.Title[Player.Data.Nametag.Value].Reward
	Multiplier *= Content.Ranks[Player.Data.Rank.Value].Boost * Content.Perks[4].Prices(Player.Data.Perk4.Value).Reward
	Multiplier *= Player.FriendBoost.Value
	Multiplier *= Content.Achievements[1].Reward[Player.Data.Achievement1.Value]
	if Player.Data.Achievement5.Value > #Content.Achievements[5].Reward then
		Multiplier *= Content.Achievements[5].Reward[#Content.Achievements[5].Reward]
	else	
		Multiplier *= Content.Achievements[5].Reward[Player.Data.Achievement5.Value]
	end
	Multiplier *= Content.Perks[1].Prices(Player.Data.Perk1.Value).Reward
	Multiplier *= RS.StarEvent.Value
	Multiplier *= HalloweenUpgrades["Upgrades"]["StarUpgrade"].Prices(Player.Data.HalloweenStarUpgrade.Value).Reward
	
	if Player.MembershipType == Enum.MembershipType.Premium then Multiplier *= 1.25 end
	if Player.Data["x2StarsBoost"].Value > 0 then Multiplier *= 2 end
	if Player.Data["x2Stars"].Value then Multiplier *= 2 end
	if Player.Data.DiscordReward.Value == true then Multiplier *= 1.35 end
	
	return Multiplier
end

function Multipliers.GetGemMultiplier(Player)
	local Boost = Content.Perks[2].Prices(Player.Data.Perk2.Value).Reward
	Boost *= Player.Data["x2GemsBoost"].Value > 2 and 2 or 1
	Boost *= Player.Data["x2Gems"].Value and 2 or 1
	Boost *= Content.Upgrades[3].Prices(Player.Data.Upgrade3.Value).Reward
	Boost *= Content.Achievements[6].Reward[Player.Data.Achievement6.Value]
	Boost *= Player.PetMulti2.Value
	Boost *= Content.Title[Player.Data.Nametag.Value].Reward
	Boost *= HalloweenUpgrades["Upgrades"]["GemUpgrade"].Prices(Player.Data.HalloweenGemUpgrade.Value).Reward
	return Boost
end

function Multipliers.GetHatchSpeed(Player)
	local HatchSpeed = require(RS.Pets.Configure).HatchSpeed
	HatchSpeed /= Player.Data.FastHatch.Value and 1.5 or 1
	HatchSpeed /= Content.Upgrades[5].Prices(Player.Data.Upgrade5.Value).Reward
	
	return math.max(HatchSpeed, 0.25) -- max 0.25 hatch speed
end

function Multipliers.GetLuckBoost(Player)
	local LuckBoost = RS.LuckEvent.Value
	LuckBoost *= Player.Data.Upgrade2.Value == 1 and Content.Upgrades[2].Reward or 1
	LuckBoost *= Player.Data.x2LuckBoost.Value >= 1 and 2 or 1
	LuckBoost *= Player.Data.SuperLuck.Value and 2 or 1
	LuckBoost *= Player.World.Value == RS.EventMultipliers.World.Value and RS.EventMultipliers.LuckBoost.Value or 1
	LuckBoost *= Player.EggCombo.Value
	LuckBoost *= HalloweenUpgrades["Upgrades"]["LuckUpgrade"].Prices(Player.Data.HalloweenLuckUpgrade.Value).Reward
	LuckBoost *= Content.Perks[10].Prices(Player.Data.Perk10.Value).Reward
	if Player.Data.DiscordReward.Value == true then LuckBoost *= 1.25 end
	return LuckBoost
end

function Multipliers.GetSecretLuckBoost(Player)
	local SecretLuckBoost = RS.LuckEvent.Value
	SecretLuckBoost *= Player.Data.x2SecretChance.Value and 2 or 1
	SecretLuckBoost *= Content.Perks[7].Prices(Player.Data.Perk7.Value).Reward
	SecretLuckBoost *= Content.Achievements[4].Reward[Player.Data.Achievement4.Value]
	
	return SecretLuckBoost
end

function Multipliers.GetMaxPetsEquipped(Player)
	local MaxEquips = 4
	MaxEquips += Content.Perks[6].Prices(Player.Data.Perk6.Value).Reward
	MaxEquips += Player.Data.IndexEquips.Value
	MaxEquips += Player.Data["+2PetsEquipped"].Value and 2 or 0
	MaxEquips += Player.Data["+3PetsEquipped"].Value and 3 or 0
	MaxEquips += Player.Data.Upgrade4.Value >= 1 and Player.Data.Upgrade4.Value or 0
	
	return MaxEquips
end

function Multipliers.GetMaxPetStorage(Player)
	local MaxStorage = Player.Data.MaxStorage.Value
	MaxStorage += Content.Achievements[3].Reward[Player.Data.Achievement3.Value] 
	MaxStorage += Content.Perks[8].Prices(Player.Data.Perk8.Value).Reward
	
	return MaxStorage
end

function Multipliers.GetMaxWalkspeed(Player)
	local Walkspeed = 20
	Walkspeed += Content.Achievements[2].Reward[Player.Data.Achievement2.Value]
	Walkspeed += Player.Data.Upgrade6.Value
	
	return Walkspeed
end

function Multipliers.GetMaxCombo(Player)	
	local Combo = StarModule.Config.MaxCombo
	Combo += Content.Upgrades[7].Prices(Player.Data.Upgrade7.Value).Reward
	
	return Combo
end

function Multipliers.GetMaxLuckCombo(Player)
	local Combo = 2
	Combo += Content.Perks[11].Prices(Player.Data.Perk11.Value).Reward

	return Combo
end

function Multipliers.GetCandyCornMultiplier(Player,Tier)
	local Boost = Content.Perks[13].Prices(Player.Data.Perk13.Value).Reward
	Boost *= Player.PetMulti4.Value + Player.PetMulti3.Value
	if Tier then
		Boost *= StarModule.Spawns[Player.World.Value].Stars[Tier].Multiplier
	else
		Boost *= StarModule.Spawns[Player.World.Value].Stars[1].Multiplier
	end
	if Player.Data.x2Candy.Value then Boost *= 2 end
	return Boost
end
return Multipliers
