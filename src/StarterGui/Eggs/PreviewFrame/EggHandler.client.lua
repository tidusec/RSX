--// Services

local RNS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local PLRS = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local SS = game:GetService("SoundService")
local MPS = game:GetService("MarketplaceService")
local RuS = game:GetService("RunService")

--// Variables

local Player = PLRS.LocalPlayer

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value

local Camera = workspace.CurrentCamera

local Settings = RS.Settings
local Currencies = Settings.Currencies

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)
local Multipliers = require(Modules.Shared.Multipliers)

local PreviewFrame = script.Parent

local CurrentTarget = PreviewFrame.CurrentTarget
local MaxMagnitude = PreviewFrame.MaxMagnitude

local DefaultSize = PreviewFrame.Size

local Pets = RS.Pets
local PetModels = Pets.Models

local Config = require(Pets.Configure)

local MainUI = Player.PlayerGui:WaitForChild("Rank Simulator X")
local HUD = MainUI.HUD

--// Determines what egg is the closest if you are in range of multiple

function GetClosestEgg(EggsAvailable)
	local CurrentClosest = nil
	local ClosestDistance = MaxMagnitude.Value
	for _,Egg in EggsAvailable do
		local EggModel = workspace.Eggs:FindFirstChild(Egg)
		local mag = (EggModel.PrimaryPart.Position-Player.Character.HumanoidRootPart.Position).Magnitude
		if mag <= ClosestDistance then
			CurrentClosest = EggModel
			ClosestDistance = mag
		end
	end
	return CurrentClosest
end

--// Handles Autodelete

function AutoDelete(Slot)
	Slot.AutoDelete.Button.MouseButton1Click:Connect(function()
		if Slot.Pet:FindFirstChildOfClass("Model").Name then
			local PetName = Slot.Pet:FindFirstChildOfClass("Model").Name

			if Content.Pets[PetName] and Content.Pets[PetName].Rarity ~= "Robux" then
				RS.Remotes.ToggleAutoDelete:FireServer(PetName)
				wait(0.2)
				Slot.AutoDelete.Cross.Visible = Player.AutoDelete[PetName].Value
			end
		end
	end)
end

--// Handles the visibility of the PreviewFrame

