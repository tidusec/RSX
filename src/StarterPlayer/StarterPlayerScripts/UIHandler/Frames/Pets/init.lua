local PetInventory = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local Plrs = game:GetService("Players")

--// Variables

local Rarities = 3

local Player = Plrs.LocalPlayer

local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)
local Multipliers = require(Modules.Shared.Multipliers)
local PetConfig = require(RS.Pets.Configure)

local PetModels = RS.Pets.Models

local PetsFolder = Player.Pets

local PetsFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Pets")
PetsFrame.Visible = false

local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD
local Popups = HUD.Parent.Popups
local DeletePet = Popups.DeletePet

local LeftSide = PetsFrame.LeftSide
local RightSide = PetsFrame.RightSide

local Remotes = RS.Remotes
local PetAction = Remotes.PetAction

local CurrentlySelected = ""

LeftSide.DescriptionBlocker.Visible = true

RightSide.Close.TextButton.MouseButton1Click:Connect(function()
	Utilities.ButtonHandler.OnClick(PetsFrame, UDim2.new(0,0,0,0))
end)

Utilities.ButtonAnimations.Create(RightSide.Close)

local CurrentlyDeleting = false
local DeletedPets = {}

local PetsTable = {}

--// Animations

local ButtonAnimations = require(script.ButtonAnimations)
ButtonAnimations.CreateAnimations()

--// Function AmountOfAPet

function GetAllPetsOfAType(Pet)
	local Counter = 0

	for _,SelectedPet in PetsFolder:GetChildren() do
		if SelectedPet.PetName.Value == Pet.PetName.Value and SelectedPet.Type.Value == Pet.Type.Value and not Pet.Locked.Value then
			Counter += 1
		end
	end

	return Counter
end

--// Function GetEvolutionStars

function GetEvolutionStars(Evolution)
	if Evolution < 6 then
		for i = 1,5 do
			LeftSide.PetFrame.Tiers.Num.Visible = false
			if Evolution >= i then
				LeftSide.PetFrame.Tiers[i].Visible = true
			else
				LeftSide.PetFrame.Tiers[i].Visible = false
			end
		end
	else
		for i = 1,5 do
			LeftSide.PetFrame.Tiers[i].Visible = false
		end
		
		LeftSide.PetFrame.Tiers.Num.Visible = true
		LeftSide.PetFrame.Tiers.Num.Amount.Text = "T"..Evolution
	end
end

--// Function InventoryInfo

local InvInfo = LeftSide.InvInfo

local function UpdateInvInfo()
	InvInfo.Text.Equips.Text = Player.Data.PetsEquipped.Value.."/"..Multipliers.GetMaxPetsEquipped(Player)
	InvInfo.Text.TextLabel.Text = Player.Data.PetsOwned.Value.."/"..Multipliers.GetMaxPetStorage(Player)
end

--// Function Side Frame

local function ChangeSideFrame(Pet)
	if LeftSide.PetFrame.Image:FindFirstChildOfClass("Model") then
		LeftSide.PetFrame.Image:FindFirstChildOfClass("Model"):Destroy()
	end

	CurrentlySelected = Pet

	if Pet.Equipped.Value then
		LeftSide.Buttons.Equip.Clicker.Text = "Unequip"
	else
		LeftSide.Buttons.Equip.Clicker.Text = "Equip"
	end

	local PetModel = PetModels:FindFirstChild(Pet.PetName.Value):Clone()
	local Viewport = LeftSide.PetFrame.Image
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)

	LeftSide.White.PetName.Text = Pet.PetName.Value
	
	if Content.Pets[Pet.PetName.Value].Multiplier ~= "???" then
		LeftSide.PetFrame.Stats.Stars.Text = "⭐ x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
	else
		LeftSide.PetFrame.Stats.Text = "???"
	end
	
	LeftSide.PetRarity.Text = Content.Pets[Pet.PetName.Value].Rarity
	LeftSide.PetRarity.TextColor3 = PetConfig.Rarities[Content.Pets[Pet.PetName.Value].Rarity].Color
	
	if Pet.Locked.Value then
		LeftSide.PetFrame.Locked.ImageTransparency = 0
	else
		LeftSide.PetFrame.Locked.ImageTransparency = 0.5
	end
	
	pcall(function()
		LeftSide.PetFrame.Exist.Text = Utilities.Short.en(RS.Pets.Exist.Global[Pet.Type.Value.." "..Pet.PetName.Value].Value + RS.Pets.Exist.Server[Pet.Type.Value.." "..Pet.PetName.Value].Value).." Exist"
	end)
	
	LeftSide.PetFrame.Enchantment.Text = Pet.Enchantment.Value == "" and "No Enchant" or Pet.Enchantment.Value

	LeftSide.Buttons.Craft.Clicker.Text = "Craft ("..GetAllPetsOfAType(Pet).."/5)"
	GetEvolutionStars(Pet.Type.Value)

	LeftSide.DescriptionBlocker.Visible = false
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
		
		if PetsFolder[PetInfo.PetID].Equipped.Value then
			RightSide.PetList[PetInfo.PetID].LayoutOrder = Order
		else
			if RightSide.PetList:FindFirstChild(PetInfo.PetID) then
				RightSide.PetList[PetInfo.PetID].LayoutOrder = Order + 200
			end
		end
	end
