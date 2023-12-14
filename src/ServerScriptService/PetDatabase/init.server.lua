--// Services

local DSS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")

--// Variables

local DS = DSS:GetDataStore("TotalExist") 
local Data = nil
local Pets = RS:WaitForChild("Pets")

local Folder = Pets.Exist

local MainModule = require(script.PetDataModule)

local Types = 6

local function CreateValues()
	Data = DS:GetAsync(tostring(game.PlaceId))
	for i = 0, Types do
		for _,PetModel in Pets.Models:GetChildren() do
			local NewInstance = Instance.new("NumberValue",Folder.Server)
			NewInstance.Name = i.." "..PetModel.Name
			NewInstance.Value = 0		

			local NewInstance = Instance.new("NumberValue",Folder.Global)
			NewInstance.Name = i.." "..PetModel.Name
			NewInstance.Value = 0	

			local suc,er = pcall(function()
				if Data ~= nil and Data[i.." "..PetModel.Name] then
					NewInstance.Value = Data[i.." "..PetModel.Name]
				end
			end)
			
			if er then warn(er) end
		end
	end
end

task.wait(2)

CreateValues()

game:BindToClose(function()
	MainModule.Save(DS)
end)

while task.wait(20) do
	MainModule.Save(DS)
	task.wait(20)
	MainModule.Load(DS)
end