LinkLuaModifier( "modifier_plants", "modifiers/modifier_plants.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_turning", "modifiers/modifier_disable_turning.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_2_attacks", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_3_attacks", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_3_regen_aura", "abilities/plants/plants_defenders.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_3_auto_heal", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_4_attacks", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifeir_defender_4_skin", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifeir_defender_4_auto_skin", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_5_attacks", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_5_armor_aura", "abilities/plants/plants_defenders.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_5_aura", "abilities/plants/plants_defenders.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifeir_defender_5_auto_armor", "abilities/plants/plants_defenders.lua" ,LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_defender_1_cooldown", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_2_cooldown", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_3_cooldown", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_4_cooldown", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_5_cooldown", "abilities/plants/plants_defenders.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_poison", "abilities/zombies/zombies.lua", LUA_MODIFIER_MOTION_NONE )
modifier_defender_1_cooldown = class({})
function modifier_defender_1_cooldown:IsHidden() return false end
function modifier_defender_1_cooldown:GetTexture() return "plants/defender1" end
modifier_defender_2_cooldown = class({})
function modifier_defender_2_cooldown:IsHidden() return false end
function modifier_defender_2_cooldown:GetTexture() return "plants/defender2" end
modifier_defender_3_cooldown = class({})
function modifier_defender_3_cooldown:IsHidden() return false end
function modifier_defender_3_cooldown:GetTexture() return "plants/defender3" end
modifier_defender_4_cooldown = class({})
function modifier_defender_4_cooldown:IsHidden() return false end
function modifier_defender_4_cooldown:GetTexture() return "plants/defender4" end
modifier_defender_5_cooldown = class({})
function modifier_defender_5_cooldown:IsHidden() return false end
function modifier_defender_5_cooldown:GetTexture() return "plants/defender5" end

plants_defender_1 = class ({})
function plants_defender_1:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_defender_1:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_1"
	self.defender_1 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() - self:GetCursorTarget():GetForwardVector()*30), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.defender_1:SetOwner(caster)
	self.defender_1:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.defender_1:AddNewModifier(self.defender_1, self, "modifier_plants", {})
	self.defender_1:AddNewModifier(self.defender_1, self, "modifier_disable_turning", {})
	self.defender_1:FindAbilityByName("defender_1_attacks"):SetLevel(1)	

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_defender_1") then v:FindAbilityByName("plants_defender_1"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_defender_1_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end
defender_1_attacks = class({})
--=================================================================================================================
--============================================= DEFENDER 1 SKILLS =================================================
--=================================================================================================================
defender_1_upgrade = class({})

function defender_1_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_1_2"
	self.upgraded_defender_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_1:SetOwner(caster:GetOwner())
	self.upgraded_defender_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_1:SetHealth(self.upgraded_defender_1:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, self, "modifier_plants", {})
	self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, self, "modifier_disable_turning", {})
	self.upgraded_defender_1:FindAbilityByName("defender_1_attacks"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_1)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

defender_12_upgrade = class({})

function defender_12_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_1_3"
	self.upgraded_defender_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_1:SetOwner(caster:GetOwner())
	self.upgraded_defender_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_1:SetHealth(self.upgraded_defender_1:GetMaxHealth()/100*health_pct)	
	self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, self, "modifier_plants", {})
	self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, self, "modifier_disable_turning", {})
	self.upgraded_defender_1:FindAbilityByName("defender_1_attacks"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_1)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_1:AddNewModifier(self.upgraded_defender_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
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
--============================================= DEFENDER 2 SKILLS ==================================================================================
--==================================================================================================================================================

--===========================================================================
--============================ SPAWN 2 DEFENDER -----------------------------
--===========================================================================

plants_defender_2 = class ({})
function plants_defender_2:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_defender_2:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_2"
	self.defender_2 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() - self:GetCursorTarget():GetForwardVector()*30), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.defender_2:SetOwner(caster)
	self.defender_2:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.defender_2:AddNewModifier(self.defender_2, self, "modifier_plants", {})
	self.defender_2:AddNewModifier(self.defender_2, self, "modifier_disable_turning", {})
	self.defender_2:FindAbilityByName("defender_2_attacks"):SetLevel(1)

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_defender_2") then v:FindAbilityByName("plants_defender_2"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_defender_2_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

