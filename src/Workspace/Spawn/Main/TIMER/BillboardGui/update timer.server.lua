local NextUpdate = 1698512400
local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)

local function Update()
	if os.time() < NextUpdate then
		script.Parent.Enabled = true
		script.Parent.Timer.Text = Utilities.Short.time(NextUpdate-os.time())
	else
		script.Parent.Enabled = false
		script.Enabled = false
	end
end

while wait(1) do
	task.spawn(function()
		Update()
	end)
end