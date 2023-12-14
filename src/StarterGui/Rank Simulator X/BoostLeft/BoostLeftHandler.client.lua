--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value

local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)

local BoostLeft = script.Parent

BoostLeft.Visible = true

for _,Frame in BoostLeft:GetChildren() do
	if Frame:IsA("Frame") then
		local BoostLeft = Player.Data["x2"..Frame.Name.."Boost"]

		if BoostLeft.Value > 0 then
			Frame.Visible = true
			Frame.TextLabel.Text = Utilities.Short.time(BoostLeft.Value)
		else
			Frame.Visible = false
		end
		
		BoostLeft.Changed:Connect(function()
			if BoostLeft.Value > 0 then
				Frame.Visible = true
				Frame.TextLabel.Text = Utilities.Short.time(BoostLeft.Value)
			else
				Frame.Visible = false
			end
		end)
	end
end