end

--// Function Pet slot

local function CreatePetIcon(Pet)
	--// Setup Icon
	
	repeat task.wait() until Pet:FindFirstChild("PetName")
	
	local NewSlot = script.PetFrame:Clone()
	NewSlot.Name = Pet.Name
	NewSlot.Parent = RightSide.PetList
	
	local PetName = Pet.PetName.Value
	
	local PetModel = PetModels:FindFirstChild(PetName):Clone()
	local Viewport = NewSlot.Image
	local Camera = Instance.new("Camera")
	
	local Pos = PetModel.PrimaryPart.Position
	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)
	NewSlot.Locked.Visible = Pet.Locked.Value
	
	if Content.Pets[PetName].Multiplier ~= "???" then
			NewSlot.Stats.Text = "⭐ x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
		else
		NewSlot.Stats.Text = "???"
	end

	if Pet.Type.Value == 0 then
		NewSlot.Rarity.Text = Content.Pets[PetName].Rarity
	else
		NewSlot.Rarity.Text = Content.Pets[PetName].Rarity.." ("..Pet.Type.Value..")"
	end

	NewSlot.Rarity.TextColor3 = PetConfig.Rarities[Content.Pets[PetName].Rarity].Color

	--// OnEquipped
	
	NewSlot.EquipMarker.Visible = Pet.Equipped.Value

	Pet.Multiplier1.Changed:Connect(function()
		if Content.Pets[PetName].Multiplier ~= "???" then
				NewSlot.Stats.Text = "⭐ x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
			else
			NewSlot.Stats.Text = "???"
		end
		SortInventory()
	end)	
	
	Pet.Enchantment.Changed:Connect(function()
		if Content.Pets[PetName].Multiplier ~= "???" then
				NewSlot.Stats.Text = "⭐ x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
			else
			NewSlot.Stats.Text = "???"
		end
	end)
	
	Player.Data.Perk3.Changed:Connect(function()
		if Content.Pets[PetName].Multiplier ~= "???" then
				NewSlot.Stats.Text = "⭐ x"..Utilities.Short.en(Pet.Multiplier1.Value * Multipliers.GetPetMulti(Player, Pet))
			end
		end)

	Pet.Equipped.Changed:Connect(function()
		if Pet.Equipped.Value then
			NewSlot.LayoutOrder = PetConfig.Rarities[Content.Pets[PetName].Rarity].SortOrder
			NewSlot.EquipMarker.Visible = true
		else
			NewSlot.LayoutOrder = Rarities + PetConfig.Rarities[Content.Pets[PetName].Rarity].SortOrder
			NewSlot.EquipMarker.Visible = false
		end
		SortInventory()
	end)
	
	Pet.Locked.Changed:Connect(function()
		NewSlot.Locked.Visible = Pet.Locked.Value
	end)

	--// OnClick

	NewSlot.TextButton.MouseButton1Click:Connect(function()
		if not CurrentlyDeleting then
			ChangeSideFrame(Pet)
		else
			if NewSlot.CrossMarker.Visible == false then
				NewSlot.CrossMarker.Visible = true
				table.insert(DeletedPets,Pet.Name)
			else
				for i,v in DeletedPets do
					if v == Pet.Name then
						table.remove(DeletedPets,i)
					end
				end

				NewSlot.CrossMarker.Visible = false
			end

			LeftSide.MultiDeleteFrame.SelectedPets.Text = "Currently selected: "..#DeletedPets
		end
	end)
end

wait(1)

