local PassId = 271771480
local MarketPlaceService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

script.Parent.MouseButton1Click:Connect(function()
	MarketPlaceService:PromptGamePassPurchase(player,PassId)
end)