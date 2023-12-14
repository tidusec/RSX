--// Services

local RS = game:GetService("ReplicatedStorage")
local MPS = game:GetService("MarketplaceService")
local TS = game:GetService("TweenService")
local PS = game:GetService("PolicyService")

--// Main Variables

local Player = game.Players.LocalPlayer
local ShopModule = {}

local ShopUI = Player.PlayerGui:WaitForChild("Rank Simulator X").HUD.Frames.Shop

local Modules = RS.Modules
local RobuxShop = require(Modules.RobuxShop)
local Utilities = require(Modules.Client.Utilities)
local Content = require(Modules.Shared.ContentManager)

local BuyingWithRobux = true

local Remotes = RS.Remotes

local MainScroll = ShopUI.ScrollingFrame


--// Exclusive Egg

local Egg = MainScroll["Exclusive Egg"]


local CD = false

function ShopModule:Init()
	
	Utilities.ButtonAnimations.Create(ShopUI.Close)
	
	ShopUI.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.ButtonHandler.OnClick(ShopUI,UDim2.new(0,0,0,0))
	end)

	ShopUI.Parent.Gift.Close.TextButton.MouseButton1Click:Connect(function()
		Utilities.ButtonHandler.OnClick(ShopUI.Parent.Gift,UDim2.new(0,0,0,0))
	end)

	--// Limited Pets

	ShopUI.YourTokens.WhiteInside.Amount.Text = Utilities.Short.en(Player.Data.TradeTokens.Value).. " Tokens"

	Player.Data.TradeTokens.Changed:Connect(function()
		ShopUI.YourTokens.WhiteInside.Amount.Text = Utilities.Short.en(Player.Data.TradeTokens.Value).. " Tokens"
	end)

	for _,Frame in MainScroll.LimitedPets:GetChildren() do
		local Buy = Frame.Buy
		local ProductID = tonumber(Frame.Name)

		Buy.TextButton.MouseButton1Click:Connect(function()
			if BuyingWithRobux then
				MPS:PromptProductPurchase(Player, ProductID)
			else
				Remotes.TokenProduct:FireServer(ProductID)
			end
		end)

		Utilities.ButtonAnimations.Create(Buy)
	end


	Utilities.ButtonAnimations.Create(Egg.Buy1, 1.04, 0.075)
	Utilities.ButtonAnimations.Create(Egg.Buy2, 1.04, 0.075)

	local success, result = pcall(function()
		return PS:GetPolicyInfoForPlayerAsync(Player)
	end)

	local CanBuy = true

	if not success then
		warn("PolicyService error: " .. result)
	elseif result.ArePaidRandomItemsRestricted == true then
		print("Paid Random Items is restricted in your region.")
		CanBuy = false
	end


	Egg.Buy1.TextButton.MouseButton1Click:Connect(function()
		if not CanBuy then Utilities.Popup.Layered("Buying this is restricted in your region.", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error) return end
		if not CD then CD = true
			if BuyingWithRobux then
				MPS:PromptProductPurchase(Player,1581245529)
			else 
				Remotes.TokenProduct:FireServer(1581245529)
			end
			ShopUI.Visible = false
			ShopUI.Parent.Parent.Blur.BackgroundTransparency = 1
			task.wait(1)
			CD = false
		end
	end)

	Egg.Buy2.TextButton.MouseButton1Click:Connect(function()
		if not CanBuy then Utilities.Popup.Layered("Buying this is restricted in your region.", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error) return end
		if not CD then CD = true
			if BuyingWithRobux then
				MPS:PromptProductPurchase(Player,1581246654)
			else 
				Remotes.TokenProduct:FireServer(1581246654)
			end
			ShopUI.Visible = false
			ShopUI.Parent.Parent.Blur.BackgroundTransparency = 1
			task.wait(1)
			CD = false
		end
	end)

	--// Boosts

	local BoostRemote = Remotes.RedeemBoost

	for _,BoostFrame in MainScroll.Boosts.Inside:GetChildren() do
		if BoostFrame:IsA("Frame") then
			if BoostFrame.Name ~= "1539646725" then -- boostpack 
				local Boost = Player.Data[RobuxShop.Products[tonumber(BoostFrame.Name)].Name.."Boost"]
				local AvailableBoosts = Player.Data[RobuxShop.Products[tonumber(BoostFrame.Name)].Name.."Available"]

				if Boost.Value > 0 then
					BoostFrame.Timer.Text = Utilities.Short.time(Boost.Value)
				else
					BoostFrame.Timer.Text = "None!"
				end

				BoostFrame.Desc.Text = "Lasts "..(Content.Perks[5].Prices(Player.Data.Perk5.Value).Reward + 30).." minutes"

				Player.Data.Perk5.Changed:Connect(function()
					BoostFrame.Desc.Text = "Lasts "..(Content.Perks[5].Prices(Player.Data.Perk5.Value).Reward + 30).." minutes"
				end)

				Boost.Changed:Connect(function()
					if Boost.Value > 0 then
						BoostFrame.Timer.Text = Utilities.Short.time(Boost.Value)
					else
						BoostFrame.Timer.Text = "None!"
					end
				end)

				BoostFrame.Buttons.Use.TextLabel.Text = "Use ("..AvailableBoosts.Value..")"

				AvailableBoosts.Changed:Connect(function()
					BoostFrame.Buttons.Use.TextLabel.Text = "Use ("..AvailableBoosts.Value..")"
				end)
			end

			--// Boost Buttons

			for _,Button in BoostFrame.Buttons:GetChildren() do
				if Button:IsA("Frame") then
					Button.TextButton.MouseButton1Click:Connect(function()
						if Button.Name == "Buy" then
							if BuyingWithRobux then
								MPS:PromptProductPurchase(Player,tonumber(BoostFrame.Name))
							else 
								Remotes.TokenProduct:FireServer(tonumber(BoostFrame.Name))
							end
						elseif Button.Name == "Use" then
							BoostRemote:FireServer(RobuxShop.Products[tonumber(BoostFrame.Name)].Name)
						end
					end)

					Utilities.ButtonAnimations.Create(Button)
				end
			end
		end
	end

	--// Gamepasses Variables

	local GPButtonSize = {}
	local BuyButtonSize = {}

	--// Gamepasses Main

	task.spawn(function()
		for _,Layout in MainScroll.Gamepasses:GetChildren() do
			if Layout:IsA("Frame") then
				for _,Button in Layout:GetChildren() do
					if Button:IsA("Frame") then
						Button.Screen.Buy.Green.TextButton.MouseButton1Click:Connect(function()
							if Player.Data[RobuxShop.Gamepasses[tonumber(Button.Name)].Name].Value == false then
								if BuyingWithRobux then
									MPS:PromptGamePassPurchase(Player,tonumber(Button.Name))
								else
									Remotes.TokenGamepass:FireServer(tonumber(Button.Name))
								end
							end
						end)

						Button.Screen.Gift.Green.TextButton.MouseButton1Click:Connect(function()
							Utilities.ButtonHandler.OnClick(ShopUI.Parent.Gift,UDim2.new(0.27,0,0.6,0))
							ShopUI.Parent.Gift.Gamepass.Value = RobuxShop.Gamepasses[tonumber(Button.Name)].Name
						end)

						--// Gui Effects

						GPButtonSize[Button.Name] = Button.Size

						wait(1)
						if Player.Device.Value == "PC" then
							Button.MouseEnter:Connect(function()
								Button:TweenSize(UDim2.new(GPButtonSize[Button.Name].X.Scale * 1.1,0,0.925,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.075)	

								Button.Screen.Visible = true

								if Player.Data[RobuxShop.Gamepasses[tonumber(Button.Name)].Name].Value == false then
									Button.Screen.Buy.Green.TextLabel.Text = "Buy"
								else
									Button.Screen.Buy.Green.TextLabel.Text = "Owned"
								end
							end)

							Button.MouseLeave:Connect(function()
								wait(0.075)
								Button:TweenSize(GPButtonSize[Button.Name],Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.075)					
								Button.Screen.Visible = false
							end)
						else
							Button.TextButton.MouseButton1Click:Connect(function()
								Button.Screen.Visible = not Button.Screen.Visible

								if Player.Data[RobuxShop.Gamepasses[tonumber(Button.Name)].Name].Value == false then
									Button.Screen.Buy.Green.TextLabel.Text = "Buy"
								else
									Button.Screen.Buy.Green.TextLabel.Text = "Owned"
								end
							end)
						end

						for _,v in Button.Screen:GetChildren() do
							if v:IsA("Frame") then
								Utilities.ButtonAnimations.Create(v)
							end
						end
					end
				end
			end
		end
	end)

	task.spawn(function()
		for _,Layout in MainScroll["Trade Tokens"]:GetChildren() do
			if Layout:IsA("Frame") then
				for _,Button in Layout:GetChildren() do
					if Button:IsA("Frame") then
						Button.Screen.Buy.Green.TextButton.MouseButton1Click:Connect(function()
							if BuyingWithRobux then
								MPS:PromptProductPurchase(Player,tonumber(Button.Name))
							else
								Remotes.TokenProduct:FireServer(tonumber(Button.Name))
							end
						end)

						--// Gui Effects

						GPButtonSize[Button.Name] = Button.Size

						task.wait(1)
						if Player.Device.Value == "PC" then
							Button.MouseEnter:Connect(function()
								Button:TweenSize(UDim2.new(GPButtonSize[Button.Name].X.Scale * 1.1,0,0.925,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.075)	

								Button.Screen.Visible = true
							end)

							Button.MouseLeave:Connect(function()
								task.wait(0.075)
								Button:TweenSize(GPButtonSize[Button.Name],Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.075)					
								Button.Screen.Visible = false
							end)
						else
							Button.TextButton.MouseButton1Click:Connect(function()
								Button.Screen.Visible = not Button.Screen.Visible
							end)
						end

						for _,v in Button.Screen:GetChildren() do
							if v:IsA("Frame") then
								Utilities.ButtonAnimations.Create(v)
							end
						end
					end
				end
			end
		end
	end)

	ShopUI.Switch.MouseButton1Click:Connect(function()
		if BuyingWithRobux then
			for _, TextLabel in MainScroll:GetDescendants() do
				if TextLabel:IsA("TextLabel") and string.find(TextLabel.Text, "R$", 1, true) then
					TextLabel.TextColor3 = Color3.fromRGB(255, 179, 0)
					TextLabel.Text = string.gsub(TextLabel.Text, "R%$", "TK")
				end
			end
		else
			for _, TextLabel in MainScroll:GetDescendants() do
				if TextLabel:IsA("TextLabel") and string.find(TextLabel.Text, "TK") then
					TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
					TextLabel.Text = string.gsub(TextLabel.Text, "TK", "R$")
				end
			end
		end
		BuyingWithRobux = not BuyingWithRobux
	end)

	MainScroll.TokensText.TextButton.MouseButton1Click:Connect(function()
		Utilities.ButtonHandler.OnClick(ShopUI.Parent.TradeTokens, UDim2.new(0.38, 0,0.45, 0))
	end)

	--// Codes

	local CodesFrame = MainScroll.Codes.Inside
	local CodesFrame2 = MainScroll.Codes2.Inside
	local Redeem = Remotes.RedeemCode
	

	CodesFrame.RedeemButton.TextButton.MouseButton1Click:Connect(function()
		if CodesFrame.TextBox.TextBox.Text == "DFHDH-92JA-HEK8K20-LL9284-RSX" then
			Utilities.Popup.Layered("Invalid code type!", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error) return
		end
		local Succes,Message = Redeem:InvokeServer(CodesFrame.TextBox.TextBox.Text)

		if Succes ~= "Succes" then
			Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
		else
			Utilities.Popup.Layered(Message, Color3.fromRGB(85, 255, 0), 1.5, RS.Audio.Completed)
		end
	end)
	
	CodesFrame2.RedeemButton.TextButton.MouseButton1Click:Connect(function()
		if CodesFrame2.TextBox.TextBox.Text ~= "DFHDH-92JA-HEK8K20-LL9284-RSX" then
			Utilities.Popup.Layered("Invalid code type!", Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error) return
		end
		local Succes,Message = Redeem:InvokeServer(CodesFrame2.TextBox.TextBox.Text)

		if Succes ~= "Succes" then
			Utilities.Popup.Layered(Message, Color3.fromRGB(244, 46, 49), 1.5, RS.Audio.Error)
		else
			Utilities.Popup.Layered(Message, Color3.fromRGB(85, 255, 0), 1.5, RS.Audio.Completed)
		end
	end)
	
	if Player.Data.DiscordReward.Value == true then
		CodesFrame2.Visible = false
	else
		CodesFrame2.Visible = true
	end 
	
	Player.Data.DiscordReward.Changed:Connect(function()
		if Player.Data.DiscordReward.Value == true then
			CodesFrame2.Visible = false
		else
			CodesFrame2.Visible = true
		end 
	end)

	Utilities.ButtonAnimations.Create(CodesFrame2.RedeemButton)
	Utilities.ButtonAnimations.Create(CodesFrame.RedeemButton)

	--// Other

	local function TweenScroll(TargetPosition)
		TS:Create(MainScroll, TweenInfo.new(0.2,Enum.EasingStyle.Linear,Enum.EasingDirection.In), {CanvasPosition = TargetPosition}):Play()
	end

	ShopUI.ScrollButtons.Boosts.TextButton.MouseButton1Click:Connect(function()
		TweenScroll(Vector2.new(0,850))
	end)

	ShopUI.ScrollButtons.Codes.TextButton.MouseButton1Click:Connect(function()
		TweenScroll(Vector2.new(0,2000))
	end)
	

	ShopUI.ScrollButtons.Gamepasses.TextButton.MouseButton1Click:Connect(function()
		TweenScroll(Vector2.new(0,400))
	end)

	ShopUI.ScrollButtons.LimitedPets.TextButton.MouseButton1Click:Connect(function()
		TweenScroll(Vector2.new(0,0))
	end)
end

return ShopModule