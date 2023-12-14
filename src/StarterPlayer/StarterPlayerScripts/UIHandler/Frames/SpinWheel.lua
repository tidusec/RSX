--// Services

local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local MPS = game:GetService("MarketplaceService")

--// Variables
local SpinWheelModule = {}

local Player = game.Players.LocalPlayer

local Remotes = RS.Remotes
local SpinInvoke = Remotes.Spin

local Multipliers = require(RS.Modules.Shared.Multipliers)
local SpinModule = require(RS.Modules.Spin)
local Utilities = require(RS.Modules.Client.Utilities)

local SpinWheel = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.SpinWheel



local function Spin(Slot)
	local SpinInfo = SpinModule[Slot]
	local RewardText = SpinInfo.Message
	local Target = -45 * Slot +22.5

	if SpinInfo.Reward.Type ~= "Potion" then
		local Reward = SpinInfo.Reward.Amount

		if SpinInfo.Reward.Type == "Stars" then
			Reward *= Multipliers.GetStarMultiplier(Player)
		elseif SpinInfo.Reward.Type == "Gems" then
			Reward *= Multipliers.GetGemMultiplier(Player)
		end

		if type(Reward) == "number" then
			Reward = Utilities.Short.en(Reward)
		end

		RewardText = string.format(SpinInfo.Message, Reward)
	end

	local function spinWheel(rotationAmount, duration, easingStyle,easingDirection)
		TS:Create(SpinWheel.Wheel, TweenInfo.new(duration, easingStyle,easingDirection), {Rotation = SpinWheel.Wheel.Rotation + rotationAmount}):Play()

		for _,Rewards in SpinWheel.Wheel:GetChildren() do
			TS:Create(Rewards,TweenInfo.new(duration, easingStyle,easingDirection),{Rotation = Rewards.Rotation - rotationAmount}):Play()
		end
	end

	spinWheel(45, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	wait(1)
	spinWheel(-350, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	wait(1.5)

	local Delta = Target-SpinWheel.Wheel.Rotation

	if Delta >= 0 then
		Delta = -(360-Delta)
	end

	spinWheel(Delta, 1.5 , Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	wait(2)

	SpinWheel.Wheel.Rotation = 0	
	for _,Rewards in SpinWheel.Wheel:GetChildren() do
		Rewards.Rotation = 0
	end

	Utilities.Popup.Layered(RewardText, Color3.fromRGB(170, 255, 255),2,RS.Audio.Completed)
	wait(1)

	--[[
	wait(1)
	spinWheel(-100, 1.5, Enum.EasingStyle.Quint)
	wait(1.5)
	spinWheel(-20, 5, Enum.EasingStyle.Elastic)]]

	--[[
	task.spawn(function()
		TS:Create(SpinWheel.Wheel,TweenInfo.new(2.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Rotation = StartingRot + 179}):Play()
		wait(2.5)
		TS:Create(SpinWheel.Wheel,TweenInfo.new(2.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Rotation = 22.5 + 45 * Slot}):Play()
	end)


	for _,Rewards in SpinWheel.Wheel:GetChildren() do
		TS:Create(Rewards,TweenInfo.new(2.5,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Rotation = StartingRot - 179}):Play()
		wait(2.5)
		TS:Create(SpinWheel.Wheel,TweenInfo.new(2.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Rotation = -22.5 + -45 * Slot}):Play()
	end]]
end

local function SpinRequest()
	if Player.Data.HasSpin.Value < os.time() then
		local Result = SpinInvoke:InvokeServer()

		if Result then
			UpdateButton()
			Spin(Result)
		end
	else
		MPS:PromptProductPurchase(Player, 1539516612)
	end
end

function UpdateButton()
	if Player.Data.HasSpin.Value < os.time() then
		SpinWheel.Purchase.Title.Text = "Spin"
	else
		SpinWheel.Purchase.Title.Text = "Buy R$39"
	end
end

local function SetPetSlot(Viewport,Pet)
	local PetModel = RS.Pets.Models:FindFirstChild(Pet):Clone()

	if not PetModel.PrimaryPart then
		warn(PetModel.Name.." does not have a primary part")
		return
	end

	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-3,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
end

function SpinWheelModule:Init()
	Utilities.ButtonAnimations.Create(SpinWheel.Close)	
	
	SpinWheel.Close.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(SpinWheel,UDim2.new(0,0,0,0))
	end)

	SetPetSlot(SpinWheel.Wheel["2"], "Spin Master")


	local CD = false

	SpinWheel.Purchase.MouseButton1Click:Connect(function()
		if CD == false then
			CD = true
			Utilities.Audio.PlayAudio("Click")
			SpinRequest()
			CD = false
		end
	end)
	
	task.spawn(function()
		while wait(1) do
			UpdateButton()
		end
	end)

end

return SpinWheelModule