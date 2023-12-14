--// Services
local TS = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

--// Variables

local Modules = ReplicatedStorage:WaitForChild("Modules")
local Content = require(Modules.Shared.ContentManager)

local Library = ReplicatedStorage.Pets

local RemoteEvents = ReplicatedStorage.Remotes
local PetActionEvent = RemoteEvents.EggOpened

local EggModels = workspace.Eggs

local Command = "!egganim"
local SpawnCommand = "!spawn"


function changeTableIntoString(seperator: {[string]: string}, list: {}, collection: number, listlength: number):  string
	return table.concat(list, seperator, collection, listlength)
end

local function findEgg(PetName)
	local Eggs	= Content.Eggs

	for EggName, Data in Eggs do
		for i, PetData in Data.Pets do
			if PetName == PetData["Name"] then
				print("eggFound", EggName)
				return EggName
			end
		end
	end

	return false
end


function RandomID(Player)
	local Chance = math.random(2,1000000)

	local suc,er = pcall(function()
		if Player.Pets:FindFirstChild(Chance) then
			return RandomID()
		end
	end)

	if er then warn("An error has occured in the 'RandomID' function: "..er) end

	return Chance
end

local function BuyEgg(Player, Egg, PetChosen, Tier)
	print("Buying Egg")
	local Type = Tier
	local ToReturn = {PetChosen,Type,false,false}

	ReplicatedStorage.Pets.Exist.Server[Type.." "..PetChosen].Value += 1
	Player.Data["UgcEggs"].Value += 1


	local Clone = ReplicatedStorage.Pets.PetTemplate:Clone()
	Clone.PetName.Value = PetChosen
	Clone.Multiplier1.Value = Content.Pets[PetChosen].Multiplier * (2 ^ Type)-- * (1 + math.random(1,100)/100-0.05)
	Clone.Type.Value = Type 
	Clone.Parent = Player.Pets
	Clone.Name = RandomID(Player)
	Clone.Locked.Value = false

	Player.Data.PetsOwned.Value += 1

	return ToReturn
end

local function PlayerAdded(Player)
	Player.Chatted:Connect(function(message: string)  
		if Player:GetRankInGroup(12554523) >= 4 then
			if #string.split(message, " ") >= 5 and string.split(message, " ")[1] == Command then
				local commandMessage = string.split(message, " ")[1]
				local PlayerName = string.split(message, " ")[2]
				local Tier = tonumber(string.split(message, " ")[3])
				local Amount = tonumber(string.split(message, " ")[4])
				local PetName = changeTableIntoString(" ", string.split(message, " "), 5, #string.split(message, " "))

				print(PetName)

				if Players:FindFirstChild(PlayerName) and commandMessage == Command then
					local localPlayer = Players:FindFirstChild(PlayerName)
					local EggName = findEgg(PetName)
					if EggName  then
						local PetsChosen = {}	

						for i = 1, Amount do
							local PetChosen = BuyEgg(localPlayer, EggName, PetName, Tier)

							PetsChosen[i] = PetChosen

							if not localPlayer.Index:FindFirstChild(PetChosen[1]) then
								local NewVal = Instance.new("IntValue", localPlayer.Index)
								NewVal.Value = 1
								NewVal.Name = PetChosen[1]
								PetChosen[3] = true
							else
								localPlayer.Index[PetChosen[1]].Value += 1
							end
						end

						RemoteEvents.SpawnPet:FireClient(localPlayer, PetsChosen, EggName)
					end
				end
			end

			if #string.split(message, " ") >= 5 and string.split(message, " ")[1] == SpawnCommand then
				local commandMessage = string.split(message, " ")[1]
				local PlayerName = string.split(message, " ")[2]
				local Tier = tonumber(string.split(message, " ")[3])
				local Amount = tonumber(string.split(message, " ")[4])
				local PetName = changeTableIntoString(" ", string.split(message, " "), 5, #string.split(message, " "))
				
				if Content.Pets[PetName] and Players:FindFirstChild(PlayerName) then
					local localPlayer = Players:FindFirstChild(PlayerName)
					
					for i = 1, Amount do
						local NewPet = ReplicatedStorage.Pets.PetsInfo.PetTemplate:Clone()
						NewPet.PetName.Value = PetName
						NewPet.Multiplier1.Value = Content.Pets[PetName].Multiplier
						NewPet.Type.Value = Tier
						NewPet.Parent = localPlayer.Pets
						NewPet.Name = RandomID(localPlayer.Pets)

						if not localPlayer.Index:FindFirstChild(PetName) then
							local NewVal = Instance.new("IntValue", localPlayer.Index)
							NewVal.Value = 1
							NewVal.Name = PetName
						else
							localPlayer.Index[PetName].Value += 1
						end

						ReplicatedStorage.Pets.Exist.Server["0 "..PetName].Value += 1
					end
				end
			end
		end
	end)
end

game.Players.PlayerAdded:Connect(PlayerAdded)