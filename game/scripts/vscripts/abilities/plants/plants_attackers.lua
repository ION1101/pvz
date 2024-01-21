LinkLuaModifier( "modifier_plants", "modifiers/modifier_plants.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_turning", "modifiers/modifier_disable_turning.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_superdefender", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_attacker_1_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_2_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_3_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_3_penetration", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_3_penetration_debuff", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_4_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_42_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_43_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_5_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_5_bash", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_attacker_53_attacks", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pumpin_damage_reduction", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_1_cooldown", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_2_cooldown", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_3_cooldown", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_4_cooldown", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attacker_5_cooldown", "abilities/plants/plants_attackers.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_poison", "abilities/zombies/zombies.lua", LUA_MODIFIER_MOTION_NONE )

modifier_attacker_1_cooldown = class({})
function modifier_attacker_1_cooldown:IsHidden() return false end
function modifier_attacker_1_cooldown:GetTexture() return "plants/attacker1" end
modifier_attacker_2_cooldown = class({})
function modifier_attacker_2_cooldown:IsHidden() return false end
function modifier_attacker_2_cooldown:GetTexture() return "plants/attacker2" end
modifier_attacker_3_cooldown = class({})
function modifier_attacker_3_cooldown:IsHidden() return false end
function modifier_attacker_3_cooldown:GetTexture() return "plants/attacker3" end
modifier_attacker_4_cooldown = class({})
function modifier_attacker_4_cooldown:IsHidden() return false end
function modifier_attacker_4_cooldown:GetTexture() return "plants/attacker4" end
modifier_attacker_5_cooldown = class({})
function modifier_attacker_5_cooldown:IsHidden() return false end
function modifier_attacker_5_cooldown:GetTexture() return "plants/attacker5" end


ability_kill_line = class({})
modifier_superdefender = class({})

function ability_kill_line:GetIntrinsicModifierName()
	return "modifier_superdefender"
end

function ability_kill_line:CleanUpLine()
if IsServer() then
	--print("CleanUpLine")
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local particleName = "particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf"
	local lines = pvzGameMode:GetLines()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE , 0, false)
	

	for _,target in pairs(targets) do
		for i = 1, lines do
			if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
				if target:GetUnitName() == "npc_dota_creature_tombstone" then
					target:AddNewModifier(caster, self, "modifier_stunned", {duration = 15})
				elseif (not target:HasModifier("modifier_kill") and not target:IsRealHero()) then
					local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					target:AddNewModifier(caster, self, "modifier_kill", {duration = 0.3})
					target:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
					local allHeroes = HeroList:GetAllHeroes()
					for k, v in pairs( allHeroes ) do
						if v:GetUnitName()=="npc_dota_hero_treant" then							
							for j = 1, 5 do
								if v:HasModifier("modifier_special_"..j.."_cooldown") then
									v:RemoveModifierByName("modifier_special_"..j.."_cooldown")
								end
								local plantsPots = FindUnitsInRadius(v:GetTeamNumber(), v:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
								for _,ppot in pairs( plantsPots ) do 
							   		if ppot:GetUnitName()=="npc_dota_creature_plants_pot" or ppot:HasModifier("modifier_plants") then
							   			if ppot:HasAbility("plants_special_"..j) then
								   			if not ppot:FindAbilityByName("plants_special_"..j):IsCooldownReady() then
												ppot:FindAbilityByName("plants_special_"..j):EndCooldown()
											end
										end
							   		end
						   		end
							end
						end
					end
					if target:GetUnitName()=="npc_cannon" then target:RemoveSelf() end
				end
			end
		end  
	end
	Timers:CreateTimer(0.6, function()
		caster:AddNewModifier(caster, self, "modifier_kill", {duration = 0.03})
	end)
end
end

function modifier_superdefender:IsHidden() return true end
function modifier_superdefender:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_superdefender:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = false,
		[MODIFIER_STATE_OUT_OF_GAME] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}

end


