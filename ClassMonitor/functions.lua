local ADDON_NAME, Engine = ...
if not Engine.Enabled then return end

-- Create a color array from one color
Engine.CreateColorArray = function(color, count)
	if not color or not count then return end
	local colors = { }
	for i = 1, count, 1 do
		tinsert(colors, color)
	end
	return colors
end

Engine.DefaultBoolean = function(value, default)
	if value == nil then
		return default
	else
		return value
	end
end

-- Compute width and spacing for total width and count
-- Don't want to solve a Diophantine equation, so we use a dumb guess/try method =)
Engine.PixelPerfect = function(totalWidth, count)
	if count == 1 then return totalWidth, 0 end
	local width, spacing = math.floor(totalWidth/count) - (count-1), 1
	while true do
		local total = width * count + spacing * (count-1)
		if total > totalWidth then
			if width * count >= totalWidth then
				assert(false, "Problem with PixelPerfect, unable to compute valid width/spacing. totalWidth: "..tostring(totalWidth).."  count: "..tostring(count))
				return nil --width, 1-- error
			end
			spacing = 1
			width = width + 1
		end
		if total == totalWidth then
			return width, spacing
		end
		spacing = spacing + 1
	end
end

Engine.FormatNumber = function(val)
	if val >= 1e6 then
		return ("%.1fm"):format(val / 1e6)
	elseif val >= 1e3 then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end

Engine.ToClock = function(seconds)
	local ceilSeconds = ceil(tonumber(seconds))
	if ceilSeconds <= 0 then
		return " "
	elseif ceilSeconds < 10 then
		return format("%.1f", seconds)
	elseif ceilSeconds < 600 then
		local _, _, m, s = ChatFrame_TimeBreakDown(ceilSeconds)
		return format("%01d:%02d", m, s)
	elseif ceilSeconds < 3600 then
		local _, _, m, s = ChatFrame_TimeBreakDown(ceilSeconds)
		return format("%02d:%02d", m, s)
	else
		return "1 hr+"
	end
end

Engine.CheckSpec = function(specs)
	local activeSpec = GetSpecialization()
	for _, spec in pairs(specs) do
		if spec == "any" or tostring(spec) == tostring(activeSpec) then
			return true
		end
	end
	return false
end

Engine.GetConfig = function(c, n)
	local class = string.upper(c)
	local name = string.upper(n)
	local alternativeName = "CM_" .. name
	local classEntry = Engine.Config[class]
	if classEntry then
		for _, v in pairs(classEntry) do
			if v.name == name or v.name == alternativeName or v.kind == name then
				return v
			end
		end
	end
	return nil
end

Engine.AddConfig = function(c, config)
	local class = string.upper(c)
	local classEntry = Engine.Config[class]
	if classEntry then
		table.insert(classEntry, config)
	end
end

-- Duplicate any object
Engine.DeepCopy = function(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return new_table
	end
	return _copy(object)
end

-- Check if PTR
Engine.IsPTR = function()
	local toc = select(4, GetBuildInfo())
	return toc > 50001
end