defender_2_upgrade = class({})
function defender_2_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_2_2"
	self.upgraded_defender_2 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_2:SetOwner(caster:GetOwner())
	self.upgraded_defender_2:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_2:SetHealth(self.upgraded_defender_2:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, self, "modifier_plants", {})
	self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, self, "modifier_disable_turning", {})
	self.upgraded_defender_2:FindAbilityByName("defender_2_attacks"):SetLevel(2)
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_2)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

defender_22_upgrade = class({})
function defender_22_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_2_3"
	self.upgraded_defender_2 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_2:SetOwner(caster:GetOwner())
	self.upgraded_defender_2:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_2:SetHealth(self.upgraded_defender_2:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, self, "modifier_plants", {})
	self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, self, "modifier_disable_turning", {})
	self.upgraded_defender_2:FindAbilityByName("defender_2_attacks"):SetLevel(3)
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_2)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_2:AddNewModifier(self.upgraded_defender_2, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ DEFENDER 2 ABILITIES -------------------------
--===========================================================================

defender_2_attacks = class({})
function defender_2_attacks:GetIntrinsicModifierName()
	return "modifier_defender_2_attacks"
end
modifier_defender_2_attacks = class({})
function modifier_defender_2_attacks:IsHidden() return true end
function modifier_defender_2_attacks:RemoveOnDeath() return true end
function modifier_defender_2_attacks:OnCreated()
	self.radius = 200
	local unit_level = self:GetParent():GetLevel()
	local interval = 2
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
end
function modifier_defender_2_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines =  pvzGameMode:GetLines()
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
					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end
		if zombies_in_front >= 1 then
			EmitSoundOn("Hero_Treant.PreAttack", caster)
			caster:StartGesture(ACT_DOTA_ATTACK)
			Timers:CreateTimer(0.4, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Hero_Treant.Attack", caster)
			end)
		end
	end
end
end


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
--============================================= DEFENDER 3 SKILLS ==================================================================================
--==================================================================================================================================================

--===========================================================================
--============================ SPAWN 3 DEFENDER SPRUCE ----------------------
--===========================================================================

plants_defender_3 = class ({})
function plants_defender_3:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_defender_3:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_3"
	self.defender_3 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() - self:GetCursorTarget():GetForwardVector()*30), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.defender_3:SetOwner(caster)
	self.defender_3:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.defender_3:AddNewModifier(self.defender_3, self, "modifier_plants", {})
	self.defender_3:AddNewModifier(self.defender_3, self, "modifier_disable_turning", {})
	self.defender_3:FindAbilityByName("defender_3_attacks"):SetLevel(1)
	self.defender_3:FindAbilityByName("defender_3_regen"):SetLevel(1)
	self.defender_3:FindAbilityByName("defender_3_regen"):ToggleAutoCast()

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_defender_3") then v:FindAbilityByName("plants_defender_3"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_defender_3_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

defender_3_upgrade = class({})
function defender_3_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_3_2"
	self.upgraded_defender_3 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_3:SetOwner(caster:GetOwner())
	self.upgraded_defender_3:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_3:SetHealth(self.upgraded_defender_3:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, self, "modifier_plants", {})
	self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, self, "modifier_disable_turning", {})
	self.upgraded_defender_3:FindAbilityByName("defender_3_attacks"):SetLevel(2)
	local cd = caster:FindAbilityByName("defender_3_regen"):GetCooldownTime()
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):SetLevel(2)
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):StartCooldown(cd)
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):ToggleAutoCast()
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_3)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

