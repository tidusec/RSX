local TradeRequestodule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer


local Remotes = RS.Remotes
local RequestTrade = Remotes.Trade.RequestTrade
local StartTrade = Remotes.Trade.StartTrade

local Frames = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames
local PlayerTrade = Frames.PlayerTrade

local Utilities = require(RS.Modules.Client.Utilities)

local db = false

function OnTradeReceived(OtherPlayer)
	if Player.Data.Rank.Value >= 10 and Player.Data["Eggs Opened"].Value >= 100 and not Player.Data.DisableTrade.Value then
		local MainFrame = script.TradeRequest:Clone()
		MainFrame.Parent = Frames.Parent
		MainFrame.Visible = true	

		local Holder = MainFrame.WhiteBorder.Holder
		Holder.TextLabel.Text = OtherPlayer.." Sent a Trade Offer!"
		Holder.Accept.Button.MouseButton1Click:Connect(function()
			if db == false then 
				db = true
				local Message = StartTrade:InvokeServer(OtherPlayer)
				if Message and Message == "StartTrade" then
					Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0.425,0,0.525,0))
					PlayerTrade.Trading.Value = OtherPlayer
				else
					print("Something went wrong with starting a trade for "..Player.Name)
				end
				MainFrame:Destroy()
				wait(0.05)
				db = false
			end
		end)

		Holder.Decline.Button.MouseButton1Click:Connect(function()
			MainFrame:Destroy()
		end)

		wait(7.5)

		if MainFrame.Visible == true then
			MainFrame:Destroy()
		end
	end
end

function OnStartTrade(OtherPlayer)
	task.spawn(function()
		Utilities.ButtonHandler.OnClick(PlayerTrade,UDim2.new(0.425,0,0.525,0))
	end)
	PlayerTrade.Trading.Value = OtherPlayer
end

function TradeRequestodule:Init()
	RequestTrade.OnClientInvoke = OnTradeReceived
	StartTrade.OnClientInvoke = OnStartTrade

	for k, frame in Frames:GetChildren() do
		frame:GetPropertyChangedSignal("Visible"):Connect(function()
			task.wait(.1)
			for _, child in frame:GetDescendants() do
				if child:IsA("ScrollingFrame") then
					local controller = child:FindFirstChildWhichIsA("UIGridLayout") or child:FindFirstChildWhichIsA("UIListLayout")
					if controller then
						child.Visible = false
						child.Visible = true
						child.CanvasPosition = Vector2.zero
					end
				end
			end
		end)
	end
end
return TradeRequestodule
