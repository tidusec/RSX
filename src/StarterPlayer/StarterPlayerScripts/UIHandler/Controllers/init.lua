--// Handles all frames

local Controllers = {}

function Controllers:Init()
	require(script.GUIHandler):Init()
	require(script.Teleport):Init()
	require(script.Starterpack):Init()
	require(script.RankUp):Init()
	require(script.Currency):Init()
	require(script.Nametag):Init()
end

return Controllers