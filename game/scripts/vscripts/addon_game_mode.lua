LinkLuaModifier( "modifier_lines", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_1", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_2", "lines.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_line_3", "lines.lua", LUA_MODIFIER_MOTION_NONE ) --для забора
LinkLuaModifier( "modifier_line_4", "lines.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_fence_1", "lines.lua", LUA_MODIFIER_MOTION_NONE )

modifier_fence_1 = class({})
function modifier_fence_1:IsHidden() return false end
function modifier_fence_1:IsPurgable() return false end
function modifier_fence_1:RemoveOnDeath() return true end

if pvzGameMode == nil then
	_G.pvzGameMode = class({})	
end

require( "events" )
require( "timers" )
require( "settings" )
require( "libraries/notifications" )

function Precache( context )

	PrecacheResource( "model", "models/bushes/bush1.vmdl", context )
	PrecacheResource( "model", "models/bushes/bush2.vmdl", context )
	PrecacheResource( "model", "models/bushes/bush3.vmdl", context )

	PrecacheResource( "model", "models/items/furion/treant_flower_1.vmdl", context )
	

	PrecacheResource( "model", "models/heroes/undying/undying_minion_torso.vmdl", context )
	PrecacheResource( "model", "models/heroes/undying/undying_minion.vmdl", context )


	PrecacheResource( "model", "models/props_generic/fence_str_wood_01a.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_str_wood_01b.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_str_wood_01c.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_angle_wood_01a.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_angle_wood_01b.vmdl", context )
	PrecacheResource( "model", "models/props_generic/fence_angle_wood_01c.vmdl", context )
	PrecacheResource( "model", "models/fence1.vmdl", context )
	PrecacheResource( "model", "models/nut.vmdl", context )
	PrecacheResource( "model", "models/house.vmdl", context )
	PrecacheResource( "model", "models/sunflower/sunflower.vmdl", context )
	PrecacheResource( "model", "models/creeps/ice_biome/undeadtusk/undead_tuskskeleton_armor01.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/ravenous_woodfang/ravenous_woodfang.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/furion_treant_nelum_red/furion_treant_nelum_red.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/defender_of_the_jungle_lakad_coconut/defender_of_the_jungle_lakad_coconut.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/hallowed_horde/hallowed_horde.vmdl", context )
	PrecacheResource( "model", "models/props_structures/pumpkin001.vmdl", context )
	PrecacheResource( "model", "models/props_structures/pumpkin002.vmdl", context )
	PrecacheResource( "model", "models/props_structures/pumpkin003.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/eternalseasons_treant/eternalseasons_treant.vmdl", context )
	PrecacheResource( "model", "models/heroes/furion/treant.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/treant_cis/treant_cis.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/np_desert_traveller_treant/np_desert_traveller_treant.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/the_ancient_guardian_the_ancient_treants/the_ancient_guardian_the_ancient_treants.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/allfather_of_nature_treant/allfather_of_nature_treant.vmdl", context )
	PrecacheResource( "model", "models/items/furion/treant/supreme_gardener_treants/supreme_gardener_treants.vmdl", context )
	PrecacheResource( "model", "models/creeps/ice_biome/undeadtusk/undead_tuskskeleton01.vmdl", context )
	PrecacheResource( "model", "models/heroes/undying/undying_flesh_golem.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/deathmatch_dominator_golem/deathmatch_dominator_golem.vmdl", context )
	PrecacheResource( "model", "models/items/undying/idol_of_ruination/ruin_wight_minion.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/incurable_pestilence_golem/incurable_pestilence_golem.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/spring2021_bristleback_paganism_pope_golem/spring2021_bristleback_paganism_pope_golem.vmdl", context )
	PrecacheResource( "model", "models/creeps/ice_biome/undeadtusk/undead_tuskskeleton02.vmdl", context )
	PrecacheResource( "model", "models/items/undying/undying_fall20_immortal_head/undying_fall20_immortal_minion.vmdl", context )
	PrecacheResource( "model", "models/zombies/undying_helmet.vmdl", context )
	PrecacheResource( "model", "models/zombies/undying_arms.vmdl", context )
	PrecacheResource( "model", "models/zombies/undying_armor.vmdl", context )
	PrecacheResource( "model", "models/zombies/cannon.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/frostivus_2018_undying_accursed_draugr_golem/frostivus_2018_undying_accursed_draugr_golem.vmdl", context )
	PrecacheResource( "model", "models/zombies/dancer_glasses.vmdl", context )
	PrecacheResource( "model", "models/zombies/dancer_wig.vmdl", context )	
	PrecacheResource( "model", "models/zombies/dancer_armor.vmdl", context )
	PrecacheResource( "model", "models/zombies/dancer_arms.vmdl", context )
	PrecacheResource( "model", "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl", context )
	PrecacheResource( "model", "models/heroes/pudge/pudge.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/grim_harvest_golem/grim_harvest_golem.vmdl", context )
	PrecacheResource( "model", "models/items/undying/undying_fall20_immortal_head/undying_fall20_immortal_tombstone.vmdl", context )
	PrecacheResource( "model", "models/heroes/undying/undying_flesh_golem_rubick.vmdl", context )
	PrecacheResource( "model", "models/items/undying/flesh_golem/incurable_pestilence_golem/incurable_pestilence_golem.vmdl", context )
	PrecacheResource( "model", "models/watermelon/watermelon.vmdl", context )
	PrecacheResource( "model", "models/dj_table/sunglasses.vmdl", context )
	PrecacheResource( "model", "models/dj_table/dj_panel.vmdl", context )
	PrecacheResource( "model", "models/dj_table/headphones.vmdl", context )
	PrecacheResource( "model", "models/dj_table/laptop.vmdl", context )
	PrecacheResource( "model", "models/dj_table/mini_speaker.vmdl", context )
	PrecacheResource( "model", "models/dj_table/speakers.vmdl", context )
	PrecacheResource( "model", "models/dj_table/table.vmdl", context )
	PrecacheResource( "model", "models/projectiles/sphere.vmdl", context )
	PrecacheResource( "model", "models/potato_mine/potato_small.vmdl", context )
	PrecacheResource( "model", "models/items/furion/defender_of_the_jungle_weapon/defender_of_the_jungle_weapon.vmdl", context )


	--[[
		
		
		
		
		
		
		PrecacheResource( "model", "", context )
		PrecacheResource( "model", "", context )
		PrecacheResource( "model", "", context )
		PrecacheResource( "model", "", context )
		PrecacheResource( "model", "", context )
		PrecacheResource( "model", "", context )
	
	]]
	
	PrecacheResource( "particle", "particles/leshrac_base_attack_bpink.vpcf", context )
	PrecacheResource( "particle", "particles/leshrac_base_attack_c.vpcf", context )
	PrecacheResource( "particle", "particles/leshrac_base_attack_e.vpcf", context )
	PrecacheResource( "particle", "particles/leshrac_base_attack_h.vpcf", context )
	PrecacheResource( "particle", "particles/mirana_spell_arrow_destruction.vpcf", context )
	PrecacheResource( "particle", "particles/mirana_spell_arrow_destruction_sparkles.vpcf", context )
	PrecacheResource( "particle", "particles/mirana_spell_arrow_ribbon_b.vpcf", context )
	PrecacheResource( "particle", "particles/plants_attacker1.vpcf", context )
	PrecacheResource( "particle", "particles/wisp_guardian_explosion_ti7.vpcf", context )
	PrecacheResource( "particle", "particles/plants_attacker1.vpcf", context )
	PrecacheResource( "particle", "particles/leshrac_base_attack_b.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_sleep.vpcf", context )
	PrecacheResource( "particle", "particles/attacker_2_explodevpcf.vpcf", context )
	PrecacheResource( "particle", "particles/attacker_2_splash_ring.vpcf", context )
	PrecacheResource( "particle", "particles/attacker_4_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
	PrecacheResource( "particle", "particles/jakiro_macropyre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_rot.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_tnt_wlk.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/pogo_stick.vpcf", context )
	PrecacheResource( "particle", "particles/techies_remote_mines_detonate.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_expire.vpcf", context )
	PrecacheResource( "particle", "particles/disco_ball_channel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context )
	PrecacheResource( "particle", "particles/blademail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", context )
	PrecacheResource( "particle", "particles/attacker1_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/attacker2_projectile.vpcf", context )

	--[[

		
		
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "", context )
		PrecacheResource( "particle", "particles/attacker2_projectile.vpcf", context )

	]]
	
	--
	PrecacheResource( "soundfile", "soundevents/plants.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/zombies.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/dj_eban.vsndevts", context )


	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystal_maiden.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	

	--[[
			
			
					
			
			PrecacheResource( "soundfile", "", context )
			PrecacheResource( "soundfile", "", context )
			PrecacheResource( "soundfile", "", context )
			PrecacheResource( "soundfile", "", context )
			PrecacheResource( "soundfile", "", context )			
			
			]]
end

function Activate()
	GameRules.PVZ = pvzGameMode()
	GameRules.PVZ:InitGameMode()

	pvzGameMode:CustomSpawnCamps()
	pvzGameMode:SpawnZombieCamps()

	pvzGameMode:SpawnFence()
	pvzGameMode:SpawnDefenders()
	pvzGameMode:SpawnPlantsLab()
	pvzGameMode:SpawnZombiesLab()
	pvzGameMode:SpawnHouse()
	pvzGameMode:SpawnDjEban()
	--pvzGameMode:SpawnRadiantHouse()

end

--[[function pvzGameMode:SpawnRadiantHouse()

	local SpawnLocation = Entities:FindByName( nil, "HouseSpawn" )
	local house = CreateUnitByName( "npc_dota_creature_house", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )

end ]]



function pvzGameMode:CustomSpawnCamps()
	for name,_ in pairs(spawncamps) do
	spawnunits(name)
	end
end

function pvzGameMode:spawncamp(campname)
	spawnunits(campname)
end

-- Simple Custom Spawn
function spawnunits(campname)
	local spawndata = spawncamps[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end

    for i = 1, NumberToSpawn do
        local creature = CreateUnitByName( "npc_dota_creature_plants_pot", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
    end
end


function pvzGameMode:InitGameMode()

	print( "PVZ addon is loaded." )

	if GetMapName() == "1x1" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	elseif GetMapName() == "2x2" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 2 )
	end

	GameRules:SetFilterMoreGold(true)
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( pvzGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( pvzGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( pvzGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( pvzGameMode, "OnNonPlayerUsedAbility" ), self )	

	GameRules:SetPreGameTime(20)
    GameRules:SetStrategyTime(0)
    GameRules:SetStartingGold(50)
    GameRules:SetTimeOfDay(0)
    GameRules:SetHeroSelectionTime(0)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:SetShowcaseTime(0)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    local levelTable = {}
    levelTable[0] = 0
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( levelTable )
    GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
    --GameRules:GetGameModeEntity():GetAnnouncerDisabled(true)
    GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_treant" )

	self.numSpawnCamps = 0
	self.numSpawnTombs = 0
	if GetMapName() == "1x1" then -- 5 lines 9 cells per each
		--print("map is 1x1")
		self.numSpawnCamps = 45 -- 5x9
		self.numSpawnTombs = 5
		self.numSpawnFence = 5
	elseif GetMapName()=="2x2" then -- 8 lines 9 cells per each
		self.numSpawnCamps = 72 -- 8x9
		self.numSpawnTombs = 16
		self.numSpawnFence = 8
	end

	self.spawnTime = 99999
	spawncamps = {}
	for i = 1, self.numSpawnCamps do
		local campname = "p"..i.."spawn"
		spawncamps[campname] =
		{
			NumberToSpawn = 1
		}
	end
	spawntombs = {}
	for i = 1, self.numSpawnTombs do
		local campname = "t"..i.."spawn"
		spawntombs[campname] =
		{
			NumberToSpawn = 1
		}
	end
	fences = {}
	for i = 1, self.numSpawnFence do
		local campname = "fence"..i
		fences[campname] =
		{
			NumberToSpawn = 1
		}
	end

	defenders = {}
	for i = 1, self.numSpawnTombs do
		local campname = "superdefender"..i
		defenders[campname] =
		{
			NumberToSpawn = 1
		}
	end
	-- for tombs
	--print("init tombs")
	self.usedAbilities = {} 
	self.unusedAbilities = {}
	--self.spawnedtombs = 0
end

-- Evaluate the state of the game
function pvzGameMode:OnThink()

	-- проверка если трент за тьму
	local allHeroes = HeroList:GetAllHeroes()
	if allHeroes and not #allHeroes == 0 then
		for k, v in pairs( allHeroes ) do 
		    if v:GetUnitName()=="npc_dota_hero_treant" and v:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			    print("treant for dire")
		        GameRules:GetGameModeEntity():SetContextThink("0.1", function()
	            	v = PlayerResource:ReplaceHeroWith(v:GetPlayerID(), "npc_dota_hero_undying", 25, 0)            
	            end, 0)  
		    end
		end 
	end
	
	-- гейм стейти
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function pvzGameMode:SpawnPlantsLab()
	Timers:CreateTimer(2, function()
	local SpawnLocation = Entities:FindByName( nil, "plants_lab" )
	local creature = CreateUnitByName( "npc_dota_plants_lab", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
end)
end
function pvzGameMode:SpawnHouse()
	local SpawnLocation = Entities:FindByName( nil, "plants_house" )
	local creature = CreateUnitByName( "npc_dota_creature_house", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
end
function pvzGameMode:SpawnDjEban()
	local SpawnLocation = Entities:FindByName( nil, "dj_eban" )
	local creature = CreateUnitByName( "npc_dota_dj_eban", SpawnLocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
	
	local parent_vector = creature:GetForwardVector()
	local angle = math.atan2(parent_vector.y, parent_vector.x)
	creature:SetForwardVector(Vector(math.cos( angle - 190), math.sin( angle - 190),0))
	
	--SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/dj_table/sunglasses.vmdl"}):FollowEntity(creature, true)
	--SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/furion/defender_of_the_jungle_weapon/defender_of_the_jungle_weapon.vmdl"}):FollowEntity(creature, true)
	
end
function pvzGameMode:SpawnZombiesLab()
	Timers:CreateTimer(2, function()
	local SpawnLocation = Entities:FindByName( nil, "zombies_lab" )
	local creature = CreateUnitByName( "npc_dota_zombies_lab", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
	local parent_vector = creature:GetForwardVector()
	local angle = math.atan2(parent_vector.y, parent_vector.x)
	creature:SetForwardVector(Vector(math.cos( angle + 210), math.sin( angle + 210),0))
end)
end

function pvzGameMode:SpawnZombieCamps()
	for tomb,_ in pairs(spawntombs) do
	spawnzobiespawner(tomb)
	end
end

function pvzGameMode:spawncamp(campname)
	spawnzobiespawner(campname)
end

-- Simple Custom Spawn
function spawnzobiespawner(campname)
	local spawndata = spawntombs[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    --local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end

    for i = 1, NumberToSpawn do

    	Timers:CreateTimer(2, function()
			local creature = CreateUnitByName( "npc_dota_creature_tombstone", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
		end)       
        --print ("Spawning Camps")
        --creature:SetInitialGoalEntity( waypointlocation )
    end
end


---------- FENCE ---------------
function pvzGameMode:SpawnFence()
	for fence,_ in pairs(fences) do
	spawnfence(fence)
	end
end

function pvzGameMode:spawncamp(campname)
	spawnfence(campname)
end

-- Simple Custom Spawn
function spawnfence(campname)
	local spawndata = fences[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end
	Timers:CreateTimer(2, function()
		local creature = CreateUnitByName( "npc_dota_creature_fence", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	end)
   
end



function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end


---------- DEFENDERS ---------------
function pvzGameMode:SpawnDefenders()
	for defender,_ in pairs(defenders) do
	spawndefender(defender)
	end
end

function pvzGameMode:spawncamp(campname)
	spawndefender(campname)
end

-- Simple Custom Spawn
function spawndefender(campname)
	local spawndata = defenders[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    --local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
	if SpawnLocation == nil then
		return
	end
    local creature = CreateUnitByName( "npc_dota_creature_superdefender", SpawnLocation:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
end

function pvzGameMode:GetLines()
	if GetMapName()=="1x1" then return 5
	elseif GetMapName()=="2x2" then return 8 end
end

function pvzGameMode:GetNumPlayers()
	local numplayers = PlayerResource:GetPlayerCount()
	print("numplayers "..numplayers)
	return numplayers
end

function pvzGameMode:PrintTable(table)
	print("--------- print table ---------------")
	for key, value in pairs(table) do
        print("Key:", key, "Value:", value)
    end	
end