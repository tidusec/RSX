--// Services

local MPS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local MS = game:GetService("MessagingService")
local DS = game:GetService("DataStoreService")
local Players = game:GetService("Players")

--// Variables

local Modules = RS.Modules
local Remotes = RS.Remotes

local Content = require(Modules.Shared.ContentManager)
local Robux = require(Modules.RobuxShop)
local Multis = require(Modules.Shared.Multipliers)

local BuyGamepassRemote = Remotes.TokenGamepass
local BuyProductRemote = Remotes.TokenProduct

--// Functions

function RandomID(Player)
	local Chance = math.random(2,10000000)
	if Player.Pets:FindFirstChild(Chance) then
		return RandomID()
	end

	return Chance
end

local function GetPet(SelectedEgg)
	local TotalWeight = 0
	for _,v in SelectedEgg do
		TotalWeight += v.Rarity
	end

	local Chance = Random.new():NextNumber(0.0001,TotalWeight)
	local Counter = 0

	for _,v in SelectedEgg do
		Counter += v.Rarity
		if Counter >= Chance then
			return v.Name
		end
	end
end

local function GetRobuxEgg(Player, Egg)
	if Content.Eggs[Egg] ~= nil then
		local EggInfo = Content.Eggs[Egg]
		local ChosenPet = GetPet(EggInfo.Pets)
		if ChosenPet ~= nil then
			local ToReturn = {ChosenPet,0}
			RS.Remotes.EggOpened:InvokeClient(Player, Egg, ToReturn, 1)
			return ChosenPet
		end
	end
end

local function CreatePet(Player,Pet)
	local NewPet = RS.Pets.PetTemplate:Clone()
	NewPet.PetName.Value = Pet
	NewPet.Multiplier1.Value = Content.Pets[Pet].Multiplier
	NewPet.Parent = Player.Pets
	NewPet.Locked.Value = true
	NewPet.Name = RandomID(Player)

	Player.Data.PetsOwned.Value += 1

	RS.Pets.Exist.Server["0 "..Pet].Value += 1

	if not Player.Index:FindFirstChild(Pet) then
		local NewVal = Instance.new("IntValue",Player.Index)
		NewVal.Value = 1
		NewVal.Name = Pet
	else
		Player.Index[Pet].Value += 1
	end
end


--[[
local Player,Pet,PetTier = game.Players["MarvHD123"],"Silver Prestige Dragon", 0

local NewPet = game.ReplicatedStorage.Pets.PetTemplate:Clone()
NewPet.PetName.Value = Pet
NewPet.Multiplier1.Value = require(game.ReplicatedStorage.Modules.Shared.ContentManager).Pets[Pet].Multiplier
NewPet.Parent = Player.Pets
NewPet.Name = math.random(1,1e6)
NewPet.Type.Value = PetTier
Player.Data.PetsOwned.Value += 1

print("created a new pet with id "..NewPet.Name)

]]

--// Load Gamepasses

Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or game.Players:FindFirstChild(Player.Name) == nil

	local Data = Player.Data

	for Id,Info in Robux.Gamepasses do
		if Data:FindFirstChild(Info.Name) then
			if Data[Info.Name].Value == false then
				if MPS:UserOwnsGamePassAsync(Player.UserId,Id) then
					Data[Info.Name].Value = true
				end
			end
		else
			warn("Gamepass: "..Info.Name.." does not have a value!")
		end
	end
end)

--// Buy Gamepasses ingame

function BuyGamepass(Player, Gamepass)
	if Player.Data:FindFirstChild(Robux.Gamepasses[Gamepass].Name) then
		Player.Data[Robux.Gamepasses[Gamepass].Name].Value = true
		RS.Remotes.CreateNotification:FireClient(Player,"SpecialPopup","PurchaseComplete")
	else
		warn("Gamepass: "..Robux.Gamepasses[Gamepass].Name.." does not have a value!")
	end
end

MPS.PromptGamePassPurchaseFinished:Connect(function(Player,Gamepass,Succes)
	if not Succes then return end

	if Robux.Gamepasses[Gamepass] then
		Player.Data["Robux Spent"].Value += Robux.Gamepasses[Gamepass].Price
		BuyGamepass(Player, Gamepass)
	else
		warn("GamepassId: "..Gamepass.." not exist!")
	end
end)

