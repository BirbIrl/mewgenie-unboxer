local module = {}

function module.make(text)
	local mewgenie = {}
	mewgenie.stats = {
		str = "Strength",
		dex = "Dexterity",
		con = "Constitution",
		int = "Intelligence",
		cha = "Charisma",
		spd = "Speed",
		lck = "Luck",
	}

	mewgenie.blacklist = {
		passives = {
			"EyeCatchin",
			"DeathChill",
			"LongStrider",
			"Deathless",
			"STARTER_PLACEHOLDER_Butcher",
			"STARTER_PLACEHOLDER_Colorless",
			"STARTER_PLACEHOLDER_Druid",
			"STARTER_PLACEHOLDER_Fighter",
			"STARTER_PLACEHOLDER_Hunter",
			"STARTER_PLACEHOLDER_Jester",
			"STARTER_PLACEHOLDER_Mage",
			"STARTER_PLACEHOLDER_Medic",
			"STARTER_PLACEHOLDER_Monk",
			"STARTER_PLACEHOLDER_Necromancer",
			"STARTER_PLACEHOLDER_Psychic",
			"STARTER_PLACEHOLDER_Tank",
			"STARTER_PLACEHOLDER_Thief",
			"STARTER_PLACEHOLDER_Tinkerer",
		},
		abilities = {
			"Double",
			"Enlarge",
			"Heathens",
			"FireArmor",
			"IceArmor",
			"Purge",
			"DoubleLoot",
			"Camouflage",
			"STARTER_PLACEHOLDER_Butcher",
			"STARTER_PLACEHOLDER_Colorless",
			"STARTER_PLACEHOLDER_Druid",
			"STARTER_PLACEHOLDER_Fighter",
			"STARTER_PLACEHOLDER_Hunter",
			"STARTER_PLACEHOLDER_Jester",
			"STARTER_PLACEHOLDER_Mage",
			"STARTER_PLACEHOLDER_Medic",
			"STARTER_PLACEHOLDER_Monk",
			"STARTER_PLACEHOLDER_Necromancer",
			"STARTER_PLACEHOLDER_Psychic",
			"STARTER_PLACEHOLDER_Tank",
			"STARTER_PLACEHOLDER_Thief",
			"STARTER_PLACEHOLDER_Tinkerer",
			"STARTER_PLACEHOLDER_Fighter",
			"ATTACK_PLACEHOLDER_JesterBasic",
			"Metronome_Enemy", --these three are temporary until we figure out a system to get rid of
			"DCBirthSquirrel",
			"PsychicChoke_Enemy",
			"Parasaurolophus_Push",
			"NCReanimate",
			"Endeavor_Auto",
			"DCAeroblast",
			"MCHadouken",
			"SM_MagicMissile",
			"TCMechSuit",
			"TCCatBot",
			"NCGravecrawl",
			"DruidCatBasic",
			"head_MiniMoonArmorAsteroid",
		}
	}

	mewgenie.collarOrder = {
		"Colorless", "Fighter", "Hunter", "Mage", "Tank", "Medic", "Thief", "Necromancer", "Tinkerer", "Butcher", "Druid",
		"Psychic", "Monk", "Jester", "Disorder"
	}

	--TODO: move collars out of here, and define themn in their own file with more info
	mewgenie.collars = {}
	for _, nameId in ipairs(mewgenie.collarOrder) do
		local collarInfo = {}
		mewgenie.collars[nameId] = collarInfo
		collarInfo.name = text["CAT_CLASS_" .. nameId:upper() .. "_NAME"]
		collarInfo.desc = text["CAT_CLASS_" .. nameId:upper() .. "_DESC"]
	end

	mewgenie.languages = {
		en = "English",
		sp = "Spanish",
		fr = "French",
		de = "German",
		it = "Italian",
		ptbr = "Brazilian Portuguese"
	}
	return mewgenie
end

return module



--[[
---@enum mewgenie.element
mewgenie.types.element = {
	Water = "Water",
	Fire = "Fire",
	Explosion = "Explosion",
	Ice = "Ice",
}

---@enum mewgenie.effect
mewgenie.types.effect = {
	Stun = "Stun",
	Burn = "Burn",
	Freeze = "Freeze",
	Trample = "Trample",
	IgnoreSelf = "Ignore Self",
}

---@enum mewgenie.target_mode
mewgenie.types.target_mode = {
	direction = "Cardinal direction",
}

---@enum mewgenie.aoe_mode
mewgenie.types.aoe_mode = {
	line = "Line"
}

---@enum mewgenie.aoe_restriction
mewgenie.types.aoe_restriction = {
	must_have_line_of_sight_unpurgable = "Must have line of sight (unpurgable)",
	none = "None",
}

---@enum mewgenie.knockback_mode
mewgenie.types.knockback_mode = {
	character_to_tile = "Character to tile"
}

---@enum mewgenie.restriction
mewgenie.types.knobckback_mode = {
	must_be_moveable = "Must be movable",
	must_have_tag = "Must have assigned tag",
	must_move = "Must move",
}

---@enum mewgenie.tags
mewgenie.types.knobckback_mode = {
	food = "Food"
}


---@enum mewgenie.templates
mewgenie.types.templates = {
	melee_attack = "Melee attack",
	lobbed_attack = "Lobbed attack",
	ranged_attack = "Ranged attack",
	straightshot_attack = "Straightshot attack",
	dash_attack = "Dash attack",
	self_buff = "Self buff",
	spell = "Spell",
}

---@class mewgenie.description
---@field en string
---@field sp string
---@field fr string
---@field de string
---@field it string
---@field pt-br string


---@class mewgenie.passive
---@field class mewgenie.class
---@field desc mewgenie.description
---@field name mewgenie.description


---@class mewgenie.abilities
---@field template mewgenie.templates
---@field meta {name: mewgenie.description, desc: mewgenie.description, class: mewgenie.class}
---@field cost {mana: integer, infcantrip?: boolean}
---@field target {target_mode?: mewgenie.target_mode, restrictions: mewgenie.restrictions, max_aoe?: integer, max_range?: integer, aoe_considers_character_size?: boolean, aoe_excludes_self?: boolean, knockback_mode?: mewgenie.knockback_mode}
---@field damage_instance? {damage?: integer, knockback?: integer, elements?: mewgenie.element[],  effects?: table<mewgenie.effect,any>}
---@field temporary_effects table<mewgenie.effect,any>



--]]
