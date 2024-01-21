LinkLuaModifier( "modifier_plants", "modifiers/modifier_plants.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_turning", "modifiers/modifier_disable_turning.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_sunflower_1", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sunflower_2", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sunflower_3", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mine_detonate", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mine_sound", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wood_bite", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wood_bite_sleep", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_special_4_freeze", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_4_freeze_debuff", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_4_attacks", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_5_suicide", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_mine_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_special_1_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_2_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_3_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_4_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_5_cooldown", "abilities/plants/plants_specials.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_poison", "abilities/zombies/zombies.lua", LUA_MODIFIER_MOTION_NONE )
modifier_special_1_cooldown = class({})
function modifier_special_1_cooldown:IsHidden() return false end
function modifier_special_1_cooldown:GetTexture() return "plants/special1" end
modifier_special_2_cooldown = class({})
function modifier_special_2_cooldown:IsHidden() return false end
function modifier_special_2_cooldown:GetTexture() return "plants/special2" end
modifier_special_3_cooldown = class({})
function modifier_special_3_cooldown:IsHidden() return false end
function modifier_special_3_cooldown:GetTexture() return "plants/special3" end
modifier_special_4_cooldown = class({})
function modifier_special_4_cooldown:IsHidden() return false end
function modifier_special_4_cooldown:GetTexture() return "plants/special4" end
modifier_special_5_cooldown = class({})
function modifier_special_5_cooldown:IsHidden() return false end
function modifier_special_5_cooldown:GetTexture() return "plants/special5" end

--=================================================================================================================
--============================================= SPECIAL 1 SKILLS =================================================
--=================================================================================================================

plants_special_1 = class ({})
function plants_special_1:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_special_1:OnSpellStart()
	local caster = self:GetCaster()

	local unit_name = "npc_plants_special_1"
	self.special_1 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin()), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.special_1:SetOwner(caster)
	self.special_1:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.special_1:AddNewModifier(self.special_1, self, "modifier_plants", {})
	self.special_1:AddNewModifier(self.special_1, self, "modifier_disable_turning", {})
	self.special_1:FindAbilityByName("special_1_sunflower"):SetLevel(1)	

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_special_1") then v:FindAbilityByName("plants_special_1"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_special_1_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

-------------------------------------------- UPGRADE ----------------------------------------------------

special_1_upgrade = class({})

function special_1_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_1_2"
	self.upgraded_special_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_special_1:SetOwner(caster:GetOwner())
	self.upgraded_special_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_special_1:SetHealth(self.upgraded_special_1:GetMaxHealth()/100*health_pct)
	self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, self, "modifier_plants", {})
	self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, self, "modifier_disable_turning", {})
	EmitSoundOn( "SoundLvlUp", self.upgraded_special_1)
	self.upgraded_special_1:FindAbilityByName("special_1_sunflower"):SetLevel(2)
	local cd = caster:FindAbilityByName("special_1_sunflower"):GetCooldownTimeRemaining()
	self.upgraded_special_1:FindAbilityByName("special_1_sunflower"):StartCooldown(cd)
	--print("cd is "..cd)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end

special_12_upgrade = class({})

function special_12_upgrade:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_1_3"
	self.upgraded_special_1 = CreateUnitByName(unit_name, (caster:GetAbsOrigin()), false, caster:GetOwner(), caster:GetOwner(), DOTA_TEAM_GOODGUYS)
	self.upgraded_special_1:SetOwner(caster:GetOwner())
	self.upgraded_special_1:SetControllableByPlayer(caster:GetOwner():GetPlayerOwnerID(), true )
	local health_pct = caster:GetHealth()/caster:GetMaxHealth()*100
	self.upgraded_special_1:SetHealth(self.upgraded_special_1:GetMaxHealth()/100*health_pct)
	self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, self, "modifier_plants", {})
	self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, self, "modifier_disable_turning", {})
	self.upgraded_special_1:FindAbilityByName("special_1_sunflower"):SetLevel(3)
	local cd = caster:FindAbilityByName("special_1_sunflower"):GetCooldownTimeRemaining()
	--print("cd is "..cd)
	self.upgraded_special_1:FindAbilityByName("special_1_sunflower"):StartCooldown(cd)
	EmitSoundOn( "SoundLvlUp", self.upgraded_special_1)
	if caster:HasModifier("modifier_zombie_poison") then
		local modifier = caster:FindModifierByName("modifier_zombie_poison")
		local stacks = modifier:GetStackCount()
		local modif = self.upgraded_special_1:AddNewModifier(self.upgraded_special_1, modifier:GetAbility(), "modifier_zombie_poison", {})
		modif:SetStackCount(stacks)
	end
	caster:RemoveSelf()
	UTIL_Remove(caster)
