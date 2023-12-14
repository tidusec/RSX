local Achievment = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local Remotes = RS.Remotes
local Modules = RS.Modules

local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)

local AchievementFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Achievements")
local Scroll = AchievementFrame.WhiteBorder.Holder.ScrollingFrame



function UpdateClaim(Color,Button)
	if Color == "Green" then
		Button.BackgroundColor3 = Color3.fromRGB(13, 225, 13)
		Button.BorderStroke.Color = Color3.fromRGB(36, 109, 0)
		Button.TextStroke.Color = Color3.fromRGB(36, 109, 0)
		Button.UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.737255, 1, 0.607843)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.737255, 1, 0.607843))
		})
		Button.Text = "Claim"
	elseif Color == "Red" then
		Button.BackgroundColor3 = Color3.fromRGB(225, 13, 13)
		Button.BorderStroke.Color = Color3.fromRGB(109, 0, 0)
		Button.TextStroke.Color = Color3.fromRGB(109, 0, 0)
		Button.UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 0.592157, 0.592157)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 0.592157, 0.592157))
		})
		Button.Text = "Claim"
	elseif Color == "Gray" then
		Button.BackgroundColor3 = Color3.fromRGB(144, 144, 144)
		Button.BorderStroke.Color = Color3.fromRGB(65, 65, 65)
		Button.TextStroke.Color = Color3.fromRGB(65, 65, 65)
		Button.UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.67451, 0.67451, 0.67451)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.67451, 0.67451, 0.67451))
		})
		Button.Text = "Maxed"
	end
end

function update(Achievement, Template)
	local val = Player.Data["Achievement"..Achievement]
	local info = Content.Achievements[Achievement]
	local ST = info.ShorteningType
	local requirement = Player.Data[info.RequiredStat]

	if val.Value + 1 > #info.Prices then
		Template.Current.Text = info.Reward[#info.Reward].. info.ProgressText
		Template.Reward.Text = "Max"
		Template.Title.Text =  string.format(info.Title, "")
		Template.ProgressBarHolder.Bar.Size = UDim2.fromScale(1,1)
		Template.ProgressBarHolder.Percent.Text = ""
		UpdateClaim("Gray", Template.ClaimButton)
	else
		Template.Title.Text = string.format(info.Title, Utilities.Short[ST](info.Prices[val.Value]))
		Template.Current.Text = info.Reward[val.Value].. info.ProgressText
		Template.Reward.Text = info.Reward[val.Value+1].. info.ProgressText
		Template.ProgressBarHolder.Bar.Size = UDim2.fromScale(math.clamp(requirement.Value / info.Prices[val.Value],0,1),1)
		Template.ProgressBarHolder.Percent.Text = math.min(math.floor(requirement.Value / info.Prices[val.Value]*100),100).."%"

		if requirement.Value >= info.Prices[val.Value] then
			UpdateClaim("Green", Template.ClaimButton)
		else
			UpdateClaim("Red", Template.ClaimButton)
		end
	end

	Template.Parent = Scroll
end

function Achievment:Init()

	for i = 1,#Content.Achievements do
		local Template = script.Template:Clone()

		update(i, Template)
		
		Utilities.ButtonAnimations.Create(AchievementFrame.Close)
		
		AchievementFrame.Close.TextButton.MouseButton1Click:Connect(function()
			Utilities.Audio.PlayAudio("Click")
			Utilities.ButtonHandler.OnClick(AchievementFrame,UDim2.new(0,0,0,0))
		end)
		
		Player.Data["Achievement"..i].Changed:Connect(function()
			Utilities.Audio.PlayAudio("Achievement")
			update(i, Template)
		end)

		Template.ClaimButton.MouseButton1Click:Connect(function()
			Remotes.CompleteAchievement:FireServer(i)
		end)

		Player.Data[Content.Achievements[i].RequiredStat].Changed:Connect(function()
			update(i, Template)
		end)
	end
end



return Achievment
