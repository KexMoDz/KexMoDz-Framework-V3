-- [[ KexMoDz Framework V3.2.3 - Official ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Alte GUI entfernen
local oldGui = game.CoreGui:FindFirstChild("KexMoDz_V1_3_Final")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KexMoDz_V1_3_Final"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MatteGreen = Color3.fromRGB(0, 150, 70)
local AppleGreen = Color3.fromRGB(48, 209, 88)
local AppleGray = Color3.fromRGB(60, 60, 60)
local BgDark = Color3.fromRGB(15, 15, 15)

-- --- DATA ---
local deaths, fps, lastBankValue = 0, 0, "0"
local lastKiller = "None"
local canCount = true
local isOpen = true
local visibility = { FPS = true, Player = true, Deaths = true, Killer = true, Bank = true }

RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)

-- --- KILLER DETECTION ---
local function GetKiller(humanoid)
    local creator = humanoid:FindFirstChild("creator")
    if creator and creator.Value and creator.Value:IsA("Player") then return creator.Value.Name end
    local lastHit = humanoid:FindFirstChild("LastHitBy") or humanoid:FindFirstChild("CombatTag")
    if lastHit and lastHit.Value and lastHit.Value:IsA("Player") then return lastHit.Value.Name end
    return "Reset"
end

-- --- INFO BOX ---
local InfoBox = Instance.new("Frame", ScreenGui)
InfoBox.Position = UDim2.new(0, 20, 0, 80)
InfoBox.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", InfoBox).CornerRadius = UDim.new(0, 8)
local InfoStroke = Instance.new("UIStroke", InfoBox)
InfoStroke.Thickness = 2
InfoStroke.Color = MatteGreen

local InfoLayout = Instance.new("UIListLayout", InfoBox)
InfoLayout.Padding = UDim.new(0, 2)
InfoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateInfoLabel(name, text, order)
    local l = Instance.new("TextLabel", InfoBox)
    l.Name = order .. "_" .. name
    l.Size = UDim2.new(1, 0, 0, 28)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBlack
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextSize = 13
    l.Text = text
    l.RichText = true
    return l
end

local InfoTitle = CreateInfoLabel("Title", "Info:", "1")
Instance.new("UIStroke", InfoTitle).Color = MatteGreen
local L_FPS = CreateInfoLabel("FPS", "FPS: 0", "2")
local L_Player = CreateInfoLabel("Player", "Player: 0", "3")
local L_Deaths = CreateInfoLabel("Deaths", "Deaths: 0", "4")
local L_Killer = CreateInfoLabel("Killer", "Killed by: None", "5")
local L_Bank = CreateInfoLabel("Bank", "Bank: $0", "6")

local function UpdateInfoSize()
    local visibleCount = 1 
    for _, v in pairs(visibility) do if v then visibleCount = visibleCount + 1 end end
    InfoBox:TweenSize(UDim2.new(0, 160, 0, (visibleCount * 28) + 10), "Out", "Quad", 0.3, true)
end

-- --- MAIN MENU ---
local Holder = Instance.new("Frame", ScreenGui)
Holder.Size = UDim2.new(0, 360, 0, 165) 
Holder.Position = UDim2.new(0.5, -180, 0.5, -82) -- Zentriert für den ersten Start
Holder.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Holder.ClipsDescendants = true
Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)
local MS = Instance.new("UIStroke", Holder)
MS.Thickness = 2.5
MS.Color = MatteGreen

-- Draggable Logic für das Hauptmenü
local draggingM, dragStartM, startPosM
Holder.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingM = true dragStartM = input.Position startPosM = Holder.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingM and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartM
        Holder.Position = UDim2.new(startPosM.X.Scale, startPosM.X.Offset + delta.X, startPosM.Y.Scale, startPosM.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) draggingM = false end)

