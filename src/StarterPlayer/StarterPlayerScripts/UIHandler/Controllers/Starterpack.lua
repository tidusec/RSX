local StarterPackModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer


local Starterpack = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Starterpack
local HUD = Starterpack.Parent
local Frames = HUD.Frames

local Utilities = require(RS.Modules.Client.Utilities)

local EndTime = Player.Data.Starterpack

function StarterPackModule:Init()

	if os.time() < EndTime.Value then
		Starterpack.Visible = true
		Starterpack.Timer.Text = Utilities.Short.time(EndTime.Value-os.time())

		Starterpack.Click.MouseButton1Click:Connect(function()
			Utilities.ButtonHandler.OnClick(Frames.StarterPack, UDim2.new(0.552,0,0.6,0))
		end)
	else
		Starterpack:Destroy()
	end

	task.spawn(function()
		while wait(1) do
			if os.time() < EndTime.Value then
				Starterpack.Timer.Text = Utilities.Short.time(EndTime.Value-os.time())
			else	
				Starterpack:Destroy()
			end
		end
	end)
end

return StarterPackModule
