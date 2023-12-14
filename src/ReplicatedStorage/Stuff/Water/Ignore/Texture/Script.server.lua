local TweenService = game:GetService("TweenService")
local Tween1 = TweenService:Create(script.Parent, TweenInfo.new(4,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut), {OffsetStudsU = 3.5, OffsetStudsV = 3.5})
local Tween2 = TweenService:Create(script.Parent, TweenInfo.new(4,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut), {OffsetStudsU = 0, OffsetStudsV = 0})

for _,Part in script.Parent.Parent.Parent:GetChildren() do
	TweenService:Create(Part, TweenInfo.new(5,Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut,1000000000000,true,1),{Position = Part.Position + Vector3.new(0,0.5,0)}):Play()
end

while true do
	Tween1:Play()
	Tween1.Completed:Wait()
	Tween2:Play()
	Tween2.Completed:Wait()
end