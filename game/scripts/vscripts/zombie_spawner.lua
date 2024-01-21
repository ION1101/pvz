
--====================================================================
--========================= LABORATORY ===============================
--====================================================================
LinkLuaModifier("modifier_zombie_lab_gold", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)

zombies_lab_gold = class({})

function zombies_lab_gold:GetIntrinsicModifierName()
	return "modifier_zombie_lab_gold"
end

modifier_zombie_lab_gold = class({})

function modifier_zombie_lab_gold:IsHidden() return true end
function modifier_zombie_lab_gold:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end
function modifier_zombie_lab_gold:OnCreated()	
	self:StartIntervalThink(1)

end

function modifier_zombie_lab_gold:OnRefresh()
	self:OnCreated()
end

function modifier_zombie_lab_gold:OnIntervalThink()
if not IsServer() then return end
	--print("interval think")
	--print("1")
	--print(self:GetParent().hasowner)
	if not self:GetParent():GetOwner() then
		--print("not owner 1")
		self:GetParent().hasowner = false
	else 
		--print("name "..self:GetParent():GetOwner():GetUnitName())
		if self:GetParent().hasowner==false then -- обновить абилку
			print("first time got owner")				
			self:GetParent():FindModifierByName("modifier_zombies_lab_extra_zombie"):ForceRefresh()
			self:GetParent():FindAbilityByName("zombies_lab_extra_zombie"):RefreshIntrinsicModifier()			
		end
		self:GetParent().hasowner = true
	end
	--print("2")
	--print(self:GetParent().hasowner)

	self:GetParent():FindAbilityByName("zombies_lab_extra_zombie"):GetCooldown(self:GetParent():FindAbilityByName("zombies_lab_extra_zombie"):GetLevel())
	
	if not self:GetParent():IsStunned() then
	local allHeroes = HeroList:GetAllHeroes()
	local nNewState = GameRules:State_Get()

	if not self:GetParent():HasModifier("modifier_lab_gold_upgrade") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lab_gold_non", {})
	end
	local upgrade = self:GetParent():FindAbilityByName("zombies_lab_gold_multiply")
	local gpm = self:GetAbility():GetSpecialValueFor("gpm")
	if upgrade~= nil then
		if upgrade:GetLevel() ~= 1 then
			local extra_gold = upgrade:GetSpecialValueFor("g_multiply")
			gpm = gpm + (gpm * (extra_gold / 100))
			--print("gpm is "..gpm)
		end
	end	
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_undying" and v:IsAlive() then
			if v:HasModifier("modifier_solo_player") then v:ModifyGold(gpm/30, true, 1)
			else v:ModifyGold(gpm/60, true, 1)
			end
		end
	end
	end

end

LinkLuaModifier("modifier_lab_gold_upgrade", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)
modifier_lab_gold_upgrade = class({})

function modifier_lab_gold_upgrade:IsHidden() return true end
function modifier_lab_gold_upgrade:OnCreated()
	self:StartIntervalThink(60)
