while true do
	wait(0.25)
	script.Parent.Dot1.InsideDot:TweenSize(UDim2.new(1,0,1,0), "In", "Sine", 0.25, true)
	wait(0.25)
	script.Parent.Dot2.InsideDot:TweenSize(UDim2.new(1,0,1,0), "In", "Sine", 0.25, true)
	wait(0.25)
	script.Parent.Dot3.InsideDot:TweenSize(UDim2.new(1,0,1,0), "In", "Sine", 0.25, true)
	wait(0.25)
	script.Parent.Dot1.InsideDot:TweenSize(UDim2.new(0,0,0,0), "In", "Sine", 0.25, true)
	wait(0.25)
	script.Parent.Dot2.InsideDot:TweenSize(UDim2.new(0,0,0,0), "In", "Sine", 0.25, true)
	wait(0.25)
	script.Parent.Dot3.InsideDot:TweenSize(UDim2.new(0,0,0,0), "In", "Sine", 0.25, true)
end