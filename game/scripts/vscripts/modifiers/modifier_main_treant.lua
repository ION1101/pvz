LinkLuaModifier( "modifier_solo_player", "modifiers/modifier_main_undying.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_main_treant", "modifiers/modifier_main_treant.lua", LUA_MODIFIER_MOTION_NONE )
modifier_main_treant = class({})

function modifier_main_treant:IsHidden() return true end
function modifier_main_treant:IsPurgable() return false end
function modifier_main_treant:IsBuff() return true end
function modifier_main_treant:RemoveOnDeath() return false end

function modifier_main_treant:OnCreated()
	self:StartIntervalThink(0.2)
	self:OnIntervalThink()
end
function modifier_main_treant:OnIntervalThink() 
if IsServer() then
	local caster = self:GetParent()
	local solo_player = true
	--[[local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	--print(#plantsPots)
	for _,ppot in pairs( plantsPots ) do 
   		if ppot:GetUnitName()=="npc_dota_plants_lab" then
   			ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
   			ppot:SetOwner(caster) 			
   		end
   	end ]]
   	for k, v in pairs( HeroList:GetAllHeroes() ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v ~= caster then	
				solo_player = false								
			end
		end	
	end
	if solo_player then
   		if GetMapName()~="1x1" and not self:GetParent():HasModifier("modifier_solo_player") then -- если чел один то даём х2 голду. если 1х1 на дуо карте то х2 деньги обеим)
   			self:GetParent():AddNewModifier(self:GetParent(),nil, "modifier_solo_player", {}) 
   		end
   	else
   		if self:GetParent():HasModifier("modifier_solo_player") then self:GetParent():RemoveModifierByName("modifier_solo_player") end
   	end
end
end