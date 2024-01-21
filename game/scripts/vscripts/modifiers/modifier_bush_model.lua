modifier_bush_model = class({})

function modifier_bush_model:IsHidden() return true end
function modifier_bush_model:IsPurgable() return false end
function modifier_bush_model:IsBuff() return true end
function modifier_bush_model:RemoveOnDeath() return false end

--function modifier_bush_model:OnCreated()
--	local rand = RandomInt(1,3)
--	if rand == 1 then local model = "models/bushes/bush1.vmdl" end
--	if rand == 2 then local model = "models/bushes/bush2.vmdl" end
--	if rand == 3 then local model = "models/bushes/bush3.vmdl" end
-- 	self:GetParent():SetModel("models/heroes/treant_protector/treant_protector.vmdl")
--end

function modifier_bush_model:DeClareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
end
function modifier_bush_model:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_bush_model:GetModifierModelChange()
	print('change model')

	return 'models/heroes/treant_protector/treant_protector.vmdl'
end