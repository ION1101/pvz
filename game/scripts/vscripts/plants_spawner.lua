spawn_attackers = class({})

function spawn_attackers:OnSpellStart()
	local caster = self:GetCaster()

	-- УДАЛЯЕМ СТАРЫЕ
	caster:RemoveAbility("spawn_attackers")
	caster:RemoveAbility("spawn_defenders")
	caster:RemoveAbility("spawn_specials")
	caster:RemoveAbility("dig_plant")
	caster:RemoveAbility("treant_end_game")
	caster:RemoveAbility("plant_watermelon")
	-- НОВЫЕ АБИЛКИ АТТАКЕРОВ
	local ability1 = caster:AddAbility("plants_attacker_1") -- q
	local ability2 = caster:AddAbility("plants_attacker_2") -- w
	local ability3 = caster:AddAbility("plants_attacker_3") -- e
	local ability6 = caster:AddAbility("plants_spawner_back") -- r
	local ability5 = caster:AddAbility("plants_attacker_5") -- d
	local ability4 = caster:AddAbility("plants_attacker_4") -- f
	
	-- АКТИВИРУЕМ НОВЫЕ СКИЛЛЫ
	ability1:SetLevel(1) -- q
	ability2:SetLevel(1) -- w
	ability3:SetLevel(1) -- e

	ability5:SetLevel(1) -- d
	ability4:SetLevel(1) -- f
	ability6:SetLevel(1) -- r


	caster:SwapAbilities("plants_spawner_back", "plants_attacker_5", true, true)
	caster:SwapAbilities("plants_spawner_back", "plants_attacker_4", true, true)
	
	for i=1, 5 do
		if caster:HasModifier("modifier_attacker_"..i.."_cooldown") then
			local cd = caster:FindModifierByName("modifier_attacker_"..i.."_cooldown"):GetRemainingTime()
			caster:FindAbilityByName("plants_attacker_"..i):StartCooldown(cd)
		end
	end 

end

spawn_defenders = class({})
	
function spawn_defenders:OnSpellStart()
	local caster = self:GetCaster()

	-- УДАЛЯЕМ СТАРЫЕ
	caster:RemoveAbility("spawn_attackers")
	caster:RemoveAbility("spawn_defenders")
	caster:RemoveAbility("spawn_specials")
	caster:RemoveAbility("dig_plant")
	caster:RemoveAbility("treant_end_game")
	caster:RemoveAbility("plant_watermelon")
	-- НОВЫЕ АБИЛКИ АТТАКЕРОВ
	local ability1 = caster:AddAbility("plants_defender_1")
	local ability2 = caster:AddAbility("plants_defender_2")
	local ability3 = caster:AddAbility("plants_defender_3")
	local ability6 = caster:AddAbility("plants_spawner_back")
	local ability4 = caster:AddAbility("plants_defender_4")
	local ability5 = caster:AddAbility("plants_defender_5")
	-- АКТИВИРУЕМ НОВЫЕ СКИЛЛЫ
	ability1:SetLevel(1)
	ability2:SetLevel(1)	
	ability3:SetLevel(1)
	ability4:SetLevel(1)
	ability5:SetLevel(1)
	ability6:SetLevel(1)

	caster:SwapAbilities("plants_spawner_back", "plants_defender_4", true, true)
	caster:SwapAbilities("plants_spawner_back", "plants_defender_5", true, true)

	for i=1, 5 do
		if caster:HasModifier("modifier_defender_"..i.."_cooldown") then
			local cd = caster:FindModifierByName("modifier_defender_"..i.."_cooldown"):GetRemainingTime()
			caster:FindAbilityByName("plants_defender_"..i):StartCooldown(cd)
		end
	end

end

spawn_specials = class({})
	
