local UgcModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// cVariables

local Player = game.Players.LocalPlayer


local UgcFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Ugc")
local ProgressFrame = UgcFrame.Progress.WhiteBorder.Holder
local RewardFrame = UgcFrame.Reward
local ClaimButton = UgcFrame.Claim
local CloseButton = UgcFrame.Close


local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)

local MaxStats = {
	["UgcStars"] = 1000,
	["UgcEggs"] = 1000,
	["UgcTime"] = 3600,
}

local Claim = false

--> update UI and not let it to go over max value 
local function update(stat)
	local StarPecentage = math.clamp( (Player.Data["UgcStars"].Value /MaxStats.UgcStars) * 100, 0, 100)
	local UgcEggsPecentage = math.clamp( (Player.Data["UgcEggs"].Value /MaxStats.UgcEggs) * 100, 0, 100)
	local UgcTimePecentage = math.clamp( (Player.Data["UgcTime"].Value /MaxStats.UgcTime) * 100, 0, 100)
	
	
	if stat.Name ~= "UgcTime" then 
		if stat.Value >= MaxStats[stat.Name] then
			ProgressFrame[stat.Name].Text = tostring(Utilities.Short.en(MaxStats[stat.Name]).. "/" .. Utilities.Short.en(MaxStats[stat.Name]))
		else
			ProgressFrame[stat.Name].Text = tostring(Utilities.Short.en(stat.Value)).. "/" .. Utilities.Short.en(MaxStats[stat.Name])
		end
	else
		if stat.Value >= MaxStats[stat.Name] then
			ProgressFrame[stat.Name].Text = tostring(Utilities.Short.time(MaxStats[stat.Name])).. "/" .. Utilities.Short.time(MaxStats[stat.Name])
		else
			ProgressFrame[stat.Name].Text = tostring(Utilities.Short.time(stat.Name)).. "/" .. Utilities.Short.time(MaxStats[stat.Name])
		end
	end
	
	local TotalPercentage = math.floor( (StarPecentage + UgcEggsPecentage + UgcTimePecentage) / 3)
	if TotalPercentage >= 100 then
		UgcFrame.Completion.Label.Text = "Claim"
		UgcFrame.Completion.Bar.Size = UDim2.new(1, 0, 1, 0)
		ClaimButton.BackgroundColor3 = Color3.fromRGB(128, 255, 126)
		ClaimButton.UIStroke.Color = Color3.fromRGB(42, 79, 36)
		Claim = true
	else
		UgcFrame.Completion.Label.Text = TotalPercentage.."% Complete"
		UgcFrame.Completion.Bar.Size = UDim2.new(TotalPercentage/100, 0, 1, 0)
	end
end

--> load initial UI and use math.clamp to make sure nothing goes over max value 
local function load()
	ProgressFrame["UgcStars"].Text = tostring(Utilities.Short.en(math.clamp(Player.Data["UgcStars"].Value, 0, 1000)).. "/" .. Utilities.Short.en(MaxStats["UgcStars"]))
	ProgressFrame["UgcEggs"].Text = tostring(Utilities.Short.en(math.clamp(Player.Data["UgcEggs"].Value, 0, 1000)).. "/" .. Utilities.Short.en(MaxStats["UgcEggs"]))
	ProgressFrame["UgcTime"].Text = tostring(Utilities.Short.time(Player.Data["UgcTime"])).. "/" .. Utilities.Short.time(MaxStats["UgcTime"])
	
	local StarPecentage = math.clamp( (Player.Data["UgcStars"].Value /MaxStats.UgcStars) * 100, 0, 100)
	local UgcEggsPecentage = math.clamp( (Player.Data["UgcEggs"].Value /MaxStats.UgcEggs) * 100, 0, 100)
	local UgcTimePecentage = math.clamp( (Player.Data["UgcTime"].Value /MaxStats.UgcTime) * 100, 0, 100)
	
	local TotalPercentage = math.floor(StarPecentage + UgcEggsPecentage + UgcTimePecentage) / 3
	
	if TotalPercentage >= 100 then
		UgcFrame.Completion.Label.Text = "Claim"
		UgcFrame.Completion.Bar.Size = UDim2.new(1, 0, 1, 0)
		ClaimButton.BackgroundColor3 = Color3.fromRGB(128, 255, 126)
		ClaimButton.UIStroke.Color = Color3.fromRGB(42, 79, 36)
		Claim = true
	else
		UgcFrame.Completion.Label.Text = TotalPercentage.."% Complete"
		UgcFrame.Completion.Bar.Size = UDim2.new(TotalPercentage/100, 0, 1, 0)
	end

end

function UgcModule:Init()
	--> buttons and easy shit
	Utilities.ButtonAnimations.Create(CloseButton)
	Utilities.ButtonAnimations.Create(ClaimButton)
	CloseButton.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(UgcFrame, UDim2.new(0,0,0,0))
	end)
	
	ClaimButton.Click.MouseButton1Click:Connect(function()
		if Claim then
			RS.Remotes.UgcClaim:FireServer()
		end
	end)
	
	--> viewport frame for our pet
	local PetModel = RS.Pets.Models:FindFirstChild("Warrior Dog"):Clone()
	local Viewport = RewardFrame.PetItem.ViewportFrame
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z-4),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
	
	load()
	
	--> data update
	Player.Data["UgcStars"].Changed:Connect(function()
		update(Player.Data["UgcStars"])
	end)
	Player.Data["UgcEggs"].Changed:Connect(function()
		update(Player.Data["UgcEggs"])
	end)
	Player.Data["UgcTime"].Changed:Connect(function()
		update(Player.Data["UgcTime"])
	end)
end

return UgcModule
