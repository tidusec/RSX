--// Configure

local LoadingFunctions = {}
local Values = require(script.Parent.Values)
local DS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")

local remotes = RS.Remotes

local PlayerData = DS:GetDataStore("Data")
local PetData = DS:GetDataStore("Pets")
local CodesData = DS:GetDataStore("Codes")
local IndexData = DS:GetDataStore("Index")
local AutoDeleteData = DS:GetDataStore("AutoDelete")

local Content = require(RS.Modules.Shared.ContentManager)

local function CreateFolder(Player,FolderName)
	local NewFolder = Instance.new("Folder",Player)
	NewFolder.Name = FolderName
	return NewFolder
end

--// Module

function LoadingFunctions.LoadAll(Player)
	local Folder = CreateFolder(Player,"PlayerData")
	local Datastore

	local suc,er = pcall(function()
		Datastore = DS:GetDataStore("Datastore"):GetAsync(Player.UserId)
	end)

	if er then warn(er) Player:Kick("Failed to load") return end
	
	local Codes = CreateFolder(Folder, "Codes")
	
	if Datastore and Datastore.Codes then
		for Code,Redeemed in Datastore.Codes do
			local NewInstance = Instance.new("BoolValue")
			NewInstance.Name = Code
			NewInstance.Value = Redeemed
			NewInstance.Parent = Codes
		end
	end
	
	local Pets = CreateFolder(Player,"Pets")

	
	if Datastore and Datastore.Pets then
		print("Loading new data")
		for _, Pet in Datastore.Pets do
			LoadPet(Pet, Player)
		end
	else
		local OldPetData = DS:GetDataStore("Pets"):GetAsync(Player.UserId)
		
		if OldPetData then
			print("Loading old data")
			for _,Pet in OldPetData do
				LoadPet(Pet, Player)
			end	
		end
	end
end

function LoadPet(Pet, Player)
	local Template = RS.Pets.PetTemplate:Clone()
	local Multi = Content.Pets[Pet.PetName].Type and Content.Pets[Pet.PetName].Multiplier.Multiplier or require(RS.Modules.Shared.ContentManager).Pets[Pet.PetName].Multiplier 
	Template.Equipped.Value = Pet.Equipped
	Template.Multiplier1.Value = Multi == "???" and Pet.Multiplier1 or Multi * (2 ^ Pet.Type)
	Template.PetName.Value = Pet.PetName
	Template.Type.Value = Pet.Type
	Template.Locked.Value = Pet.Locked
	Template.Name = Pet.PetID
	Template.Parent = Player.Pets

	if Pet.Enchantment then
		Template.Enchantment.Value = Pet.Enchantment
	end

	--// PetData

	Player.Data.PetsOwned.Value += 1
	
	if not Pet.Equipped then return end
	
	Player.Data.PetsEquipped.Value += 1
	Player.PetMulti.Value += Pet.Multiplier1
	Player.PetMulti4.Value += Content.Pets[Pet.PetName].Type and Content.Pets[Pet.PetName].Multiplier.CandyMultiplier or 0

	local Enchant = Content.Enchantments[Pet.Enchantment]
	if Enchant and Enchant.Type == "GP" then
		Player.PetMulti2.Value += Enchant.Boost
	elseif Enchant and Enchant.Type == "PP" then
		Player.PetMulti3.Value += Enchant.Boost * Template.Multiplier1.Value
	end
end

LoadingFunctions.LoadData = function(Player)
	local LoadPlayerData = PlayerData:GetAsync(Player.UserId)
	local Folder = CreateFolder(Player,"Data")


	for _,Info in Values do
		local NewInstance = Instance.new(Info.Type,Folder)
		NewInstance.Name = Info.Name
		NewInstance.Value = Info.Value

		if LoadPlayerData then
			if LoadPlayerData[Info.ID] and LoadPlayerData ~= Info.Value then
				Folder[Info.Name].Value = LoadPlayerData[Info.ID]
			end
		end
	end
	
	if os.time() - Folder.LastLeft.Value <= 300 then
		Player.EggCombo.Value = Folder.LuckCombo.Value 
	end
	
	Folder.PetsEquipped.Value = 0
	Folder.PetsOwned.Value = 0
end

LoadingFunctions.ReturnData = function(playerID)
	return PlayerData:GetAsync(playerID)
end

LoadingFunctions.LoadIndex = function(Player)
	local LoadPlayerIndex = IndexData:GetAsync(Player.UserId)
	local Folder = CreateFolder(Player,"Index")
	
	if not LoadPlayerIndex then return end
	
	for PetName, Amount in LoadPlayerIndex do
		local NewInstance = Instance.new("IntValue",Folder)
		NewInstance.Name = PetName
		NewInstance.Value = Amount
	end
end

function LoadingFunctions.InstantSave(playerId, Data)
	PlayerData:SetAsync(playerId, Data)
end


LoadingFunctions.LoadDelete = function(Player)
	local LoadAutoDelete = AutoDeleteData:GetAsync(Player.UserId)
	local Folder = CreateFolder(Player,"AutoDelete")
	
	for PetName,PetInfo in require(RS.Modules.Shared.ContentManager).Pets do
		local NewInstance = Instance.new("BoolValue", Folder)
		NewInstance.Name = PetName
		NewInstance.Value = false

		if LoadAutoDelete and LoadAutoDelete[PetName] then
			NewInstance.Value = LoadAutoDelete[PetName]
		end
	end
end

return LoadingFunctions
