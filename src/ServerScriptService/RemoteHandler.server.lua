--// Change player.gifting's value 

--// Services

local RS = game:GetService("ReplicatedStorage")
local MarketPlaceService = game:GetService("MarketplaceService")

--// Variables

local Modules = RS.Modules
local Worlds = require(Modules.Worlds)
local SpinModule = require(Modules.Spin)
local Content = require(Modules.Shared.ContentManager)
local StarModule = require(Modules.Stars)
local Multipliers = require(Modules.Shared.Multipliers)
local Constants = require(Modules.Constants)
local HalloweenInfoModule = Content.HalloweenModule

local Remotes = RS.Remotes
local PetsInfo = RS.Pets

local function isLoaded(Player)
	if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
		return true
	end
end

function RandomID(Folder)
	local Chance = math.random(2,10000000)
	if Folder:FindFirstChild(Chance) then
		return RandomID()
	end

	return Chance
end


function GivePet(Player,Pet)
	local NewPet = PetsInfo.PetTemplate:Clone()
	NewPet.PetName.Value = Pet
	NewPet.Multiplier1.Value = Content.Pets[Pet].Multiplier
	NewPet.Type.Value = 0
	NewPet.Parent = Player.Pets
	NewPet.Name = RandomID(Player.Pets)

	if not Player.Index:FindFirstChild(Pet) then
		local NewVal = Instance.new("IntValue",Player.Index)
		NewVal.Value = 1
		NewVal.Name = Pet
	else
		Player.Index[Pet].Value += 1
	end

	RS.Pets.Exist.Server["0 "..Pet].Value += 1
end

Remotes.SelectGift.OnServerEvent:Connect(function(Player,Target)
	Player.Gifting.Value = Target
end)

--> UGC
Remotes.UgcClaim.OnServerEvent:Connect(function(player)
	if player.Data.UgcClaim.Value == false then
		if player.Data.UgcStars.Value >= 1000 and player.Data.UgcEggs.Value >= 1000 and 
			player.Data.UgcTime.Value >= 3600 then
			MarketPlaceService:PromptPurchase(player, 14604243086)
		else
			player:Kick("Error 204\nIf this keeps happening when claiming the Ugc join our discord server and contact staff")
		end
	end
	if player.Data.UgcPet.Value == false then
		if player.Data.UgcStars.Value >= 1000 and player.Data.UgcEggs.Value >= 1000 and 
			player.Data.UgcTime.Value >= 3600 then
			GivePet(player, "Warrior Dog")
			player.Data.UgcPet.Value = true
		end
	end
end)

--> Halloween Event
Remotes.HalloweenClaim.OnServerEvent:Connect(function(player)
	print("Claimed event")
	if player.Data.HalloweenClaim.Value == false then
		if player.Data.CandyCorn.Value >= 20_000 and player.Data.HalloweenEggs.Value >= 10_000 and 
			player.Data.HalloweenTime.Value >= 14_000 then
			GivePet(player, "Inferno Gem")
			player.Data.HalloweenClaim.Value = true
		end
	end
end)

local HalloweenTypes = {
	["GemBoost"] = {["Name"] = "HalloweenGemBoostClaimed", ["Type"] = "Boost"},
	["GemUpgrade"] = {["Name"] = "HalloweenGemUpgrade", ["Type"] = "Upgrade"},
	["LuckBoost"] = {["Name"] = "HalloweenLuckBoostClaimed", ["Type"] = "Boost"},
	["Pet"] = {["Name"] = "HalloweenPetClaimed", ["Type"] = "Pet"},
	["StarBoost"] = {["Name"] = "HalloweenStarBoostClaimed", ["Type"] = "Boost"},
	["StarUpgrade"] = {["Name"] = "HalloweenStarUpgrade", ["Type"] = "Upgrade"}
}
Remotes.AddHalloweenShop.OnServerEvent:Connect(function(player, ItemName: any)  
	if HalloweenTypes[ItemName] then
		if HalloweenTypes[ItemName].Type == "Boost" then
			if player.Data[HalloweenTypes[ItemName].Name].Value < HalloweenInfoModule.OriginalAmount[ItemName]
				and  player.Data.CandyCorn.Value >= HalloweenInfoModule.Prices[ItemName] then
				
				player.Data[HalloweenTypes[ItemName].Name].Value += 1
				player.Data.CandyCorn.Value -= HalloweenInfoModule.Prices[ItemName]
				if ItemName == "GemBoost" then
					player.Data.x2GemsAvailable.Value += 1
				elseif ItemName == "LuckBoost" then
					player.Data.x2LuckAvailable.Value += 1
				elseif ItemName == "StarBoost" then
					player.Data.x2StarsAvailable.Value += 1
				else
					print("Cannot find this boost")
				end
			end
			
		elseif HalloweenTypes[ItemName].Type == "Pet" then
			if player.Data[HalloweenTypes[ItemName].Name].Value < HalloweenInfoModule.OriginalAmount[ItemName]
				and  player.Data.CandyCorn.Value >= HalloweenInfoModule.Prices[ItemName] then
				
				player.Data.CandyCorn.Value -= HalloweenInfoModule.Prices[ItemName]
				player.Data[HalloweenTypes[ItemName].Name].Value += 1
				
				GivePet(player, "Monstrous Star")
			end
			
		elseif HalloweenTypes[ItemName].Type == "Upgrade" then
			if player.Data[HalloweenTypes[ItemName].Name].Value < HalloweenInfoModule.Upgrades[ItemName].Max
				and  player.Data.CandyCorn.Value >= HalloweenInfoModule.Upgrades[ItemName].Prices( player.Data[HalloweenTypes[ItemName].Name].Value + 1).Price then
				
				player.Data.CandyCorn.Value -= HalloweenInfoModule.Upgrades[ItemName].Prices( player.Data[HalloweenTypes[ItemName].Name].Value + 1).Price
				player.Data[HalloweenTypes[ItemName].Name].Value += 1
			end
		end
	end
end)

