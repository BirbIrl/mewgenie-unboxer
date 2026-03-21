local iconExtractor = require("scripts.iconExtractor")
local svgAdjuster = require("scripts.svgAdjuster")
local sh = require("lib.shellUtils")
local dataLoader = require("scripts.dataLoader")
local langLoader = require("scripts.langLoader")
local json = require("lib.json")
local paths = require("lib.paths")
local shellMaker = require("scripts.shellMaker")
local fontExtractor = require("scripts.fontExtractor")
local dataTransformer = require("scripts.dataTransformer")
local mewgenieMetadataMaker = require("scripts.mewgenieMetadataMaker")
local serpent = require("lib.serpent")


---TODO
---extract items

if sh.stat(paths.mewgenie) then
	if ... == "--force" then
		sh.rm(paths.mewgenie, true)
	else
		error(
			"Please get rid of the existing " ..
			paths.mewgenie .. " folder first, or run this with --force to delete it automatically")
	end
end

sh.mkdir(paths.mewgenie)
iconExtractor.extractAbilities()
svgAdjuster.adjustPassives()
svgAdjuster.adjustSkills()

iconExtractor.extractFontIcons()
svgAdjuster.adjustClasses()

shellMaker.makeShells()

fontExtractor.extractFonts()


local passives, abilities, unlocks, classes, pools = dataLoader.load()

local text = langLoader.load()
local mewgenie = mewgenieMetadataMaker.make(text)

dataTransformer.tweakData(passives, abilities)
dataTransformer.standardizePassives(passives)
abilities = dataTransformer.standardizeAbilities(abilities)
dataTransformer.flattenAbiltiies(abilities)
dataTransformer.applyUnlocks(passives, abilities, unlocks)
dataTransformer.applyText(passives, abilities, text)
dataTransformer.applyBlacklist(passives, abilities, mewgenie.blacklist)
dataTransformer.applyPools(passives, abilities, classes, pools)

sh.write(paths.data.json.passives, json.encode(passives))
sh.write(paths.data.json.abilities, json.encode(abilities))
sh.write(paths.data.json.unlocks, json.encode(unlocks))
sh.write(paths.data.json.classes, json.encode(classes))


sh.write(paths.data.json.mewgenie, json.encode(mewgenie))
