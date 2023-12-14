--// Services

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")

--// Variables

local Modules = RS.Modules
local StarModule = require(Modules.Stars)
local Worlds = require(Modules.Worlds)
local Content = require(Modules.Shared.ContentManager)
local Multipliers = require(Modules.Shared.Multipliers)

local DespawnMin, DespawnMax = 600,1200

local MaxCombo = StarModule.Config.MaxCombo

local Stars = RS.Stars

--// Setup

local Spawners = {}
local Count = {}

for World,_ in StarModule.Spawns do
	Spawners[World] = workspace.SpawnZones:WaitForChild(World)
	Count[World] = 0
end

--// Star RNG
local function ChooseRandomStar(Area)
	local Chance = math.random() * 100
	local Selected = nil

	for i,v in StarModule.Spawns[Area].Stars do
		if v.Chance > Chance then
			Selected = i
		end
	end

	if Selected == nil then Selected = 1 end

	return Selected
end

--// Star Collection

local function GiveCandyCorn(Player,World,Tier)
	local Data = Player.Data
	local CornMultiplier = Multipliers.GetCandyCornMultiplier(Player,Tier)
	if Tier == 5 then
		Data["Secret Stars"].Value +=1
	end
	Data.CandyCorn.Value += CornMultiplier * Data.Combo.Value
	Data.TotalCandyCorn.Value  += CornMultiplier * Data.Combo.Value
	Player.Data["UgcStars"].Value += 1
	Player.Data.SeasonQuest4.Value += 1
	local AddedCombo = math.random(1,3)/100 * Tier
	if Data.Combo.Value + AddedCombo < MaxCombo + Content.Upgrades[7].Prices(Player.Data.Upgrade7.Value).Reward then
		Data.Combo.Value += AddedCombo
	else
		Data.Combo.Value = MaxCombo + Content.Upgrades[7].Prices(Player.Data.Upgrade7.Value).Reward
	end

	Player.ComboCountdown.Value = 2.5
end

local function GiveStars(Player,World,Tier)
	local Data = Player.Data
	local StarMultiplier = Multipliers.GetStarMultiplier(Player, Tier)
	print(Data.Stars.Value)
	Data.Stars.Value += StarMultiplier * Data.Combo.Value

	if Tier == 5 then 
		StarMultiplier *= Content.Perks[12].Prices(Player.Data.Perk12.Value).Reward 
		Data["Secret Stars"].Value += 1
	end
	Data["TotalStars"].Value += StarMultiplier * Data.Combo.Value

	Player.Data.SeasonQuest4.Value += 1
	Player.Data["UgcStars"].Value += 1 
	if World == "Forest" then Player.Data.SeasonQuest1.Value += 1 end

	local AddedCombo = math.random(1,3)/100 * Tier

	if Data.Combo.Value + AddedCombo < MaxCombo + Content.Upgrades[7].Prices(Player.Data.Upgrade7.Value).Reward then
		Data.Combo.Value += AddedCombo
	else
		Data.Combo.Value = MaxCombo + Content.Upgrades[7].Prices(Player.Data.Upgrade7.Value).Reward
	end

		Player.ComboCountdown.Value = 2.5
end

local function IsSpaceClear(Object)
	local objectsInSpace = workspace:GetPartBoundsInBox(Object.CFrame,Object.Size)

	for _,v in objectsInSpace do	
		if v.Name ~= "Ground" and v.Parent.Name ~= "SpawnZones" and v.Name ~= "Ignore" then
			return false
		end
	end

	return true
end

--// Object Spawning
local function SpawnObject(Object,Spawner)
	local FinalPos = Vector3.new(math.random(1,Spawner.Size.X)-Spawner.Size.X/2,Object.PrimaryPart.Size.Y/2-1, math.random(1,Spawner.Size.Z)-Spawner.Size.Z/2)
	local Angle = CFrame.Angles(math.rad(math.random(0,20)-10),math.rad(math.random(0,360)),math.rad(math.random(15,45)-30))
	Object:SetPrimaryPartCFrame(Spawner.CFrame * Angle + FinalPos)	

	if not IsSpaceClear(Object.PrimaryPart) then -- check if its not spawnign in different objects
		Object:Destroy()
		return false
	end

	Object.Parent = Spawner
	return true	
