--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Remotes = RS.Remotes
local Modules = RS.Modules
local PetsInfo = RS.Pets

local Content = require(Modules.Shared.ContentManager)
local Multipliers = require(Modules.Shared.Multipliers)

local PetAction = Remotes.PetAction

--// Setup

function RandomID(Folder)
	local Chance = math.random(2,10000000)
	if Folder:FindFirstChild(Chance) then
		return RandomID()
	end

	return Chance
end

function GivePet(Player,Pet)
	print(Pet)
	local NewPet = PetsInfo.PetTemplate:Clone()
	NewPet.PetName.Value = Pet
	NewPet.Multiplier1.Value = Content.Pets[Pet].Multiplier
	NewPet.Type = 1
	NewPet.Parent = Player.Pets
	NewPet.Name = RandomID(Player.Pets)
	NewPet.Locked.Value = false
end

function CheckEquips(Folder)
	local Equips = 0
	for _,Pet in Folder:GetChildren() do
		if Pet.Equipped.Value then
			Equips += 1
		end
	end
	return Equips
end

--// Pet Body

function GetPointOnCircle(CircleRadius, Degrees)
	return Vector3.new(math.cos(math.rad(Degrees)) * CircleRadius, 1, math.sin(math.rad(Degrees))* CircleRadius)
end

function GetPet(Player, PetID)
	for _,Pet in workspace.PlayerPets[Player.Name]:GetChildren() do
		if Pet:IsA("Model") then
			if tonumber(Pet.Name) == PetID then
				return Pet
			end
		end
	end
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

Remotes.plrWalk.OnServerEvent:Connect(function(Player, State)
	Player.Data:FindFirstChild("isWalking").Value = State
end)

