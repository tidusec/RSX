local GUIHandlerModule = {}

--// Services

local RS = game:GetService("ReplicatedStorage")
local SG = game:GetService("StarterGui")

--// Variables

local Player = game.Players.LocalPlayer


local Content = require(RS.Modules.Shared.ContentManager)
local Stars = require(RS.Modules.Stars)
local Utilities = require(RS.Modules.Client.Utilities)
local Worlds = require(RS.Modules.Worlds)

local MaxCombo = Stars.Config.MaxCombo

local CreateNotification = RS.Remotes.CreateNotification

local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD
local Buttons = HUD.Buttons
local Frames = HUD.Frames

local Rings = workspace.Rings

local BaseSize = {}

--// Rings 

local function HandleRing(Ring,Frame)
	if Player.Character then
		local suc,er = pcall(function()
			if (Player.Character.HumanoidRootPart.Position-Ring.PrimaryPart.Position).Magnitude < Ring.PrimaryPart.Size.X/2 + 1 then
				if not Frame.Visible then
					Utilities.ButtonHandler.OnClick(Frame, BaseSize[Frame.Name])
				end
			end
		end)

		if er then print(er) end
	end
end


function GUIHandlerModule:Init()
	coroutine.wrap(function() -- run seperately
		while wait(5) do
			HUD["Friend Boost"].Text = "Friend Boost: "..Utilities.Short.en(Player.FriendBoost.Value).."x"
		end
	end)()

	BaseSize["PerkShopFrame"] = Frames.PerkShopFrame.Size
	BaseSize["RankShop"] = Frames.RankShop.Size
	BaseSize["Shop"] = Frames.Shop.Size
	BaseSize["UpgradeShop"] = Frames.UpgradeShop.Size
	BaseSize["Index"] = Frames.Index.Size
	BaseSize["Achievements"] = Frames.Achievements.Size
	BaseSize["SpinWheel"] = Frames.SpinWheel.Size
	BaseSize["Enchant"] = Frames.Enchant.Size
	BaseSize["HalloweenShop"] = Frames.HalloweenShop.Size

	task.spawn(function()
		while wait(0.1) do
			HandleRing(Rings.Ranks,Frames.RankShop)
			HandleRing(Rings.Robux,Frames.Shop)
			HandleRing(Rings.Upgrades,Frames.UpgradeShop)
			HandleRing(Rings.Index,Frames.Index)
			HandleRing(Rings.Achievements, Frames.Achievements)
			HandleRing(Rings.Spin,Frames.SpinWheel)
			HandleRing(Rings.Enchant, Frames.Enchant)
			HandleRing(Rings.HalloweenShop, Frames.HalloweenShop)

			if not Frames.PerkInventory.Visible then
				HandleRing(Rings.Perks,Frames.PerkShopFrame)
			end

			local HasSpin = Player.Data.HasSpin.Value

			if HasSpin - os.time() < 0 then
				Rings.Spin.MainPart.BillboardGui.TextLabel.Text = "Spin available!"
			else
				Rings.Spin.MainPart.BillboardGui.TextLabel.Text = "Next spin in ".. Utilities.Short.time(HasSpin - os.time())
			end
		end
	end)
end

return GUIHandlerModule
