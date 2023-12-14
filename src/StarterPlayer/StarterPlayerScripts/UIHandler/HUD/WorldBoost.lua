local WorldBoost = {}
local Player = game.Players.LocalPlayer
local HUD = Player.PlayerGui["Rank Simulator X"].HUD
local WorldBoosts = HUD.WorldBoosts

local RS = game:GetService("ReplicatedStorage")
local Worlds = require(RS.Modules.Worlds)

function WorldBoost.Update()
	if RS.EventMultipliers.World.Value == Player.World.Value then -- if there is an event
		WorldBoosts.StarBoost.Text = "Star Boost x"..Worlds[Player.World.Value].WorldBoost * RS.EventMultipliers.StarBoost.Value

		if RS.EventMultipliers.LuckBoost.Value > 1 then -- if the event is luck
			WorldBoosts.LuckBoost.Text = "Luck Boost x"..RS.EventMultipliers.LuckBoost.Value
			WorldBoosts.LuckBoost.Visible = true
		else
			WorldBoosts.LuckBoost.Visible = false
		end
	else
		WorldBoosts.LuckBoost.Visible = false
		WorldBoosts.StarBoost.Text = "Star Boost x"..Worlds[Player.World.Value].WorldBoost
	end
end

return WorldBoost