PetAction.OnServerInvoke = function(Player,Action,Args)
	if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
		if Args == nil then return end
		
		if Action == "Equip" then
			local EquippedPets = CheckEquips(Player.Pets)
			
			for _, PetID in Args do
				local Pet = Player.Pets[PetID]

				if Pet.Equipped.Value then
					Pet.Equipped.Value = false
					Player.Data.PetsEquipped.Value -= 1
					Player.PetMulti.Value -= Pet.Multiplier1.Value
					local CandyCornMulti = (2 ^ (Pet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
					Player.PetMulti4.Value -= CandyCornMulti

					if Content.Enchantments[Pet.Enchantment.Value] then
						if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
							Player.PetMulti2.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost
						elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
							Player.PetMulti3.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost * Pet.Multiplier1.Value
						end
					end
					
					EquippedPets -= 1
				else
					if EquippedPets >= Multipliers.GetMaxPetsEquipped(Player) then continue end
					
					Pet.Equipped.Value = true
					Player.Data.PetsEquipped.Value += 1
					EquippedPets += 1

					if Content.Pets[Pet.PetName.Value].Multiplier ~= "???" then
						Player.PetMulti.Value += Pet.Multiplier1.Value
						print((Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier))
						local CandyCornMulti = (2 ^ (Pet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
						Player.PetMulti4.Value += CandyCornMulti
					else
						local SortedPets = {}

						for _, Pet in Player.Pets:GetChildren() do
							table.insert(SortedPets, {Pet.Multiplier1.Value, Pet})
						end

						table.sort(SortedPets, function(a,b)
							return a[1] > b[1]
						end)
						Pet.Multiplier1.Value = SortedPets[1][1]
						Player.PetMulti.Value += Pet.Multiplier1.Value
						print((Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier))
						local CandyCornMulti = (2 ^ (Pet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
						Player.PetMulti4.Value += CandyCornMulti
					end
					
					if Content.Enchantments[Pet.Enchantment.Value] then
						if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
							Player.PetMulti2.Value += Content.Enchantments[Pet.Enchantment.Value].Boost
						elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
							Player.PetMulti3.Value += Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
						end
					end
				end
			end
			
			LoadEquipped(Player)
			
			return "Succes"
		elseif Action == "Delete" then
			local suc,er = pcall(function()
				local Pet = Player.Pets[Args]
				
				if Pet.Locked.Value then return end
				
				if Pet.Equipped.Value then
					Player.Data.PetsEquipped.Value -= 1
					Player.PetMulti.Value -= Pet.Multiplier1.Value
					local CandyCornMulti = (2 ^ (Pet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
					Player.PetMulti4.Value -= CandyCornMulti

					if Content.Enchantments[Pet.Enchantment.Value] then
						if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
							Player.PetMulti2.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost
						elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
							Player.PetMulti3.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
						end
					end
				end

				Pet:Destroy()

				LoadEquipped(Player)
			end)

			if suc then
				return "Succes"
			else
				return "Error", er
			end
		elseif Action == "Craft" then
			local Pet = Player.Pets:FindFirstChild(Args)
			
			if Pet == nil then return end
			if Pet.Locked.Value or Player.Trade.Value then return end
			if Pet.Type.Value >= 5 or Pet.Locked.Value then return end
			
			local CraftedPets = {}
			
			CraftedPets[#CraftedPets+1] = Pet.Name

			for _,PlayerPet in Player.Pets:GetChildren() do
				if PlayerPet.PetName.Value == Pet.PetName.Value and PlayerPet.Name ~= Pet.Name and PlayerPet.Type.Value == Pet.Type.Value and PlayerPet.Locked.Value == false then
					CraftedPets[#CraftedPets+1] = PlayerPet.Name
				end
			end

			if #CraftedPets >= 5 then
				for i = 2,5 do
					local PlayerPet = Player.Pets[CraftedPets[i]]

					if PlayerPet.Equipped.Value then
						PlayerPet.Equipped.Value = false
						Player.Data.PetsEquipped.Value -= 1
						Player.PetMulti.Value -= PlayerPet.Multiplier1.Value
						local CandyCornMulti = (2 ^ (Pet.Type.Value+ 1)) * Content.Pets[Pet.PetName.Value].Type and (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
						Player.PetMulti4.Value -= CandyCornMulti

						if Content.Enchantments[Pet.Enchantment.Value] then
							if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
								Player.PetMulti2.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost
							elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
								Player.PetMulti3.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
							end
						end
					end

					PlayerPet:Destroy()
				end

				local UpdatedPet = Pet:Clone()

				if Pet.Equipped.Value then
					Player.PetMulti.Value -= Pet.Multiplier1.Value
					local CandyCornMulti = (2 ^ (UpdatedPet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
					Player.PetMulti4.Value -= CandyCornMulti

					if Content.Enchantments[Pet.Enchantment.Value] then
						if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
							Player.PetMulti2.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost
						elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
							Player.PetMulti3.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
						end
					end
				end

				Pet:Destroy()

				UpdatedPet.Type.Value += 1
				UpdatedPet.Multiplier1.Value *= 2
				UpdatedPet.Parent = Player.Pets

				if UpdatedPet.Equipped.Value then
					Player.PetMulti.Value += UpdatedPet.Multiplier1.Value
					local CandyCornMulti = (2 ^ (UpdatedPet.Type.Value+ 1))  * (Content.Pets[Pet.PetName.Value].Type and Content.Pets[Pet.PetName.Value].Multiplier.CandyMultiplier or 0)
					Player.PetMulti4.Value += CandyCornMulti

					if Content.Enchantments[Pet.Enchantment.Value] then
						if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then
							Player.PetMulti2.Value += Content.Enchantments[Pet.Enchantment.Value].Boost
						elseif Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then
							Player.PetMulti3.Value += Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
						end
					end
				end

				RS.Pets.Exist.Server[UpdatedPet.Type.Value.." "..UpdatedPet.PetName.Value].Value += 1

				LoadEquipped(Player)
			end

			return "Succes"
		elseif Action == "Lock" then
			local Pet = Player.Pets[Args]

			Pet.Locked.Value = not Pet.Locked.Value
			return "Succes"
		elseif Action == "Enchant" then
			local Pet = Player.Pets:FindFirstChild(Args)
			
			if Pet == nil then print(Args) return end
			if Player.World.Value ~= "Medieval" then warn(Player.Name.." just tried to enchant in medieval from world "..Player.World.Value) return end
			
			if Player.Data.Gems.Value >= 2.5e4 then
				Player.Data.Gems.Value -= 2.5e4
				
				local function getEnchant()
					local RNG = Random.new(); -- You could use math.random, this is just what I chose.
					local Counter = 0;
					for i, v in Content.Enchantments do
						Counter += Content.Enchantments[i]["Rarity"]
					end
					
					local Chosen = RNG:NextNumber(0, Counter);
					for i, v in Content.Enchantments do
						Counter -= Content.Enchantments[i]["Rarity"]
						if Chosen > Counter then
							return i
						end
					end
				end
				
				local SelectedEnchantment = getEnchant()
				
				--// If it's equipped, adjust gem multis
				if Pet.Equipped.Value and Content.Enchantments[Pet.Enchantment.Value] then
					--// Gems
					if Content.Enchantments[Pet.Enchantment.Value].Type == "GP" then -- equipped pet had gem multi
						Player.PetMulti2.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost
					end
					
					if Content.Enchantments[SelectedEnchantment].Type == "GP" then -- equipped pet and should add gem multi
						Player.PetMulti2.Value += Content.Enchantments[SelectedEnchantment].Boost
					end
					
					--// Pet Power
					
					if Content.Enchantments[Pet.Enchantment.Value].Type == "PP" then -- equipped pet had pet multi
						Player.PetMulti3.Value -= Content.Enchantments[Pet.Enchantment.Value].Boost* Pet.Multiplier1.Value
					end

					if Content.Enchantments[SelectedEnchantment].Type == "PP" then -- equipped pet and should add pet multi
						Player.PetMulti3.Value += Content.Enchantments[SelectedEnchantment].Boost* Pet.Multiplier1.Value
					end
				end
				
				Pet.Enchantment.Value = SelectedEnchantment
			end
			
			return "Succes", "Your pet now has "..Pet.Enchantment.Value
		end
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil

	if Player.Parent == nil then return end

	local PetFolder = Player.Pets

	local Folder = Instance.new("Folder", workspace.PlayerPets)
	Folder.Name = Player.Name

	local Character = Player.Character

	Player.Pets.ChildRemoved:Connect(function()
		Player.Data.PetsOwned.Value = #Player.Pets:GetChildren()
	end)

	LoadEquipped(Player)	
end)

game.Players.PlayerRemoving:Connect(function(Player)
	workspace.PlayerPets:FindFirstChild(Player.Name):Destroy()
end)

-- Global Pet Float

local maxFloat = .6
local floatInc = 0.025
local sw = false
local fl = 0

spawn(function() 
	while true do
		wait()
		if not sw then
			fl = fl + floatInc
			if fl >= maxFloat then
				sw = true
			end
		else
			fl = fl - floatInc
			if fl <=-maxFloat then
				sw = false
			end
		end
		RS.globalPetFloat.Value = fl
	end
end)