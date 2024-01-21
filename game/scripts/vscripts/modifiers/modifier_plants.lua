modifier_plants = class({})

function modifier_plants:IsHidden() return true end
function modifier_plants:IsPurgable() return false end
function modifier_plants:IsBuff() return true end
function modifier_plants:RemoveOnDeath() return true end
function modifier_plants:CheckState()
	 return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	 } 
end
function modifier_plants:OnDeath()
	local unit = self:GetParent():GetUnitName()
	if unit == "npc_dota_watermelon_1" or unit == "npc_dota_watermelon_2" or unit == "npc_dota_watermelon_3" then 
		self:GetParent():RemoveSelf() 
	end
	if unit == "npc_plants_defender_1" or unit == "npc_plants_defender_1_2" or unit == "npc_plants_defender_1_2" then
		self:GetParent():RemoveSelf()
	end
end