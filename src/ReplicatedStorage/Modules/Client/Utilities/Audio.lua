local module = {}

module.PlayAudio = function(Soundname, Volume)
	spawn(function()
		if not game.Players.LocalPlayer.Data.MuteSounds.Value then
			local Sound = game.ReplicatedStorage.Audio[Soundname]:Clone()
			Sound.Parent = game.SoundService
			Sound.Volume = Volume or Sound.Volume
			Sound:Play()
			wait(Sound.TimeLength)
			Sound:Destroy()
		end
	end)
end

return module