function spawn_specials:OnSpellStart()
	local caster = self:GetCaster()

	-- УДАЛЯЕМ СТАРЫЕ
	caster:RemoveAbility("spawn_attackers")
	caster:RemoveAbility("spawn_defenders")
	caster:RemoveAbility("spawn_specials")
	caster:RemoveAbility("dig_plant")
	caster:RemoveAbility("treant_end_game")
	caster:RemoveAbility("plant_watermelon")
	-- НОВЫЕ АБИЛКИ АТТАКЕРОВ
	local ability1 = caster:AddAbility("plants_special_1")
	local ability2 = caster:AddAbility("plants_special_2")
	local ability3 = caster:AddAbility("plants_special_3")
	local ability4 = caster:AddAbility("plants_special_4")
	local ability5 = caster:AddAbility("plants_special_5")
	local ability6 = caster:AddAbility("plants_spawner_back")
	-- АКТИВИРУЕМ НОВЫЕ СКИЛЛЫ
	ability1:SetLevel(1)
	ability2:SetLevel(1)
	ability3:SetLevel(1)
	ability4:SetLevel(1)
	ability5:SetLevel(1)
	ability6:SetLevel(1)

	--caster:SwapAbilities("plants_spawner_back", "plants_special_4", true, true)
	--caster:SwapAbilities("plants_spawner_back", "plants_special_5", true, true)	
	
	for i=1, 5 do
		if caster:HasModifier("modifier_special_"..i.."_cooldown") then
			local cd = caster:FindModifierByName("modifier_special_"..i.."_cooldown"):GetRemainingTime()
			caster:FindAbilityByName("plants_special_"..i):StartCooldown(cd)
		else caster:FindAbilityByName("plants_special_"..i):EndCooldown()
		end
	end
end

plants_spawner_back = class({})

