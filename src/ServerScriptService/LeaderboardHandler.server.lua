--// Services

local DS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")
local Plrs = game:GetService("Players")
local SS = game:GetService("ServerStorage")
local MS = game:GetService("MessagingService")

--// Variables

local Leaderboards = workspace.Leaderboards

local Modules = RS:WaitForChild("Modules")
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)
local LeaderboardInfo = Content.Leaderboards

local currentMonth = (DateTime.now():FormatLocalTime("MMMMYYYY","en-us"))
local AwardedLBPets = DS:GetDataStore("PetLBData"):GetAsync(currentMonth) == true
local PetsStore = DS:GetDataStore("Pets")

local LBPets = {
	"Golden Prestige Dragon",
	"Silver Prestige Dragon",
	"Bronze Prestige Dragon"
}

function RandomID(Player)
	local Chance = math.random(2,10000000)
	if Player.Pets:FindFirstChild(Chance) then
		return RandomID()
	end

	return Chance
end


local function CreatePet(Player,Pet)
	if not Player.Index:FindFirstChild(Pet) then
		local NewVal = Instance.new("IntValue",Player.Index)
		NewVal.Value = 1
		NewVal.Name = Pet

		local NewPet = RS.Pets.PetTemplate:Clone()
		NewPet.PetName.Value = Pet
		NewPet.Multiplier1.Value = Content.Pets[Pet].Multiplier
		NewPet.Parent = Player.Pets
		NewPet.Name = RandomID(Player)

		Player.Data.PetsOwned.Value += 1

		RS.Pets.Exist.Server["0 "..Pet].Value += 1
	end
end

MS:SubscribeAsync("AwardLBPet", function(Message)
	local Split = string.split(Message.Data,",")
	local UserID, Pet = tonumber(Split[1]), Split[2]

	for _, Player in game.Players:GetPlayers() do
		if Player.UserId == UserID then
			CreatePet(Player, Pet)
		end
	end
end)

local Template = script.Template
Template.Visible = false

local Cache = SS.Cache

local function GetNameFromUserId(Id)
	local Cached = Cache.UserIds:FindFirstChild(tostring(Id))

	if Cached then
		return tostring(Cached.Value)
	else
		local new
		pcall(function()
			new = game:GetService("Players"):GetNameFromUserIdAsync(Id)
		end)
		if new then
			local x = Instance.new("StringValue")
			x.Name = tostring(Id)
			x.Value = tostring(new)
			x.Parent = Cache.UserIds

			if not Cache.Names:FindFirstChild(tostring(new)) then
				local y = Instance.new("IntValue")
				y.Name = tostring(new)
				y.Value = tonumber(Id)
				y.Parent = Cache.Names
			end

			return tostring(new)
		end
	end

	return nil
end

local function GetFlagFromUserId(Id)
	local Cached = Cache.Flags:FindFirstChild(tostring(Id))

	if Cached then
		return tostring(Cached.Value)
	else
		local new
		pcall(function()
			local PlrData = DS:GetDataStore("Data"):GetAsync(Id)
			new = PlrData[49]
		end)
		if new then
			local x = Instance.new("StringValue")
			x.Name = tostring(Id)
			x.Value = tostring(new)
			x.Parent = Cache.Flags
		end
	end
end

local function SetLeaderboardStats(Leaderboard)
	for _,Player in Plrs:GetChildren() do
		if Player:FindFirstChild("Loaded") and Player.Loaded.Value then
			local Stat = Player[Leaderboard.Folder][Leaderboard.Stat].Value
			Stat += 1
			Stat = math.log10(Stat)
			Stat *= 270000000000

			local Datastore = DS:GetOrderedDataStore(Leaderboard.Datastore)
			pcall(function()Datastore:SetAsync(Player.UserId, math.round(Stat)) end)
			task.wait(0.05)
		end
	end
end

