-- [[ KexMoDz Framework V3.2.3 - FULL VERSION ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Alte GUI entfernen
if game.CoreGui:FindFirstChild("KexMoDz_V1_3_Final") then
    game.CoreGui:FindFirstChild("KexMoDz_V1_3_Final"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KexMoDz_V1_3_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MatteGreen = Color3.fromRGB(0, 150, 70)
local AppleGreen = Color3.fromRGB(48, 209, 88)
local AppleGray = Color3.fromRGB(60, 60, 60)
local BgDark = Color3.fromRGB(15, 15, 15)

-- --- DATA ---
local deaths, fps, lastBankValue, lastKiller, canCount, isOpen = 0, 0, "0", "None", true, true
local visibility = { FPS = true, Player = true, Deaths = true, Killer = true, Bank = true }

RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)

-- --- KILLER DETECTION ---
local function GetKiller(humanoid)
    local creator = humanoid:FindFirstChild("creator")
    if creator and creator.Value and creator.Value:IsA("Player") then return creator.Value.Name end
    return "Reset"
end

-- --- INFO BOX ---
local InfoBox = Instance.new("Frame", ScreenGui)
InfoBox.Position = UDim2.new(0, 20, 0, 80)
InfoBox.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", InfoBox).CornerRadius = UDim.new(0, 8)
local InfoStroke = Instance.new("UIStroke", InfoBox)
InfoStroke.Thickness, InfoStroke.Color = 2, MatteGreen
local InfoLayout = Instance.new("UIListLayout", InfoBox)
InfoLayout.Padding = UDim.new(0, 2)

local function CreateInfoLabel(name, text)
    local l = Instance.new("TextLabel", InfoBox)
    l.Size = UDim2.new(1, 0, 0, 28)
    l.BackgroundTransparency, l.Font, l.TextColor3, l.TextSize, l.RichText = 1, Enum.Font.GothamBlack, Color3.new(1, 1, 1), 13, true
    l.Text = text
    return l
end

local L_Title = CreateInfoLabel("Title", "Info:")
local L_FPS = CreateInfoLabel("FPS", "FPS: 0")
local L_Player = CreateInfoLabel("Player", "Player: 0")
local L_Deaths = CreateInfoLabel("Deaths", "Deaths: 0")
local L_Killer = CreateInfoLabel("Killer", "Killed by: None")
local L_Bank = CreateInfoLabel("Bank", "Bank: $0")

local function UpdateInfoSize()
    local count = 1 
    for _, v in pairs(visibility) do if v then count = count + 1 end end
    InfoBox:TweenSize(UDim2.new(0, 160, 0, (count * 28) + 10), "Out", "Quad", 0.3, true)
end

-- --- MAIN MENU ---
local Holder = Instance.new("Frame", ScreenGui)
Holder.Size, Holder.Position, Holder.BackgroundColor3 = UDim2.new(0, 360, 0, 165), UDim2.new(1, -380, 0, 20), Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", Holder)
local MS = Instance.new("UIStroke", Holder)
MS.Thickness, MS.Color = 2.5, MatteGreen

local LogoFrame = Instance.new("Frame", ScreenGui)
LogoFrame.Size, LogoFrame.Position, LogoFrame.Visible, LogoFrame.BackgroundTransparency = UDim2.new(0, 55, 0, 55), UDim2.new(1, -75, 0, 85), false, 1
local LogoBtn = Instance.new("ImageButton", LogoFrame)
LogoBtn.Size, LogoBtn.BackgroundTransparency, LogoBtn.Image = UDim2.new(1, 0, 1, 0), 1, "rbxthumb://type=Asset&id=122559737709007&w=420&h=420"

local Sidebar = Instance.new("Frame", Holder)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundTransparency = UDim2.new(0, 110, 1, -45), UDim2.new(0, 10, 0, 45), 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

local Pages = Instance.new("Frame", Holder)
Pages.Size, Pages.Position, Pages.BackgroundTransparency = UDim2.new(1, -135, 1, -45), UDim2.new(0, 125, 0, 40), 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size, p.BackgroundTransparency, p.Visible, p.ScrollBarThickness, p.CanvasSize = UDim2.new(1, 0, 1, 0), 1, false, 2, UDim2.new(0, 0, 2, 0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6)
    return p
end

local GenPage, SrvPage, MscPage = CreatePage("General"), CreatePage("Server"), CreatePage("Misc")

local function AddTab(name, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.BackgroundColor3, b.Text, b.Font, b.TextColor3, b.TextSize = UDim2.new(1, 0, 0, 32), BgDark, name, Enum.Font.GothamBold, Color3.new(1, 1, 1), 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
end

AddTab("⚙️ General", GenPage); AddTab("🌐 Server", SrvPage); AddTab("🛠️ Misc", MscPage)
GenPage.Visible = true

-- --- UI ELEMENTS ---
local function CreateAppleSwitch(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text = UDim2.new(1, -5, 0, 32), BgDark, ""
    Instance.new("UICorner", btn)
    local l = Instance.new("TextLabel", btn)
    l.Size, l.Position, l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.BackgroundTransparency = UDim2.new(1, -45, 1, 0), UDim2.new(0, 8, 0, 0), text, Color3.new(1,1,1), Enum.Font.GothamBold, 10, 0, 1
    local sw = Instance.new("Frame", btn)
    sw.Size, sw.Position, sw.BackgroundColor3 = UDim2.new(0, 30, 0, 16), UDim2.new(1, -35, 0.5, -8), (default and AppleGreen or AppleGray)
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    local active = default
    btn.MouseButton1Click:Connect(function()
        active = not active
        sw.BackgroundColor3 = active and AppleGreen or AppleGray
        callback(active)
    end)
end

local function CreateBtn(parent, text, func)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.BackgroundColor3, btn.Text, btn.Font, btn.TextColor3, btn.TextSize = UDim2.new(1, -5, 0, 32), BgDark, text, Enum.Font.GothamBold, Color3.new(1, 1, 1), 10
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

-- --- CONTENT ---
CreateAppleSwitch(GenPage, "Hermanos Farm", false, function(s) 
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"))() end
end)

CreateAppleSwitch(GenPage, "FPS Booster", false, function(s)
    Lighting.GlobalShadows = not s
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            v.Material = s and Enum.Material.SmoothPlastic or Enum.Material.Plastic
        end
    end
end)

CreateBtn(SrvPage, "Small Server", function() 
    local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local s, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(Api)) end)
    if s and res.data then for _, v in pairs(res.data) do if v.playing < Players.MaxPlayers and v.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) return end end end
end)

CreateBtn(SrvPage, "Rejoin", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId) end)