function  modifier_superdefender:OnIntervalThink()
if IsServer() then
	local defender = self:GetParent()
	local targets = FindUnitsInRadius(defender:GetTeamNumber(), defender:GetAbsOrigin(), nil, 125, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	--print(#targets)
	local lines = pvzGameMode:GetLines()
	local trigger = false

	if #targets==0 then return end -- если врагов рядом нет обрубаем функцию

	for _,target in pairs(targets) do
		for i=1, lines do
			if defender:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then -- если рядом зомби с нужной линии
				trigger = true
			end
		end  
	end

	if trigger == true then
		self:GetAbility():CleanUpLine()
		defender:RemoveModifierByName("modifier_superdefender")
	end
end
end

--===========================================================================
--============================ SPAWN 1 ATTACKER -----------------------------
--===========================================================================

plants_attacker_1 = class ({})
function plants_attacker_1:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_attacker_1:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_1"

	self.attacker_1 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin()), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.attacker_1:SetOwner(caster)
	self.attacker_1:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.attacker_1:AddNewModifier(self.attacker_1, self, "modifier_plants", {})
	self.attacker_1:AddNewModifier(self.attacker_1, self, "modifier_disable_turning", {})	

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_attacker_1") then v:FindAbilityByName("plants_attacker_1"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_attacker_1_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
end

--=================================================================================================================
--============================================= ATTACKER 1 SKILLS =================================================
--=================================================================================================================
attacker_1_upgrade = class({})

function attacker_1_upgrade:OnSpellStart()

	local caster = self:GetCaster()

	local unit_name = "npc_plants_attacker_1_2"
	
	self.upgraded_attacker_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_1:SetOwner(caster:GetOwner())
	self.upgraded_attacker_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_1:SetHealth(self.upgraded_attacker_1:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, self, "modifier_plants", {})
	self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, self, "modifier_disable_turning", {})
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_1)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

attacker_12_upgrade = class({})