end


------------------------------- SUNFLOWER GOLD -----------------------
------------------------------- 1 LVL --------------------------------
special_1_sunflower = class({})

function special_1_sunflower:GetIntrinsicModifierName()
	return "modifier_sunflower_1"
end
function special_1_sunflower:GetCooldown(iLevel)
	if GetMapName()=="2x2" then
		return self:GetSpecialValueFor("tick_interval_2x2") 	
	end
	return self:GetSpecialValueFor("tick_interval")
end
modifier_sunflower_1 = class({})
function modifier_sunflower_1:IsHidden() return true end
function modifier_sunflower_1:RemoveOnDeath() return true end
function modifier_sunflower_1:IsBuff() return true end
function modifier_sunflower_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
end
function modifier_sunflower_1:GetModifierOverrideAbilitySpecial( params )
	local ability = params.ability
    if ability==self:GetAbility() and ability:GetAbilityName()=="special_1_sunflower" then        
	    return 1
    else return 0
    end
end
-- умножить визуал значения на 2
function modifier_sunflower_1:GetModifierOverrideAbilitySpecialValue(params)
    local szAbilityName = params.ability:GetAbilityName()
    if not szAbilityName=="special_1_sunflower" then return end

    local value = params.ability_special_value  
	local level = params.ability_special_level  
    if value=="tick_interval" and GetMapName()=="2x2" then 
    	--print("tick and 2x2") 
    	local new_value = params.ability:GetSpecialValueFor("tick_interval_2x2") 
    	--print("new value "..new_value)
    	return new_value     	    
	end       
    local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( value, level )       
    return flBaseValue   
      
  
end 
function modifier_sunflower_1:OnCreated()
	if not IsServer() then return end
	self.ability = self:GetAbility()
	if self:GetParent():GetLevel()==1 then
		self.ability:UseResources(false, false, false, true)
	end
	local tick_interval = self.ability:GetSpecialValueFor("tick_interval")
	self:StartIntervalThink(0.2)
end

function modifier_sunflower_1:OnIntervalThink()
if IsServer() then
	if self:GetParent():IsAlive() and self:GetAbility():IsCooldownReady() then
		local gold = self.ability:GetSpecialValueFor("gold_gain")
		--print("flower will give "..gold)
		local allHeroes = HeroList:GetAllHeroes()
		for k, v in pairs( allHeroes ) do
			if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
				if v:HasModifier("modifier_solo_player") then 
					v:ModifyGold(gold*2, true, 1)
					else v:ModifyGold(gold, true, 1)				
					local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
					ParticleManager:SetParticleControlEnt(midas_particle, 1, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), false)
				end
			end
		end
		self.ability:GetCooldown(self.ability:GetLevel())
		self.ability:UseResources(false, false, false, true)
		EmitSoundOn( "SoundSunflower", self:GetParent())
	end
end
end

-----------------------------------------------------------------------
----------------- SPECIAL 2 POTATO MINE -------------------------------
-----------------------------------------------------------------------

plants_special_2 = class ({})
function plants_special_2:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end
end
function plants_special_2:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_2"
	self.special_2 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin()), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.special_2:SetOwner(caster)
	self.special_2:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.special_2:AddNewModifier(self.special_2, self, "modifier_plants", {})
	self.special_2:AddNewModifier(self.special_2, self, "modifier_disable_turning", {})

	self.special_2:AddNewModifier(self.special_2, self, "modifier_mine_cooldown", {duration = self.special_2:FindAbilityByName("special_2_mine"):GetCooldown(1)})
	
	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_special_2") then v:FindAbilityByName("plants_special_2"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_special_2_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

