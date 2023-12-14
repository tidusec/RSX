--// Handles all frames

local Frames = {}

function Frames:Init()
	task.spawn(function()
		require(script.PerkInventory):Init()
	end)
	task.spawn(function()
		require(script.Pets)
	end)
	task.spawn(function()
		require(script.DailyGift):Init()
	end)
	require(script.Enchant):Init()
	require(script.Settings):Init()
	require(script.Title):Init()
	require(script.Halloween):Init()
	require(script.HalloweenShop):Init()
	require(script.RankShop):Init()
	require(script.Achievment):Init()
	require(script.Index):Init()
	require(script.Shop):Init()
	require(script.SpinWheel):Init()
	require(script.UpgradeShop):Init()
	require(script.Stats):Init()
	require(script.Teleport):Init()
	require(script.UpdateLog):Init()
	require(script.StarterPack):Init()
	require(script.PlayerTime):Init()
	require(script.Trade):Init()
	require(script.PerkShop):Init()
end

return Frames