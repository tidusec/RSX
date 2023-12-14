--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer
local RankShopModule = {}

local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)
local Multipliers = require(Modules.Shared.Multipliers)

local Remotes = RS.Remotes

local RankShop = Player.PlayerGui["Rank Simulator X"]:WaitForChild("HUD").Frames.RankShop

local Rank = Player.Data.Rank

local function LoadLeft()
	RankShop.Main.RankBefore.Image = Content.Ranks[Rank.Value].RankImage
	RankShop.Main.StarsBefore.CoinLabel.Text = "x"..Utilities.Short.en(Content.Ranks[Rank.Value].Boost * Content.Perks[4].Prices(Player.Data.Perk4.Value).Reward)
end

local function GetSkipInfo()
	local MaxRankSkips = Content.Perks[9].Prices(Player.Data.Perk9.Value).Reward
	local Cost, Gems, Skips = 0,0,0

	for i = 1, MaxRankSkips do
		local RankInfo = Content.Ranks[Player.Data.Rank.Value + i]

		if RankInfo == nil then break end

		if Player.Data.Stars.Value >= Cost + RankInfo.Cost or i == 1 then
			Cost += RankInfo.Cost
			Gems += RankInfo.Gems
			Skips += 1
		else
			break
		end
	end

	return Cost, Gems, Skips
end

local function LoadRight()
	local Cost, Gems, Skips = GetSkipInfo()

	if Skips >= 2 then
		RankShop.Main.Rewards.Skips.Visible = true
		RankShop.Main.Rewards.Skips.SkipsLabel.Text = "Skipping "..Skips.." Ranks"
	else
		RankShop.Main.Rewards.Skips.Visible = false
	end

	RankShop.Main.BuyButton.Cost.TextLabel.Text = Utilities.Short.en(Cost)
	RankShop.Main.Rewards.Gems.GemLabel.Text = "+"..Utilities.Short.en(Gems * Multipliers.GetGemMultiplier(Player))
	RankShop.Main.StarsAfter.CoinLabel.Text = "x"..Utilities.Short.en(Content.Ranks[Rank.Value+Skips].Boost * Content.Perks[4].Prices(Player.Data.Perk4.Value).Reward)
	RankShop.Main.RankAfter.Image = Content.Ranks[Rank.Value+Skips].RankImage
end

local function Main()
	LoadLeft()
	LoadRight()

	Rank.Changed:Connect(function()
		LoadLeft()
		LoadRight()
	end)

	Player.Data.Stars.Changed:Connect(function()
		if RankShop.Visible == true then
			LoadRight()
		end
	end)

	RankShop:GetPropertyChangedSignal("Visible"):Connect(function()
		LoadRight()
	end)

	--// Gems

	Player.Data["x2GemsBoost"].Changed:Connect(function()
		LoadRight()
	end)

	Player.Data.Upgrade3.Changed:Connect(function()
		LoadRight()
	end)

	Player.Data.Perk2.Changed:Connect(function()
		LoadRight()
	end)

	Player.Data.Perk4.Changed:Connect(function()
		LoadRight()
	end)
end


function RankShopModule:Init()

	Main()
	--// Buy Button
	Utilities.ButtonAnimations.Create(RankShop.Main.BuyButton, 1.05, 0.075)
	Utilities.ButtonAnimations.Create(RankShop.Close)

	RankShop.Main.BuyButton.Click.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Remotes.BuyRank:FireServer()
	end)


	Utilities.ButtonAnimations.Create(RankShop.Close)
	RankShop.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(RankShop,UDim2.new(0,0,0,0))
	end)
end
return RankShopModule