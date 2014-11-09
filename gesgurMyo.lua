scriptId = 'com.thalmic.examples.outputeverything'

locked = true
rollDefault = nil
state = 'start'
flag = nil

function onPoseEdge(pose, edge)
    --myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
    
    pose = conditionallySwapWave(pose)

    if(edge == "on") then
    	if (pose == "thumbToPinky") then
    		toggleLock()
    	elseif (not locked) then
    		if (pose == "waveIn") then
    			myo.vibrate("short")
				myo.keyboard("left_arrow","press")
    		elseif (pose == "waveOut") then
    			myo.vibrate("short")
				myo.keyboard("right_arrow", "press")
    		elseif (pose == "fist") then
    			myo.vibrate('short')
				state = 'navigation'
    			rollDefault = nil
    			myo.debug("moved to navigation mode")
    		elseif (pose == "fingersSpread") then
    			flag = true
    			myo.vibrate('short')
				state = 'voting'
    			rollDefault = nil
    			myo.debug("moved to voting mode")
    		end
    	end
    elseif (edge == "off" and not locked) then 
    	if (pose == "fist") then
    		state = 'start'
    		myo.debug("moved out of navigation mode")
    	elseif (pose == "fingersSpread") then
    		state = 'start'
    		myo.debug("moved out of voting mode")
    		myo.keyboard("equal", "up")
    		myo.keyboard("minus", "up")
    	end
    end
end

function onPeriodic()
	if state == 'navigation' then
		if rollDefault == nil then
			sampleRoll()
		end

		if (myo.getRoll() - rollDefault) > 0.3 then
			myo.keyboard('down_arrow', 'press')
		elseif (myo.getRoll() - rollDefault) < -0.3 then
			myo.keyboard('up_arrow', 'press')
		end
	end

	if state == 'voting' then
		if rollDefault == nil then
			voteRoll()
		end
		
		if ((myo.getRoll() - rollDefault) > 0.3) and flag then
			--upvote
			myo.keyboard('equal', 'down')
			flag = false
		elseif ((myo.getRoll() - rollDefault) < -0.3) and flag then
			myo.keyboard('minus', 'down')
			flag = false
		end
	end
end

function sampleRoll()
	myo.debug("scrolling now")
	rollSum = 0
	rollNum = 25
	for var = 0, rollNum - 1, 1 do
		rollSum = rollSum+myo.getRoll()
		wait(10)
	end
	rollDefault = rollSum/rollNum
end

function voteRoll()
	myo.debug("voting now")
	rollSum = 0
	rollNum = 25
	for var = 0, rollNum - 1, 1 do
		rollSum = rollSum+myo.getRoll()
		wait(10)
	end
	rollDefault = rollSum/rollNum
end

function wait(millis)
	startTime = myo.getTimeMilliseconds()

	while myo.getTimeMilliseconds() - startTime < millis do
	end
end

function toggleLock()
	locked = not locked
	myo.vibrate("long")
	if locked == true then
		myo.debug("Myo is now locked")
	elseif locked == false then
		myo.debug("Myo is now unlocked")
	end
end

function conditionallySwapWave(pose)
	if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function onForegroundWindowChange(app, title)
    --myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    --myo.debug(title)
    if(string.match(title, "imgur") or string.match(title, "Imgur")) then 
    	--myo.debug("We did it!")
    	--myo.centerMousePosition()
    	--myo.controlMouse(true)
    else 
    	--myo.debug("Not imgur")
    	myo.controlMouse(false)
    end
    return true
end

function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
    --myo.debug("onActiveChange")
end