LinkLuaModifier( "modifier_solo_player", "modifiers/modifier_main_undying.lua", LUA_MODIFIER_MOTION_NONE )

modifier_main_undying = class({})

function modifier_main_undying:IsHidden() return true end
function modifier_main_undying:IsPurgable() return false end
function modifier_main_undying:IsBuff() return true end
function modifier_main_undying:RemoveOnDeath() return false end

function modifier_main_undying:OnCreated()
if not IsServer() then return end
	--[[local caster = self:GetParent()
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	for _,ppot in pairs( plantsPots ) do
		if ppot:GetUnitName()=="npc_dota_zombies_lab" then
			ppot:SetOwner(caster)	
   			ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )   					
   		end
   		if ppot:GetUnitName()=="npc_dota_dj_eban" then
   			self:GetParent():SetOwner(caster) 
	   		self:GetParent():SetControllableByPlayer(caster:GetPlayerOwnerID(), true ) 
	   		self:GetParent():SetTeam(caster:GetTeamNumber())	   		
   		end
   	end ]]
	self:StartIntervalThink(0.2)
	self:OnIntervalThink()
end
function modifier_main_undying:OnIntervalThink() 
if IsServer() then
	local caster = self:GetParent()

	--local second_caster = nil

	local solo_player = true
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	for _,ppot in pairs( plantsPots ) do 
		for k, v in pairs( HeroList:GetAllHeroes() ) do
		if v:GetUnitName()=="npc_dota_hero_undying" and v:IsAlive() then
			if v ~= caster then	
				solo_player = false
				--second_caster = v						
			end
		end	
	end 
   		
   		if solo_player == true then   
	   		if ppot:GetUnitName()=="npc_dota_creature_tombstone" then
	   			ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
	   			ppot:SetOwner(caster)			
	   		end		
   		else
   			if ppot:GetUnitName()=="npc_dota_creature_tombstone" and ppot:HasModifier("modifier_tomb1") then
   				ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
   				ppot:SetOwner(caster)
   			end	
   			--if ppot:GetUnitName()=="npc_dota_creature_tombstone" and ppot:HasModifier("modifier_tomb2") then
   			--	ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), false )
   			--	ppot:SetOwner(second_caster)
   			--end		
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

modifier_second_undying = class({})

function modifier_second_undying:IsHidden() return true end
function modifier_second_undying:IsPurgable() return false end
function modifier_second_undying:IsBuff() return true end
function modifier_second_undying:RemoveOnDeath() return false end

function modifier_second_undying:OnCreated()
	self:StartIntervalThink(0.2)
	self:OnIntervalThink()
end
function modifier_second_undying:OnIntervalThink() 
if IsServer() then
	local caster = self:GetParent()	
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	for _,ppot in pairs( plantsPots ) do  
  		if ppot:GetUnitName()=="npc_dota_creature_tombstone" and ppot:HasModifier("modifier_tomb2") then
   			ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
   			ppot:SetOwner(caster)			
   		end     		
   	end   
end
end

modifier_solo_player = class({})
function modifier_solo_player:IsHidden() return true end