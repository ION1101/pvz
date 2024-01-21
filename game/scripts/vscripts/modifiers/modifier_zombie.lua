LinkLuaModifier( "modifier_zombie_autoattack", "modifiers/modifier_zombie.lua", LUA_MODIFIER_MOTION_NONE )

modifier_zombie_autoattack = class({})

function modifier_zombie_autoattack:IsHidden() return true end
function modifier_zombie_autoattack:IsPurgable() return false end
function modifier_zombie_autoattack:IsBuff() return true end
function modifier_zombie_autoattack:RemoveOnDeath() return true end

function modifier_zombie_autoattack:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED ] = true
	}
end

function modifier_zombie_autoattack:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK
	} 
end

function modifier_zombie_autoattack:GetDisableAutoAttack() return 1 end

modifier_zombie = class({})

function modifier_zombie:IsHidden() return true end
function modifier_zombie:IsPurgable() return false end
function modifier_zombie:IsBuff() return true end
function modifier_zombie:RemoveOnDeath() return true end
function modifier_zombie:OnCreated()
	self.movespeed = self:GetParent():GetBaseMoveSpeed()
	--print(self.movespeed)
end
function modifier_zombie:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		--[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
	}
end
function modifier_zombie:DeclareFunctions()
	return {	
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
	} 
end
function modifier_zombie:GetModifierMoveSpeedOverride() return self.movespeed end
function modifier_zombie:OnCreated()

	self:StartIntervalThink(0.2)

end

function modifier_zombie:OnIntervalThink()
if IsServer() then
	local zombie = self:GetParent()

	local num_plants_in_front = 0
	local num_plants_behind = 0
	local house_target = nil
	local closest_flower = nil
	local shortest_distance = 0
	local lines = pvzGameMode:GetLines()

	local plats_targets = FindUnitsInRadius(zombie:GetTeamNumber(), zombie:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
	
	--if plants_targets ~= nil then

		--print(#plats_targets)
		for _,target in pairs(plats_targets) do
			
			if target:GetUnitName()=="npc_dota_creature_house" then
				house_target = target
				--print("found house")
			end
			local same_line = false

			if zombie:HasModifier("modifier_lines") and target:HasModifier("modifier_lines") then
				for i=1, lines do
					if zombie:HasModifier("modifier_line_"..i) and target:HasModifier("modifier_line_"..i) then
						--print("they are on the same line")
						same_line = true
					end
				end  
			end
			---------------------------------------------------------------
			------------------------ ATTACK FENCE -------------------------
			---------------------------------------------------------------
			if not zombie:HasModifier("z_modifier_6_attacks") and zombie:GetUnitName()~= "npc_zombie_6" then
			if same_line == true and target:GetUnitName() == "npc_dota_creature_fence" then
				--print("fence near, go eat it")
				local order_zombie =
				{
					UnitIndex = zombie:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = target:entindex()
				}

				--print("attacking fence")
				zombie:RemoveModifierByName("modifier_zombie_autoattack")
				ExecuteOrderFromTable(order_zombie)
				return
			end
			end
			if same_line == true and target:HasModifier("modifier_plants") then
				--print("same line plants")

				local flower_location = target:GetAbsOrigin()
				local zombie_location = zombie:GetAbsOrigin()
					
				local direction = (flower_location - zombie_location):Normalized() -- вектор между цветком и зомбаком
				local direction_flower = (zombie_location - flower_location):Normalized() -- вектор между зомбаком и цветком
				local forward_vector = target:GetForwardVector()  -- направление взгляда зомбака
				local forward_vector_flower = zombie:GetForwardVector() -- направление взгляда зомбака
				local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y) -- угол между цветком и зомби

				--local angle_flower = math.abs(RotationDelta((VectorToAngles(direction_flower)), VectorToAngles(forward_vector_flower)).y) -- угол между зомби и цветком

				--print("Angle: " .. angle)
				--print("Angle: zombie" .. angle_flower)

				if angle<=30 then
					num_plants_behind = num_plants_behind + 1
				elseif angle>30 then
					num_plants_in_front = num_plants_in_front + 1
				end

				------------ ЕСЛИ СПЕРЕДИ ЕСТЬ ВРАГИ ХОТЬ 1 ------------------------------
				if num_plants_in_front >= 1 then -- когда есть хоть одно расстение спереди
					if angle >30 then -- меряем только те расстения которые спереди
						local distance = math.sqrt((zombie_location.x - flower_location.x)^2 + (zombie_location.y - flower_location.y)^2) -- пишем расстояние между зомби и этим расстением
						--print("distance "..distance)
						if distance < shortest_distance then -- если расстояние от текущего юнита меньше чем до этого было записано
							shortest_distance = distance --у нашей переменной новое значение кратчайшего расстояния
							closest_flower = target -- ближайший противник (юнит) = юнит с кратчайшей дистанцией
						end
						if shortest_distance == 0 then -- если перебор первый (дефолтное значение 0)
							shortest_distance = distance -- сделать первого юнита кратчайшим
							closest_flower = target -- ближайший противник (юнит) = юнит с кратчайшей дистанцией
						end
					end
				end
			end
		end

		-- после цикла и переборов
		------------ ЕСЛИ СПЕРЕДИ ВРАГОВ НЕТ ---------------------------------

		---------------------------------------------------------------
		------------------------ MOVE TO POS  -------------------------
		---------------------------------------------------------------
		if num_plants_in_front == 0 and house_target~= nil then
			
				local order_zombie =
				{
					UnitIndex = zombie:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = house_target:entindex()
				}
				--print("attacking house")
				zombie:RemoveModifierByName("modifier_zombie_autoattack")
				ExecuteOrderFromTable(order_zombie)
				return

							--[[local PointName = "inhouse"
							local TudaNamNado = Entities:FindByName( nil, PointName )
							local PointOrigin = TudaNamNado:GetAbsOrigin()
							zombie:AddNewModifier(zombie, nil, "modifier_zombie_autoattack", {})
							--zombie:MoveToPosition(PointOrigin)
							

							local order_zombie =
							{
								UnitIndex = zombie:entindex(),
								OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
								Position = PointOrigin
							}
							--print("move to position")
							--zombie:RemoveModifierByName("modifier_zombie_autoattack")
							ExecuteOrderFromTable(order_zombie)
							return ]]
		end

		--print("shortest_distance "..shortest_distance)
		--print("in front "..num_plants_in_front)
		--print("in behind "..num_plants_behind)
		--print("------------") 

		---------------------------------------------------------------
		----------------------- ATTACK PLANTS -------------------------
		---------------------------------------------------------------

		if closest_flower ~= nil then
			if closest_flower:HasModifier("modifier_has_watermelon") then
				local watermelons = FindUnitsInRadius(closest_flower:GetTeamNumber(), closest_flower:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, FIND_CLOSEST, 0, false) 
				--print(#plantsPots)
				for _,watermelon in pairs( watermelons ) do --если очень близко растение или куст
			   		if watermelon:HasModifier("modifier_watermelon") then
			   			closest_flower = watermelon
			   			break
			   		end
			   	end
			end

			local order_zombie =
			{
				UnitIndex = zombie:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = closest_flower:entindex()
			}
			--print("attacking plants")
			zombie:RemoveModifierByName("modifier_zombie_autoattack")
			ExecuteOrderFromTable(order_zombie)
			return
		end

end
end