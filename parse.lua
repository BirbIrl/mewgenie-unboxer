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
local dataTransformer = require("scripts.dataTransformer")
local mewgenieMetadataMaker = require("scripts.mewgenieMetadataMaker")





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

iconExtractor.extractFontIcons()
svgAdjuster.adjustClasses()

shellMaker.makeShells()

fontExtractor.extractFonts()


local passives, abilities, unlocks = dataLoader.load()


dataTransformer.tweakData(passives, abilities)
local text = langLoader.load()
dataTransformer.applyText(passives, abilities, text)

dataTransformer.applyUnlocks(passives, abilities, unlocks)

sh.write(paths.data.json.abilities, json.encode(abilities))
sh.write(paths.data.json.passives, json.encode(passives))

local mewgenie = mewgenieMetadataMaker.make(text)

sh.write(paths.data.json.mewgenie, json.encode(mewgenie))
