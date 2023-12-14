local Enchant = {}

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Utilities = require(RS.Modules.Client.Utilities)
local Content = require(RS.Modules.Shared.ContentManager)
local Multipliers = require(RS.Modules.Shared.Multipliers)

local HUD = game.Players.LocalPlayer.PlayerGui:WaitForChild("Rank Simulator X"):WaitForChild("HUD")
local Frame = HUD.Frames.Enchant

local CurrentPet = 0
local PetsFolder = Player.Pets
local PetsTable = {}

function Enchant:Init()
	Utilities.ButtonAnimations.Create(Frame.Close)
	Utilities.ButtonAnimations.Create(Frame.Enchant, 1.03)
	
	Frame.Close.Click.MouseButton1Click:Connect(function()
		Utilities.ButtonHandler.OnClick(Frame, UDim2.new(0,0,0,0))
		Utilities.Audio.PlayAudio("Click")
	end)
	
	Frame.Enchant.Click.MouseButton1Click:Connect(function()		
		local Succes, Message = RS.Remotes.PetAction:InvokeServer("Enchant", CurrentPet)

		if Succes == "Succes" then
			Utilities.Popup.Layered(Message, Color3.fromRGB(85, 255, 0), 2, RS.Audio.Completed)
		end
		
		Utilities.Audio.PlayAudio("Click")
	end)
	
	--// Inventory
	task.spawn(function()	
		for _,Pet in PetsFolder:GetChildren() do
			PetsTable[#PetsTable+1] = {Multiplier = Pet.Multiplier1.Value, PetID = Pet.Name}

			CreatePetIcon(Pet)
		end
	end)

	SortInventory()

	PetsFolder.ChildAdded:Connect(function(Child)
		local suc,er = task.spawn(function()
			wait(0.1)
			PetsTable[#PetsTable+1] = {Multiplier = Child.Multiplier1.Value, PetID = Child.Name}
			CreatePetIcon(Child)
			SortInventory()
		end)

		if er then print(er) end
	end)
	
	PetsFolder.ChildRemoved:Connect(function(Child)
		if Frame.WhiteBorder.Holder.PetList:FindFirstChild(Child.Name) then
			Frame.WhiteBorder.Holder.PetList[Child.Name]:Destroy()
		end
		
		for Order,PetInfo in PetsTable do
			if PetInfo.PetID == Child.Name then
				table.remove(PetsTable,Order)
			end
		end
	end)
end

function CreatePetIcon(Pet)
	--// Setup Icon

	repeat task.wait() until Pet:FindFirstChild("PetName")

	local NewSlot = script.PetFrame:Clone()
	NewSlot.Name = Pet.Name
	NewSlot.Parent = Frame.WhiteBorder.Holder.PetList
	
	local PetName = Pet.PetName.Value

	local PetModel = RS.Pets.Models:FindFirstChild(PetName):Clone()
	local Viewport = NewSlot.Image
	local Camera = Instance.new("Camera")

	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
	
	if Content.Pets[PetName].Multiplier ~= "???" then
		NewSlot.Stats.Text = "x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet)) 
	else
		NewSlot.Stats.Text = "???"
	end
	
	Pet.Enchantment.Changed:Connect(function()
		if Content.Pets[PetName].Multiplier ~= "???" then
			NewSlot.Stats.Text = "x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet)) 
		else
			NewSlot.Stats.Text = "???"
		end
	end)
	
	if Pet.Type.Value == 0 then
		NewSlot.Rarity.Text = Content.Pets[PetName].Rarity
	else
		NewSlot.Rarity.Text = Content.Pets[PetName].Rarity.." ("..Pet.Type.Value..")"
	end
	
	NewSlot.Rarity.TextColor3 = require(RS.Pets.Configure).Rarities[Content.Pets[PetName].Rarity].Color
	
	--// OnClick

	NewSlot.TextButton.MouseButton1Click:Connect(function()
		local Old = Frame.WhiteBorder.Holder.PetList:FindFirstChild(tostring(CurrentPet))
		if Old then
			Old.EquipMarker.Visible = false
		end
		NewSlot.EquipMarker.Visible = true
		CurrentPet = tonumber(Pet.Name)
	end)
	
	NewSlot.MouseEnter:Connect(function()
		Utilities.Hover.Create(NewSlot, Frame.Hover, Frame)
		Frame.Hover.Enchantment.Text = Pet.Enchantment.Value
		Frame.Hover.PetName.TextColor3 = require(RS.Pets.Configure).Rarities[Content.Pets[PetName].Rarity].Color

		if Content.Pets[PetName].Multiplier ~= "???" then
			Frame.Hover.Stats.Text = "x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
		else
			Frame.Hover.Stats.Text = "???"
		end
		
		if Pet.Type.Value > 0 then
			Frame.Hover.PetName.Text = PetName.." ("..Pet.Type.Value..")"
		else
			Frame.Hover.PetName.Text = PetName
		end		
	end)
end

function SortInventory()	
	table.sort(PetsTable,function(a,b)
		return a.Multiplier > b.Multiplier
	end)

	for Order,PetInfo in PetsTable do
		if PetsFolder:FindFirstChild(PetInfo.PetID) == nil then
			PetsTable[Order] = nil
			return
		end
		
		pcall(function()
			Frame.WhiteBorder.Holder.PetList[PetInfo.PetID].LayoutOrder = Order
		end)
	end
end



return Enchant
