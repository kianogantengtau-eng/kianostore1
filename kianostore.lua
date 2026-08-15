--------------------------------------------------------------------------------
-- 1. DAFTAR 3 KEY (UBAH TEKS KEY SESUAI KEINGINANMU DI SINI)
--------------------------------------------------------------------------------
local KEYS_LIST = {
    ["KIANO"] = true,
    ["KIANOGANTENG"] = true,
    ["KIANOGACOR"] = true
}

--------------------------------------------------------------------------------
-- 2. SETUP SERVICES
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

if CoreGui:FindFirstChild("KianoKeyGui") then
    CoreGui.KianoKeyGui:Destroy()
end

--------------------------------------------------------------------------------
-- 3. INTERFACE UI INPUT KEY
--------------------------------------------------------------------------------
local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "KianoKeyGui"
KeyScreenGui.ResetOnSpawn = false
KeyScreenGui.Parent = CoreGui

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 320, 0, 210)
KeyFrame.Position = UDim2.new(0.5, -160, 0.4, -105)
KeyFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = KeyScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔑 KianoStore - Verification System"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 13
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 50)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyInput.BorderSizePixel = 0
KeyInput.PlaceholderText = "Masukkan Key Kamu..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 12
KeyInput.Parent = KeyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 36)
SubmitBtn.Position = UDim2.new(0, 20, 0, 100)
SubmitBtn.Text = "VERIFIKASI KEY"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 12
SubmitBtn.Parent = KeyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = SubmitBtn

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, -40, 0, 40)
KeyStatus.Position = UDim2.new(0, 20, 0, 145)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = "Status: Menunggu Key..."
KeyStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyStatus.Font = Enum.Font.Gotham
KeyStatus.TextSize = 11
KeyStatus.Parent = KeyFrame

