local ADDON_NAME, Engine = ...
local L = Engine.Locales
local UI = Engine.UI

if Engine.Enabled then return end -- UI already found

if not ElvUI then return end -- ElvUI detected

Engine.Enabled = true -- ElvUI found

------------
--- ElvUI
------------
local E, _, _, P, _, _ = unpack(ElvUI)
--local E = unpack(ElvUI)

local UF = E:GetModule("UnitFrames")

--UI.BorderColor = P.general.bordercolor
UI.BorderColor = E["media"].bordercolor
UI.NormTex = [[Interface\AddOns\ElvUI\media\textures\normTex2.tga]]
--UI.NormTex = E["media"].normTex
--print("NormTex: "..tostring(UI.NormTex))
UI.MyClass = E.myclass
UI.MyName = E.myname
UI.Border = E.Border

-- Hider Secure (mostly used to hide stuff while in pet battle)  ripped from Tukui
local petBattleHider = CreateFrame("Frame", "ElvUIClassMonitorPetBattleHider", UIParent, "SecureHandlerStateTemplate")
petBattleHider:SetAllPoints(UIParent)
RegisterStateDriver(petBattleHider, "visibility", "[petbattle] hide; show")
UI.PetBattleHider = petBattleHider

UI.SetFontString = function(parent, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate(nil, fontHeight, fontStyle)
	return fs
end

------Reset popup
local function Reset()
	-- delete data per char
	for k, v in pairs(ClassMonitorDataPerChar) do
		ClassMonitorDataPerChar[k] = nil
	end
	-- delete data per realm
	for k, v in pairs(ClassMonitorData) do
		ClassMonitorData[k] = nil
	end
	-- reload
	ReloadUI()
end

E.PopupDialogs["CLASSMONITOR_RESET"] = {
	text = L.classmonitor_command_reset,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = Reset,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

UI.StaticPopup_Reset_show = function() E:StaticPopup_Show("CLASSMONITOR_RESET") end
------

UI.ClassColor = function(className)
	local class = className or E.myclass
	local color = RAID_CLASS_COLORS[class]
	return E:GetColorTable(color)
end

UI.PowerColor = function(resourceName)
	local color
	color = P.unitframe.colors.power[resourceName]
--print("resourceName:"..tostring(resourceName).."  "..tostring(color and color.r).."  "..tostring(color and color.g).."  "..tostring(color and color.b))
	if color then
		return E:GetColorTable(color)
	end
end

UI.HealthColor = function(unit)
	local color = {1, 1, 1, 1}
	-- if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		-- color = UF.db.colors.tapped
	if not UnitIsConnected(unit) then
		color = UF.db.colors.disconnected
	elseif UnitIsPlayer(unit) or (UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local class = select(2, UnitClass(unit)) or E.MyClass
		color = RAID_CLASS_COLORS[class]
	elseif UnitReaction(unit, "player") then
		local reaction = UnitReaction(unit, "player")
		if 1 == reaction or 2 == reaction or 3 == reaction then
			color = UF.db.colors.reaction.GOOD
		elseif 4 == reaction then
			color = UF.db.colors.reaction.NEUTRAL
		elseif 5 == reaction or 6 == reaction or 7 == reaction or 8 == reaction then
			color = UF.db.colors.reaction.BAD
		end
		--color = UF.db.colors.reaction[UnitReaction(unit, "player")]
	end
	return E:GetColorTable(color)
end

UI.CreateMover = function(name, width, height, anchor, text)
	local holder = CreateFrame("Frame", name.."HOLDER", UIParent)
	holder:Size(width, height)
	holder:Point(unpack(anchor))

	E:CreateMover(holder, name, text, true)--snapOffset, postdrag, moverTypes)

	--return holder
	return E.CreatedMovers[name].mover -- we need the mover for multiple anchors
end

UI.Move = function()
	E:ToggleConfigMode() -- Call MoveUI from ElvUI
	return true
end