function plants_spawner_back:OnSpellStart()
if not IsServer() then return end
	local caster = self:GetCaster()

	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then
			local abilityName = ability:GetAbilityName()
			caster:RemoveAbility(abilityName)
		end
	end

	local ability1 = caster:AddAbility("spawn_attackers")
	local ability2 = caster:AddAbility("spawn_defenders")
	local ability3 = caster:AddAbility("spawn_specials")
	local ability4 = caster:AddAbility("dig_plant")
	local ability5 = caster:AddAbility("plant_watermelon")
	local ability6 = caster:AddAbility("treant_end_game")

	ability1:SetLevel(1)
	ability2:SetLevel(1)
	ability3:SetLevel(1)
	ability4:SetLevel(1)	
	ability6:SetLevel(1)	
	local watermelon_lvl = 0
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	--print(#plantsPots)
	for _,ppot in pairs( plantsPots ) do 
   		if ppot:GetUnitName()=="npc_dota_plants_lab" then
   			watermelon_lvl = ppot:GetAbilityByIndex(1):GetLevel()
   		--print(watermelon_lvl)
   		end
   	end
   	caster:FindAbilityByName("plant_watermelon"):SetLevel(watermelon_lvl)

end

LinkLuaModifier("modifier_get_plants", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE)
dig_plant = class({})
function dig_plant:GetIntrinsicModifierName()
	return "modifier_get_plants"
end
function dig_plant:CastFilterResultTarget(hTarget)
	if not hTarget:HasModifier("modifier_plants") then 	return UF_FAIL_OTHER end
	local nResult = UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	return nResult	
end

modifier_get_plants = class({})
function modifier_get_plants:IsHidden() return true end
function modifier_get_plants:OnCreated()
	--self:StartIntervalThink(0.2)
end
function modifier_get_plants:OnIntervalThink()
if IsServer() then
	local caster = self:GetParent()

	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	--print(#plantsPots)
	for _,ppot in pairs( plantsPots ) do 
   		if ppot:GetUnitName()=="npc_dota_creature_plants_pot" or ppot:HasModifier("modifier_plants") then
   			--ppot:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
   			if GetMapName() == "1x1" then
   				--ppot:SetOwner(caster)
   			end
   		end
   	end
end
end
function dig_plant:OnSpellStart( bInterrupted )

	self.target = self:GetCursorTarget()

	local playerID = self:GetCaster():GetPlayerOwnerID()

	if not self.target:HasModifier("modifier_plants") then 
		--SendErrorMessage(playerID, "#error_cannot_dig_this")	
		return 
	end
end

function dig_plant:OnChannelFinish( bInterrupted )
	--print("finish")
	if not bInterrupted then
		--print("not interrupted")
		self.target:Kill(self, self:GetCaster())
	end
end

LinkLuaModifier( "modifier_kill_plants", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_kill_plants = class({})

function modifier_kill_plants:IsHidden() return true end
function modifier_kill_plants:IsPurgable() return false end
function modifier_kill_plants:RemoveOnDeath() return true end
function modifier_kill_plants:OnCreated() 
	self.caster = self:GetParent()
	self:StartIntervalThink(0.03)
end

function modifier_kill_plants:OnIntervalThink()
if IsServer() then
	--if self.caster:HasModifier("modifier_kill_plants") then
	local cd = self:GetRemainingTime()
		--print(cd)
	if cd <= 0.03 then
  		self.caster:Kill(self:GetAbility(), self:GetCaster())   		
		--self.caster:AddNewModifier(self.caster, nil, "modifier_kill", {duration = 0.03})
	else return end
end
end
function modifier_kill_plants:OnDestroy()
if not IsServer() then return end
	if self:GetParent():IsAlive() then
 		self:GetCaster():Kill(self:GetAbility(), self:GetCaster())
 	end
 end
--====================================================================
--========================= LABORATORY ===============================
--====================================================================
LinkLuaModifier("modifier_plants_lab_gold", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lab_gold_upgrade", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lab_gold_non", "zombie_spawner.lua", LUA_MODIFIER_MOTION_NONE)

plants_lab_gold = class({})

function plants_lab_gold:GetIntrinsicModifierName()
	return "modifier_plants_lab_gold"
end

modifier_plants_lab_gold = class({})

function modifier_plants_lab_gold:IsHidden() return true end
function modifier_plants_lab_gold:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end
function modifier_plants_lab_gold:OnCreated()
if IsServer() then
	local nNewState = GameRules:State_Get()
	if not self:GetParent():HasModifier("modifier_lab_gold_upgrade") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lab_gold_non", {})
	end

	self.ability = self:GetAbility()
	self.tick_min = self.ability:GetSpecialValueFor("interval_min")
	self.tick_max = self.ability:GetSpecialValueFor("interval_max")
	self:GetAbility():StartCooldown(math.random(self.tick_min,self.tick_max))
	self:StartIntervalThink(0.2)
end
end
function modifier_plants_lab_gold:OnRefresh()
	self:OnCreated()
end

function modifier_plants_lab_gold:OnIntervalThink()
if IsServer() then
	if not self:GetParent():IsStunned() and self:GetAbility():IsCooldownReady() then
		local gold = self.ability:GetSpecialValueFor("gold_gain")
		local allHeroes = HeroList:GetAllHeroes()
		for k, v in pairs( allHeroes ) do
			if v:GetUnitName()=="npc_dota_hero_treant" then
				if v:IsAlive() then
					if v:HasModifier("modifier_solo_player") then 
						v:ModifyGold(gold*2, true, 1)
					else v:ModifyGold(gold, true, 1) 
					end					
					local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
					ParticleManager:SetParticleControlEnt(midas_particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), false)
				end
			end
		end
		EmitSoundOn( "SoundSunflower", self:GetParent())
		self:GetAbility():StartCooldown(math.random(self.tick_min,self.tick_max))
	end

	
	local caster = self:GetParent()
	local plantsPots = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 
	for _,ppot in pairs( plantsPots ) do
		if ppot:GetUnitName()=="npc_dota_hero_treant" then
			caster:SetOwner(ppot)
			caster:SetControllableByPlayer( ppot:GetPlayerOwnerID(), true )  
			return 					
   		end
   	end

end
end

--[[LinkLuaModifier( "modifier_plans_lab", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE )
plants_lab_upgrade = class({})

function plants_lab_upgrade:GetIntrinsicModifierName()
	return "modifier_plans_lab"
end
modifier_plans_lab = class({})
]]

treant_end_game = class({})

function treant_end_game:OnSpellStart()

	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	--EmitGlobalSound("SoundWin")
end

function ZombieEndGame(event)
	local unit = event.activator
	if unit:HasModifier("modifier_zombie") or unit:GetUnitName()=="npc_summon_7_2" then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		--EmitGlobalSound("SoundLose")
		EmitGlobalSound("SoundScream")
	end
end

plants_house = class({})

function plants_house:GetIntrinsicModifierName()
	return "modifier_house"
end
LinkLuaModifier( "modifier_house", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE )

modifier_house = class({})

function modifier_house:IsHidden() return true end
function modifier_house:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[MODIFIER_STATE_UNSELECTABLE ] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES ] = true,
		[MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL] = true 
	}
