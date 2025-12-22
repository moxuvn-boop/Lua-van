--[[ 
    SUPER RING PARTS V6 - SOUL LAND EDITION (ĐẤU LA ĐẠI LỤC)
    Author: Gemini
    
    Cập nhật:
    - Auto lấy toàn bộ khối (Global Fetch).
    - Bỏ qua khối lỗi (Safe Skip).
    - Chế độ 9 Hồn Hoàn (9 Concentric Rings).
    - Chỉnh tốc độ xoay.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- // CẤU HÌNH MẶC ĐỊNH \\ --
local Settings = {
    Radius = 30,             -- Bán kính vòng nhỏ nhất
    RingSpacing = 15,        -- Khoảng cách giữa các vòng hồn hoàn
    RotationSpeed = 2,       -- Tốc độ xoay mặc định
    Height = 5,              -- Độ cao của vòng
    Enabled = false,
    TotalRings = 9,          -- Số lượng vòng hồn hoàn (9 vòng như Đấu La)
    Attraction = 50          -- Lực hút
}

-- // UI LIBRARY MODERN \\ --
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SoulLandRingV6"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Màu đen tím huyền bí
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Bo góc & Viền
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(138, 43, 226) -- Màu tím Hồn Hoàn
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame

    -- Header
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "SOUL LAND RINGS V6"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame

    -- Container chứa nút
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 1, -50)
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 10)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Parent = Container

    -- Hàm tạo nút chức năng
    local function CreateButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = text
        btn.BackgroundColor3 = color
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = Container
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function() callback(btn) end)
        return btn
    end

    -- Hàm tạo thanh điều chỉnh (Label + 2 nút)
    local function CreateAdjuster(labelText, onIncrease, onDecrease)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundTransparency = 1
        frame.Parent = Container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local decBtn = Instance.new("TextButton")
        decBtn.Size = UDim2.new(0.25, 0, 1, 0)
        decBtn.Position = UDim2.new(0.45, 0, 0, 0)
        decBtn.Text = "-"
        decBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        decBtn.TextColor3 = Color3.new(1,1,1)
        decBtn.Parent = frame
        Instance.new("UICorner", decBtn).CornerRadius = UDim.new(0, 6)

        local incBtn = Instance.new("TextButton")
        incBtn.Size = UDim2.new(0.25, 0, 1, 0)
        incBtn.Position = UDim2.new(0.75, 0, 0, 0)
        incBtn.Text = "+"
        incBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        incBtn.TextColor3 = Color3.new(1,1,1)
        incBtn.Parent = frame
        Instance.new("UICorner", incBtn).CornerRadius = UDim.new(0, 6)

        decBtn.MouseButton1Click:Connect(function() onDecrease(label) end)
        incBtn.MouseButton1Click:Connect(function() onIncrease(label) end)
    end

    -- 1. Nút Bật/Tắt
    CreateButton("BẬT HỒN HOÀN (OFF)", Color3.fromRGB(180, 50, 50), function(btn)
        Settings.Enabled = not Settings.Enabled
        if Settings.Enabled then
            btn.Text = "BẬT HỒN HOÀN (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        else
            btn.Text = "BẬT HỒN HOÀN (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
    end)

    -- 2. Chỉnh Tốc Độ Xoay
    CreateAdjuster("Tốc Độ: " .. Settings.RotationSpeed, 
        function(lbl) -- Tăng
            Settings.RotationSpeed = Settings.RotationSpeed + 0.5
            lbl.Text = "Tốc Độ: " .. Settings.RotationSpeed
        end,
        function(lbl) -- Giảm
            Settings.RotationSpeed = Settings.RotationSpeed - 0.5
            lbl.Text = "Tốc Độ: " .. Settings.RotationSpeed
        end
    )

    -- 3. Chỉnh Bán Kính
    CreateAdjuster("Độ Rộng: " .. Settings.RingSpacing,
        function(lbl)
            Settings.RingSpacing = Settings.RingSpacing + 2
            lbl.Text = "Độ Rộng: " .. Settings.RingSpacing
        end,
        function(lbl)
            Settings.RingSpacing = math.max(5, Settings.RingSpacing - 2)
            lbl.Text = "Độ Rộng: " .. Settings.RingSpacing
        end
    )
    
    -- Status Label
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.BackgroundTransparency = 1
    Status.Text = "Số khối: 0"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.Font = Enum.Font.Code
    Status.Parent = Container

    -- Kéo thả UI
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Status
end

local StatusLabel = CreateUI()

-- // HỆ THỐNG NETLESS (GIÚP LẤY KHỐI) \\ --
task.spawn(function()
    while true do
        if Settings.Enabled then
            -- Tăng simulation radius để chiếm quyền điều khiển khối
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        end
        task.wait(0.5)
    end
end)

-- // LOGIC VẬT LÝ \\ --
RunService.Heartbeat:Connect(function()
    if not Settings.Enabled then return end

    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local CenterPos = RootPart.Position
    local AllParts = {}

    -- 1. LẤY TOÀN BỘ KHỐI (AUTO ALL)
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(Character) then
            -- Chỉ lấy những khối có kích thước hợp lý để tránh lỗi map
            if part.Size.Magnitude < 100 then 
                table.insert(AllParts, part)
            end
        end
    end

    StatusLabel.Text = "Đang điều khiển: " .. #AllParts .. " khối"

    -- 2. CHIA VÒNG HỒN HOÀN (SOUL LAND LOGIC)
    -- Chúng ta chia đều số part vào 9 vòng
    local TotalParts = #AllParts
    local Time = tick()
    
    for i, part in ipairs(AllParts) do
        -- Tính xem part này thuộc vòng số mấy (từ 0 đến 8)
        local RingIndex = (i % Settings.TotalRings) 
        
        -- Tính bán kính cho vòng này (Vòng càng lớn chỉ số càng xa)
        local CurrentRadius = Settings.Radius + (RingIndex * Settings.RingSpacing)
        
        -- Tính góc xoay
        -- Vòng chẵn xoay phải, Vòng lẻ xoay trái
        local Direction = (RingIndex % 2 == 0) and 1 or -1
        local Angle = (Time * Settings.RotationSpeed * Direction) + (i * 0.1) -- i*0.1 giúp các khối trong cùng 1 vòng rải đều ra
        
        -- Vị trí mục tiêu
        local TargetX = CenterPos.X + math.cos(Angle) * CurrentRadius
        local TargetZ = CenterPos.Z + math.sin(Angle) * CurrentRadius
        
        -- Hiệu ứng lên xuống nhẹ nhàng
        local TargetY = CenterPos.Y + math.sin(Time * 2 + RingIndex) * 2
        
        local TargetPos = Vector3.new(TargetX, TargetY, TargetZ)
        
        -- Áp dụng lực (Dùng pcall để tránh lỗi nếu khối bị khóa)
        pcall(function()
            part.CanCollide = false
            part.Velocity = (TargetPos - part.Position) * Settings.Attraction -- Kéo về vị trí
            part.RotVelocity = Vector3.new(math.random(-5,5), math.random(-5,5), math.random(-5,5)) -- Xoay bản thân nó cho đẹp
        end)
    end
end)

-- Thông báo
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Soul Land Rings",
    Text = "Đã tải xong! Mở menu để bật Hồn Hoàn.",
    Duration = 5
})

