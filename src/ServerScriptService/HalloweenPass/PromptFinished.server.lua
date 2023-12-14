local Player = game:GetService("Players")
local gamepasstable = {
	[271771480] = "x2CandyCorn";

}
local MarketPlaceService = game:GetService("MarketplaceService")
MarketPlaceService.PromptGamePassPurchaseFinished:Connect(function(player, GamepassId, sucess)
	if sucess == false then
		return end
	if gamepasstable[GamepassId] then
		if gamepasstable[GamepassId] == "x2CandyCorn" then
			player.Data.x2Candy.Value = true
		end
	end
end)