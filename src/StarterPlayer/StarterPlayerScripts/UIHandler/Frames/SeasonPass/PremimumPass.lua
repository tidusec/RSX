local PremimumPassModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local Premiumpass = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.PremiumPassBuy
local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD

local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)

local function HasOwned()
	if Player.Data.PremiumPass.Value then
		Premiumpass.PurchaseButton.Price.Text = "Owned"
	else
		Premiumpass.PurchaseButton.Price.Text = "399R$"
	end
end


function PremimumPassModule:Init()
	Utilities.ButtonAnimations.Create(Premiumpass.Close)
	
	HasOwned()

	Premiumpass.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Premiumpass, UDim2.new(0,0,0,0))
	end)

	Premiumpass.LeftBar.PremiumButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
	end)

	Premiumpass.LeftBar.QuestButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.SeasonpassQuests, UDim2.new(0.45,0,0.7,0))
	end)

	Premiumpass.LeftBar.RewardsButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.SeasonPass, UDim2.new(0.45,0,0.7,0))
	end)

	Player.Data.PremiumPass.Changed:Connect(function()
		HasOwned()
	end)

	Premiumpass.PurchaseButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")

		if not Player.Data.PremiumPass.Value then 
			game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1569342785)
		end
	end)
end


return PremimumPassModule
