--[[

Scripts contains:
- Datastore
- Leaderstats
- Combo
- Total Gems
- Server Message
- World Events

Extra info:
 Datastore module contains values, main loading function and main saving function
 Loading module contains individual loading & saving functions and the datastore codes

]]

--// Services

local DS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")

--// Datastores

local PlayerData = DS:GetDataStore("Data")
local PetData = DS:GetDataStore("Pets")
local CodesData = DS:GetDataStore("Codes")
local AutoDeleteData = DS:GetDataStore("AutoDelete")
local IndexData = DS:GetDataStore("Index")

--// Variables

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local IndexRewards = require(Modules.Shared.IndexRewards)
local PetFolder = RS.Pets

--// Server Modules

local MainFolder = script.Parent
local Datastore = require(MainFolder.Datastore)
local Values = require(MainFolder.Datastore.Values)
local Settings = require(MainFolder.Datastore.Settings)
local ServerEvents = require(MainFolder.ServerEvents)
local Multipliers = require(RS.Modules.Shared.Multipliers)

local isReserved = game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0

local function MaxStorage(Player)
	local MaxStorage = 75
	
	if Player.Data["+50Storage"].Value then
		MaxStorage += 50
	end
	
	if Player.Data["+250Storage"].Value then
		MaxStorage += 250
	end
	
	return MaxStorage
end

--// Set Up

spawn(function()
	require(MainFolder.ChatMessage).SendMessage()
end)

--// ServerEvents

spawn(function()
	ServerEvents.StartEvents()
end)

--//

local function CountFriendBoost(Player)
	local FriendBoost = 1

	for _,v in game.Players:GetPlayers() do
		if v:IsFriendsWith(Player.UserId) then
			FriendBoost += 0.1
		end
	end

	return math.min(FriendBoost,2)	
end

--// Player Join

local function PlayerAdded(plr)
	if isReserved then return end
	
	for _,ConfigVal in Settings do
		local NewVal = Instance.new(ConfigVal.Type,plr)
		NewVal.Name = ConfigVal.Name
		NewVal.Value = ConfigVal.Value
	end
	
	local Gifts = Instance.new("Folder", plr)
	Gifts.Name = "Gifts"
		
	local IsLoaded = Datastore.LoadData(plr)
	
	if IsLoaded ~= true then
		plr:Kick("Failed to load data")
	end
	
	wait(1)
	
	Datastore.StartLeaderstats(plr)
		
	plr.Data.Combo.Value = 1
	
	--// Max Storage
	
	plr.Data.MaxStorage.Value = MaxStorage(plr)
	
	plr.Data["+50Storage"].Changed:Connect(function()
		plr.Data.MaxStorage.Value = MaxStorage(plr)
	end)
	
	plr.Data["+250Storage"].Changed:Connect(function()
		plr.Data.MaxStorage.Value = MaxStorage(plr)
	end)
		
	plr.Loaded.Value = true
		
	--// Total Gems
	
	local Before = plr.Data.Gems.Value
	
	plr.Data.Gems.Changed:Connect(function()
		local After = plr.Data.Gems.Value
		
		if After > Before then
			plr.Data.TotalGems.Value += After-Before
		end
		
		Before = After
	end)
	
	--// Load FriendBoost
	
	for _,Player in game.Players:GetPlayers() do
		Player.FriendBoost.Value = CountFriendBoost(Player)
	end
	
	--// Pet Power
	
	wait(2)
		
	local function CalculatePetPower()
		local PetTable = {}
		for i,v in plr.Pets:GetChildren() do
			PetTable[i] = v.Multiplier1.Value * Multipliers.GetPetMulti(plr, v)
		end
		table.sort(PetTable,function(a,b)
			return a > b
		end)
		local Total = 0
		for i = 1,50 do
			if #PetTable >= i then
				Total += PetTable[i]
			end
		end
		plr.Data.PetPower.Value = Total
	end
	
	CalculatePetPower()
	
	task.spawn(function()
		while wait(60) do
			CalculatePetPower()
		end
	end)
	
	
	local function TradeTokenHack()
		if plr.Data.TradeTokens.Value >= 5e4 then -- more than 50000
			-- send webhook here
			
			if plr.Data.TradeTokens.Value >= 1e6 then -- ban
				if plr:GetRankInGroup(12554523) < 252 then
					plr.Data.TradeTokens.Value = 0
					BanSystem:BanPlayer(plr, "You have ban been banned for Trade Token Hack.\nIf you think this was a Mistake join the discord and Appeal")
				end
			end
		end
	end
	
	TradeTokenHack()
	
	plr.Data.TradeTokens.Changed:Connect(function()
		TradeTokenHack()
	end)
	
	--// Index
	
	local TotalPets = 0

	for _,Pet in Content.Pets do if Pet.Rarity ~= "Special" then TotalPets += 1 end end -- calculates total pets

	local function GetOwnedPets()
		local Amount = 0
		for _,IndexPets in plr.Index:GetChildren() do
			local PetRarity = Content.Pets[IndexPets.Name].Rarity
			if PetRarity ~= "Special" and PetRarity ~= nil then
				Amount += 1
			end
		end
		return Amount
	end

	local OwnedPets = GetOwnedPets()
	
	local function UpdateReward()
		for i = 1, #IndexRewards do
			if i < #IndexRewards then
				if OwnedPets < IndexRewards[i].Requirement then
					plr.Data.IndexEquips.Value = IndexRewards[i].Amount
					return
				end
			else
				plr.Data.IndexEquips.Value = IndexRewards[i].Amount
			end
		end
	end

	UpdateReward()


	plr.Index.ChildAdded:Connect(function()
		OwnedPets += 1
		UpdateReward()
	end)
	
	--// Combo
	task.spawn(function()
		while wait(0.1) do
			plr.ComboCountdown.Value -= 0.1
			
			if plr.ComboCountdown.Value <= 0 then
				plr.ComboCountdown.Value = 0			
				plr.Data.Combo.Value = math.max(plr.Data.Combo.Value - 0.01, 1)	
			end
		end
	end)
