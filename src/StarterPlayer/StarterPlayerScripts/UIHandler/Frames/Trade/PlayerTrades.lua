--// Services

local PlayerTrades = {}

local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("PolicyService")

--// Variables

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local Remotes = RS.Remotes
local SendOffer = Remotes.Trade.SendOffer
local ChangeOffer = Remotes.Trade.ChangeOffer

local PlayerTrade = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.PlayerTrade
local HoverUI = PlayerTrade.Hover

local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)
local Config = require(RS.Pets.Configure)

local CanTradePaidItems = true

local Count = 5


local success, result = pcall(function()
	return PS:GetPolicyInfoForPlayerAsync(Player)
end)

if not success then
	warn("PolicyService error: " .. result)
elseif result.IsPaidItemTradingAllowed == false then
	print("You cannot trade paid items")
	CanTradePaidItems = false -- paid items arent tradable in korea
end

function CreatePetSlot(Pet,Parent, ParentPlayer)
	--// Setup Icon

	if Content.Pets[Pet.PetName.Value].Multiplier == "???" then
		return
	end

	local NewSlot = script.Template:Clone()
	NewSlot.Name = Pet.Name
	NewSlot.Parent = Parent

	local PetName = Pet.PetName.Value
	local PetType = Pet.Type.Value

	local PetModel = RS.Pets.Models:FindFirstChild(PetName):Clone()
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position
	local Rarity = Content.Pets[PetName].Rarity

	NewSlot.Image.CurrentCamera = Camera
	PetModel.Parent = NewSlot.Image
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z+3),Pos)
	PetModel.PrimaryPart.CFrame *= CFrame.Angles(0, math.rad(90), 0)

	NewSlot.Stats.Text = "x"..Utilities.Short.en(Pet.Multiplier1.Value)

	if PetType == 0 then
		NewSlot.Rarity.Text = Rarity
	else
		NewSlot.Rarity.Text = Rarity .. " ("..PetType..")"
	end

	NewSlot.Locked.Visible = Pet.Locked.Value	
	NewSlot.Rarity.TextColor3 = Config.Rarities[Rarity].Color

	--// OnClick

	NewSlot.TextButton.MouseEnter:Connect(function()
		Utilities.Hover.Create(NewSlot, HoverUI, PlayerTrade)
		HoverUI.Exist.Text = Utilities.Short.en(RS.Pets.Exist.Global[PetType.." "..PetName].Value + RS.Pets.Exist.Server[PetType.." "..PetName].Value).." Exist"
		HoverUI.PetName.Text = PetName
		HoverUI.Enchantment.Text = Pet.Enchantment.Value
	end)

	if Parent == PlayerTrade.YourOffer.Inventory then
		NewSlot.TextButton.MouseButton1Click:Connect(function()
			if PlayerTrade.YourOffer.ReadyCover.Visible == true then
				return
			end

			if Content.Pets[Pet.PetName.Value].Rarity == "Robux" and CanTradePaidItems == false then
				Utilities.Popup.Layered("You can't trade robux pets", Color3.fromRGB(244, 47, 67), 2.5, RS.Audio.Error)
				return -- cant trade robux pets
			end

			local Message = ChangeOffer:InvokeServer(PlayerTrade.Trading.Value, "Add","Pet",Pet.Name)

			if Message == "Added" then
				NewSlot.EquipMarker.Visible = true
				SortInventory(Player,PlayerTrade.YourOffer.Inventory)
			elseif Message == "Removed" then
				NewSlot.EquipMarker.Visible = false
				SortInventory(Player,PlayerTrade.YourOffer.Inventory)
			elseif Message == "Max" then
				Utilities.Popup.Layered("Other player does not have enough storage", Color3.fromRGB(244, 47, 67), 2.5, RS.Audio.Error)
			end
		end)
	end
end


