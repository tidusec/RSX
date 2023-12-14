--// Services

local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local PLRS = game:GetService("Players")
local MS = game:GetService("MessagingService")

--// Variables

local Modules = RS:WaitForChild("Modules")
local Content = require(Modules.Shared.ContentManager)
local Multipliers = require(Modules.Shared.Multipliers)

local Library = RS.Pets

local RemoteEvents = RS.Remotes
local PetActionEvent = RemoteEvents.EggOpened

local EggModels = workspace.Eggs

local function GetRarity(Pet)
	return Content.Pets[Pet].Rarity
end

local Cooldown = {}

function SecretBroadcast(User, Pet, Type)
	local BroadcastMessage
	
	if Type == 0 then
		BroadcastMessage = User.Name.." just hatched a Secret "..Pet
	else
		BroadcastMessage = User.Name.." just hatched a Secret "..Type.." Star "..Pet
	end
	
	MS:PublishAsync("Secret Hatch", BroadcastMessage)
end

function ChoosePet(Egg, player)
	local Data = Content.Eggs[Egg]
	local PetList = Data["Pets"]
	local AllPets = {}
	local TotalWeight = 0		
	local LuckBoost = Multipliers.GetLuckBoost(player)
	local SecretBoost = Multipliers.GetSecretLuckBoost(player)
	
	--// Add Pets to Chances
	for _,v in PetList do
		AllPets[#AllPets + 1] = {Name = v.Name,Rarity = v.Rarity}
		TotalWeight += v.Rarity
	end
	
	table.sort(AllPets, function(a,b)
		return (a.Rarity < b.Rarity)
	end)

	local Chance = Random.new():NextNumber(0,TotalWeight)
	if TotalWeight <= 0  then
		TotalWeight += 1
	end
	
	--// Select Pet
	
	local Counter = 0
	for _,v in AllPets do	
		local PetRarity = Content.Pets[v.Name].Rarity
		if PetRarity == "Legendary" then
			Counter += v.Rarity * LuckBoost
		elseif PetRarity == "Secret" then
			Counter += v.Rarity * SecretBoost
		else
			Counter += v.Rarity
		end
				
		if Counter >= Chance then
			return v.Name
		end
	end
end

function totalPets(Player)
	return #Player.Pets:GetChildren()
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

function BuyEgg(Player, Egg)
	local EggInfo = Content.Eggs[Egg]
	local PetChosen = ChoosePet(Egg,Player)
		
	if EggInfo.Currency ~= "Robux" then
		Player.Data[EggInfo.Currency].Value -= EggInfo.Cost
		Player.Data["Eggs Opened"].Value += 1
	end
	
	local Type = 0
	
	if Player.Data.MagicEggs.Value and math.random() <= 0.1 then
		Type = 1
	end
	
	local ToReturn = {PetChosen,Type,false,false}
	
	RS.Pets.Exist.Server[Type.." "..PetChosen].Value += 1
	Player.Data["UgcEggs"].Value += 1
	
	if Player.World.Value == "Sinister Valley" then
		Player.Data.HalloweenEggs.Value += 1
	end
	
	if not Player.AutoDelete[PetChosen].Value or Content.Pets[PetChosen].Rarity == "Secret" then
		local Clone = RS.Pets.PetTemplate:Clone()
		Clone.PetName.Value = PetChosen
		Clone.Type.Value = Type 
		Clone.Parent = Player.Pets
		Clone.Name = RandomID(Player)
		Clone.Locked.Value = false
		
		if Content.Pets[PetChosen].Type  then
			Clone.Multiplier1.Value = Content.Pets[PetChosen].Multiplier.Multiplier  * (2 ^ Type)-- * (1 + math.random(1,100)/100-0.05)
		else
			Clone.Multiplier1.Value = Content.Pets[PetChosen].Multiplier * (2 ^ Type)
		end
		Player.Data.PetsOwned.Value += 1
			
		
		if Content.Pets[PetChosen].Rarity == "Secret" then
			local Info = {Text = Player.Name.." just hatched a Secret "..PetChosen, Color = Color3.fromRGB(255, 0, 0),Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18}
			--RS.Remotes.SendMessage:FireAllClients(Info)
			ToReturn[4] = "Secret"
		elseif Content.Pets[PetChosen].Rarity == "Rare" then
			Player.Data.SeasonQuest2.Value += 1
		end
	end
	
	local suc,er = spawn(function()
		if Content.Pets[PetChosen].Rarity == "Secret" then
			Player.Data["Secrets Hatched"].Value += 1
			SecretBroadcast(Player,PetChosen,Type)
			require(script.Webhook).SecretMessage(Player,PetChosen, Type)
		end
	end)
	
	if er then print(er) end
		
	return ToReturn
end

local function IsInGroup(Player, Group)
	pcall(function()
		if Player:IsInGroup(12554523) then
			return true
		end
	end)
	
	return false
end

function EggRequest(Player, Egg, Type)
	if Content.Eggs[Egg] ~= nil then
		local EggInfo = Content.Eggs[Egg]
		local Model = EggModels:FindFirstChild(Egg)
		if (Player.Character.HumanoidRootPart.Position - Model.Egg.PrimaryPart.Position).Magnitude <= 15 then
			if EggInfo.Currency ~= "R$" then
				if Player.Data[EggInfo.Currency].Value >= EggInfo.Cost * Type then
					
					if totalPets(Player) + Type <= Multipliers.GetMaxPetStorage(Player) then
						if Type == 3 and Player:IsInGroup(12554523) or Type == 1 then
							if Cooldown[Player.Name] == false then
								Cooldown[Player.Name] = true
								local PetsChosen = {}							

								if Player.World.Value ~= EggInfo.World then
									Player:Kick("Exploits detected (Egg "..Egg..")")
								end

								for i = 1,Type do
									local PetChosen = BuyEgg(Player,Egg)
									PetsChosen[i] = PetChosen

									if not Player.Index:FindFirstChild(PetChosen[1]) then
										local NewVal = Instance.new("IntValue",Player.Index)
										NewVal.Value = 1
										NewVal.Name = PetChosen[1]
										PetChosen[3] = true
									else
										Player.Index[PetChosen[1]].Value += 1
									end
									
									if Player.EggCombo.Value < Multipliers.GetMaxLuckCombo(Player) then
										Player.EggCombo.Value += 0.0001
									end
								end

								local suc,er = spawn(function()
									task.wait(Multipliers.GetHatchSpeed(Player))
									Cooldown[Player.Name] = false
								end)

								if er then warn(er) end

								return PetsChosen
							end
						end
					else
						return "Error", "Not Enough Inventory Storage"
					end
				else
					return "Error", "Not Enough Currency"
				end
			else
				-- robux
				if totalPets(Player) < Multipliers.GetMaxPetStorage(Player) then
					return "Error", "Robux Purchase"
				else
					return "Error", "Not Enough Inventory Storage"
				end
			end
		end
	else
		return "Error", "Too far away"
	end
end



PLRS.PlayerAdded:Connect(function(plr)
	Cooldown[plr.Name] = false
	
end)

PLRS.PlayerRemoving:Connect(function(plr)
	plr.Data.LastLeft.Value = os.time()
	plr.Data.LuckCombo.Value = plr.EggCombo.Value
	Cooldown[plr.Name] = nil
end)

RemoteEvents.EggOpened.OnServerInvoke = function(...)
	return EggRequest(...)
end 