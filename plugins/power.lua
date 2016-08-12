-- Power plugin
local ADDON_NAME, Engine = ...
if not Engine.Enabled then return end
local UI = Engine.UI

local CheckSpec = Engine.CheckSpec
local PixelPerfect = Engine.PixelPerfect
local DefaultBoolean = Engine.DefaultBoolean
local GetColor = Engine.GetColor

local plugin = Engine:NewPlugin("POWER")
--print(tostring(UnitPower("player", self.settings.powerType)))
-- own methods

function plugin:UpdateVisibility(event)
	--
--print("POWER:UpdateVisibility")
	local inCombat = true
	if event == "PLAYER_REGEN_DISABLED" or InCombatLockdown() then
		inCombat = true
	else
		inCombat = false
	end
	--
	if (self.settings.autohide == false or inCombat) and CheckSpec(self.settings.specs) then
		--self:UpdateMaxValue()
		self:UpdateValue()
		--
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function plugin:UpdateValue(event, unit, powerType)
	local value = UnitPower("player", self.settings.powerType)
	if value and value > 0 then
		assert(value <= self.count, "Current value:"..tostring(value).." must be <= to count:"..tostring(self.count))
		for i = 1, value do self.points[i]:Show() end
		for i = value+1, self.count do self.points[i]:Hide() end
	else
		for i = 1, self.count do self.points[i]:Hide() end
	end
end

function plugin:SetCounts()
	local maxValue = UnitPowerMax("player", self.settings.powerType)
	if maxValue and maxValue ~= self.maxValue then
		self.count = maxValue

		self:UpdateGraphics()
	end
end

function plugin:UpdatePointGraphics(index, width, height, spacing)
	local point = self.points[index]
	if not point then
		point = CreateFrame("Frame", nil, self.frame)
		point:SetTemplate()
		point:SetFrameStrata("BACKGROUND")
		point:Hide()
		self.points[index] = point
	end
	point:Size(width, height)
	point:ClearAllPoints()
	if index == 1 then
		point:Point("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
	else
		point:Point("LEFT", self.points[index-1], "RIGHT", spacing, 0)
	end
	--
	if self.settings.filled == true and not point.status then
		point.status = CreateFrame("StatusBar", nil, point)
		point.status:SetStatusBarTexture(UI.NormTex)
		point.status:SetFrameLevel(6)
		point.status:SetInside()
	end
	--
	local color = GetColor(self.settings.colors, index, UI.ClassColor())
	if self.settings.filled == true then
		point.status:SetStatusBarColor(unpack(color))
		point.status:Show()
		point:SetBackdropBorderColor(unpack(UI.BorderColor))
	else
		point:SetBackdropBorderColor(unpack(color))
		if point.status then point.status:Hide() end
	end
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
		self:UpdatePointGraphics(i, width, height, spacing)
	end
end

-- overridden methods
function plugin:Initialize()
	-- set defaults
	self.settings.count = self.settings.count or 1 -- starts with count = 1 if count not found in settings
	self.settings.filled = DefaultBoolean(self.settings.filled, false)
	self.settings.powerType = self.settings.powerType or SPELL_POWER_HOLY_POWER --
	self.settings.colors = self.settings.colors or self.settings.color or UI.PowerColor(self.settings.powerType) or UI.ClassColor()

	self:SetCounts()
end

function plugin:Enable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", plugin.UpdateVisibility)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", plugin.UpdateVisibility)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", plugin.UpdateVisibility)
	self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player", plugin.UpdateVisibility)

	self:RegisterUnitEvent("UNIT_POWER", "player", plugin.UpdateValue)
	self:RegisterEvent("UNIT_MAXPOWER", plugin.SetCounts)
	self:RegisterUnitEvent("UNIT_MAXPOWER", "player", plugin.UpdateValue)
end

function plugin:Disable()
	--
	self:UnregisterAllEvents()
	--
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