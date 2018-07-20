-- Combo Points plugin
local ADDON_NAME, Engine = ...
if not Engine.Enabled then return end
local UI = Engine.UI

if UI.MyClass ~= "ROGUE" and UI.MyClass ~= "DRUID" then return end -- combo not needed for other classes

local CheckSpec = Engine.CheckSpec
local PixelPerfect = Engine.PixelPerfect
local DefaultBoolean = Engine.DefaultBoolean
local GetColor = Engine.GetColor
local ColorPercent = Engine.ColorPercent

--
local plugin = Engine:NewPlugin("COMBO")

local DefaultColors = {
	{0.69, 0.31, 0.31, 1}, -- 1
	{0.33, 0.63, 0.33, 1}, -- 2
}

-- own methods
function plugin:UpdateVisibility(event)
	local inCombat = true
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		inCombat = true
	else
		inCombat = false
	end
	if (self.settings.autohide == false or inCombat) and CheckSpec(self.settings.specs) then
		self.frame:Show()
		self:UpdateValue()
	else
		self.frame:Hide()
	end
end

function plugin:UpdateValue()
	local points = GetComboPoints("player", "target")
	if self.settings.borderRemind == true then
		if points and points > 0 then
			for i = 1, points do self.points[i].status:Show() end
			for i = points+1, self.count do self.points[i].status:Hide() end
		else
			for i = 1, self.count do self.points[i].status:Hide() end
		end
	else
		if points and points > 0 then
			for i = 1, points do self.points[i]:Show() end
			for i = points+1, self.count do self.points[i]:Hide() end
		else
			for i = 1, self.count do self.points[i]:Hide() end
		end
	end
--print(tostring(points))
end

function plugin:UpdateGraphics()
	-- Create a frame including every points
	local frame = self.frame
	if not frame then
		frame = CreateFrame("Frame", self.name, UI.PetBattleHider)
		frame:Hide()
		self.frame = frame
	end
	local frameWidth = self:GetWidth()
	local height = self:GetHeight()
	frame:ClearAllPoints()
	frame:Point(unpack(self:GetAnchor()))
	frame:Size(frameWidth, height)
	-- Create points
	local width, spacing = PixelPerfect(frameWidth, self.count)
	self.points = self.points or {}
	for i = 1, self.count do
		local point = self.points[i]
		if not point then
			point = CreateFrame("Frame", nil, self.frame)
			point:SetTemplate()
			point:SetFrameStrata("BACKGROUND")
			point:SetBackdropColor(1, 1, 1, 0)
			if not self.settings.borderRemind == true then point:Hide() end
			self.points[i] = point
		end
		point:Size(width, height)
		point:ClearAllPoints()
		if i == 1 then
			point:Point("TOPLEFT", frame, "TOPLEFT", 0, 0)
		else
			point:Point("LEFT", self.points[i-1], "RIGHT", spacing, 0)
		end
		if not point.status then
			point.status = CreateFrame("StatusBar", nil, point)
			point.status:SetStatusBarTexture(UI.NormTex)
			point.status:SetFrameLevel(6)
			point.status:SetInside()
		end
--		local color = GetColor(self.settings.colors, i, DefaultColors[i])
		local color = ColorPercent(self.settings.colors[1], self.settings.colors[2], i, self.count)
		if self.settings.filled == true then
			point.status:SetStatusBarColor(unpack(color))
			point:SetBackdropBorderColor(unpack(UI.BorderColor))
			point.status:Show()
		else
			point.status:SetStatusBarColor(0, 0, 0, 1)
			point:SetBackdropBorderColor(unpack(color))
			point.status:Show()
		end
	end
end

-- overridden methods
function plugin:Initialize()
	-- set defaults
	self.settings.filled = DefaultBoolean(self.settings.filled, false)
	self.settings.colors = self.settings.colors or DefaultColors

	self:SetCounts()
end

function plugin:SetCounts()
	self.count = UnitPowerMax("player", 4)
--print(tostring(self.count))
	self:UpdateGraphics()
end

function plugin:Enable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", plugin.UpdateVisibility)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", plugin.UpdateVisibility)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", plugin.UpdateVisibility)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", plugin.UpdateVisibility)
	--self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player", plugin.UpdateVisibility)
	self:RegisterEvent("UNIT_MAXPOWER", plugin.SetCounts)
	
	self:RegisterUnitEvent("UNIT_POWER_UPDATE", "player", plugin.UpdateValue)
end

function plugin:Disable()
	self:UnregisterAllEvents()

	self.frame:Hide()
end

function plugin:SettingsModified()
	--
	self:Disable()
	--
	self:UpdateGraphics()
	--
	if self:IsEnabled() then
		self:Enable()
		self:UpdateVisibility()
	end
end