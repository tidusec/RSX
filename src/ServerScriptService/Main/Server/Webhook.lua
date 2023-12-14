--// I extended webhook and it looked messy in the script so I made it modular. Thank me later

local module = {}
local HttpService = game:GetService("HttpService")
local Webhook = "https://hooks.hyra.io/api/webhooks/1124017240690413678/B71FlJVdKRIQYKIjfsaSt8eslJ4zvownXmywjVU2DwJDtbs3E4ktYkv_SUrkMT0J5vwR"
local TradeLogWebHook = "https://discord-webhook-proxy.onrender.com/api/webhooks/1147936921276923964/kOySdXCaui6oZiNDjA3LHL79xZFsS2IszDn6c6mkB6HdDjaToUv8lQDH1tP509Zhydu_"
module.SecretMessage = function(User, Pet, Type)
	local ExistCount = game.ReplicatedStorage.Pets.Exist.Global[Type.." "..Pet].Value + 1

	local Message = {
		["content"] = "",
		["embeds"] = {{
			["type"] = "rich",
			["color"] = tonumber(0xff5927),
			["title"] = User.Name.." hatched a Secret",
			["fields"] = {
				{
					["name"] = "Pet Name",
					["value"] = Pet,
					["inline"] = true
				},
				{
					["name"] = "Total Exist",
					["value"] = ExistCount,
					["inline"] = true
				},
				{
					["name"] = "Stars",
					["value"] = Type,
					["inline"] = true
				},
			}
		}}
	}

	local jsonMessage = HttpService:JSONEncode(Message)

	HttpService:PostAsync(Webhook, jsonMessage)
end

module.TradeLog = function(TradePlayer1: Player, TradedItem1: any, TradedPlayer2: Player, tradedItem2: any)
	local Message = {
		["content"] = "",
		["embeds"] = {
			{
				["type"] = "rich",
				["color"] = tonumber(0xff5927),
				["title"] = "Trade Logs",
				["fields"] = {
					{
						["name"] = TradePlayer1.Name,
						["value"] = "Has Traded " ..TradedItem1.Message .."\nHas Traded ".. TradedItem1.TradeTokens.. " Tokens",
					},
					{
						["name"] = TradedPlayer2.Name,
						["value"] = "Has Traded " ..tradedItem2.Message .."\nHas Traded ".. tradedItem2.TradeTokens.. " Tokens",
					},
				}
			}
		}
	}

	local jsonMessage = HttpService:JSONEncode(Message)

	task.spawn(function() 
		HttpService:PostAsync(TradeLogWebHook, jsonMessage)
	end)
end

return module