-- Logo & Minimize Button
local LogoFrame = Instance.new("Frame", ScreenGui)
LogoFrame.Size = UDim2.new(0, 55, 0, 55)
LogoFrame.Position = UDim2.new(1, -75, 0, 85)
LogoFrame.BackgroundTransparency = 1 
LogoFrame.Visible = false
Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0, 12)
local LogoStroke = Instance.new("UIStroke", LogoFrame)
LogoStroke.Thickness = 2.5
LogoStroke.Color = MatteGreen
local LogoBtn = Instance.new("ImageButton", LogoFrame)
LogoBtn.Size = UDim2.new(1, 0, 1, 0)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Image = "rbxthumb://type=Asset&id=122559737709007&w=420&h=420"

local function ToggleMenu()
    isOpen = not isOpen
    Holder.Visible = isOpen
    LogoFrame.Visible = not isOpen
end

LogoBtn.MouseButton1Click:Connect(ToggleMenu)

local ToggleBtn = Instance.new("TextButton", Holder)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(1, -45, 0, 5)
ToggleBtn.Text = "-"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 30 
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.MouseButton1Click:Connect(ToggleMenu)

-- Tabs System
local Sidebar = Instance.new("Frame", Holder)
Sidebar.Size = UDim2.new(0, 110, 1, -45)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

local Pages = Instance.new("Frame", Holder)
Pages.Size = UDim2.new(1, -135, 1, -45)
Pages.Position = UDim2.new(0, 125, 0, 40)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = MatteGreen
    p.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    p.Name = name
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
    return p
end

local GenPage, SrvPage, MscPage = CreatePage("General"), CreatePage("Server"), CreatePage("Misc")

local Title = Instance.new("TextLabel", Holder)
Title.Size = UDim2.new(0, 230, 0, 30)
Title.Position = UDim2.new(0, 12, 0, 7)
Title.Text = "KexMoDz V3.2.3"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Instance.new("UIStroke", Title).Color = MatteGreen

-- Tab Buttons
local function AddTab(name, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = BgDark
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
end

AddTab("⚙️ General", GenPage)
AddTab("🌐 Server", SrvPage)
AddTab("🛠️ Misc", MscPage)
GenPage.Visible = true

-- --- UI ELEMENTS ---
local function CreateAppleSwitch(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -5, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = ""
    Instance.new("UICorner", btn)
    local l = Instance.new("TextLabel", btn)
    l.Size = UDim2.new(1, -45, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    local sw = Instance.new("Frame", btn)
    sw.Size = UDim2.new(0, 30, 0, 16)
    sw.Position = UDim2.new(1, -35, 0.5, -8)
    sw.BackgroundColor3 = default and AppleGreen or AppleGray
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    local c = Instance.new("Frame", sw)
    c.Size = UDim2.new(0, 12, 0, 12)
    c.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    c.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
    local active = default
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(c, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = active and AppleGreen or AppleGray}):Play()
        callback(active)
    end)
end

local function CreateBtn(parent, text, func)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -5, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "  " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

-- --- FUNKTIONEN ---
CreateAppleSwitch(GenPage, "Hermanos Farm", false, function(s) 
    if s then 
        getgenv().script_mode = "FARM"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))()
    end 
end)

CreateBtn(SrvPage, "Rejoin Server", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
CreateAppleSwitch(MscPage, "Show Infobox", true, function(s) InfoBox.Visible = s end)

-- --- MAIN LOOP ---
task.spawn(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 and canCount then deaths = deaths + 1 canCount = false lastKiller = GetKiller(hum)
            elseif hum and hum.Health > 0 then canCount = true end
            L_FPS.Text = "FPS: " .. fps
            L_Player.Text = "Players: " .. #Players:GetPlayers()
            L_Deaths.Text = "Deaths: " .. deaths
            L_Killer.Text = "Killer: " .. lastKiller
        end)
        task.wait(0.5)
    end
end)

UpdateInfoSize()
print("KexMoDz Loaded Successfully!")
