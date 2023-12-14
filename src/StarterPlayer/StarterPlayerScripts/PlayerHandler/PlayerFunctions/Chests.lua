local Chests = {}
local Player = game.Players.LocalPlayer
local HUD = Player.PlayerGui:WaitForChild("Rank Simulator X"):WaitForChild("HUD")

local RS = game:GetService("ReplicatedStorage")
local Utilities = require(RS.Modules.Client.Utilities)
local Content = require(RS.Modules.Shared.ContentManager)

function OnChestTouch(Chest)
	local ChestCooldown = Player.Data[Chest.Name.."ChestCooldown"]
	if ChestCooldown.Value < os.time() then
		RS.Remotes.ClaimChest:FireServer(Chest.Name)
	else
		Utilities.Popup.Layered("You have a cooldown!", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
	end
end

function UpdateTimer(Chest)
	local ChestCooldown = Player.Data[Chest.Name.."ChestCooldown"]
	local Timer = Chest.PrimaryPart.BillboardGui.ClaimText

	if ChestCooldown.Value > os.time() then
		Timer.Text = "Claim in"..Utilities.Short.time(ChestCooldown.Value-os.time())

		if Chest.Name == "Mine" and Chest:FindFirstChild("MineDecoration") then
			Chest.MineDecoration.Parent = RS
		elseif Chest.Name == "Toxic" and Chest:FindFirstChild("ToxicDecoration") then
			Chest.ToxicDecoration.Parent = RS
		end
	else
		Timer.Text = "Claim"

		if Chest.Name == "Mine" and RS:FindFirstChild("MineDecoration") then
			RS.MineDecoration.Parent = Chest
		elseif Chest.Name == "Toxic" and RS:FindFirstChild("ToxicDecoration") then
			RS.ToxicDecoration.Parent = Chest
		end
	end
end

function Chests.Create()
	for _,Chest in workspace.Chests:GetChildren() do
		if not Chest:IsA("Model") or not Chest.PrimaryPart then continue end
		local ChestInfo = Content.Chests[Chest.Name]
		
		--// Timer
		
		local IsEnabled = false
		local TimerCoroutine = coroutine.create(function()			
			while task.wait(0.5) do
				UpdateTimer(Chest)
				
				if not IsEnabled then coroutine.yield() end
			end
		end)
		
		--// Handle Timer per world
		
		if ChestInfo.World == Player.World.Value then
			IsEnabled = true
			coroutine.resume(TimerCoroutine)
		end
		
		Player.World.Changed:Connect(function()
			if ChestInfo.World == Player.World.Value then
				IsEnabled = true
				coroutine.resume(TimerCoroutine)
			else
				IsEnabled = false
				coroutine.yield(TimerCoroutine)
			end
		end)
			
		--// Touched
		local ChestCD = false
		Chest.PrimaryPart.Touched:Connect(function(Hit)
			if Hit.Parent.Name ~= Player.Name then return end
			if ChestCD then return end
			
			ChestCD = true
			OnChestTouch(Chest)
			task.wait(1)
			ChestCD = false
		end)
	end
end

return Chests
