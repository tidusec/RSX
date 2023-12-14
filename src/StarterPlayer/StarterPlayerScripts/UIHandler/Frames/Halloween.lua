local HalloweenModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// cVariables

local Player = game.Players.LocalPlayer


local HalloweenFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Halloween")
local ProgressFrame = HalloweenFrame.Progress.WhiteBorder.Holder
local RewardFrame = HalloweenFrame.Reward
local ClaimButton = HalloweenFrame.Claim
local CloseButton = HalloweenFrame.Close


local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)

local MaxStats = {
	["TotalCandyCorn"] = 20_000,
	["HalloweenEggs"] = 10_000,
	["HalloweenTime"] = 14_000,
}

local Claim = false

--> update UI and not let it to go over max value 
local function update(stat)
	local StarPecentage = math.clamp( (Player.Data["TotalCandyCorn"].Value /MaxStats.TotalCandyCorn) * 100, 0, 100)
	local HalloweenEggsPecentage = math.clamp( (Player.Data["HalloweenEggs"].Value /MaxStats.HalloweenEggs) * 100, 0, 100)
	local HalloweenTimePecentage = math.clamp( (Player.Data["HalloweenTime"].Value /MaxStats.HalloweenTime) * 100, 0, 100)


	if stat.Name ~= "HalloweenTime" then 
		ProgressFrame[stat.Name].Text = tostring(Utilities.Short.en( math.clamp(stat.Value, 0, MaxStats[stat.Name]) ).. "/" .. Utilities.Short.en(MaxStats[stat.Name]))
	else
		ProgressFrame[stat.Name].Text = tostring(Utilities.Short.time( math.clamp(stat.Value, 0, MaxStats[stat.Name]) ).. "/" .. Utilities.Short.time(MaxStats[stat.Name]))
	end

	local TotalPercentage = math.floor( (StarPecentage + HalloweenEggsPecentage + HalloweenTimePecentage) / 3)
	if TotalPercentage >= 100 and Player.Data.HalloweenClaim.Value == false then
		Claim = true
		HalloweenFrame.Completion.Label.Text = "Claim"
		HalloweenFrame.Completion.Bar.Size = UDim2.new(1, 0, 1, 0)
		ClaimButton.BackgroundColor3 = Color3.fromRGB(128, 255, 126)
		ClaimButton.UIStroke.Color = Color3.fromRGB(42, 79, 36)
		ClaimButton.Amount.UIStroke.Color = Color3.fromRGB(42, 79, 36)
		
	elseif Player.Data.HalloweenClaim.Value == true then
		ClaimButton.BackgroundColor3 = Color3.fromRGB(60, 63, 63)
		ClaimButton.UIStroke.Color = Color3.fromRGB(48, 47, 47)
		ClaimButton.Amount.Text = "Claimed"
		ClaimButton.Amount.UIStroke.Color = Color3.fromRGB(48, 47, 47)
		HalloweenFrame.Completion.Label.Text = "Claimed"
		Claim = false
		
	else
		HalloweenFrame.Completion.Label.Text = TotalPercentage.."% Complete"
		HalloweenFrame.Completion.Bar.Size = UDim2.new(TotalPercentage/100, 0, 1, 0)
		Claim = false
	end
end

--> load initial UI and use math.clamp to make sure nothing goes over max value 
local function load()
	ProgressFrame["TotalCandyCorn"].Text = tostring(Utilities.Short.en(math.clamp(Player.Data["TotalCandyCorn"].Value, 0, 1000)).. "/" .. Utilities.Short.en(MaxStats["TotalCandyCorn"]))
	ProgressFrame["HalloweenEggs"].Text = tostring(Utilities.Short.en(math.clamp(Player.Data["HalloweenEggs"].Value, 0, 1000)).. "/" .. Utilities.Short.en(MaxStats["HalloweenEggs"]))
	ProgressFrame["HalloweenTime"].Text = tostring(Utilities.Short.time(Player.Data["HalloweenTime"])).. "/" .. Utilities.Short.time(MaxStats["HalloweenTime"])

	local StarPecentage = math.clamp( (Player.Data["TotalCandyCorn"].Value /MaxStats.TotalCandyCorn) * 100, 0, 100)
	local HalloweenEggsPecentage = math.clamp( (Player.Data["HalloweenEggs"].Value /MaxStats.HalloweenEggs) * 100, 0, 100)
	local HalloweenTimePecentage = math.clamp( (Player.Data["HalloweenTime"].Value /MaxStats.HalloweenTime) * 100, 0, 100)

	local TotalPercentage = math.floor(StarPecentage + HalloweenEggsPecentage + HalloweenTimePecentage) / 3
	
	if TotalPercentage >= 100 and Player.Data.HalloweenClaim.Value == false then
		Claim = true
		HalloweenFrame.Completion.Label.Text = "Claim"
		HalloweenFrame.Completion.Bar.Size = UDim2.new(1, 0, 1, 0)
		ClaimButton.BackgroundColor3 = Color3.fromRGB(128, 255, 126)
		ClaimButton.UIStroke.Color = Color3.fromRGB(42, 79, 36)
		
	elseif Player.Data.HalloweenClaim.Value == true then
		ClaimButton.BackgroundColor3 = Color3.fromRGB(60, 63, 63)
		ClaimButton.UIStroke.Color = Color3.fromRGB(48, 47, 47)
		Claim = false
		
	else
		HalloweenFrame.Completion.Label.Text = TotalPercentage.."% Complete"
		HalloweenFrame.Completion.Bar.Size = UDim2.new(TotalPercentage/100, 0, 1, 0)
		Claim = false
	end
end



function HalloweenModule:Init()
	--> buttons and easy shit
	Utilities.ButtonAnimations.Create(CloseButton)
	Utilities.ButtonAnimations.Create(ClaimButton)
	CloseButton.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HalloweenFrame, UDim2.new(0,0,0,0))
	end)

	ClaimButton.Click.MouseButton1Click:Connect(function()
		if Claim then
			RS.Remotes.HalloweenClaim:FireServer()
		end
	end)

	----> viewport frame for our pet
	--local PetModel = RS.Pets.Models:FindFirstChild("Warrior Dog"):Clone()
	--local Viewport = RewardFrame.PetItem.ViewportFrame
	--local Camera = Instance.new("Camera")
	--local Pos = PetModel.PrimaryPart.Position

	--Viewport.CurrentCamera = Camera
	--PetModel.Parent = Viewport
	--Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z-4),Pos)
	--PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)

	load()

	----> data update
	Player.Data["TotalCandyCorn"].Changed:Connect(function()
		update(Player.Data["TotalCandyCorn"])
	end)
	Player.Data["HalloweenTime"].Changed:Connect(function()
		update(Player.Data["HalloweenTime"])
	end)
	Player.Data["HalloweenEggs"].Changed:Connect(function()
		update(Player.Data["HalloweenEggs"])
	end)
end

return HalloweenModule