end
function modifier_lab_gold_upgrade:OnIntervalThink()
if IsServer() then
	local ability = self:GetAbility()
	local ability_lvl = ability:GetLevel()
	local last_lvl = 6
	local lab = self:GetParent():GetUnitName()
	if lab == "npc_dota_zombies_lab" then
		last_lvl = 10
	elseif lab == "npc_dota_plants_lab" then
		last_lvl = 6
	end
	if ability_lvl == last_lvl then return end
	ability:SetLevel(ability_lvl+1)
	if lab == "npc_dota_zombies_lab" then
		self:GetParent():FindModifierByName("modifier_zombie_lab_gold"):OnCreated()
	else 
		self:GetParent():FindModifierByName("modifier_plants_lab_gold"):OnCreated()
	end
	local extra_zombie = self:GetParent():FindAbilityByName("zombies_lab_extra_zombie")
	if not extra_zombie then return end
	local current_level = ability:GetLevel()
	extra_zombie:SetLevel(current_level)

	for i=1, 2 do
		--print("gold int cycle")
		if IsServer() then
			if not self:GetParent().hasowner then
				--print("not owner intervalthink")
				local abilities_to_upgrade = {"zombies_upgrade_health", "zombies_upgrade_damage", "zombies_upgrade_armor", "zombies_lab_cd_reduction"}
				local top_level = 999
				local upgraded_ability
				for SlotCaster=0,15 do
			        local caster_ability = self:GetParent():GetAbilityByIndex(SlotCaster)
			        if caster_ability ~= nil then 
			        	for _, ab in ipairs(abilities_to_upgrade) do
			        		if caster_ability:GetAbilityName()==ab then
			        			--print("sovpalo "..ab)
			        			local current_level = caster_ability:GetLevel()
				                if current_level < top_level then
				                    top_level = current_level
				                    upgraded_ability = caster_ability
				                end
			        		end
			        	end		            
			        end
		     	end
		     	if upgraded_ability ~= nil then
				    --print("Lowest level ability:", upgraded_ability:GetAbilityName().." its level: "..upgraded_ability:GetLevel())
				    --print("Level:", top_level)
				    upgraded_ability:OnSpellStart()
				else
				    --print("No abilities found in the list")
				end 

			end
		end
	end
end
end

LinkLuaModifier("modifier_lab_gold_non", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)
modifier_lab_gold_non = class({})
function modifier_lab_gold_non:IsHidden() return true end
function modifier_lab_gold_non:OnCreated()
	self:StartIntervalThink(0.2)
end
function modifier_lab_gold_non:OnIntervalThink()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lab_gold_upgrade", {})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zombie_control", {})	
		if self:GetParent():HasModifier("modifier_zombies_lab_extra_zombie") then
			self:GetParent():FindModifierByName("modifier_zombies_lab_extra_zombie"):SetInterval()
		end
		self:GetParent():RemoveModifierByName("modifier_lab_gold_non")		
	end

end

---==========================================================================
--===================== HEALTH UPGRADE ===================================
--===========================================================================

zombies_upgrade_health = class({})
function zombies_upgrade_health:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_health"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_health:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_health"):GetLevel()==6 then
		return 0
	end
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_health:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_health"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
end

function zombies_upgrade_health:GetIntrinsicModifierName()
	return "modifier_upgrade_health"
end
zombies_upgrade_health_2x2 = class({})
function zombies_upgrade_health_2x2:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_health_2x2"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_health_2x2:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_health_2x2"):GetLevel()==6 then
		return 0
	end
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_health_2x2:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_health_2x2"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
end

function zombies_upgrade_health_2x2:GetIntrinsicModifierName()
	return "modifier_upgrade_health"
