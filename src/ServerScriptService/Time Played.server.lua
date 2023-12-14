game.Players.PlayerAdded:Connect(function(Player)
	repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value or Player.Parent == nil
	while wait(1) do
		Player.Data.Time.Value += 1
		Player.Data["UgcTime"].Value += 1
		Player.IngameTime.Value += 1
		Player.Data["HalloweenTime"].Value += 1
		Player.Data.SeasonQuest8.Value += 1/3600
	end
end)