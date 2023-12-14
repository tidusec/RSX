--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Modules = RS.Modules
local SyncedTime = require(Modules.SyncedTime)
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)

SyncedTime.init() -- Will make the request to google.com if it hasn't already.

local currentHour
local currentShopItems = {}

function getAvailableItems(seed, numberofitems) 
	local rng = Random.new(seed)
	
	local GeneratedPerks = {}

	local function Generate()
		local SelectedPerk = rng:NextInteger(1,#Content.Perks)
		local Duplicate = false
		
		if Content.Perks[SelectedPerk].HideFromShop then -- if this exists then u hide it from shop
			Duplicate = true
		end
		
		for _,v in GeneratedPerks do
			if v == SelectedPerk then
				Duplicate = true				
			end
		end
		
		if not Duplicate then
			table.insert(GeneratedPerks, SelectedPerk)
		end
	end

	repeat
		Generate()
	until #GeneratedPerks >= numberofitems

	return GeneratedPerks
end

while true do
	local hour = math.floor((SyncedTime.time()) / 3600) -- 3600
	local t = (math.floor(SyncedTime.time()))
	local timeleft = 3600 - (t % 3600) -- 3600 - (t % 3600)
	local timeleftstring = Utilities.Short.time(timeleft)

	if hour ~= currentHour then
		currentHour = hour
		currentPerks = getAvailableItems(hour, 3)
		
		for i,v in RS.Perks:GetChildren() do
			v.Value = currentPerks[i]
		end
	end
	wait(1)
end