end

local function SpawnStar(World)
	task.spawn(function()
		--// CheckAvailable

		local Star = ChooseRandomStar(World)
		local NewStar = nil

		if StarModule.Spawns[World].Stars[Star].Type and StarModule.Spawns[World].Stars[Star].Type == "Gem" then
			NewStar = Stars[World].Gem:Clone()
		else
			NewStar = Stars[World][Star]:Clone()
		end

		if NewStar == nil then return end
		if not SpawnObject(NewStar,Spawners[World]) then return end

		if Star == 5 then -- secret star
			local Info = {Text = " A secret star just spawned in "..World, Color = Color3.fromRGB(255, 46, 46),Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18}
			RS.Remotes.SendMessage:FireAllClients(Info)
		end

		Count[World] += 1

		--// Collection

		local Touched = false

		NewStar.PrimaryPart.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChild("Humanoid") == nil then return end

			local Player = Players:GetPlayerFromCharacter(hit.Parent)

			if Player == nil or Player:FindFirstChild("Loaded") == nil or Player.Loaded.Value == false then return end

			if Player.World.Value ~= World then
				Player:Kick("Exploiting Detected")
				return
			end

			if (Player.Character.HumanoidRootPart.Position-NewStar.PrimaryPart.Position).Magnitude >= 18 then return end

			if Touched then return end    

			if Player.StarCD.Value then return end

			Player.StarCD.Value = true
			Touched = true
			if World == "Sinister Valley" then
				if NewStar.Name ~= "Gem" then
					GiveCandyCorn(Player,World,Star)
				else
					Player.Data.GemsCollected.Value += 1
					Player.Data.Gems.Value += StarModule.Spawns[World].Stars[Star].Multiplier * Multipliers.GetGemMultiplier(Player)
				end
			else
				if NewStar.Name ~= "Gem" then
					print(Player,World,Star)
					GiveStars(Player,World,Star)
					Player.Data.StarsCollected.Value += 1
				else
					if World == "Frosty" then Player.Data.SeasonQuest3.Value += 1 end
					Player.Data.GemsCollected.Value += 1
					Player.Data.Gems.Value += StarModule.Spawns[World].Stars[Star].Multiplier * Multipliers.GetGemMultiplier(Player)
				end
			end
		


			--// Fade out

			for _,Part in NewStar:GetChildren() do
				TS:Create(Part,TweenInfo.new(0.5),{Transparency = 1}):Play()
			end

			task.wait(0.04)

			Player.StarCD.Value = false

			task.wait(0.46)

			NewStar:Destroy()
			Count[World] -= 1
		end)

		task.wait(math.random(DespawnMin,DespawnMax))

		if NewStar.PrimaryPart ~= nil and Touched == false then
			NewStar:Destroy()
			Count[World] -= 1
		end
	end)
end

while task.wait(1) do
	local PlayerWorlds = {}

	--// Add all the player's worlds in a folder
	for _, Player in game.Players:GetPlayers() do
		if Player:FindFirstChild("World") then
			if not table.find(PlayerWorlds, Player.World.Value) then
				table.insert(PlayerWorlds, Player.World.Value)
			end
		end
	end

	for World in StarModule.Spawns do 
		if table.find(PlayerWorlds, World) then
			--// Only spawn if a player is in the world
			coroutine.wrap(function()
				for i = 1,50 do -- spawn 60 stars in that world
					if Count[World] >= StarModule.Spawns[World].MaxSpawn then break end -- end loop if max spawn
					SpawnStar(World)
					task.wait(0.02)
				end
			end)()
		end
	end
end