--------------------------------------------------------------------------------
-- 4. LOGIKA UTAMA MASAK MS & UNDERGROUND
--------------------------------------------------------------------------------
local function LoadMainScript()
    if CoreGui:FindFirstChild("KianoStoreGui") then
        CoreGui.KianoStoreGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KianoStoreGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local UNDERGROUND_DEPTH = 10 
    local IsUnderground = false
    local platformPart = nil
    local undergroundConnection = nil
    local noclipConnection = nil

    local function GetTargetPivot()
        local character = LocalPlayer.Character
        if not character then return nil end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart then
            return humanoid.SeatPart.Parent 
        end
        return character
    end

    local function EnableUnderground()
        local target = GetTargetPivot()
        if not target then return end

        if not platformPart then
            platformPart = Instance.new("Part")
            platformPart.Name = "UndergroundPlatform"
            platformPart.Size = Vector3.new(30, 1, 30)
            platformPart.Anchored = true
            platformPart.CanCollide = true
            platformPart.Transparency = 0.5
            platformPart.Material = Enum.Material.SmoothPlastic
            platformPart.Color = Color3.fromRGB(0, 170, 255)
            platformPart.Parent = Workspace
        end

        local currentCFrame = target:GetPivot()
        local newCFrame = currentCFrame - Vector3.new(0, UNDERGROUND_DEPTH, 0)
        target:PivotTo(newCFrame)

        noclipConnection = RunService.Stepped:Connect(function()
            local currentTarget = GetTargetPivot()
            if currentTarget then
                for _, part in ipairs(currentTarget:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        undergroundConnection = RunService.Heartbeat:Connect(function()
            local currentTarget = GetTargetPivot()
            if currentTarget and platformPart then
                local rootPos = currentTarget:GetPivot().Position
                platformPart.CFrame = CFrame.new(rootPos.X, rootPos.Y - 3.5, rootPos.Z)
            end
        end)
    end

    local function DisableUnderground()
        if undergroundConnection then undergroundConnection:Disconnect(); undergroundConnection = nil end
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if platformPart then platformPart:Destroy(); platformPart = nil end

        local target = GetTargetPivot()
        if target then
            local currentCFrame = target:GetPivot()
            local newCFrame = currentCFrame + Vector3.new(0, UNDERGROUND_DEPTH + 2, 0)
            target:PivotTo(newCFrame)
            for _, part in ipairs(target:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.zero
                    part.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -150, 0.4, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 35)
    TitleLabel.Position = UDim2.new(0, 0, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "🧪 KianoStore - Auto MS ⚙️"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.Parent = MainFrame

    local StatusBadge = Instance.new("Frame")
    StatusBadge.Size = UDim2.new(1, -24, 0, 30)
    StatusBadge.Position = UDim2.new(0, 12, 0, 40)
    StatusBadge.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    StatusBadge.BorderSizePixel = 0
    StatusBadge.ClipsDescendants = true
    StatusBadge.Parent = MainFrame

    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(0, 6)
    BadgeCorner.Parent = StatusBadge

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.BackgroundTransparency = 0.3
    ProgressBar.Parent = StatusBadge

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Idle 💤"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 11
    StatusLabel.ZIndex = 2
    StatusLabel.Parent = StatusBadge

    local UndergroundBtn = Instance.new("TextButton")
    UndergroundBtn.Size = UDim2.new(1, -24, 0, 36)
    UndergroundBtn.Position = UDim2.new(0, 12, 0, 78)
    UndergroundBtn.Text = "🌐 BAWAH TANAH (-10 STUD)"
    UndergroundBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
    UndergroundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    UndergroundBtn.Font = Enum.Font.GothamBold
    UndergroundBtn.TextSize = 11
    UndergroundBtn.Parent = MainFrame

    local UBtnCorner = Instance.new("UICorner")
    UBtnCorner.CornerRadius = UDim.new(0, 6)
    UBtnCorner.Parent = UndergroundBtn

    UndergroundBtn.MouseButton1Click:Connect(function()
        IsUnderground = not IsUnderground
        if IsUnderground then
            UndergroundBtn.Text = "⬆️ KEMBALI KE PERMUKAAN"
            UndergroundBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            EnableUnderground()
        else
            UndergroundBtn.Text = "🌐 BAWAH TANAH (-10 STUD)"
            UndergroundBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 200)
            DisableUnderground()
        end
    end)

    local InfoContainer = Instance.new("Frame")
    InfoContainer.Size = UDim2.new(1, -24, 0, 140)
    InfoContainer.Position = UDim2.new(0, 12, 0, 124)
    InfoContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    InfoContainer.BorderSizePixel = 0
    InfoContainer.Parent = MainFrame

    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 6)
    InfoCorner.Parent = InfoContainer

    local FinishedMSLabel = Instance.new("TextLabel")
    FinishedMSLabel.Size = UDim2.new(1, -16, 0, 60)
    FinishedMSLabel.Position = UDim2.new(0, 8, 0, 8)
    FinishedMSLabel.BackgroundTransparency = 1
    FinishedMSLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
    FinishedMSLabel.Font = Enum.Font.GothamMedium
    FinishedMSLabel.TextSize = 11
    FinishedMSLabel.TextXAlignment = Enum.TextXAlignment.Left
    FinishedMSLabel.TextYAlignment = Enum.TextYAlignment.Top
    FinishedMSLabel.Text = "📦 Marshmallow Jadi:\n   • Small  : 0\n   • Medium : 0\n   • Large  : 0"
    FinishedMSLabel.Parent = InfoContainer

    local IngredientsLabel = Instance.new("TextLabel")
    IngredientsLabel.Size = UDim2.new(1, -16, 0, 60)
    IngredientsLabel.Position = UDim2.new(0, 8, 0, 70)
    IngredientsLabel.BackgroundTransparency = 1
    IngredientsLabel.TextColor3 = Color3.fromRGB(160, 210, 255)
    IngredientsLabel.Font = Enum.Font.GothamMedium
    IngredientsLabel.TextSize = 11
    IngredientsLabel.TextXAlignment = Enum.TextXAlignment.Left
    IngredientsLabel.TextYAlignment = Enum.TextYAlignment.Top
    IngredientsLabel.Text = "🧪 Bahan di Tas:\n   • Water  : 0\n   • Sugar  : 0\n   • Gelatin: 0"
    IngredientsLabel.Parent = InfoContainer

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -24, 0, 36)
    ToggleButton.Position = UDim2.new(0, 12, 0, 274)
    ToggleButton.Text = "START MASAK MS"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 12
    ToggleButton.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton

    local IsAutoSell = false

    local AutoSellBtn = Instance.new("TextButton")
    AutoSellBtn.Size = UDim2.new(1, -24, 0, 36)
    AutoSellBtn.Position = UDim2.new(0, 12, 0, 318)
    AutoSellBtn.Text = "AUTO SELL: OFF 🔴"
    AutoSellBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    AutoSellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoSellBtn.Font = Enum.Font.GothamBold
    AutoSellBtn.TextSize = 12
    AutoSellBtn.Parent = MainFrame

    local AutoSellCorner = Instance.new("UICorner")
    AutoSellCorner.CornerRadius = UDim.new(0, 6)
    AutoSellCorner.Parent = AutoSellBtn

    AutoSellBtn.MouseButton1Click:Connect(function()
        IsAutoSell = not IsAutoSell
        if IsAutoSell then
            AutoSellBtn.Text = "AUTO SELL: ON 🟢"
            AutoSellBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
        else
            AutoSellBtn.Text = "AUTO SELL: OFF 🔴"
            AutoSellBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end)

    local InfoKeyLabel = Instance.new("TextLabel")
    InfoKeyLabel.Size = UDim2.new(1, 0, 0, 20)
    InfoKeyLabel.Position = UDim2.new(0, 0, 0, 365)
    InfoKeyLabel.BackgroundTransparency = 1
    InfoKeyLabel.Text = "[PageUp] Buka / Tutup Menu"
    InfoKeyLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    InfoKeyLabel.Font = Enum.Font.Gotham
    InfoKeyLabel.TextSize = 10
    InfoKeyLabel.Parent = MainFrame

    local function UpdateInventoryStats()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        local counts = {Water = 0, Sugar = 0, Gelatin = 0, Small = 0, Medium = 0, Large = 0}

        local function scan(container)
            if not container then return end
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local name = item.Name:lower()
                    if name:find("water") then counts.Water = counts.Water + 1
                    elseif name:find("sugar") then counts.Sugar = counts.Sugar + 1
                    elseif name:find("gelatin") then counts.Gelatin = counts.Gelatin + 1
                    elseif name:find("small") then counts.Small = counts.Small + 1
                    elseif name:find("medium") then counts.Medium = counts.Medium + 1
                    elseif name:find("large") then counts.Large = counts.Large + 1
                    end
                end
            end
        end

        scan(backpack)
        scan(character)

        FinishedMSLabel.Text = string.format("📦 Marshmallow Jadi:\n   • Small  : %d\n   • Medium : %d\n   • Large  : %d", counts.Small, counts.Medium, counts.Large)
        IngredientsLabel.Text = string.format("🧪 Bahan di Tas:\n   • Water  : %d\n   • Sugar  : %d\n   • Gelatin: %d", counts.Water, counts.Sugar, counts.Gelatin)
    end

    task.spawn(function()
        while true do
            UpdateInventoryStats()
            task.wait(0.5)
        end
    end)

    local IsRunning = false

    local function PressE()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.1)
    end

    local function HoldE(duration)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(duration)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.1)
    end

    local function EquipTool(toolName)
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        if not backpack or not character then return false end
        
        local held = character:FindFirstChildOfClass("Tool")
        if held and held.Name:lower():find(toolName:lower()) then return true end

        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find(toolName:lower()) then
                item.Parent = character
                task.wait(0.2)
                return true
            end
        end
        return false
    end

    local function WaitTimer(duration, titlePrefix, emoji)
        local startTime = tick()
        while IsRunning do
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            ProgressBar.Size = UDim2.new(math.clamp(elapsed / duration, 0, 1), 0, 1, 0)
            StatusLabel.Text = string.format("%s (%.1fs) %s", titlePrefix, remaining, emoji)
            if remaining <= 0 then break end
            task.wait(0.1)
        end
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if IsAutoSell then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local character = LocalPlayer.Character
                if backpack and character then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and item.Name:lower():find("marshmallow") then
                            item.Parent = character
                            task.wait(0.3)
                            HoldE(2.5)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        IsRunning = not IsRunning
        ToggleButton.Text = IsRunning and "STOP MASAK" or "START MASAK MS"
        ToggleButton.BackgroundColor3 = IsRunning and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(0, 180, 120)

        if IsRunning then
            task.spawn(function()
                while IsRunning do
                    if EquipTool("Water") then PressE(); WaitTimer(21, "Memasak Air", "💧") end
                    if not IsRunning then break end
                    if EquipTool("Sugar") then PressE(); task.wait(0.8) end
                    if not IsRunning then break end
                    if EquipTool("Gelatin") then PressE(); task.wait(0.8) end
                    if not IsRunning then break end
                    WaitTimer(46, "Proses Masak MS", "⏳")
                    if not IsRunning then break end
                    StatusLabel.Text = "Status: Ambil Hasil Bag 🛍️"
                    if EquipTool("bag") or EquipTool("empty") then
                        PressE(); task.wait(0.4); PressE(); task.wait(0.8)
                    else
                        StatusLabel.Text = "Status: Bag Tidak Ada! ❌"
                        task.wait(1.5)
                    end
                end
                ProgressBar.Size = UDim2.new(0, 0, 1, 0)
                StatusLabel.Text = "Status: Idle 💤"
            end)
        else
            ProgressBar.Size = UDim2.new(0, 0, 1, 0)
            StatusLabel.Text = "Status: Idle 💤"
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.PageUp then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
end

--------------------------------------------------------------------------------
-- 5. VERIFIKASI KEY PERMANEN
--------------------------------------------------------------------------------
SubmitBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text

    if KEYS_LIST[enteredKey] then
        KeyStatus.Text = "✅ Key Valid! Memuat UI..."
        KeyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.8)
        KeyScreenGui:Destroy()
        LoadMainScript()
    else
        KeyStatus.Text = "❌ Key Salah!"
        KeyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)
