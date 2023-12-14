--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local SettingsModule = {}

local Modules = RS.Modules
local Settings = require(Modules.Settings)

local SettingsFrame = Player.PlayerGui["Rank Simulator X"]:WaitForChild("HUD").Frames.Settings
local List = SettingsFrame.List
local Utilities = require(Modules.Client.Utilities)

local Remotes = RS.Remotes
local ChangeSetting = Remotes.ChangeSetting


local function SwitchSetting(Frame,Val)
	if Val then
		Frame.Frame.BackgroundColor3 = Color3.fromRGB(65,255,119)
		Frame.Text.Text = "ON"
		Frame.Parent.Selected.Visible = true
	else
		Frame.Frame.BackgroundColor3 = Color3.fromRGB(255,66,66)
		Frame.Text.Text = "OFF"
		Frame.Parent.Selected.Visible = false
	end
end


function SettingsModule:Init()
	Utilities.ButtonAnimations.Create(SettingsFrame.Close)	
	SettingsFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(SettingsFrame,UDim2.new(0,0,0,0))
	end)
	
	SettingsFrame.LeftBar.Title.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(SettingsFrame, UDim2.new(0,0,0,0))
		Utilities.ButtonHandler.OnClick(SettingsFrame.Parent.Titles, UDim2.new(0.4, 0, 0.5, 0))
	end)
	
	for SettingName,SettingInfo in Settings do
		local Frame = List:FindFirstChild(SettingName)

		if Frame then
			if SettingInfo.Type == "Bool" then
				SwitchSetting(Frame.Switch,Player.Data:WaitForChild(SettingName).Value)

				Player.Data[SettingName].Changed:Connect(function()
					SwitchSetting(Frame.Switch,Player.Data[SettingName].Value)
					Utilities.Audio.PlayAudio("Click")
				end)

				Frame.Switch.TextButton.MouseButton1Click:Connect(function()
					ChangeSetting:FireServer(SettingName)
				end)
			end	
		end
	end

end

return SettingsModule