BuyGamepassRemote.OnServerEvent:Connect(function(Player,Gamepass,Success)
	if Player.Data.TradeTokens.Value > Robux.Gamepasses[Gamepass].Price and Player.Data[Robux.Gamepasses[Gamepass].Name].Value == false then
		BuyGamepass(Player, Gamepass)
		Player.Data.TradeTokens.Value -= Robux.Gamepasses[Gamepass].Price
	end
end)

--// Developer Products

function BuyProduct(Player, Info, Gift, Type)
	if Gift and Player.Data[Info.Name].Value == false then
		Player.Data[Info.Name].Value = true

		local Message = {Text = Type.." just gifted "..Info.Display.." to "..Player.Name, Color = Color3.fromRGB(85, 255, 127),Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18}
		RS.Remotes.SendMessage:FireAllClients(Message)
	else
		if Type == "Pet" then
			CreatePet(Player, Info.PetName)
		elseif Type == "TradeTokens" then
			Player.Data.TradeTokens.Value += Info.Price
		elseif Type == "Boost" then
			Player.Data[Info.Name.."Available"].Value += 1
		elseif Type == "Spin" then
			Player.Data.HasSpin.Value = 1 -- sets cooldown to 1 < os.time() which is true
		elseif Type == "PremiumPass" then
			Player.Data.PremiumPass.Value = true
						
			for i = 1,Player.Data.Tier.Value do
				local Reward = require(game.ReplicatedStorage.Modules.SeasonPassReward).Premium[i]
				if Reward ~= nil then
					if Reward.Type == "Stars" then
						Player.Data.Stars.Value += Reward.Amount * Multis.GetStarMultiplier(Player,3)
					elseif Reward.Type == "Gems" then
						Player.Data.Gems.Value += Reward.Amount * Multis.GetGemMultiplier(Player)
					elseif Reward.Type == "Pet" then
						CreatePet(Player, Reward.Amount)
					elseif Reward.Type == "TradeTokens" then
						Player.Data.TradeTokens.Value += Reward.Amount
					elseif Reward.Type == "Boost" then
						Player.Data["x2"..Reward.Amount.."Available"].Value += 1
					end
				end
			end
		elseif Type == "Skip" then
			if Player.Data.Tier.Value ~= 10 then
				Player.Data.XP.Value += (Player.Data.Tier.Value-1) * 50 + 100
			end
		elseif Type == "SkipAll" then
			local Skips = 10 - Player.Data.Tier.Value
			
			for i = 1, Skips do
				Player.Data.XP.Value += (Player.Data.Tier.Value-1) * 50 + 100
				task.wait(0.1)
			end
		elseif Type == "Pack" then
			Player.Data["x2GemsAvailable"].Value += 5
			Player.Data["x2StarsAvailable"].Value += 5
			Player.Data["x2LuckAvailable"].Value += 5
		elseif Type == "ExclusiveEgg" then
			local EggInfo = {[1] = {Name = "Golden Dog", Type = 1, Rarity = 83.9},[2] = {Name = "Golden King Dragon", Type = 1, Rarity = 13},[3] = {Name = "Golden Gem", Type = 1, Rarity = 3},[4] = {Name = "Shiny Star", Type = 1, Rarity = 0.1}}
			for i = 1,Info.Amount do
				local PetChosen = GetPet(EggInfo)
				RS.Remotes.EggOpened:InvokeClient(Player, "Golden", {PetChosen, 0}, 1)
				CreatePet(Player, PetChosen)
			end
		else
			Player.Data["x2GemsAvailable"].Value += 1
			Player.Data["x2StarsAvailable"].Value += 1
			CreatePet(Player, "Frozen Unicorn")
		end
	end

	RS.Remotes.CreateNotification:FireClient(Player,"SpecialPopup","PurchaseComplete")
end

