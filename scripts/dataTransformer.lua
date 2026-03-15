local json = require("lib.json")
local serpent = require("lib.serpent")
module = {}

function module.tweakData(passives, abilities)
	passives.VoidSoul.class = "Colorless" --temporary fix because it has no class assigned
end

function module.applyUnlocks(passives, abilities, unlocks)
	for unlockName, unlock in pairs(unlocks) do
		local targets
		local pool
		if unlock.unlock_passive then
			pool = passives
			targets = unlock.unlock_passive
			unlock.unlock_passive = nil
		elseif unlock.unlock_ability then
			pool = abilities
			targets = unlock.unlock_ability
			unlock.unlock_ability = nil
			-- elseif unlock.unlock_song then
			--elseif unlock.unlock_item or unlock.unlock_item_immediate then
		else
			goto continue
		end
		if type(targets) ~= "table" then
			targets = { targets }
		end

		local condition = {}
		condition["repeat"] = unlock["repeat"] -- repeat is reserved

		if unlock.complete_chapter_with_class then
			condition.cheapter = unlock.complete_chapter_with_class[1]
			condition.with = unlock.complete_chapter_with_class[2]
		else
			print("Couldn't find an unlock semantic for:")
			print(serpent.block(unlock))
		end
		for _, target in ipairs(targets) do
			for _, levelledTarget in ipairs(pool[target]) do
				levelledTarget.unlock_condition = condition
			end
		end

		::continue::
	end
end

local function iStringPairs(tbl) -- ipairs over string number fields
	local i = 0
	return function()
		i = i + 1
		local key = tostring(i)
		local value = tbl[key]

		if value ~= nil then
			return key, value
		end
	end
end

local function merge(value, target, key)
	if type(target[key]) ~= "table" then
		if target[key] == nil then
			target[key] = value
		end
		return
	end
	if type(value) == "table" then
		local t = target[key]
		for k, v in pairs(value) do
			merge(v, t, k)
		end
	end
end



function module.standardizePassives(passives)
	for name, passive in pairs(passives) do
		if not passive["1"] then
			local tbl = {}
			tbl["1"] = passive
			passive = tbl
		end
		local new = {}
		for tier, levelledPassive in iStringPairs(passive) do
			new[tonumber(tier)] = levelledPassive
			for key, value in pairs(passive) do
				if not tonumber(key) then
					levelledPassive[key] = levelledPassive[key] or value
				end
			end
		end
		for key, _ in pairs(passive) do
			if not tonumber(key) then
				passive[key] = nil
			end
		end
		passives[name] = new
	end
end

---@param abilities table<string, table>
function module.standardizeAbilities(abilities)
	local standardizedAbilities = {}
	for abilityName, ability in pairs(abilities) do
		if tonumber(abilityName:sub(-1, -1)) then
			goto continue
		end
		local full = {}
		full[1] = ability
		local i = 2
		while abilities[abilityName .. i] do
			full[i] = abilities[abilityName .. i]
			i = i + 1
		end

		for tier, levelledAbility in ipairs(full) do
			levelledAbility.templateClass = levelledAbility.class -- renaming the templateClass field for my own needs
			levelledAbility.class = nil
			if not levelledAbility.meta then
				goto continue
			end
			for key, value in pairs(levelledAbility.meta) do
				levelledAbility[key] = value
			end
			levelledAbility.tier = tonumber(tier)
			levelledAbility.name = abilityName
			levelledAbility.meta = nil
			::continue::
		end

		standardizedAbilities[abilityName] = full
		::continue::
	end
	for _, ability in pairs(standardizedAbilities) do
		for _, levelledAbility in ipairs(ability) do
			module.assignDependencies(levelledAbility, standardizedAbilities)
		end
	end
	return standardizedAbilities
end

local function shallowCopy(tbl)
	local new = {}
	for key, value in pairs(tbl) do
		new[key] = value
	end
	return new
end

function module.assignDependencies(ability, abilities)
	local parentName = nil
	if ability.variant_of then
		parentName = ability.variant_of
		ability.variant_of = nil
	elseif ability.template then
		parentName = "template_" .. ability.template
		ability.template = nil
	else
		return
	end
	-- all variant_of's use the first level of the ability
	assert(not tonumber(parentName:sub(-1, -1)), "the code doesn't expect a parent of an ability to have a level")
	local parent = abilities[parentName][1]
	module.assignDependencies(parent, abilities)
	ability.ancestors = shallowCopy(parent.ancestors or {})
	table.insert(ability.ancestors, 1, parentName)
end

function module.flattenAbiltiies(abilities)
	for _, ability in pairs(abilities) do
		for _, levelledAbility in ipairs(ability) do
			if not levelledAbility.ancestors then
				goto continue
			end
			for _, ancestorName in ipairs(levelledAbility.ancestors) do
				for key, value in pairs(abilities[ancestorName][1]) do
					merge(value, levelledAbility, key)
				end
			end
			::continue::
		end
	end
end

function module.applyBlacklist(passives, abilities, blacklist)
	for _, name in ipairs(blacklist.passives) do
		for _, levelledPassive in ipairs(passives[name]) do
			levelledPassive.blacklisted = true
		end
	end

	for _, name in ipairs(blacklist.abilities) do
		for _, levelledAbility in ipairs(abilities[name]) do
			levelledAbility.blacklisted = true
		end
	end

	for name, ability in pairs(abilities) do
		if name:sub(1, 9) == "template_" then
			for _, levelledAbility in ipairs(ability) do
				levelledAbility.blacklisted = true
			end
		end
	end
end

local function assignText(ability, text)
	for _, tierData in ipairs(ability) do
		if tierData.desc then
			tierData.desc = text[tierData.desc]
		else
			tierData.desc = text[ability.desc]
		end
		if tierData.desc_multiclass then
			tierData.desc_multiclass = text[tierData.desc_multiclass]
		else
			tierData.desc_multiclass = text[ability.desc_multiclass]
		end
		if tierData.name then
			tierData.name = text[tierData.name]
		else
			tierData.name = text[ability.name]
		end
	end
	ability.name = nil
	ability.desc = nil
	ability.desc_multiclass = nil
end

function module.applyText(passives, abilities, text)
	for _, passive in pairs(passives) do
		assignText(passive, text)
	end

	for _, ability in pairs(abilities) do
		assignText(ability, text)
	end
end

return module