defender_32_upgrade = class({})
function defender_32_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_3_3"
	self.upgraded_defender_3 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_3:SetOwner(caster:GetOwner())
	self.upgraded_defender_3:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_3:SetHealth(self.upgraded_defender_3:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, self, "modifier_plants", {})
	self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, self, "modifier_disable_turning", {})
	self.upgraded_defender_3:FindAbilityByName("defender_3_attacks"):SetLevel(3)
	local cd = caster:FindAbilityByName("defender_3_regen"):GetCooldownTime()
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):SetLevel(3)
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):StartCooldown(cd)
	self.upgraded_defender_3:FindAbilityByName("defender_3_regen"):ToggleAutoCast()	
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_3)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_3:AddNewModifier(self.upgraded_defender_3, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ DEFENDER 3 ABILITIES -------------------------
--===========================================================================
defender_3_attacks = class({})

function defender_3_attacks:GetIntrinsicModifierName()
	return "modifier_defender_3_attacks"
end
modifier_defender_3_attacks = class({})
function modifier_defender_3_attacks:IsHidden() return true end
function modifier_defender_3_attacks:RemoveOnDeath() return true end
function modifier_defender_3_attacks:OnCreated()
	self.radius = 200
	local unit_level = self:GetParent():GetLevel()
	local interval = 2
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
end
function modifier_defender_3_attacks:OnIntervalThink()
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
					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end
		if zombies_in_front >= 1 then
			EmitSoundOn("Hero_Treant.PreAttack", caster)
			caster:StartGesture(ACT_DOTA_ATTACK)
			Timers:CreateTimer(0.4, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Hero_Treant.Attack", caster)
			end)
		end
	end
end
end


defender_3_regen = class({})
function defender_3_regen:GetIntrinsicModifierName() return "modifier_defender_3_auto_heal" end
function defender_3_regen:RequiresFacing() return false end
function defender_3_regen:OnSpellStart()

	local target = self:GetCursorTarget()
	
	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(self:GetCaster(), self, "modifier_spruce_heal", {duration = duration})
	
end
modifier_defender_3_auto_heal = class({})
function modifier_defender_3_auto_heal:IsHidden() return true end
function modifier_defender_3_auto_heal:OnCreated()
	self:StartIntervalThink(1)
end
function modifier_defender_3_auto_heal:OnIntervalThink()
if not IsServer() then return end
if not self:GetAbility():IsCooldownReady() then return end
if not self:GetAbility():GetAutoCastState() then return end
	local caster = self:GetParent()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false)
	
	for _,target in pairs(targets) do
		if target:HasModifier("modifier_plants") and target:GetHealth()/target:GetMaxHealth()<=0.9 and not target:HasModifier("modifier_spruce_heal") then
			caster:CastAbilityOnTarget(target, self:GetAbility(), caster:GetPlayerOwnerID())
		end
	end	
end
LinkLuaModifier( "modifier_spruce_heal", "abilities/plants/plants_defenders.lua" ,LUA_MODIFIER_MOTION_NONE )
modifier_spruce_heal = class({})
function modifier_spruce_heal:IsHidden() return false end
function modifier_spruce_heal:IsPurgable() return false end
function modifier_spruce_heal:RemoveOnDeath() return true end
function modifier_spruce_heal:IsDebuff() return false end
function modifier_spruce_heal:OnRefresh()
	if self.LivingArmorParticle then
		ParticleManager:DestroyParticle(self.LivingArmorParticle,false)
	end
	self:OnCreated()
end
function modifier_spruce_heal:OnCreated()
	self.heal = self:GetAbility():GetSpecialValueFor("heal_per_second")
	--print("heal is "..self.heal)
	--self.LivingArmorParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	--ParticleManager:SetParticleControlEnt(self.LivingArmorParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	--ParticleManager:SetParticleControlEnt(self.LivingArmorParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self.LivingArmorParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.LivingArmorParticle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "follow_origin", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(self.LivingArmorParticle, false, false, 15, false, false)
end
function modifier_spruce_heal:OnDestroy()
	if self.LivingArmorParticle then
		ParticleManager:DestroyParticle(self.LivingArmorParticle,false)
	end
end
function modifier_spruce_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_spruce_heal:GetModifierConstantHealthRegen() return self.heal end
function modifier_spruce_heal:OnDeath(ev)
if ev.unit==self:GetParent() then
	if self:GetAbility()~=nil then
		self:GetAbility():EndCooldown()
	end
end
end
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
--===========================================================================
--============================ SPAWN 4 DEFENDER -----------------------------
--===========================================================================

plants_defender_4 = class ({})
function plants_defender_4:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_defender_4:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_4"
	self.defender_4 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() - self:GetCursorTarget():GetForwardVector()*30), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.defender_4:SetOwner(caster)
	self.defender_4:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.defender_4:AddNewModifier(self.defender_4, self, "modifier_plants", {})
	self.defender_4:AddNewModifier(self.defender_4, self, "modifier_disable_turning", {})
	self.defender_4:FindAbilityByName("defender_4_attacks"):SetLevel(1)
	self.defender_4:FindAbilityByName("defender_4_skin"):SetLevel(1)
	self.defender_4:FindAbilityByName("defender_4_skin"):ToggleAutoCast()

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_defender_4") then v:FindAbilityByName("plants_defender_4"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_defender_4_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

defender_4_upgrade = class({})
function defender_4_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_4_2"
	self.upgraded_defender_4 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_4:SetOwner(caster:GetOwner())
	self.upgraded_defender_4:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_4:SetHealth(self.upgraded_defender_4:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, self, "modifier_plants", {})
	self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, self, "modifier_disable_turning", {})
	self.upgraded_defender_4:FindAbilityByName("defender_4_attacks"):SetLevel(2)
	local cd = caster:FindAbilityByName("defender_4_skin"):GetCooldownTime()
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):SetLevel(2)
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):StartCooldown(cd)
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):ToggleAutoCast()
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_4)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