BuyProductRemote.OnServerEvent:Connect(function(Player, ID)
	local Price
	
	for _, InfoTable in Robux do
		for ProdID, Info in InfoTable do
			if ProdID == ID then
				Price = Info.Price
			end
		end
	end
	
	if Player.Data.TradeTokens.Value < Price then return end
	
	if Robux.Products[ID] then
		local Info = Robux.Products[ID]
		Price = Info.Price
		
		if Info.Type == "Boost" then
			BuyProduct(Player, Info, false, "Boost")
		elseif Info.Type == "TradeTokens" then
			--BuyProduct(Player, Info, false, "TradeTokens")
			Price = 0
		elseif Info.Type == "Pack" then
			BuyProduct(Player, Info, false, "Pack")
		elseif Info.Type == "ExclusiveEgg" then
			BuyProduct(Player, Info, false, "ExclusiveEgg")
		end
	elseif Robux.LimitedPets[ID] then
		local Info = Robux.LimitedPets[ID]
		Price = Info.Price
		
		BuyProduct(Player, Info, false, "Pet")
	else 
		for _,GPInfo in Robux.Gamepasses do
			if GPInfo.GiftProduct == ID then
				local TargetPlayer = Players:FindFirstChild(Player.Gifting.Value)
				Price = GPInfo.Price

				if TargetPlayer then					
					BuyProduct(TargetPlayer, GPInfo, true)
				end
			end
		end
	end
	
	Player.Data.TradeTokens.Value -= Price
end)

MPS.ProcessReceipt = function(receiptInfo)
	local Player = Players:GetPlayerByUserId(receiptInfo.PlayerId)

	--// If it's in the "Robux" module products tab
	if Robux.Products[receiptInfo.ProductId] then
		local Info = Robux.Products[receiptInfo.ProductId]

		Player.Data["Robux Spent"].Value += Info.Price

		if Info.Type == "Boost" then
			BuyProduct(Player, Info, false, "Boost")
		elseif Info.Type == "TradeTokens" then
			BuyProduct(Player, Info, false, "TradeTokens")
		elseif Info.Type == "Spin" then
			BuyProduct(Player, Info, false, "Spin")
		elseif Info.Type == "Pack" then
			BuyProduct(Player, Info, false, "Pack")
		elseif Info.Type == "PremiumPass" then
			BuyProduct(Player, Info, false, "PremiumPass")
		elseif Info.Type == "Skip" then
			BuyProduct(Player, Info, false, "Skip")
		elseif Info.Type == "SkipAll" then
			BuyProduct(Player, Info, false, "SkipAll")
		elseif Info.Type == "ExclusiveEgg" then
			task.spawn(function()
				BuyProduct(Player, Info, false, "ExclusiveEgg")
			end)
		end
		
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif Robux.LimitedPets[receiptInfo.ProductId] then
		local Info = Robux.LimitedPets[receiptInfo.ProductId]

		BuyProduct(Player, Info, false,"Pet")
		Player.Data["Robux Spent"].Value += Info.Price

		return Enum.ProductPurchaseDecision.PurchaseGranted
	else 
		for _,GPInfo in Robux.Gamepasses do
			if GPInfo.GiftProduct == receiptInfo.ProductId then
				local TargetPlayer = Players:FindFirstChild(Player.Gifting.Value)

				if TargetPlayer and TargetPlayer.Data:FindFirstChild(GPInfo.Name) then			
					BuyProduct(TargetPlayer, GPInfo, true, Player.Name)

					Player.Data["Robux Spent"].Value += GPInfo.Price
					return Enum.ProductPurchaseDecision.PurchaseGranted
				end
			end
		end
	end
	
	if receiptInfo.ProductId == 1544559894 then
		BuyProduct(Player,nil, false, "")
		Player.Data["Robux Spent"].Value += 249
		Player.Data.Starterpack.Value = 0
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	
	--// Limited Pet
	if receiptInfo.ProductId == 1549212591 then
		CreatePet(Player, "Cosmic Star")
		MS:PublishAsync("BoughtPet")
		local PetsSoldData = DS:GetDataStore("LimitedPet")
		local AmountSold = 0
		
		local Key = workspace["Limited Pet"].Stand.Datastore.Value
		
		pcall(function()
			AmountSold = PetsSoldData:GetAsync(Key)
		end)
		
		Player.Data["Robux Spent"].Value += 999
		PetsSoldData:SetAsync(Key, AmountSold + 1)
		RS.Remotes.CreateNotification:FireClient(Player,"SpecialPopup","PurchaseComplete")
		
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	for Egg,EggInfo in Content.Eggs do
		if EggInfo.ProductID ~= nil then
			if EggInfo.ProductID == receiptInfo.ProductId then
				local ChoosePet = GetRobuxEgg(Player,Egg)

				if ChoosePet then
					CreatePet(Player,ChoosePet)
				end

				Player.Data["Robux Spent"].Value += EggInfo.Cost
				RS.Remotes.CreateNotification:FireClient(Player,"SpecialPopup","PurchaseComplete")
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end	
		end
	end
end