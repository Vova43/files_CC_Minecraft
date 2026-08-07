local radarMon = peripheral.find("create_radar:monitor")

if not radarMon then
    error("xError")
end

local block_reader = peripheral.find("block_reader")

if not block_reader then
    error("xError")
end

local playerWasPresent = false
local RADAR_ROTATION_TIME = 5.0
local lastTimeSeen = 0
local sideOutput = "right" -- left + right

while true do
    term.clear()
    term.setCursorPos(1, 1)
    
    local tracks = radarMon.getTracks()
    local playersFound = 0
	
	local currentTime = os.clock()
	
	redstone.setOutput(sideOutput, false)
    
    if tracks then
        for i = 1, #tracks do
            local target = tracks[i]
            
            if target.category == "PLAYER" then
                playersFound = playersFound + 1
                
                local pos = target.position or {}
                local x = pos.x or 0
                local y = pos.y or 0
                local z = pos.z or 0
                
                local vel = target.velocity or {}
                local vx = vel.x or 0
                local vy = vel.y or 0
                local vz = vel.z or 0
                
                print(string.format("%d. player! id:%s", playersFound, target.id))
                print(string.format(" C: X:%.1f Y:%.1f Z:%.1f", x, y, z))
                
                local speed = math.sqrt(vx^2 + vy^2 + vz^2)
                if speed > 0.1 then
                    print(string.format(" Vspeed: %.2f m/s", speed * 20))
                end
                
            end
        end
    end
    
    -- if playersFound == 0 then
        -- print("null...")
	-- else
		-- redstone.setOutput(sideOutput, false)
		-- redstone.setOutput(sideOutput, true)
		-- sleep(1.5)
		-- redstone.setOutput(sideOutput, false)
    -- end
	
	if playersFound > 0 then
		lastTimeSeen = currentTime
        if not playerWasPresent then
            print("\n[!] NEW PLAYER DETECTED! Activating signal...")
            -- redstone.setOutput(sideOutput, true)
            -- sleep(1.5)
            -- redstone.setOutput(sideOutput, false)
			
			if not block_reader.getBlockStates().powering then
				redstone.setOutput(sideOutput, true)
				sleep(1.5)
				redstone.setOutput(sideOutput, false)
			end
			
            print("Signal turned off.")
            playerWasPresent = true
        else
            print("\nPlayer is still on base. Waiting for them to leave...")
        end
    else
        local timeSinceLastSeen = currentTime - lastTimeSeen
        
        if playerWasPresent and timeSinceLastSeen > RADAR_ROTATION_TIME then
            print("\n[-] Base is clear. Player left.")
            playerWasPresent = false
        elseif playerWasPresent then
            print(string.format("\nWaiting for radar antenna to complete loop... (%.1f sec)", RADAR_ROTATION_TIME - timeSinceLastSeen))
        else
            print("\nnull...")
        end
    end
    
    sleep(0.5)
end
