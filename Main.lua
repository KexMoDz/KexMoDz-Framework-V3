-- [[ KexMoDz Framework V3.2.3 - REPAIR VERSION ]]
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
    InfoBox:Size = UDim2.new(0, 160, 0, (visibleCount * 28) + 10)
end

-- --- MAIN MENU ---
local Holder = Instance.new("Frame", ScreenGui)
Holder.Size = UDim2.new(0, 400, 0, 250) -- GRÖSSERES FENSTER
Holder.Position = UDim2.new(0.5, -200, 0.5, -125)
Holder.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Holder.ClipsDescendants = true
Instance.new("UICorner", Holder).CornerRadius = UDim.new(0, 10)
local MS = Instance.new("UIStroke", Holder)
MS.Thickness = 2.5
MS.Color = MatteGreen

-- Logo & Draggable
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

-- Minimieren Funktion
local function ToggleMenu()
    isOpen = not isOpen
    Holder.Visible = isOpen
    LogoFrame.Visible = not isOpen
end

-- Header
local Title = Instance.new("TextLabel", Holder)
Title.Size = UDim2.new(0, 300, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.Text = "KexMoDz V3.2.3 [REPAIRED]" -- Version Check
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Holder)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.Text = "-"
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 35
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(ToggleMenu)
LogoBtn.MouseButton1Click:Connect(ToggleMenu)

-- Sidebar
local Sidebar = Instance.new("Frame", Holder)
Sidebar.Size = UDim2.new(0, 120, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 5)

-- Pages Container
local Pages = Instance.new("Frame", Holder)
Pages.Size = UDim2.new(1, -150, 1, -60)
Pages.Position = UDim2.new(0, 140, 0, 50)
Pages.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = MatteGreen
    p.CanvasSize = UDim2.new(0, 0, 2, 0) 
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local GenPage = CreatePage("General")
local SrvPage = CreatePage("Server")
local MscPage = CreatePage("Misc")

-- Tab Buttons
local function AddTab(name, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = BgDark
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, pg in pairs(Pages:GetChildren()) do if pg:IsA("ScrollingFrame") then pg.Visible = false end end
        page.Visible = true
    end)
end

AddTab("⚙️ General", GenPage)
AddTab("🌐 Server", SrvPage)
AddTab("🛠️ Misc", MscPage)
GenPage.Visible = true

-- --- UI ELEMENTE ---
local function CreateSwitch(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "  " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.TextColor3 = active and AppleGreen or Color3.new(1,1,1)
        callback(active)
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- --- CONTENT ---
-- General Page
CreateSwitch(GenPage, "Hermanos Farm", function(s)
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))() end
end)

CreateSwitch(GenPage, "FPS Booster", function(s)
    Lighting.GlobalShadows = not s
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            v.Material = s and Enum.Material.SmoothPlastic or Enum.Material.Plastic
        end
    end
end)

-- Server Page
CreateButton(SrvPage, "Find Small Server", function() 
    print("Searching...") 
end)
CreateButton(SrvPage, "Rejoin Server", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)

-- Misc Page
CreateSwitch(MscPage, "Show FPS", function(s) visibility.FPS = s UpdateInfoSize() end)
CreateSwitch(MscPage, "Show Bank", function(s) visibility.Bank = s UpdateInfoSize() end)

-- --- LOOP ---
task.spawn(function()
    while true do
        L_FPS.Text = "FPS: " .. fps
        L_Player.Text = "Players: " .. #Players:GetPlayers()
        L_Bank.Text = "Bank: $" .. lastBankValue
        task.wait(0.5)
    end
end)

UpdateInfoSize()