end
LinkLuaModifier( "modifier_upgrade_health", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_health_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_health = class({})

modifier_upgrade_health_aura = class({})

modifier_upgrade_health = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_health:IsAura()
    return true
end
function modifier_upgrade_health:GetModifierAura()
    return "modifier_upgrade_health_aura"
end
function modifier_upgrade_health:GetAuraRadius()
    return 10000
end
function modifier_upgrade_health:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_health:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_health:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_health:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_health_aura = class({})
function modifier_upgrade_health_aura:GetTexture() return "zombies/laboratory_health" end
function modifier_upgrade_health_aura:IsHidden()
 	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return true end
 	return false 
end
function modifier_upgrade_health_aura:RemoveOnDeath() return true end
function modifier_upgrade_health_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
end
function modifier_upgrade_health_aura:GetModifierExtraHealthPercentage()
	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return end
 	if self:GetParent():GetUnitName()=="npc_zombie_7" or self:GetParent():GetUnitName()=="npc_zombie_7_2" or self:GetParent():GetUnitName()=="npc_zombie_7_3" then
 		return self:GetAbility():GetSpecialValueFor("health")/2
 	end
 	return self:GetAbility():GetSpecialValueFor("health")
end

---==========================================================================
--===================== DAMAGE UPGRADE ===================================
--===========================================================================
zombies_upgrade_damage = class({})
function zombies_upgrade_damage:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_damage"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_damage:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_damage"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_damage:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_damage"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
end

function zombies_upgrade_damage:GetIntrinsicModifierName()
	return "modifier_upgrade_damage"
end
zombies_upgrade_damage_2x2 = class({})
function zombies_upgrade_damage_2x2:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_damage_2x2"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_damage_2x2:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_damage_2x2"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_damage_2x2:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_damage_2x2"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
end

function zombies_upgrade_damage_2x2:GetIntrinsicModifierName()
	return "modifier_upgrade_damage"
end
LinkLuaModifier( "modifier_upgrade_damage", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_damage_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_damage = class({})

modifier_upgrade_damage_aura = class({})

modifier_upgrade_damage = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_damage:IsAura()
    return true
end
function modifier_upgrade_damage:GetModifierAura()
    return "modifier_upgrade_damage_aura"
end
function modifier_upgrade_damage:GetAuraRadius()
    return 10000
end
function modifier_upgrade_damage:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_damage:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_damage:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_damage:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_damage_aura = class({})
function modifier_upgrade_damage_aura:GetTexture() return "zombies/laboratory_damage" end
function modifier_upgrade_damage_aura:IsHidden()
 	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return true end
 	return false 
end
function modifier_upgrade_damage_aura:RemoveOnDeath() return true end
function modifier_upgrade_damage_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_upgrade_damage_aura:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return end
  	if self:GetParent():GetUnitName()=="npc_zombie_7" or self:GetParent():GetUnitName()=="npc_zombie_7_2" or self:GetParent():GetUnitName()=="npc_zombie_7_3" then
 		return self:GetAbility():GetSpecialValueFor("dmg")/2
 	end
 	return self:GetAbility():GetSpecialValueFor("dmg")
end


---==========================================================================
--===================== ARMOR UPGRADE ===================================
--===========================================================================

zombies_upgrade_armor = class({})
function zombies_upgrade_armor:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_armor"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_armor:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_armor"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_armor:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_armor"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")

end

function zombies_upgrade_armor:GetIntrinsicModifierName()
	return "modifier_upgrade_armor"
end
zombies_upgrade_armor_2x2 = class({})
function zombies_upgrade_armor_2x2:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_armor_2x2"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_upgrade_armor_2x2:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_upgrade_armor_2x2"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_upgrade_armor_2x2:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_upgrade_armor_2x2"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
end
function zombies_upgrade_armor_2x2:GetIntrinsicModifierName()
	return "modifier_upgrade_armor"
end

LinkLuaModifier( "modifier_upgrade_armor", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_armor_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_armor = class({})

modifier_upgrade_armor_aura = class({})

modifier_upgrade_armor = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_armor:IsAura()
    return true
end
function modifier_upgrade_armor:GetModifierAura()
    return "modifier_upgrade_armor_aura"
end
function modifier_upgrade_armor:GetAuraRadius()
    return 10000
end
function modifier_upgrade_armor:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_armor:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_armor:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_armor:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_armor_aura = class({})
function modifier_upgrade_armor_aura:GetTexture() return "zombies/laboratory_armor" end
function modifier_upgrade_armor_aura:IsHidden()
 	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return true end
 	return false 
end
function modifier_upgrade_armor_aura:RemoveOnDeath() return true end
function modifier_upgrade_armor_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_upgrade_armor_aura:GetModifierPhysicalArmorBonus()
	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return end
 	if self:GetParent():GetUnitName()=="npc_zombie_7" or self:GetParent():GetUnitName()=="npc_zombie_7_2" or self:GetParent():GetUnitName()=="npc_zombie_7_3" then
 		return self:GetAbility():GetSpecialValueFor("armor")/2
 	end
 	return self:GetAbility():GetSpecialValueFor("armor")
end

---==========================================================================
--===================== CD REDUCE UPGRADE ===================================
--===========================================================================

zombies_lab_cd_reduction = class({})

function zombies_lab_cd_reduction:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_lab_cd_reduction:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction"):GetLevel()==6 then
		return 0
	end		
	return self:GetSpecialValueFor("gold_cost") 
end
function zombies_lab_cd_reduction:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")

end

function zombies_lab_cd_reduction:GetIntrinsicModifierName()
	return "modifier_upgrade_reduce"
end
zombies_lab_cd_reduction_2x2 = class({})

function zombies_lab_cd_reduction_2x2:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction_2x2"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_lab_cd_reduction_2x2:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction_2x2"):GetLevel()==6 then
		return 0
	end		
	return self:GetSpecialValueFor("gold_cost") 
end
function zombies_lab_cd_reduction_2x2:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_lab_cd_reduction_2x2"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")