defender_42_upgrade = class({})
function defender_42_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_4_3"
	self.upgraded_defender_4 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_4:SetOwner(caster:GetOwner())
	self.upgraded_defender_4:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_4:SetHealth(self.upgraded_defender_4:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, self, "modifier_plants", {})
	self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, self, "modifier_disable_turning", {})
	self.upgraded_defender_4:FindAbilityByName("defender_4_attacks"):SetLevel(3)
	local cd = caster:FindAbilityByName("defender_4_skin"):GetCooldownTime()
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):SetLevel(3)
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):StartCooldown(cd)
	self.upgraded_defender_4:FindAbilityByName("defender_4_skin"):ToggleAutoCast()
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_4)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_4:AddNewModifier(self.upgraded_defender_4, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end

	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ DEFENDER 4 ABILITIES ------------------------
--===========================================================================

defender_4_attacks = class({})

defender_4_attacks = class({})

function defender_4_attacks:GetIntrinsicModifierName()
	return "modifier_defender_4_attacks"
end
modifier_defender_4_attacks = class({})
function modifier_defender_4_attacks:IsHidden() return true end
function modifier_defender_4_attacks:RemoveOnDeath() return true end
function modifier_defender_4_attacks:OnCreated()
	self.radius = 200
	local unit_level = self:GetParent():GetLevel()
	local interval = 1
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
end
function modifier_defender_4_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines =  pvzGameMode:GetLines()
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
					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end
		if zombies_in_front >= 1 then
			EmitSoundOn("Hero_Tiny.PreAttack", caster)
			caster:StartGesture(ACT_DOTA_ATTACK)
			Timers:CreateTimer(0.4, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Hero_Tiny.Attack", caster)
			end)
		end
	end
end
end

defender_4_skin = class({})
function defender_4_skin:GetIntrinsicModifierName() return "modifeir_defender_4_auto_skin" end
function defender_4_skin:OnSpellStart()	
	
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifeir_defender_4_skin", {duration = duration})
	EmitSoundOn("DOTA_Item.BladeMail.Activate", self:GetCaster())
end

modifeir_defender_4_skin = class({})

function modifeir_defender_4_skin:IsBuff() return true end
function modifeir_defender_4_skin:IsHidden() return false end
function modifeir_defender_4_skin:IsPassive() return true end

function modifeir_defender_4_skin:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifeir_defender_4_skin:OnTakeDamage(params)

	local ability = self:GetAbility()
	self.reflect_percent = ability:GetSpecialValueFor("dmg")

	if not IsServer() then return end

	if params.unit == self:GetParent() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local damage = params.damage / 100 * self.reflect_percent
		--print("Return damage: ", damage)
		ApplyDamage({
			victim = params.attacker,
			attacker = params.unit,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
		})
		EmitSoundOn("DOTA_Item.BladeMail.Damage", self:GetParent())
	end
end
function modifeir_defender_4_skin:GetEffectName()
	return "particles/blademail.vpcf"
end
function modifeir_defender_4_skin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifeir_defender_4_auto_skin = class({})
function modifeir_defender_4_auto_skin:IsHidden() return true end
function modifeir_defender_4_auto_skin:IsBuff() return true end
function modifeir_defender_4_auto_skin:OnCreated()
	self:StartIntervalThink(0.5)
end
function modifeir_defender_4_auto_skin:OnIntervalThink()
if not IsServer() then return end
if not self:GetAbility():IsCooldownReady() then return end
if not self:GetAbility():GetAutoCastState() then return end
	local lines =  pvzGameMode:GetLines()

	local caster = self:GetParent()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false)
	if #targets >= 2 then
		for _,target in pairs(targets) do
			local same_line = false
			if caster:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
				for i=1, lines do
					if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
						same_line = true
					end
				end  
			end
			if same_line == true then	
				if (target:GetHealth()/target:GetMaxHealth()>=0.9 and target:HasModifier("modifier_zombie") and not target:HasModifier("modifier_flying_zombie")) or (#targets>=3 and not target:HasModifier("modifier_flying_zombie")) or target:GetLevel()==6 then
					caster:CastAbilityNoTarget(self:GetAbility(), caster:GetPlayerOwnerID())
				end
			end
		end
	end
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
--============================ SPAWN 5 DEFENDER -----------------------------
--===========================================================================

plants_defender_5 = class ({})
function plants_defender_5:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_defender_5:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_5"
	self.defender_5 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() - self:GetCursorTarget():GetForwardVector()*30), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.defender_5:SetOwner(caster)
	self.defender_5:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.defender_5:AddNewModifier(self.defender_5, self, "modifier_plants", {})
	self.defender_5:AddNewModifier(self.defender_5, self, "modifier_disable_turning", {})
	self.defender_5:FindAbilityByName("defender_5_attacks"):SetLevel(1)
	self.defender_5:FindAbilityByName("defender_5_armor"):SetLevel(1)
	self.defender_5:FindAbilityByName("defender_5_armor"):ToggleAutoCast()

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_defender_5") then v:FindAbilityByName("plants_defender_5"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_defender_5_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

