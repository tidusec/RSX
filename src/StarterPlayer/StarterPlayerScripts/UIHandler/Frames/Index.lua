local IndexModule = {}
--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()


local PetFolder = Player.Pets

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Config = require(RS.Pets.Configure)
local Utilities = require(Modules.Client.Utilities)
local IndexRewards = require(Modules.Shared.IndexRewards)

local PetModels = RS.Pets.Models

local Index = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Index")
local Scroll = Index.MainFrame.ScrollingFrame
local HoverUI = Index.Hover


function startHover(Button, PetName, Exist, Hatched, Rarity)
	local MoveHoverUI = Mouse.Move:Connect(function()
		HoverUI.Visible = true
		HoverUI.Position = UDim2.fromOffset(
			Mouse.X-Index.AbsolutePosition.X, 
			Mouse.Y-Index.AbsolutePosition.Y
		)

		HoverUI.Exist.Text = Exist.." Exist"
		HoverUI.Hatched.Text = "You hatched "..Hatched
		HoverUI.PetName.Text = PetName
		HoverUI.PetName.TextColor3 = Config.Rarities[Rarity].Color
	end)
	local Disconnect

	Disconnect = Button.MouseLeave:Connect(function()
		HoverUI.Visible = false

		MoveHoverUI:Disconnect()
		Disconnect:Disconnect()
	end)
end

local function SetPetSlot(Viewport,Pet)
	local PetModel = PetModels:FindFirstChild(Pet)
	
	if not PetModel then warn(Pet.." does not exist in Pet Models") return end
	
	PetModel = PetModel:Clone()

	if not PetModel.PrimaryPart then
		warn(PetModel.Name.." does not have a primary part")
		return
	end

	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
end

--// Index Rewards
local RewardsFrame = Index.MainFrame.Rewards

local TotalPets = 0

for _,Pet in Content.Pets do if Pet.Rarity ~= "Special" then TotalPets += 1 end end -- calculates total pets

local function GetOwnedPets()
	local Amount = 0
	for _,IndexPets in Player.Index:GetChildren() do
		local PetRarity = Content.Pets[IndexPets.Name].Rarity
		if PetRarity ~= "Special" and PetRarity ~= nil then
			Amount += 1
		end
	end
	return Amount
end

local OwnedPets = GetOwnedPets()

local function UpdateRewardFrame()
	for i = 1, #IndexRewards do
		if i < #IndexRewards then
			if OwnedPets < IndexRewards[i].Requirement then
				RewardsFrame.TextLabel.Text = "Get "..IndexRewards[i].Requirement.." Pets for +"..IndexRewards[i].Amount.." Pet Equipped"
				RewardsFrame.ProgressHolder.ProgressBar.Size = UDim2.new(OwnedPets/IndexRewards[i].Requirement,0,1,0)
				RewardsFrame.ProgressHolder.ProgressIndicator.Text = OwnedPets.."/"..IndexRewards[i].Requirement
				return
			end
		else
			RewardsFrame.TextLabel.Text = "Completed Index Rewards. +"..IndexRewards[i].Amount.." Pet Equipped"
			RewardsFrame.ProgressHolder.ProgressBar.Size = UDim2.new(1,0,1,0)
			RewardsFrame.ProgressHolder.ProgressIndicator.Text = OwnedPets.."/"..TotalPets
		end
	end
end

function IndexModule:Init()
	Utilities.ButtonAnimations.Create(Index.Close)
	spawn(function()
		for Pet,PetInfo in Content.Pets do
			if PetInfo.Rarity ~= "Special" then
				local PetFrame = script.IndexPetTemplate:Clone()
				PetFrame.Parent = Scroll
				PetFrame.LayoutOrder = Config.Rarities[PetInfo.Rarity].SortOrder
				PetFrame.Name = Pet

				PetFrame.MouseEnter:Connect(function()
					if Player.Index:FindFirstChild(Pet) then
						startHover(PetFrame, Pet, Utilities.Short.en(RS.Pets.Exist.Global["0 "..Pet].Value + RS.Pets.Exist.Server["0 "..Pet].Value), Utilities.Short.en(Player.Index[Pet].Value), PetInfo.Rarity)
					else
						startHover(PetFrame, Pet, Utilities.Short.en(RS.Pets.Exist.Global["0 "..Pet].Value + RS.Pets.Exist.Server["0 "..Pet].Value), 0, PetInfo.Rarity)
					end
				end)


				SetPetSlot(PetFrame.View, Pet)

				if not Player.Index:FindFirstChild(Pet) then
					PetFrame.Hatched.Text = ""
					PetFrame.View.ImageColor3 = Color3.fromRGB(0,0,0)
				else
					PetFrame.Hatched.Text = Player.Index[Pet].Value
					PetFrame.View.ImageColor3 = Color3.fromRGB(255,255,255)
				end
			elseif Pet == "Monstrous Star" then
				local PetFrame = script.IndexPetTemplate:Clone()
				PetFrame.Parent = Scroll
				PetFrame.LayoutOrder = Config.Rarities[PetInfo.Rarity].SortOrder
				PetFrame.Name = Pet

				PetFrame.MouseEnter:Connect(function()
					if Player.Index:FindFirstChild(Pet) then
						startHover(PetFrame, Pet, Utilities.Short.en(RS.Pets.Exist.Global["0 "..Pet].Value + RS.Pets.Exist.Server["0 "..Pet].Value), Utilities.Short.en(Player.Index[Pet].Value), PetInfo.Rarity)
					else
						startHover(PetFrame, Pet, Utilities.Short.en(RS.Pets.Exist.Global["0 "..Pet].Value + RS.Pets.Exist.Server["0 "..Pet].Value), 0, PetInfo.Rarity)
					end
				end)


				SetPetSlot(PetFrame.View, Pet)

				if not Player.Index:FindFirstChild(Pet) then
					PetFrame.Hatched.Text = ""
					PetFrame.View.ImageColor3 = Color3.fromRGB(0,0,0)
				else
					PetFrame.Hatched.Text = Player.Index[Pet].Value
					PetFrame.View.ImageColor3 = Color3.fromRGB(255,255,255)
				end
			end
		end
	end)
	
	Index.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Index,UDim2.new(0,0,0,0))
	end)
	
	Player.Index.ChildAdded:Connect(function(Pet)
		Scroll[Pet.Name].Hatched.Text = Pet.Value
		Scroll[Pet.Name].View.ImageColor3 = Color3.fromRGB(255,255,255)
	end)
	
	UpdateRewardFrame()
	
	Player.Index.ChildAdded:Connect(function()
		OwnedPets += 1
		UpdateRewardFrame()
	end)

	task.wait(1)
	Scroll.CanvasSize = UDim2.new(0, 0, 0, Scroll.AbsoluteCanvasSize.Y + 45)
end

return IndexModule
