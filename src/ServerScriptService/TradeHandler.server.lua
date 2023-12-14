--// Services

local RS = game:GetService("ReplicatedStorage")
local DS = game:GetService("DataStoreService")

local PetData = DS:GetDataStore("Pets")

--// Variables

local PetsInfo = RS.Pets
local Remotes = RS.Remotes
local SendTrade = Remotes.Trade.RequestTrade
local StartTrade = Remotes.Trade.StartTrade
local SendOffer = Remotes.Trade.SendOffer
local ChangeOffer = Remotes.Trade.ChangeOffer

local Content = require(RS.Modules.Shared.ContentManager)
local Multipliers = require(RS.Modules.Shared.Multipliers)
local Webhooks = require(script.Parent.Main.Server.Webhook)

local TradeOffers = {}

function savePets(Player)
	local suc, er = pcall(function()
		local ToSave2 = {}
		local PetsFolder = Player.Pets

		for i,v in PetsFolder:GetChildren() do
			local NewTable = {}

			NewTable = {
				PetID = v.Name,
				Equipped = v.Equipped.Value,
				PetName = v.PetName.Value,
				Multiplier1 = v.Multiplier1.Value,
				TotalXP = v.TotalXP.Value,
				Type = v.Type.Value,
				Locked = v.Locked.Value
			}

			table.insert(ToSave2, NewTable)
		end

		PetData:SetAsync(Player.UserId,ToSave2)
	end)

	if er then
		warn(er)
	end
end

function GetPointOnCircle(CircleRadius, Degrees)
	return Vector3.new(math.cos(math.rad(Degrees)) * CircleRadius, 1, math.sin(math.rad(Degrees))* CircleRadius)
end

