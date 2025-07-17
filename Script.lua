-- Tool Spawner GUI with Full-Game Search

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolSpawnerGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 50)
frame.Position = UDim2.new(0.5, -150, 0.5, -25)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 5)
textBox.PlaceholderText = "Enter Tool Name"
textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Parent = frame

local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 40, 0, 40)
imageButton.Position = UDim2.new(0, 220, 0, 5)
imageButton.Image = "rbxassetid://174762951"
imageButton.Parent = frame

local remote = Instance.new("RemoteEvent")
remote.Name = "RequestToolSpawn"
remote.Parent = screenGui

-- LocalScript
local localScript = Instance.new("LocalScript")
localScript.Source = [[
local frame = script.Parent.Frame
local textBox = frame.TextBox
local button = frame.ImageButton
local remote = script.Parent:WaitForChild("RequestToolSpawn")

button.MouseButton1Click:Connect(function()
    local toolName = textBox.Text
    if toolName ~= "" then
        remote:FireServer(toolName)
    end
end)
]]
localScript.Parent = screenGui

-- ServerScript
local serverScript = Instance.new("Script")
serverScript.Source = [[
local remote = script.Parent:WaitForChild("RequestToolSpawn")

remote.OnServerEvent:Connect(function(player, toolName)
    local foundTool = nil

    for _, descendant in ipairs(game:GetDescendants()) do
        if descendant:IsA("Tool") and descendant.Name == toolName then
            foundTool = descendant
            break
        end
    end

    if foundTool then
        local clone = foundTool:Clone()
        clone.Parent = player.Backpack
        warn(player.Name .. " received a cloned tool: " .. toolName)
    else
        warn("❌ Tool not found anywhere in the game: " .. toolName)
    end
end)
]]
serverScript.Parent = screenGui
