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
		assert(target[key] == nil or (type(target[key] == type(target))))
		target[key] = value
		return
	end

	local t = target[key]
	for _, v in pairs(value) do
		merge(v, t, key)
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

function module.refactorAbilities(abilities)
	for ability in abilities do
	end
end

local function assignText(ability, text)
	for _, tierData in iStringPairs(ability) do
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
		if ability.meta then
			assignText(ability.meta, text)
		end
	end
end

return module
