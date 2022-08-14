--[[
 Original scripts from https://gist.github.com/drio/a1c3967e9cc59eceaee90f45efa32379
--]]
local function getWindows(appname)
	local wins = hs.window.allWindows()
	local windows = {}
	for i = 1, #wins do 
		local w = wins[i]
		local a = w:application()
		if a:name() == appname then
			table.insert(windows, w)
		end
	end

	return windows
end

local function getWindow(appname) 
	local wins = hs.window.allWindows()

	for i = 1, #wins do 
		local w = wins[i]
		local a = w:application()

		if a:name() == appname then
			return w
		end
	end
	return nil
end

local function getFocusWinName()
	return hs.window.focusedWindow():application():name()
end

--[[
Is the focus window ?
  YES:
  - Do we have more instances?
    YES: focus on the next one
    NO: do nothing
  NO:
  - Do we have any instance?
    YES: go to any of the windows
    NO: open a new instance 
--]]
local function run(appname)
	local this_window = getWindow(appname)
	local ala_windows = getWindows(appname)
	local we_are_focused_in_alacritty = getFocusWinName() == appname
	if we_are_focused_in_alacritty then
		for _, w in ipairs(hs.window.allWindows()) do
			if w:application():name() == appname and w:id() ~= hs.window.focusedWindow():id() then
				w:focus()
				break
			end
		end
	else -- We are not focus in alacrity
		if this_window == nil then
			hs.application.open(appname)
		else
			this_window:focus()
		end
	end
end

local obj = {}
obj.__index = obj

function obj:bindHotkeys(apps) 
    if (apps) then
        for _, configure in ipairs(apps) do
            hs.hotkey.bind(configure.key[1], configure.key[2], function() run(configure.appname) end)
        end
    end
end

return obj