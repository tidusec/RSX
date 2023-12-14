local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage.Remotes
local Content = require(ReplicatedStorage.Modules.Shared.ContentManager)

EquipNametag = Remotes.EquipNametag
UnequipNametag = Remotes.UnequipNametag

local nametagsFolder = workspace.Nametags
local nametagAdornees: {[Player]: BillboardGui} = {}
local nametagGui = script.Tags
local ServerEquippedNametags = {}

local function unequipNametag(player: Player)
	local PlayerData = player.Data
	PlayerData.Nametag.Value = "None"
	nametagAdornees[player]:SetAttribute('NametagEffect', "None")
end

local function equipNametag(player: Player, nametagKey: string)
	local PlayerData = player.Data

	PlayerData.Nametag.Value =  nametagKey
	if nametagAdornees[player] then
		nametagAdornees[player]:SetAttribute('NametagEffect', nametagKey)
	end
end


local function characterAdded(character: Model)
	local player = Players:GetPlayerFromCharacter(character)
	local equippedNametag = Remotes.GetEquippedNametag:InvokeClient(player)
	ServerEquippedNametags[character] = {}
	
	if nametagAdornees[player] then
		nametagAdornees[player].Adornee = character:WaitForChild("Head")
	end
	equipNametag(player, equippedNametag)
end

local function playerAdded(player: Player)
	repeat wait() until player:FindFirstChild("Loaded") and player.Loaded.Value or player.Parent == nil
	
	--player.Data.Nametag.Value = "None"
	local equippedNametag = Content.Title[player.Data.Nametag.Value].Title
	local newNametag = nametagGui:Clone()
	local Rank = player.Data.Rank
	
	newNametag.Rank.Rank.Image = Content.Ranks[Rank.Value].RankImage

	
	newNametag.Title.Text = equippedNametag
	

	nametagAdornees[player] = newNametag	

	Rank.Changed:Connect(function()
		newNametag.Rank.Rank.Image = Content.Ranks[Rank.Value].RankImage
	end)
	
	if player.Character then characterAdded(player.Character) end
	player.CharacterAdded:Connect(characterAdded)
	newNametag.Parent = nametagsFolder
end

local function playerRemoving(plr)
	if nametagAdornees[plr] then
		nametagAdornees[plr]:Destroy()
		nametagAdornees[plr] = nil
	end
end


EquipNametag.OnServerEvent:Connect(equipNametag)
UnequipNametag.OnServerEvent:Connect(unequipNametag)


game.Players.PlayerAdded:Connect(playerAdded)