--[[
when user claims ugc  make sure they cannot claim it again
]]
MarketPlaceService.PromptPurchaseFinished:Connect(function(player, assetId, purchased)
	if purchased then
		player.Data.UgcClaim.Value = true
	end
end)

--// Settings

local SettingsModule = require(Modules.Settings)

Remotes.ChangeSetting.OnServerEvent:Connect(function(Player,Setting)
	local SettingInfo = SettingsModule[Setting]

	if isLoaded(Player) then
		if SettingInfo then
			if SettingInfo.Type == "Bool" then
				Player.Data[Setting].Value = not Player.Data[Setting].Value
			end
		end
	end
end)

--// Ranks

local function GetRankInfo(Player)
	local MaxRankSkips = Content.Perks[9].Prices(Player.Data.Perk9.Value).Reward

	local Cost, Gems, Skips = 0,0,0

	for i = 1, MaxRankSkips do
		local RankInfo = Content.Ranks[Player.Data.Rank.Value + i]

		if RankInfo == nil then break end

		if Player.Data.Stars.Value >= Cost + RankInfo.Cost then
			Cost += RankInfo.Cost
			Gems += RankInfo.Gems
			Skips += 1
		else
			break
		end
	end

	return Cost, Gems, Skips
end

Remotes.BuyRank.OnServerEvent:Connect(function(Player)
	if not isLoaded(Player) then return end
	if Player.World.Value ~= "Spawn" then Player:Kick("Exploiting") end

	local Cost, Gems, Skips = GetRankInfo(Player)

	if Skips == 0 then return end -- no rank is bought

	Player.Data.Gems.Value += Gems * Multipliers.GetGemMultiplier(Player)
	Player.Data.Rank.Value += Skips
	Player.Data.Stars.Value = 0

	local Message = Player.Name.." just ranked up to "..Content.Ranks[Player.Data.Rank.Value].RankName

	if Skips > 1 then
		Message = Message.." (Skipped "..Skips.." Ranks)"
	end

	local Info = {Text = Message, Color = Color3.fromRGB(255, 238, 0),Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18}
	Remotes.SendMessage:FireAllClients(Info)
end)

--// Upgrades

Remotes.Upgrades.OnServerEvent:Connect(function(Player,Upgrade)
	if not Content.Upgrades[Upgrade] then return end
	if Player.World.Value ~= "Spawn" then Player:Kick("Exploiting") end

	local UpgradeInfo = Content.Upgrades[Upgrade]

	if isLoaded(Player) then
		local UpgradeStat = Player.Data:FindFirstChild("Upgrade"..Upgrade)

		if UpgradeInfo.Max ~= "Unlockable" then
			if Player.Data.Gems.Value >= UpgradeInfo.Prices(UpgradeStat.Value).Price and UpgradeStat.Value < UpgradeInfo.Max then
				Player.Data.Gems.Value -= UpgradeInfo.Prices(UpgradeStat.Value).Price
				UpgradeStat.Value += 1
			end
		else
			if Player.Data.Gems.Value >= UpgradeInfo.Price and UpgradeStat.Value < 1 then
				Player.Data.Gems.Value -= UpgradeInfo.Price
				UpgradeStat.Value += 1
			end
		end
	end
end)

--// Teleport

local TeleportCooldown = {} -- so no instant tp anymore