function LoadEquipped(Player)
	local PetTable = {}
	local CurrentlyEquipped = {}

	for _,Pet in Player.Pets:GetChildren() do
		PetTable[Pet.Name] = Pet.Name

		if Pet.Equipped.Value then
			CurrentlyEquipped[#CurrentlyEquipped + 1 ] = {PetID = Pet.Name, PetName = Pet.PetName.Value, PetType = Pet.Type.Value}
		else
			if workspace.PlayerPets[Player.Name]:FindFirstChild(Pet.Name) then
				workspace.PlayerPets[Player.Name][Pet.Name]:Destroy()
			end
		end
	end

	local Offset = 360/#CurrentlyEquipped + 1
	local Character = Player.Character
	local CircleRadius = 8

	for i = 1,#CurrentlyEquipped do
		local PetModel = workspace.PlayerPets[Player.Name]:FindFirstChild(CurrentlyEquipped[i].PetID)

		if PetModel then
			PetModel.Pos.Value = GetPointOnCircle(CircleRadius, Offset * i)
		else			
			local NewPet = PetsInfo.Models[CurrentlyEquipped[i].PetName]:Clone()
			local Pos = Instance.new("Vector3Value",NewPet)
			Pos.Name = "Pos"
			Pos.Value = GetPointOnCircle(CircleRadius, Offset * i)
			NewPet.Name = CurrentlyEquipped[i].PetID
			NewPet.Parent = workspace.PlayerPets[Player.Name]

			local Clone = script.Follow:Clone()
			Clone.Parent = NewPet
			Clone.Enabled = true

			local BG = script.BodyGyro:Clone()
			BG.Parent = NewPet.PrimaryPart

			local BP = script.BodyPosition:Clone()
			BP.Parent = NewPet.PrimaryPart

			local Overhead = PetsInfo.PetInfo:Clone()
			Overhead.Parent = NewPet.PrimaryPart

			for v = 1,5 do
				if CurrentlyEquipped[i].PetType >= v then
					Overhead.Stars[v].Visible = true
				else
					Overhead.Stars[v].Visible = false
				end
			end

			Overhead.PetName.Text = CurrentlyEquipped[i].PetName
			Overhead.Rarity.Text = Content.Pets[CurrentlyEquipped[i].PetName].Rarity
			Overhead.Rarity.TextColor3 = require(PetsInfo.Configure).Rarities[Content.Pets[CurrentlyEquipped[i].PetName].Rarity].Color

			NewPet.Parent = workspace.PlayerPets[Player.Name]
			NewPet.PrimaryPart:SetNetworkOwner(Player)
		end
	end

	for _,PlayerPet in workspace.PlayerPets[Player.Name]:GetChildren() do
		if not PetTable[PlayerPet.Name] then
			PlayerPet:Destroy()
		end
	end
end

SendTrade.OnServerInvoke = function(Player,Player2)
	--// Player clicked "SendTrade"

	Player2 = game.Players:FindFirstChild(Player2)

	if not Player2:FindFirstChild("Loaded") or not Player2.Loaded.Value then return end

	if Player.Trade.Value or Player2.Trade.Value then return end

	--// Send TradeOffer

	SendTrade:InvokeClient(Player2,Player.Name)	
end

StartTrade.OnServerInvoke = function(Player,Player2)
	--// Trade Offer is accepted, starting trade

	Player2 = game.Players:FindFirstChild(Player2)

	if not Player2:FindFirstChild("Loaded") or not Player2.Loaded.Value then return end

	if Player.Trade.Value or Player2.Trade.Value then return end

	Player.Trade.Value = true
	Player2.Trade.Value = true

	StartTrade:InvokeClient(Player2,Player.Name)
	return "StartTrade"
end

local t = false

SendOffer.OnServerInvoke = function(Player,Player2,Option)
	Player2 = game.Players:FindFirstChild(Player2)

	if Option == "Cancel" then
		if Player2 == nil then -- if player 2 left
			Player.Trade.Value = false
			Player.Ready.Value = false

			TradeOffers[Player.Name].Pets = {}
			TradeOffers[Player.Name].Tokens = 0

			return "Succes"
		else
			Player.Trade.Value = false
			Player2.Trade.Value = false
			Player.Ready.Value = false
			Player2.Ready.Value = false

			TradeOffers[Player.Name].Pets = {}
			TradeOffers[Player.Name].Tokens = 0
			TradeOffers[Player2.Name].Pets = {}
			TradeOffers[Player2.Name].Tokens = 0

			SendOffer:InvokeClient(Player2,"Cancel",Player.Name)

			return "Succes"
		end
	elseif Option == "TradeDone" then
		if t == false then
			Player.Data.SeasonQuest7.Value += 1
			Player2.Data.SeasonQuest7.Value += 1
			Player.Trade.Value = false
			Player2.Trade.Value = false
			Player.Ready.Value = false
			Player2.Ready.Value = false

			Player2.Data.TradeTokens.Value += TradeOffers[Player.Name].Tokens
			Player2.Data.TradeTokens.Value -= TradeOffers[Player2.Name].Tokens
			Player.Data.TradeTokens.Value += TradeOffers[Player2.Name].Tokens
			Player.Data.TradeTokens.Value -= TradeOffers[Player.Name].Tokens

			local function ReturnMessage (player) 
				local tableMessage = {["Message"] = "", ["TradeTokens"] = ""}
				for name, number in TradeOffers[player.Name].Pets do
					if player.Pets:FindFirstChild(name) then
						local PetName = player.Pets:FindFirstChild(name).PetName.Value
						tableMessage.Message =  tableMessage.Message ..PetName..", "
					end
				end
				local Tokens = tostring(TradeOffers[player.Name].Tokens)
				tableMessage.TradeTokens = Tokens
				return tableMessage
			end
			local player1Message = ReturnMessage(Player)
			local player2Message = ReturnMessage(Player2)

			Webhooks.TradeLog(Player, player1Message, Player2, player2Message)

			for i,v in TradeOffers[Player.Name].Pets do
				local ClonedPet = Player.Pets:FindFirstChild(i)
				if ClonedPet then
					ClonedPet.Parent = Player2.Pets

					if ClonedPet.Equipped.Value then
						Player.PetMulti.Value -= ClonedPet.Multiplier1.Value
						Player.PetMulti4.Value -= Content.Pets[ClonedPet.PetName.Value].Type and ClonedPet.Multiplier1.Value or 0
						Player.Data.PetsEquipped.Value -= 1
						ClonedPet.Equipped.Value = false

						local Enchant = Content.Enchantments[ClonedPet.Enchantment.Value]
						if Enchant and Enchant.Type == "GP" then
							Player.PetMulti2.Value -= Enchant.Boost
						elseif Enchant and Enchant.Type == "PP" then
							Player.PetMulti3.Value -= Enchant.Boost
						end
					end

					if not Player2.Index:FindFirstChild(ClonedPet.PetName.Value) then
						local NewVal = Instance.new("IntValue",Player.Index)
						NewVal.Value = 1
						NewVal.Name = ClonedPet.PetName.Value
					end
				end
			end

			for i,v in TradeOffers[Player2.Name].Pets do
				local ClonedPet = Player2.Pets:FindFirstChild(i)
				if ClonedPet then
					ClonedPet.Parent = Player.Pets

					if ClonedPet.Equipped.Value then
						Player2.PetMulti.Value -= ClonedPet.Multiplier1.Value
						Player2.PetMulti4.Value -= Content.Pets[ClonedPet.PetName.Value].Type and ClonedPet.Multiplier1.Value or 0
						Player2.Data.PetsEquipped.Value -= 1
						ClonedPet.Equipped.Value = false

						local Enchant = Content.Enchantments[ClonedPet.Enchantment.Value]
						if Enchant and Enchant.Type == "GP" then
							Player2.PetMulti2.Value -= Enchant.Boost
						elseif Enchant and Enchant.Type == "PP" then
							Player2.PetMulti3.Value -= Enchant.Boost
						end
					end

					if not Player.Index:FindFirstChild(ClonedPet.PetName.Value) then
						local NewVal = Instance.new("IntValue",Player.Index)
						NewVal.Value = 1
						NewVal.Name = ClonedPet.PetName.Value
					end
				end
			end

			TradeOffers[Player.Name].Pets = {}
			TradeOffers[Player.Name].Tokens = 0
			TradeOffers[Player2.Name].Pets = {}
			TradeOffers[Player2.Name].Tokens = 0
			t = true
			task.wait(0.05)
			t = false

			savePets(Player)
			savePets(Player2)

			LoadEquipped(Player)
			LoadEquipped(Player2)
			SendOffer:InvokeClient(Player2,"TradeDone")
			return "Succes"
		end
	elseif Option == "Ready" then
		if not Player.Ready.Value then
			Player.Ready.Value = true
			SendOffer:InvokeClient(Player2,"Ready")
			return "Ready"
		else 
			Player.Ready.Value = false
			SendOffer:InvokeClient(Player2,"Unready")
			return "Unready"
		end
	end
end

local function GetAmount(x)
	local a = 0
	for _,_ in x do
		a += 1
	end
	return a
end

ChangeOffer.OnServerInvoke = function(Player,Player2,Action,RewardType,Amount)
	if Action == "Add" then
		if RewardType == "Pet" then
			if not TradeOffers[Player.Name].Pets[Amount] then
				if GetAmount(TradeOffers[Player.Name].Pets) < Multipliers.GetMaxPetStorage(game.Players[Player2]) - #game.Players[Player2].Pets:GetChildren() then
					TradeOffers[Player.Name].Pets[Amount] = 1
					ChangeOffer:InvokeClient(game.Players[Player2],"Pet Add",Amount)
					return "Added"
				else
					return "Max"
				end
			else
				TradeOffers[Player.Name].Pets[Amount] = nil
				ChangeOffer:InvokeClient(game.Players[Player2],"Pet Remove",Amount)
				return "Removed"
			end
		elseif RewardType == "Tokens" then
			if Player.Data.TradeTokens.Value >= Amount then 
				TradeOffers[Player.Name].Tokens = math.clamp(Amount,0,math.huge)
				ChangeOffer:InvokeClient(game.Players[Player2],"Tokens Add",Amount)
				return "Added Tokens"
			else
				return "Not enough trade tokens"
			end
		end
	end	
end

game.Players.PlayerAdded:Connect(function(Player)
	TradeOffers[Player.Name] = {["Pets"] = {},["Tokens"] = 0}
end)

game.Players.PlayerRemoving:Connect(function(Player)
	TradeOffers[Player.Name] = nil
end)