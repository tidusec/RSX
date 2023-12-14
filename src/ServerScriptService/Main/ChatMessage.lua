local RS = game:GetService("ReplicatedStorage")
local MS = game:GetService("MessagingService")
local Messages = {
	"[TIP]: Hatch Eggs to get better pets",
	"[TIP]: Walk around to collect stars",
	"[TIP]: Don't forget to buy upgrades",
	"[TIP]: Rank up to get more boosts!",
	"[TIP]: Collect gems to buy powerful buffs!",
	"[TIP]: Secret pets are the rarest pets in the game!",
	"[TIP]: Join the group for free triple hatch",
	"[TIP]: Invite your friends to get +10% stars per friend!",
}

local ChatMessage = {}

ChatMessage.SendMessage = function()
	--// Global Secret Hatch
	MS:SubscribeAsync("Secret Hatch", function(Message)
		local Message = Message.Data
		
		local Info = {
			Text = (Message);
			Color = Color3.new(0.305882, 0.854902, 0.152941);
			Font = Enum.Font.SourceSansBold; 
			FontSize = Enum.FontSize.Size18;
		}
		
		RS.Remotes.SendMessage:FireAllClients(Info)
	end)
	
	--// Tips
	while wait() do
		for i = 1,#Messages do
			wait(math.random(240,360))
			
			local Info = {
				Text = (Messages[i]);
				Color = Color3.new(0.666667, 0.666667, 0.666667);
				Font = Enum.Font.SourceSansBold; 
				FontSize = Enum.FontSize.Size18;
			}
			RS.Remotes.SendMessage:FireAllClients(Info)	
		end
	end
end

return ChatMessage