local suc,er = spawn(function()
	while wait(0.1) do

		if PlayerTrade.Trading.Value ~= "" then
			if not game.Players:FindFirstChild(PlayerTrade.Trading.Value) then
				-- cancel trade if player left
				local Message = SendOffer:InvokeServer(PlayerTrade.Trading.Value, "Cancel")

				if Message and Message == "Succes" then
					PlayerTrade.Trading.Value = ""
					PlayerTrade.TradeCountdown.Visible = false
					PlayerTrade.OtherPlayerOffer.ReadyCover.Visible = false
					PlayerTrade.YourOffer.ReadyCover.Visible = false
					PlayerTrade.Ready.TextButton.Text = "Ready"
					Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
				end

				return
			end

			if game.Players[PlayerTrade.Trading.Value].Ready.Value and Player.Ready.Value then
				PlayerTrade.TradeCountdown.Visible = true
				Count -= 0.1
				PlayerTrade.TradeCountdown.Text = (math.round(Count*10)/10).." seconds left..."

				if Count <= 0 then
					Count = 0
					local msg = SendOffer:InvokeServer(PlayerTrade.Trading.Value, "TradeDone")
					print(msg)

					if msg and msg == "Succes" then
						PlayerTrade.Trading.Value = ""
						Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
						PlayerTrade.TradeCountdown.Visible = false
						PlayerTrade.OtherPlayerOffer.ReadyCover.Visible = false
						PlayerTrade.YourOffer.ReadyCover.Visible = false
						PlayerTrade.Ready.TextButton.Text = "Ready"
					end
				end
			end
		end
	end
end)

if er then warn(er) end