function attacker_12_upgrade:OnSpellStart()

	local caster = self:GetCaster()

	local unit_name = "npc_plants_attacker_1_3"
	
	self.upgraded_attacker_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_1:SetOwner(caster:GetOwner())
	self.upgraded_attacker_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_1:SetHealth(self.upgraded_attacker_1:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, self, "modifier_plants", {})
	self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, self, "modifier_disable_turning", {})
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_1)

	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_1:AddNewModifier(self.upgraded_attacker_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end

	caster:RemoveSelf()
	UTIL_Remove(caster)
end


attacker_1_attacks = class({})
attacker_1_double_attacks = class({})
modifier_attacker_1_attacks = class({})

function attacker_1_attacks:GetIntrinsicModifierName()
	return "modifier_attacker_1_attacks"
end

function attacker_1_attacks:OnCreated()
if IsServer() then 
	local flower = self:GetCaster()		
	flower:StartGesture( ACT_DOTA_ATTACK )
	Timers:CreateTimer(0.34, function()
		if flower == nil then return end
		if flower:IsAlive() then
			self.projID = ProjectileManager:CreateLinearProjectile( {
		      Ability = self,
		      EffectName = "particles/attacker1_projectile.vpcf",
		      vSpawnOrigin = flower:GetAbsOrigin() + flower:GetForwardVector()*45,
		      fDistance = 2000,
		      fStartRadius = 50,
		      fEndRadius = 100,
		      Source = flower,
		      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		      iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		      bDeleteOnHit = true,
		      vVelocity = flower:GetForwardVector() * 750,
		      bProvidesVision = false,
	   		 } )
			EmitSoundOn( "Hero_Leshrac.Attack", flower)

		end
	end)
end
end

function attacker_1_attacks:OnProjectileHit(hTarget, vLocation)
	local caster = self:GetCaster()
	if hTarget == nil or hTarget:HasModifier("modifier_cannot_be_attacked") then return end
	caster:PerformAttack(hTarget, true, true, true, false, false, false, false)
	local particle = "particles/wisp_guardian_explosion_ti7.vpcf"
	local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(fx, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(fx)
	EmitSoundOn( "Hero_Leshrac.ProjectileImpact", hTarget)
	return true
end

function modifier_attacker_1_attacks:IsHidden() return true end
function modifier_attacker_1_attacks:IsPurgable() return false end

function modifier_attacker_1_attacks:OnCreated()
	local unit_level = self:GetParent():GetLevel()
	local interval = 1
	if unit_level >= 2	then interval = 0.9 end
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
	--self:GetParent():StartGesture( ACT_DOTA_ATTACK )
end
function modifier_attacker_1_attacks:OnDeath()
	self:GetParent():RemoveModifierByName("modifier_attacker_1_attacks")
end
function modifier_attacker_1_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines = pvzGameMode:GetLines()
	local zombies_in_front = 0
	
	local attack_cone = 30

	local flower = self:GetParent()

	--print("IntervalThink")
	local should_attack = false -- стрелять нельзя
	local targets = FindUnitsInRadius(flower:GetTeamNumber(), flower:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local attackable_enemies = 0
	--print(#targets)
	if #targets >= 1 then
		for _,target in pairs(targets) do

			local same_line = false

			if flower:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
				for i=1, lines do
					if flower:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
						same_line = true
					end
				end  
			end

			if same_line == true then
				local flower_location = flower:GetAbsOrigin()
				local target_location = target:GetAbsOrigin()
				
				local direction = (flower_location - target_location):Normalized() -- вектор между цветком и зомбаком
				local direction_flower = (target_location - flower_location):Normalized() -- вектор между зомбаком и цветком
				local forward_vector = target:GetForwardVector()  -- направление взгляда зомбака
				local forward_vector_flower = flower:GetForwardVector() -- направление взгляда зомбака
				local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

				local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
				--print("Angle: target" .. angle)
				--print("Angle: flower" .. angle_flower)

				if angle_flower<=attack_cone then
					if not target:HasModifier("modifier_cannot_be_attacked") then
						attackable_enemies = attackable_enemies + 1
					end
				end
			end
		end
	end

	--print("attackable_enemies "..attackable_enemies)
	--print("zombies_in_front "..zombies_in_front)
	if attackable_enemies >=1 then
		should_attack = true
	else should_attack = false
	end

	if not flower:IsAlive() then should_attack = false end

	if should_attack == true then
		self:GetAbility():OnCreated()

		if flower:GetLevel() == 3 then
			flower:FindAbilityByName("attacker_1_double_attacks"):MakeProjectile()
		end
	end
end
end

function attacker_1_double_attacks:MakeProjectile()
if IsServer() then
	--print("make projectile")
	local flower = self:GetCaster()
	
	--flower:StartGesture( ACT_DOTA_ATTACK )

	Timers:CreateTimer(0.54, function()
		if flower == nil then return end
		if flower:IsAlive() then
			self.projID = ProjectileManager:CreateLinearProjectile( {
		      Ability = self,
		      EffectName = "particles/attacker1_projectile.vpcf",
		      vSpawnOrigin = flower:GetAbsOrigin() + flower:GetForwardVector()*45,
		      fDistance = 2000,
		      fStartRadius = 50,
		      fEndRadius = 100,
		      Source = flower,
		      --bHasFrontalCone = false,
		      --bReplaceExisting = false,
		      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		      iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		      bDeleteOnHit = true,
		      vVelocity = flower:GetForwardVector() * 750,
		      bProvidesVision = false,
		      --iVisionRadius = 0,
		      --iVisionTeamNumber = flower:GetTeamNumber()
	   		 } )
			EmitSoundOn( "Hero_Leshrac.Attack", flower)
			--print(self.projID)
		end
	end)
end
end


function attacker_1_double_attacks:OnProjectileHit(hTarget, vLocation)
	local caster = self:GetCaster()
	if hTarget == nil or hTarget:HasModifier("modifier_cannot_be_attacked") then return end
	local particle = "particles/wisp_guardian_explosion_ti7.vpcf"
	local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(fx, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(fx)
	--print("second hit unit")
	caster:PerformAttack(hTarget, true, true, true, false, false, false, false)

	EmitSoundOn( "Hero_Leshrac.ProjectileImpact", caster)
	--ProjectileManager:DestroyLinearProjectile(self.projID)
	--particles/leshrac_base_attack_e.vpcf

	return true
end


--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================
--				--									==============
--				--									==         ===
--				--											===
--				--										 ===
--				--									  ===		 ==
--				--									===============
--==================================================================================================================================================
--============================================= ATTACKER 2 SKILLS ==================================================================================
--==================================================================================================================================================

--===========================================================================
--============================ SPAWN 2 ATTACKER -----------------------------
--===========================================================================

plants_attacker_2 = class ({})
function plants_attacker_2:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_attacker_2:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_2"
	self.attacker_2 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin()), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.attacker_2:SetOwner(caster)
	self.attacker_2:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.attacker_2:AddNewModifier(self.attacker_2, self, "modifier_plants", {})
	self.attacker_2:AddNewModifier(self.attacker_2, self, "modifier_disable_turning", {})
	self.attacker_2:FindAbilityByName("attacker_2_attacks"):SetLevel(1)
	self.attacker_2:FindAbilityByName("attacker_2_attacks"):SetLevel(1)
	
	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then	
			if v:HasAbility("plants_attacker_2") then v:FindAbilityByName("plants_attacker_2"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_attacker_2_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

attacker_2_upgrade = class({})
function attacker_2_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_2_2"
	self.upgraded_attacker_2 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_2:SetOwner(caster:GetOwner())
	self.upgraded_attacker_2:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_2:SetHealth(self.upgraded_attacker_2:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, self, "modifier_plants", {})
	self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, self, "modifier_disable_turning", {})
	self.upgraded_attacker_2:FindAbilityByName("attacker_2_attacks"):SetLevel(2)
	self.upgraded_attacker_2:FindAbilityByName("attacker_2_splash"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_2)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

attacker_22_upgrade = class({})
function attacker_22_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_2_3"
	self.upgraded_attacker_2 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_2:SetOwner(caster:GetOwner())
	self.upgraded_attacker_2:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_2:SetHealth(self.upgraded_attacker_2:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, self, "modifier_plants", {})
	self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, self, "modifier_disable_turning", {})
	self.upgraded_attacker_2:FindAbilityByName("attacker_2_attacks"):SetLevel(3)
	self.upgraded_attacker_2:FindAbilityByName("attacker_2_splash"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_2)	
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_2:AddNewModifier(self.upgraded_attacker_2, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ ATTACKER 2 ABILITIES -------------------------
--===========================================================================

attacker_2_attacks = class({})

function attacker_2_attacks:GetIntrinsicModifierName()
	return "modifier_attacker_2_attacks"
end

function attacker_2_attacks:OnCreated()
if IsServer() then
	--print("oncreated")
	local flower = self:GetCaster()
	flower:StartGesture( ACT_DOTA_ATTACK )
	Timers:CreateTimer(0.34, function()
		if flower == nil then return end
		if flower:IsAlive() then

			self.projID = ProjectileManager:CreateLinearProjectile( {
		      Ability = self,
		      EffectName = "particles/attacker2_projectile.vpcf",
		      vSpawnOrigin = flower:GetAbsOrigin() + flower:GetForwardVector()*45,
		      fDistance = 2000,
		      fStartRadius = 50,
		      fEndRadius = 100,
		      Source = flower,
		      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		      iUnitTargetType = DOTA_UNIT_TARGET_ALL,
		      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		      bDeleteOnHit = true,
		      vVelocity = flower:GetForwardVector() * 750,
		      bProvidesVision = false,
	   		 } )
			EmitSoundOn( "Hero_Puck.Attack", flower)
		end
	end)
end
end

function attacker_2_attacks:OnProjectileHit(hTarget, vLocation)
	local caster = self:GetCaster()
	if hTarget == nil or hTarget:HasModifier("modifier_cannot_be_attacked") then return end
	--print("first hit unit")
	caster:PerformAttack(hTarget, true, true, true, false, false, false, false)

	local level = self:GetCaster():GetLevel()
	local ability_name = "attacker_2_splash"
	--print(ability_name)
	local splash_ability = self:GetCaster():FindAbilityByName(ability_name)
	level = splash_ability:GetLevel()
	--print("lvl ability is "..level)

	local plant_damage = self:GetCaster():GetAttackDamage()
	local dmg = splash_ability:GetSpecialValueFor("damage")
	local radius = splash_ability:GetSpecialValueFor("radius")
	local damage = (plant_damage * dmg) / 100
	--print("dmg is "..damage)
	--print("radius is "..radius)
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	--print(#targets)
	for _,target in pairs(targets) do
		local damage_table = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL
			}
			if target == hTarget then
				damage_table.damage = 0
			end
			ApplyDamage( damage_table )
		
	end
	local particle = "particles/attacker_2_explodevpcf.vpcf"
	local fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(fx, 1, hTarget:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(fx)

	local splash_particle = ParticleManager:CreateParticle("particles/attacker_2_splash_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)

	ParticleManager:SetParticleControl(splash_particle, PATTACH_ABSORIGIN_FOLLOW, Vector( radius, radius, 0 ))

	EmitSoundOn( "Hero_Puck.ProjectileImpact", hTarget)
	return true
end

modifier_attacker_2_attacks = class({})

function modifier_attacker_2_attacks:IsHidden() return true end
function modifier_attacker_2_attacks:IsPurgable() return false end
function modifier_attacker_2_attacks:RemoveOnDeath() return true end

function modifier_attacker_2_attacks:OnCreated()
	local unit_level = self:GetParent():GetLevel()
	local interval = 1.5 -- ATTACK RATE
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
	--self:GetParent():StartGesture( ACT_DOTA_ATTACK )
end
function modifier_attacker_2_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines = pvzGameMode:GetLines()
	local zombies_in_front = 0
	
	local attack_cone = 30

	local flower = self:GetParent()

	--print("IntervalThink")
	local should_attack = false -- стрелять нельзя
	local targets = FindUnitsInRadius(flower:GetTeamNumber(), flower:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local attackable_enemies = 0
	--print(#targets)
	if #targets >= 1 then
		for _,target in pairs(targets) do

			local same_line = false

			if flower:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
				for i=1, lines do
					if flower:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
						--print("they are on the same line")
						same_line = true
					end
				end  
			end

			if same_line == true then
				local flower_location = flower:GetAbsOrigin()
				local target_location = target:GetAbsOrigin()
				
				local direction = (flower_location - target_location):Normalized() -- вектор между цветком и зомбаком
				local direction_flower = (target_location - flower_location):Normalized() -- вектор между зомбаком и цветком
				local forward_vector = target:GetForwardVector()  -- направление взгляда зомбака
				local forward_vector_flower = flower:GetForwardVector() -- направление взгляда зомбака
				local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

				local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
				--print("Angle: target" .. angle)
				--print("Angle: flower" .. angle_flower)

				if angle_flower<=attack_cone then -- если зомби спереди
					if not target:HasModifier("modifier_cannot_be_attacked") then
						attackable_enemies = attackable_enemies + 1
					end
				end
			end
		end
	end

	--print("attackable_enemies "..attackable_enemies)
	--print("zombies_in_front "..zombies_in_front)
	if attackable_enemies >=1 then
		should_attack = true
	else should_attack = false
	end

	if not flower:IsAlive() then should_attack = false end

	if should_attack == true then
		self:GetAbility():OnCreated()
	end
end
end

-- SPASH ATTACKS --
attacker_2_splash = class({})



--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================
--				--									==============
--				--									=          ===
--				--											   ===
--				--									    ==========
--				--											   ===
--				--									=		   ===
--				--									==============
--==================================================================================================================================================
--============================================= ATTACKER 3 SKILLS ==================================================================================
--==================================================================================================================================================

--===========================================================================
--============================ SPAWN 3 ATTACKER -----------------------------
--===========================================================================

plants_attacker_3 = class ({})
function plants_attacker_3:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_attacker_3:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_3"
	self.attacker_3 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() + self:GetCursorTarget():GetForwardVector()*40), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.attacker_3:SetOwner(caster)
	self.attacker_3:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.attacker_3:AddNewModifier(self.attacker_3, self, "modifier_plants", {})
	self.attacker_3:AddNewModifier(self.attacker_3, self, "modifier_disable_turning", {})
	self.attacker_3:FindAbilityByName("attacker_3_attacks"):SetLevel(1)

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_attacker_3") then v:FindAbilityByName("plants_attacker_3"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_attacker_3_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

attacker_3_upgrade = class({})
function attacker_3_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_3_2"
	self.upgraded_attacker_3 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_3:SetOwner(caster:GetOwner())
	self.upgraded_attacker_3:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_3:SetHealth(self.upgraded_attacker_3:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, self, "modifier_plants", {})
	self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, self, "modifier_disable_turning", {})
	self.upgraded_attacker_3:FindAbilityByName("attacker_3_attacks"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_3)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

attacker_32_upgrade = class({})
function attacker_32_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_3_3"
	self.upgraded_attacker_3 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_3:SetOwner(caster:GetOwner())
	self.upgraded_attacker_3:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_3:SetHealth(self.upgraded_attacker_3:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, self, "modifier_plants", {})
	self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, self, "modifier_disable_turning", {})
	self.upgraded_attacker_3:FindAbilityByName("attacker_3_attacks"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_3)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_3:AddNewModifier(self.upgraded_attacker_3, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ ATTACKER 3 ABILITIES =========================
--===========================================================================

attacker_3_attacks = class({})

function attacker_3_attacks:GetIntrinsicModifierName()
	return "modifier_attacker_3_attacks"
end

modifier_attacker_3_attacks = class({})

function modifier_attacker_3_attacks:IsHidden() return true end
function modifier_attacker_3_attacks:RemoveOnDeath() return true end


function modifier_attacker_3_attacks:OnCreated()
	self.radius = 350
	local unit_level = self:GetParent():GetLevel()
	local interval = 0.9
	if unit_level == 2	then interval = 0.7 
	elseif unit_level == 3 then interval = 0.5 
	end
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
	--self:GetParent():StartGesture( ACT_DOTA_ATTACK )
end
function modifier_attacker_3_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines = pvzGameMode:GetLines()
	local zombies_in_front = 0
	
	local attack_cone = 30
	local caster = self:GetParent()
	local enemy = nil
	--print("interval think")
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	if #targets >= 1 then
		for _,target in pairs(targets) do -- перебор мелких
			if enemy == nil then --как только найдём врага сразу перестанем перебирать

				local same_line = false

				if caster:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
					for i=1, lines do
						if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
							--print("they are on the same line")
							same_line = true
						end
					end  
				end

				if same_line == true then

					local flower_location = caster:GetAbsOrigin()
					local target_location = target:GetAbsOrigin()
					
					local direction = (flower_location - target_location):Normalized() -- вектор между цветком и зомбаком
					local direction_flower = (target_location - flower_location):Normalized() -- вектор между зомбаком и цветком
					local forward_vector = target:GetForwardVector()  -- направление взгляда зомбака
					local forward_vector_flower = caster:GetForwardVector() -- направление взгляда зомбака
					--local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					--print("Angle: target" .. angle)
					--print("Angle: caster" .. angle_flower)

					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end

		if zombies_in_front >= 1 then
			EmitSoundOn("Furion_Treant.PreAttack", caster)
			caster:StartGesture(ACT_DOTA_ATTACK)
			Timers:CreateTimer(0.4, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Furion_Treant.Attack", caster)
				EmitSoundOn("Creep_Good_Melee.Attack", caster)
			end)
		end
	end
	end
end


attacker_3_penetration = class({})

function attacker_3_penetration:GetIntrinsicModifierName()
	return "modifier_attacker_3_penetration"
end
modifier_attacker_3_penetration = class({})
modifier_attacker_3_penetration.OnRefresh = modifier_attacker_3_penetration.OnCreated

function modifier_attacker_3_penetration:IsHidden() return true end
function modifier_attacker_3_penetration:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
function modifier_attacker_3_penetration:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_attacker_3_penetration:GetModifierProcAttack_Feedback(params)

	local target = params.target
	if not target:HasModifier("modifier_attacker_3_penetration_debuff") then
		local modifier = target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_attacker_3_penetration_debuff", {duration = self.duration,})
		if not modifier == nil then
			modifier:SetStackCount(1)
		end
	else 
		local stack_count = target:GetModifierStackCount("modifier_attacker_3_penetration_debuff", self:GetParent())
		if stack_count >= 5 then stack_count = 4 end
		target:RemoveModifierByName("modifier_attacker_3_penetration_debuff")
		target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_attacker_3_penetration_debuff", {duration = self.duration,})
		target:SetModifierStackCount("modifier_attacker_3_penetration_debuff", self:GetParent(), stack_count + 1)
	end

end

modifier_attacker_3_penetration_debuff = class({})
function modifier_attacker_3_penetration_debuff:GetTexture() return "plants/attacker3_penetration" end
modifier_attacker_3_penetration_debuff.OnRefresh = modifier_attacker_3_penetration_debuff.OnCreated
function modifier_attacker_3_penetration_debuff:IsHidden() return false end
function modifier_attacker_3_penetration_debuff:OnCreated()
 	self.armor = 0 - self:GetAbility():GetSpecialValueFor("armor")
 end 
function modifier_attacker_3_penetration_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_attacker_3_penetration_debuff:GetModifierPhysicalArmorBonus() return self:GetStackCount() * self.armor end


--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================
--				--									==          ==
--				--									==          ==
--				--									==		    ==
--				--									==============
--				--											   ===
--				--											   ===
--				--											   ===
--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================
------------------------------------- P U M P K I N -------------------------------------
--===========================================================================
--============================ SPAWN 4 ATTACKER -----------------------------
--===========================================================================

plants_attacker_4 = class ({})
function plants_attacker_4:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_attacker_4:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_4"
	self.attacker_4 = CreateUnitByName(unit_name, self:GetCursorTarget():GetAbsOrigin(), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.attacker_4:SetOwner(caster)
	self.attacker_4:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.attacker_4:AddNewModifier(self.attacker_4, self, "modifier_plants", {})
	self.attacker_4:AddNewModifier(self.attacker_4, self, "modifier_disable_turning", {})
	self.attacker_4:FindAbilityByName("attacker_4_attacks"):SetLevel(1)
	self.attacker_4:FindAbilityByName("attacker_4_splash_attacks"):SetLevel(1)	

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_attacker_4") then v:FindAbilityByName("plants_attacker_4"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_attacker_4_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
end

attacker_4_upgrade = class({})
function attacker_4_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_4_2"
	self.upgraded_attacker_4 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_4:SetOwner(caster:GetOwner())
	self.upgraded_attacker_4:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_4:SetHealth(self.upgraded_attacker_4:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, self, "modifier_plants", {})
	self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, self, "modifier_disable_turning", {})
	self.upgraded_attacker_4:FindAbilityByName("attacker_4_attacks"):SetLevel(2)
	self.upgraded_attacker_4:FindAbilityByName("attacker_4_splash_attacks"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_4)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

attacker_42_upgrade = class({})
function attacker_42_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_4_3"
	self.upgraded_attacker_4 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_4:SetOwner(caster:GetOwner())
	self.upgraded_attacker_4:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_4:SetHealth(self.upgraded_attacker_4:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, self, "modifier_plants", {})
	self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, self, "modifier_disable_turning", {})
	self.upgraded_attacker_4:FindAbilityByName("attacker_4_attacks"):SetLevel(3)
	self.upgraded_attacker_4:FindAbilityByName("attacker_4_splash_attacks"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_4)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_4:AddNewModifier(self.upgraded_attacker_4, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end


--==================================================================================================================================================
--============================================= ATTACKER 4 SKILLS ==================================================================================
--==================================================================================================================================================
attacker_4_splash_attacks = class({})
attacker_4_attacks = class({})

function attacker_4_attacks:GetIntrinsicModifierName()
	return "modifier_attacker_4_attacks"
end

function attacker_4_attacks:MakeProjectile(enemy, line)
if IsServer() then
	local flower = self:GetCaster()
	flower:StartGesture( ACT_DOTA_ATTACK )
	local projectile_name = "particles/attacker_4_projectile.vpcf"
	local projectile_speed = 800
	local info = {
		Target = enemy,
		Source = flower,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,
		ExtraData = { 
			data = line,
		}
	}

	Timers:CreateTimer(0.4, function()
		ProjectileManager:CreateTrackingProjectile(info)
		EmitSoundOn("SoundPumpkinGo"..math.random(1,4), flower)
	end)
end
function attacker_4_attacks:OnProjectileHit_ExtraData( hTarget, location, extraData)
	if not hTarget then return end
	if extraData.data == 0 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pumpin_damage_reduction", {})
	end
	self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, false, false)
	EmitSoundOn("SoundPumpkinHit", self:GetCaster())
	EmitSoundOn("SoundPumpkinHit"..math.random(1,2), self:GetCaster())
	if self:GetCaster():HasModifier("modifier_pumpin_damage_reduction") then
		self:GetCaster():RemoveModifierByName("modifier_pumpin_damage_reduction")
	end
	return true
end
end

modifier_attacker_4_attacks = class({})

function modifier_attacker_4_attacks:IsHidden() return true end
function modifier_attacker_4_attacks:RemoveOnDeath() return true end
function modifier_attacker_4_attacks:OnCreated()
if IsServer() then
	self.targets = self:GetParent():GetLevel()
	--print("targets are "..self.targets)
	--self:OnIntervalThink()
	self:StartIntervalThink(2)
end
end

function modifier_attacker_4_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	if not self:GetParent():IsAlive() then return end
	local attacked = 0
	local flower = self:GetParent()
	local lines = pvzGameMode:GetLines()
	

	local targets = FindUnitsInRadius(flower:GetTeamNumber(), flower:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local attackable_enemies = 0

	if #targets >= 1 then
		for _,target in pairs(targets) do
			if attacked < self.targets then
				if flower:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") and not target:HasModifier("modifier_cannot_be_attacked") and target:GetUnitName()~="npc_zombie_4_3" then
					for i=1, lines do  -- если с основной линии
						if attacked < self.targets then
							if flower:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
								--print("main line")
								local enemy = target
								local line = 1
								self:GetAbility():MakeProjectile(enemy, line)
								attacked = attacked + 1
							elseif flower:HasModifier("modifier_line_"..i) and (target:HasModifier("modifier_line_"..i+1) or target:HasModifier("modifier_line_"..i-1)) then
								--print("adj line")
								local enemy = target
								local line = 0
								self:GetAbility():MakeProjectile(enemy, line)
								attacked = attacked + 1
							end
						end
					end  
				end
			end
		end
	end
end
end

modifier_pumpin_damage_reduction = class({})

function modifier_pumpin_damage_reduction:IsHidden() return true end
function modifier_pumpin_damage_reduction:IsPurgable() return false end
function modifier_pumpin_damage_reduction:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_pumpin_damage_reduction:GetModifierDamageOutgoing_Percentage()
	return -25--self:GetAbility():GetSpecialValueFor("dmg")
end
--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================
--				--									==============
--				--									==           
--				--									==
--				--									==============
--				--											    ==
--				--											    ==
--				--									==============
--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================

--===========================================================================
--============================ SPAWN 5 ATTACKER -----------------------------
--===========================================================================

plants_attacker_5 = class({})
function plants_attacker_5:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_attacker_5:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_5"
	self.attacker_5 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() + self:GetCursorTarget():GetForwardVector()*40), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.attacker_5:SetOwner(caster)
	self.attacker_5:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.attacker_5:AddNewModifier(self.attacker_5, self, "modifier_plants", {})
	self.attacker_5:AddNewModifier(self.attacker_5, self, "modifier_disable_turning", {})
	self.attacker_5:FindAbilityByName("attacker_5_attacks"):SetLevel(1)
	self.attacker_5:FindAbilityByName("attacker_5_bash"):SetLevel(1)

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_attacker_5") then v:FindAbilityByName("plants_attacker_5"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_attacker_5_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
end

attacker_5_upgrade = class({})
function attacker_5_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_5_2"
	self.upgraded_attacker_5 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_5:SetOwner(caster:GetOwner())
	self.upgraded_attacker_5:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_5:SetHealth(self.upgraded_attacker_5:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, self, "modifier_plants", {})
	self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, self, "modifier_disable_turning", {})
	self.upgraded_attacker_5:FindAbilityByName("attacker_5_attacks"):SetLevel(2)
	self.upgraded_attacker_5:FindAbilityByName("attacker_5_bash"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_5)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

attacker_52_upgrade = class({})
function attacker_52_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_attacker_5_3"
	self.upgraded_attacker_5 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_attacker_5:SetOwner(caster:GetOwner())
	self.upgraded_attacker_5:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_attacker_5:SetHealth(self.upgraded_attacker_5:GetMaxHealth()/100*health_pct)
	self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, self, "modifier_plants", {})
	self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, self, "modifier_disable_turning", {})
	self.upgraded_attacker_5:FindAbilityByName("attacker_5_attacks"):SetLevel(3)
	self.upgraded_attacker_5:FindAbilityByName("attacker_5_bash"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_attacker_5)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_attacker_5:AddNewModifier(self.upgraded_attacker_5, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ ATTACKER 5 ABILITIES =========================
--===========================================================================
attacker_5_attacks = class({})

function attacker_5_attacks:GetIntrinsicModifierName()
	return "modifier_attacker_5_attacks"
end

modifier_attacker_5_attacks = class({})

function modifier_attacker_5_attacks:IsHidden() return true end
function modifier_attacker_5_attacks:RemoveOnDeath() return true end

modifier_attacker_5_attacks.OnRefresh = modifier_attacker_5_attacks.OnCreated 

function modifier_attacker_5_attacks:OnCreated()
	self.radius = 350
	local unit_level = self:GetParent():GetLevel()
	local interval = 0.5
	if unit_level == 2	then interval = 0.4
	elseif unit_level == 3 then interval = 0.3
	end
	self:OnIntervalThink()
	--print("unit level is "..unit_level)
	self:StartIntervalThink(interval)
end
function modifier_attacker_5_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines = pvzGameMode:GetLines()
	local zombies_in_front = 0
	
	local attack_cone = 30
	local caster = self:GetParent()
	local enemy = nil
	--print("interval think")
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	if #targets >= 1 then
		for _,target in pairs(targets) do -- перебор мелких
			if enemy == nil then --как только найдём врага сразу перестанем перебирать

				local same_line = false

				if caster:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
					for i=1, lines do
						if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
							same_line = true
						end
					end  
				end

				if same_line == true then

					local flower_location = caster:GetAbsOrigin()
					local target_location = target:GetAbsOrigin()
					
					local direction = (flower_location - target_location):Normalized() -- вектор между цветком и зомбаком
					local direction_flower = (target_location - flower_location):Normalized() -- вектор между зомбаком и цветком
					local forward_vector = target:GetForwardVector()  -- направление взгляда зомбака
					local forward_vector_flower = caster:GetForwardVector() -- направление взгляда зомбака
					--local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					--print("Angle: target" .. angle)
					--print("Angle: caster" .. angle_flower)

					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end

		local interval = 0.25
		local anim_dur = 2
		if caster:GetLevel() == 2 then
			anim_dur = 2.5
			interval = 0.2
		elseif caster:GetLevel() == 3 then
			anim_dur = 1/0.3
			interval = 0.15
		end
		--print("interval "..interval)
		if zombies_in_front >= 1 then
			EmitSoundOn("Furion_Treant.PreAttack", caster)
			EmitSoundOn("SoundPreattack"..math.random(1,4), caster)
			caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, anim_dur)
			Timers:CreateTimer(interval, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Furion_Treant.Attack", caster)
			end)
		end
	end
	end
end

--===================================================
--=================== BASH ==========================
--===================================================

attacker_5_bash = class({})

function attacker_5_bash:GetIntrinsicModifierName()
	return "modifier_attacker_5_bash"
end

modifier_attacker_5_bash = class({})
modifier_attacker_5_bash.OnRefresh = modifier_attacker_3_penetration.OnCreated

function modifier_attacker_5_bash:IsHidden() return true end
function modifier_attacker_5_bash:OnCreated()
if IsServer() then
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if self.duration == nil then self.duration = 0.3 end
	local lvl = self:GetParent():GetLevel()
	if lvl == 1 then self.chance = 10
	elseif lvl == 2 then self.chance = 15
	elseif lvl == 3 then self.chance = 20
	end
end
end
function modifier_attacker_5_bash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_attacker_5_bash:GetModifierProcAttack_Feedback(params)
	--print("chance is "..self.chance)
	if RollPercentage(self.chance) then
		--print("roll successfull")
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.duration,})
	end

end
