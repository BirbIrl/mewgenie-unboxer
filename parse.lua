local serpent = require("lib.serpent")
local eggon = require("lib.eggon")
local iconExtractor = require("scripts.iconExtractor")
local svgAdjuster = require("scripts.svgAdjuster")
local sh = require("lib.shellUtils")
local dataLoader = require("scripts.dataLoader")
local langLoader = require("scripts.langLoader")
local json = require("lib.json")
local paths = require("lib.paths")
local shellMaker = require("scripts.shellMaker")
local fontExtractor = require("scripts.fontExtractor")


local function assignText(ability, text)
	if ability.desc then
		ability.desc = text[ability.desc]
	end
	if ability.name then
		ability.name = text[ability.name]
	end
	local i = 1
	while ability[tostring(i)] do
		local key = tostring(i)
		if ability[key].desc then
			ability[key].desc = text[ability[key].desc]
		end
		if ability[key].name then
			ability[key].name = text[ability[key].name]
		end
		i = i + 1
	end
end



if sh.stat(paths.mewgenie) then
	if ... == "--force" then
		sh.rm(paths.mewgenie, true)
	else
		error(
			"Please get rid of the existing " ..
			paths.mewgenie .. " folder first, or run this with --force to delete it automatically")
	end
end


iconExtractor.extractAbilities()
svgAdjuster.adjustPassives()
svgAdjuster.adjustSkills()
svgAdjuster.adjustClasses()

local passives, abilities = dataLoader.load()

local text = langLoader.load()


for _, passive in pairs(passives) do
	assignText(passive, text)
end

passives.VoidSoul.class = "Colorless" --temporary fix because it has no class assigned

for _, ability in pairs(abilities) do
	assignText(ability, text)
end


local abilitiesFile = assert(io.open(paths.data.json.abilities, "w"))
abilitiesFile:write(json.encode(abilities))
abilitiesFile:close()

local passivesFile = assert(io.open(paths.data.json.passives, "w"))
passivesFile:write(json.encode(passives))
passivesFile:close()


iconExtractor.extractFontIcons()


shellMaker.makeShells()

fontExtractor.extractFonts()

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


sh.write(paths.mewgenie .. "/mewgenie.json", json.encode(mewgenie))



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