RNS.RenderStepped:Connect(function()
	if Player.Character:FindFirstChild("Humanoid") then
		if Player.Character.Humanoid.Health ~= 0 then
			local EggsAvailable = {}
			local CameraRatio = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude)/11

			for _,v in workspace.Eggs:GetChildren() do
				if v:IsA("Model") and v.Name ~= "Golden" then
					local mag = (v.Egg.PrimaryPart.Position-Player.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
					if mag <= script.Parent.MaxMagnitude.Value then
						EggsAvailable[#EggsAvailable+1] = v.Name
					end
				end
			end

			if #EggsAvailable == 1 then
				local Egg = workspace.Eggs:FindFirstChild(EggsAvailable[1])
				local WSP = workspace.CurrentCamera:WorldToScreenPoint(Egg.Egg.PrimaryPart.Position)
				PreviewFrame.Visible = true
				PreviewFrame.Position = UDim2.new(0,WSP.X,0,WSP.Y)
				CurrentTarget.Value = Egg.Name
			elseif #EggsAvailable > 1 then
				local Egg = GetClosestEgg(EggsAvailable)
				local WSP = workspace.CurrentCamera:WorldToScreenPoint(Egg.Egg.PrimaryPart.Position)
				PreviewFrame.Visible = true
				PreviewFrame.Position = UDim2.new(0,WSP.X,0,WSP.Y)
				CurrentTarget.Value = Egg.Name
			elseif #EggsAvailable == 0 then
				CurrentTarget.Value = "None"
				PreviewFrame.Visible = false
			end

			PreviewFrame.Size = UDim2.new(DefaultSize.X.Scale/CameraRatio, DefaultSize.X.Offset, DefaultSize.Y.Scale/CameraRatio, DefaultSize.Y.Offset)
		end
	end
end)

--// Reset Slots

function ResetFrame()
	for _,Slot in PreviewFrame.PetChances.List:GetChildren() do
		if Slot:IsA("Frame") then
			for _,Pet in Slot.Pet:GetChildren() do
				Pet:Destroy()
			end
			Slot.Percentage.Text = ""
			Slot.Rarity.Text = ""
			Slot.AutoDelete.Cross.Visible = false
		end
	end
end

--// Change PreviewFrame GUI

CurrentTarget.Changed:Connect(function()
	if CurrentTarget.Value ~= "None" then
		if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
			local Egg = Content.Eggs[CurrentTarget.Value]
			local Currency = Egg.Currency
			local Cost = Egg.Cost
			local Counter = 0
			local Pets = {}
			for _,Pet in Egg.Pets do
				Pets[#Pets + 1] = {Name = Pet.Name, Type = Pet.Type, Rarity = Pet.Rarity, Secret = Pet.Secret}
			end

			ResetFrame()

			PreviewFrame.EggInfo.Price["1"].Image = Currencies[Currency.."Image"].Value
			PreviewFrame.EggInfo.Price.PriceLabel.Text = Utilities.Short.en(Cost)
			PreviewFrame.EggInfo.EggName.TextLabel.Text = CurrentTarget.Value

			--// If robux egg:

			if Currency == "R$" then
				PreviewFrame.EggInfo.Price.PriceLabel.Visible = false
				PreviewFrame.EggInfo.Price["1"].Visible = false
				PreviewFrame.EggInfo.Price.RobuxLabel.Visible = true
				PreviewFrame.EggInfo.Price["RobuxLabel"].Text = string.split(PreviewFrame.EggInfo.Price["RobuxLabel"].Text," ")[1].." "..Utilities.Short.en(Cost)
			else
				PreviewFrame.EggInfo.Price.PriceLabel.Visible = true
				PreviewFrame.EggInfo.Price["1"].Visible = true
				PreviewFrame.EggInfo.Price.RobuxLabel.Visible = false
			end

			--// Sort

			table.sort(Pets,function(a,b)
				return a.Rarity > b.Rarity
			end)

			--// Configure Slots

			for Order,PetInfo in Pets do 				
				if PetInfo.Secret == false then

					--// PetViewport
					local PetName = PetInfo.Name
					local PetModel = PetModels:FindFirstChild(PetName):Clone()
					local Slot = PreviewFrame.PetChances.List["Pet"..Order]
					local Viewport = Slot.Pet
					local Camera = Instance.new("Camera")
					local Pos = PetModel.PrimaryPart.Position
					Viewport.CurrentCamera = Camera
					PetModel.Parent = Viewport
					Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
					PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90),0)

					--// Configure the rest

					Slot.Percentage.Text = PetInfo.Rarity.."%"
					Slot.Rarity.Text = Content.Pets[PetName].Rarity
					Slot.Rarity.TextColor3 = Config.Rarities[Content.Pets[PetName].Rarity].Color

					if Player.AutoDelete[PetName].Value then
						Slot.AutoDelete.Cross.Visible = true
					else
						Slot.AutoDelete.Cross.Visible = false
					end
				end
			end
		end
	end
end)

--[[
		EGG HATCHING PART
]]