Remotes.Teleport.OnServerInvoke = function(Player,World)
	if not Worlds[World] or Player.Data.Rank.Value >= Worlds[World].Requirement then
		if TeleportCooldown[Player.Name] == false then
			TeleportCooldown[Player.Name] = true
			if string.find(World,"Return") then
				Player.World.Value = "Spawn"
				Player.Character.HumanoidRootPart.Anchored = true
				task.wait(1)
				Player.Character:PivotTo(workspace.PortalReceivers.Spawn.CFrame)
				Player.Character.HumanoidRootPart.Anchored = false
			else
				Player.World.Value = World
				Player.Character.HumanoidRootPart.Anchored = true
				task.wait(1)
				Player.Character:PivotTo(workspace.PortalReceivers[World].CFrame)
				Player.Character.HumanoidRootPart.Anchored = false
			end
			TeleportCooldown[Player.Name] = false
		end
	else
		return "Error", "You need a higher rank!"
	end
end

--// Autodelete

Remotes.ToggleAutoDelete.OnServerEvent:Connect(function(Player,Pet)
	if Player.AutoDelete:FindFirstChild(Pet) then
		Player.AutoDelete[Pet].Value = not Player.AutoDelete[Pet].Value
	end
end)

--// Chests

Remotes.ClaimChest.OnServerEvent:Connect(function(Player,Chest)
	if not isLoaded(Player) then return end

	if Content.Chests[Chest].World ~= Player.World.Value then Player:Kick("Exploiting") end

	local Val = Player.Data:FindFirstChild(Chest.."ChestCooldown")
	if not Val then return end

	if Content.Chests[Chest].Requirement(Player) then
		if Val.Value > os.time() then return end

		Player.Data.SeasonQuest10.Value += 1
		Val.Value = os.time() + Content.Chests[Chest].Cooldown

		for _,Reward in Content.Chests[Chest].Reward do
			if Reward.Type == "Number" then
				if Reward.Stat == "Gems" then	
					Player[Reward.Folder][Reward.Stat].Value += Reward.Amount * Multipliers.GetGemMultiplier(Player)
				elseif Reward.Stat == "Boost" then
					local Boosts = {"x2Stars","x2Gems","x2Luck"}

					local SelectedBoost = Boosts[math.random(1,3)]
					Player.Data[SelectedBoost.."Available"].Value += 1
					Remotes.ClaimChest:FireClient(Player,string.format(Content.Chests[Chest].Text, SelectedBoost.." Boost"))
					return
				else
					Player[Reward.Folder][Reward.Stat].Value += Reward.Amount
				end
			end
		end
		Remotes.ClaimChest:FireClient(Player,Content.Chests[Chest].Text)
	else
		RS.Remotes.CreateNotification:FireClient(Player,"Layered","You don't meet the requirement to open this chest.","Error")
	end
end)

--// Spin

CD = false

