local sh = require("lib.shellUtils")
local paths = require("lib.paths")
local eggon = require("lib.eggon")

local module = {}


function module.load()
	local passives = {}
	for _, path in ipairs(paths.data.gon.passives) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			passives[key] = value
		end
	end

	local abilities = {}
	for _, path in ipairs(paths.data.gon.abilities) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			abilities[key] = value
		end
	end

	local abilityTemplates = {}
	for key, value in pairs(eggon.parse(sh.read(paths.data.gon.abilityTemplates))) do
		abilityTemplates[key] = value
	end

	local unlocks = {}
	for key, value in pairs(eggon.parse(sh.read(paths.data.gon.unlocks))) do
		unlocks[key] = value
	end

	return passives, abilities, abilityTemplates, unlocks
end

return module
