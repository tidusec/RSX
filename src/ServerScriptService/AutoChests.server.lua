local RS = game:GetService("ReplicatedStorage")
local Content = require(RS.Modules.Shared.ContentManager)
local Multipliers = require(RS.Modules.Shared.Multipliers)
local Worlds = require(RS.Modules.Worlds)

local function ClaimChest(Player, Info)
	for _,Reward in Info.Reward do
		if Reward.Type == "Number" then
			if Reward.Stat == "Gems" then
				Player[Reward.Folder][Reward.Stat].Value += Reward.Amount * Multipliers.GetGemMultiplier(Player)
			elseif Reward.Stat == "Boost" then
				local Boosts = {"x2Stars","x2Gems","x2Luck"}

				local SelectedBoost = Boosts[math.random(1,3)]
				Player.Data[SelectedBoost.."Available"].Value += 1
				RS.Remotes.ClaimChest:FireClient(Player,string.format(Info.Text, SelectedBoost.." Boost"))
				return
			else
				Player[Reward.Folder][Reward.Stat].Value += Reward.Amount
			end
		end
	end
	RS.Remotes.ClaimChest:FireClient(Player,Info.Text)
end

game.Players.PlayerAdded:Connect(function(Player)
	while task.wait(5) do
		if Player.Parent == nil then return end

		if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
			if not Player.Data.AutoCollectChests.Value then return end

			for Chest,Info in Content.Chests do
				local Val = Player.Data:FindFirstChild(Chest.."ChestCooldown")

				if not Val then warn("Chest: "..Chest.." does not have a value") continue end

				if not Info.Requirement then continue end

				if Player.Data.Rank.Value < Worlds[Info.World].Requirement then continue end

				if Val.Value < os.time() then
					Player.Data.SeasonQuest10.Value += 1
					Val.Value = os.time() + Info.Cooldown
					ClaimChest(Player, Info)
				end
			end
		end
	end
end)