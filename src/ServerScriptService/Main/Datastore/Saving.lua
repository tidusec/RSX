local DS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")

local SavingFunctions = {}

SavingFunctions.SaveData = function(Player)
	local Folder = Player.PlayerData
		
	if Player:FindFirstChild("Loaded") == nil or Player.Loaded.Value == false then
		return
	end

	Player.Loaded.Value = false

	local Save = {}

	--// Codes
	Save["Codes"] = {}
	
	for _, Code in Folder.Codes:GetChildren() do
		Save["Codes"][Code.Name] = true
	end
	
	--// Pets
	Save["Pets"] = {}
	
	for _, Pet in Player.Pets:GetChildren() do
		local NewTable = {}

		NewTable = {
			PetID = Pet.Name,
			Equipped = Pet.Equipped.Value,
			PetName = Pet.PetName.Value,
			Multiplier1 = Pet.Multiplier1.Value,
			Type = Pet.Type.Value,
			Locked = Pet.Locked.Value,
			Enchantment = Pet.Enchantment.Value,
		}

		table.insert(Save["Pets"], NewTable)
	end

	local suc,er = pcall(function()
		DS:GetDataStore("Datastore"):SetAsync(Player.UserId, Save)
	end)

	if er then warn("error with saving data for "..Player.Name.." : "..er) end
end

return SavingFunctions