local RankUpmodule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

--// Variables

local Player = game.Players.LocalPlayer


local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)

local MainUI = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.RankUp
local Teleport = MainUI.Parent.Parent.Parent.Teleport

local ConfettiColors = {Color3.fromRGB(255, 0, 0),Color3.fromRGB(255, 170, 0),Color3.fromRGB(255, 255, 0),Color3.fromRGB(85, 255, 0)}


local function BlurAnimation(Transparency)
	spawn(function()
		local Tween = TS:Create(MainUI.Parent.Blur,TweenInfo.new(0.25),{BackgroundTransparency=Transparency}):Play()
	end)
end

local function CloseFrames()
	for _,OpenedFrame in MainUI.Parent.Frames:GetChildren() do
		if OpenedFrame.Visible then
			OpenedFrame:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			wait(0.05)
			OpenedFrame.Visible = false
		end
	end
end


local function SpawnConfetti(Amount)
	local Count = 10

	for i = 1,Amount do
		local Element = script.Confetti:Clone()
		Element.Parent = MainUI
		Element.BackgroundColor3 = ConfettiColors[math.random(1,#ConfettiColors)]

		local XStart = math.random(200,800)/1000
		Element.Position = UDim2.new(XStart,0,-0.2,0)
		Element.Rotation = math.random(1,360)

		local RandomX,RandomY = math.random(200,800)/1000,math.random(100,900)/1000
		Element:TweenPosition(UDim2.new(XStart,0,RandomY,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,1)

		spawn(function()
			wait(0.25)
			TS:Create(Element,TweenInfo.new(1.7,Enum.EasingStyle.Quint),{BackgroundTransparency = 1}):Play()
			wait(2.25)
			Element:Destroy()
		end)

		if Count%10 == 0 then wait(0.01) end
	end
end

local function RankUp()
	if not MainUI.Visible then
		CloseFrames()

		MainUI.Parent.Frames.Visible = false
		MainUI.Visible = true
		Teleport.Enabled = false

		--// Text Tweens

		MainUI.NewRank.Size = UDim2.new(0,0,0,0)
		MainUI.NewRank:TweenSize(UDim2.new(0.7,0,0.2,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.5)
		MainUI.NewRank.Text = Content.Ranks[Player.Data.Rank.Value].RankName

		MainUI.Title.Size = UDim2.new(0,0,0,0)
		MainUI.Title:TweenSize(UDim2.new(0.7,0,0.2,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.5)

		MainUI.ImageLabel.Size = UDim2.new(0,0,0,0)
		MainUI.ImageLabel:TweenSize(UDim2.new(0.2,0,0.3,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.5)
		MainUI.ImageLabel.Image = Content.Ranks[Player.Data.Rank.Value].RankImage

		spawn(function()
			SpawnConfetti(300)
		end)

		Utilities.Audio.PlayAudio("Rankup")
		BlurAnimation(0.4)

		wait(2)

		--// Text Tweens Out

		MainUI.NewRank:TweenSize(UDim2.new(0.0,0,0.0,0),Enum.EasingDirection.In,Enum.EasingStyle.Quart,0.5)
		MainUI.Title:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Quart,0.5)
		MainUI.ImageLabel:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Quart,0.5)

		wait(0.45)

		MainUI.Visible = false
		MainUI.Parent.Frames.Visible = true
		Teleport.Enabled = true
		BlurAnimation(1)
	end
end

function RankUpmodule:Init()
	local Before = Player.Data.Rank.Value

	Player.Data.Rank.Changed:Connect(function()
		if Player.Data.Rank.Value > Before then
			RankUp()
		end

		Before = Player.Data.Rank.Value
	end)
end

return RankUpmodule
