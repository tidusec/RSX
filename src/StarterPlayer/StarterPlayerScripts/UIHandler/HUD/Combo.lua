local WorldBoost = {}
local Player = game.Players.LocalPlayer
local HUD = Player.PlayerGui["Rank Simulator X"].HUD
local WorldBoosts = HUD.WorldBoosts

local RS = game:GetService("ReplicatedStorage")
local Multipliers = require(RS.Modules.Shared.Multipliers)
local Utilities = require(RS.Modules.Client.Utilities)

local ComboFrame = HUD.Combo
local ComboStat = Player.Data.Combo

function WorldBoost.Update()
	if ComboStat.Value <= 1 then
		if ComboFrame.Visible then
			task.spawn(function()
				ComboFrame:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.4,true)
				task.wait(0.3)
				ComboFrame.Visible = false
			end)
		end
	else
		if not ComboFrame.Visible and not HUD.Frames.SpinWheel.Visible then				
			ComboFrame:TweenSize(UDim2.new(0.15,0,0.079,0),Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.4,true)
			task.spawn(function()
				task.wait(0.1)
				ComboFrame.Visible = true
			end)
		end
		
		local MaxCombo = Multipliers.GetMaxCombo(Player)

		ComboFrame.Bar:TweenSize(UDim2.fromScale(math.min((ComboStat.Value-1)/(MaxCombo-1) * 0.82 + 0.19,1.01),0.931),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.1,true)
		ComboFrame.Combo.Text = "Combo: x"..Utilities.Short.en(ComboStat.Value)
	end
end

return WorldBoost