Remotes.Spin.OnServerInvoke = function(Player)
	if isLoaded(Player) and CD == false then
		if Player.World.Value ~= "Spawn" then Player:Kick("Exploiting") return end
		if Player.Data.HasSpin.Value < os.time() then
			CD = true			
			Player.Data.HasSpin.Value = os.time() + 24*60*60

			local function giveReward(Type,SlotInfo)
				if SlotInfo.Reward.Type == "Pet" then
					GivePet(Player, SlotInfo.Reward.Amount)
				elseif SlotInfo.Reward.Type == "Potion" then
					Player.Data[SlotInfo.Reward.Amount].Value += 1
				elseif SlotInfo.Reward.Type == "Stars" then
					Player.Data["Stars"].Value += SlotInfo.Reward.Amount * Multipliers.GetStarMultiplier(Player)
				elseif SlotInfo.Reward.Type == "Gems" then
					Player.Data.Gems.Value += SlotInfo.Reward.Amount * Multipliers.GetGemMultiplier(Player)
				else					
					Player.Data[SlotInfo.Reward.Type].Value += SlotInfo.Reward.Amount
				end
			end

			local Chances = {}

			--// Put chances in a table
			for Slot,SlotInfo in require(Modules.Spin) do
				Chances[#Chances+1] = {Slot, SlotInfo.Chance}
			end

			table.sort(Chances, function(a,b)
				return (a[2] < b[2])
			end)

			local Chance = Random.new():NextNumber(0,100)

			--// Select rarest
			for _,v in Chances do	
				if v[2] >= Chance then
					CD = false
					local SlotInfo = SpinModule[v[1]]

					giveReward(SlotInfo.Reward.Type, SlotInfo)

					return v[1]
				end
			end

			task.wait(0.02)
			CD = false
			return nil
		end
	end
end


--Remotes.FirstJoin.OnServerEvent:Connect(function(player)
--	player.Data.FirstJoin.Value = false
--	print(player.Data.FirstJoin.Value)
--	print("changing value")
--end)

Remotes.SeasonPassQuestsChosen.OnServerEvent:Connect(function(player, ids)
	player.Data.DailyQuestCoolDown.Value = os.time() + 86400

	for i, v in pairs(ids) do
		player.Data["CurrentShowingQuest"..i].Value = v
	end

end)

Remotes.CompleteAchievement.OnServerEvent:Connect(function(Player, Achievement)
	if Player.World.Value == "Aqua" then
		local AchievementInfo = Content.Achievements[Achievement] 
		local AchievementVal = Player.Data["Achievement"..Achievement]
		local RequiredStat = Player.Data[AchievementInfo.RequiredStat]
		if not AchievementInfo.Reward[AchievementVal.Value + 1] then return end
		if RequiredStat.Value >= AchievementInfo.Prices[AchievementVal.Value] then
			AchievementVal.Value += 1
		end
	else
		Player:Kick("Exploiting")
	end
end)

--// CountryCode

local CountryCooldown = {}

Remotes.SendCountry.OnServerEvent:Connect(function(Player,Code)
	if not CountryCooldown[Player.Name] then
		if RS.Flag:FindFirstChild(Code) then
			Player.Data.Country.Value = Code
		else
			warn("No flag for "..Code)
		end
	end
end)

--// Perk

Remotes.BuyPerk.OnServerEvent:Connect(function(Player,Perk)
	if Perk ~= 1 and Perk ~= 2 and Perk ~= 3 then print(Perk) return end

	local PerkNumber = RS.Perks[Perk].Value

	local PerkInfo = Content.Perks[PerkNumber]

	if isLoaded(Player) then
		local PerkStat = Player.Data["Perk"..PerkNumber]

		if Player.Data.Rank.Value >= PerkInfo.Prices(PerkStat.Value).Price then
			Player.Data.Rank.Value -= PerkInfo.Substraction
			Player.Data.Stars.Value = 0
			PerkStat.Value += 1
			Remotes.BuyPerk:FireClient(Player)
		end
	end
end)

--// Playtime Rewards
local RewardPet = "King Cat"
local RewardPetRarity = 0.1

Remotes.ClaimGift.OnServerEvent:Connect(function(Player,Gift)
	if not isLoaded(Player) then return end
	if Player.Gifts:FindFirstChild(Gift) then return end
	if Content.PlaytimeRewards[Gift].Milestone >= Player.IngameTime.Value then return end

	-- add a new value which is gift to the Player.Gifts folder

	Player.Data.SeasonQuest5.Value += 1
	local GiftValue = Instance.new("BoolValue", Player.Gifts)
	GiftValue.Name = Gift
	local RewardPetInfo = Content.Pets[RewardPet]
	local percentage = math.random()

	if percentage * 100 <= RewardPetRarity then
		local Clone = RS.Pets.PetTemplate:Clone()
		Clone.PetName.Value = RewardPet
		local Type = 0

		if Player.Data.MagicEggs.Value and math.random() <= 0.1 then
			Type = 1
		end
		Clone.Multiplier1.Value = RewardPetInfo.Multiplier * (2 ^ Type)
		Clone.Type.Value = Type
		Clone.Parent = Player.Pets
		Clone.Name = RandomID(Player)
		Clone.Locked.Value = false

		if not Player.Index:FindFirstChild(RewardPet) then
			local NewVal = Instance.new("IntValue",Player.Index)
			NewVal.Value = 1
			NewVal.Name = RewardPet
		else
			Player.Index[RewardPet].Value += 1
		end

		RS.Pets.Exist.Server["0 "..RewardPet].Value += 1

		RS.Remotes.CreateNotification:FireClient(Player,"Layered","You got "..RewardPet.." from the gift","Success")
	end

	Player.Data.Stars.Value += Content.PlaytimeRewards[Gift].Reward * Multipliers. 	GetStarMultiplier(Player)
end)

local sp = require(RS.Modules.SeasonPass)

Remotes.ClaimSeasonQuest.OnServerEvent:Connect(function(Player, Quest)
	local SeasonQuest = Player.Data["SeasonQuest"..Quest]
	local Claimed = Player.Data["SeasonQuest"..Quest.."Claimed"]

	if SeasonQuest.Value >= sp[Quest].Required and Claimed.Value == false then
		Player.Data.XP.Value += sp[Quest].Reward
		Claimed.Value = true
	end
end)



game.Players.PlayerAdded:Connect(function(plr)
	CountryCooldown[plr.Name] = false
	TeleportCooldown[plr.Name] = false
	--print(plr.Data.FirstJoin.Value)
end)

game.Players.PlayerRemoving:Connect(function(plr)
	CountryCooldown[plr.Name] = nil
	TeleportCooldown[plr.Name] = nil
	--print(plr.Data.FirstJoin.Value)
end)