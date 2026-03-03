local sh = require("lib.shellUtils")
local paths = require("lib.paths")
local module = {}


local function escape(str)
	return str:gsub("([^%w])", "%%%1")
end

-- the lion doesn't concern himself with editing raw xml files without a library
function module.adjustPassives()
	for _, filename in ipairs(sh.ls(paths.assets.final.passive)) do
		local reader = assert(io.open(paths.assets.final.passive .. "/" .. filename, "r"), "couldn't open file")
		---@type string
		local svg = reader:read("a")
		reader:close()

		local writer = assert(io.open(paths.assets.final.passive .. "/" .. filename, "w"), "couldn't open file")
		svg = svg:gsub('transform="matrix%(1.0, 0.0, 0.0, 1.0, 40.45, 7.95%)"', 'transform="translate(2,2)"')
		svg = svg:gsub('height="55.8px" width="120.75px"', 'height="44.33px" width="78.6px"')
		writer:write(svg)
		writer:close()
	end
end

function module.adjustSkills()
	for _, filename in ipairs(sh.ls(paths.assets.final.ability)) do
		local reader = assert(io.open(paths.assets.final.ability .. "/" .. filename, "r"), "couldn't open file")
		---@type string
		local svg = reader:read("a")
		reader:close()

		local writer = assert(io.open(paths.assets.final.ability .. "/" .. filename, "w"), "couldn't open file")

		svg = svg:gsub('transform="matrix%(1.0, 0.0, 0.0, 1.0, 3.45, 10.4%)"', 'transform="translate(1.5,1.5)"')
		svg = svg:gsub('height="70.55px" width="71.35px"', 'height="60.5px" width="67px"')
		writer:write(svg)
		writer:close()
	end
end

function module.adjustClasses()
	for _, filename in ipairs(sh.ls(paths.assets.final.collars)) do
		if filename:find("Scaled") then
			goto continue
		end
		local path = paths.assets.final.collars .. "/" .. filename
		local svg = sh.read(path)
		local it = svg:gmatch("matrix%(.-%)")
		it()
		local matrixString = it()
		local newString = matrixString
		for number in matrixString:gmatch("-?[%d%.]+") do
			newString = newString:gsub(number, number * 1.35, 1) -- the lion doesn't concern himself with collissions
		end
		sh.write(path:sub(0, -5) .. "Scaled.svg", svg:gsub(escape(matrixString), newString, 1))
		::continue::
	end
end

return module
