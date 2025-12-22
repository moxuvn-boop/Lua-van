--[[ 
    SOUL LAND SYSTEM V7 - STATUS HUD EDITION
    Author: Gemini
    Style: RPG System Status (Hệ thống trạng thái)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- // SETTINGS (CẤU HÌNH) \\ --
local Settings = {
    Enabled = false,
    Radius = 25,             -- Bán kính cơ bản
    RingSpacing = 12,        -- Khoảng cách giữa các vòng
    RotationSpeed = 2,       -- Tốc độ xoay
    TotalRings = 9,          -- 9 Hồn hoàn
    Attraction = 60,         -- Lực hút
    UI_Color = Color3.fromRGB(0, 255, 255), -- Màu chủ đạo (Cyan Neon)
    UI_Dark = Color3.fromRGB(10, 15, 20)    -- Màu nền tối
}

-- // UI LIBRARY: SYSTEM STYLE \\ --
local function CreateSystemUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SoulLandSystemHUD"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- MAIN BOARD (BẢNG TRẠNG THÁI)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "SystemBoard"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Settings.UI_Dark
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- VIỀN NEON
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Settings.UI_Color
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5
    UIStroke.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    -- DECORATION LINES (TRANG TRÍ)
    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BackgroundColor3 = Settings.UI_Color
    TopLine.BorderSizePixel = 0
    TopLine.Parent = MainFrame

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -20, 0, 40)
    Header.Position = UDim2.new(0, 10, 0, 5)
    Header.BackgroundTransparency = 1
    Header.Text = "HỆ THỐNG HỒN HOÀN"
    Header.TextColor3 = Settings.UI_Color
    Header.Font = Enum.Font.Michroma -- Font kiểu máy móc/viễn tưởng
    Header.TextSize = 18
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = MainFrame

    -- MINIMIZE BUTTON (NÚT THU NHỎ)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -35, 0, 5)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "[-]"
    MinBtn.TextColor3 = Settings.UI_Color
    MinBtn.Font = Enum.Font.Code
    MinBtn.TextSize = 18
    MinBtn.Parent = MainFrame

    -- CONTENT CONTAINER
    local Container = Instance.new("Frame")
    Container.Name = "Content"
    Container.Size = UDim2.new(1, -20, 1, -50)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = Container

    -- -- COMPONENTS -- --

    -- 1. STATUS DISPLAY (HIỂN THỊ THÔNG SỐ)
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(1, 0, 0, 60)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    StatusFrame.BackgroundTransparency = 0.5
    StatusFrame.Parent = Container
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 4)
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -10, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "TRẠNG THÁI: CHỜ\nSỐ KHỐI: 0"
    StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusText.Font = Enum.Font.Code
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusFrame

    -- 2. MAIN TOGGLE (NÚT KÍCH HOẠT)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = "KÍCH HOẠT HỆ THỐNG"
    ToggleBtn.TextColor3 = Settings.UI_Color
    ToggleBtn.Font = Enum.Font.Michroma
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = Container
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Settings.UI_Color
    ToggleStroke.Thickness = 1
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleStroke.Parent = ToggleBtn

    ToggleBtn.MouseButton1Click:Connect(function()
        Settings.Enabled = not Settings.Enabled
        if Settings.Enabled then
            ToggleBtn.Text = ">> HỆ THỐNG ĐANG CHẠY <<"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
            ToggleBtn.TextColor3 = Color3.new(1,1,1)
        else
            ToggleBtn.Text = "KÍCH HOẠT HỆ THỐNG"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleBtn.TextColor3 = Settings.UI_Color
        end
    end)

    -- 3. SLIDERS FUNCTION (HÀM TẠO THANH KÉO)
    local function CreateSlider(name, default, min, max, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 45)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = name .. ": " .. default
        Label.TextColor3 = Color3.fromRGB(180, 180, 180)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local SlideBar = Instance.new("TextButton") -- Dùng button để click
        SlideBar.Size = UDim2.new(1, 0, 0, 6)
        SlideBar.Position = UDim2.new(0, 0, 0, 25)
        SlideBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SlideBar.Text = ""
        SlideBar.AutoButtonColor = false
        SlideBar.Parent = Frame
        Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Settings.UI_Color
        Fill.BorderSizePixel = 0
        Fill.Parent = SlideBar
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        -- Logic kéo thả
        local draggingSlider = false
        SlideBar.MouseButton1Down:Connect(function() draggingSlider = true end)
        UserInputService.InputEnded:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end 
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = SlideBar.AbsolutePosition.X
                local barSize = SlideBar.AbsoluteSize.X
                local relPos = math.clamp((mousePos - barPos) / barSize, 0, 1)
                
                Fill.Size = UDim2.new(relPos, 0, 1, 0)
                local value = math.floor(min + (max - min) * relPos)
                Label.Text = name .. ": " .. value
                callback(value)
            end
        end)
    end

    -- TẠO CÁC SLIDER
    CreateSlider("TỐC ĐỘ XOAY", Settings.RotationSpeed, 0, 20, function(val) Settings.RotationSpeed = val end)
    CreateSlider("KHOẢNG CÁCH VÒNG", Settings.RingSpacing, 5, 50, function(val) Settings.RingSpacing = val end)
    
    -- -- DRAGGABLE LOGIC (KÉO THẢ MENU) -- --
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- -- MINIMIZE LOGIC (THU NHỎ) -- --
    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            -- Thu nhỏ lại
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 45)}):Play()
            Container.Visible = false
            MinBtn.Text = "[+]"
            Header.Text = "HỆ THỐNG [ĐANG ẨN]"
        else
            -- Mở ra
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 400)}):Play()
            Container.Visible = true
            MinBtn.Text = "[-]"
            Header.Text = "HỆ THỐNG HỒN HOÀN"
        end
    end)

    return StatusText
