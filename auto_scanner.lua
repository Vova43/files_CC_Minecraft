local chat_side = "top" -- Сторона вашей Чат-коробки

-- Get the full path to the running script
local currentScript = shell.getRunningProgram()
-- Get only the directory path where the script is located
local currentDir = fs.getDir(currentScript)
print("Script running from: " .. currentScript)
print("Parent directory: " .. currentDir)

--local list_file = "playersX.txt"
local list_file = string.format("/%s/playersX.txt", currentDir)
print("File path: " .. list_file)

local chat = peripheral.wrap(chat_side)
if not chat then
    print("Error: Chat Box not found on side: " .. chat_side)
    return
end

-- Функция для проверки, есть ли уже ник в файле
local function isNameSaved(name)
    if not fs.exists(list_file) then return false end
    local f = fs.open(list_file, "r")
    local line = f.readLine()
    while line do
        if line:gsub("%s+", "") == name then
            f.close()
            return true
        end
        line = f.readLine()
    end
    f.close()
    return false
end

-- Функция для дозаписи нового ника в файл
local function saveNickname(name)
    local f = fs.open(list_file, "a") -- "a" означает append (дозапись в конец)
    f.writeLine(name)
    f.close()
    print("[Auto-Find] Added new player to database: " .. name)
end

print("=== Chat Sniffer Active ===")
print("Waiting for players to speak in chat...")
print("Press Ctrl+T to stop script.")

while true do
    -- Ждем событие сообщения в чате от Advanced Peripherals
    local event, username, message, uuid = os.pullEvent("chat")
    
    if username then
        -- Проверяем, знаем ли мы уже этого игрока
        if not isNameSaved(username) then
            saveNickname(username)
        end
    end
end

--[[
local chat_side = "top" -- Сторона вашей Чат-коробки
local list_file = "./playersX.txt"

local chat = peripheral.wrap(chat_side)
if not chat then
    print("Error: Chat Box not found on side: " .. chat_side)
    return
end

-- Функция для проверки, есть ли уже ник в файле
local function isNameSaved(name)
    if not fs.exists(list_file) then return false end
    local f = fs.open(list_file, "r")
    local line = f.readLine()
    while line do
        if line:gsub("%s+", "") == name then
            f.close()
            return true
        end
        line = f.readLine()
    end
    f.close()
    return false
end

-- Функция для дозаписи нового ника в файл
local function saveNickname(name)
    local f = fs.open(list_file, "a") -- "a" означает append (дозапись в конец)
    f.writeLine(name)
    f.close()
    print("[Auto-Find] Added new player to database: " .. name)
end

print("=== Chat Sniffer Active ===")
print("Waiting for players to speak in chat...")
print("Press Ctrl+T to stop script.")

while true do
    -- Ждем событие сообщения в чате от Advanced Peripherals
    local event, username, message, uuid = os.pullEvent("chat")
    
    if username then
        -- Проверяем, знаем ли мы уже этого игрока
        if not isNameSaved(username) then
            saveNickname(username)
        end
    end
end
]]