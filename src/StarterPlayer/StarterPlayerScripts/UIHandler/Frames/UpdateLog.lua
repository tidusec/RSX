local UpdateLogModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local Utilities = require(RS.Modules.Client.Utilities)
local Changelog = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.UpdateLog

function UpdateLogModule:Init()
	Utilities.ButtonAnimations.Create(Changelog.Close)	
	Changelog.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Changelog,UDim2.new(0,0,0,0))
	end)
end

return UpdateLogModule
