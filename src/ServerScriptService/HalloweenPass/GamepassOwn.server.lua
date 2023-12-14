local Players = game:GetService("Players")
local MarketPlaceService = game:GetService("MarketplaceService")

game.Players.PlayerAdded:Connect(function(player)
	wait(5)
	local GpId = 271771480
	if MarketPlaceService:UserOwnsGamePassAsync(player.UserId,GpId) then
		player.Data.x2Candy.Value = true
	end
end)
