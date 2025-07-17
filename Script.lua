-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetCloneGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create big Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 400, 0, 300) -- Massive frame size
frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Center on screen
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

-- Create TextBox inside Frame
local textBox = Instance.new("TextBox")
textBox.Name = "PetNameBox"
textBox.Size = UDim2.new(1, -40, 0, 50) -- Leave room for button on right
textBox.Position = UDim2.new(0, 10, 0, 20)
textBox.PlaceholderText = "Enter pet/tool name..."
textBox.ClearTextOnFocus = false
textBox.TextColor3 = Color3.new(1,1,1)
textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
textBox.Parent = frame

-- Create ImageButton inside TextBox
local imageButton = Instance.new("ImageButton")
imageButton.Name = "SearchButton"
imageButton.Size = UDim2.new(0, 30, 0, 30)
imageButton.Position = UDim2.new(1, -35, 0, 10) -- right side inside textbox
imageButton.Image = "rbxassetid://174762951"
imageButton.BackgroundTransparency = 1
imageButton.Parent = textBox

-- Create RemoteEvent inside the ScreenGui
local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "ToolCloneRemote"
remoteEvent.Parent = screenGui

-- Create LocalScript inside the ScreenGui
local localScript = Instance.new("LocalScript")
localScript.Name = "PetCloneLocalScript"
localScript.Parent = screenGui

localScript.Source = [[
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local screenGui = script.Parent
local frame = screenGui:WaitForChild("MainFrame")
local textBox = frame:WaitForChild("PetNameBox")
local imageButton = textBox:WaitForChild("SearchButton")
local remoteEvent = screenGui:WaitForChild("ToolCloneRemote")

imageButton.MouseButton1Click:Connect(function()
    local petName = textBox.Text
    if petName and petName ~= "" then
        remoteEvent:FireServer(petName)
    else
        warn("Please enter a tool/pet name.")
    end
end)
]]

-- Create ServerScript inside the ScreenGui
local serverScript = Instance.new("Script")
serverScript.Name = "PetCloneServerScript"
serverScript.Parent = screenGui

serverScript.Source = [[
local remoteEvent = script.Parent:WaitForChild("ToolCloneRemote")

remoteEvent.OnServerEvent:Connect(function(player, toolName)
    if not toolName or toolName == "" then return end

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local backpack = otherPlayer:FindFirstChild("Backpack")
            if backpack then
                local tool = backpack:FindFirstChild(toolName)
                if tool then
                    local clone = tool:Clone()
                    clone.Parent = player.Backpack
                    print(player.Name .. " cloned tool '" .. toolName .. "' from " .. otherPlayer.Name)
                    return
                end
            end
        end
    end

    warn("❌ Tool '" .. toolName .. "' not found in other players' backpacks.")
end)
]]

print("Pet Clone GUI with scripts and RemoteEvent created!")
