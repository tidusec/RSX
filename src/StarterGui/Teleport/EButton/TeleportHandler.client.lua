--// Services

local RNS = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local PLRS = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local SS = game:GetService("SoundService")

--// Variables

local Player = PLRS.LocalPlayer

repeat wait() until Player:FindFirstChild("Loaded") and Player.Loaded.Value

local Camera = workspace.CurrentCamera

local Modules = RS.Modules
local Utilities = require(Modules.Client.Utilities)
local Worlds = require(Modules.Worlds)
local Content = require(Modules.Shared.ContentManager)

local EButton = script.Parent

local CurrentTarget = EButton.CurrentTarget
local MaxMagnitude = EButton.MaxMagnitude

local DefaultSize = EButton.Size
EButton.Size = UDim2.new(0,0,0,0)

local MainUI = Player.PlayerGui:WaitForChild("Rank Simulator X")
local HUD = MainUI.HUD

local TeleportRemote = RS.Remotes.Teleport

--// Setup

for World,WorldInfo in Worlds do
	if workspace.Portals:FindFirstChild(World) then
		workspace.Portals[World].Tp.BillboardGui.Frame.ImageLabel.Image = Content.Ranks[WorldInfo.Requirement].RankImage
		workspace.Portals[World].Tp.BillboardGui.Frame.TextLabel.Text = Content.Ranks[WorldInfo.Requirement].RankName
	end
end

--// Determines what egg is the closest if you are in range of multiple

function GetClosestPortal(PortalsAvailable)
	local CurrentClosest = nil
	local ClosestDistance = MaxMagnitude.Value
	for _,Portal in pairs(PortalsAvailable) do
		local MainPart = workspace.Portals:FindFirstChild(Portal).Tp
		local mag = (MainPart.Position-Player.Character.HumanoidRootPart.Position).Magnitude
		if mag <= ClosestDistance then
			CurrentClosest = workspace.Portals:FindFirstChild(Portal)
			ClosestDistance = mag
		end
	end
	return CurrentClosest
end

--// Handles the visibility of the PreviewFrame

RNS.RenderStepped:Connect(function()
	if Player.Character:FindFirstChild("Humanoid") then
		if Player.Character.Humanoid.Health ~= 0 then
			if EButton.Parent.Enabled then
				local PortalsAvailable = {}
				local CameraRatio = ((Camera.CFrame.Position - Camera.Focus.Position).Magnitude)/11

				for _,v in workspace.Portals:GetChildren() do
					if v:IsA("Model") then
						local mag = (v.Tp.Position-Player.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
						if mag <= script.Parent.MaxMagnitude.Value then
							PortalsAvailable[#PortalsAvailable+1] = v.Name
						end
					end
				end

				local Size = UDim2.new(DefaultSize.X.Scale/CameraRatio, DefaultSize.X.Offset, DefaultSize.Y.Scale/CameraRatio, DefaultSize.Y.Offset)

				if #PortalsAvailable == 1 then
					local Portal = workspace.Portals:FindFirstChild(PortalsAvailable[1])
					local WSP = workspace.CurrentCamera:WorldToScreenPoint(Portal.Tp.Position)
					if EButton.Visible == false then
						EButton:TweenSize(Size,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
						EButton.Visible = true
					end				
					EButton.Position = UDim2.new(0,WSP.X,0,WSP.Y)
					CurrentTarget.Value = Portal.Name
				elseif #PortalsAvailable > 1 then
					local Portal = GetClosestPortal(PortalsAvailable)
					local WSP = workspace.CurrentCamera:WorldToScreenPoint(Portal.Tp.Position)
					if EButton.Visible == false then
						EButton:TweenSize(Size,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
						EButton.Visible = true
					end
					EButton.Position = UDim2.new(0,WSP.X,0,WSP.Y)
					CurrentTarget.Value = Portal.Name
				elseif #PortalsAvailable == 0 then
					CurrentTarget.Value = "None"
					if EButton.Visible == true then
						EButton:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.25,true)
						spawn(function()
							wait(0.05)
							EButton.Visible = false
						end)
					end		
				end			
			end
		end
	end
end)

local TeleportCooldown = false

local function teleportRequest()
	if TeleportCooldown == false then
		local Succes, Message = TeleportRemote:InvokeServer(CurrentTarget.Value)

		if Succes and Succes == "Error" then
			Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
		end

		TeleportCooldown = true -- bottom of the script, so if it breaks you can just press again
		wait(1.5)
		TeleportCooldown = false
	end
end

UIS.InputBegan:connect(function(input,gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.E then
			if UIS:GetFocusedTextBox() == nil then
				if CurrentTarget.Value ~= "None" then
					teleportRequest()
				end
			end
		end
	end
end)

EButton.TextButton.MouseButton1Click:Connect(function()
	teleportRequest()
end)