end

function zombies_lab_cd_reduction_2x2:GetIntrinsicModifierName()
	return "modifier_upgrade_reduce"
end

LinkLuaModifier( "modifier_upgrade_reduce", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_reduce_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_reduce = class({})

modifier_upgrade_reduce_aura = class({})

modifier_upgrade_reduce = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_reduce:IsAura()
    return true
end
function modifier_upgrade_reduce:GetModifierAura()
    return "modifier_upgrade_reduce_aura"
end
function modifier_upgrade_reduce:GetAuraRadius()
    return 10000
end
function modifier_upgrade_reduce:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_reduce:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_reduce:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_reduce:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_reduce_aura = class({})
function modifier_upgrade_reduce_aura:GetTexture() return "zombies/laboratory_cooldown" end
function modifier_upgrade_reduce_aura:IsHidden()
 	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" or self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_pharaon_tomb" or self:GetParent():GetUnitName()=="npc_dota_dj_eban" then return true end
 	return false 
end
function modifier_upgrade_reduce_aura:RemoveOnDeath() return true end
function modifier_upgrade_reduce_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function modifier_upgrade_reduce_aura:GetModifierPercentageCooldown()
	if self:GetParent():GetUnitName()=="npc_cannon" or self:GetParent():GetUnitName()=="npc_dota_zombies_lab" then return 0 end
 	return self:GetAbility():GetSpecialValueFor("cd_reduce")
end

---==========================================================================
--===================== MANA UPGRADE ===================================
--===========================================================================

zombies_lab_mana = class({})

function zombies_lab_mana:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_lab_mana"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_lab_mana:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_lab_mana"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_lab_mana:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_lab_mana"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")

end

function zombies_lab_mana:GetIntrinsicModifierName()
	return "modifier_upgrade_mana"
end