end

local StatusLabel = CreateSystemUI()

-- // NETLESS BYPASS (CHIẾM QUYỀN KHỐI) \\ --
task.spawn(function()
    while true do
        if Settings.Enabled then
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        end
        task.wait(0.1)
    end
end)

-- // MAIN PHYSICS LOOP (VÒNG LẶP VẬT LÝ) \\ --
RunService.Heartbeat:Connect(function()
    if not Settings.Enabled then 
        StatusLabel.Text = "TRẠNG THÁI: TẮT\nSỐ KHỐI: 0"
        return 
    end

    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local CenterPos = RootPart.Position
    local AllParts = {}

    -- AUTO SCAN: Lấy tất cả khối không bị neo
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(Character) then
            -- Kiểm tra khối hợp lệ (không quá to, không phải Terrain)
            if part.Size.Magnitude < 100 then
                table.insert(AllParts, part)
            end
        end
    end

    StatusLabel.Text = "TRẠNG THÁI: HOẠT ĐỘNG\nSỐ KHỐI ĐIỀU KHIỂN: " .. #AllParts

    local Time = tick()
    
    -- SOUL LAND ALGORITHM (THUẬT TOÁN HỒN HOÀN)
    for i, part in ipairs(AllParts) do
        -- Chia đều vào 9 vòng
        local RingIndex = (i % Settings.TotalRings)
        
        -- Tính bán kính (Vòng 0 ở trong cùng, Vòng 8 ở ngoài cùng)
        local CurrentRadius = Settings.Radius + (RingIndex * Settings.RingSpacing)
        
        -- Hướng xoay: Chẵn phải, Lẻ trái
        local Direction = (RingIndex % 2 == 0) and 1 or -1
        
        -- Góc xoay: Kết hợp thời gian và chỉ số part để rải đều
        local Angle = (Time * Settings.RotationSpeed * Direction) + (i * (math.pi * 2 / (#AllParts / Settings.TotalRings)))
        
        local TargetX = CenterPos.X + math.cos(Angle) * CurrentRadius
        local TargetZ = CenterPos.Z + math.sin(Angle) * CurrentRadius
        
        -- Tạo hiệu ứng sóng (Wave) lên xuống
        local TargetY = CenterPos.Y + math.sin(Time * 3 + RingIndex) * 2
        
        local TargetPos = Vector3.new(TargetX, TargetY, TargetZ)
        
        -- Dùng pcall để bỏ qua khối lỗi
        pcall(function()
            part.CanCollide = false
            part.Velocity = (TargetPos - part.Position) * Settings.Attraction
            -- Hiệu ứng xoay khối tại chỗ
            part.RotVelocity = Vector3.new(0, 5, 0)
            part.Transparency = 0 -- Đảm bảo khối nhìn thấy được
        end)
    end
end)

-- NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Hệ Thống Đã Tải",
    Text = "Kích hoạt Menu bên phải màn hình!",
    Icon = "",
    Duration = 5
})