local function Update(LB,Info)
	local Leaderboard = Leaderboards[LB]

	local Datastore = DS:GetOrderedDataStore(Info.Datastore)
	local GetData = Datastore:GetSortedAsync(false, 100)
	local GetCurrent = GetData:GetCurrentPage()

	task.wait()

	local Sort = Leaderboard.PrimaryPart.SurfaceGui.MainFrame.Players.Scroll

	for Rank,Data in GetCurrent do
		local LBInstance = Sort:FindFirstChild(tostring(Rank))
		LBInstance.Visible = true
		LBInstance.Rank.Number.Text = "#"..Rank

		local Username = GetNameFromUserId(Data.key)
		if Username == nil then Username = Data.key end
		LBInstance.Player.PlrName.Text = Username 

		local vl = Data.value
		vl /= 270000000000
		vl = 1e1^vl
		vl -= 1e0
		vl = math.round(vl)

		if not Info.ShortenType then
			LBInstance.Amount.Number.Text = Utilities.Short.en(vl)
		elseif Info.ShortenType == "Time" then
			LBInstance.Amount.Number.Text = Utilities.Short.time(vl)
		else
			LBInstance.Amount.Number.Text = vl
		end

		local CountryCode = GetFlagFromUserId(Data.key)

		if CountryCode ~= nil and RS.Flag:FindFirstChild(CountryCode) then
			LBInstance.Player.PlayerIcon.Image = RS.Flag[CountryCode].Texture
		else
			LBInstance.Player.PlayerIcon.Image = ""
		end
		
		task.wait(1)
		--LBInstance.PlayerIcon.Image = game.Players:GetUserThumbnailAsync(Data.key, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end
end

function awardLBPets()
	local CurrentDay = os.date("*t").day
	
	if not AwardedLBPets and CurrentDay == 1 then
		DS:GetDataStore("PetLBData"):SetAsync(currentMonth, true)

		local Leaderboard = Leaderboards["Pet Power"]

		local Datastore = DS:GetOrderedDataStore(LeaderboardInfo["Pet Power"].Datastore)
		local Top25 = Datastore:GetSortedAsync(false, 25)
		local GetCurrent = Top25:GetCurrentPage()
		
		for Rank, Info in (GetCurrent) do
			local UserID, PetPower = Info.key, Info.Value
			local PlayerName = GetNameFromUserId(UserID)
			
			local function AddLBPet(PetName)
				local PetsTable = PetsStore:GetAsync(tonumber(UserID))

				local NewTable = {
					PetID = Random.new():NextInteger(0,1e8),
					Equipped = false,
					PetName = PetName,
					Multiplier1 = Content.Pets[PetName].Multiplier,
					TotalXP = 0,
					Type = 0,
					Locked = true
				}

				table.insert(PetsTable, NewTable)

				PetsStore:SetAsync(UserID,PetsTable)
			end

			if Rank == 1 then
				MS:PublishAsync("AwardLBPet", UserID..",".. LBPets[1])
				AddLBPet(LBPets[1])
			elseif Rank <= 10 then
				MS:PublishAsync("AwardLBPet", UserID..",".. LBPets[2])
				AddLBPet(LBPets[2])
			else
				MS:PublishAsync("AwardLBPet", UserID..",".. LBPets[3])
				AddLBPet(LBPets[3])
			end
			task.wait(5)
		end
	end
end

--// Setup

for _,Leaderboard in Leaderboards:GetChildren() do
	local MainFrame = Leaderboard.PrimaryPart.SurfaceGui.MainFrame
	MainFrame.Title.Text = LeaderboardInfo[Leaderboard.Name].Title
	MainFrame.Players.Amount.Text = LeaderboardInfo[Leaderboard.Name].Stat

	for i = 1,100 do
		local Clone = Template:Clone()
		Clone.LayoutOrder = i
		Clone.Name = i
		Clone.Rank.Number.Text = ""
		Clone.Player.PlrName.Text = ""
		Clone.Amount.Number.Text = ""
		Clone.Parent = MainFrame.Players.Scroll
	end 
end

--// Script

while wait(5) do
	for Name,Info in LeaderboardInfo do
		local suc,er = spawn(function()
			SetLeaderboardStats(Info)	
			task.wait(.1)
			Update(Name,Info)
		end)

		task.wait(10)

		if er then warn(er) end	
	end

	local suc,er = task.spawn(function()
		AwardedLBPets = DS:GetDataStore("PetLBData"):GetAsync(currentMonth) == true
		awardLBPets()
	end)
	
	if er then warn(er) end

	wait(45)
end