function SortInventory(TargetPlayer,Inventory)
	local PetTable = {}

	for _,Pet in TargetPlayer.Pets:GetChildren() do
		if Pet:IsA("Folder") then
			PetTable[#PetTable+1] = {Multiplier = Pet.Multiplier1.Value, PetID = Pet.Name}
		end
	end

	table.sort(PetTable,function(a,b)
		return a.Multiplier > b.Multiplier
	end)

	pcall(function() -- this function sometimes breaks if you craft while trading for example.
		for Order,PetInfo in PetTable do
			if TargetPlayer.Pets[PetInfo.PetID].Equipped.Value then
				Inventory[PetInfo.PetID].LayoutOrder = Order
			else
				Inventory[PetInfo.PetID].LayoutOrder = Order + 200
			end
		end
	end)
end

local function StartTrade()
	PlayerTrade.OtherPlayerOffer.TitleStuff.TextLabel.Text = PlayerTrade.Trading.Value 
	PlayerTrade.YourTokens.WhiteInside.Amount.Text = Utilities.Short.en(Player.Data.TradeTokens.Value).. " Tokens"
	PlayerTrade.OtherPlayerCurrency.Text = "0 Tokens"

	--// Delete Inventory
	for _,Pet in PlayerTrade.YourOffer.Inventory:GetChildren() do
		if Pet:IsA("Frame") then
			Pet:Destroy()
		end
	end

	for _,Pet in PlayerTrade.OtherPlayerOffer.Inventory:GetChildren() do
		if Pet:IsA("Frame") then
			Pet:Destroy()
		end
	end

	--// Create Your inventory
	for _,Pet in Player.Pets:GetChildren() do
		CreatePetSlot(Pet,PlayerTrade.YourOffer.Inventory, Player)
	end

	SortInventory(Player, PlayerTrade.YourOffer.Inventory)

	-- Create other inventory
	for _,Pet in game.Players:FindFirstChild(PlayerTrade.Trading.Value).Pets:GetChildren() do
		CreatePetSlot(Pet,PlayerTrade.OtherPlayerOffer.Inventory, game.Players:FindFirstChild(PlayerTrade.Trading.Value))
	end

	SortInventory(game.Players:FindFirstChild(PlayerTrade.Trading.Value), PlayerTrade.OtherPlayerOffer.Inventory)
end



function PlayerTrades:Init()
	PlayerTrade.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
	end)
	
	PlayerTrade.Trading.Changed:Connect(function()
		if PlayerTrade.Trading.Value ~= "" then
			StartTrade()
		end
	end)
	
	ChangeOffer.OnClientInvoke = function(Type,Amount)
		if Type == "Pet Add" then
			local Slot = PlayerTrade.OtherPlayerOffer.Inventory[Amount] 
			Slot.EquipMarker.Visible = true
			SortInventory(game.Players:FindFirstChild(PlayerTrade.Trading.Value),PlayerTrade.OtherPlayerOffer.Inventory)
		elseif Type == "Tokens Add" then
			PlayerTrade.OtherPlayerCurrency.Text = Utilities.Short.en(Amount).. " Tokens"
		else
			local Slot = PlayerTrade.OtherPlayerOffer.Inventory[Amount] 
			Slot.EquipMarker.Visible = false
			SortInventory(game.Players:FindFirstChild(PlayerTrade.Trading.Value),PlayerTrade.OtherPlayerOffer.Inventory)
		end
	end

	PlayerTrade.Cancel.TextButton.MouseButton1Click:Connect(function()
		if PlayerTrade.Trading.Value ~= "" then
			local Message = SendOffer:InvokeServer(PlayerTrade.Trading.Value, "Cancel")

			if Message and Message == "Succes" then
				PlayerTrade.Trading.Value = ""
				Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
			end
		end
	end)

	PlayerTrade.TokenInput.FocusLost:Connect(function()
		if PlayerTrade.YourOffer.ReadyCover.Visible == true then
			return
		end
		if PlayerTrade.Trading.Value ~= "" and Player.Data.TradeTokens.Value >= tonumber(PlayerTrade.TokenInput.Text) and tonumber(PlayerTrade.TokenInput.Text) >= 0 then
			local Message = ChangeOffer:InvokeServer(PlayerTrade.Trading.Value, "Add","Tokens",tonumber(math.round(PlayerTrade.TokenInput.Text)))
		else
			PlayerTrade.TokenInput.Text = math.clamp(tonumber(PlayerTrade.TokenInput.Text), 0, Player.Data.TradeTokens.Value)
		end
	end)

	PlayerTrade.Ready.TextButton.MouseButton1Click:Connect(function()
		if PlayerTrade.Trading.Value ~= "" then
			local Message = SendOffer:InvokeServer(PlayerTrade.Trading.Value, "Ready")

			PlayerTrade.OtherPlayerOffer.ReadyCover.Visible = game.Players[PlayerTrade.Trading.Value].Ready.Value
			PlayerTrade.YourOffer.ReadyCover.Visible = Player.Ready.Value

			if Message and Message == "Ready" then
				Count = 5
				PlayerTrade.Ready.TextButton.Text = "Unready"
			elseif Message == "Unready" then
				Count = 9999999
				PlayerTrade.Ready.TextButton.Text = "Ready"
				PlayerTrade.TradeCountdown.Visible = false
			end
		end
	end)

	SendOffer.OnClientInvoke = function(Option)

		PlayerTrade.OtherPlayerOffer.ReadyCover.Visible = game.Players[PlayerTrade.Trading.Value].Ready.Value
		PlayerTrade.YourOffer.ReadyCover.Visible = Player.Ready.Value

		if Option == "Cancel" then
			PlayerTrade.Trading.Value = ""
			PlayerTrade.OtherPlayerCurrency.Text = "0 Tokens"
			Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
		elseif Option == "Ready" then
			Count = 5
		elseif Option == "Unready" then
			Count = 9999999
			PlayerTrade.TradeCountdown.Visible = false
		elseif Option == "TradeDone" then
			PlayerTrade.Trading.Value = ""
			Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0,0,0,0))
			PlayerTrade.TradeCountdown.Visible = false
			PlayerTrade.OtherPlayerOffer.ReadyCover.Visible = false
			PlayerTrade.YourOffer.ReadyCover.Visible = false
			PlayerTrade.Ready.TextButton.Text = "Ready"
		end
	end

end

return PlayerTrades