--// Services

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local PlayerFunctions = {}
local Player = game.Players.LocalPlayer

local Utilities = require(RS.Modules.Client.Utilities)

function PlayerFunctions.AntiAfk()
	local IdleTime = tick()
	UIS.InputBegan:Connect(function()
		IdleTime = tick()
	end)
	spawn(function()
		while task.wait(10) do
			if tick() - IdleTime >= 18*60 then
				game:GetService('TeleportService'):Teleport(game.PlaceId, Player)
			end
		end
	end)
end

function PlayerFunctions.CreateSettings()
	--// Mute Music
	workspace.Music.Volume = Player.Data.MuteMusic.Value and 0 or 0.5

	Player.Data.MuteMusic.Changed:Connect(function()
		workspace.Music.Volume = Player.Data.MuteMusic.Value and 0 or 0.5
	end)
	
	--// No Reset Character
	
	pcall(function()
		game:GetService("StarterGui"):SetCore("ResetButtonCallback" ,false)
	end)
end

function PlayerFunctions.CreateEvents()
	local Events = require(script.Events)
	local EventWorld = RS.EventMultipliers.World
	Events.CreateEvent(EventWorld.Value)

	EventWorld.Changed:Connect(function()
		Events.CreateEvent(EventWorld.Value)
	end)
end

function PlayerFunctions.CreateChests()
	local Chests = require(script.Chests)
	Chests.Create()

	RS.Remotes.ClaimChest.OnClientEvent:Connect(function(Message)
		Utilities.Popup.Layered(Message, Color3.fromRGB(85, 255, 0), 2, RS.Audio.Completed)	-- reward from chests remote	
	end)
end

return PlayerFunctions
