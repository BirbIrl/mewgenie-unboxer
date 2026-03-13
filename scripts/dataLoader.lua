local sh = require("lib.shellUtils")
local paths = require("lib.paths")
local eggon = require("lib.eggon")

local module = {}


function module.load()
	local passives = {}
	local abilities = {}
	local unlocks = {}
	for _, path in ipairs(paths.data.gon.passives) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			passives[key] = value
		end
	end

	for _, path in ipairs(paths.data.gon.abilities) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			abilities[key] = value
		end
	end

	local parsed = eggon.parse(sh.read(paths.data.gon.unlocks))
	for key, value in pairs(parsed) do
		unlocks[key] = value
	end

	return passives, abilities, unlocks
end

return module