CreateAppleSwitch(MscPage, "Show FPS", true, function(s) visibility.FPS = s UpdateInfoSize() end)
CreateAppleSwitch(MscPage, "Show Bank", true, function(s) visibility.Bank = s UpdateInfoSize() end)

-- --- LOOP ---
task.spawn(function()
    while true do
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 and canCount then deaths = deaths + 1; canCount = false; lastKiller = GetKiller(hum)
            elseif hum and hum.Health > 0 then canCount = true end
            
            L_FPS.Visible, L_Player.Visible, L_Deaths.Visible, L_Killer.Visible, L_Bank.Visible = visibility.FPS, visibility.Player, visibility.Deaths, visibility.Killer, visibility.Bank
            L_FPS.Text = "FPS: " .. fps
            L_Player.Text = "Player: " .. #Players:GetPlayers()
            L_Deaths.Text = "Deaths: " .. deaths
            L_Killer.Text = "Killed by: " .. lastKiller
            
            for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and (v.Text:find("Bank") or v.Text:find("Guthaben")) then
                    lastBankValue = v.Text:match("%d+[%d%.,]*") or lastBankValue
                end
            end
            L_Bank.Text = 'Bank: <font color="rgb(0, 255, 127)">$</font>' .. lastBankValue
        end)
        task.wait(0.5)
    end
end)

UpdateInfoSize()
