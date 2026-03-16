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

	local unlocks = {}
	for key, value in pairs(eggon.parse(sh.read(paths.data.gon.unlocks))) do
		unlocks[key] = value
	end

	local classes = {}
	for _, path in ipairs(paths.data.gon.classes) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			classes[key] = value
		end
	end

	local pools = {}
	for _, path in ipairs(paths.data.gon.pools) do
		local parsed = eggon.parse(sh.read(path))
		for key, value in pairs(parsed) do
			pools[key] = value
		end
	end


	return passives, abilities, unlocks, classes, pools
end

return module
