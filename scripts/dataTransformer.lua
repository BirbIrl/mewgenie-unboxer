local json = require("lib.json")
local serpent = require("lib.serpent")
module = {}

function module.tweakData(passives, abilities)
	passives.VoidSoul.class = "Colorless" --temporary fix because it has no class assigned
end

function module.applyUnlocks(passives, abilities, unlocks)
	for id, unlock in pairs(unlocks) do
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
			--elseif unlock.unlock_song then
			--elseif unlock.unlock_item or unlock.unlock_item_immediate then
		else
			goto continue
		end
		if type(targets) ~= "table" then
			targets = { targets }
		end

		local condition = {}
		condition["repeat"] = unlock["repeat"] -- repeat is reserved
		condition.id = id

		if unlock.complete_chapter_with_class then
			condition.cheapter = unlock.complete_chapter_with_class[1]
			condition.with = unlock.complete_chapter_with_class[2]
		else
			print("Couldn't find an unlock semantic for:")
			print(serpent.block(unlock))
		end
		for _, target in ipairs(targets) do
			for _, tieredTarget in ipairs(pool[target]) do
				tieredTarget.unlock_condition = condition
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
	for id, passive in pairs(passives) do
		if not passive["1"] then
			local tbl = {}
			tbl["1"] = passive
			passive = tbl
		end
		local new = {}
		for tier, tieredPassive in iStringPairs(passive) do
			new[tonumber(tier)] = tieredPassive
			tieredPassive.id = id
			tieredPassive.tier = tier
			for key, value in pairs(passive) do
				if not tonumber(key) then
					tieredPassive[key] = tieredPassive[key] or value
				end
				tieredPassive.tier = tonumber(tier)
				tieredPassive.id = id
			end
		end
		for key, _ in pairs(passive) do
			if not tonumber(key) then
				passive[key] = nil
			end
		end
		passives[id] = new
	end
end

---@param abilities table<string, table>
function module.standardizeAbilities(abilities)
	local standardizedAbilities = {}
	for id, ability in pairs(abilities) do
		if tonumber(id:sub(-1, -1)) then
			goto continue
		end
		local abilityTiers = {}
		abilityTiers[1] = ability
		local i = 1
		while abilities[id .. i + 1] do
			i = i + 1
			abilityTiers[i] = abilities[id .. i]
		end
		local maxTier = i

		for tier, tieredAbility in ipairs(abilityTiers) do
			tieredAbility.templateClass = tieredAbility.class -- renaming the templateClass field for my own needs
			tieredAbility.class = nil
			tieredAbility.tier = tonumber(tier)
			tieredAbility.id = id
			tieredAbility.maxTier = maxTier

			if not tieredAbility.meta then
				goto continue
			end
			for key, value in pairs(tieredAbility.meta) do
				tieredAbility[key] = value
			end
			tieredAbility.meta = nil

			::continue::
		end

		standardizedAbilities[id] = abilityTiers
		::continue::
	end
	for _, abilityTiers in pairs(standardizedAbilities) do
		for _, ability in ipairs(abilityTiers) do
			module.assignDependencies(ability, standardizedAbilities)
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
	-- all variant_of's use the first tier of the ability
	assert(not tonumber(parentName:sub(-1, -1)), "the code doesn't expect a parent of an ability to have a tier ")
	local parent = abilities[parentName][1]
	parent.children = parent.children or {}
	table.insert(parent.children, abilities.id)
	module.assignDependencies(parent, abilities)
	ability.ancestors = shallowCopy(parent.ancestors or {})
	table.insert(ability.ancestors, 1, parentName)
	--[[
	if #ability.ancestors > 2 then
		print(serpent.block(ability))
		print(#ability.ancestors)
		print(ability.id)
	end
	--]]
end

function module.flattenAbiltiies(abilities)
	for _, abilityTiers in pairs(abilities) do
		for _, ability in ipairs(abilityTiers) do
			if not ability.ancestors then
				goto continue
			end
			for _, ancestorName in ipairs(ability.ancestors) do
				for key, value in pairs(abilities[ancestorName][1]) do
					merge(value, ability, key)
				end
			end
			::continue::
		end
	end
end

function module.applyBlacklist(passives, abilities, blacklist)
	for _, name in ipairs(blacklist.passives) do
		for _, tieredPassive in ipairs(passives[name]) do
			tieredPassive.blacklisted = true
		end
	end

	for _, name in ipairs(blacklist.abilities) do
		for _, ability in ipairs(abilities[name]) do
			ability.blacklisted = true
		end
	end

	for name, abilityTiers in pairs(abilities) do
		if name:sub(1, 9) == "template_" then
			for _, ability in ipairs(abilityTiers) do
				ability.blacklisted = true
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

local function addClassPool(objects, className, class, poolName, nameOverride)
	if not (class and class[poolName]) then
		return
	end
	for _, passiveId in ipairs(class[poolName]) do
		for _, tieredObject in ipairs(objects[passiveId]) do
			tieredObject.pool = tieredObject.pool or {}
			table.insert(tieredObject.pool, className:lower() .. "_" .. (nameOverride or poolName))
		end
	end
end

function module.applyClassPools(passives, abilities, classes)
	for className, class in pairs(classes) do
		addClassPool(passives, className, class, "passive_pool", "passive")
		addClassPool(abilities, className, class, "ability_pool", "ability")
		addClassPool(abilities, className, class, "attack_pool", "attack")
		addClassPool(abilities, className, class.ability_groups, "attack")
		addClassPool(abilities, className, class.ability_groups, "defense")
		addClassPool(abilities, className, class.ability_groups, "misc")
		addClassPool(abilities, className, class.ability_groups, "move")
	end
end

return module
