local Starterpackmodule = {}
--// Services

local RS = game:GetService("ReplicatedStorage")
local MPS = game:GetService("MarketplaceService")

--// Variables

local Player = game.Players.LocalPlayer


local Starterpack = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.StarterPack
local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD

local Utilities = require(RS.Modules.Client.Utilities)

local EndTime = Player.Data.Starterpack

local function SetPetSlot(Viewport,Pet)
	local PetModel = RS.Pets.Models:FindFirstChild(Pet):Clone()
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-1,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
end


function Starterpackmodule:Init()
	
	Utilities.ButtonAnimations.Create(Starterpack.Close)
	
	SetPetSlot(Starterpack.PackOption2.Pet, "Frozen Unicorn")

	Starterpack.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Starterpack)
	end)

	Starterpack.PurchaseButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		MPS:PromptProductPurchase(Player, 1544559894)
	end)

	spawn(function()
		while wait(1) do
			if os.time() < EndTime.Value then
				Starterpack.Timer.Text = Utilities.Short.time(EndTime.Value-os.time())
			end
		end
	end)
end

return Starterpackmodule
