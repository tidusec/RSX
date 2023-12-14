--[[
	Gets device & country of player
]]

local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")

repeat wait() until game.Players.LocalPlayer:FindFirstChild("Loaded") and game.Players.LocalPlayer.Loaded.Value

function getDevice()
	local Variables = {}

	local MouseEnabled = UserInputService.MouseEnabled
	local console = game:GetService("GuiService"):IsTenFootInterface()
	local check1 = false
	local check2 = false
	local check3 = false
	local check4 = false

	if UserInputService.GamepadEnabled then
		check1 = true
	elseif console then
		if not MouseEnabled then
			check1 = true
		elseif UserInputService.VREnabled then
			check4 = true
			check3 = false
		elseif UserInputService.TouchEnabled then
			if not MouseEnabled then
				check2 = true
			elseif not UserInputService.GyroscopeEnabled then
				if UserInputService.AccelerometerEnabled then
					check2 = true
				else
					check3 = true
				end
			else
				check2 = true
			end
		elseif not UserInputService.GyroscopeEnabled then
			if UserInputService.AccelerometerEnabled then
				check2 = true
			else
				check3 = true
			end
		else
			check2 = true
		end
	elseif UserInputService.VREnabled then
		check4 = true
		check3 = false
	elseif UserInputService.TouchEnabled then
		if not MouseEnabled then
			check2 = true
		elseif not UserInputService.GyroscopeEnabled then
			if UserInputService.AccelerometerEnabled then
				check2 = true
			else
				check3 = true
			end
		else
			check2 = true
		end
	elseif not UserInputService.GyroscopeEnabled then
		if UserInputService.AccelerometerEnabled then
			check2 = true
		else
			check3 = true
		end
	else
		check2 = true
	end

	Variables.PC = check3
	Variables.Mobile = check2
	Variables.Console = check1
	Variables.VR = check4

	local ret = {}

	for i, bool in Variables do 
		if bool then
			return i
		end
	end
	
	return ret
end

UserInputService.GamepadConnected:Connect(getDevice)
UserInputService.GamepadDisconnected:Connect(getDevice)

game.Players.LocalPlayer.Device.Value = getDevice()

wait(5)

local result, code = pcall(function()
	return LocalizationService:GetCountryRegionForPlayerAsync(game.Players.LocalPlayer)
end)

if result then
	game.ReplicatedStorage.Remotes.SendCountry:FireServer(code)
else
	warn("Failed to load country!")
end

while wait(10) do
	game.Players.LocalPlayer.Device.Value = getDevice()
end