local Players = game:GetService("Players")

local player = Players.LocalPlayer
local Data = player:WaitForChild("Data")

local FirstTutorialFinished = Data:WaitForChild("FirstTutorialFinished")
local DisableTutorial = Data:WaitForChild("DisableTutorial")

local function DisableTutorialFunc()
    if DisableTutorial.Value == true then
        return true
    else
        return false
    end
end

local function FirstTutorialFinishedFunc()
    if FirstTutorialFinished.Value == true then
        return true
    else
        return false
    end
end

if DisableTutorialFunc() or FirstTutorialFinishedFunc() then return end

local TutorialGui = script.Parent
local TutorialFrame = TutorialGui:WaitForChild("TutorialFrame")