for _,Pet in PetsFolder:GetChildren() do
	PetsTable[#PetsTable+1] = {Multiplier = Pet.Multiplier1.Value, PetID = Pet.Name}
		
	CreatePetIcon(Pet)
end

SortInventory()

PetsFolder.ChildAdded:Connect(function(Child)
	local suc,er = spawn(function()
		wait(0.1)
		PetsTable[#PetsTable+1] = {Multiplier = Child.Multiplier1.Value, PetID = Child.Name}
		CreatePetIcon(Child)
		SortInventory()
	end)
	
	if er then print(er) end
end)

PetsFolder.ChildRemoved:Connect(function(Child)
	if RightSide:FindFirstChild("PetList"):FindFirstChild(Child.Name) then
		RightSide.PetList[Child.Name]:Destroy()
	end

	for Order,PetInfo in PetsTable do
		if PetInfo.PetID == Child.Name then
			table.remove(PetsTable,Order)
		end
	end
end)

--// Equip
Utilities.ButtonAnimations.Create(RightSide.Close)

LeftSide.Buttons.Equip.Clicker.MouseButton1Click:Connect(function()
	local Succes,Message = PetAction:InvokeServer("Equip",{CurrentlySelected.Name})
		
	if Succes == "Succes" then
		if CurrentlySelected.Equipped.Value then
			LeftSide.Buttons.Equip.Clicker.Text = "Unequip"
		else
			LeftSide.Buttons.Equip.Clicker.Text = "Equip"
		end
	else
		if Message then
			Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
		end
	end
end)

--// Delete

LeftSide.Buttons.Delete.Clicker.MouseButton1Click:Connect(function()
	local Pet = PetsFolder:FindFirstChild(CurrentlySelected.Name)
	local Rarity = Content.Pets[Pet.PetName.Value].Rarity
	
	if Rarity == "Robux" or Rarity == "Legendary" or Rarity == "Secret" then -- rarities where u need to "confirm" to delete
		DeletePet.Visible = true
		DeletePet.PetID.Value = CurrentlySelected.Name
		
		if Pet.Type.Value > 0 then
			DeletePet.Description.Text = "Are you sure you want to delete your "..Pet.Type.Value.." Star "..Rarity.." "..Pet.PetName.Value.."?"
		else
			DeletePet.Description.Text = "Are you sure you want to delete your "..Rarity.." "..Pet.PetName.Value.."?"
		end
	else
		local Succes = PetAction:InvokeServer("Delete",CurrentlySelected.Name)

		if Succes == "Succes" then
			LeftSide.DescriptionBlocker.Visible = true
			CurrentlySelected = ""
			SortInventory()
		end
	end	
end)

DeletePet.Buttons.Yes.TextButton.MouseButton1Click:Connect(function()
	local Succes,Message = PetAction:InvokeServer("Delete",DeletePet.PetID.Value)
		
	if Succes == "Succes" then
		LeftSide.DescriptionBlocker.Visible = true
		CurrentlySelected = ""
		SortInventory()
		DeletePet.Visible = false
	else
		Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 2, RS.Audio.Error)
		DeletePet.Visible = false
	end
end)

DeletePet.Buttons.No.TextButton.MouseButton1Click:Connect(function()
	DeletePet.Visible = false
end)

--// Craft Button

LeftSide.Buttons.Craft.Clicker.MouseButton1Click:Connect(function()
	local Succes = PetAction:InvokeServer("Craft",CurrentlySelected.Name)

	if Succes == "Succes" then
		LeftSide.DescriptionBlocker.Visible = true
		CurrentlySelected = ""
		SortInventory()
	end
end)

--// Lock Button

LeftSide.PetFrame.Locked.TextButton.MouseButton1Click:Connect(function()
	local Succes,Message = PetAction:InvokeServer("Lock",CurrentlySelected.Name)

	if Succes == "Succes" then
		if CurrentlySelected.Locked.Value then
			LeftSide.PetFrame.Locked.ImageTransparency = 0
		else
			LeftSide.PetFrame.Locked.ImageTransparency = 0.5
		end
	else
		if Message then
			Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
		end
	end
end)

--// BottomButtons

local Buttons = RightSide.Buttons
local CraftAll = Buttons.CraftAll
local EquipBest = Buttons.EquipBest
local MultiDelete = Buttons.MultiDelete
local UnequipAll = Buttons.UnequipAll

--// Main

UnequipAll.Clicker.MouseButton1Click:Connect(function()
	local x = {}
	for _,v in PetsFolder:GetChildren() do
		if v.Equipped.Value then
			table.insert(x, tonumber(v.Name))
		end
	end
	PetAction:InvokeServer("Equip",x)
end)

local EquipBestCooldown = false
local CraftCooldown = false

EquipBest.Clicker.MouseButton1Click:Connect(function()
	if not EquipBestCooldown then
		CancelMultiDelete()
		EquipBestCooldown = true
		
		local suc,er = pcall(function() -- added pcall for if it breaks, it can just be retried.
			local SortedList = {}
			
			local Unequip = {}
			for _,v in PetsFolder:GetChildren() do
				if v ~= nil then
					if v.Equipped.Value then
						table.insert(Unequip, v.Name)
					end

					table.insert(SortedList,{ID = v.Name,MULTI = v.Multiplier1.Value})
				end
			end
			
			PetAction:InvokeServer("Equip",Unequip)

			table.sort(SortedList, function(x,y)
				return x.MULTI > y.MULTI
			end)

			local Equipped = 0
			
			local ToEquip = {}
			for _,v in SortedList do
				if Equipped < Multipliers.GetMaxPetsEquipped(Player) then
					Equipped += 1
					table.insert(ToEquip, v.ID)
				end
			end
			
			PetAction:InvokeServer("Equip", ToEquip)
		end)
		
		if er then warn("An error has occured in the Equipbest function: "..er) end

		wait(0.25)
		EquipBestCooldown = false
	end	
end)

function CancelMultiDelete()
	for _,v in DeletedPets do
		RightSide.PetList[v].CrossMarker.Visible = false
	end

	DeletedPets = {}
	CurrentlyDeleting = false

	MultiDelete.Clicker.Text = "Multi Delete"
	LeftSide.MultiDeleteFrame.Visible = false
	LeftSide.DescriptionBlocker.Visible = true
end

MultiDelete.Clicker.MouseButton1Click:Connect(function()
	if not CurrentlyDeleting then
		CurrentlyDeleting = true

		LeftSide.DescriptionBlocker.Visible = false
		LeftSide.MultiDeleteFrame.Visible = true
		MultiDelete.Clicker.Text = "Cancel"
		LeftSide.MultiDeleteFrame.SelectedPets.Text = "Currently Selected: 0"
	else
		CancelMultiDelete()
	end
end)

LeftSide.MultiDeleteFrame.Delete.TextButton.MouseButton1Click:Connect(function()
	if CurrentlyDeleting then
		for _,v in DeletedPets do
			PetAction:InvokeServer("Delete", v)
		end

		LeftSide.DescriptionBlocker.Visible = true
		LeftSide.MultiDeleteFrame.Visible = false

		DeletedPets = {}
		CurrentlyDeleting = false
		MultiDelete.Clicker.Text = "Multi Delete"

		SortInventory()
	end
end)

function CraftAllFunc()
	if not CraftCooldown then
		CancelMultiDelete()

		--// Craft All
		CraftCooldown = true
		local CraftedPets = {}

		local AmountCrafted = 0

		for _,Pet in PetsFolder:GetChildren() do
			if Pet:FindFirstChild("PetName") and Pet.Locked.Value == false then
				if not CraftedPets[Pet.PetName.Value..Pet.Type.Value] then
					CraftedPets[Pet.PetName.Value..Pet.Type.Value] = {Amount = 1, BasePet = Pet.Name}
				else
					local CraftedPet = CraftedPets[Pet.PetName.Value..Pet.Type.Value] 
					CraftedPet.Amount = CraftedPet.Amount + 1

					--// Craft & Reset amount so it can craft multiple
					if CraftedPet.Amount == 5 and Pet.Type.Value < 5 then
						PetAction:InvokeServer("Craft",Pet.Name)
						CraftedPet.Amount = 0
						AmountCrafted += 1
					end
				end
			end
		end

		if AmountCrafted == 1 then
			LeftSide.DescriptionBlocker.Visible = true
			Utilities.Popup.Layered("Succesfully crafted 1 pet", Color3.fromRGB(255, 247, 23), 2, RS.Audio.Completed)
		elseif AmountCrafted > 1 then
			LeftSide.DescriptionBlocker.Visible = true
			Utilities.Popup.Layered("Succesfully crafted "..AmountCrafted.." pets", Color3.fromRGB(255, 247, 23), 2, RS.Audio.Completed)
		end

		SortInventory()
		wait(0.35)
		CraftCooldown = false
	end
end

CraftAll.Clicker.MouseButton1Click:Connect(function()
	CraftAllFunc()
end)

task.spawn(function()
	while wait(15) do
		if Player.Data.Upgrade8.Value > 0 and not Player.Data.AutoCraft.Value then
			CraftAllFunc()
		end
	end
end)

--// PetInv Updating

UpdateInvInfo()

Player.Data.PetsOwned.Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data.PetsEquipped.Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data["+2PetsEquipped"].Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data["+3PetsEquipped"].Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data["+50Storage"].Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data["+250Storage"].Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data.Perk8.Changed:Connect(function()
	UpdateInvInfo()
end)

Player.Data.IndexEquips.Changed:Connect(function()
	UpdateInvInfo()
end)


return PetInventory
