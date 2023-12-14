local CurrencyModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Variables

local Player = Players.LocalPlayer


local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)

local Data = Player.Data

repeat wait() until #Data:GetChildren() > 10

--// TopDisplays

local Displays = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Left

--// Ranks

local Colors = {[0] = Color3.fromRGB(240, 55, 55),[0.2] = Color3.fromRGB(255, 170, 0),[0.4] = Color3.fromRGB(255, 255, 0),[0.6] = Color3.fromRGB(85, 255, 127),[0.8] = Color3.fromRGB(101, 155, 255),[1] = Color3.fromRGB(195, 90, 255)}

local function DisplayRank()
	if Content.Ranks[Player.Data.Rank.Value+1] then
		Displays.RankDisplay.RankName.Text = Content.Ranks[Player.Data.Rank.Value+1].RankName
		Displays.RankDisplay.RankName.TextColor3 = Content.Ranks[Player.Data.Rank.Value+1].RankColor
		Displays.RankDisplay.Percent.Text = Utilities.Short.en(math.min(Data.Stars.Value * 100/Content.Ranks[Player.Data.Rank.Value+1].Cost,100)).."%"
		Displays.RankDisplay.Progress.Bar.Size = UDim2.new(math.min(Data.Stars.Value/Content.Ranks[Player.Data.Rank.Value+1].Cost,1),0,1,0)	

		local SelectedColor,Current = Color3.fromRGB(0,0,0), 0	

		for Requirement,Color in Colors do
			if math.min(Data.Stars.Value/Content.Ranks[Player.Data.Rank.Value+1].Cost,1.01) >= Requirement and Requirement >= Current then
				SelectedColor = Color
				Current = Requirement
			end
		end

		Displays.RankDisplay.Percent.TextColor3 = SelectedColor

	else
		Displays.RankDisplay.RankName.Text = Content.Ranks[Player.Data.Rank.Value].RankName
		Displays.RankDisplay.RankName.TextColor3 = Content.Ranks[Player.Data.Rank.Value].RankColor
		Displays.RankDisplay.Percent.Text = "100%"
		Displays.RankDisplay.Progress.Bar.Size = UDim2.new(1,0,1,0)	
	end
end

local function UpdateText()
	local Ready = 0
	local Gifts = {}

	-- Adds every timer up into a table, or counts amount that can be claimed
	for i = 1,12 do
		if not Player.Gifts:FindFirstChild(i) then
			if Content.PlaytimeRewards[i].Milestone-Player.IngameTime.Value > 0 then
				Gifts[#Gifts+1] = Content.PlaytimeRewards[i].Milestone-Player.IngameTime.Value
			else
				Ready += 1
			end
		end
	end

	if Ready ~= 0 then
		Displays.FreeGift.Timer.Text = "Ready!"
		Displays.FreeGift.Amount.Text = "x"..Ready
	else
		table.sort(Gifts,function(a,b)
			return a < b
		end)

		if #Gifts ~= 0 then
			Displays.FreeGift.Timer.Text = Utilities.Short.time(Gifts[1])
			Displays.FreeGift.Amount.Text = ""		
		else
			Displays.FreeGift.Timer.Text = "Finished"
			Displays.FreeGift.Amount.Text = ""		

			return true
		end
	end	
end


function CurrencyModule:Init()

	DisplayRank()

	--// Gems

	repeat wait() until Data:FindFirstChild("Gems")

	Displays.GemDisplay.TextLabel.Text = Utilities.Short.en(Data.Gems.Value)

	Data.Gems.Changed:Connect(function()
		Displays.GemDisplay.TextLabel.Text = Utilities.Short.en(Data.Gems.Value)
	end)

	--// Stars

	Displays.StarDisplay.TextLabel.Text = Utilities.Short.en(Data.Stars.Value)

	Data.Stars.Changed:Connect(function()
		Displays.StarDisplay.TextLabel.Text = Utilities.Short.en(Data.Stars.Value)
		DisplayRank()
	end)
	
	Displays.CandyCornDisplay.TextLabel.Text = Utilities.Short.en(Data.CandyCorn.Value)
	
	Data.CandyCorn.Changed:Connect(function()
		Displays.CandyCornDisplay.TextLabel.Text = Utilities.Short.en(Data.CandyCorn.Value)
	end)

	--// Gift

	Displays.FreeGift.TextButton.MouseButton1Click:Connect(function()
		Utilities.ButtonHandler.OnClick(Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.PlaytimeRewards, UDim2.new(0.345,0,0.715,0))
	end)

	local GiftsFolder = Player.Gifts
	
	task.spawn(function()
		while wait(1) do
			local Break = UpdateText()

			if Break then break end
		end
	end)
end

return CurrencyModule
