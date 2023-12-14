local Title = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local TitleFrame =  Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("Titles")
local Scroll = TitleFrame.WhiteBorder.Holder.ScrollingFrame

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)
local SyncedTime = require(Modules.SyncedTime)

local Remotes = RS.Remotes

local TitleDataModule = Content.Title
local GroupID = 12554523

local currentlyEquipped = Player.Data.Nametag.Value

local titleData = {
	["Time"] = {
		"Fan","LoyalFan","DevotedFan", "AmazingFan", "DedicatedFan"
	};
	["StarsCollected"] = {
		"StarRookie", "StarBeginner", "StarIntermediate", "StarAdvanced", "StarExpert"
	};
	["Eggs Opened"] = {
		"RookieHatcher", "PetLover", "PetEnthusiast", "PetFanatic"
	};
	["Secrets Hatched"] = {
		"OneInAMillion"
	};
	["HalloweenClaim"] = {
		"HalloweenLover"
	}
}

local function loadUI()
	task.spawn(function()
		for TitleName, TitleInfo in TitleDataModule do
			if Scroll:FindFirstChild(TitleName) then
				if TitleInfo["GroupReward"] == nil and TitleInfo["DataType"] == "Number" then
					if Player.Data[TitleInfo["Stat"]].Value < TitleInfo["Requiement"] then
						Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0.5

						Scroll:FindFirstChild(TitleName).Equip.Visible = false
						Scroll:FindFirstChild(TitleName).Locked.Visible = true
					end
				elseif TitleInfo["GroupReward"] then
					if Player:GetRankInGroup(GroupID) < TitleInfo["GroupRankID"] then
						Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0.5

						Scroll:FindFirstChild(TitleName).Equip.Visible = false
						Scroll:FindFirstChild(TitleName).Locked.Visible = true
					end

				elseif TitleInfo["DataType"] == "Boolean" then
					if Player.Data[TitleInfo["Stat"]].Value ~= TitleInfo["Requiement"] then
						Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0.5
						Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0.5

						Scroll:FindFirstChild(TitleName).Equip.Visible = false
						Scroll:FindFirstChild(TitleName).Locked.Visible = true
					end
				end


				if Scroll:FindFirstChild(currentlyEquipped) then
					Scroll:FindFirstChild(currentlyEquipped).Unequip.Visible = true
					Scroll:FindFirstChild(currentlyEquipped).Equip.Visible = false
					Scroll:FindFirstChild(currentlyEquipped).UIStroke.Enabled = true
				end

				Scroll:FindFirstChild(TitleName).Equip.MouseButton1Click:Connect(function()
					Scroll:FindFirstChild(TitleName).Unequip.Visible = true
					Scroll:FindFirstChild(TitleName).Equip.Visible = false
					Scroll:FindFirstChild(TitleName).UIStroke.Enabled = true

					if currentlyEquipped ~= "None" then
						Scroll:FindFirstChild(currentlyEquipped).Unequip.Visible = false
						Scroll:FindFirstChild(currentlyEquipped).Equip.Visible = true
						Scroll:FindFirstChild(currentlyEquipped).UIStroke.Enabled = false
					end


					currentlyEquipped = TitleName
					Remotes.EquipNametag:FireServer(TitleName)
				end)

				Scroll:FindFirstChild(TitleName).Unequip.MouseButton1Click:Connect(function()
					Scroll:FindFirstChild(TitleName).Unequip.Visible = false
					Scroll:FindFirstChild(TitleName).Equip.Visible = true
					Scroll:FindFirstChild(TitleName).UIStroke.Enabled = false

					currentlyEquipped = "None"
					Remotes.UnequipNametag:FireServer()
				end)
			end
		end
	end)
end

local function update(Stat)
	task.spawn(function()
		for i, TitleName in titleData[Stat] do
			if Scroll:FindFirstChild(TitleName) then
				if TitleDataModule[TitleName]["DataType"] then
					if TitleDataModule[TitleName]["DataType"] == "Number" then
						if Player.Data[TitleDataModule[TitleName]["Stat"]].Value >= TitleDataModule[TitleName]["Requiement"] then
							Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0
							Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0
							Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0
							Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0

							Scroll:FindFirstChild(TitleName).Equip.Visible = true
							Scroll:FindFirstChild(TitleName).Locked.Visible = false
						end
					else
						if Player.Data[TitleDataModule[TitleName]["Stat"]].Value == TitleDataModule[TitleName]["Requiement"] then
							Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0
							Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0
							Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0
							Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0

							Scroll:FindFirstChild(TitleName).Equip.Visible = true
							Scroll:FindFirstChild(TitleName).Locked.Visible = false
						end
					end
				end
			elseif TitleDataModule[TitleName]["GroupReward"] then
				if Player:GetRankInGroup(GroupID) < TitleDataModule[TitleName]["GroupRankID"] then
					Scroll:FindFirstChild(TitleName).BackgroundTransparency = 0
					Scroll:FindFirstChild(TitleName).Holder.BackgroundTransparency = 0
					Scroll:FindFirstChild(TitleName).Description.TextTransparency = 0
					Scroll:FindFirstChild(TitleName).Title.TextTransparency = 0

					Scroll:FindFirstChild(TitleName).Equip.Visible = true
					Scroll:FindFirstChild(TitleName).Locked.Visible = false
				end
			end
		end
	end)
end

Remotes.GetEquippedNametag.OnClientInvoke = function() 
	return currentlyEquipped
end

function Title:Init()
	Utilities.ButtonAnimations.Create(TitleFrame.Close)
	TitleFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(TitleFrame, UDim2.new(0,0,0,0))
	end)

	TitleFrame.LeftBar.Setting.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(TitleFrame, UDim2.new(0,0,0,0))
		Utilities.ButtonHandler.OnClick(TitleFrame.Parent.Settings, UDim2.new(0.4, 0, 0.6, 0))
	end)

	loadUI()

	Scroll.CanvasSize = UDim2.new(0, 0, 0, Scroll.AbsoluteCanvasSize.Y + 30)

	Player.Data["Secrets Hatched"].Changed:Connect(function()
		update("Secrets Hatched")
	end)
	Player.Data["Time"].Changed:Connect(function()
		update("Time")
	end)
	Player.Data["Eggs Opened"].Changed:Connect(function()
		update("Eggs Opened")
	end)
	Player.Data["StarsCollected"].Changed:Connect(function()
		update("StarsCollected")
	end)
	Player.Data["HalloweenClaim"].Changed:Connect(function()
		update("HalloweenClaim")
	end)
end

return Title

