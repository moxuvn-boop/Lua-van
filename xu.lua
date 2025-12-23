--[[ Super Ring Parts V4 - Phiên bản cải tiến đẹp kiểu RGB by Grok trợ giúp ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Sound
local function playSound(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. id
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end
playSound("2865227271")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperRingPartsRGB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- RGB Animation
spawn(function()
    while true do
        for i = 0, 360, 2 do
            UIGradient.Offset = Vector2.new(math.sin(math.rad(i)) * 0.5, math.cos(math.rad(i)) * 0.5)
            task.wait(0.03)
        end
    end
end)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.4
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "SUPER RING PARTS V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = MainFrame

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(1, 0, 0, 25)
Watermark.Position = UDim2.new(0, 0, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "Improved RGB Edition - Enjoy!"
Watermark.TextColor3 = Color3.fromRGB(200, 200, 255)
Watermark.Font = Enum.Font.Gotham
Watermark.TextSize = 14
Watermark.Parent = MainFrame

-- Biến trạng thái
local ringPartsEnabled = false
local radius = 200
local rotationSpeed = 3
local height = 150
local attractionStrength = 1000

-- Hàm tạo nút đẹp
local function createButton(name, pos, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(100, 255, 255)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 100)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
    end)

    return btn
end

local function createAdjustButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 24
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)

    btn.MouseButton1Click:Connect(function()
        callback()
        playSound("12221967")
    end)

    return btn
end

local function createLabel(text, pos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.8, 0, 0, 30)
    lbl.Position = pos
    lbl.Text = text
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 18
    lbl.Parent = MainFrame
    return lbl
end

-- Các control
local ToggleButton = createButton("Toggle", UDim2.new(0.1, 0, 0.15, 0), "Ring Parts: OFF")

local RadiusLabel = createLabel("Radius: " .. radius, UDim2.new(0.1, 0, 0.32, 0))
createAdjustButton("-", UDim2.new(0.1, 0, 0.4, 0), function() radius = math.max(100, radius - 100); RadiusLabel.Text = "Radius: " .. radius end)
createAdjustButton("+", UDim2.new(0.73, 0, 0.4, 0), function() radius = math.min(2000, radius + 100); RadiusLabel.Text = "Radius: " .. radius end)

local SpeedLabel = createLabel("Tốc độ xoay: " .. rotationSpeed, UDim2.new(0.1, 0, 0.55, 0))
createAdjustButton("-", UDim2.new(0.1, 0, 0.63, 0), function() rotationSpeed = math.max(0.5, rotationSpeed - 0.5); SpeedLabel.Text = "Tốc độ xoay: " .. rotationSpeed end)
createAdjustButton("+", UDim2.new(0.73, 0, 0.63, 0), function() rotationSpeed = math.min(10, rotationSpeed + 0.5); SpeedLabel.Text = "Tốc độ xoay: " .. rotationSpeed end)

local HeightLabel = createLabel("Độ cao vòng: " .. height, UDim2.new(0.1, 0, 0.78, 0))
createAdjustButton("-", UDim2.new(0.1, 0, 0.86, 0), function() height = math.max(50, height - 50); HeightLabel.Text = "Độ cao vòng: " .. height end)
createAdjustButton("+", UDim2.new(0.73, 0, 0.86, 0), function() height = math.min(500, height + 50); HeightLabel.Text = "Độ cao vòng: " .. height end)

-- Toggle logic
ToggleButton.MouseButton1Click:Connect(function()
    ringPartsEnabled = not ringPartsEnabled
    ToggleButton.Text = ringPartsEnabled and "Ring Parts: ON" or "Ring Parts: OFF"
    ToggleButton.BackgroundColor3 = ringPartsEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    playSound("12221967")
end)

-- Draggable
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Network Retain (giữ phần client control)
if not getgenv().Network then
    getgenv().Network = { BaseParts = {}, Velocity = Vector3.new(50, 50, 50) }
    Network.RetainPart = function(part)
        if part:IsA("BasePart") then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
        end
    end
    RunService.Heartbeat:Connect(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        for _, p in pairs(Network.BaseParts) do
            if p and p.Parent then p.Velocity = Network.Velocity end
        end
    end)
end

-- Ring logic
local parts = {}
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and not obj.Anchored and obj.Parent ~= LocalPlayer.Character then
        table.insert(parts, obj)
        Network.RetainPart(obj)
    end
end)

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local center = hrp.Position
    for _, part in pairs(parts) do
        if part and part.Parent and not part.Anchored then
            local pos = part.Position
            local flatDist = (Vector3.new(pos.X, center.Y, pos.Z) - center).Magnitude
            local angle = math.atan2(pos.Z - center.Z, pos.X - center.X)
            local newAngle = angle + math.rad(rotationSpeed)

            local targetX = center.X + math.cos(newAngle) * math.min(radius, flatDist)
            local targetZ = center.Z + math.sin(newAngle) * math.min(radius, flatDist)
            local targetY = center.Y + height * math.sin((pos.Y - center.Y) / height * math.pi)

            local target = Vector3.new(targetX, targetY, targetZ)
            local dir = (target - pos).Unit
            part.Velocity = dir * attractionStrength
        end
    end
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Super Ring Parts V4 RGB",
    Text = "Đã tải thành công! UI đẹp lung linh kiểu RGB nha <3",
    Duration = 6
})