LinkLuaModifier( "modifier_upgrade_mana", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_mana_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_mana = class({})

modifier_upgrade_mana_aura = class({})

modifier_upgrade_mana = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_mana:IsAura()
    return true
end
function modifier_upgrade_mana:GetModifierAura()
    return "modifier_upgrade_mana_aura"
end
function modifier_upgrade_mana:GetAuraRadius()
    return 10000
end
function modifier_upgrade_mana:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_mana:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_mana:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_mana:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_mana_aura = class({})
function modifier_upgrade_mana_aura:GetTexture() return "zombies/laborathory_mana" end
function modifier_upgrade_mana_aura:IsHidden()
 	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" then return false end
 	return true
end
function modifier_upgrade_mana_aura:RemoveOnDeath() return true end
function modifier_upgrade_mana_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end
function modifier_upgrade_mana_aura:GetModifierConstantManaRegen()
	if self:GetParent():GetUnitName()=="npc_dota_creature_tombstone" then return self:GetAbility():GetSpecialValueFor("mana_regen") end
 	return 0
end

---==========================================================================
--===================== GOLD MULTIPLY UPGRADE ===============================
--===========================================================================

zombies_lab_gold_multiply = class({})


function zombies_lab_gold_multiply:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_lab_gold_multiply:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_lab_gold_multiply:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
	self:GetCaster():FindModifierByName("modifier_zombie_lab_gold"):OnCreated()
end

function zombies_lab_gold_multiply:GetIntrinsicModifierName()
	return "modifier_upgrade_multiply"
end

zombies_lab_gold_multiply_2x2 = class({})


function zombies_lab_gold_multiply_2x2:GetBehavior()
	if self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply_2x2"):GetLevel()==6 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function zombies_lab_gold_multiply_2x2:GetGoldCost()
	if self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply_2x2"):GetLevel()==6 then
		return 0
	end	
	return self:GetSpecialValueFor("gold_cost")
end
function zombies_lab_gold_multiply_2x2:OnSpellStart()
	local lvl = self:GetCaster():FindAbilityByName("zombies_lab_gold_multiply_2x2"):GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 6 then
		self:SetLevel(lvl+1)
	end
	--print("spell start")
	self:GetCaster():FindModifierByName("modifier_zombie_lab_gold"):OnCreated()
end

function zombies_lab_gold_multiply_2x2:GetIntrinsicModifierName()
	return "modifier_upgrade_multiply"
end

LinkLuaModifier( "modifier_upgrade_multiply", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upgrade_multiply_aura", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_upgrade_multiply = class({})

modifier_upgrade_multiply_aura = class({})

modifier_upgrade_multiply = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_upgrade_multiply:IsAura()
    return true
end
function modifier_upgrade_multiply:GetModifierAura()
    return "modifier_upgrade_multiply_aura"
end
function modifier_upgrade_multiply:GetAuraRadius()
    return 10000
end
function modifier_upgrade_multiply:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_upgrade_multiply:GetAuraDuration()    
    return 1.0
end
function modifier_upgrade_multiply:GetAuraSearchType()   
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_upgrade_multiply:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_upgrade_multiply_aura = class({})
function modifier_upgrade_multiply_aura:GetTexture() return "zombies/laboratory_multiply" end
function modifier_upgrade_multiply_aura:IsHidden() 	return true end
function modifier_upgrade_multiply_aura:RemoveOnDeath() return true end



LinkLuaModifier("modifier_zombie_control", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)
modifier_zombie_control = class({})
function modifier_zombie_control:IsHidden() return true end
function modifier_zombie_control:OnCreated() self:StartIntervalThink(1) end
function modifier_zombie_control:OnIntervalThink()
if not IsServer() then return end
	local caster = self:GetParent()
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 
	for _,ppot in pairs( plantsPots ) do
		if ppot:GetUnitName()=="npc_dota_hero_undying" then
			caster:SetOwner(ppot)
			caster:SetControllableByPlayer( ppot:GetPlayerOwnerID(), true )
			return   					
   		end
   	end
end

LinkLuaModifier( "modifier_zombies_lab_extra_zombie", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE )
zombies_lab_extra_zombie = class({})

function zombies_lab_extra_zombie:GetCooldown(ilevel)
	local cd = self.BaseClass.GetCooldown( self, ilevel )
	if IsServer() then
		--print("cd is "..self:GetSpecialValueFor("interval"))
		return self:GetSpecialValueFor("interval")		
	end
	
	return cd
end

function zombies_lab_extra_zombie:GetIntrinsicModifierName()
	return "modifier_zombies_lab_extra_zombie"
end

modifier_zombies_lab_extra_zombie = class({})
function modifier_zombies_lab_extra_zombie:IsHidden() return true end
function modifier_zombies_lab_extra_zombie:OnCreated()
	if not IsServer() then return end
	
end
function modifier_zombies_lab_extra_zombie:DeclareFunctions()
	return {		
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
end
function modifier_zombies_lab_extra_zombie:GetModifierOverrideAbilitySpecial( params )
	local ability = params.ability
    if ability==self:GetAbility() and ability:GetAbilityName()=="zombies_lab_extra_zombie" then
	    return 1
    else return 0
    end
end
-- менять значения в зависимости от мапи та гравця
function modifier_zombies_lab_extra_zombie:GetModifierOverrideAbilitySpecialValue(params)
    local szAbilityName = params.ability:GetAbilityName()
    if not szAbilityName=="zombies_lab_extra_zombie" then return end
    local ability = params.ability
    local value = params.ability_special_value
	local level = params.ability_special_level  
	--print("level "..level)
	local hasowner = self:GetParent():IsControllableByAnyPlayer()
	--print(b)
    if hasowner then
    	--print("has owner override ab")
    	if GetMapName()=="2x2" then
    		--print("2x2 map owner")
    		
    		if value=="num" then
    			local allHeroes = HeroList:GetAllHeroes()
				for k, v in pairs( allHeroes ) do
					if v:GetUnitName()=="npc_dota_hero_undying" then
						if v:IsAlive() then
							if v:HasModifier("modifier_solo_player") then 

							else 
								--print("2 undyings 0 num")
								return 0
							end					
							
						end
					end
				end
    			return ability:GetLevelSpecialValueNoOverride( value, level )
    		elseif value=="interval" then
    			local allHeroes = HeroList:GetAllHeroes()
				for k, v in pairs( allHeroes ) do
					if v:GetUnitName()=="npc_dota_hero_undying" then
						if v:IsAlive() then
							if v:HasModifier("modifier_solo_player") then 
								
							else 
								--print("2 undyings 999 cd")
								self:GetAbility():SetActivated(false)
								return -1
							end					
							
						end
					end
				end
    			return 30--ability:GetLevelSpecialValueNoOverride( value, level ) / 2
    		end
    	end    

    	if value=="t1chance" then    			
			-- 100 95 89 78 67 56 45 34 23 14
			local t1_chance = {100, 95, 89, 78, 69, 60, 51, 42, 33, 24}
			return t1_chance[level+1]   
		elseif value=="t2chance" then    			
			-- 0 5 11 17 23 29 35 41 47 53
			local t2_chance = {0, 5, 11, 17, 23, 29, 35, 41, 47, 53}
			return t2_chance[level+1]    
		elseif value=="t3chance" then    			
			-- 0 0 0 5 8 11 14 17 20 23
			local t3_chance = {0, 0, 0, 5, 8, 11, 14, 17, 20, 23}
			return t3_chance[level+1]  
		elseif value=="t4chance" then    			
			-- 0 0 0 0 0 2 4 6 8 10
			local t4_chance = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
			return t4_chance[level+1] 			
		end
    	return params.ability:GetLevelSpecialValueNoOverride( value, level ) 
    else
    	if value=="t1chance" then    			
			-- 96 91 81 71 61 51 41 31 21 11
			local t1_chance = {100, 91, 81, 71, 61, 51, 41, 31, 21, 11}
			return  t1_chance[level+1]   
		elseif value=="t2chance" then    			
			-- 4 8 16 20 24 26 28 30 32 34
			local t2_chance = {0, 8, 16, 20, 24, 26, 28, 30, 32, 34}
			return  t2_chance[level+1]    
		elseif value=="t3chance" then    			
			-- 0 1 3 7 11 17 23 29 35 41
			local t3_chance = {0, 1, 3, 7, 11, 17, 23, 29, 35, 41}
			return  t3_chance[level+1]  
		elseif value=="t4chance" then    			
			-- 0 0 0 2 4 6 8 10 12 14
			local t4_chance = {0, 0, 0, 2, 4, 6, 8, 10, 12, 14}
			return  t4_chance[level+1] 			
		end

    	if GetMapName()=="1x1" then
    		if value=="num" then
    			return ability:GetLevelSpecialValueNoOverride( value, level ) * 2
    		elseif value=="interval" then
    			return ability:GetLevelSpecialValueNoOverride( value, level ) / 1.35 
    		end 		
    	elseif GetMapName()=="2x2" then
    		--print("2x2 map")
    		if value=="num" then
    			return ability:GetLevelSpecialValueNoOverride( value, level ) * 2.5
    		elseif value=="interval" then
    			return ability:GetLevelSpecialValueNoOverride( value, level ) / 2
    		end
    	end    	
    end  
       
    local flBaseValue = ability:GetLevelSpecialValueNoOverride( value, level )       
    return flBaseValue   

  
end 



function modifier_zombies_lab_extra_zombie:SetInterval()
if not IsServer() then return end
	self.ability = self:GetAbility()
	Timers:CreateTimer(0.3, function()
		self:StartIntervalThink(self.ability:GetSpecialValueFor("interval"))
	end)	
end
function modifier_zombies_lab_extra_zombie:OnIntervalThink()
	
	local caster = self:GetParent()
	if caster:IsStunned() or caster:IsSilenced() then return end
	--print("extra zombie interval")
	--[[ переміщено до modifier_lab_gold_upgrade:OnIntervalThink()
	if IsServer() then
		if not self:GetParent().hasowner then
			--print("not owner intervalthink")
			local abilities_to_upgrade = {"zombies_upgrade_health", "zombies_upgrade_damage", "zombies_upgrade_armor", "zombies_lab_cd_reduction"}
			local top_level = 999
			local upgraded_ability
			for SlotCaster=0,15 do
		        local caster_ability = caster:GetAbilityByIndex(SlotCaster)
		        if caster_ability ~= nil then 
		        	for _, ab in ipairs(abilities_to_upgrade) do
		        		if caster_ability:GetAbilityName()==ab then
		        			--print("sovpalo "..ab)
		        			local current_level = caster_ability:GetLevel()
			                if current_level < top_level then
			                    top_level = current_level
			                    upgraded_ability = caster_ability
			                end
		        		end
		        	end		            
		        end
	     	end
	     	if upgraded_ability ~= nil then
			    print("Lowest level ability:", upgraded_ability:GetAbilityName().." its level: "..upgraded_ability:GetLevel())
			    --print("Level:", top_level)
			    upgraded_ability:OnSpellStart()
			else
			    --print("No abilities found in the list")
			end 

		end
	end
	]]
	local t1chance = self:GetAbility():GetSpecialValueFor("t1chance")
	local t2chance = self:GetAbility():GetSpecialValueFor("t2chance")
	local t3chance = self:GetAbility():GetSpecialValueFor("t3chance")
	local t4chance = self:GetAbility():GetSpecialValueFor("t4chance")
	--print("chances "..t1chance.." "..t2chance.." "..t3chance.." "..t4chance)
	local num = self:GetAbility():GetSpecialValueFor("num")
	local zombies_interval = self:GetAbility():GetSpecialValueFor("zombie_interval")

	local zombieTypes = {
	    {type = "t1", chance = t1chance},
	    {type = "t2", chance = t2chance},
	    {type = "t3", chance = t3chance},
	    {type = "t4", chance = t4chance},
	}

	for i=1, num do		
		Timers:CreateTimer((zombies_interval * i) - 1, function()
			local totalChance = 0
		    for _, zombieType in ipairs(zombieTypes) do
		        totalChance = totalChance + zombieType.chance
		    end

		    local randomValue = RandomInt(1, totalChance)
		    local selectedType
		    for _, zombieType in ipairs(zombieTypes) do
		        if randomValue <= zombieType.chance then
		            selectedType = zombieType.type
		            break
		        end
		        randomValue = randomValue - zombieType.chance
		    end
		   --	print("selected type "..selectedType)
		   	local spawners = {
		   	}

		   	local Tombs = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 
	      	for _,tomb in pairs( Tombs ) do
	      		if tomb:GetUnitName()=="npc_dota_creature_tombstone" then
			        table.insert(spawners, tomb)
			    end
	      	end

	      	local tombspawner = spawners[RandomInt(1, #spawners)]      	

		    local spawnz = 1

		    if selectedType == "t1" then
		    	spawnz = tombspawner:GetAbilityByIndex(0)
		    elseif selectedType == "t2" then
		    	spawnz = tombspawner:GetAbilityByIndex(RandomInt(1,2))
		    elseif selectedType == "t3" then
		    	spawnz = tombspawner:GetAbilityByIndex(RandomInt(3,5))
		   	elseif selectedType == "t4" then
		    	spawnz = tombspawner:GetAbilityByIndex(6)
		    end

		   -- print("spawn abi  "..spawnz:GetAbilityName())

		    spawnz:OnSpellStart()
		end)
		

	end

	self:SetInterval()
	self:GetAbility():UseResources(false, false, false, true)


end