modifier_mine_cooldown = class({})
function modifier_mine_cooldown:IsHidden() return true end
function modifier_mine_cooldown:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end
function modifier_mine_cooldown:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_mine_cooldown:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
end
function modifier_mine_cooldown:GetModifierModelChange()
	return "models/potato_mine/potato_small.vmdl"
end
-------------- DETONATE SKILL -------------------

special_2_mine = class({})

function special_2_mine:GetIntrinsicModifierName()
	return "modifier_mine_detonate"
end

modifier_mine_detonate = class({})
function modifier_mine_detonate:IsPurgable() return false end
function modifier_mine_detonate:IsHidden() return true end
function modifier_mine_detonate:RemoveOnDeath() return true end
function modifier_mine_detonate:OnCreated()
if IsServer() then
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, false, true)
	end
	self:StartIntervalThink(0.1)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.lines = pvzGameMode:GetLines()	
end
end

function modifier_mine_detonate:OnIntervalThink()
if IsServer() then
	if not self:GetParent():IsAlive() then return end
	if not self:GetAbility():IsCooldownReady() then return end
	local caster = self:GetParent()

	targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local same_line = false
	--print(#targets)
	if #targets >= 1 then
		for _,target in pairs(targets) do
		if not target:HasModifier("modifier_flying_zombie") then
			if caster:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
				for i=1, self.lines do
					if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
					--	print("they are on the same line")
						same_line = true
					end
				end  
			end
		end
		end
		if same_line == true then
			if not caster:HasModifier("modifier_mine_sound") then
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_mine_sound", {duration = 0.6})
			end
			caster:RemoveModifierByName("modifier_mine_detonate")
		end
	end
end
end

modifier_mine_sound = class({})

function modifier_mine_sound:IsHidden() return true end
function modifier_mine_sound:RemoveOnDeath() return true end
function modifier_mine_sound:IsBuff() return true end
function modifier_mine_sound:OnCreated()
if IsServer() then
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(0.1)
	self.red = 255
	self.model_scale = 2
	self:StartIntervalThink(0.1)

	EmitSoundOn("SoundMineDetonate", self:GetParent())
	Timers:CreateTimer(0.33, function()
		EmitSoundOn("SoundMinePreExplode", self:GetParent())
	end)

end
end
function modifier_mine_sound:OnIntervalThink()
if IsServer() then
	self.red = self.red - 45
	self.model_scale = self.model_scale + 0.18
	if self.red <=0 then self.red = 1 end
	self:GetParent():SetModelScale(self.model_scale)
	self:GetParent():SetRenderColor(255, self.red, self.red)
end
end

function modifier_mine_sound:OnDestroy()
if IsServer() then
	if not self:GetParent():IsAlive() then return end
	local lines = pvzGameMode:GetLines()
	local caster = self:GetParent()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	if #targets >= 1 then
		for _,target in pairs(targets) do
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
				local damage_table = {
						victim = target,
						attacker = caster,
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PURE
					}
				ApplyDamage( damage_table )
			end
		end
	end
		EmitSoundOn("Hero_Techies.RemoteMine.Detonate", caster)
		local explode_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(explode_particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( explode_particle )
			
		local crater_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_bomb_crater.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(crater_particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( crater_particle )
		caster:SetModelScale(0.1)
		StopSoundOn("SoundMineDetonate", caster)
		caster:Kill(self:GetAbility(), caster)
end
end
function modifier_mine_sound:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
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
--=============================================SPECIAL 3 WOODFANG ==================================================================================
--==================================================================================================================================================


plants_special_3 = class ({})
function plants_special_3:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end
end
function plants_special_3:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_3"
	self.special_2 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() + self:GetCursorTarget():GetForwardVector()*40), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.special_2:SetOwner(caster)
	self.special_2:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.special_2:AddNewModifier(self.special_2, self, "modifier_plants", {})
	self.special_2:AddNewModifier(self.special_2, self, "modifier_disable_turning", {})

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_special_3") then v:FindAbilityByName("plants_special_3"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_special_3_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

-------------- BITE -------------------

special_3_bite = class({})

function special_3_bite:GetIntrinsicModifierName()
	return "modifier_wood_bite"
end

modifier_wood_bite = class({})

function modifier_wood_bite:IsHidden() return true end
function modifier_wood_bite:IsBuff() return true end

function modifier_wood_bite:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("hp_limit")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(0.1)
end

function modifier_wood_bite:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
	local lines = pvzGameMode:GetLines()
	local zombies_in_front = 0
	local attack_cone = 30
	if self:GetAbility():IsCooldownReady() and self:GetParent():IsAlive() then
	local caster = self:GetParent()
	local could_be_killed = 0
	local fat_enemies = 0
	local enemy = nil
	local fat_enemy = nil
	--print("interval think")
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	if #targets >= 1 then
		for _,target in pairs(targets) do -- перебор мелких
			if not enemy ~= nil then --как только найдём врага сразу перестанем перебирать

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
					local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					--print("Angle: target" .. angle)
					--print("Angle: caster" .. angle_flower)

					if angle_flower<=attack_cone then -- только для тех кто сперети
						
						local hp = target:GetMaxHealth()

						if hp <= self.damage then
							could_be_killed = could_be_killed + 1
							enemy = target
							--print("low hp "..enemy)
						else 
							fat_enemies = fat_enemies + 1
							fat_enemy = target
							--print("fat hp "..fat_enemy)
						end
						zombies_in_front = zombies_in_front + 1
					end
				end
			end
		end

		if zombies_in_front >= 1 then 
			if could_be_killed <= 0 and fat_enemies >= 1 and not enemy ~= nil then
				enemy = fat_enemy
			end
			local damage_table = {
				victim = enemy,
				attacker = caster,
				damage = self.damage,
				damage_type = DAMAGE_TYPE_PURE
				}
			caster:StartGesture(ACT_DOTA_ATTACK)
			self:GetAbility():UseResources(false, false, false, true)
			Timers:CreateTimer(0.4, function()
				EmitSoundOn("SoundWoodFangBite1", caster)
				ApplyDamage( damage_table )
				if caster:GetOwner():HasModifier("modifier_solo_player") then
					caster:GetOwner():ModifyGold(50, true, 0)					
				else
					caster:GetOwner():ModifyGold(25, true, 0)
				end
			end)
			Timers:CreateTimer(0.7, function()
				EmitSoundOn("SoundWoodFangBite2", caster)
			end)
			Timers:CreateTimer(1.7, function()
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_wood_bite_sleep", {duration = 12.3})
			end)
		end

	end
	end
end
end

modifier_wood_bite_sleep = class({})

function modifier_wood_bite_sleep:IsHidden() return true end
function modifier_wood_bite_sleep:OnCreated()
	self:StartIntervalThink(2.32)
end
function modifier_wood_bite_sleep:CheckState() 
	return {
		[MODIFIER_STATE_STUNNED] = true 
	} 

end
function modifier_wood_bite_sleep:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_wood_bite_sleep:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_wood_bite_sleep:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end
function modifier_wood_bite_sleep:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_wood_bite_sleep:IsStunDebuff()
	return true
end
function modifier_wood_bite_sleep:OnIntervalThink()
if IsServer() then
	self:GetParent():StartGesture(ACT_DOTA_DISABLED)
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
--============================ SPAWN 4 SPECIAL -----------------------------
--===========================================================================

plants_special_4 = class({})
function plants_special_4:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_special_4:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_4"
	self.special_4 = CreateUnitByName(unit_name, (self:GetCursorTarget():GetAbsOrigin() + self:GetCursorTarget():GetForwardVector()*40), false, caster, caster, DOTA_TEAM_GOODGUYS)
	self.special_4:SetOwner(caster)
	self.special_4:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.special_4:AddNewModifier(self.special_4, self, "modifier_plants", {})
	self.special_4:AddNewModifier(self.special_4, self, "modifier_disable_turning", {})
	self.special_4:FindAbilityByName("special_4_def_attacks"):SetLevel(1)
	self.special_4:FindAbilityByName("special_4_spell"):SetLevel(1)

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_special_4") then v:FindAbilityByName("plants_special_4"):UseResources(false, false, false, true) end
		   	v:AddNewModifier(v, self, "modifier_special_4_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

--===========================================================================
--============================ SPECIAL 4 ABILITIES =========================
--===========================================================================
special_4_def_attacks = class({})

function special_4_def_attacks:GetIntrinsicModifierName()
	return "modifier_special_4_attacks"
end

modifier_special_4_attacks = class({})

function modifier_special_4_attacks:IsHidden() return true end
function modifier_special_4_attacks:RemoveOnDeath() return true end

function modifier_special_4_attacks:OnCreated()
	self.radius = 380
	self:OnIntervalThink()
	self:StartIntervalThink(2.5)
end
function modifier_special_4_attacks:OnIntervalThink()
if IsServer() then
if self:GetParent():IsStunned() then return end
local zombies_in_front = 0
	local lines = pvzGameMode:GetLines()
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
					local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между целью и точкой кастера

					local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между целью и точкой кастера
					--print("Angle: target" .. angle)
					--print("Angle: caster" .. angle_flower)

					if angle_flower<=attack_cone then -- только для тех кто сперети
						zombies_in_front = zombies_in_front + 1
						enemy = target
					end
				end
			end
		end

		if zombies_in_front >= 1 then
			EmitSoundOn("Furion_Treant.PreAttack", caster)
			EmitSoundOn("Hero_Lich.PreAttack", caster)
			caster:StartGesture(ACT_DOTA_ATTACK)
			Timers:CreateTimer(0.4, function()
				caster:PerformAttack(enemy, true, true, true, false, false, false, false)
				EmitSoundOn("Furion_Treant.Attack", caster)
				EmitSoundOn("Hero_Lich.Attack", caster)
				caster:FindAbilityByName("special_4_spell"):StartCooldown(2.6)
			end)
		end

	end
end
end

--===================================================
--=================== ICE STUN ==========================
--===================================================

special_4_spell = class({})

function special_4_spell:GetIntrinsicModifierName()
	return "modifier_special_4_freeze"
end

modifier_special_4_freeze = class({})
modifier_special_4_freeze.OnRefresh = modifier_special_4_freeze.OnCreated

function modifier_special_4_freeze:IsHidden() return true end
function modifier_special_4_freeze:OnCreated()
if IsServer() then
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end
end
function modifier_special_4_freeze:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_special_4_freeze:GetModifierProcAttack_Feedback(params)
if IsServer() then
	print("duration "..self.duration)
	if params.target:GetUnitName()~="npc_zombie_4_2" then
		print("duration "..self.duration)
		params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_special_4_freeze_debuff", {duration = self.duration})
	end
end
end

modifier_special_4_freeze_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_special_4_freeze_debuff:IsHidden()
	return false
end

function modifier_special_4_freeze_debuff:IsDebuff()
	return true
end

function modifier_special_4_freeze_debuff:IsStunDebuff()
	return false
end

function modifier_special_4_freeze_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------


function modifier_special_4_freeze_debuff:OnCreated	( kv )	
	EmitSoundOn("hero_Crystal.frostbite", self:GetParent())
end
function modifier_special_4_freeze_debuff:OnRefresh( kv )
	self:OnCreated()	
end

function modifier_special_4_freeze_debuff:OnDestroy()
	StopSoundOn("hero_Crystal.frostbite", self:GetParent())
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_special_4_freeze_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}
	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_special_4_freeze_debuff:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_special_4_freeze_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
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
--============================ SPAWN 5 SPECIAL P I T A H A Y A --------------
--===========================================================================

plants_special_5 = class({})
function plants_special_5:CastFilterResultTarget(hTarget)	
	if hTarget:GetUnitName()=="npc_dota_creature_plants_pot" then return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , self:GetCaster():GetTeamNumber())
	else return UF_FAIL_OTHER end	
end
function plants_special_5:OnSpellStart()
	local caster = self:GetCaster()
	local unit_name = "npc_plants_special_5"
	self.special_4 = CreateUnitByName(unit_name, self:GetCursorTarget():GetAbsOrigin(), true, caster, caster, DOTA_TEAM_GOODGUYS)
	self.special_4:SetOwner(caster)
	self.special_4:SetControllableByPlayer(caster:GetPlayerOwnerID(), true )
	self.special_4:AddNewModifier(self.special_4, self, "modifier_plants", {})
	self.special_4:AddNewModifier(self.special_4, self, "modifier_disable_turning", {})
	self.special_4:FindAbilityByName("special_5_spell"):SetLevel(1)

	local allHeroes = HeroList:GetAllHeroes()
	for k, v in pairs( allHeroes ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if v:HasAbility("plants_special_5") then v:FindAbilityByName("plants_special_5"):UseResources(false, false, false, true) end			
		   	v:AddNewModifier(v, self, "modifier_special_5_cooldown", {duration = self:GetCooldown(1)})		  		
		end
	end
	self:GetCursorTarget():RemoveSelf()
	UTIL_Remove(self:GetCursorTarget())
end

--===========================================================================
--============================ SPECIAL 5 ABILITIES =========================
--===========================================================================
special_5_spell = class({})

function special_5_spell:GetIntrinsicModifierName()
	return "modifier_special_5_suicide"
end

modifier_special_5_suicide = class({})

function modifier_special_5_suicide:RemoveOnDeath() return true end
function modifier_special_5_suicide:IsHidden() return true end
function modifier_special_5_suicide:IsBuff() return true end

function modifier_special_5_suicide:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_special_5_suicide:OnTakeDamage(params)
if not IsServer() then return end
	local lines = pvzGameMode:GetLines()
	local ability = self:GetAbility()
	local farthest_in_front = nil
	local farthest_in_behind = nil
	local distance_from_front = 0
	local distance_from_behind = 0
	
	local ability = self:GetAbility()
	local dmg =  self:GetAbility():GetSpecialValueFor("dmg")
	local caster = params.unit
	
	--and params.attacker:HasModifier("modifier_zombie")
	if params.unit == self:GetParent() and (params.attacker:GetTeamNumber()==DOTA_TEAM_BADGUYS or params.attacker:GetTeamNumber()==DOTA_TEAM_NEUTRALS) then
		--print("takeDamage")
		if caster:GetHealth()<=1 then
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false)
			if #targets >= 1 then
				for _,target in pairs(targets) do
					
					--print(#targets)
					local same_line = false
					if caster:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") and not target:HasModifier("modifier_cannot_be_attacked") then
						for i=1, lines do
							if caster:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
							same_line = true
						end
						end 
					end
					if same_line == true then

						local flower_location = caster:GetAbsOrigin()
						local target_location = target:GetAbsOrigin()
						
						local direction = (flower_location - target_location):Normalized()
						local direction_flower = (target_location - flower_location):Normalized()
						local forward_vector = target:GetForwardVector()
						local forward_vector_flower = caster:GetForwardVector()
						local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)

						local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y)

							if angle_flower<=30 then
								local distance = math.sqrt((flower_location.x - target_location.x)^2 + (flower_location.y - target_location.y)^2)
								if distance >= distance_from_front then
									--print("fartest in front")
									distance_from_front = distance
									farthest_in_front = target
								end
							elseif angle_flower >30 then
								local distance = math.sqrt((flower_location.x - target_location.x)^2 + (flower_location.y - target_location.y)^2)
								if distance >= distance_from_behind then
									--print("fartest behind")
									distance_from_behind = distance
									farthest_in_behind = target
								end
							end

						local damage = target:GetHealth()*dmg/100
						local damage_table = {
							victim = target,
							attacker = caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_PURE
						}
						ApplyDamage(damage_table)
					end
				end
			end

			local pathRadius	= 100
			local duration		= 1

			if farthest_in_behind == nil
				then farthest_in_behind = caster
			end
			if farthest_in_front == nil
				then farthest_in_front = caster
			end

			local startPos = farthest_in_behind:GetAbsOrigin() - farthest_in_behind:GetForwardVector() * 200
			local endPos = farthest_in_front:GetAbsOrigin() + farthest_in_front:GetForwardVector() * 200

			local particleName = "particles/jakiro_macropyre.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, startPos )
			ParticleManager:SetParticleControl( pfx, 1, endPos )
			ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
			ParticleManager:SetParticleControl( pfx, 3, startPos )
			EmitSoundOn("SoundFireOn", caster)
			caster:Kill(self:GetAbility(), caster)
		end
	end
end