LinkLuaModifier( "modifier_dj_eban", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_original_thinker", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original_1", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original_2", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original_3", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original_4", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_original_5", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_playing_original_song", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_rap_1", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- Jake Hill Satin Black
LinkLuaModifier( "modifier_rap_2", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- RedZed - Straight Outta Flames
LinkLuaModifier( "modifier_rap_3", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- NF - When I Grow Up
LinkLuaModifier( "modifier_rap_4", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- XXXTentacion - Look At Me
LinkLuaModifier( "modifier_rap_5", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- zero936_the_box
LinkLuaModifier( "modifier_rap_6", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- write_this_down_mashup
LinkLuaModifier( "modifier_rap_7", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- drdre_what_the_difference
LinkLuaModifier( "modifier_rap_8", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- lil_nas_x_industry_baby
LinkLuaModifier( "modifier_rap_9", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- denzel_curry_ultimate
LinkLuaModifier( "modifier_rap_10", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- t_i_24_s

dj_eban_original = class({})

function dj_eban_original:OnToggle()
if not IsServer() then return end
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_original_thinker", {})
		if caster:FindAbilityByName("dj_eban_rap"):GetToggleState() then caster:FindAbilityByName("dj_eban_rap"):ToggleAbility() end
		if caster:FindAbilityByName("dj_eban_chill"):GetToggleState() then caster:FindAbilityByName("dj_eban_chill"):ToggleAbility() end
	else
		if caster:HasModifier("modifier_playing_original_song") then caster:RemoveModifierByName("modifier_playing_original_song") end
		if caster:HasModifier("modifier_original_thinker") then caster:RemoveModifierByName("modifier_original_thinker") end
		for i=1, 5 do
			caster:RemoveModifierByName("modifier_original_"..i)
		end
	end
end

modifier_original_thinker = class({})
function  modifier_original_thinker:IsHidden() return true end
function modifier_original_thinker:OnCreated()
 	
	self:StartIntervalThink(1)
end
function modifier_original_thinker:OnIntervalThink()
if not IsServer() then return end
--print(self:GetParent():GetTeamNumber())
local heroes = FindUnitsInRadius(2, self:GetParent():GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 	
if #heroes == 0 then
	local enemies = FindUnitsInRadius(3, self:GetParent():GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	--print(#enemies)
	for _,undying in pairs( enemies ) do
	   	if undying:IsAlive() and undying:IsRealHero() then
	   		self:GetParent():SetOwner(undying) 
	   		self:GetParent():SetControllableByPlayer( undying:GetPlayerOwnerID(), true ) 
	   		self:GetParent():SetTeam(undying:GetTeamNumber())
	   		--print("dj undy")			
	   	end
	end
else
	for _,treant in pairs( heroes ) do
	   	if treant:IsAlive() and treant:IsRealHero() then
	   		self:GetParent():SetOwner(treant) 
	   		self:GetParent():SetControllableByPlayer( treant:GetPlayerOwnerID(), true ) 
	   		self:GetParent():SetTeam(treant:GetTeamNumber())
	   		--print("yes")			
	   	end
	end
end

	local caster = self:GetParent()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local gargantuars = 0
	if #targets >= 1 then
		for _,target in pairs(targets) do
			if target:GetUnitName()=="npc_zombie_7" or target:GetUnitName()=="npc_zombie_7_2" or target:GetUnitName()=="npc_zombie_7_3" then
				--print("gargantua")
				gargantuars = gargantuars + 1
				if not caster:HasModifier("modifier_original_5") then
					caster:RemoveModifierByName("modifier_playing_original_song")
					EmitGlobalSound("SoundGargantua")
					caster:AddNewModifier(caster, self:GetAbility(), "modifier_original_5", {duration = 50})
					caster:AddNewModifier(caster, self:GetAbility(), "modifier_playing_original_song", {duration = 50})
					for i=1, 5 do if i~=5 then caster:RemoveModifierByName("modifier_original_"..i) end end
				end
			end 
		end
	end
	if gargantuars == 0 then
		if caster:HasModifier("modifier_original_5") then
			caster:RemoveModifierByName("modifier_original_5")
			caster:RemoveModifierByName("modifier_playing_original_song")
		end
	end

	if not caster:HasModifier("modifier_original_5") then
	if GameRules:State_Get()==DOTA_GAMERULES_STATE_PRE_GAME then
		--print("pregame") -- начало игры
		if not caster:HasModifier("modifier_original_1") then
			caster:RemoveModifierByName("modifier_playing_original_song")
			EmitGlobalSound("SoundPreGame")
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_original_1", {duration = 21})
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_playing_original_song", {duration = 21})
			for i=1, 5 do 
				if i~=1 then 
					caster:RemoveModifierByName("modifier_original_"..i) 
				end 
			end
		end
	elseif GameRules:State_Get()==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and not GameRules:IsDaytime() and GameRules:GetGameTime()<= 170 then
		--print(GameRules:GetGameTime()) -- первая ночь
		if not caster:HasModifier("modifier_original_2") then 
			caster:RemoveModifierByName("modifier_playing_original_song")
			EmitGlobalSound("SoundNight1")
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_original_2", {duration = 151})
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_playing_original_song", {duration = 151})
			for i=1, 5 do 
				if i~=2 then
					caster:RemoveModifierByName("modifier_original_"..i) 
				end 
			end
		end
	elseif GameRules:State_Get()==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GameRules:IsDaytime() then
		--print("Day time") -- день
		if not caster:HasModifier("modifier_original_3") then 
			caster:RemoveModifierByName("modifier_playing_original_song")
			EmitGlobalSound("SoundDay")
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_original_3", {duration = 305})
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_playing_original_song", {duration = 305})
			for i=1, 5 do if i~=3 then caster:RemoveModifierByName("modifier_original_"..i) end end
		end
	elseif GameRules:State_Get()==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and not GameRules:IsDaytime() then
		--print("Night time") -- ночь
		if not caster:HasModifier("modifier_original_4") then
			caster:RemoveModifierByName("modifier_playing_original_song")	
			EmitGlobalSound("SoundNight2")
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_original_4", {duration = 310})
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_playing_original_song", {duration = 310})
			for i=1, 5 do if i~=4 then caster:RemoveModifierByName("modifier_original_"..i) end end
		end
	end
	end
end

modifier_playing_original_song = class({})
function modifier_playing_original_song:IsHidden() return false end
function modifier_playing_original_song:IsBuff() return true end
function modifier_playing_original_song:OnDestroy()
if not IsServer() then return end
	StopGlobalSound("SoundPreGame")
	StopGlobalSound("SoundNight1")
	StopGlobalSound("SoundNight2")
	StopGlobalSound("SoundDay")
	StopGlobalSound("SoundGargantua")
end
function modifier_playing_original_song:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_playing_original_song:GetOverrideAnimation() return ACT_DOTA_TAUNT end
modifier_original_1 = class({})
modifier_original_2 = class({})
modifier_original_3 = class({})
modifier_original_4 = class({})
modifier_original_5 = class({})
function modifier_original_1:IsHidden() return true end
function modifier_original_2:IsHidden() return true end
function modifier_original_3:IsHidden() return true end
function modifier_original_4:IsHidden() return true end
function modifier_original_5:IsHidden() return true end

--====================================================================================
--============== D J =================================================================
--===================== E B A N ======================================================
--====================================================================================
--====================================================================================
modifier_dj_eban = class({})

function modifier_dj_eban:IsHidden() return true end
function modifier_dj_eban:OnCreated()
if not IsServer() then return end
	--[[self:StartIntervalThink(1)
	self.treant1 = nil
	self.treant2 = nil
	--local treant2 = nil
	self.zombie1 = nil
	self.zombie2 = nil
	--local zombie2 = nil

	for k, v in pairs( HeroList:GetAllHeroes() ) do
		if v:GetUnitName()=="npc_dota_hero_treant" and v:IsAlive() then
			if self.treant1 == nil then				
				self.treant1 = v			
			end
			if self.treant2 == nil then
				if self.treant1 ~= v then
					--print("another treant")
					self.treant2 = v
				end
			end

		end
		if v:GetUnitName()=="npc_dota_hero_undying" and v:IsAlive() then
			if self.zombie1 == nil then
				self.zombie1 = v				
			end
			if self.zombie2 == nil then
				if self.zombie1 ~= v then
					--print("another zombie")
					self.zombie2 = v
				end
			end
		end
	end
	if self.treant1 ~= nil then		
		if self.treant2 ~= nil then
			--print("two treants found")
			SetUnitShareMaskForPlayer(self.treant1:GetPlayerOwnerID(), self.treant2:GetPlayerOwnerID(), 1, true)
			SetUnitShareMaskForPlayer(self.treant2:GetPlayerOwnerID(), self.treant1:GetPlayerOwnerID(), 2, true)
		end
		self:GetParent():SetControllableByPlayer( self.treant1:GetPlayerOwnerID(), true )
	end
	if self.zombie1 ~= nil then		
		if self.zombie2 ~= nil then
			--print("two zombies found")
			SetUnitShareMaskForPlayer(self.zombie1:GetPlayerOwnerID(), self.zombie2:GetPlayerOwnerID(), 3, true)
			SetUnitShareMaskForPlayer(self.zombie2:GetPlayerOwnerID(), self.zombie1:GetPlayerOwnerID(), 4, true)
		end
		self:GetParent():SetControllableByPlayer( self.zombie1:GetPlayerOwnerID(), true )
	end
	]]
end
function modifier_dj_eban:OnIntervalThink()
	self:OnCreated()
end

function modifier_dj_eban:CheckState()
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


dj_eban_rap = class({})
function dj_eban_rap:GetIntrinsicModifierName()
	return "modifier_dj_eban"
end
function dj_eban_rap:OnToggle()
if not IsServer() then return end
	local caster = self:GetCaster()

	if self:GetToggleState() then
		local j = 247
		if caster:FindAbilityByName("dj_eban_original"):GetToggleState() then caster:FindAbilityByName("dj_eban_original"):ToggleAbility() end
		if caster:FindAbilityByName("dj_eban_chill"):GetToggleState() then caster:FindAbilityByName("dj_eban_chill"):ToggleAbility() end
		
		local rand = RandomInt(1,10)
		if rand == 1 then j = 138 end
		if rand == 2 then j = 127 end
		if rand == 3 then j = 199 end
		if rand == 4 then j = 129 end
		if rand == 5 then j = 121 end
		if rand == 6 then j = 163 end
		if rand == 7 then j = 247 end
		if rand == 8 then j = 214 end
		if rand == 9 then j = 193 end
		if rand == 10 then j = 247 end
		EmitGlobalSound("SoundRap"..rand)
		caster:AddNewModifier(caster, self, "modifier_rap_"..rand, {duration = j})
	else
		for i=1, 10 do
			if caster:HasModifier("modifier_rap_"..i) then
				caster:RemoveModifierByName("modifier_rap_"..i)
				StopGlobalSound("SoundRap"..i)
			end
		end
	end

end



modifier_rap_1 = class({})
function modifier_rap_1:IsHidden() return false end
function modifier_rap_1:IsBuff() return true end
function modifier_rap_1:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_2 = class({})
function modifier_rap_2:IsHidden() return false end
function modifier_rap_2:IsBuff() return true end
function modifier_rap_2:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_3 = class({})
function modifier_rap_3:IsHidden() return false end
function modifier_rap_3:IsBuff() return true end
function modifier_rap_3:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_4 = class({})
function modifier_rap_4:IsHidden() return false end
function modifier_rap_4:IsBuff() return true end
function modifier_rap_4:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_5 = class({})
function modifier_rap_5:IsHidden() return false end
function modifier_rap_5:IsBuff() return true end
function modifier_rap_5:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_6 = class({})
function modifier_rap_6:IsHidden() return false end
function modifier_rap_6:IsBuff() return true end
function modifier_rap_6:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_7 = class({})
function modifier_rap_7:IsHidden() return false end
function modifier_rap_7:IsBuff() return true end
function modifier_rap_7:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_8 = class({})
function modifier_rap_8:IsHidden() return false end
function modifier_rap_8:IsBuff() return true end
function modifier_rap_8:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_9 = class({})
function modifier_rap_9:IsHidden() return false end
function modifier_rap_9:IsBuff() return true end
function modifier_rap_9:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end
modifier_rap_10 = class({})
function modifier_rap_10:IsHidden() return false end
function modifier_rap_10:IsBuff() return true end
function modifier_rap_10:OnDestroy()
	for i=1, 10 do
		if self:GetParent():HasModifier("modifier_rap_"..i) then
			self:GetParent():RemoveModifierByName("modifier_rap_"..i)
			StopGlobalSound("SoundRap"..i)
		end
	end
end


LinkLuaModifier( "modifier_chill_1", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- bobby_vinton_mr_lonely 1
LinkLuaModifier( "modifier_chill_2", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- build_me_up_buttercup 2 
LinkLuaModifier( "modifier_chill_3", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- gustixa_lemon_tree 3 
LinkLuaModifier( "modifier_chill_4", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- daft_punk_get_lucky 4
LinkLuaModifier( "modifier_chill_5", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- feder_goodbye 5
LinkLuaModifier( "modifier_chill_6", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- gangsta_paradise_lofi 6
LinkLuaModifier( "modifier_chill_7", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- gnarls_barkley_crazy 7
LinkLuaModifier( "modifier_chill_8", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- iamnotshane_maybe_my_soulmate_died 8
LinkLuaModifier( "modifier_chill_9", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- justin_timberlake_cry_me_a_river 9
LinkLuaModifier( "modifier_chill_10", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- stay_with_me_remix 10
LinkLuaModifier( "modifier_chill_11", "dj_eban.lua", LUA_MODIFIER_MOTION_NONE ) -- tame_impala_the_less_i_know_the_better 11

dj_eban_chill = class({})
function dj_eban_chill:OnToggle()
if not IsServer() then return end
	local caster = self:GetCaster()

	if self:GetToggleState() then
		local j = 247
		if caster:FindAbilityByName("dj_eban_original"):GetToggleState() then caster:FindAbilityByName("dj_eban_original"):ToggleAbility() end
		if caster:FindAbilityByName("dj_eban_rap"):GetToggleState() then caster:FindAbilityByName("dj_eban_rap"):ToggleAbility() end
		local rand = RandomInt(1,11)
		if rand == 1 then j = 139 end --
		if rand == 2 then j = 107 end --
		if rand == 3 then j = 125 end --
		if rand == 4 then j = 245 end --
		if rand == 5 then j = 269 end --
		if rand == 6 then j = 115 end --
		if rand == 7 then j = 179 end --
		if rand == 8 then j = 114 end --
		if rand == 9 then j = 142 end --
		if rand == 10 then j = 122 end --
		if rand == 11 then j = 217 end --
		EmitGlobalSound("SoundChill"..rand)
		caster:AddNewModifier(caster, self, "modifier_chill_"..rand, {duration = j})
	else
		for i=1, 11 do
			if caster:HasModifier("modifier_chill_"..i) then
				caster:RemoveModifierByName("modifier_chill_"..i)
				StopGlobalSound("SoundChill"..i)
			end
		end
	end

end



modifier_chill_1 = class({})
function modifier_chill_1:IsHidden() return false end
function modifier_chill_1:IsBuff() return true end
function modifier_chill_1:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_2 = class({})
function modifier_chill_2:IsHidden() return false end
function modifier_chill_2:IsBuff() return true end
function modifier_chill_2:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_3 = class({})
function modifier_chill_3:IsHidden() return false end
function modifier_chill_3:IsBuff() return true end
function modifier_chill_3:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_4 = class({})
function modifier_chill_4:IsHidden() return false end
function modifier_chill_4:IsBuff() return true end
function modifier_chill_4:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_5 = class({})
function modifier_chill_5:IsHidden() return false end
function modifier_chill_5:IsBuff() return true end
function modifier_chill_5:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_6 = class({})
function modifier_chill_6:IsHidden() return false end
function modifier_chill_6:IsBuff() return true end
function modifier_chill_6:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_7 = class({})
function modifier_chill_7:IsHidden() return false end
function modifier_chill_7:IsBuff() return true end
function modifier_chill_7:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_8 = class({})
function modifier_chill_8:IsHidden() return false end
function modifier_chill_8:IsBuff() return true end
function modifier_chill_8:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_9 = class({})
function modifier_chill_9:IsHidden() return false end
function modifier_chill_9:IsBuff() return true end
function modifier_chill_9:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_10 = class({})
function modifier_chill_10:IsHidden() return false end
function modifier_chill_10:IsBuff() return true end
function modifier_chill_10:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end
modifier_chill_11 = class({})
function modifier_chill_10:IsHidden() return false end
function modifier_chill_10:IsBuff() return true end
function modifier_chill_10:OnDestroy()
	for i=1, 11 do
		if self:GetParent():HasModifier("modifier_chill_"..i) then
			self:GetParent():RemoveModifierByName("modifier_chill_"..i)
			StopGlobalSound("SoundChill"..i)
		end
	end
end