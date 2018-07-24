local ADDON_NAME, Engine = ...
if not Engine.Enabled then return end

local L = Engine.Locales

Engine.Config = {
--[[
	name = frame name (can be used in anchor)
	displayName = name displayed in config
	kind = MOVER | RESOURCE | COMBO | POWER | AURA | RUNES | ECLIPSE | ENERGIZE | HEALTH  | DOT | TOTEMS | BANDITSGUILE | STAGGER | TANKSHIELD | BURNINGEMBERS | DEMONICFURY
	enable = true|false												no need to explain [default: true] (plugin will be created but never displayed, this allow other plugin to anchor it. Temporary easy fix to handle this problem)
	verticalIndex = number (-20->20)	[default:0]					in automatic anchor mode, these indices are used to order frames vertically (frame with index 0 (or lowest positive or highest negative) is anchored on mover)
	horizontalIndex = number (0->9)		[default:0]					in autoanchor mode, if 2 frames have similar verticalIndex, these indices are used to order frames horizontally (if both horizontal and vertical are identical, frames are overlapped)

	MOVER	create a mover in Tukui/ElvUI to be able to move bars via /moveui
	主框体
	text = string													text to display in config mode
	width = number													width of anchor bar
	height = number													height of anchor bar

	RESOURCE (mana/runic power/energy/focus/rage/chi):
	主资源
	text = true|false												display resource value (% for mana) [default: true]
	autohide = true|false											hide or not while out of combat [default: false]
	hideifmax = true|false											hide when current value = max value [default: false]
	anchor 	=														see note below
	width = number													width of resource bar [default: 85]
	height = number													height of resource bar [default: 16]
	color|colors =													see note below [default: tukui power color]
	specs = 														see note below [default: any]

	COMBO:
	连击点
	autohide = true|false											hide or not while out of combat [default: true]
	anchor =														see note below
	width = number													bar total width (combo * count + spacing * count-1)
	height = number													height of combo point [default: 16]
	color|colors =													see note below [default: class color]
	filled = true|false												is combo point filled or not [default: false]
	smooth = true|false                                             color smoothly with count [default: false]
	specs = 														see note below [default: any]

	POWER (holy power/soul shard/light force, ...):
	职业特殊能量
	autohide = true|false											hide or not while out of combat [default: false]
	powerType = SPELL_POWER_HOLY_POWER|SPELL_POWER_SOUL_SHARDS|SPELL_POWER_LIGHT_FORCE|SPELL_POWER_SHADOW_ORBS	power to monitor (can be any power type (http://www.wowwiki.com/PowerType) for SPELL_POWER_BURNING_EMBERS|SPELL_POWER_DEMONIC_FURY, use specific plugin
	count = number													max number of points to display
	anchor =														see note below
	--width = number													width of power point [default: 85]
	width = number													bar total width (point * count + spacing * count-1)
	height = number													height of power point [default: 16]
	--spacing = number												space between power points [default: 3]
	color|colors =													see note below [default: class color]
	filled = true|false												is power point filled or not [default: false]
	specs = 														see note below [default: any]

	AURA (buff/debuff):
	光环
	autohide = true|false											hide or not while out of combat [default: true]
	unit = "player"|"target"|"focus"|"pet"							check aura on this unit [default:"player"]
	spellID = number												spell id of buff/debuff to monitor
	filter = "HELPFUL" | "HARMFUL"									BUFF or DEBUFF
	count = number													max number of stack to display
	anchor =														see note below
	--width = number													width of buff stack or bar[default: 85]
	width = number													bar total width (stack * count + spacing * count-1)
	height = number													height of buff stack or bar [default: 16]
	--spacing = number												space between buff stack if no bar[default: 3]
	color|colors =													see note below [default: class color]
	filled = true|false												is buff stack filled or not if no bar[default: false]

	AURABAR (buff/debuff):
	光环-计时条样式
	autohide = true|false											hide or not while out of combat [default: true]
	unit = "player"|"target"|"focus"|"pet"							check aura on this unit [default:"player"]
	spellID = number												spell id of buff/debuff to monitor
	filter = "HELPFUL" | "HARMFUL"									BUFF or DEBUFF
	anchor =														see note below
	width = number													width of bar[default: 85]
	height = number													height of bar [default: 16]
	color =															see note below [default: class color]
	text = true|false												display current/max stack in status bar [default:true]
	duration = true|false											display buff|debuff time left in status bar [default:false]
	specs = 														see note below [default: any]

	RUNES
	DK-符文
	updatethreshold = number										interval between runes display update [default: 0.1]
	autohide = true|false											hide or not while out of combat [default: false]
	orientation = "HORIZONTAL" | "VERTICAL"							direction of rune filling display [default: HORIZONTAL]
	anchor =														see note below
	--width = number													width of rune [default: 85]
	width = number													bar total width (rune * count + spacing * count-1)
	height = number													height of rune [default: 16]
	--spacing = number												space between runes [default: 3]
	colors = { blood, unholy, frost, death }						color of runes
	runemap = { 1, 2, 3, 4, 5, 6 }									see instruction in DEATHKNIGHT section

	ECLIPSE
	日月食-已删除
	autohide = true|false											hide or not while out of combat [default: false]
	text = true|false												display eclipse direction [default: true]
	anchor=															see note below
	width = number													width of eclipse bar [default: 85]
	height = number													height of eclipse bar [default: 16]
	colors = { lunar, solar }										color of lunar and solar bar

	ENERGIZE
	内置CD
	anchor = 														see note below
	text = true|false												display energize value (% for mana) [default: true]
	autohide = true|false											hide or not while out of combat [default: false]
	width = number													width of energize bar [default: 85]
	height = number													height of energize bar [default: 16]
	color =															see note below [default: class color]

	HEALTH
	血量
	unit = "player"|"target"|"focus"|"pet"							check aura on this unit [default:"player"]
	anchor = 														see note below
	autohide = true|false											hide or not while out of combat [default: true]
	width = number													width of health bar [default: 85]
	height = number													height of health bar [default: 16]
	color =															see note below [default: class color]
	specs = 														see note below [default: any]

	DOT
	DOT
	autohide = true|false											hide or not while out of combat [default: true]
	anchor = 														see note below
	width = number													width of dot bar [default: 85]
	height = number													height of dot bar [default: 16]
	spellID = number												spell id of dot to monitor
	latency = true|false											indicate latency on buff (useful for ignite)
	threshold = number or 0											threshold to work with colors [default: 0]
	colors = array of array :
		{
			{255/255, 165/255, 0, 1},								bad color : under 75% of threshold -- here orange -- [default: class color]
			{255/255, 255/255, 0, 1},								intermediate color : 0,75% of threshold -- here yellow -- [default: class color]
			{127/255, 255/255, 0, 1},								good color : over threshold -- here green -- [default: class color]
		},
	color = {r, g, b, a}											if treshold is set to 0	[default: class color]
	specs = 														see note below [default: any]

	TOTEMS (totems or wildmushrooms):
	仆从生物（图腾，蘑菇）
	autohide = true|false											hide or not while out of combat [default: false]
	anchor = 														see note below
	--width = number													width of totem bar [default: 85]
	width = number													bar total width (totem * count + spacing * count-1)
	height = number													height of totem bar [default: 16]
	--spacing = number												spacing between each totems [default: 3]
	count = number													number of totems (4 for shaman totems, 3 for druid mushrooms)
	color|colors =													see note below [default: class color]
	specs = 														see note below [default: any]
	text = true|false												display totem duration left [default:false]
	map = array of number											totem remapping
		example: { 2, 1, 3, 4 }										display second totem, followed by first totem, then third and fourth

	BANDITSGUILE:
	dz-盗匪之诈-已删除
	autohide = true|false											hide or not while out of combat [default: true]
	anchor =														see note below
	--width = number													width of bandit's guilde charge [default: 85]
	width = number													bar total width (point * count + spacing * count-1)
	height = number													height of bandit's guilde charge [default: 16]
	--spacing = number												space between bandit's guilde charge [default: 3]
	color|colors =													see note below [default: class color]
	filled = true|false												is bandit's guilde charge filled or not [default: false]

	STAGGER
	monk-醉拳
	autohide = true|false											hide or not while out of combat [default: true]
	anchor =														see note below
	width = number													width of stagger bar [default: 85]
	height = number													height of stagger bar [default: 16]
	text = true|false												display value and % [default:true]
	colors =														colors of 3 states (light, moderate and heavy)
	threshold = number (%)											above this value, bar state is meaningless, below this value, bar state is meaningful [default: 100]

	TANKSHIELD (Warrior: Shield Barrier, Monk: Guard, Deathknight: Blood Shield, Paladin: Sacred Shield):
	吸收盾
	autohide = true|false											hide or not while out of combat [default: true]
	anchor =														see note below
	width = number													width of bar[default: 85]
	height = number													height of bar [default: 16]
	color =															see note below [default: class color]
	duration = true|false											display time left in status bar [default:false]
	specs = 														see note below [default: any]

	BURNINGEMBERS:
	余烬-已删除
	autohide = true|false											hide or not while out of combat [default: false]
	anchor =														see note below
	--width = number													width of power point [default: 85]
	width = number													bar total width (point * count + spacing * count-1)
	height = number													height of power point [default: 16]
	--spacing = number												space between power points [default: 3]
	color|colors =													see note below [default: class color]
	filled = true|false												is power point filled or not [default: false]

	DEMONICFURY:
	恶魔能量-已删除
	autohide = true|false											hide or not while out of combat [default: false]
	anchor =														see note below
	--width = number													width of power point [default: 85]
	width = number													bar total width (point * count + spacing * count-1)
	height = number													height of power point [default: 16]
	color =															bar color [default: Tukui demonic fury power color)
	text = true|false												display value and % [default:true]

	Notes about anchor
	anchor = { "POSITION", parent, "POSITION", offsetX, offsetY }

	Notes about color
	color = {r, g, b, a}
		-> same color for every point (if no color is specified, raid class color will be used)
	colors = { { {r, g, b, a}, {r, g, b, a}, {r, g, b, a}, ...{r, g, b, a} }
		-> one different color by point (for kind COMBO/AURA/POWER)
	colors = { [RESOURCE_TYPE] = {r, g, b, a}, [RESOURCE_TYPE] = {r, g, b, a}, ...[RESOURCE_TYPE] = {r, g, b, a}}
		-> one different color by resource type (only for kind RESOURCE) (if no color is specified, default resource color will be used)

	Notes about spec
	specs = {table of spec} -> only shown when in any of the specified spec  or {"any"}
--]]
	["DRUID"] = {
		{ -- 1
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{ -- 2
			name = "CM_RESOURCE",
			displayName = L.classmonitor_RESOURCEBAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
		},
		{ -- 3
			name = "CM_COMBO",
			displayName = L.classmonitor_COMBOPOINTS,
			kind = "COMBO",
			anchor = { "BOTTOMLEFT", "CM_RESOURCE", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			--spacing = 3,
			colors = {
				{0.69, 0.31, 0.31, 1}, -- 1
				{0.65, 0.42, 0.31, 1}, -- 2
				{0.65, 0.63, 0.35, 1}, -- 3
				{0.46, 0.63, 0.35, 1}, -- 4
				{0.33, 0.63, 0.33, 1}, -- 5
			},
			filled = false,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
	},
	["PALADIN"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		--{
		--	name = "CM_HEALTH",
		--	kind = "HEALTH",
		--	text = true,
		--	autohide = false,
		--	anchor = { "TOP", "CM_MOVER", "BOTTOM", 0, -20},
		--	width = 262,
		--	height = 10,
		--},
		{
			name = "CM_MANA",
			displayName = L.classmonitor_MANABAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262, -- 50 + 3 + 50 + 3 + 50 + 3 + 50 + 3 + 50
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_HOLYPOWER",
			displayName = L.classmonitor_PALADIN_HOLYPOWERBAR,
			kind = "POWER",
			specs = {3},
			powerType = SPELL_POWER_HOLY_POWER,
			count = 5,
			anchor = { "BOTTOMLEFT", "CM_MANA", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			--spacing = 3,
			color = {228/255, 225/255, 16/255, 1},
			filled = true,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
	},
	["WARLOCK"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_MANA",
			displayName = L.classmonitor_MANABAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_SOUL_SHARD",
			displayName = L.classmonitor_WARLOCK_SOULSHARDS,
			kind = "POWER",
			powerType = SPELL_POWER_SOUL_SHARDS,
--			count = 5,
			autohide = false,
			anchor = { "BOTTOMLEFT", "CM_MANA", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			--spacing = 3,
			color = {148/255, 130/255, 201/255, 1},
			filled = true,
--            borderRemind = true,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
		{
			name = "CM_REAP_SOULS",
			displayName = L.classmonitor_WARLOCK_REAPSOULS,
			kind = "AURABAR",
			autohide = true,
			showspellname = false,
			unit = "player",
			spellID = 216708,
			color = {148/255, 130/255, 201/255, 1},
			countFromOther = true,
			countSpellID = 216695,
			filter = "HELPFUL",
			anchor = { "TOPLEFT", "CM_MANA", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			count =	12,
			text = true,
			duration = true,
			specs = {1},
		},
	},
	["ROGUE"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_ENERGY",
			displayName = L.classmonitor_ROGUE_ENERGYBAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_COMBO",
			displayName = L.classmonitor_COMBOPOINTS,
			kind = "COMBO",
			anchor = { "BOTTOMLEFT", "CM_ENERGY", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			-- spacing = 3,
			 colors = {
				 {0.69, 0.31, 0.31, 1}, -- 1
				 {0.33, 0.63, 0.33, 1}, -- 2
			 },
			filled = true,
--			borderRemind = true,
			autohide = false,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
	},
	["PRIEST"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_MANA",
			displayName = L.classmonitor_MANABAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
	},
	["MAGE"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_MANA",
			displayName = L.classmonitor_MANABAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_ARCANE_BLAST",
			displayName = L.classmonitor_MAGE_ARCANE,
			kind = "POWER",
			powerType = SPELL_POWER_ARCANE_CHARGES,
			count = 5,
			autohide = false,
			anchor = { "BOTTOMLEFT", "CM_MANA", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			--spacing = 3,
			--color = {148/255, 130/255, 201/255, 1},
			filled = false,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
	},
	["DEATHKNIGHT"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_RUNIC_POWER",
			displayName = L.classmonitor_DEATHKNIGHT_RUNICPOWER,
			kind = "RESOURCE",
			text = true,
			autohide = true,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_RUNES",
			displayName = L.classmonitor_DEATHKNIGHT_RUNES,
			kind = "RUNES",
			updatethreshold = 0.1,
			autohide = false,
			orientation = "HORIZONTAL",
			anchor = { "BOTTOMLEFT", "CM_RUNIC_POWER", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			duration = true,
			durationTextSize = 12,
			--spacing = 3,
			-- colors = {
				-- { 0.69, 0.31, 0.31, 1 }, -- Blood
				-- { 0.31, 0.45, 0.63, 1 }, -- Frost
				-- { 0.33, 0.59, 0.33, 1 }, -- Unholy
			-- },
			verticalIndex = -1,
			horizontalIndex = 0,
		},
		{
			name = "CM_BLOODSHIELD",
			displayName = L.classmonitor_DEATHKNIGHT_BLOODSHIELD,
			kind = "TANKSHIELD",
			--specs = {1}, -- Blood
			anchor = { "TOPLEFT", "CM_RUNIC_POWER", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			duration = true,
			verticalIndex = 1,
			horizontalIndex = 0,
		},
	},
	["HUNTER"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_FOCUS",
			displayName = L.classmonitor_HUNTER_FOCUS,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
	},
	["WARRIOR"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_RAGE",
			displayName = L.classmonitor_WARRIOR_RAGEBAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_SHIELDBARRIER",
			displayName = L.classmonitor_WARRIOR_SHIELDBARRIER,
			kind = "TANKSHIELD",
			-- specs = {3}, -- Protection
			anchor = { "TOPLEFT", "CM_RAGE", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			duration = true,
			verticalIndex = 1,
			horizontalIndex = 0,
		}
	},
	["SHAMAN"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_MANA",
			displayName = L.classmonitor_MANABAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_TOTEM",
			displayName = L.classmonitor_SHAMAN_TOTEMS,
			kind = "TOTEMS",
			autohide = false,
			anchor = { "TOPLEFT", "CM_RESOURCE", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			--spacing = 3,
			count = 4,
			specs = {4},
			text = true,
		},
	},
	["MONK"] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_RESOURCE",
			displayName = L.classmonitor_RESOURCEBAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_CHI",
			displayName = L.classmonitor_MONK_CHICHARGES,
			kind = "POWER",
			specs = {3},
			powerType = SPELL_POWER_LIGHT_FORCE or 12, -- Bug in 5.1
			count = 5,
			anchor = { "BOTTOMLEFT", "CM_RESOURCE", "TOPLEFT", 0, 3 },
			width = 262,
			height = 16,
			--spacing = 3,
			colors = {
				[1] = {.69, .31, .31, 1},
				[2] = {.65, .42, .31, 1},
				[3] = {.65, .63, .35, 1},
				[4] = {.46, .63, .35, 1},
				[5] = {.33, .63, .33, 1},
			},
			filled = false,
			verticalIndex = -1,
			horizontalIndex = 0,
		},
		{ -- only available is Brewmaster spec
			name = "CM_STAGGER",
			displayName = L.classmonitor_MONK_STAGGERBAR,
			kind = "STAGGER",
			specs = {1},
			text = true,
			autohide = false,
			threshold = 20,
			anchor = { "TOPLEFT", "CM_RESOURCE", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			colors = {
				[1] = {0, .4, 0, 1},
				[2] = {.7, .7, .2, 1},
				[3] = {.9, .2, .2, 1},
			},
			verticalIndex = 2,
			horizontalIndex = 0,
		},
	},
	['DEMONHUNTER'] = {
		{
			name = "CM_MOVER",
			displayName = "Mover",
			kind = "MOVER",
			anchor = { "CENTER", UIParent, "CENTER", 0, -140 },
			width = 262,
			height = 16,
			text = L.classmonitor_move
		},
		{
			name = "CM_RESOURCE",
			displayName = L.classmonitor_RESOURCEBAR,
			kind = "RESOURCE",
			text = true,
			autohide = false,
			anchor = { "TOPLEFT", "CM_MOVER", "TOPLEFT", 0, 0 },
			width = 262,
			height = 16,
			verticalIndex = 0,
			horizontalIndex = 0,
		},
		{
			name = "CM_SOULFRAGMENT",
			displayName = L.classmonitor_DEMONHUNTER_SOULFRAGMENT,
			kind = "AURA",
			autohide = true,
			unit = "player",
			spellID = 203981,
			filter = "HELPFUL",
			count = 5,
			anchor = { "TOPLEFT", "CM_RESOURCE", "BOTTOMLEFT", 0, -3 },
			width = 262,
			height = 16,
			specs = {2},
		},
	},
}