local PlayTimemodule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local MPS = game:GetService("MarketplaceService")

--// Variables

local Player = game.Players.LocalPlayer

local Playtime = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.PlaytimeRewards
local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD

local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)
local Content = require(RS.Modules.Shared.ContentManager)
local PlaytimeModule = Content.PlaytimeRewards


function UpdateGift(Gift)
	if Player.IngameTime.Value < PlaytimeModule[Gift].Milestone then
		Playtime.ScrollingFrame[Gift].Gift.Timer.Text = Utilities.Short.time(PlaytimeModule[Gift].Milestone-Player.IngameTime.Value)
	else
		if not Player.Gifts:FindFirstChild(Gift) then
			Playtime.ScrollingFrame[Gift].Gift.Timer.Text = "Ready!"
		else
			if Playtime.ScrollingFrame[Gift].Gift.Visible then
				Playtime.ScrollingFrame[Gift].Gift.Visible = false
				Playtime.ScrollingFrame[Gift].Reward.Visible = true
				Playtime.ScrollingFrame[Gift].Reward.Amount.Text = Utilities.Short.en(PlaytimeModule[Gift].Reward * require(RS.Modules.Shared.Multipliers).GetStarMultiplier(Player))
				Utilities.Audio.PlayAudio("Completed2")
			end
		end
	end
end


function PlayTimemodule:Init()
	
	Utilities.ButtonAnimations.Create(Playtime.Close)	
	Playtime.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Playtime)
	end)

	for i = 1,12 do
		local Clone = script.Frame:Clone()
		Clone.Parent = Playtime.ScrollingFrame
		Clone.Name = i

		Clone.Gift.TextButton.MouseButton1Click:Connect(function()
			Remotes.ClaimGift:FireServer(i)
			wait(0.1)
			UpdateGift(i)
		end)
	end


	Playtime.TextLabel.Text = #Player.Gifts:GetChildren().."/12 Gifts Claimed"

	Player.Gifts.ChildAdded:Connect(function()
		Playtime.TextLabel.Text = #Player.Gifts:GetChildren().."/12 Gifts Claimed"
	end)

	spawn(function()
		while task.wait(1) do
			for i = 1,12 do
				UpdateGift(i)
			end
		end
	end)
end

return PlayTimemodule
