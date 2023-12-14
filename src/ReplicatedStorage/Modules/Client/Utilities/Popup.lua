local RS = game:GetService("ReplicatedStorage")
local Popups = {}

local Player = game.Players.LocalPlayer

Popups.Layered = function(Text, Color, Duration, Audio : SoundInstance)
	task.spawn(function()
		local Notif = script.NotificationTemplate1:Clone()
		Notif.Parent = Player.PlayerGui["Rank Simulator X"].HUD.Notifications;

		Notif.Label.Text = Text
		Notif.Label.TextColor3 = Color or Color3.fromRGB(255, 255, 255)

		if Audio then
			local suc,er = spawn(function()
				if not Player.Data.MuteSounds.Value then
					local Clone = Audio:Clone()
					Clone.Parent = workspace

					Clone:Play()
					Clone.ended:Wait()
					Clone:Destroy()
				end
			end)
			if er then warn(er) end
		end

		task.wait(Duration or 0.5)
		Notif:Destroy()
	end)
end

Popups.Random = function(Text, Color, Duration, Audio : Sound, Image : ImageID)
	local suc,er = task.spawn(function()
		if Player.Data.HidePopups.Value then return end

		local Notif = script.NotificationTemplate2:Clone()
		Notif.Parent = Player.PlayerGui["Rank Simulator X"].HUD;

		Notif.Label.Text = Text
		Notif.Label.TextColor3 = Color or Color3.fromRGB(255, 255, 255)
		Notif.Image.Image = Image 

		Notif.Size = UDim2.new(0,0,0,0)

		Notif:TweenSize(UDim2.new(0.161,0,0.061,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,Duration*0.2,true)
		Notif.Rotation = math.random(1,30)-15
		Notif.Position = UDim2.new((math.random(30,70)/100),0,(math.random(40,70)/100),0)

		if Audio then
			local suc,er = spawn(function()
				if not Player.Data.MuteSounds.Value then
					local Clone = Audio:Clone()
					Clone.Parent = workspace
					Clone:Play()
					Clone.ended:Wait()
					Clone:Destroy()
				end
			end)

			if er then warn(er) end
		end

		wait(Duration*0.6)

		Notif:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,Duration*0.2,true)
		task.wait(Duration*0.2 or 0.5)
		Notif:Destroy()
	end)

	if er then print(er) end
end

return Popups