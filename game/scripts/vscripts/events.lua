LinkLuaModifier( "modifier_main_hero", "modifiers/modifier_main_hero.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_plants_pot", "modifiers/modifier_plants_pot.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_turning", "modifiers/modifier_disable_turning.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tombestone_spawner", "modifiers/modifier_tombestone_spawner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lab_stunned", "modifiers/modifier_lab_stunned.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_main_treant", "modifiers/modifier_main_treant.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_main_undying", "modifiers/modifier_main_undying.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_second_undying", "modifiers/modifier_main_undying.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tombestone_cd", "zombies/zombies.lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_pvz_2x2", "modifiers/modifier_lab_stunned.lua", LUA_MODIFIER_MOTION_NONE )
---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function pvzGameMode:OnGameRulesStateChange()
if not IsServer() then return end
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_INIT then
		CustomGameEventManager:Send_ServerToAllClients("gamesetup", nil)
		--print("DOTA_GAMERULES_STATE_INIT")
	end
	--if nNewState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
	--	CustomGameEventManager:Send_ServerToAllClients("gamesetup", nil)
	--end

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--CustomGameEventManager:Send_ServerToAllClients("hero_selection", nil) -- js
      --[[for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
         local hPlayer = PlayerResource:GetPlayer( nPlayerID )         
            if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
               if hPlayer.bFirstSpawned == nil then
               print("TEAM "..hPlayer:GetTeamNumber())
               if hPlayer:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
                  CreateHeroForPlayer("npc_dota_hero_treant", hPlayer)                 
               else
                  CreateHeroForPlayer("npc_dota_hero_undying", hPlayer)
               end   
               hPlayer.bFirstSpawned = true        
            end   
      end
      end]]
	end
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
      CustomGameEventManager:Send_ServerToAllClients("pre_game", nil)
	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
	end
end

