local Teleportmodule = {}

--// Services

local PLRS = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = PLRS.LocalPlayer


local Modules = RS.Modules
local Worlds = require(Modules.Worlds)
local Utilities = require(Modules.Client.Utilities)

local TeleportUI = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.Teleport
local Content = TeleportUI .List

local function CanAffordWorld(World)
	return Player.Data.Rank.Value >= World.Requirement
end

function Teleportmodule:Init()
	Utilities.ButtonAnimations.Create(TeleportUI.Close)	
	
	TeleportUI .Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(TeleportUI ,UDim2.new(0,0,0,0))
	end)


	for WorldName,WorldInfo in Worlds do
		if Content:FindFirstChild(WorldName) then
			if not CanAffordWorld(WorldInfo) then
				Content[WorldName].Darken.Visible = true
			end

			Content[WorldName].TeleportButton.MouseButton1Click:Connect(function()
				RS.Remotes.Teleport:InvokeServer(WorldName)				
			end)

			spawn(function()
				while wait(3) do
					if CanAffordWorld(WorldInfo) then
						Content[WorldName].Darken.Visible = false
					else
						Content[WorldName].Darken.Visible = true
					end
				end
			end)

		else
			print(WorldName.." does not exist in teleport Gui!")
		end
	end
end

return Teleportmodule
