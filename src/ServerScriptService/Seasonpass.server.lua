local Seasonrewards = require(game.ReplicatedStorage.Modules.SeasonPassReward)
local Multipliers = require(game.ReplicatedStorage.Modules.Shared.Multipliers)
local Content = require(game.ReplicatedStorage.Modules.Shared.ContentManager)

local function CreatePet(Player,Pet)
	local NewPet = game.ReplicatedStorage.Pets.PetTemplate:Clone()
	NewPet.PetName.Value = Pet
	NewPet.Multiplier1.Value = Content.Pets[Pet].Multiplier
	NewPet.Parent = Player.Pets
	NewPet.Locked.Value = true
	NewPet.Name = math.random(1,1000000000)

	Player.Data.PetsOwned.Value += 1

	game.ReplicatedStorage.Pets.Exist.Server["0 "..Pet].Value += 1

	if not Player.Index:FindFirstChild(Pet) then
		local NewVal = Instance.new("IntValue",Player.Index)
		NewVal.Value = 1
		NewVal.Name = Pet
	else
		Player.Index[Pet].Value += 1
	end
end

function GiveReward(Player, Reward)
	if Reward.Type == "Stars" then
		Player.Data.Stars.Value += Reward.Amount * Multipliers.GetStarMultiplier(Player,3)
	elseif Reward.Type == "Gems" then
		Player.Data.Gems.Value += Reward.Amount * Multipliers.GetGemMultiplier(Player)
	elseif Reward.Type == "Pet" then
		CreatePet(Player, Reward.Amount)
	elseif Reward.Type == "TradeTokens" then
		Player.Data.TradeTokens.Value += Reward.Amount
	elseif Reward.Type == "Boost" then
		Player.Data["x2"..Reward.Amount.."Available"].Value += 1
	end
end

function ClaimReward(Player, Tier)
	local Normal = Seasonrewards.Normal[Tier]
	GiveReward(Player, Normal)
	
	if Player.Data.PremiumPass.Value then
		local Premium = Seasonrewards.Premium[Tier]
		GiveReward(Player, Premium)
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil
	
	if Player.Parent == nil then return end
	
	local function UpdateTier()
		if Player.Data.XP.Value >= (Player.Data.Tier.Value-1) * 50 + 100 and Player.Data.Tier.Value ~= 10 then
			Player.Data.XP.Value -= (Player.Data.Tier.Value-1) * 50 + 100
			Player.Data.Tier.Value += 1
			ClaimReward(Player, Player.Data.Tier.Value)
		end
	end
	
	UpdateTier()
	
	Player.Data.XP.Changed:Connect(function()
		task.wait(0.1)
		UpdateTier()
	end)
end)