defender_5_upgrade = class({})
function defender_5_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_5_2"
	self.upgraded_defender_5 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_5:SetOwner(caster:GetOwner())
	self.upgraded_defender_5:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_5:SetHealth(self.upgraded_defender_5:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, self, "modifier_plants", {})
	self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, self, "modifier_disable_turning", {})
	self.upgraded_defender_5:FindAbilityByName("defender_5_attacks"):SetLevel(2)
	local cd = caster:FindAbilityByName("defender_5_armor"):GetCooldownTime()
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):SetLevel(2)
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):StartCooldown(cd)
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):ToggleAutoCast()
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_5)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

defender_52_upgrade = class({})
function defender_52_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_defender_5_3"
	self.upgraded_defender_5 = CreateUnitByName(unit_name, caster:GetAbsOrigin(), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_defender_5:SetOwner(caster:GetOwner())
	self.upgraded_defender_5:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_defender_5:SetHealth(self.upgraded_defender_5:GetMaxHealth()/100*health_pct)
	self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, self, "modifier_plants", {})
	self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, self, "modifier_disable_turning", {})
	self.upgraded_defender_5:FindAbilityByName("defender_5_attacks"):SetLevel(3)
	local cd = caster:FindAbilityByName("defender_5_armor"):GetCooldownTime()
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):SetLevel(3)
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):StartCooldown(cd)
	self.upgraded_defender_5:FindAbilityByName("defender_5_armor"):ToggleAutoCast()
	EmitSoundOn( "SoundLvlUp", self.upgraded_defender_5)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_defender_5:AddNewModifier(self.upgraded_defender_5, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

--===========================================================================
--============================ DEFENDER 5 ABILITIES ------------------------
--===========================================================================

defender_5_attacks = class({})

function defender_5_attacks:GetIntrinsicModifierName()
	return "modifier_defender_5_attacks"
end
modifier_defender_5_attacks = class({})
function modifier_defender_5_attacks:IsHidden() return true end
function modifier_defender_5_attacks:RemoveOnDeath() return true end
function modifier_defender_5_attacks:OnCreated()
	self.radius = 200
	local unit_level = self:GetParent():GetLevel()
	local interval = 2
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
end
function modifier_defender_5_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines =  pvzGameMode:GetLines()
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
					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					if angle_flower<=attack_cone then -- только для тех кто сперети
						enemy = target
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end
		if zombies_in_front >= 1 then
			EmitSoundOn("Hero_ElderTitan.PreAttack", caster)
			caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 0.75)
			Timers:CreateTimer(0.8, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Hero_ElderTitan.Attack", caster)
			end)
		end
	end
