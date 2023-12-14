local Events = require(script.Parent.Events)

return {
	[1] = {Name = "Forest", StartFunction = function() return Events.ForestEvent() end, Message = "A thunderstorm has covered the Forest area!"},
	[2] = {Name = "Frosty", StartFunction = function() return Events.FrostEvent() end, Message = "A snowstorm is happening in the Frosty area!"},
	[3] = {Name = "Mine", StartFunction = function() return Events.MineEvent() end, Message = "The mine has collapsed!"},
	[4] = {Name = "Aqua", StartFunction = function() return Events.AquaEvent() end, Message = "A flood has covered the Aqua area!"},
	[5] = {Name = "Steampunk", StartFunction = function() return Events.SteampunkEvent() end, Message = "The pipes have burst in the Steampunk area!"},
	[6] = {Name = "Sakura", StartFunction = function() return Events.SakuraEvent() end, Message = "The trees have started blossoming in the Sakura Area!"},
	[7] = {Name = "Candy", StartFunction = function() return Events.CandyEvent() end, Message = "Lollipops are falling from the sky in the Candy Area!!"},
}