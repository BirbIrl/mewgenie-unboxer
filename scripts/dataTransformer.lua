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
			pool[target].unlock_condition = condition
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
	for _, passive in pairs(passives) do
		passive["1"] = passive["1"] or {}
		for key, value in pairs(passive) do
			if tonumber(key) or key == "class" or key == "unlock_condition" then
				goto continue
			end
			for _, levelledPassive in iStringPairs(passive) do
				merge(value, levelledPassive, key)
			end
			passive[key] = nil
			::continue::
		end
	end
end

local function flattenDependencies(ability, abilities, abilityTemplates)
	local parent = nil
	local parentName = nil
	if ability.variant_of then
		parentName = ability.variant_of
		parent = abilities[parentName]
		ability.variant_of = nil
	elseif ability.template then
		parentName = "template_" .. ability.template
		parent = abilityTemplates[parentName]
		ability.template = nil
	else
		return
	end
	for key, value in pairs(parent) do
		merge(value, ability, key)
	end
	ability.parents = ability.parents or {}
	table.insert(ability.parents, 1, parentName)
	flattenDependencies(ability, abilities, abilityTemplates)
end

---@param abilities table<string, table>
---@param abilityTemplates table<string, table>
function module.standardizeAbilities(abilities, abilityTemplates)
	local standardizedAbilities = {}
	for abilityName, ability in pairs(abilities) do
		if tonumber(abilityName:sub(-1, -1)) then
			goto continue
		end
		local full = {}
		full["1"] = ability
		local i = 2
		while abilities[abilityName .. i] do
			full[tostring(i)] = abilities[abilityName .. i]
			i = i + 1
		end

		for _, levelledAbility in iStringPairs(full) do
			flattenDependencies(levelledAbility, abilities, abilityTemplates)
		end

		if ability.meta and ability.meta.class then
			full.class = ability.meta.class
		end

		standardizedAbilities[abilityName] = full
		::continue::
	end
	return standardizedAbilities
end

function module.applyBlacklist(passives, abilities, blacklist)
	for _, name in ipairs(blacklist.passives) do
		passives[name].blacklisted = true
	end

	for _, name in ipairs(blacklist.abilities) do
		abilities[name].blacklisted = true
	end
end

local function assignText(ability, text)
	for _, tierData in iStringPairs(ability) do
		tierData = tierData.meta or tierData
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
