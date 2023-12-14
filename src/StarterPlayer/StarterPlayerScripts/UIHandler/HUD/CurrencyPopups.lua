local Currency = {}
local Player = game.Players.LocalPlayer

local RS = game:GetService("ReplicatedStorage")
local Utilities = require(RS.Modules.Client.Utilities)
local Content = require(RS.Modules.Shared.ContentManager)

function Currency.CreatePopups()
	local Stars, StarsBefore = Player.Data.Stars, Player.Data.Stars.Value
	local Gems, GemsBefore = Player.Data.Gems, Player.Data.Gems.Value
	local CandyCorn, CandyCornBefore = Player.Data.CandyCorn,Player.Data.CandyCorn.Value
	
	Stars.Changed:Connect(function()
		if Stars.Value-StarsBefore > 0 then
			print(Stars.Value-StarsBefore > 0)
			Utilities.Popup.Random("+"..Utilities.Short.en(Stars.Value-StarsBefore),Color3.fromRGB(250,233,0),2,RS.Audio.Collect,"rbxassetid://11623114533")
			
		end

		--// Rank Afford Popup
		if Content.Ranks[Player.Data.Rank.Value+1] ~= nil then
			local RankAboveInfo = Content.Ranks[Player.Data.Rank.Value + 1]
			if Stars.Value >= RankAboveInfo.Cost and StarsBefore < RankAboveInfo.Cost then -- if you had less than the requirmeent but now have more
				Utilities.Popup.Layered("You can now afford rank "..RankAboveInfo.RankName, Color3.fromRGB(85, 170, 255), 3, RS.Audio.Completed)
			end
		end

		StarsBefore = Stars.Value
	end)

	Gems.Changed:Connect(function()
		if Gems.Value-GemsBefore > 0 then
			Utilities.Popup.Random("+"..Utilities.Short.en(Gems.Value-GemsBefore),Color3.fromRGB(0, 170, 255),2,RS.Audio.Collect,"rbxassetid://12506258121")
		end
		GemsBefore = Gems.Value
	end)
	CandyCorn.Changed:Connect(function()
		if CandyCorn.Value - CandyCornBefore > 0 then
			Utilities.Popup.Random("+" .. Utilities.Short.en(CandyCorn.Value-CandyCornBefore),Color3.fromRGB(255, 151, 6),2,RS.Audio.Collect,"rbxassetid://15020369551")
		end
		CandyCornBefore = CandyCorn.Value--]]
	end)
end

return Currency
