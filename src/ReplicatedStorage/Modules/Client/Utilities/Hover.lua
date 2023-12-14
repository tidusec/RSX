local Dropdown = {}

function Dropdown.Create(Frame: MouseEnterFrame, Hover: HoverUI, ParentFrame: Frame)
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local MoveHoverUI = Mouse.Move:Connect(function()
		Hover.Visible = true
		Hover.Position = UDim2.fromOffset(
			Mouse.X-ParentFrame.AbsolutePosition.X, 
			Mouse.Y-ParentFrame.AbsolutePosition.Y
		)
	end)
	local Disconnect

	Disconnect = Frame.MouseLeave:Connect(function()
		Hover.Visible = false

		MoveHoverUI:Disconnect()
		Disconnect:Disconnect()
	end)
end

return Dropdown
