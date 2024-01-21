modifier_tombestone_spawner = class({})

function modifier_tombestone_spawner:IsHidden() return true end
function modifier_tombestone_spawner:IsPurgable() return false end
function modifier_tombestone_spawner:IsBuff() return true end
function modifier_tombestone_spawner:RemoveOnDeath() return false end

function modifier_tombestone_spawner:CheckState()
	 return {
	 	--[MODIFIER_STATE_INVULNERABLE] = false,
		--[MODIFIER_STATE_OUT_OF_GAME] = false,
		--[MODIFIER_STATE_NO_UNIT_COLLISION] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		--[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		--[MODIFIER_STATE_ROOTED] = true,
		--[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
		--[MODIFIER_STATE_FROZEN] = true
	 } 
end
function modifier_tombestone_spawner:DeClareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
end
function modifier_tombestone_spawner:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_tombestone_spawner:GetModifierModelChange()
	--print('change model')

	--return 'models/heroes/treant_protector/treant_protector.vmdl'
end
--[[function modifier_tombestone_spawner:DeClareFunctions()
	return {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE 
	}
end

function modifier_tombestone_spawner:GetModifierTurnRate_Percentage() return 1 end
function modifier_tombestone_spawner:GetModifierIncomingDamage_Percentage() return -999 end
function modifier_tombestone_spawner:GetModifierMoveSpeed_Limit() return 0 end
function modifier_tombestone_spawner:GetModifierMoveSpeed_Max() return 0 end
function modifier_tombestone_spawner:GetModifierMoveSpeed_AbsoluteMin() return 0 end
function modifier_tombestone_spawner:GetModifierDisableTurning () return 1 end
function modifier_tombestone_spawner:GetModifierTurnRate_Override() return 0 end ]]