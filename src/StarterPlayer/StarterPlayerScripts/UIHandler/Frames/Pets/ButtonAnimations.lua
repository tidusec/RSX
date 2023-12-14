local module = {}

local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)

local Player = game.Players.LocalPlayer

local PetInventory = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Pets")
local LeftSide = PetInventory.LeftSide
local RightSide = PetInventory.RightSide

module.CreateAnimations = function()
	-- Sideframe buttons
	for _,Button in LeftSide.Buttons:GetChildren() do
		if Button:IsA("Frame") then
			Utilities.ButtonAnimations.Create(Button)
			
			Button.Clicker.MouseButton1Click:Connect(function()
				Utilities.Audio.PlayAudio("Click")
			end)
		end
	end
	
	-- Bottom buttons
	for _,Button in RightSide.Buttons:GetChildren() do
		if Button:IsA("Frame") then
			Utilities.ButtonAnimations.Create(Button)

			Button.Clicker.MouseButton1Click:Connect(function()
				Utilities.Audio.PlayAudio("Click")
			end)
		end
	end
			
	local MultiDeleteConfirm = LeftSide.MultiDeleteFrame.Delete
	
	Utilities.ButtonAnimations.Create(MultiDeleteConfirm)
	
	MultiDeleteConfirm.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
	end)

	-- confirm delete frame
	
	for _,Button in Player.PlayerGui["Rank Simulator X"].Popups.DeletePet.Buttons:GetChildren() do
		if Button:IsA("Frame") then
			Utilities.ButtonAnimations.Create(Button)

			Button.TextButton.MouseButton1Click:Connect(function()
				Utilities.Audio.PlayAudio("Click")
			end)
		end
	end
	
	-- X button
	
	Utilities.ButtonAnimations.Create(RightSide.Close)

	RightSide.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
	end)
end

return module
