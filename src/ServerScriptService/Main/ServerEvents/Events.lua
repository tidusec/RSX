local Events = {}
local EventsMultiplier = game.ReplicatedStorage.EventMultipliers

local function SetDefault()
	EventsMultiplier.StarBoost.Value = 1
	EventsMultiplier.LuckBoost.Value = 1
end

local function SetBoosts()
	local Chance = math.random()

	if Chance < 0.5 then
		EventsMultiplier.StarBoost.Value *= 2
		return "StarBoost"
	elseif Chance <= 1 then
		EventsMultiplier.LuckBoost.Value *= 1.5
		return "LuckBoost"
	end
end

local function SetDefaultEvent(WorldName)
	SetDefault()
	local SelectedBoost = SetBoosts()
	EventsMultiplier.World.Value = WorldName
	
	return SelectedBoost
end

Events.ForestEvent = function()
	return SetDefaultEvent("Forest")
end

Events.FrostEvent = function()
	return SetDefaultEvent("Frosty")
end

Events.MineEvent = function()
	return SetDefaultEvent("Mine")
end

Events.AquaEvent = function()
	return SetDefaultEvent("Aqua")
end

Events.SteampunkEvent = function()
	return SetDefaultEvent("Steampunk")
end

Events.SakuraEvent = function()
	return SetDefaultEvent("Sakura")
end

Events.CandyEvent = function()
	return SetDefaultEvent("Candy")
end

return Events
