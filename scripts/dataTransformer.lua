module = {}

function module.tweakData(passives, abilities)
	passives.VoidSoul.class = "Colorless" --temporary fix because it has no class assigned
end

function module.applyUnlocks(passives, abilities, unlocks)

end

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

function module.applyText(passives, abilities, text)
	for _, passive in pairs(passives) do
		assignText(passive, text)
	end

	for _, ability in pairs(abilities) do
		if ability.meta then
			assignText(ability.meta, text)
		end
	end
end

return module