end

--// Autosave

spawn(function()
	while wait(300) do
		for _, plr in (game.Players:GetChildren()) do
			if plr:FindFirstChild("Loaded") and plr.Loaded.Value then
				save(plr)
				plr.Loaded.Value = true
			end
		end
	end
end)

--// On Player leave

task.spawn(function()
	for i, v in game.Players:GetPlayers() do
		PlayerAdded(v)
	end
end)

game.Players.PlayerAdded:Connect(PlayerAdded)

game.Players.PlayerRemoving:Connect(function(plr)
	save(plr)
end) 

game.Players.ChildRemoved:Connect(function()
	for _,Player in game.Players:GetPlayers() do
		Player.FriendBoost.Value = CountFriendBoost(Player)
	end
end)

--// On server close

game:BindToClose(function()
	for i,v in game.Players:GetPlayers() do
		save(v)
	end
end)

--// Save Function

function save(plr)
	if isReserved then return end

	if plr:FindFirstChild("Loaded") == nil or plr.Loaded.Value == false then
		return
	end
	
	Datastore.SaveData(plr)

	local suc,er = pcall(function()
		local ToSave = {}
		local DataFolder = plr.Data
		
		local ToSave2 = {}
		local PetsFolder = plr.Pets
		
		for _,Info in Values do
			if ToSave[Info.ID] ~= Info.Value then
				ToSave[Info.ID] = DataFolder[Info.Name].Value
			end
		end
		
		local ToSave4 = {}
		local AutoDeleteFolder = plr.AutoDelete
		
		for _,Val in AutoDeleteFolder:GetChildren() do
			if Content.Pets[Val.Name] then
				ToSave4[Val.Name] = Val.Value
			end
		end
		
		local Index = {}
		local IndexFolder = plr.Index
		
		for _,Val in IndexFolder:GetChildren() do
			if Content.Pets[Val.Name] then
				Index[Val.Name] = Val.Value
			end
		end

		PlayerData:SetAsync(plr.UserId,ToSave)
		AutoDeleteData:SetAsync(plr.UserId,ToSave4)
		IndexData:SetAsync(plr.UserId,Index)
	end)

	if er then warn(er) end
end