local Trademodule = {}
--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer


local Remotes = RS.Remotes
local RequestTrade = Remotes.Trade.RequestTrade
local TradeFrame = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.Trade

local Utilities = require(RS.Modules.Client.Utilities)
local PlayerTrades = require(script.PlayerTrades):Init()
local TradeRequests = require(script.TradeRequets):Init()

local Content = TradeFrame.WhiteBorder.Holder.ScrollingFrame
local Template = script.TradingTemplate

local function HasRequirements()
	if Player.Data["Eggs Opened"].Value >= 100 and Player.Data.Rank.Value >= 10 then return true end
end

local function CreateSlot(SelectedPlayer)
	pcall(function()
		-- check if rank is above 
		if SelectedPlayer.Data.Rank.Value >= 10 and SelectedPlayer.Data["Eggs Opened"].Value >= 100 and not Content:FindFirstChild(SelectedPlayer.Name) then
			local NewTemplate = Template:Clone()
			NewTemplate.Parent = Content
			NewTemplate.DisplayName.Text = SelectedPlayer.DisplayName
			NewTemplate.Username.Text = "@"..SelectedPlayer.Name
			NewTemplate.Name = SelectedPlayer.Name
			Content.CanvasSize = UDim2.new(0, 0, 0, Content.AbsoluteCanvasSize.Y + 55)

			NewTemplate.Click.MouseButton1Click:Connect(function()
				if not SelectedPlayer.Data.DisableTrade.Value and HasRequirements() then
					Utilities.Popup.Layered("Successfully sent a trade!", Color3.fromRGB(0, 244, 0), 1.5, RS.Audio.Completed)
					RequestTrade:InvokeServer(SelectedPlayer.Name)
				end
			end)

			if SelectedPlayer.Data.DisableTrade.Value then
				NewTemplate.Disabled.Visible = true
				NewTemplate.LayoutOrder = 2
				NewTemplate.BackgroundColor3 = Color3.fromRGB(196, 205, 213)
			end

			SelectedPlayer.Data.DisableTrade.Changed:Connect(function()
				if SelectedPlayer.Data.DisableTrade.Value then
					NewTemplate.Disabled.Visible = true
					NewTemplate.LayoutOrder = 2
					NewTemplate.BackgroundColor3 = Color3.fromRGB(196, 205, 213)
				else
					NewTemplate.Disabled.Visible = false
					NewTemplate.LayoutOrder = 1
					NewTemplate.BackgroundColor3 = Color3.fromRGB(235, 245, 255)
				end
			end)
		end
	end)
end


local function TradeLock()
	if HasRequirements() then
		TradeFrame.WhiteBorder.TradeLocked.Visible = false
	end
end

function Trademodule:Init()
	TradeFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(TradeFrame,UDim2.new(0,0,0,0))
	end)

	TradeFrame.WhiteBorder.TradeLocked.Visible = true
	TradeLock()

	local Connection
	Connection = Player.Data["Eggs Opened"].Changed:Connect(function()
		TradeLock()

		if not TradeFrame.WhiteBorder.TradeLocked.Visible then
			Connection:Disconnect()
		end
	end)

	local RankConnection
	RankConnection = Player.Data["Rank"].Changed:Connect(function()
		TradeLock()

		if not TradeFrame.WhiteBorder.TradeLocked.Visible then
			Connection:Disconnect()
		end
	end)


	for _,SelectedPlayer in game.Players:GetChildren() do
		if SelectedPlayer.Name ~= Player.Name then
			CreateSlot(SelectedPlayer)
		end
	end

	game.Players.PlayerAdded:Connect(function(NewPlayer)
		if NewPlayer.Name ~= Player.Name then
			CreateSlot(NewPlayer)
		end
	end)

	game.Players.PlayerRemoving:Connect(function(OldPlayer)
		if Content:FindFirstChild(OldPlayer.Name) then
			Content[OldPlayer.Name]:Destroy()
		end
	end)
	
	spawn(function()
		while task.wait(10) do
			for _,SelectedPlayer in game.Players:GetChildren() do
				if SelectedPlayer.Name ~= Player.Name then
					CreateSlot(SelectedPlayer)
				end
			end
		end
	end)
end

return Trademodule
