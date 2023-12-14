local PerkShop = {}

--// Services

local RS = game:GetService("ReplicatedStorage")

--// Variables

local Player = game.Players.LocalPlayer

local PerkShopFrame =  Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames:WaitForChild("PerkShopFrame")
local Scroll = PerkShopFrame.Perks

local Modules = RS.Modules
local Content = require(Modules.Shared.ContentManager)
local Utilities = require(Modules.Client.Utilities)
local SyncedTime = require(Modules.SyncedTime)

local Remotes = RS.Remotes

local Template = script.Upgrade



local function SetPerkSlot(Perk, Slot)
	local PerkInfo = Content.Perks[Perk]
	local PerkStat = Player.Data["Perk"..Perk]
	Scroll[Slot].Title.Text = PerkInfo.Title.." "..Utilities.Short.RomanNumeral(PerkStat.Value + 1)
	Scroll[Slot].PerkName.Tier.Text = Utilities.Short.RomanNumeral(Player.Data["Perk"..Perk].Value + 1)
	Scroll[Slot].PerkName.ImageColor3 = PerkInfo.Color
	Scroll[Slot].Multiplier.Text = string.format(PerkInfo.Boost, PerkInfo.Prices(PerkStat.Value + 1).Reward)

	if Player.Data.Rank.Value >= PerkInfo.Prices(PerkStat.Value).Price then
		Scroll[Slot].Cost.Text = "-"..PerkInfo.Substraction.." Ranks"
	else
		if PerkInfo.Prices(PerkStat.Value).Price <= #Content.Ranks then
			Scroll[Slot].Cost.Text = Content.Ranks[PerkInfo.Prices(PerkStat.Value).Price].RankName
			Scroll[Slot].Cost.TextColor3 = Content.Ranks[PerkInfo.Prices(PerkStat.Value).Price].RankColor
		else
			Scroll[Slot].Cost.Text = "Max"
			Scroll[Slot].Cost.TextColor3 = Color3.fromRGB(255,255,255)
		end
		--Content[Slot].Cost.Text = "Rank "..PerkInfo.Prices(PerkStat.Value).Price.." Required"
	end
end

function PerkShop:Init()
	Utilities.ButtonAnimations.Create(PerkShopFrame.Close)
	
	PerkShopFrame.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(PerkShopFrame, UDim2.new(0,0,0,0))
	end)

	PerkShopFrame.Toggle.TextButton.MouseButton1Click:Connect(function()
		Utilities.Audio.PlayAudio("Click")
		Utilities.ButtonHandler.OnClick(PerkShopFrame.Parent.PerkInventory, UDim2.new(0.52,0,0.52,0))
	end)

	repeat wait() until RS.Perks["1"].Value ~= 0

	local function UpdatePerks()
		for i = 1,3 do
			SetPerkSlot(RS.Perks[i].Value, i)
		end
	end

	UpdatePerks()

	Remotes.BuyPerk.OnClientEvent:Connect(function()
		UpdatePerks()
	end)

	local function BuyPerk(Perk)
		Remotes.BuyPerk:FireServer(tonumber(Perk))
	end
	
	task.spawn(function()
		for _,Perk in Scroll:GetChildren() do
			if Perk:IsA("Frame") then
				Perk.PurchaseButton.Click.MouseButton1Click:Connect(function()
					Utilities.Audio.PlayAudio("Click")
					BuyPerk(Perk.Name)
				end)
			end
		end
	end)

	Player.Data.Rank.Changed:Connect(function()
		UpdatePerks()
	end)
	
	task.spawn(function()
		for _,v in RS.Perks:GetChildren() do
			if v:IsA("IntValue") then
				v.Changed:Connect(function()
					local suc,er = pcall(function() -- as i dont know if it works i added pcall
						SetPerkSlot(v.Value, tonumber(v.Name))
					end)

					if er then
						warn("Something went wrong with perk updating: "..er)
					end
				end)
			end
		end
	end)
	
	spawn(function()
		while task.wait(1) do
			local hour = math.floor((SyncedTime.time()) / 3600)
			local t = (math.floor(SyncedTime.time()))
			local timeleft = 3600 - (t % 3600)
			local timeleftstring = Utilities.Short.time(timeleft)

			PerkShopFrame.Info.Timer.Text = "Perks Refresh in"..Utilities.Short.time(timeleft)	
		end
	end)
end

return PerkShop
