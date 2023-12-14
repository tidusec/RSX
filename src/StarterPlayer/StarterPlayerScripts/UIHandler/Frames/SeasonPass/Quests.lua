local Quests = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local Utilities = require(RS.Modules.Client.Utilities)
local Constants = require(RS.Modules.Constants)
--// Variables

local Player = game.Players.LocalPlayer
local MAXIMUM_QUEST_PER_DAY = Constants.MAXIMUM_QUEST_PER_DAY

local DailyQuestCoolDown = Player.Data["DailyQuestCoolDown"]
local SeasonQuests = require(RS.Modules.SeasonPass)

local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD
local Seasonpass = HUD.Frames:WaitForChild("SeasonpassQuests")

local RefreshTimerText = Seasonpass.RefreshTimer

local Remotes = RS.Remotes

local Utilities = require(RS.Modules.Client.Utilities)

function Quests:Init()
	Utilities.ButtonAnimations.Create(Seasonpass.Close)	
	Seasonpass.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(Seasonpass, UDim2.new(0,0,0,0))
	end)

	Seasonpass.LeftBar.PremiumButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.PremiumPassBuy, UDim2.new(0.45,0,0.587,0))
	end)

	Seasonpass.LeftBar.QuestButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
	end)

	Seasonpass.LeftBar.RewardsButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(HUD.Frames.SeasonPass, UDim2.new(0.45,0,0.7,0))
	end)
end

local function Update(x,i)
	if Player.Data["SeasonQuest"..i].Value >= SeasonQuests[i].Required then
		x.Claim.Visible = true

		if Player.Data["SeasonQuest"..i.."Claimed"].Value == false then
			x.Claim.Text = "Click to Claim!"
		else
			x.Claim.Text = "Claimed!"

		end
	else
		x.Claim.Visible = false
	end
end

local function getSeasonQuests()
	local questsPicked = {}
	local questPickedID = {}

	--> delete all quests
	for i, v in pairs(Seasonpass.Quests:GetChildren()) do
		if v:IsA("ImageLabel") then v:Destroy() end
	end

	local ran = 0
	repeat
		local amountQuests = #SeasonQuests
		local currentQuestPicked = SeasonQuests[math.random(1, amountQuests)]--> get a random quest\

		--> if quest has not already been picked select to go to the frame and its not claimed
		if not table.find(questsPicked, currentQuestPicked.Text) and Player.Data["SeasonQuest"..currentQuestPicked.Id.."Claimed"].Value == false  then 

			table.insert(questsPicked, currentQuestPicked.Text) --> add value to the table
			table.insert(questPickedID, currentQuestPicked.Id)

			local NewQuest = script.Quest:Clone()
			NewQuest.QuestName.Text = SeasonQuests[currentQuestPicked.Id].Text
			NewQuest.Parent = Seasonpass.Quests
			NewQuest.TextButton.MouseButton1Click:Connect(function()
				if Player.Data["SeasonQuest"..currentQuestPicked.Id].Value >= SeasonQuests[currentQuestPicked.Id].Required then
					RS.Remotes.ClaimSeasonQuest:FireServer(currentQuestPicked.Id)
				end
			end)

			Update(NewQuest,currentQuestPicked.Id)

			NewQuest.Progress.Text = Utilities.Short.en(Player.Data["SeasonQuest"..currentQuestPicked.Id].Value).."/"..Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Required)
			NewQuest.Reward.Text = Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Reward).."XP"

			Player.Data["SeasonQuest"..currentQuestPicked.Id].Changed:Connect(function()
				NewQuest.Progress.Text = Utilities.Short.en(Player.Data["SeasonQuest"..currentQuestPicked.Id].Value).."/"..Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Required)
				Update(NewQuest,currentQuestPicked.Id)
			end)

			Player.Data["SeasonQuest"..currentQuestPicked.Id.."Claimed"].Changed:Connect(function()
				Update(NewQuest, currentQuestPicked.Id)
			end)

			ran = ran + 1
		end

	until ran == MAXIMUM_QUEST_PER_DAY

	Remotes.SeasonPassQuestsChosen:FireServer(questPickedID)
end

local function getCurrentSeasonQuests()
	--> delete all quests
	for i, v in pairs(Seasonpass.Quests:GetChildren()) do
		if v:IsA("ImageLabel") then v:Destroy() end
	end

	for i = 1, MAXIMUM_QUEST_PER_DAY do
		local currentQuestPicked = SeasonQuests[Player.Data["CurrentShowingQuest".. i].Value]

		local NewQuest = script.Quest:Clone()
		NewQuest.QuestName.Text = currentQuestPicked.Text
		NewQuest.Parent = Seasonpass.Quests
		NewQuest.TextButton.MouseButton1Click:Connect(function()
			if Player.Data["SeasonQuest"..currentQuestPicked.Id].Value >= SeasonQuests[currentQuestPicked.Id].Required then
				RS.Remotes.ClaimSeasonQuest:FireServer(currentQuestPicked.Id)
			end
		end)

		Update(NewQuest,currentQuestPicked.Id)

		NewQuest.Progress.Text = Utilities.Short.en(Player.Data["SeasonQuest"..currentQuestPicked.Id].Value).."/"..Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Required)
		NewQuest.Reward.Text = Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Reward).."XP"

		Player.Data["SeasonQuest"..currentQuestPicked.Id].Changed:Connect(function()
			NewQuest.Progress.Text = Utilities.Short.en(Player.Data["SeasonQuest"..currentQuestPicked.Id].Value).."/"..Utilities.Short.en(SeasonQuests[currentQuestPicked.Id].Required)
			Update(NewQuest,currentQuestPicked.Id)
		end)

		Player.Data["SeasonQuest"..currentQuestPicked.Id.."Claimed"].Changed:Connect(function()
			Update(NewQuest, currentQuestPicked.Id)
		end)
	end
end


getCurrentSeasonQuests()

--> daily quests timer
spawn(function()
	while true do --> never stops running
		while task.wait(1) do			
			if DailyQuestCoolDown.Value > os.time() then
				RefreshTimerText.Text = "Resets in: "..Utilities.Short.time(DailyQuestCoolDown.Value-os.time())
			else
				getSeasonQuests()
			end
		end
	end
end)


return Quests
