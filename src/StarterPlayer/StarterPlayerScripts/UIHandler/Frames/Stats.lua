--// Services

local RS = game:GetService("ReplicatedStorage")
local StatModule = {}
--// Variables

local Player = game.Players.LocalPlayer

local Modules = RS.Modules
local StatsModule = require(Modules.GuiModules.Stats)
local Utilities = require(Modules.Client.Utilities)

local StatsFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.Stats
local List = StatsFrame.List

local Remotes = RS.Remotes


function StatModule:Init()
	Utilities.ButtonAnimations.Create(StatsFrame.Close)	

	StatsFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(StatsFrame,UDim2.new(0,0,0,0))
	end)

	for Order,StatInfo in StatsModule do
		local Frame = script.Stat:Clone()
		Frame.Parent = List

		Frame.Text.Text = StatInfo.Display

		if StatInfo.StatName == "Date Joined" then
			Frame.Amt.Text = Player.Data[StatInfo.StatName].Value
		elseif StatInfo.StatName == "Time" then
			Frame.Amt.Text = Utilities.Short.time(Player.Data[StatInfo.StatName].Value)
		else
			Frame.Amt.Text = Utilities.Short.en(Player.Data[StatInfo.StatName].Value)
		end

		Player.Data[StatInfo.StatName].Changed:Connect(function()
			if StatInfo.StatName == "Date Joined" then
				Frame.Amt.Text = Player.Data[StatInfo.StatName].Value
			elseif StatInfo.StatName == "Time" then
				Frame.Amt.Text = Utilities.Short.time(Player.Data[StatInfo.StatName].Value)
			else
				Frame.Amt.Text = Utilities.Short.en(Player.Data[StatInfo.StatName].Value)
			end
		end)
	end
end

return StatModule