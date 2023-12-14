local HalloweenShop = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Modules = ReplicatedStorage.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)

local HalloweenInfoModule = Content.HalloweenModule

local PetModels = ReplicatedStorage.Pets.Models

local debounce = false

local HalloweenShopContainer = LocalPlayer.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.HalloweenShop.WhiteBorder.Holder
local PetFrame = HalloweenShopContainer.ScrollingFrame.Pet

local tableInfo = {
	["GemBoost"] = "HalloweenGemBoostClaimed",
	["GemUpgrade"] = "HalloweenGemUpgrade",
	["LuckBoost"] = "HalloweenLuckBoostClaimed",
	["Pet"] = "HalloweenPetClaimed",
	["StarBoost"] = "HalloweenStarBoostClaimed",
	["StarUpgrade"] = "HalloweenStarUpgrade"
}

function HalloweenShop:LoadButtons(Frame)
	if HalloweenInfoModule.Prices[Frame.Name] then
		local CostValue = HalloweenInfoModule.Prices[Frame.Name]
		if HalloweenInfoModule.OriginalAmount[Frame.Name] - LocalPlayer.Data[tableInfo[Frame.Name]].Value <= 0 then
			Frame.Buy.Label.Text = "Max"
		else
			Frame.Buy.Label.Text = Utilities.Short.en(CostValue)
		end
	else
		if HalloweenInfoModule.Upgrades[Frame.Name] then
			local CostValue = HalloweenInfoModule.Upgrades[Frame.Name].Prices( math.clamp(LocalPlayer.Data[tableInfo[Frame.Name]].Value + 1, 0, HalloweenInfoModule.Upgrades[Frame.Name].Max)).Price
			if LocalPlayer.Data[tableInfo[Frame.Name]].Value >= HalloweenInfoModule.Upgrades[Frame.Name].Max then
				Frame.Buy.Label.Text = "Max"
			else
				Frame.Buy.Label.Text = Utilities.Short.en(CostValue)
			end
		end
	end

	
	Frame.Buy.Button.MouseButton1Click:Connect(function()
		if not debounce then
			debounce = true
			ReplicatedStorage.Remotes.AddHalloweenShop:FireServer(Frame.Name)
			task.wait(1)
			debounce = false
		end
	end)
end

function HalloweenShop:LoadFrames(Frame)
	if Frame.Name ~= "StarUpgrade" and Frame.Name ~= "GemUpgrade" then
		if HalloweenInfoModule.OriginalAmount[Frame.Name] then
			local text = HalloweenInfoModule.OriginalAmount[Frame.Name] - LocalPlayer.Data[tableInfo[Frame.Name]].Value 
			Frame.Stock.Text = text .. " in stock"
		end
	else
		if HalloweenInfoModule.Upgrades[Frame.Name] then
			local text = LocalPlayer.Data[tableInfo[Frame.Name]].Value .. "/" .. HalloweenInfoModule.Upgrades[Frame.Name].Max
			Frame.Stock.Text = text
		end
	end
end

function HalloweenShop:Init()
	Utilities.ButtonAnimations.Create(HalloweenShopContainer.Parent.Parent.Close)
	HalloweenShopContainer.Parent.Parent.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HalloweenShopContainer.Parent.Parent, UDim2.new(0,0,0,0))
	end)	


	local PetModel = PetModels:FindFirstChild("Monstrous Star"):Clone()
	local Viewport = PetFrame.ViewportFrame
	local Camera = Instance.new("Camera")
	local Pos = PetModel.PrimaryPart.Position

	Viewport.CurrentCamera = Camera
	PetModel.Parent = Viewport
	Camera.CFrame = CFrame.new(Vector3.new(Pos.X-2,Pos.Y,Pos.Z-4),Pos)

	ReplicatedStorage.Remotes.HalloweenClaim.OnClientEvent:Connect(function(ItemName: any)  

	end)
	
	--// Create animation
	for _, Frame in HalloweenShopContainer.ScrollingFrame:GetChildren() do
		if not Frame:IsA("Frame") then continue end
		Utilities.ButtonAnimations.Create(Frame.Buy)
	end
	
	--// tolu why are u looping every () abru
	task.spawn(function()
		while task.wait() do
			for i, Frames in HalloweenShopContainer.ScrollingFrame:GetChildren() do
				if Frames:IsA("Frame") then
					
					self:LoadButtons(Frames)
					self:LoadFrames(Frames)
				end
			end
		end
	end)

	--LocalPlayer.Data.HalloweenStarUpgrade.Changed:Connect(function()
	--	self:LoadFrames(HalloweenShopContainer.ScrollingFrame.StarUpgrade)
	--	self:LoadButtons(HalloweenShopContainer.ScrollingFrame.StarUpgrade)
	--end)
	--LocalPlayer.Data.HalloweenGemUpgrade.Changed:Connect(function()
	--	self:LoadFrames(HalloweenShopContainer.ScrollingFrame.GemUpgrade)
	--	self:LoadButtons(HalloweenShopContainer.ScrollingFrame.GemUpgrade)
	--end)
	--LocalPlayer.Data.HalloweenStarBoostClaimed.Changed:Connect(function()
	--	self:LoadFrames(HalloweenShopContainer.ScrollingFrame.StarBoost)
	--	self:LoadButtons(HalloweenShopContainer.ScrollingFrame.StarBoost)
	--end)
	----LocalPlayer.Data.HalloweenLuckBoostClaimed.Changed:Connect(function()
	----	--self:LoadFrames(HalloweenShopContainer.ScrollingFrame.StarBoost)
	----end)
	--LocalPlayer.Data.HalloweenGemBoostClaimed.Changed:Connect(function()
	--	self:LoadFrames(HalloweenShopContainer.ScrollingFrame.GemBoost)
	--	self:LoadButtons(HalloweenShopContainer.ScrollingFrame.GemBoost)
	--end)
	--LocalPlayer.Data.HalloweenPetClaimed.Changed:Connect(function()
	--	self:LoadFrames(HalloweenShopContainer.ScrollingFrame.Pet)
	--	self:LoadButtons(HalloweenShopContainer.ScrollingFrame.Pet)
	--end)
end

return HalloweenShop
