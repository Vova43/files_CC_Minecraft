local args = { ... }
local path = args[1]
local pathOut = args[2] or "/"

if not path then
    print("Usage: restore <path> <to path>")
    return
end

local f = fs.open(path, "r")
if f then	
	print("Unpacking data...")
	local archive = textutils.unserialize(f.readAll())
	f.close()

	if type(archive) ~= "table" then
		printError("Error: Invalid archive format.")
		return
	end

	-- Восстанавливаем файлы
	for path, data in pairs(archive) do
		path = fs.combine(pathOut, path)
		-- Если файл лежал в папке, создаем эту папку, если её нет
		local dir = fs.getDir(path)
		if dir ~= "" and not fs.exists(dir) then
			fs.makeDir(dir)
		end

		-- Записываем данные в файл
		local f = fs.open(path, "w")
		if f then
			f.write(data)
			f.close()
			print("Restored: " .. path)
		end
	end

	print("\n[DONE] All files restored successfully!")
end
