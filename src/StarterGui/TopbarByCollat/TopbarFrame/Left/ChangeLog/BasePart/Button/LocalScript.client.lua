local Player = game.Players.LocalPlayer
local MainUI = Player.PlayerGui:WaitForChild("Rank Simulator X")
local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)

script.Parent.MouseButton1Click:Connect(function()
	Utilities.ButtonHandler.OnClick(MainUI.HUD.Frames.UpdateLog, UDim2.new(0.3,0,0.5,0))
end)