local gameId = game.PlaceId
if gameId == 6765805766 then -- ID für Block Spin
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KexMoDz/KexMoDz-Framework-V3/main/BlockSpin.lua?cache=" .. tick()))()
else
    print("Spiel wird nicht unterstützt")
end
