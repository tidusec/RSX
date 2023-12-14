local BottomButtons = {}

local Utilities = require(game.ReplicatedStorage.Modules.Client.Utilities)

BaseSize = {} -- Default size of buttons

function BottomButtons.CreateButton(Button, Frame)
	BaseSize[Button.Name] = Frame.Size
	Utilities.ButtonAnimations.Create(Button, 1.05, 0.075)

	Button.Click.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Frame, BaseSize[Button.Name])
	end)
end

return BottomButtons
