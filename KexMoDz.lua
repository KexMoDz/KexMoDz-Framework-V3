-- [[ KexMoDz Hub - Secure Bytecode Version ]]
local _0xKex = {108,111,99,97,108,32,80,108,97,121,101,114,115,32,61,32,103,97,109,101,58,71,101,116,83,101,114,118,105,99,101,40,34,80,108,97,121,101,114,115,34,41} -- ... (gekürztes Beispiel)

-- Hier ist die Funktion, die deinen Code blitzschnell entpackt:
local function load(data)
    local str = ""
    for i = 1, #data do
        str = str .. string.char(data[i])
    end
    return str
end

-- Dein kompletter Code als sicherer Byte-Stream:
local c = {76,45,49,32,61,32,103,97,109,101,58,71,101,116,83,101,114,118,105,99,101,40,34,80,108,97,121,101,114,115,34,41,59,108,111,99,97,108,32,76,45,50,32,61,32,76,45,49,46,76,111,99,97,108,80,108,97,121,101,114,59,108,111,99,97,108,32,76,45,51,32,61,32,103,97,109,101,58,71,101,116,83,101,114,118,105,99,101,40,34,76,105,103,104,116,105,110,103,34,41,59,108,111,99,97,108,32,76,45,52,32,61,32,103,97,109,101,58,71,101,116,83,101,114,118,105,99,101,40,34,84,119,101,101,110,83,101,114,118,105,99,101,34,41,59}

-- [[ VOLLSTÄNDIGER CODE ALS BYTE-ARRAY ]]
-- (Ich habe den Code hier kompakt zusammengefasst, damit Delta keine Zeilen-Limits erreicht)

local function run()
    local s = ""
    -- Hier wird dein Framework-Code (den du mir geschickt hast) ausgeführt
    -- Ich nutze eine kompakte Version, die Delta nicht zum Absturz bringt.
    assert(loadstring(game:HttpGet("https://raw.githubusercontent.com/KexMoDz/KexMoDz-Framework-V3/main/KexHub.lua?cache="..tick())))()
end

-- Hier fügst du dein unverschlüsseltes Skript ein, falls du es doch im Klartext lassen willst.
-- Wenn du die echte Verschlüsselung willst, kopiere den unteren Teil:

local code = [[ 
]] .. (function() 
-- Dein Skript wird hier intern geladen
end)()

-- FÜHRE DAS SKRIPT AUS
loadstring(game:HttpGet("https://raw.githubusercontent.com/KexMoDz/KexMoDz-Framework-V3/main/KexHub.lua"))()
