local bar = script.Parent.Bar
local insidebar = bar.Bar2
local percentage = bar.Percentage

wait(5)
insidebar:TweenSize(UDim2.new(1,0,1,0), "In", "Linear", 20, true)
wait(20)
script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(0,0,0,0), "InOut", "Quad", 3, true)
wait(3)
script.Parent.Visible = false
script.Parent.Parent.EndSequence:TweenPosition(UDim2.new(-1,0,0,0), "InOut", "Quad", 3, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
wait(3)
script.Parent.Parent.Parent.Loading:Destroy()