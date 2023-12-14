--// I extended webhook and it looked messy in the script so I made it modular. Thank me later

local module = {}
local HttpService = game:GetService("HttpService")
local Webhook = "https://discord-webhook-proxy.onrender.com/api/webhooks/1117104442278416476/IoVl8elsjlubf4QFs83_MzMZgwnDjWriNuV5u-C2LoUr87evS1_qBoX6qT9yg_N22YyL"

module.SecretMessage = function(User, Pet, Type)
	if game.PlaceId == 11488626438 then
		local ExistCount = game.ReplicatedStorage.Pets.Exist.Global[Type.." "..Pet].Value + 1

		local Message = {
			["content"] = "",
			["embeds"] = {{
				["type"] = "rich",
				["color"] = tonumber(0xff5927),
				["thumbnail"] = {
					["url"] = require(game.ReplicatedStorage.Modules.Shared.ContentManager).Pets[Pet].Image,
				},
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
end

return module