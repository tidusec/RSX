--// Services

local BS = game:GetService("BadgeService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

--// Script

function AwardBadge(Player: Player, ID: number, Retries)
	if Retries == 0 then return end
	local Success, Result = pcall(function()
		BS:AwardBadge(Player.UserId, ID)
	end)

	if not Success then
		warn("Error while awarding badge: " .. Result)
	elseif not Result then
		task.spawn(function()
			task.wait(1)

			AwardBadge(Player, ID, Retries - 1)
		end)
	end
end

function HasBadge(Player: Player, ID: BadgeId)
	return BS:UserHasBadgeAsync(Player.UserId, ID)
end

function ValueBadge(Player: Player, ID: BadgeId, Requirement: Number, ValueName, String)
	if Player.Data[ValueName].Value >= Requirement then
		AwardBadge(Player,ID,2)
	end

	local Connection
	Connection = Player.Data[ValueName].Changed:Connect(function()
		if not HasBadge(Player, ID) then
			AwardBadge(Player,ID,2)
		end
		Connection:Disconnect()
	end)
end

Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Players:FindFirstChild(Player.Name) == nil
	
	if Player.Parent == nil then return end
		
	local Data = Player.Data
	
	AwardBadge(Player,2145420160,2)
		
	ValueBadge(Player, 2147742237, 2, "Rank")
	ValueBadge(Player, 2148638578, 1, "Eggs Opened")
end)