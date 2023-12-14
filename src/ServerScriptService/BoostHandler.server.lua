--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Content = require(RS.Modules.Shared.ContentManager)

local Boosts = {"x2Stars","x2Gems","x2Luck"}

local Remotes = RS.Remotes
local RedeemBoost = Remotes.RedeemBoost

--// Boost Redeem

RedeemBoost.OnServerEvent:Connect(function(Player,BoostType)
	if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
		local BoostAvailable = Player.Data:FindFirstChild(BoostType.."Available")
		local Boost = Player.Data:FindFirstChild(BoostType.."Boost")
				
		if BoostAvailable == nil or Boost == nil then return end

		if BoostAvailable.Value >= 1 then
			Player.Data.SeasonQuest9.Value += 1
			BoostAvailable.Value -= 1
			Boost.Value += 1800 + Content.Perks[5].Prices(Player.Data.Perk5.Value).Reward * 60
		end
	end
end)

--// Boost Timer
	
game.Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil
	
	if Player.Parent == nil then return end
	
	while wait(1) do
		for _,BoostType in Boosts do
			local Boost = Player.Data:FindFirstChild(BoostType.."Boost")
			
			if Boost and Boost.Value > 0 then
				Boost.Value -= 1
			end
		end
	end
end)
