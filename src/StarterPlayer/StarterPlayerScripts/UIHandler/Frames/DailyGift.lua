local DailyGiftModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local MPS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

--// Variables

local Player = Players.LocalPlayer


local Gift = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Gift")
local List = Gift.List

local Modules = RS.Modules
local Robux = require(Modules.RobuxShop)

local Remotes = RS.Remotes
local Select = Remotes.SelectGift

--// Load Players

local function getGPId()
	for _,v in Robux.Gamepasses do
		if v.Name == Gift.Gamepass.Value then
			return v.GiftProduct
		end
	end
end

local DB = false

local function Gray(Frame)
	Frame.LayoutOrder = 2
	Frame.Gift.Text.Text = "Owned"
	Frame.Gift.BorderStroke.Color = Color3.fromRGB(70, 70, 70)
	Frame.Gift.Text.UIStroke.Color = Color3.fromRGB(76, 76, 76)
	Frame.Gift.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(158, 158, 158)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(116, 116, 116))
	})
	Frame.Gift.Text.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 115, 115)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(250, 250, 250)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 115, 115))
	})
end

local function Red(Frame)
	Frame.LayoutOrder = 1
	Frame.Gift.Text.Text = "Gift"
	Frame.Gift.BorderStroke.Color = Color3.fromRGB(194, 65, 0)
	Frame.Gift.Text.UIStroke.Color = Color3.fromRGB(184, 61, 0)
	Frame.Gift.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 132, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 0))
	})
	Frame.Gift.Text.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 195, 165)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 195, 165))
	})
end

local function PlayerTemplate(v)
	if v.Name ~= Player.Name then
		local Template = script.Template:Clone()
		Template.Username.Text = v.Name
		Template.Avatar.Image = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		Template.Parent = List
		Template.Name = v.Name

		if Gift.Gamepass.Value ~= "" then
			if v.Data:FindFirstChild(Gift.Gamepass.Value).Value == true then
				Gray(Template)
			end
		end

		Gift.Gamepass.Changed:Connect(function()
			if v.Data:FindFirstChild(Gift.Gamepass.Value).Value == true then
				Gray(Template)
			else
				Red(Template)
			end
		end)

		Template.Gift.Click.MouseButton1Click:Connect(function()
			if DB == true then return end
			DB = true

			if v.Data:FindFirstChild(Gift.Gamepass.Value).Value == false then
				Select:FireServer(v.Name)
				MPS:PromptProductPurchase(Player, getGPId())
			end

			wait(0.3)
			DB = false
		end)
	end
end

--// PlayerLoad
function DailyGiftModule:Init()
	for _,v in Players:GetChildren() do
		PlayerTemplate(v)
	end

	Players.ChildAdded:Connect(function(v)
		PlayerTemplate(v)
	end)

	Players.ChildRemoved:Connect(function(v)
		if List:FindFirstChild(v.Name) then
			List[v.Name]:Destroy()
		end
	end)
end

return DailyGiftModule
