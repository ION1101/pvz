LinkLuaModifier( "modifier_plants_pot", "modifiers/modifier_plants_pot.lua", LUA_MODIFIER_MOTION_NONE )
modifier_plants_pot = class({})

function modifier_plants_pot:IsHidden() return true end
function modifier_plants_pot:IsPurgable() return false end
function modifier_plants_pot:IsBuff() return true end
function modifier_plants_pot:RemoveOnDeath() return false end

function modifier_plants_pot:CheckState()
	 return {
	 	[MODIFIER_STATE_INVULNERABLE] = false,
		[MODIFIER_STATE_OUT_OF_GAME] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
	 } 
end

function modifier_plants_pot:DeClareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_plants_pot:GetModifierIncomingDamage_Percentage() return -999 end