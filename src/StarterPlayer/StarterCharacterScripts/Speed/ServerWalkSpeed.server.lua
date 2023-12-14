local MainFolder = script.Parent

repeat wait() until MainFolder.Parent:IsA("Model")

local Character = MainFolder.Parent
local Player = game.Players:GetPlayerFromCharacter(Character)

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil

if Player.Parent == nil then return end

local Remote = MainFolder.WalkSpeedConnection

local Data = Player.Data

local RS = game:GetService("ReplicatedStorage")
local Multipliers = require(RS.Modules.Shared.Multipliers)

Character.Humanoid.WalkSpeed = Multipliers.GetMaxWalkspeed(Player)

Data.Upgrade6.Changed:Connect(function()
	Character.Humanoid.WalkSpeed = Multipliers.GetMaxWalkspeed(Player)
end)

Data.Achievement2.Changed:Connect(function()
	Character.Humanoid.WalkSpeed = Multipliers.GetMaxWalkspeed(Player)
end)

Remote.OnServerEvent:Connect(function(Target, Speed)
	if Target.Name == Player.Name then
		if Speed >= Character.Humanoid.WalkSpeed + 10 then
			Target:Kick("Exploiting")
		end
	end
end)