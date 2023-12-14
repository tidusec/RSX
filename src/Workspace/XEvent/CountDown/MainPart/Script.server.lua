local text_label = script.Parent:WaitForChild("BillboardGui"):WaitForChild("TextLabel")
local NextUpdate = 1702749600
local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)

local function Update()
	if os.time() < NextUpdate then
		text_label.Text = Utilities.Short.time(NextUpdate-os.time())
	else
		script.Enabled = false
	end
end

wait(4)

script.Parent:WaitForChild("ParticleEmitter").Rate = 35

while wait(0.5) do
	Update()
end