--------------------------------------------------------------------------------
-- Event: OnNPCSpawned
--------------------------------------------------------------------------------
function pvzGameMode:OnNPCSpawned( event )
if not IsServer() then return end
	local spawnedUnit = EntIndexToHScript( event.entindex )

	local hero = spawnedUnit
   
    if spawnedUnit:IsRealHero() then           
        if spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            GameRules:GetGameModeEntity():SetContextThink("0.1", function()
            spawnedUnit = PlayerResource:ReplaceHeroWith(spawnedUnit:GetPlayerID(), "npc_dota_hero_undying", 25, 0)            
            end, 0)            
        end               
    end
      if spawnedUnit:GetUnitName()=="npc_dota_dj_eban" then 
         spawnedUnit:FindAbilityByName("dj_eban_original"):SetLevel(1)
         spawnedUnit:FindAbilityByName("dj_eban_rap"):SetLevel(1)
         spawnedUnit:FindAbilityByName("dj_eban_chill"):SetLevel(1)
         spawnedUnit:FindAbilityByName("dj_eban_original"):ToggleAbility()
         spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_disable_turning", {} )
        
      end
      if spawnedUnit:IsRealHero() then         
   		spawnedUnit:AddNewModifier( spawnedUnit, spawnedUnit, "modifier_main_hero", {} ) -- модифаер бессмертия на персонажей
         --
         --------------------------- TREANT --------------------------------------------------
         --
   		if spawnedUnit:GetUnitName() == "npc_dota_hero_treant" then -- если заспавнился трент
           
            if not spawnedUnit:IsAlive() then return end
            --print("alive")
            if spawnedUnit:GetTeamNumber()~=DOTA_TEAM_GOODGUYS then return end
            --print("goodguys")
            self:OnHeroInGame( hero )
            self.treant = spawnedUnit
            --print("Treants were spawned")
            local treant = spawnedUnit
            for abilitySlot=0,15 do
               local ability = treant:GetAbilityByIndex(abilitySlot)
               if ability ~= nil then 
                  ability:SetLevel(1)
               end
            end            
            local plantsPots = FindUnitsInRadius(treant:GetTeamNumber(), treant:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
            for _,ppot in pairs( plantsPots ) do
               if ppot:GetUnitName()=="npc_dota_creature_plants_pot" then             
                  ppot:AddNewModifier(spawnedUnit, nil, "modifier_plants_pot", {} ) -- модифаер для растений
                  ppot:AddNewModifier(spawnedUnit, nil, "modifier_disable_turning", {} )                 
               end               
            end
           
            
   		end
         --
         --------------------------- UNDYING --------------------------------------------------
         --
   		if spawnedUnit:GetUnitName() == "npc_dota_hero_undying" then -- если заспавнился зомби
   			self.undying = spawnedUnit
            self:OnHeroInGame( hero )
   			--print("Undying were spawned")
   			local undying = spawnedUnit
   			local tombestones = FindUnitsInRadius(undying:GetTeamNumber(), undying:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
   			--print("tomstones "..#tombestones)
   			-- ищем все горшки с растениями
    			for _,tomb in pairs( tombestones ) do -- 1 тамбу записываем как tomb 
   				if tomb:GetUnitName()=="npc_dota_creature_tombstone" then -- если у найденого юнита имя томбы   					
   					tomb:AddNewModifier(spawnedUnit, nil, "modifier_tombestone_spawner", {} ) -- модифаер для тамбы   					
   				end               
   			end	
   		end
      end

      if spawnedUnit:GetUnitName()=="npc_dota_plants_lab" then                
         for SlotCaster=0,15 do
            local caster_ability = spawnedUnit:GetAbilityByIndex(SlotCaster)            
            if caster_ability ~= nil then 
               caster_ability:SetLevel(1)
            end
         end
         spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_lab_stunned", {duration = -1} )
      end
      if spawnedUnit:GetUnitName()=="npc_dota_zombies_lab" then
         --[[if GetMapName() == "2x2" then
            local ab1 = spawnedUnit:AddAbility("zombies_upgrade_health_2x2")
            local ab2 = spawnedUnit:AddAbility("zombies_upgrade_damage_2x2")
            local ab3 = spawnedUnit:AddAbility("zombies_upgrade_armor_2x2")
            local ab4 = spawnedUnit:AddAbility("zombies_lab_cd_reduction_2x2")
            local ab5 = spawnedUnit:AddAbility("zombies_lab_gold_multiply_2x2")           
         elseif GetMapName() == "1x1" then
            
            local ab1 = spawnedUnit:AddAbility("zombies_upgrade_health")
            local ab2 = spawnedUnit:AddAbility("zombies_upgrade_damage")
            local ab3 = spawnedUnit:AddAbility("zombies_upgrade_armor")
            local ab4 = spawnedUnit:AddAbility("zombies_lab_cd_reduction")
            local ab5 = spawnedUnit:AddAbility("zombies_lab_gold_multiply")                      
         end
         ]]     
         --local ab6 = spawnedUnit:AddAbility("zombies_lab_gold")  
         for SlotCaster=0,15 do
            local caster_ability = spawnedUnit:GetAbilityByIndex(SlotCaster)
            if caster_ability ~= nil then 
               caster_ability:SetLevel(1)
            end
         end          
         spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_lab_stunned", {duration = -1} )
      end


      --[[ if spawnedUnit:GetUnitName()=="npc_dota_zombies_lab" or spawnedUnit:GetUnitName()=="npc_dota_plants_lab" then
         if GetMapName() == "2x2" then 
            spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_pvz_2x2", {duration = -1}) 
         end -- для клиeнтских проверок карты
         spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_lab_stunned", {duration = -1} )
      end
      ]]

   	--[[=============================== SPAWNED PLANTS POT =========================================
   	=================================== ЗАСПАВНИЛСЯ ГОРШОК =======================================]]
   	if spawnedUnit:GetUnitName() == "npc_dota_creature_plants_pot" then -- если заспавнился куст
   		--print("Plants pots were spawned")
   		local ppot = spawnedUnit
   		ppot:AddNewModifier(ppot, nil, "modifier_plants_pot", {} ) -- модифаер для растений
		   ppot:AddNewModifier(ppot, nil, "modifier_disable_turning", {} )
         
   		if not ppot:HasModifier("modifier_plants_pot") then
   			ppot:AddNewModifier(ppot, nil, "modifier_plants_pot", {} )
   		end
   		if not ppot:HasModifier("modifier_disable_turning") then
   			ppot:AddNewModifier(ppot, nil, "modifier_disable_turning", {} )
   		end
   	end
   	--[[=============================== SPAWNED TOMBSTONE =========================================
   	=================================== ЗАСПАВНИЛАСЬ ТОМБА =======================================]]
   	if spawnedUnit:GetUnitName() == "npc_dota_creature_tombstone" then -- если заспавнилась томба
   		--print("Tombstones were spawned")
         spawnedUnit.hasowner = false

         for i = 1, 7 do
             local abilityName
             if i <= 3 then
                 abilityName = "zombie_spawn_" .. i
             else
                 local tier = 3
                 if i == 7 then
                     tier = 4
                 end

                 -- Заповнюємо таблицю self.unusedAbilities всіма доступними здібностями для даного tier
                 self.unusedAbilities = {}
                 for j = 1, 3 do
                     table.insert(self.unusedAbilities, "zombie_spawn_" .. i .. "_" .. j)
                 end

                 -- Видаляємо з використаних здібність, якщо вона була раніше використана


               for k, v in pairs(self.usedAbilities) do
                  local count = 0 -- # не працює на к-в таблицях
                  for _ in pairs(self.usedAbilities) do
                      count = count + 1
                  end
                  if count>=12 then
                     --print("more than 12")
                     self.usedAbilities = {} -- повна очистка таблиці
                     
                     break
                  end
               
                  for j = #self.unusedAbilities, 1, -1 do
                     if self.unusedAbilities[j] == k then -- якщо невикористана здібність = використана здібність
                        table.remove(self.unusedAbilities, j)
                        break                      
                     end
                  end
               end

                 -- Вибираємо випадкову здібність з вільних для даного тиру
                 local randomIndex = RandomInt(1, #self.unusedAbilities)
                 abilityName = self.unusedAbilities[randomIndex]

                 -- Позначаємо вибрану здібність як використану
                 self.usedAbilities[abilityName] = true
             end

             local ability = spawnedUnit:AddAbility(abilityName)
             ability:SetLevel(i <= 3 and 2 or 3) -- левел
         end

         --print("UNUSED ABILITIES "..#self.unusedAbilities)
         --self:PrintTable(self.unusedAbilities)

         --print("USED ABILITIES "..#self.usedAbilities)        
         --self:PrintTable(self.usedAbilities)   

         --[[
         for i=1, 7 do
            if i <= 3 then
               local ability = spawnedUnit:AddAbility("zombie_spawn_"..i)
               if i == 1 then
                  ability:SetLevel(1) -- 1 tier
               else
                  ability:SetLevel(2) -- 2 tier
               end
            else
               local j = RandomInt(1,3)
               local ability = spawnedUnit:AddAbility("zombie_spawn_"..i.."_"..j)
                if i == 7 then
                  ability:SetLevel(4) -- 4 tier
               else then
                  ability:SetLevel(3) -- 3 tier
               end               
            end
         end

         local tombestones = FindUnitsInRadius(spawnedUnit:GetTeamNumber(), spawnedUnit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
         local tombs = {}         
         if #tombestones>=1 then
            for _,tomb in pairs( tombestones ) do -- 1 тамбу записываем как tomb 
               if tomb:GetUnitName()=="npc_dota_creature_tombstone" then -- если у найденого юнита имя томбы                  
                                 
               end               
            end   
         end
         ]]
         --[[
         local ability1 = spawnedUnit:AddAbility("zombie_spawn_1")
         local ability2 = spawnedUnit:AddAbility("zombie_spawn_2")
         local ability3 = spawnedUnit:AddAbility("zombie_spawn_3")
         local rand4 = RandomInt(1,3)
         local rand5 = RandomInt(1,3)
         local rand6 = RandomInt(1,3)
         local rand7 = RandomInt(1,2)
         local ability4 = spawnedUnit:AddAbility("zombie_spawn_4_"..rand4) 
         local ability5 = spawnedUnit:AddAbility("zombie_spawn_5_"..rand5)
         local ability6 = spawnedUnit:AddAbility("zombie_spawn_6_"..rand6)
         local ability7 = spawnedUnit:AddAbility("zombie_spawn_7_"..rand6)
         ability1:SetLevel(1)
         ability2:SetLevel(1)
         ability3:SetLevel(1)
         ability4:SetLevel(1)
         ability5:SetLevel(1)
         ability6:SetLevel(1)
         ability7:SetLevel(1)
         ]]

   		if not spawnedUnit:HasModifier("modifier_tombestone_spawner") then
   			spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_tombestone_spawner", {} )
            spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_lab_stunned", {duration = -1} )

            for abilitySlot=0,15 do
               local ability = spawnedUnit:GetAbilityByIndex(abilitySlot)
               if ability ~= nil then
                  --local abilityName = ability:GetAbilityName()
                  if not ability:IsActivated() then
                     ability:SetActivated(true)
                  end
               end
            end

   		end
   	end
   	--[[=============================== SPAWNED PLANTS =========================================
   	=================================== ЗАСПАВНИЛСЯ =======================================]]
   	if spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then -- если заспавнился юнит сил света
   		--print("spawned good guys")
   		if spawnedUnit:GetUnitName() ~= "npc_dota_hero_treant" and spawnedUnit:GetUnitName() ~= "npc_dota_creature_plants_pot" then -- если заспавнился не куст и не трент --------------------------------------------------------------------------------------------------------------------------------------------------------
 			   if self.treant ~= nil then   
              
               EmitSoundOn("SoundPlant", spawnedUnit)
            end            
         end
   	end
end

function pvzGameMode:OnEntityKilled( event )
if IsServer() then
	local k = EntIndexToHScript( event.entindex_killed )
   local unit = k:GetUnitName()
  -- print("unit name "..unit)
  if unit=="npc_dota_watermelon_1" or unit=="npc_dota_watermelon_2" or unit=="npc_dota_watermelon_3" then return end
	if k:HasModifier("modifier_plants") then
     --  print("modifier plants "..unit)
      if unit == "npc_plants_defender_1" or unit == "npc_plants_defender_1_2" or unit == "npc_plants_defender_1_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() + k:GetForwardVector()*30), false, nil, nil, DOTA_TEAM_GOODGUYS)
         k:RemoveSelf()
         return
      end
      if unit == "npc_plants_defender_2" or unit == "npc_plants_defender_2_2" or unit == "npc_plants_defender_2_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() + k:GetForwardVector()*30), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_defender_3" or unit == "npc_plants_defender_3_2" or unit == "npc_plants_defender_3_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() + k:GetForwardVector()*30), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_defender_4" or unit == "npc_plants_defender_4_2" or unit == "npc_plants_defender_4_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() + k:GetForwardVector()*30), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_defender_5" or unit == "npc_plants_defender_5_2" or unit == "npc_plants_defender_5_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() + k:GetForwardVector()*30), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_attacker_3" or unit == "npc_plants_attacker_3_2" or unit == "npc_plants_attacker_3_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() - k:GetForwardVector()*40), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_attacker_5" or unit == "npc_plants_attacker_5_2" or unit == "npc_plants_attacker_5_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() - k:GetForwardVector()*40), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_special_3" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() - k:GetForwardVector()*40), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
      if unit == "npc_plants_special_4" then
         local creature = CreateUnitByName( "npc_dota_creature_plants_pot", (k:GetAbsOrigin() - k:GetForwardVector()*40), false, nil, nil, DOTA_TEAM_GOODGUYS)
         return
      end
     -- print("no conditional "..unit)
      local creature = CreateUnitByName( "npc_dota_creature_plants_pot", k:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
	end
   if unit == "npc_dota_creature_fence" then k:RemoveSelf() end
end
   print("util removing")
   UTIL_Remove(k)
end


function pvzGameMode:OnHeroInGame( hero )
--print ("hero "..hero:GetUnitName())
if not IsServer() then return end   
Timers:CreateTimer(1, function()
   if not hero:IsAlive() then return end
if hero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
   if hero:GetUnitName() == "npc_dota_hero_treant" then
      local treants = 0      
      --print("treant")
      local treant_exist = false
      local allHeroes = HeroList:GetAllHeroes()
      for k, v in pairs( allHeroes ) do 
         if v:GetUnitName()=="npc_dota_hero_treant" then
            treants = treants + 1
            if v:HasModifier("modifier_main_treant") then treant_exist = true end -- если хоть один трент с этим модифаером
            --print("main treant exist")   
         end
      end      
      if not treant_exist or treants <= 1 then hero:AddNewModifier(hero, nil, "modifier_main_treant", {}) end      
   end
end
if hero:GetTeamNumber()~=DOTA_TEAM_GOODGUYS then
   if hero:GetUnitName() == "npc_dota_hero_undying" then
      
      --print("und TEAM "..hero:GetTeamNumber())
      local main_exist = false
      local allHeroes = HeroList:GetAllHeroes() -- ищем трента
      for k, v in pairs( allHeroes ) do -- делаем владельца
         if v:GetUnitName()=="npc_dota_hero_undying" then
           
            if v:HasModifier("modifier_main_undying") then main_exist = true end -- если хоть один трент с этим модифаером
           -- print("main undying exist")   
         end
      end
      if not main_exist then hero:AddNewModifier(hero, nil, "modifier_main_undying", {}) 
      else hero:AddNewModifier(hero, nil, "modifier_second_undying", {})
      end
   end
end
end)
end

function pvzGameMode:OnNonPlayerUsedAbility(event)
if not IsServer() then return end
   local abilityname = event.abilityname  
   local caster = EntIndexToHScript( event.caster_entindex)
   local casted_ability = nil
   local slot = 0
   --print("casted abilitty")
   if caster:GetUnitName()=="npc_dota_creature_tombstone" then
      local Tombs = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false) 
      
      local lines =  pvzGameMode:GetLines()
      
      
      for SlotCaster=0,15 do
         local caster_ability = caster:GetAbilityByIndex(SlotCaster)
         if caster_ability ~= nil then 
            if caster_ability == caster:FindAbilityByName(abilityname) then
               slot = SlotCaster               
            end
         end
      end     
      --print("casted ability "..slot)
      
      for _,tomb in pairs( Tombs ) do 
         if caster:HasModifier("modifier_lines") and tomb:HasModifier("modifier_lines") then
            for i=1, lines do
               if caster:HasModifier("modifier_line_"..i) and tomb:HasModifier("modifier_line_"..i) then                 
                  --print("same line")
                  local ability = tomb:GetAbilityByIndex(slot)
                  if ability~=nil then
                     ability:StartCooldown(ability:GetCooldown(1))
                  end                 
               end
            end  
         end  
      end 
   end
end
