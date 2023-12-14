local Events = require(script.Events)
local Worlds = require(script.Worlds)
local ServerEvents = {}

local function ChooseWorld()
	local SelectedEvent = Worlds[math.random(1,#Worlds)]
	
	if SelectedEvent.Name == game.ReplicatedStorage.EventMultipliers.World.Value then
		return ChooseWorld()
	end
	
	return SelectedEvent
end

ServerEvents.StartEvents = function()
	while true do
		wait(math.random(60,120))
		
		local SelectedEvent = ChooseWorld()
		local BoostMessages = require(game.ReplicatedStorage.Modules.Events)
		
		local WaitDuration = math.random(300,600) -- div 10 for now
		game.ReplicatedStorage.EventMultipliers.Ends.Value = os.time() + (WaitDuration/2)
		
		local Message = SelectedEvent.StartFunction()
		
		local Info = {Text = SelectedEvent.Message.." "..BoostMessages[Message], Color = Color3.fromRGB(191, 249, 0),Font = Enum.Font.SourceSansBold, FontSize = Enum.FontSize.Size18}
		game.ReplicatedStorage.Remotes.SendMessage:FireAllClients(Info)
		game.ReplicatedStorage.Remotes.StartEvent:FireAllClients({SelectedEvent.Name,Message})
				
		wait(WaitDuration)
	end
end

return ServerEvents