end

--==================================================================================
--========================W A T E R M E L O N=======================================
--==================================================================================
LinkLuaModifier("modifier_plants", "modifiers/modifier_plants.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_watermelon", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_has_watermelon", "plants_spawner.lua", LUA_MODIFIER_MOTION_NONE)

plant_watermelon = class({})
function plant_watermelon:CastFilterResultTarget(hTarget)
	if hTarget:HasModifier("modifier_plants") and not hTarget:HasModifier("modifier_has_watermelon") and not hTarget:HasModifier("modifier_watermelon") then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber()) end
	return UF_FAIL_OTHER	
end
function plant_watermelon:OnAbilityPhaseStart()
	local target = self:GetCursorTarget()
	if target:HasModifier("modifier_plants") and not target:HasModifier("modifier_has_watermelon") then return true end
	return false
end

function plant_watermelon:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local i = self:GetLevel()
	local watermelon = CreateUnitByName("npc_dota_watermelon_"..i, (target:GetAbsOrigin())+target:GetForwardVector(), false, nil, nil, DOTA_TEAM_GOODGUYS)
	watermelon:AddNewModifier(caster, self, "modifier_plants", {})
	watermelon:AddNewModifier(caster, self, "modifier_disable_turning", {})
	watermelon:AddNewModifier(caster, self, "modifier_watermelon", {})
	target:AddNewModifier(caster, self, "modifier_has_watermelon", {})
end

modifier_has_watermelon = class({})

function modifier_has_watermelon:IsHidden() return true end
function modifier_has_watermelon:RemoveOnDeath() return true end
function modifier_has_watermelon:OnCreated()
if IsServer() then
	self:StartIntervalThink(0.1)
end
end
function modifier_has_watermelon:OnIntervalThink()
if IsServer() then
	local caster = self:GetParent()

	local plants = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	
	if #plants==1 then
		caster:RemoveModifierByName("modifier_has_watermelon")
	end
	

end
end

modifier_watermelon = class({})

function modifier_watermelon:IsHidden() return true end
function modifier_watermelon:RemoveOnDeath() return true end
function modifier_watermelon:OnCreated()
if IsServer() then	
	self:StartIntervalThink(0.1)
end	
end
function modifier_watermelon:OnIntervalThink()
if IsServer() then
	local caster = self:GetParent()

	local plants = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	--print(#plantsPots)
	for _,plant in pairs( plants ) do --если очень близко растение или куст, магнитимся к нему
   		if plant:HasModifier("modifier_plants") or plant:HasModifier("modifier_plants_pot") then
   			caster:SetAbsOrigin(plant:GetAbsOrigin())
   		end
   	end

end
end
function modifier_watermelon:OnDeath()
if IsServer() then
	local caster = self:GetParent()
	local plants = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
	--print(#plantsPots)
	for _,plant in pairs( plants ) do --если очень близко растение или куст, магнитимся к нему
   		if plant:HasModifier("modifier_plants") and plant:HasModifier("modifier_has_watermelon") then
   			plant:RemoveAbility("modifier_has_watermelon")   			
   		end
   	end
end	
end

plants_lab_watermelon = class({})

function plants_lab_watermelon:GetBehavior()
	if self:GetCaster():FindAbilityByName("plants_lab_watermelon"):GetLevel()==3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function plants_lab_watermelon:GetGoldCost(lvl)
	if self:GetCaster():FindAbilityByName("plants_lab_watermelon"):GetLevel()==3 then
		return 0
	end
	if GetMapName()=="2x2" then
		return self:GetSpecialValueFor("gold_cost_2x2")
	end
	return self:GetSpecialValueFor("gold_cost")
end
function plants_lab_watermelon:OnSpellStart()
	local lvl = self:GetLevel()
	--print("lvl is "..lvl)
	if lvl ~= 3 then
		self:SetLevel(lvl+1)
	end
	
	for k, v in pairs(HeroList:GetAllHeroes()) do
		if v:GetUnitName()=="npc_dota_hero_treant" then
			if v:HasAbility("plant_watermelon") then
				v:FindAbilityByName("plant_watermelon"):SetLevel(lvl+1)
			end
		end
	end

end
