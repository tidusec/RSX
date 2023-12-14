--// Handles everything which is not frames

local HUD = {}

local Player = game.Players.LocalPlayer
local Interface = Player.PlayerGui:WaitForChild("Rank Simulator X")
local MainUI = Interface:WaitForChild("HUD")

local RS = game:GetService("ReplicatedStorage")

local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)

--[[
   Layout:
	Buttons
	Popups
	World Boost
	Combo
	Chat
]]

function HUD:Init()	
	local BottomButtons = require(script.BottomButtons)
	for _,Button in MainUI.Buttons:GetChildren() do
		if Button:IsA("ImageButton") then
			local Frame = MainUI.Frames[Button.Name] -- the frame which the button opens
			BottomButtons.CreateButton(Button, Frame)
		end
	end
	
	MainUI.Buttons.Teleport.Visible = Player.Data.Teleport.Value
	
	Player.Data.Teleport.Changed:Connect(function()
		MainUI.Buttons.Teleport.Visible = Player.Data.Teleport.Value
	end)

	
	--// Popups
	Remotes.CreateNotification.OnClientEvent:Connect(function(NotificationType, Var1, Var2)
		if NotificationType == "SpecialPopup" then
			local Popup = Interface.Popups[Var1]:Clone()
			Popup.Visible = true
			Popup.Parent = MainUI
			Popup.Buttons.Ok.TextButton.MouseButton1Click:Connect(function()
				Popup:Destroy()
			end)
		elseif NotificationType == "Layered" then
			if Var2 == "Error" then
				Utilities.Popup.Layered(Var1, Color3.fromRGB(244, 46, 49), 2, RS.Audio.Error)
			elseif Var2 == "Success" then
				Utilities.Popup.Layered(Var1, Color3.fromRGB(73, 244, 55), 2, RS.Audio.Completed)
			end
		end
	end)
	
	local CurrencyPopups = require(script.CurrencyPopups)
	CurrencyPopups.CreatePopups()
	
	--// World Boosts
	local WorldBoosts = require(script.WorldBoost)
	WorldBoosts.Update()
	
	Player.World.Changed:Connect(function()
		WorldBoosts.Update()
	end)
	
	RS.EventMultipliers.World.Changed:Connect(function()
		WorldBoosts.Update() -- the event changed to a different world
	end)
	
	--// Update the combo bar
	local Combo = require(script.Combo)
	Combo.Update()
	
	Player.Data.Combo.Changed:Connect(function()
		Combo.Update()
	end)
	
	MainUI.Frames.SpinWheel:GetPropertyChangedSignal("Visible"):Connect(function()
		if MainUI.Frames.SpinWheel.Visible then -- if spinwheel pops up then hide combo, else unhide and update
			MainUI.Combo.Visible = false
		else
			Combo.Update()
		end
	end)
	
	--// Chat
	
	RS.Remotes.SendMessage.OnClientEvent:Connect(function(Info)
		--if #string.split(Info["Text"], "Legendary") > 1 then 
		--	if Player.Data.DisableLegendaryChat2 == false then
		--		return
		--	end
		--end
		game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",Info)
	end)
	RS.Remotes.BanChat.OnClientEvent:Connect(function(message)
		game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", message)
	end)
end

return HUD