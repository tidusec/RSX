local Lighting = game:GetService("Lighting")
local Effects = {}

function ResetWorldEffects()
	for _,v in game.Lighting:GetChildren() do
		if v.Name == "WorldEffect" then
			v:Destroy()
		end
	end

	Lighting.Brightness = 2.79	
	Lighting.Ambient = Color3.fromRGB(220,220,220)
end

function CreateAtmosphere(Color,Decay,Glare,Haze,Density,Offset)
	local Atmosphere = Instance.new("Atmosphere", Lighting)
	Atmosphere.Name = "WorldEffect"
	Atmosphere.Color = Color
	Atmosphere.Decay = Decay
	Atmosphere.Glare = Glare
	Atmosphere.Haze = Haze
	Atmosphere.Density = Density
	Atmosphere.Offset = Offset
end

Effects.SetDefaultEffects = function()
	ResetWorldEffects()

	CreateAtmosphere(Color3.fromRGB(199,199,199),Color3.fromRGB(176,179,203),0,0,0.3,0.25)
end

Effects.SetForestEffects = function()
	ResetWorldEffects()
	CreateAtmosphere(Color3.fromRGB(20,199,0),Color3.fromRGB(176,179,203),0,0,0.5,0.25)
end

Effects.SetFrostyEffects = function()
	ResetWorldEffects()	
	CreateAtmosphere(Color3.fromRGB(0,255,255),Color3.fromRGB(176,179,203),0,0,0.5,0.25)
end

Effects.SetMineEffects = function()
	ResetWorldEffects()
	CreateAtmosphere(Color3.fromRGB(95,95,95),Color3.fromRGB(176,179,203),0,0,0.4,0.25)
	Lighting.Brightness = 2	
end

Effects.SetAquaEffects = function()
	ResetWorldEffects()
	CreateAtmosphere(Color3.fromRGB(199,199,199),Color3.fromRGB(176,179,203),0.5,0.2,0.5,0.25)
	Lighting.Ambient = Color3.fromRGB(29,119,255)
end

return Effects
