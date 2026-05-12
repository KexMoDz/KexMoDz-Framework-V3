-- [[ KexMoDz V3.2.3 - EXTREME PROTECTION ]] --
local _0xKex = "6c6f6164737472696e67"
local function _0xV(_0x1)
    local _0x2 = ""
    for i = 1, #_0x1, 2 do
        _0x2 = _0x2 .. string.char(tonumber(_0x1:sub(i, i+1), 16))
    end
    return _0x2
end

local _0xSource = "local Players = game:GetService('Players'); local LocalPlayer = Players.LocalPlayer; local ScreenGui = Instance.new('ScreenGui', game.CoreGui); ScreenGui.Name = 'KexMoDz_Final'; local Holder = Instance.new('Frame', ScreenGui); Holder.Size = UDim2.new(0, 360, 0, 165); Holder.Position = UDim2.new(1, -380, 0, 20); Holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15); local MS = Instance.new('UIStroke', Holder); MS.Thickness = 2.5; MS.Color = Color3.fromRGB(0, 150, 70); local Title = Instance.new('TextLabel', Holder); Title.Size = UDim2.new(1, 0, 0, 30); Title.Text = 'KexMoDz V3.2.3 Loaded!'; Title.TextColor3 = Color3.new(1, 1, 1); Title.BackgroundTransparency = 1; print('KexMoDz Active!')"

-- Dieser Teil sorgt dafür, dass Delta den Code sofort schluckt:
local run = loadstring(_0xSource)
if run then
    run()
else
    warn("KexMoDz: Boot Error - Please restart Delta")
end
