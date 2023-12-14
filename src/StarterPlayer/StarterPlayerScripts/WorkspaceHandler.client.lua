--// Services

local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local PL = game:GetService("Players")
local TS = game:GetService("TweenService")

--// Variables

local Player = PL.LocalPlayer
local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)

local function HideMyPets(Val)
	if Val then
		WS.PlayerPets:WaitForChild(Player.Name).Parent = RS.HiddenPets
		-- hide your pets
	else
		if RS.HiddenPets:FindFirstChild(Player.Name) then
			RS.HiddenPets[Player.Name].Parent = WS.PlayerPets
		end
		-- unhide your pets
	end
end

function TweenModel(EndCFrame,TI,Model)
	local NewCFrameValue = Instance.new("CFrameValue")
	NewCFrameValue.Value = Model.PrimaryPart.CFrame
	local Tween = TS:Create(NewCFrameValue,TI,EndCFrame)
	local Connection

	Connection = NewCFrameValue.Changed:Connect(function()
		if Model.PrimaryPart == nil then return end
		Model:PivotTo(NewCFrameValue.Value)
	end)

	Tween:Play()

	Tween.Completed:Connect(function()
		NewCFrameValue:Destroy()
		Connection:Disconnect()
	end)
end

local function HideAllPets(Val)
	if Val == true then
		for _,PlayerPet in WS.PlayerPets:GetChildren() do
			if PlayerPet.Name ~= Player.Name then
				PlayerPet.Parent = RS.HiddenPets
			end 
		end
	else
		for _,PlayerPet in RS.HiddenPets:GetChildren() do
			if PlayerPet.Name ~= Player.Name then
				PlayerPet.Parent = WS.PlayerPets
			end 
		end
	end
end

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value

HideMyPets(Player.Data.HideMyPets.Value)
HideAllPets(Player.Data.HideAllPets.Value)

Player.Data.HideMyPets.Changed:Connect(function()
	HideMyPets(Player.Data.HideMyPets.Value)
end)

Player.Data.HideAllPets.Changed:Connect(function()
	HideAllPets(Player.Data.HideAllPets.Value)
end)

PL.PlayerAdded:Connect(function(NewPlayer)
	repeat wait() until NewPlayer:FindFirstChild("Loaded") and NewPlayer.Loaded.Value or NewPlayer.Parent == nil
	
	if NewPlayer.Parent == nil then return end
	
	HideAllPets(Player.Data.HideAllPets)
end)

--// Floating Eggs

for _,v in workspace.Eggs:GetChildren() do
	if v:IsA("Model") then
		TweenModel({Value = v.PrimaryPart.CFrame + Vector3.new(0,1,0)},TweenInfo.new(2.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,-1,true,0.02),v.Egg)
	end
end

--// Index

local IndexRing = workspace.Rings.Index
local Counter = IndexRing.MainPart.BillboardGui.Counter

local TotalPets = 0

for _,Pet in Content.Pets do
	if Pet.Rarity ~= "Special" then
		TotalPets += 1
	end
end

local function GetOwnedPets()
	local Amount = 0
	
	for _,IndexPets in Player.Index:GetChildren() do
		local PetRarity = Content.Pets[IndexPets.Name].Rarity
		if PetRarity ~= "Special" and PetRarity ~= nil then
			Amount += 1
		end
	end
	
	return Amount
end

Counter.Text = GetOwnedPets() .. "/" .. TotalPets

Player.Index.ChildAdded:Connect(function()
	Counter.Text = GetOwnedPets() .. "/" .. TotalPets
end)

--// Star Spawn

local function CreateAnimation(Star)
	repeat task.wait() until Star == nil or #Star:GetChildren() > 0
	
	if Star == nil then return end
	
	local Spawner = Star.Parent
	Star:SetPrimaryPartCFrame(Star.PrimaryPart.CFrame + Vector3.new(0,10,0))
	
	
	TweenModel({Value = Star.PrimaryPart.CFrame - Vector3.new(0, 10, 0)},TweenInfo.new(0.6,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),Star)

	for _,Part in Star:GetChildren() do
		local Goal = Part.Size
		Part.Size = Vector3.new(0,0,0)
		TS:Create(Part,TweenInfo.new(0.2,Enum.EasingStyle.Bounce,Enum.EasingDirection.In),{Size = Goal}):Play()
	end
end

local Connection

Connection = workspace.SpawnZones[Player.World.Value].ChildAdded:Connect(CreateAnimation)

Player.World.Changed:Connect(function()
	if Connection then
		Connection:Disconnect()
	end

	Connection = workspace.SpawnZones[Player.World.Value].ChildAdded:Connect(CreateAnimation)
end)

--// Walkspeed

local function MaxWalkSpeed()
	return Player.Data.Upgrade6.Value + 20
end

local Remote = Player.Character:WaitForChild("Speed").WalkSpeedConnection

Player.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	if Player.Character.Humanoid.WalkSpeed > MaxWalkSpeed() + 3 then
		Remote:FireServer(Player.Character.Humanoid.WalkSpeed)
	end
end)