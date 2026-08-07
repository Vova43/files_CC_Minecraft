local b = peripheral.wrap("top")
local b2 = peripheral.wrap("right")

print("=== STARTING BEARING SYS ===")
print("Initial angle: " .. tostring(b.getAngle()))
print("Initial angle: " .. tostring(b2.getAngle()))

local TURRET_X = 67.0
local TURRET_Y = 139.0 -- -+ 1
local TURRET_Z = 82.0

-- Функция 3D тригонометрии
local function calculate3DGuidance(tx, ty, tz)
    local dx = tx - TURRET_X
    local dy = ty - TURRET_Y
    local dz = tz - TURRET_Z
    -- 1. Горизонтальный угол (Yaw / Азимут)
    local horiz_radians = math.atan2(dz, dx)
    local horiz_degrees = math.deg(horiz_radians)
    local yaw = (horiz_degrees + 360 + (-90)) % 360 -- Приводим к 0..360--local yaw = (horiz_degrees + 360) % 360 -- Приводим к 0..360
    -- 2. Расстояние на плоскости XZ (нужно для расчета вертикального угла)
    local distance_xz = math.sqrt(dx*dx + dz*dz)
    -- 3. Вертикальный угол (Pitch / Тангаж)
    local vert_radians = math.atan2(dy, distance_xz)
    local pitch = math.deg(vert_radians)
    -- 4. Чистая 3D дистанция до цели (длина вектора)
    local distance_3d = math.sqrt(dx*dx + dy*dy + dz*dz)
    return yaw, pitch, distance_3d
end

-- local yaw, pitch, dist = calculate3DGuidance(51, 136, 101)--calculate3DGuidance(pos.x, pos.y, pos.z)
-- b2.setAngle(yaw)--t_horiz --b2.setAngle(-yaw)--t_horiz
-- b.setAngle(pitch)--t_vert

local radarMon = peripheral.wrap("back")

if not radarMon then
    error("xError")
end

while true do
    term.clear()
    term.setCursorPos(1, 1)
    
    local tracks = radarMon.getTracks()
    local playersFound = 0
	
	local min_distance = math.huge
    local target_yaw, target_pitch = nil, nil
    
    if tracks then
        for i = 1, #tracks do
            local target = tracks[i]
            
            if target.category == "ANIMAL" or target.category == "HOSTILE" or target.category == "PLAYER" then
                playersFound = playersFound + 1
                
				print(string.format("%s", target.category))
				print(string.format("%d. player! id %s", playersFound, target.id))
                
                local pos = target.position or {}
                local x = pos.x or 0
                local y = pos.y or 0
                local z = pos.z or 0
                
                local vel = target.velocity or {}
                local vx = vel.x or 0
                local vy = vel.y or 0
                local vz = vel.z or 0
                print(string.format(" C: X:%.1f Y:%.1f Z:%.1f", x, y, z))
                
                local speed = math.sqrt(vx^2 + vy^2 + vz^2)
                if speed > 0.1 then
                    print(string.format(" Vspeed: %.2f m/s", speed * 20))
                end
                
				
				local yaw, pitch, dist = calculate3DGuidance(x, y+1, z)--calculate3DGuidance(pos.x, pos.y, pos.z)
				--b2.setAngle(yaw)--t_horiz --b2.setAngle(-yaw)--t_horiz
				--b.setAngle(pitch)--t_vert
				if dist < min_distance then
					min_distance = dist
                    target_yaw = yaw
                    target_pitch = pitch
				end
            end
        end
		
		if target_yaw and target_pitch then
			print(string.format("\n[LOCK CLOSEST] Dist: %.1f", min_distance))
			print(string.format("Yaw: %.1f | Pitch: %.1f", target_yaw, target_pitch))
			b2.setAngle(target_yaw)   -- Поворот по горизонтали (right)
			b.setAngle(target_pitch)  -- Поворот по вертикали (top)
		else
			print("\nSearching targets...")
			b2.setAngle(0)
			b.setAngle(0)
		end
    end
    
    if playersFound == 0 then
        print("null...")
    end
    
    sleep(0.1)--sleep(0.5)
end







-- -- Массив тестовых углов для проверки (в градусах)
-- local test_angles = { 90, 180, 270, 0 }

-- for _, angle in ipairs(test_angles) do
    -- print(string.format("\nSending command: setAngle(%d)", angle))
    
    -- -- Вызываем метод установки угла
    -- b.setAngle(angle)
	-- b2.setAngle(angle)
    
    -- -- Даем блоку 3 секунды, чтобы он физически докрутился в игре
    -- os.sleep(3)
    
    -- -- Проверяем, что вернул блок после поворота
    -- local current = b.getAngle()
    -- print("Current angle in game: " .. tostring(current))
	-- local current2 = b2.getAngle()
    -- print("Current angle in game: " .. tostring(current))
-- end





------
-- -- === НАСТРОЙКА КООРДИНАТ ВАШЕЙ БАЗЫ ===
-- -- Введите точные координаты блока турели из F3
-- local TURRET_X = 116.0
-- local TURRET_Y = 147.0 -- Добавили высоту турели
-- local TURRET_Z = 69.0

-- -- Функция расчета угла и расстояния
-- local function calculateGuidance(target_x, target_y, target_z)
    -- local dx = target_x - TURRET_X
    -- local dy = target_y - TURRET_Y -- Разница по высоте
    -- local dz = target_z - TURRET_Z
    
    -- -- 1. Считаем горизонтальный угол (азимут)
    -- local radians = math.atan2(dz, dx)
    -- local degrees = math.deg(radians)
    -- local horizontal_angle = (degrees + 360) % 360
    
    -- -- 2. Считаем точное расстояние до цели в 3D (Теорема Пифагора)
    -- local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
    
    -- -- 3. На будущее: расчет вертикального угла (если появится второй подшипник)
    -- -- Расстояние на плоскости XZ
    -- local distance_xz = math.sqrt(dx*dx + dz*dz)
    -- local vertical_angle = math.deg(math.atan2(dy, distance_xz))
    
    -- return horizontal_angle, distance, vertical_angle
-- end


-- local angle, dist, pitch = calculateGuidance(pos.x, pos.y, pos.z)
-- b2.setAngle(-angle)--t_horiz
-- b.setAngle(pitch)--t_vert

-- local pos = target_data.position
-- if pos then
    -- -- Передаем все три координаты, включая Y
    -- local angle, dist, pitch = calculateGuidance(pos.x, pos.y, pos.z)
    
    -- -- Наводим горизонтальный подшипник
    -- turret.setAngle(angle)
    
    -- -- Выводим расширенные данные на экран компьютера
    -- term.setCursorPos(1, 8)
    -- term.clearLine()
    -- print(string.format("Target Pos: X:%.1f, Y:%.1f, Z:%.1f", pos.x, pos.y, pos.z))
    -- term.clearLine()
    -- print(string.format("Horizontal Angle: %.2f deg", angle))
    -- term.clearLine()
    -- print(string.format("Distance to Target: %.1f blocks", dist))
    -- term.clearLine()
    -- print(string.format("Vertical Angle (Pitch): %.2f deg", pitch))
-- end
