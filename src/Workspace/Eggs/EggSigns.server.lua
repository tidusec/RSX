local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)
local Content = require(game.ReplicatedStorage.Modules.Shared.ContentManager)

for _,Egg in script.Parent:GetChildren() do
	if Egg:IsA("Model") then
		Egg.Eggname.SurfaceGui:FindFirstChild("Name").Text = Egg.Name
		
		if Egg:FindFirstChild("EggPrice") and Content.Eggs[Egg.Name] then
			Egg.EggPrice.SurfaceGui.TextLabel.Text = Utilities.Short.en(Content.Eggs[Egg.Name].Cost)
		end
	end
end