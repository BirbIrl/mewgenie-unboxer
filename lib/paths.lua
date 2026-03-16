local ids = {
	ability = 1346,
	passives = 515,
	collars = 753,
	fontIcons = {
		stimulation = 2685,
		evolution = 2663,
		health = 2665,
		comfort = 2687,
		appeal = 2689,
		divineshield = 2693,
		shield = 2695,
		str = 2704,
		spd = 2707,
		int = 2710,
		dex = 2713,
		con = 2716,
		cha = 2719,
		lck = 3896,
	}

}
local paths = {}
paths.mewgenie = "./mewgenie-data"
paths.assets = {
	unsorted = {
		ability = paths.mewgenie .. "/DefineSprite_" .. ids.ability .. "_AbilityIcon",
		passive = paths.mewgenie .. "/DefineSprite_" .. ids.passives .. "_PassiveIcon",
		collars = paths.mewgenie .. "/DefineSprite_" .. ids.collars .. "_ClassCollar",
		shells = "./static/shells",
		fonts = paths.mewgenie .. "TODO",
	},
	final = {
		ability = paths.mewgenie .. "/abilityIcons",
		passive = paths.mewgenie .. "/passiveIcons",
		collars = paths.mewgenie .. "/collarIcons",
		fontIcons = paths.mewgenie .. "/fontIcons",
		shells = paths.mewgenie .. "/shells",
		fonts = paths.mewgenie .. "/fonts",
	},
	swf = {
		ability = "./mewgenics-data/swfs/ability_icons.swf",
		ui = "./mewgenics-data/swfs/ui.swf",
		fonts = "./mewgenics-data/swfs/fonts.swf",
	}
}
paths.data = {
	json = {
		folder = paths.mewgenie,
		passives = paths.mewgenie .. "/passives.json",
		abilities = paths.mewgenie .. "/abilities.json",
		abilityTemplates = paths.mewgenie .. "/ability_templates.json",
		unlocks = paths.mewgenie .. "/unlocks.json",
		mewgenie = paths.mewgenie .. "/mewgenie.json",
		classes = paths.mewgenie .. "/classes.json",
	},
	csv = {
		"./mewgenics-data/data/text/abilities.csv",
		"./mewgenics-data/data/text/additions2.csv",
		"./mewgenics-data/data/text/additions3.csv",
		"./mewgenics-data/data/text/additions.csv",
		"./mewgenics-data/data/text/cutscene_text.csv",
		"./mewgenics-data/data/text/enemy_abilities.csv",
		"./mewgenics-data/data/text/events.csv",
		"./mewgenics-data/data/text/furniture.csv",
		"./mewgenics-data/data/text/items.csv",
		"./mewgenics-data/data/text/keyword_tooltips.csv",
		"./mewgenics-data/data/text/misc.csv",
		"./mewgenics-data/data/text/mutations.csv",
		"./mewgenics-data/data/text/npc_dialog.csv",
		"./mewgenics-data/data/text/passives.csv",
		"./mewgenics-data/data/text/progression.csv",
		"./mewgenics-data/data/text/pronouns.csv",
		"./mewgenics-data/data/text/teamnames.csv",
		"./mewgenics-data/data/text/units.csv",
		"./mewgenics-data/data/text/weather.csv",
	},
	gon = {
		unlocks = "./mewgenics-data/data/adventure_progression_unlocks.gon",
		classes = {

			"./mewgenics-data/data/classes/classes.gon",
			"./mewgenics-data/data/classes/advanced_classes.gon",
		},
		pools = {
			"./mewgenics-data/data/passive_pools.gon",
			"./mewgenics-data/data/ability_pools.gon",
			"./mewgenics-data/data/event_pools.gon",
		},
		passives = {
			"./mewgenics-data/data/passives/butcher_passives.gon",
			"./mewgenics-data/data/passives/colorless_passives.gon",
			"./mewgenics-data/data/passives/disorders.gon",
			"./mewgenics-data/data/passives/druid_passives.gon",
			"./mewgenics-data/data/passives/fighter_passives.gon",
			"./mewgenics-data/data/passives/hunter_passives.gon",
			"./mewgenics-data/data/passives/jester_passives.gon",
			"./mewgenics-data/data/passives/mage_passives.gon",
			"./mewgenics-data/data/passives/medic_passives.gon",
			"./mewgenics-data/data/passives/monk_passives.gon",
			"./mewgenics-data/data/passives/necromancer_passives.gon",
			"./mewgenics-data/data/passives/psychic_passives.gon",
			"./mewgenics-data/data/passives/tank_passives.gon",
			"./mewgenics-data/data/passives/thief_passives.gon",
			"./mewgenics-data/data/passives/tinkerer_passives.gon",
			"./mewgenics-data/data/passives/util_passives.gon",
		},
		abilities = {
			"./mewgenics-data/data/abilities/abilities.gon",
			"./mewgenics-data/data/abilities/armor_abilities.gon",
			"./mewgenics-data/data/abilities/basic_attacks.gon",
			"./mewgenics-data/data/abilities/basic_movement.gon",
			"./mewgenics-data/data/abilities/butcher_abilities.gon",
			"./mewgenics-data/data/abilities/colorless_abilities.gon",
			"./mewgenics-data/data/abilities/consumable_item_abilities.gon",
			"./mewgenics-data/data/abilities/contextual_abilities.gon",
			"./mewgenics-data/data/abilities/disorder_abilities.gon",
			"./mewgenics-data/data/abilities/druid_abilities.gon",
			"./mewgenics-data/data/abilities/event_abilities.gon",
			"./mewgenics-data/data/abilities/fighter_abilities.gon",
			"./mewgenics-data/data/abilities/finalboss_abilities.gon",
			"./mewgenics-data/data/abilities/guillotina_abilities.gon",
			"./mewgenics-data/data/abilities/hunter_abilities.gon",
			"./mewgenics-data/data/abilities/item_abilities.gon",
			"./mewgenics-data/data/abilities/jester_abilities.gon",
			"./mewgenics-data/data/abilities/kaiju_abilities.gon",
			"./mewgenics-data/data/abilities/mage_abilities.gon",
			"./mewgenics-data/data/abilities/medic_abilities.gon",
			"./mewgenics-data/data/abilities/misc_abilities.gon",
			"./mewgenics-data/data/abilities/monk_abilities.gon",
			"./mewgenics-data/data/abilities/necromancer_abilities.gon",
			"./mewgenics-data/data/abilities/psychic_abilities.gon",
			"./mewgenics-data/data/abilities/rifthead_abilities.gon",
			"./mewgenics-data/data/abilities/special_enemy_abilities.gon",
			"./mewgenics-data/data/abilities/tank_abilities.gon",
			"./mewgenics-data/data/abilities/terminator_abilities.gon",
			"./mewgenics-data/data/abilities/test_abilities.gon",
			"./mewgenics-data/data/abilities/thief_abilities.gon",
			"./mewgenics-data/data/abilities/throbbing_king_abilities.gon",
			"./mewgenics-data/data/abilities/tinkerer_abilities.gon",
			"./mewgenics-data/data/abilities/util_abilities.gon",
			"./mewgenics-data/data/ability_templates/ability_templates.gon" -- templates
		}
	}
}


for key, id in pairs(ids.fontIcons) do
	local path = paths.mewgenie .. "/DefineSprite_" .. id .. "_FontIcon_" .. key
	if key == "divineshield" or key == "shield" then
		path = path:gsub("FontIcon", "RawFontIcon")
	end

	paths.assets.unsorted[key] = path
end
paths.ids = ids

return paths
