local LS = {}
local Content = require(game.ReplicatedStorage.Modules.Shared.ContentManager)

LS.Setup = function(Player)
	local Folder = Instance.new("Folder",Player)
	Folder.Name = "leaderstats"
	
	--// Date Joined
	
	local Months = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}

	if Player.Data["Date Joined"].Value == "" then
		Player.Data["Date Joined"].Value = os.date("*t").day .. " " .. Months[os.date("*t").month] .. " " .. os.date("*t").year
	end

	local lsStat = Instance.new("StringValue",Folder)
	lsStat.Name = "Rank"
	lsStat.Value = Content.Ranks[Player.Data.Rank.Value].RankName

	Player.Data.Rank.Changed:Connect(function()
		lsStat.Value = Content.Ranks[Player.Data.Rank.Value].RankName
	end)
	
	local lsStat2 = Instance.new("IntValue", Folder)
	lsStat2.Name = "Eggs"
	lsStat2.Value = Player.Data["Eggs Opened"].Value
	
	Player.Data["Eggs Opened"].Changed:Connect(function()
		lsStat2.Value = Player.Data["Eggs Opened"].Value
	end)
end

return LS
