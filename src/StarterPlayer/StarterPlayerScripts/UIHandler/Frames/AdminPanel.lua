local AdminPanelmodule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local AdminPanel = LocalPlayer.PlayerGui:WaitForChild('Rank Simulator X').HUD.Frames.AdminPanel

local PanelUI = AdminPanel.AdminPanel.Body

local scrollingFrame = PanelUI:WaitForChild("Main")
local targetFrame = scrollingFrame.TARGET

local function hoverSystem()
	for i, v in scrollingFrame:GetDescendants() do
		if v:IsA("Frame") and v.Name == "Shadow" then
			if v.Parent:IsA("Frame") then
				local button: TextButton = v.Parent.Trigger
				button.MouseEnter:Connect(function()
					v.Visible = true
				end)
				button.MouseLeave:Connect(function()
					v.Visible = false
				end)
			end
		end
		if v:IsA("Frame") and v.Name == "Hover" then
			if v.Parent:IsA("Frame") then
				local button: TextButton = v.Parent.Trigger
				button.MouseEnter:Connect(function()
					v.Transparency = 0
				end)
				button.MouseLeave:Connect(function()
					v.Transparency = 1
				end)
			end
		end
	end
end

function AdminPanelmodule:Init()
	hoverSystem()
end

return AdminPanelmodule
