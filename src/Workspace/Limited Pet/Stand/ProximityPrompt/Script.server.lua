local MPS = game:GetService("MarketplaceService")
local MS = game:GetService("MessagingService")
local DS = game:GetService("DataStoreService")

local Stand = script.Parent.Parent

local PetsSoldData = DS:GetDataStore("LimitedPet")
local AmountSold = nil

local suc,er = pcall(function()
	AmountSold = PetsSoldData:GetAsync(Stand.Datastore.Value)
end)

if er then warn(er) end

if AmountSold == nil then PetsSoldData:SetAsync(Stand.Datastore.Value,0) AmountSold = 0 end

local BillboardHolder = Stand.Parent.BillboardHolder
local BillboardGui = BillboardHolder.BillboardGui

local ID = 1549212591

BillboardGui.Sold.Text = AmountSold.."/"..Stand.Amount.Value.." Bought!"

MS:SubscribeAsync("BoughtPet", function()
	wait(1)
	AmountSold = PetsSoldData:GetAsync(Stand.Datastore.Value)
	BillboardGui.Sold.Text = AmountSold.."/"..Stand.Amount.Value.." Bought!"
end)

script.Parent.Triggered:Connect(function(Player)
	if AmountSold < Stand.Amount.Value and Player:FindFirstChild("Loaded") and Player.Loaded.Value then
		MPS:PromptProductPurchase(Player, ID)
	end
end)