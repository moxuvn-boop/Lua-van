--[[ 
    SUPER RING PARTS V5 - OPTIMIZED & MODERN UI
    Author: Gemini (Refactored)
    Original Logic: Lukas
    
    Cải tiến:
    - Giảm lag bằng cách giới hạn số lượng part (Part Cap).
    - Tối ưu hóa vòng lặp Heartbeat.
    - Giao diện Dark Mode hiện đại, mượt mà.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // SETTINGS \\ --
local Settings = {
    Radius = 50,
    Height = 10,
    RotationSpeed = 2,
    AttractionStrength = 1000,
    MaxParts = 200, -- GIỚI HẠN SỐ KHỐI ĐỂ KHÔNG BỊ LAG
    Enabled = false
}

local Parts = {}
local NetworkVelocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)

-- // UI LIBRARY SIMPLE \\ --
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SuperRingV5"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 65)
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    -- Fix bottom corners of header
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Text = "Ring Parts V5"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Minimize Button
    local MinButton = Instance.new("TextButton")
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -35, 0, 5)
    MinButton.Text = "-"
    MinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinButton.Font = Enum.Font.GothamBold
    MinButton.TextSize = 18
    MinButton.AutoButtonColor = false
    MinButton.Parent = Header

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinButton

    -- Container for Controls
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 1, -40)
    Container.Position = UDim2.new(0, 0, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Padding for list
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.Parent = Container

    -- Helper function to create buttons
    local function CreateButton(text, callback)
        local ButtonObj = Instance.new("TextButton")
        ButtonObj.Size = UDim2.new(0.9, 0, 0, 40)
        ButtonObj.BackgroundColor3 = Color3.fromRGB(50, 50, 180)
        ButtonObj.Text = text
        ButtonObj.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonObj.Font = Enum.Font.GothamSemibold
        ButtonObj.TextSize = 14
        ButtonObj.Parent = Container
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = ButtonObj

        ButtonObj.MouseButton1Click:Connect(function()
            callback(ButtonObj)
        end)
        return ButtonObj
    end

    -- Helper for Labels
    local function CreateStatusLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.9, 0, 0, 30)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(180, 180, 180)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = Container
        return Label
    end

    -- TOGGLE BUTTON
    local ToggleBtn = CreateButton("Enable Ring", function(btn)
        Settings.Enabled = not Settings.Enabled
        if Settings.Enabled then
            btn.Text = "Disable Ring"
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Red
        else
            btn.Text = "Enable Ring"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 180) -- Blue
        end
    end)

    -- Info Labels
    local RadiusLabel = CreateStatusLabel("Radius: " .. Settings.Radius)
    
    -- Radius Control Row
    local ControlRow = Instance.new("Frame")
    ControlRow.Size = UDim2.new(0.9, 0, 0, 40)
    ControlRow.BackgroundTransparency = 1
    ControlRow.Parent = Container
    
    local DecBtn = Instance.new("TextButton")
    DecBtn.Size = UDim2.new(0.45, -5, 1, 0)
    DecBtn.Text = "Radius (-)"
    DecBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    DecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecBtn.Font = Enum.Font.Gotham
    DecBtn.TextSize = 12
    DecBtn.Parent = ControlRow
    Instance.new("UICorner", DecBtn).CornerRadius = UDim.new(0, 8)

    local IncBtn = Instance.new("TextButton")
    IncBtn.Size = UDim2.new(0.45, -5, 1, 0)
    IncBtn.Position = UDim2.new(0.55, 5, 0, 0)
    IncBtn.Text = "Radius (+)"
    IncBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    IncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncBtn.Font = Enum.Font.Gotham
    IncBtn.TextSize = 12
    IncBtn.Parent = ControlRow
    Instance.new("UICorner", IncBtn).CornerRadius = UDim.new(0, 8)

    DecBtn.MouseButton1Click:Connect(function()
        Settings.Radius = math.max(5, Settings.Radius - 5)
        RadiusLabel.Text = "Radius: " .. Settings.Radius
    end)

    IncBtn.MouseButton1Click:Connect(function()
        Settings.Radius = math.min(500, Settings.Radius + 5)
        RadiusLabel.Text = "Radius: " .. Settings.Radius
    end)

    -- Status
    local CountLabel = CreateStatusLabel("Parts Controlled: 0")

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Minimize Logic
    local minimized = false
    MinButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            MainFrame:TweenSize(UDim2.new(0, 260, 0, 40), "Out", "Quad", 0.3, true)
            MinButton.Text = "+"
        else
            MainFrame:TweenSize(UDim2.new(0, 260, 0, 320), "Out", "Quad", 0.3, true)
            MinButton.Text = "-"
        end
    end)

    return CountLabel
end

local PartCountLabel = CreateUI()

-- // NETWORK OWNERSHIP & OPTIMIZATION \\ --

-- Function to handle network simulation radius
-- Only running this occasionally to save resources
task.spawn(function()
    while true do
        if Settings.Enabled then
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        end
        task.wait(1) -- No need to spam this every frame
    end
end)

-- Function to check if a part is valid
local function IsValidPart(part)
    return part:IsA("BasePart") 
        and not part.Anchored 
        and part:IsDescendantOf(Workspace) 
        and not part:IsDescendantOf(LocalPlayer.Character)
        and part.Size.Magnitude < 50 -- Don't try to move giant parts
end

-- // PHYSICS LOOP \\ --
RunService.Heartbeat:Connect(function()
    if not Settings.Enabled then return end
    
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not RootPart then return end
    
    local CenterPos = RootPart.Position
    local CollectedParts = {}
    
    -- Optimized Part Collection:
    -- Instead of looping through ALL workspace descendants every frame (which lags),
    -- we check nearby parts or maintain a list.
    -- For simplicity and reliability in this fix, we use GetPartBoundsInBox or similar, 
    -- but standard looping with a distance check and cap is safer for exploits.
    
    local count = 0
    for _, part in ipairs(Workspace:GetDescendants()) do
        if count >= Settings.MaxParts then break end
        
        if IsValidPart(part) then
            local dist = (part.Position - CenterPos).Magnitude
            if dist < (Settings.Radius + 100) then -- Only grab parts relatively close
                table.insert(CollectedParts, part)
                count = count + 1
                
                -- Optimization: Only set properties if they aren't already set
                if part.CanCollide then part.CanCollide = false end
            end
        end
    end
    
    PartCountLabel.Text = "Parts Controlled: " .. #CollectedParts

    -- Physics Calculation
    -- Pre-calculate time based rotation
    local t = tick()
    local rotOffset = t * Settings.RotationSpeed
    
    for i, part in ipairs(CollectedParts) do
        -- Distribute parts evenly around the circle or just spin them
        -- Using index 'i' to offset the angle makes a nice ring shape
        local angle = rotOffset + (i * (math.pi * 2 / #CollectedParts))
        
        local targetX = CenterPos.X + math.cos(angle) * Settings.Radius
        local targetZ = CenterPos.Z + math.sin(angle) * Settings.Radius
        
        -- Sine wave height effect
        local targetY = CenterPos.Y + math.sin(t * 3 + i) * (Settings.Height / 2)
        
        local targetPos = Vector3.new(targetX, targetY, targetZ)
        
        -- Apply Velocity
        part.Velocity = (targetPos - part.Position) * 10 -- Response speed
        part.RotVelocity = Vector3.new(0, 5, 0) -- Spin the part itself
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Super Ring V5",
    Text = "Script Loaded! Toggle GUI to start.",
    Duration = 5
})

