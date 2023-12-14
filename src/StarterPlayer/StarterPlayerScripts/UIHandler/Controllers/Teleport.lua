local Teleportodule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

--// Variables

local Player = game.Players.LocalPlayer

local Modules = RS.Modules
local Worlds = require(Modules.Worlds)

local MainUI = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Teleport

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

local function PlayTeleportAnimation()
	if not MainUI.Visible then
		CloseFrames()
		BlurAnimation(1)
		MainUI.Parent.Left.Visible = false
		MainUI.Parent.Buttons.Visible = false
		MainUI.Visible = true
		Player.PlayerGui.Teleport.Enabled = false

		--// Text Tweens

		MainUI.NewWorld.Size = UDim2.new(0,0,0,0)
		MainUI.NewWorld:TweenSize(UDim2.new(0.7,0,0.2,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.5)
		MainUI.NewWorld.Text = Player.World.Value
		MainUI.NewWorld.TextColor3 = Worlds[Player.World.Value].WorldColor

		MainUI.Title.Size = UDim2.new(0,0,0,0)
		MainUI.Title:TweenSize(UDim2.new(0.7,0,0.2,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.5)

		MainUI.Bar:TweenPosition(UDim2.new(0,0,-0.1,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.4)

		TS:Create(MainUI.Loading,TweenInfo.new(1.3),{ImageTransparency = 0}):Play()

		task.wait(0.4)

		spawn(function()
			for i = 1,100 do
				MainUI.Loading.Rotation += 4
				task.wait(0.01)
			end
		end)

		task.wait(1.1)

		MainUI.Bar:TweenPosition(UDim2.new(1,0,-0.1,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,0.5)

		MainUI.NewWorld:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Bounce,0.6)
		MainUI.Title:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Bounce,0.6)
		TS:Create(MainUI.Loading,TweenInfo.new(0.5),{ImageTransparency = 1}):Play()

		--// Load World


		Worlds[Player.World.Value].WorldEffect()
		Player.PlayerGui.Teleport.Enabled = true
		Player.PlayerGui.Teleport.EButton.Size = UDim2.new(0,0,0,0)

		task.wait(0.5)

		MainUI.Bar.Position = UDim2.new(-1,0,-0.1,0)
		MainUI.Visible = false
		MainUI.Parent.Left.Visible = true
		MainUI.Parent.Buttons.Visible = true
	end
end

function Teleportodule:Init()
	Player.World.Changed:Connect(function()
		PlayTeleportAnimation()
	end)
end

return Teleportodule
