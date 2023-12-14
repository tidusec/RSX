local Module = {}

Module.Save = function(Datastore)
	local success, Data = pcall(function()
		return Datastore:GetAsync(tostring(game.PlaceId))
	end)

	if not success then
		warn("PetExist Data did not load correctly")
		return
	end
	
	local SaveData = {}

	for _,ExistVal in game.ReplicatedStorage.Pets.Exist.Server:GetChildren() do
		SaveData[ExistVal.Name] = ExistVal.Value
		
		pcall(function()
			if Data[ExistVal.Name] then
				SaveData[ExistVal.Name] = SaveData[ExistVal.Name] + Data[ExistVal.Name]
			end
		end)

		ExistVal.Value = 0
	end
	
	Datastore:SetAsync(tostring(game.PlaceId), SaveData)
end

Module.Load = function(Datastore)
	local success, Data = pcall(function()
		return Datastore:GetAsync(tostring(game.PlaceId))
	end)
	
	if not success then
		warn("PetExist Data did not load correctly")
		return
	end
	
	for _,ExistVal in game.ReplicatedStorage.Pets.Exist.Global:GetChildren() do
		pcall(function()
			if Data[ExistVal.Name] then
				ExistVal.Value = Data[ExistVal.Name]
			end
		end)
	end
end

return Module
