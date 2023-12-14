--// Services

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Variables

local Disabled = false

local function PetMovement(Character, Pet)
	local Pos = Pet.Pos.Value
	if Character == nil then return end
	if not Character:FindFirstChild("HumanoidRootPart") then return end
	local Height = Character.HumanoidRootPart.Position.Y - Pet.PrimaryPart.Position.Y
	local BG = Pet.PrimaryPart.BodyGyro
	local BP = Pet.PrimaryPart.BodyPosition

	BP.Position = (Character.HumanoidRootPart.Position + Pos) - Vector3.new(0,Character.HumanoidRootPart.Size.Y/2,0) + Vector3.new(0,Pet.PrimaryPart.Size.Y/2,0) + Vector3.new(0,RS.globalPetFloat.Value,0)
	
	local Player = game.Players:GetPlayerFromCharacter(Character)
	
	if Player.Data.isWalking.Value == false then
		BG.CFrame = CFrame.new(Pet.PrimaryPart.Position, Character.HumanoidRootPart.Position - Vector3.new(0, Height, 0))
	else
		BG.CFrame = Character.HumanoidRootPart.CFrame
	end
end

local function Main()
	for _,PetsEquipped in workspace.PlayerPets:GetChildren() do
		if Players[PetsEquipped.Name].World.Value == game.Players.LocalPlayer.World.Value then
			for _,Pet in PetsEquipped:GetChildren() do
				PetMovement(Players[PetsEquipped.Name].Character, Pet)
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	Main()
end)