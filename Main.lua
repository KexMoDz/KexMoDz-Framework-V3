-- [[ KexMoDz Framework V3.2.3 ]]
print("KexMoDz: Startet...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Falls das Menü schon da ist, löschen
if CoreGui:FindFirstChild("KexMoDz_V1_3_Final") then
    CoreGui:FindFirstChild("KexMoDz_V1_3_Final"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KexMoDz_V1_3_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Test-Fenster (damit wir sehen, ob überhaupt was kommt)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "KexMoDz V3.2.3 Lädt..."
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1

print("KexMoDz: Menü wurde erstellt!")