end
end

defender_5_armor = class({})
function defender_5_armor:GetIntrinsicModifierName() return "modifeir_defender_5_auto_armor" end

function defender_5_armor:OnSpellStart()	
	
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_defender_5_aura", {duration = duration})
	EmitSoundOn("Hero_Sven.WarCry", self:GetCaster())
end


--------------------------------------------------------------------------------


modifier_defender_5_aura = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})

function modifier_defender_5_aura:IsAura()
    return true
end
function modifier_defender_5_aura:GetModifierAura()
    return "modifier_defender_5_armor_aura"
end
function modifier_defender_5_aura:GetAuraRadius()
    return 10000
end
function modifier_defender_5_aura:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_defender_5_aura:GetAuraDuration()    
    return 1.0
end
function modifier_defender_5_aura:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_BASIC
end
function modifier_defender_5_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
modifier_defender_5_armor_aura = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsPurgeException        = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
        }
    end,
})
function modifier_defender_5_armor_aura:GetTexture()
	return "plants/defender5_armor"
end

--------------------------------------------------------------------------------

--[[function modifier_defender_5_armor_aura:OnCreated()
	local lvl = self:GetAbility():GetCaster():GetLevel()
	if lvl == 1 then self.armor = 5
	elseif lvl == 2 then self.armor = 8
	elseif lvl == 3 then self.armor = 11
	end
end ]]

function modifier_defender_5_armor_aura:OnRefresh()
    self:OnCreated()
end
function modifier_defender_5_armor_aura:GetAuraEntityReject(ent)
    if ent:GetUnitName()=="npc_dota_creature_plants_pot" or ent:GetUnitName()=="npc_dota_creature_superdefender" then 
    	return true 
    end
    return false
end
function modifier_defender_5_armor_aura:GetModifierPhysicalArmorBonus()
	if self:GetParent():HasModifier("modifier_plants_pot") then return end
	if self:GetParent():GetUnitName()=="npc_dota_creature_superdefender" then return end
	return 5
end
function modifier_defender_5_armor_aura:GetEffectName()
	if self:GetParent():HasModifier("modifier_plants_pot") then return end
	if self:GetParent():GetUnitName()=="npc_dota_creature_superdefender" or self:GetParent():GetUnitName()=="npc_dota_creature_plants_pot" then return end
	return "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf" 
end 
function modifier_defender_5_armor_aura:GetEffectAttachType() 
	if self:GetParent():HasModifier("modifier_plants_pot") then return end
	if self:GetParent():GetUnitName()=="npc_dota_creature_superdefender" then return end
	return PATTACH_ABSORIGIN_FOLLOW 
end


modifeir_defender_5_auto_armor = class({})
function modifeir_defender_5_auto_armor:IsHidden() return true end
function modifeir_defender_5_auto_armor:IsBuff() return true end
function modifeir_defender_5_auto_armor:OnCreated()
	self:StartIntervalThink(0.5)
end
function modifeir_defender_5_auto_armor:OnIntervalThink()
if not IsServer() then return end
if not self:GetAbility():IsCooldownReady() then return end
if not self:GetAbility():GetAutoCastState() then return end
	local caster = self:GetParent()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false)
	if #targets >= 3 then
	for _,target in pairs(targets) do
		if not target:HasModifier("modifier_cannot_be_attacked") and target:HasModifier("modifier_zombie") and not target:HasModifier("modifier_flying_zombie") or #targets>=5 or target:GetLevel()==6 then
			caster:CastAbilityNoTarget(self:GetAbility(), caster:GetPlayerOwnerID())
		end
	end
	end
end
