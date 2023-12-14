--// Effects on client for the events

local RS = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local Events = {}

local Player = game.Players.LocalPlayer
local Areas = workspace.Areas
local EventMultipliers = RS.EventMultipliers

function Events.CreateEvent(World)
	if World == "Forest" then
		Areas.Forest.Rain.ParticleEmitter.Enabled = true
		Areas.Forest.Ignore.ParticleEmitter.Enabled = true
		task.wait(EventMultipliers.Ends.Value-os.time())
		Areas.Forest.Rain.ParticleEmitter.Enabled = false
		Areas.Forest.Ignore.ParticleEmitter.Enabled = false
	elseif World == "Frosty" then
		Areas.Frosty.Extra.Snow.Particles.ParticleEmitter.Enabled = false
		Areas.Frosty.Extra.Snow.Particles.ParticleEmitterEvent.Enabled = true
		task.wait(EventMultipliers.Ends.Value-os.time())
		Areas.Frosty.Extra.Snow.Particles.ParticleEmitter.Enabled = true
		Areas.Frosty.Extra.Snow.Particles.ParticleEmitterEvent.Enabled = false
	elseif World == "Mine" then
		Areas.Mine.Ignore.Smoke.Enabled = true
		task.wait(EventMultipliers.Ends.Value-os.time())
		Areas.Mine.Ignore.Smoke.Enabled = false
	elseif World == "Aqua" then
		if RS.Stuff:FindFirstChild("Water") then
			RS.Stuff.Water.Parent = Areas.Aqua
		end
		task.wait(EventMultipliers.Ends.Value-os.time())
		if Areas.Aqua:FindFirstChild("Water") then
			Areas.Aqua.Water.Parent = RS.Stuff
		end
	elseif World == "Steampunk" then
		for _,Part in Areas.Steampunk.Main.Events:GetChildren() do
			for _, Smoke in Part:GetChildren() do
				Smoke.Enabled = Smoke.Name ~= "NormalSmoke"
			end
		end
		task.wait(EventMultipliers.Ends.Value-os.time())
		for _,Part in Areas.Steampunk.Main.Events:GetChildren() do
			for _, Smoke in Part:GetChildren() do
				Smoke.Enabled = Smoke.Name ~= "EventSmoke"
			end
		end
	elseif World == "Sakura" then
		for _,Part in Areas.Sakura.Events:GetChildren() do
			Part.ParticleEmitter.Enabled = true
		end
		task.wait(EventMultipliers.Ends.Value-os.time())
		for _,Part in Areas.Sakura.Events:GetChildren() do
			Part.ParticleEmitter.Enabled = false
		end
	elseif World == "Candy" then
		for _, ParticleEmitter in Areas.Candy.Events:GetDescendants() do
			if not ParticleEmitter:IsA("ParticleEmitter") then continue end
			ParticleEmitter.Enabled = true
		end
		task.wait(EventMultipliers.Ends.Value-os.time())
		for _, ParticleEmitter in Areas.Candy.Events:GetDescendants() do
			if not ParticleEmitter:IsA("ParticleEmitter") then continue end
			ParticleEmitter.Enabled = false
		end
	end
end

return Events