local function SpawnConfetti(Amount,Parent,Cooldown)
	task.spawn(function()
		local Count = 0

		for i = 1,Amount do
			local Element = script.Confetti:Clone()
			Element.Parent = Parent
			Element.BackgroundColor3 = Color3.new(math.random(),math.random(),math.random())

			local XStart = math.random(100,900)/1000
			Element.Position = UDim2.new(XStart,0,math.random(-100,200)/1000,0)
			Element.Rotation = math.random(1,360)

			local RandomX,RandomY = math.random(200,800)/1000,math.random(600,800)/1000
			Element:TweenPosition(UDim2.new(XStart,0,RandomY,0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,Cooldown * 15)

			task.spawn(function()
				task.wait(Cooldown*8)
				TS:Create(Element,TweenInfo.new(Cooldown * 12,Enum.EasingStyle.Exponential),{BackgroundTransparency = 1}):Play()
				task.wait(Cooldown*13)
				Element:Destroy()
			end)

			Count += 1

			if Count == 10 then task.wait(Cooldown*3) Count = 0 end
		end
	end)
end

function TweenModel(EndCFrame,TI,Model)
	local NewCFrameValue = Instance.new("CFrameValue")
	NewCFrameValue.Value = Model.PrimaryPart.CFrame
	local Tween = TS:Create(NewCFrameValue,TI,EndCFrame)
	local Connection

	Connection = NewCFrameValue.Changed:Connect(function()
		if Model.PrimaryPart == nil then return end
		Model:SetPrimaryPartCFrame(NewCFrameValue.Value)
	end)

	Tween:Play()

	Tween.Completed:Connect(function()
		NewCFrameValue:Destroy()
		Connection:Disconnect()
	end)
end

local function ScaleModel(Model : Model, Scale : Number)
	local primaryCFrame = Model.PrimaryPart.CFrame

	for _, Part in Model:GetDescendants() do
		if Part:IsA("BasePart") or Part:IsA("MeshPart") then
			Part.Size = (Part.Size * Scale)

			if (Part ~= Model.PrimaryPart) then
				Part.CFrame = (primaryCFrame + (primaryCFrame:inverse() * Part.Position * Scale))
			end
		end
	end

	return Model
end

function rotateEgg(Egg, Rot, NumberTime)
	local TI = TweenInfo.new(NumberTime)
	local Goal = {Value = Egg.PrimaryPart.CFrame * CFrame.Angles(0,0,math.rad(Rot))}
	TweenModel(Goal,TI,Egg)
end

local function BlurAnimation(Transparency)
	task.spawn(function()
		local Tween = TS:Create(HUD.Blur,TweenInfo.new(0.4),{BackgroundTransparency=Transparency}):Play()
	end)
end

local Buttons = PreviewFrame.Buttons

local function HatchEgg(Egg,Results,HatchFrame)
	local Vars = {
		[1]=0,
		[2]=-2,
		[3]=2
	}
	--// Setup
	local Result = Results[1]
	local Type = Results[2]	
	local Rot, X, Y, Z = Instance.new("NumberValue"), Instance.new("NumberValue"), Instance.new("NumberValue"), Instance.new("NumberValue")

	HatchFrame = PreviewFrame.Parent.HatchFrame[HatchFrame]:Clone()
	HatchFrame.Parent = PreviewFrame.Parent.HatchFrame

	local PetClone = ScaleModel(PetModels[Result]:Clone(), 0.3)

	if not workspace.Eggs:FindFirstChild(Egg) and not workspace.Eggs:FindFirstChild(Egg):FindFirstChild("Egg") then
		Egg = "Basic"
	end

	local EggClone = ScaleModel(workspace.Eggs:FindFirstChild(Egg).Egg:Clone(), 0.3)

	local Rarity = Content.Pets[Result].Rarity
	
	Rot.Value = 30
	Z.Value = -3
	X.Value = 10

	--local Camera = Instance.new("Camera", HatchFrame)
	local Camera = workspace.CurrentCamera

	--// Start Hatch

	HUD.Frames.Visible = false
	HUD.Buttons.Visible = false
	
	PreviewFrame.Buttons.Visible = false
	PreviewFrame.EggInfo.Visible = false
	PreviewFrame.PetChances.Visible = false

	HatchFrame.CurrentCamera = Camera

	local function MoveEgg()
		local X, Y, Z = X.Value, Y.Value, Z.Value
		EggClone:SetPrimaryPartCFrame(Camera:GetRenderCFrame()*CFrame.new(X,Y,Z)*CFrame.Angles(0,0,math.rad(Rot.Value)))
	end
	local function MovePet(Pet,X,Y,Z,Rot)
		local X, Y, Z = X.Value, Y.Value, Z.Value
		Pet:SetPrimaryPartCFrame(Camera:GetRenderCFrame()*CFrame.new(X,Y,Z)*CFrame.Angles(0,math.rad(180+Rot.Value),0))
	end

	for _, Descendant in (EggClone:GetDescendants()) do
		pcall(function()
			Descendant.CanCollide = false
		end)
	end
	
	local HasBlur = false

	if HUD.Blur.BackgroundTransparency <= 0.5 then
		HasBlur = true
		BlurAnimation(1)
	end

	local CameraMove = RuS.Heartbeat:Connect(MoveEgg)
	local CameraMove2 = Camera:GetPropertyChangedSignal("CFrame"):Connect(MoveEgg)

	EggClone.Parent = workspace	

	--// Egg Hatch	

	local HatchSpeed = Multipliers.GetHatchSpeed(Player)

	local tweenInfo = TweenInfo.new(HatchSpeed * 0.09, Enum.EasingStyle.Quad)

	Utilities.Audio.PlayAudio("Wind")

	task.wait(HatchSpeed*0.09)
	local TweenIn = TS:Create(X, TweenInfo.new(HatchSpeed * 0.18, Enum.EasingStyle.Back), {Value = Vars[tonumber(HatchFrame.Name)]})
	local RotTweenIn = TS:Create(Rot, TweenInfo.new(HatchSpeed * 0.18, Enum.EasingStyle.Back), {Value = 0})

	TweenIn:Play()
	RotTweenIn:Play()

	TweenIn.Completed:Wait()
	task.wait(HatchSpeed * 0.03)

	local CrateDelay = 0.075
	for i = 1,((HatchSpeed * 0.4) * 5) + 1 do
		local Tween = TS:Create(Rot, TweenInfo.new(CrateDelay, Enum.EasingStyle.Back), {Value = 6})
		Tween:Play()
		Tween.Completed:Wait()
		Utilities.Audio.PlayAudio("Bounce")
		
		local Tween = TS:Create(Rot, TweenInfo.new(CrateDelay, Enum.EasingStyle.Back), {Value = -6})
		Tween:Play()
		Tween.Completed:Wait()
		Utilities.Audio.PlayAudio("Bounce")
		CrateDelay -= .005
	end

	--// Result

	if HatchFrame.FlashEffect ~= nil then
		HatchFrame.FlashEffect:TweenSize(UDim2.new(1.5,0,1.5,2), "Out", "Linear", .2)
		task.spawn(function()
			for i = 0,1,.1 do
				HatchFrame.FlashEffect.ImageTransparency = i
				task.wait(HatchSpeed * 0.03)
			end
		end)
	end
	
	if not Results[4] then
		Utilities.Audio.PlayAudio("PetReveal")
	else
		Utilities.Audio.PlayAudio(Results[4].."Reveal")
	end

	if Rarity == "Legendary" or Rarity == "Secret" then
		SpawnConfetti(125,HatchFrame,HatchSpeed*0.01)
	end

	EggClone:Destroy()
	CameraMove:Disconnect()
	CameraMove2:Disconnect()

	--PetClone.Parent = HatchFrame
	PetClone.Parent = workspace
	
	local X,Y,Z,Rot = Instance.new("NumberValue"),Instance.new("NumberValue"),Instance.new("NumberValue"), Instance.new("NumberValue")
	local RotTween = TS:Create(Rot, TweenInfo.new(HatchSpeed*.35), {Value = 360})
	RotTween:Play()
	
	local CameraMove = RuS.Heartbeat:Connect(function()
		X.Value = Vars[tonumber(HatchFrame.Name)]
		Z.Value = -2.5
		MovePet(PetClone, X, Y, Z,Rot)
	end)
	local CameraMove2 = Camera:GetPropertyChangedSignal("CFrame"):Connect(function()
		X.Value = Vars[tonumber(HatchFrame.Name)]
		Z.Value = -2.5
		MovePet(PetClone, X, Y, Z,Rot)
	end)
	
	HatchFrame.PetName.Text = Result
	HatchFrame.PetRarity.Text = Rarity
	HatchFrame.PetRarity.TextColor3 = Config.Rarities[Rarity].Color

	if Type > 0 then
		HatchFrame.Evolution.Visible = true
		HatchFrame.Evolution.AutoDeleted.Text = Type
	end

	if Results[3] == true then
		HatchFrame.PetDiscovered.Visible = true
	end

	if Player.AutoDelete[Result].Value then
		HatchFrame.AutoDeleted.Visible = true
	end

	task.wait(HatchSpeed * 0.5)

	HatchFrame.PetName.Text = ""
	HatchFrame.PetRarity.Text = ""

	HatchFrame:TweenPosition(UDim2.new(HatchFrame.Position.X.Scale,0,1.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, HatchSpeed/15, true)
	
	local TI = TweenInfo.new(HatchSpeed * 0.35)
	local Goal = {Value = PetClone.PrimaryPart.CFrame * CFrame.new(0,-10,0)}
	TweenModel(Goal,TI,PetClone)

	task.wait(HatchSpeed * 0.07)
	
	CameraMove:Disconnect()
	CameraMove2:Disconnect()
	PetClone:Destroy()	

	HUD.Frames.Visible = true
	HUD.Buttons.Visible = true
	
	PreviewFrame.Buttons.Visible = true
	PreviewFrame.EggInfo.Visible = true
	PreviewFrame.PetChances.Visible = true
	
	HatchFrame:Destroy()

	if HasBlur == true then
		BlurAnimation(0.4)
	end
end

function eggRequest(EggAmount)
	local Egg = CurrentTarget.Value
	if Content.Eggs[Egg] ~= nil then
		if CurrentTarget.Value ~= "None" then
			if (Player.Character.HumanoidRootPart.Position - workspace.Eggs:FindFirstChild(Egg).PrimaryPart.Position).Magnitude <= 10 then			
				local Result, Message = RS.Remotes.EggOpened:InvokeServer(Egg, EggAmount)
				if Result ~= "Error" and Result ~= nil then
					if math.floor((Player.EggCombo.Value-1)*100) > 1 then
						PreviewFrame.Parent.HatchFrame.Combo.Text = "Egg Luck Combo: "..math.floor((Player.EggCombo.Value-1)*100).."%"
					end
					for i,v in Result do
						task.spawn(function()
							HatchEgg(Egg, v, i)
						end)
					end
					task.wait(Multipliers.GetHatchSpeed(Player))
					PreviewFrame.Parent.HatchFrame.Combo.Text = ""
				else
					if Message ~= nil then
						if Message == "Robux Purchase" and EggAmount == 1 then
							local ProductID = Content.Eggs[Egg]["ProductID"]
							if ProductID ~= nil then
								MPS:PromptProductPurchase(Player, ProductID)
							end
						else
							Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
							return "Error"
						end
					end
				end
			end
		end
	end
end

local AutoHatching = false
local IsInGroup = false

function autoEgg()
	local Egg = CurrentTarget.Value
	local EggData = Content.Eggs[Egg]
	local Cost = EggData.Cost

	if EggData.Currency ~= "R$" then
		if AutoHatching == false then
			while true do
				AutoHatching = true

				if CurrentTarget.Value ~= "None" and CurrentTarget.Value == Egg then
					if IsInGroup and tonumber(Player.Data[EggData.Currency].Value) >= Cost * 3 then
						local Error = eggRequest(3)

						if Error then AutoHatching = false break end
					elseif tonumber(Player.Data[EggData.Currency].Value) >= Cost then
						local Error = eggRequest(1)

						if Error then AutoHatching = false break end					
					else
						AutoHatching = false
						break
					end
				else
					AutoHatching = false
					break
				end		

				wait(0.1)
			end
		end
	end
end

RS.Remotes.SpawnPet.OnClientEvent:Connect(function(Result, Egg)
	print(Result)
	for i,v in Result do
		task.spawn(function()
			HatchEgg(Egg, v, i)
		end)
	end
end)

RS.Remotes.EggOpened.OnClientInvoke = HatchEgg

Buttons.Single.Click.MouseButton1Click:Connect(function()
	eggRequest(1)
end)

Buttons.Triple.Click.MouseButton1Click:Connect(function()
	if IsInGroup then
		eggRequest(3)
	else
		Utilities.Popup.Layered("Join the group to unlock triple hatch.", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
	end
end)

Buttons.Auto.Click.MouseButton1Click:Connect(function()
	autoEgg()
end)

UIS.InputBegan:connect(function(input,gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.E then
			if UIS:GetFocusedTextBox() == nil then
				eggRequest(1)
			end
		elseif input.KeyCode == Enum.KeyCode.R then
			if UIS:GetFocusedTextBox() == nil then
				if IsInGroup then
					eggRequest(3)
				else
					Utilities.Popup.Layered("Join the group to unlock triple hatch.", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
				end
			end
		elseif input.KeyCode == Enum.KeyCode.T then
			if UIS:GetFocusedTextBox() == nil then
				autoEgg()
			end
		end
	end
end)

--// Auto Delete

for _,Slot in PreviewFrame.PetChances.List:GetChildren() do
	if Slot:IsA("Frame") then
		AutoDelete(Slot)
	end
end

--// Group

pcall(function()
	if Player:IsInGroup(12554523) then
		IsInGroup = true
	else
		IsInGroup = false
	end
end)


	
while wait(15) do
	pcall(function()
		if Player:IsInGroup(12554523) then
			IsInGroup = true
		else
			IsInGroup = false
		end
	end)
end