local sh = require("lib.shellUtils")
local paths = require("lib.paths")

---TODO: these might be innacurate
local activeColors = {
	Colorless = "#76716D",
	Fighter = "#8E5C5C",
	Hunter = "#354B31",
	Mage = "#60607B",
	Tank = "#6B5C3A",
	Medic = "#CBCBCB",
	Thief = "#CDCA91",
	Necromancer = "#1C1D1E",
	Tinkerer = "#91BCB1",
	Butcher = "#8A3746",
	Druid = "#49352C",
	Psychic = "#504361",
	Monk = "#606060",
	Jester = "#b55aa8",
}

local activeCrownColors = {
	Colorless = "#A3A1A0",
	Fighter = "#714848",
	Hunter = "#263623",
	Mage = "#A2A1AF",
	Tank = "#433923",
	Medic = "#C2C0C0",
	Thief = "#AEAB81",
	Necromancer = "#333337",
	Tinkerer = "#91BCB1",
	Butcher = "#642630",
	Druid = "#2F211B",
	Psychic = "#332B3F",
	Monk = "#828282",
	Jester = "#a63d98",
}
local passiveColors = {
	Colorless = "#938D88",
	Fighter = "#B17373",
	Hunter = "#425D3D",
	Mage = "#787899",
	Tank = "#857348",
	Medic = "#FDFDFD",
	Thief = "#FFFBB5",
	Necromancer = "#232425",
	Tinkerer = "#B5EADC",
	Butcher = "#AC4457",
	Druid = "#5B4237",
	Psychic = "#684E78",
	Monk = "#787878",
	Jester = "#dd54cb",
}

local passiveCrownColors = {
	Colorless = "#CBC9C7",
	Fighter = "#8D5959",
	Hunter = "#2F432B",
	Mage = "#CAC8DA",
	Tank = "#53472B",
	Medic = "#FDFDFD",
	Thief = "#FFFBB5",
	Necromancer = "#232425",
	Tinkerer = "#79CEB7",
	Butcher = "#7C2F3C",
	Druid = "#3A2922",
	Psychic = "#40354E",
	Monk = "#A2A2A2",
	Jester = "#a63d98",
}


local module = {}
local shells = paths.assets.unsorted.shells .. "/"
local shellsSorted = paths.assets.final.shells .. "/"

function module.makeShells()
	sh.mkdir(paths.mewgenie .. "/" .. "shells")
	local passive = sh.read(shells .. "shellPassive.svg")
	local passiveClassed = sh.read(shells .. "shellPassiveClassed.svg")
	local passiveCrown = sh.read(shells .. "shellPassiveUpgradeCrown.svg")
	sh.cp(shells .. "shellPassiveDisorder.svg", shellsSorted .. "shellPassiveDisorder.svg")
	sh.cp(shells .. "shellPassiveUpgradePip.svg", shellsSorted .. "shellPassiveUpgradePip.svg")
	sh.write(shellsSorted .. "shellPassiveColorless.svg", passive:gsub("#111111", passiveColors.Colorless))
	for class, color in pairs(passiveColors) do
		if class ~= "Colorless" then
			sh.write(shellsSorted .. "shellPassive" .. class .. ".svg", passiveClassed:gsub("#111111", color))
		end
	end
	for class, color in pairs(passiveCrownColors) do
		sh.write(shellsSorted .. "shellPassiveUpgradeCrown" .. class .. ".svg", passiveCrown:gsub("#666666", color))
	end

	local active = {
		colorless = {
			Small = sh.read(shells .. "shellActiveSmall.svg"),
			Medium = sh.read(shells .. "shellActiveMedium.svg"),
			Large = sh.read(shells .. "shellActiveLarge.svg"),
		},
		classed = {
			Small = sh.read(shells .. "shellActiveSmallClassed.svg"),
			Medium = sh.read(shells .. "shellActiveMediumClassed.svg"),
			Large = sh.read(shells .. "shellActiveLargeClassed.svg"),
		},
		innate = {
			Small = sh.read(shells .. "shellInnateSmall.svg"),
			Medium = sh.read(shells .. "shellInnateMedium.svg"),
			Large = sh.read(shells .. "shellInnateLarge.svg"),
		},
	}
	local passiveCrown = sh.read(shells .. "shellPassiveUpgradeCrown.svg")
	sh.cp(shells .. "shellActiveUpgradePip.svg", shellsSorted .. "shellActiveUpgradePip.svg")
	for size, svg in pairs(active.colorless) do
		sh.write(shellsSorted .. "shellActive" .. size .. ".svg", svg:gsub("#111111", activeColors.Colorless))
	end
	for class, color in pairs(activeColors) do
		if class ~= "Colorless" then
			for size, svg in pairs(active.classed) do
				sh.write(shellsSorted .. "shellActive" .. size .. class .. ".svg",
					svg:gsub("#111111", color))
			end
			for size, svg in pairs(active.innate) do
				sh.write(shellsSorted .. "shellInnate" .. size .. class .. ".svg", svg:gsub("#111111", color))
			end
		end
	end
	for class, color in pairs(activeCrownColors) do
		sh.write(shellsSorted .. "shellActiveUpgradeCrown" .. class .. ".svg", passiveCrown:gsub("#666666", color))
	end
end

return module
