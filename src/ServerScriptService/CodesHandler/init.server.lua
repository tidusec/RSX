--// Services

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

--// Variables

local Remotes = RS.Remotes
local Remote = Remotes:WaitForChild("RedeemCode")

local Codes = require(script.Codes)

--// Script

local function CreateCode(Player,Code)
	local Redeemed = Instance.new("BoolValue")
	Redeemed.Name = Code
	Redeemed.Parent = Player.PlayerData.Codes
end

Remote.OnServerInvoke = function(Player,Code)
	if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
		if Player.PlayerData.Codes:FindFirstChild(Code) then
			return "Error","Code is already redeemed"
		else
			if Codes[Code] then
				if not Codes[Code].Expired then
					CreateCode(Player,Code)
					
					if Code == "DFHDH-92JA-HEK8K20-LL9284-RSX" then
						Player.Data.DiscordReward.Value = true
						return "Succes","Redeemed 1.35x Stars & 1.25x Luck"
					end
					if Codes[Code].Type == "Stat" then
						Player.Data[Codes[Code].Stat].Value += Codes[Code].Amount
						return "Succes","Redeemed "..Codes[Code].Amount.." "..Codes[Code]["StatName"]
					end
				else
					return "Error","Code has expired"
				end
			else
				return "Error","Code does not exist"
			end
		end
	else
		warn("Failed to redeem code, player hasn't loaded yet")
	end
end