local Seasonpass = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables
local Player = game.Players.LocalPlayer


local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)
local Rewards = require(RS.Modules.SeasonPassReward)
local Multipliers = require(RS.Modules.Shared.Multipliers)
local QuestModule = require(script.Quests):Init()
local PremimumPassModule = require(script.PremimumPass):Init()



local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD
local SeasonpassUI = HUD.Frames:WaitForChild("SeasonPass")

local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)
local Rewards = require(RS.Modules.SeasonPassReward)
local Multipliers = require(RS.Modules.Shared.Multipliers)

function Seasonpass:Init()
	Utilities.ButtonAnimations.Create(SeasonpassUI.Close)
	

	SeasonpassUI.PurchaseButton.MouseButton1Click:Connect(function()
		game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1577735030)
	end)

	SeasonpassUI.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(SeasonpassUI, UDim2.new(0,0,0,0))
	end)
	SeasonpassUI.LeftBar.PremiumButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.PremiumPassBuy, UDim2.new(0.45,0,587,0))
	end)

	SeasonpassUI.LeftBar.QuestButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.SeasonpassQuests, UDim2.new(0.45,0,0.7,0))
	end)

	SeasonpassUI.LeftBar.RewardsButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
	end)
end

local function SetTierLock(Slot, Tier) -- locks tiers depending on if you have them unlocked
	Slot.Lock.Visible = Player.Data.Tier.Value < Tier
	Slot.Shadow.Visible = Player.Data.Tier.Value < Tier
	Slot.Skip.Visible = Player.Data.Tier.Value + 1 == Tier
	Slot.Free.Checkmark.Visible = Player.Data.Tier.Value >= Tier
	Slot.Premium.Checkmark.Visible = Player.Data.Tier.Value >= Tier and Player.Data.PremiumPass.Value
end

local function ProgressText()
	if Player.Data.Tier.Value == 10 then
		SeasonpassUI.Progress.Text = Utilities.Short.en(Player.Data.XP.Value).."/".."Max XP"
	else
		SeasonpassUI.Progress.Text = Utilities.Short.en(Player.Data.XP.Value).. "/"..Utilities.Short.en((Player.Data.Tier.Value-1) * 50 + 100).." XP"
	end
end



local function SetPetSlot(Viewport,Pet)
	local PetModel = RS.Pets.Models:FindFirstChild(Pet):Clone()
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-3,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
end

local function HandleReward(Slot, Info)
	if Info.Type == "Stars" then
		Slot.Img.Visible = true
		Slot.Img.Image = "rbxassetid://11623114533"
		Slot.Amount.Visible = true
		Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetStarMultiplier(Player, 3))

		Player.World.Changed:Connect(function()
			Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetStarMultiplier(Player, 3))
		end)
	elseif Info.Type == "Gems" then
		Slot.Img.Visible = true
		Slot.Img.Image = "rbxassetid://12506258121"
		Slot.Amount.Visible = true
		Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetGemMultiplier(Player))

		Player.Data.x2GemsBoost.Changed:Connect(function()
			Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetGemMultiplier(Player))
		end)

		Player.Data.x2Gems.Changed:Connect(function()
			Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetGemMultiplier(Player))
		end)

		Player.Data.Upgrade3.Changed:Connect(function()
			Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetGemMultiplier(Player))
		end)

		Player.Data.Perk2.Changed:Connect(function()
			Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount * Multipliers.GetGemMultiplier(Player))
		end)
	elseif Info.Type == "TradeTokens" then
		Slot.Img.Visible = true
		Slot.Img.Image = "rbxassetid://13291646357"
		Slot.Amount.Visible = true
		Slot.Amount.Text = "+"..Utilities.Short.en(Info.Amount)
	elseif Info.Type == "Boost" then
		Slot.Img.Visible = true
		Slot.Img.Image = Info.Img
		Slot.Amount.Visible = true
		Slot.Amount.Text = "x2 "..Info.Amount
	elseif Info.Type == "Pet" then
		SetPetSlot(Slot.Viewport, Info.Amount)
	end
end

for i = 1,10 do
	local NewSlot = script.Frame:Clone()
	NewSlot.Parent = SeasonpassUI.ScrollingFrame
	NewSlot.Num.Text = "Tier "..i

	SetTierLock(NewSlot, i)

	Player.Data.Tier.Changed:Connect(function()
		SetTierLock(NewSlot, i)
	end)

	Player.Data.PremiumPass.Changed:Connect(function()
		SetTierLock(NewSlot, i)
	end)

	ProgressText()

	Player.Data.Tier.Changed:Connect(function()
		ProgressText()
	end)

	Player.Data.XP.Changed:Connect(function()
		ProgressText()
	end)

	NewSlot.Skip.MouseButton1Click:Connect(function()
		game:GetService("MarketplaceService"):PromptProductPurchase(Player, 1577723203)
	end)

	--// Premium Lock

	if not Player.Data.PremiumPass.Value then
		NewSlot.Premium.Lock.Visible = true
	else
		NewSlot.Premium.Lock.Visible = false
	end

	Player.Data.PremiumPass.Changed:Connect(function()
		if not Player.Data.PremiumPass.Value then
			NewSlot.Premium.Lock.Visible = true
		else
			NewSlot.Premium.Lock.Visible = false
		end
	end)

	--// Reward

	local Reward = Rewards.Normal[i]
	if Reward ~= nil then
		HandleReward(NewSlot.Free, Reward)
	end

	local PremiumReward = Rewards.Premium[i]
	if PremiumReward ~= nil then
		HandleReward(NewSlot.Premium, PremiumReward)
	end
end

return Seasonpass