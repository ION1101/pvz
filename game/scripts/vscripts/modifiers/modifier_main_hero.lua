LinkLuaModifier( "modifier_main_hero", "modifiers/modifier_main_hero.lua", LUA_MODIFIER_MOTION_NONE )

modifier_main_hero = class({})

function modifier_main_hero:IsHidden() return true end
function modifier_main_hero:IsPurgable() return false end
function modifier_main_hero:IsBuff() return true end
function modifier_main_hero:RemoveOnDeath() return false end

function modifier_main_hero:CheckState()
	 return {
	 	[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	 } 
end
