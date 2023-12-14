local Perk = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// cVariables

local Player = game.Players.LocalPlayer


local PerkInventory = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("PerkInventory")
local Scroll = PerkInventory.ScrollingFrame
local SideFrame = PerkInventory.SideFrame


local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)



local function CreateNewPerk(Perk)
	local NewPerk = script.Perk:Clone()
	NewPerk.Title.Text = Content.Perks[Perk].Title.." "..Utilities.Short.RomanNumeral(Player.Data["Perk"..Perk].Value)
	NewPerk.PerkImage.ImageColor3 = Content.Perks[Perk].Color
	NewPerk.PerkImage.Tier.Text = Utilities.Short.RomanNumeral(Player.Data["Perk"..Perk].Value)
	NewPerk.Parent = Scroll

	if Player.Data["Perk"..Perk].Value == 0 then
		NewPerk.Visible = false
	else
		NewPerk.Visible = true
	end

	Player.Data["Perk"..Perk].Changed:Connect(function()
		NewPerk.PerkImage.Tier.Text = Utilities.Short.RomanNumeral(Player.Data["Perk"..Perk].Value)

		if Player.Data["Perk"..Perk].Value == 0 then
			NewPerk.Visible = false
		else
			NewPerk.Visible = true
		end
	end)

	NewPerk.TextButton.MouseButton1Click:Connect(function()
		CreateSideFrame(Perk)
	end)
end


function Perk:Init()
	Utilities.ButtonAnimations.Create(PerkInventory.Close)
	PerkInventory.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(PerkInventory, UDim2.new(0,0,0,0))
	end)

	PerkInventory.Toggle.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(PerkInventory.Parent.PerkShopFrame, UDim2.new(0.52,0,0.52,0))
	end)
	
	for i = 1,#Content.Perks do
		CreateNewPerk(i)
	end
end

function CreateSideFrame(Perk)
	SideFrame.Visible = true
	SideFrame.Boost.Text = string.format(Content.Perks[Perk].Boost, Content.Perks[Perk].Prices(Player.Data["Perk"..Perk].Value).Reward)
	SideFrame.Perk.ImageColor3 = Content.Perks[Perk].Color
	SideFrame.Perk.Tier.Text = Utilities.Short.RomanNumeral(Player.Data["Perk"..Perk].Value)
	SideFrame.Title.Text = Content.Perks[Perk].Title
	SideFrame.Description.Text = Content.Perks[Perk].Description
end


return Perk
