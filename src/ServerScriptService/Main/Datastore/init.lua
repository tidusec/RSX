local LoadingFunctions = require(script.Loading)
local SavingFunctions = require(script.Saving)
local Leaderstats = require(script.Leaderstats)

local Datastore = {
	LoadData = function(Player)
		LoadingFunctions.LoadData(Player)
		task.wait(0.5)
		LoadingFunctions.LoadAll(Player)
		task.wait(0.5)
		LoadingFunctions.LoadIndex(Player)
		task.wait(0.5)
		LoadingFunctions.LoadDelete(Player)
		
		return true
	end,
	
	StartLeaderstats = function(Player)
		Leaderstats.Setup(Player)
	end,
	
	SaveData = function(Player)
		SavingFunctions.SaveData(Player)
	end,
}

return Datastore
