LinkLuaModifier( "modifier_lines", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_1", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_2", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_3", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_4", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_5", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_6", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_7", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_8", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cannot_be_attacked", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tomb1", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tomb2", "lines.lua", LUA_MODIFIER_MOTION_NONE )

modifier_cannot_be_attacked = class ({})

function modifier_cannot_be_attacked:IsHidden() return true end
function modifier_cannot_be_attacked:IsPurgable() return false end
function modifier_cannot_be_attacked:RemoveOnDeath() return true end

function SetCannotBeAttacked(event)
	local unit = event.activator
	
	unit:AddNewModifier(unit, event, "modifier_cannot_be_attacked", {duration = -1})
end

function SetCanBeAttacked(event)
	local unit = event.activator
	unit:RemoveModifierByName("modifier_cannot_be_attacked")
end

function ApplyLineModifier1(event)
	--print("line 1")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_1", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier2(event)
	--print("line 2")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_2", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier3(event)
	--print("line 3")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_3", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier4(event)
	--print("line 4")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_4", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier5(event)
	--print("line 5")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_5", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier6(event)
	--print("line 5")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_6", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier7(event)
	--print("line 5")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_7", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

function ApplyLineModifier8(event)
	--print("line 5")
	local unit = event.activator
	if not unit:IsRealHero() then
		unit:AddNewModifier(unit, event, "modifier_line_8", {duration = -1})
		unit:AddNewModifier(unit, event, "modifier_lines", {duration = -1})
	end
end

modifier_lines = class({})
modifier_line_1 = class({})
modifier_line_2 = class({})
modifier_line_3 = class({})
modifier_line_4 = class({})
modifier_line_5 = class({})
modifier_line_6 = class({})
modifier_line_7 = class({})
modifier_line_8 = class({})

function modifier_lines:IsHidden() return true end
function modifier_lines:IsPurgable() return false end
function modifier_lines:RemoveOnDeath() return true end

function modifier_line_1:IsHidden() return true end
function modifier_line_1:IsPurgable() return false end
function modifier_line_1:RemoveOnDeath() return true end

function modifier_line_2:IsHidden() return true end
function modifier_line_2:IsPurgable() return false end
function modifier_line_2:RemoveOnDeath() return true end

function modifier_line_3:IsHidden() return true end
function modifier_line_3:IsPurgable() return false end
function modifier_line_3:RemoveOnDeath() return true end

function modifier_line_4:IsHidden() return true end
function modifier_line_4:IsPurgable() return false end
function modifier_line_4:RemoveOnDeath() return true end

function modifier_line_5:IsHidden() return true end
function modifier_line_5:IsPurgable() return false end
function modifier_line_5:RemoveOnDeath() return true end

function modifier_line_6:IsHidden() return true end
function modifier_line_6:IsPurgable() return false end
function modifier_line_6:RemoveOnDeath() return true end

function modifier_line_7:IsHidden() return true end
function modifier_line_7:IsPurgable() return false end
function modifier_line_7:RemoveOnDeath() return true end

function modifier_line_8:IsHidden() return true end
function modifier_line_8:IsPurgable() return false end
function modifier_line_8:RemoveOnDeath() return true end

function RemoveLineModifier1(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_1")
	]]
end
function RemoveLineModifier2(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_2")
	]]
end
function RemoveLineModifier3(event)
	--[[
	local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_3")
	]]
end
function RemoveLineModifier4(event)
	--[[
	local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_4")
	]]
end
function RemoveLineModifier5(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_5")]]
end
function RemoveLineModifier6(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_5")]]
end
function RemoveLineModifier7(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_5")]]
end
function RemoveLineModifier8(event)
	--[[local unit = event.activator
	unit:RemoveModifierByName("modifier_lines")
	unit:RemoveModifierByName("modifier_line_5")]]
end

modifier_tomb1 = class({})
modifier_tomb2 = class({})
function modifier_tomb1:IsHidden() return true end
function modifier_tomb2:IsHidden() return true end
function ApplyTomb1(event)
	local unit = event.activator
	if unit:GetUnitName()=="npc_dota_creature_tombstone" then
		unit:AddNewModifier(unit, nil, "modifier_tomb1", {})
		--print("tomb1 modif")
	end
end
function ApplyTomb2(event)
	local unit = event.activator
	if unit:GetUnitName()=="npc_dota_creature_tombstone" then
		unit:AddNewModifier(unit, nil, "modifier_tomb2", {})
		--print("tomb2 modif")
	end
end