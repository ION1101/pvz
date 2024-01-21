LinkLuaModifier( "modifier_pvz_2x2", "modifiers/modifier_lab_stunned.lua", LUA_MODIFIER_MOTION_NONE )

modifier_lab_stunned = class({})

function modifier_lab_stunned:IsHidden() return true end
function modifier_lab_stunned:IsPurgable() return false end
function modifier_lab_stunned:IsBuff() return true end
function modifier_lab_stunned:RemoveOnDeath() return false end

function modifier_lab_stunned:OnCreated()
	--if GetMapName() == "2x2" then   
   -- end 
	self:StartIntervalThink(1)
end
function modifier_lab_stunned:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_lab_stunned:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

function modifier_lab_stunned:OnIntervalThink()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:GetParent():RemoveModifierByName("modifier_lab_stunned")
	end
end
function modifier_lab_stunned:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_lab_stunned:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end
function modifier_lab_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_lab_stunned:IsStunDebuff()
	return true
end

modifier_pvz_2x2 = class({})
function modifier_pvz_2x2:IsHidden() return false end
function modifier_pvz_2x2:IsBuff() return true end