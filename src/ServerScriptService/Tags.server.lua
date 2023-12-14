--// Services

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local MarketPlaceService = game:GetService("MarketplaceService")

local GrouproleColors = {
	["Member"] = Color3.fromRGB(55, 102, 255),
	["Tester"] = Color3.fromRGB(150, 255, 126),
	["Youtuber"] = Color3.fromRGB(255, 103, 52),
	["Founder"] = Color3.fromRGB(149, 43, 255),
	["Developer"] = Color3.fromRGB(255, 74, 3),
	["Lead Developer"] = Color3.fromRGB(255, 51, 10),
	["Co-Owner"] = Color3.fromRGB(247, 49, 10),
	["Owner"] = Color3.fromRGB(213, 0, 0),
}

--// Leaderboard Tags

local function LeaderboardPosition(Player)
	local HighestPos,Leaderboard = 101,nil
	for _,v in workspace.Leaderboards:GetChildren() do
		local lb = nil
		if v:IsA("Model") and v.Name ~= "Tokens" then
			lb = v.Name
			for _,z in v.MainPart.SurfaceGui.MainFrame.Players.Scroll:GetChildren() do
				if z:IsA("Frame") then
					if z.Player:FindFirstChild("PlrName").Text == Player.Name then
						if HighestPos > tonumber(string.split(z.Rank.Number.Text,"#")[2]) then
							HighestPos = tonumber(string.split(z.Rank.Number.Text,"#")[2])
							Leaderboard = lb
						end
					end
				end
			end
		end
	end

	if HighestPos <= 100 and Leaderboard ~= nil then
		return HighestPos,Leaderboard
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil
	
	if Player.Parent == nil then return end

	local Tags = {}	

	local ChatService = require(SSS:WaitForChild("ChatServiceRunner").ChatService)

	local Speaker = nil

	while Speaker == nil do
		Speaker = ChatService:GetSpeaker(Player.Name)
		if Speaker ~= nil then break end
		task.wait(0.01)
	end

	Speaker:SetExtraData("Tags",Tags)
	Speaker:SetExtraData("ChatColor",Color3.fromRGB(255, 255, 255))

	local Types = {
		["Stars"] = {"⭐",Color3.fromRGB(255, 255, 0)},
		["Gems"] = {"💎",Color3.fromRGB(0, 170, 255)},
		["Eggs"] = {"🥚",Color3.fromRGB(255, 223, 148)},
		["Robux Spent"] = {"💸",Color3.fromRGB(69, 255, 56)},
		["Time Played"] = {"⏰", Color3.fromRGB(255, 39, 39)},
		["Pet Power"] = {"🐾", Color3.fromRGB(170, 62, 0)},
		["CandyCorn"] = {"🍬", Color3.fromRGB(216, 105, 8)}
	}
	
	local GroupRole = Player:GetRoleInGroup(12554523)
	
	if GroupRole ~= "Guest" then
		table.insert(Tags,{TagText = GroupRole, TagColor = GrouproleColors[Player:GetRoleInGroup(12554523)]})
	end

	local LBTag = false

	while task.wait(10) do
		local suc,er = pcall(function()
			local Pos,Type = LeaderboardPosition(Player)
			if Pos ~= nil and Type ~= nil then
				if LBTag == false then
					LBTag = true
					table.insert(Tags,
						{
							TagText = Types[Type][1].." #"..Pos, 
							TagColor = Types[Type][2]
						})
				else
					for _,v in Tags do 
						if string.match(v.TagText,"#") then
							v.TagText = Types[Type][1].." #"..Pos
							v.TagColor = Types[Type][2]
						end
					end
				end
			end
		end)

		if er then warn(er) end
		wait(20)
	end
end)