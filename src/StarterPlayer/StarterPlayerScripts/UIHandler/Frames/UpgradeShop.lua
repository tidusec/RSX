local UpgradeShopModule = {}
--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer


local UpgradesFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.UpgradeShop
local Scroll = UpgradesFrame.Upgrades.ScrollingFrame

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)

local Template = script.Upgrade

local function Green(Frame)
	local Gradient = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(188,255,155)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(188,255,155))
	})
	Frame.Upgrade.BackgroundColor3 = Color3.fromRGB(0,225,0)
	Frame.Upgrade.BorderStroke.Color = Color3.fromRGB(36,109,0)
	Frame.Upgrade.Click.TextStroke.Color = Color3.fromRGB(36,109,0)
	Frame.Upgrade.UIGradient.Color = Gradient
	Frame.Upgrade.Click.UIGradient.Color = Gradient
end

local function Red(Frame)
	local Gradient = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,155,155)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,155,155))
	})
	Frame.Upgrade.BackgroundColor3 = Color3.fromRGB(225, 48, 48)
	Frame.Upgrade.BorderStroke.Color = Color3.fromRGB(116,0,0)
	Frame.Upgrade.Click.TextStroke.Color = Color3.fromRGB(116,0,0)
	Frame.Upgrade.UIGradient.Color = Gradient
	Frame.Upgrade.Click.UIGradient.Color = Gradient
end

local function Gray(Frame)
	local Gradient = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(144,144,144)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(144,144,144))
	})
	Frame.Upgrade.BackgroundColor3 = Color3.fromRGB(120,120,120)
	Frame.Upgrade.BorderStroke.Color = Color3.fromRGB(70, 70, 70)
	Frame.Upgrade.Click.TextStroke.Color = Color3.fromRGB(70, 70, 70)
	Frame.Upgrade.UIGradient.Color = Gradient
	Frame.Upgrade.Click.UIGradient.Color = Gradient
end

local function UpdateTexts(Upgrade,Frame,Number)
	local UpgradeValue = Player.Data["Upgrade"..Number]

	if Upgrade.Max == "Unlockable" then
		Frame.Title.Text = Upgrade.Title.." ["..UpgradeValue.Value.."/1]"

		if UpgradeValue.Value == 0 then
			Frame.Boost.Text = "Locked"

			if Player.Data.Gems.Value >= Upgrade.Price then
				Green(Frame)
			else
				Red(Frame)
			end

			Frame.Upgrade.Click.Text = Utilities.Short.en(Upgrade.Price).." Gems"
		else
			Frame.Boost.Text = "Unlocked"
			Gray(Frame)
			Frame.Upgrade.Click.Text = "Unlocked"
		end
	else
		Frame.Title.Text = Upgrade.Title.." ["..UpgradeValue.Value.."/"..Upgrade.Max.."]"
		Frame.Boost.Text = string.format(Upgrade.Boost, Utilities.Short.en(Upgrade.Prices(UpgradeValue.Value).Reward), Utilities.Short.en(Upgrade.Prices(UpgradeValue.Value+1).Reward))

		if UpgradeValue.Value >= Upgrade.Max then
			Gray(Frame)

			Frame.Upgrade.Click.Text = "Max"
		else
			if Player.Data.Gems.Value >= Upgrade.Prices(UpgradeValue.Value).Price then
				Green(Frame)
			else
				Red(Frame)
			end

			Frame.Upgrade.Click.Text = Utilities.Short.en(Upgrade.Prices(UpgradeValue.Value).Price).." Gems"
		end
	end
end

function UpgradeShopModule:Init()
	Utilities.ButtonAnimations.Create(UpgradesFrame.Close)
	
	UpgradesFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(UpgradesFrame,UDim2.new(0,0,0,0))
	end)

	local DB = false

	for Number,Upgrade in Content.Upgrades do
		local UpgradeValue = Player.Data["Upgrade"..Number]
		local NewUpgrade = Template:Clone()
		NewUpgrade.Parent = Scroll

		UpdateTexts(Upgrade,NewUpgrade,Number)

		UpgradeValue.Changed:Connect(function()
			UpdateTexts(Upgrade,NewUpgrade,Number)
			Utilities.Audio.PlayAudio("Completed2")
		end)

		Player.Data.Gems.Changed:Connect(function()
			UpdateTexts(Upgrade,NewUpgrade,Number)
		end)

		NewUpgrade.Upgrade.Click.MouseButton1Click:Connect(function()
			if DB == false then
				DB = true
				Utilities.Audio.PlayAudio("Click")
				RS.Remotes.Upgrades:FireServer(Number)
				wait(0.1)
				DB = false
			end
		end)

		Utilities.ButtonAnimations.Create(NewUpgrade.Upgrade, 1.04, 0.075)
	end
end


return UpgradeShopModule
