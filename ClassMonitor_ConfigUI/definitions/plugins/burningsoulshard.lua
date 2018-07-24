local ADDON_NAME, Engine = ...

local L = Engine.Locales
local D = Engine.Definitions

local color = D.Helpers.CreateColorsDefinition("color", 1, {L.BarColor})

local options = {
	[1] = D.Helpers.Description,
	[2] = D.Helpers.Name,
	[3] = D.Helpers.DisplayName,
	[4] = D.Helpers.Kind,
	[5] = D.Helpers.Enabled,
	[6] = D.Helpers.Autohide,
	[7] = D.Helpers.WidthAndHeight,
	[8] = D.Helpers.Specs,
--	[9] = {
--		key = "powerType",
--		name = L.PowerType,
--		desc = L.PowerTypeDesc,
--		type = "select",
--		values = GetPowerTypes,
--		get = D.Helpers.GetValue,
--		set = D.Helpers.SetValue,
--		disabled = D.Helpers.IsPluginDisabled
--	},
	[11] = {
		key = "filled",
		name = L.Filled,
		desc = L.PowerFilledDesc,
		type = "toggle",
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		disabled = D.Helpers.IsPluginDisabled
	},
	[12] = {
		key = "reverse",
		name = L.Reverse,
		desc = L.ReverseDesc,
		type = "toggle",
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		disabled = D.Helpers.IsPluginDisabled
	},
	[13] = {
		key = "borderRemind",
		name = L.BorderRemind,
		desc = L.ComboBorderRemindDesc,
		type = "toggle",
		get = D.Helpers.GetValue,
		set = D.Helpers.SetValue,
		disabled = D.Helpers.IsPluginDisabled
	},
	[14] = color,
	[15] = D.Helpers.Anchor,
	[16] = D.Helpers.AutoGridAnchor,
}

D.Helpers:NewPluginDefinition("BURNING_SOUL_SHARD", options, L.PluginShortDescription_BURNING_SOUL_SHARD, L.PluginDescription_BURNING_SOUL_SHARD)