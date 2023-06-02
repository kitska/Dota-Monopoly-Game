require('libraries/timers')
function angleChangeForFirst( event )
	player = event.activator
	player:SetAngles(0,90,0)
end

function angleChangeForSecond( event )
	player = event.activator
	player:SetAngles(0,0,0)
end

function angleChangeForThird( event )
	player = event.activator
	player:SetAngles(0,270,0)
end

function angleChangeForFours( event )
	player = event.activator
	player:SetAngles(0,180,0)
end

function angleChangeForJail( event )
	player = event.activator
	player:SetAngles(0,330,0)
end

function startTrigger( event )
	player = event.activator
	player:ModifyGold(200, false, 0)
end

function changeAbility( event )
	player = event.activator
	local pID = player:GetPlayerID()
	local pos = player:GetOrigin()
	local fakePos = Dmono:GetFakePos(pID)
	local cost = 0
	local index = 0

	if pos == Vector(-1856, -1421.731445, 128) or pos == Vector(-1664, -1408, 128) or pos == Vector(-1664, -1719.28, 128) or pos == Vector(-1856, -1728, 128) then
		pos = caster:GetOrigin()
	elseif pos ~= fakePos then
		pos = fakePos
		print(pos)
	end

	index = Dmono:GetPosForSector(pos)
	cost = Dmono:GetFromSectorRentTable(index)

	local pID = player:GetPlayerID()
	local teamID = PlayerResource:GetTeam(pID)
	local checkSector = Dmono:GetFromSectorStatusBought(index)

	--print(cost.." rent")
	if checkSector == teamID then
		print("on own sector")
		Dmono:SetNewTurn()
	elseif checkSector == 0 then
		player:RemoveAbility("Roll")
		player:AddAbility("None"):SetLevel(1)
		player:AddAbility("Buy"):SetLevel(1)
	elseif checkSector ~= teamID then
		if index ~= 8 or index ~= 21 then
			if player:GetGold() > cost then
				player:ModifyGold(cost * -1, false, 0)
				Dmono:SendMoneyToOwner(checkSector, cost)
				Say(player, "You got into property. You paid ".. cost .." to the owner", false)
			end
		else
			local multiplyer = 0
			if Dmono:GetUtilityTable(pID) == 1 then
				multiplyer = 4
			elseif Dmono:GetUtilityTable(pID) == 2 then
				multiplyer = 10
			end
			cost = (Dmono:GetRand1ForUtility() + Dmono:GetRand2ForUtility()) * multiplyer
			if player:GetGold() > cost then
				player:ModifyGold(cost * -1, false, 0)
				Dmono:SendMoneyToOwner(checkSector, cost)
			end
		end
		Dmono:SetNewTurn()
	end
end

function OnFirstSpawn( event )
	player = event.activator
	local pID = player:GetPlayerID()
	player:SetAbilityPoints(0)
	Dmono:SetStationTable(pID, 0)
	Dmono:SetUtilityTable(pID, 0)
	player:RemoveAbility("None")
	player:RemoveAbility("Roll")
	player:RemoveAbility("Buy")
	player:AddAbility("Roll"):SetLevel(1)
	player:AddAbility("Upgrade"):SetLevel(1)
end

function OnPayTaxSector( event )
	player = event.activator
	local pID = player:GetPlayerID()
	local index = 0
	local pos = player:GetOrigin()
	local fakePos = Dmono:GetFakePos(pID)

	if pos == Vector(-1856, -1421.731445, 128) or pos == Vector(-1664, -1408, 128) or pos == Vector(-1664, -1719.28, 128) or pos == Vector(-1856, -1728, 128) then
		pos = caster:GetOrigin()
	elseif pos ~= fakePos then
		pos = fakePos
		print(pos)
	end

	if pos == Dmono:GetSectorPos(5) then
		index = 1
	elseif pos == Dmono:GetSectorPos(39) then
		index = 4
	end

	local paytaxer = Entities:FindByName(nil,("pay_tax_entity_"..index))

	if paytaxer then
        paytaxer:FindAbilityByName("pay_tax"):SetActivated(true)
        paytaxer:MoveToTargetToAttack(player)
		Timers:CreateTimer("paytax_timer", {
			endTime = 1,
			callback = function()
				paytaxer:Stop()
				paytaxer:FindAbilityByName("pay_tax"):SetActivated(false)
			end
		})
    end
	Dmono:SetNewTurn()
end

function OnChestSector( event )
	player = event.activator
	local randForChest = RandomInt(1, 16) 
	Dmono.ChestSectorScriptTable[randForChest](player)
	if Dmono:GetChestFlag() then
		return
		Dmono:SetChestFlag(false)
	else
		Dmono:SetNewTurn()
	end
end

function OnChanceSector( event )
	player = event.activator
	local pID = player:GetPlayerID()
	local playerPos = Dmono:GetFakePos(pID)
	local randForChance = 10--RandomInt(1, 16)
	Dmono.ChanceSectorScriptTable[randForChance](player)
	if Dmono:GetChanceFlag() then
		return
		Dmono:SetChanceFlag(false)
	else
		Dmono:SetNewTurn()
	end
end

function OnVisitJailSector( event )
	player = event.activator
	Dmono:SetNewTurn()
end

function JailTrigger( event )
	player = event.activator
	playerID = player:GetPlayerID()
	Dmono:InsertJail(playerID, 3)
	local JailCoords = Dmono:GetJailCoords()
	FindClearSpaceForUnit(player, JailCoords, true)
	Dmono:SetNewTurn()
end

function InJailTrigger( event )
	player = event.activator
	player:RemoveModifierByName("modifier_muted")
	player:RemoveAbility("Roll")
	player:AddAbility("Jail_Roll"):SetLevel(1)
	player:AddAbility("Pay_Jail"):SetLevel(1)
end

function SkipTurnTrigger( event )
	player = event.activator
	local pID = player:GetPlayerID()
	Dmono:SkipTurn(pID)
	local modifier = player:AddNewModifier(nil, nil, "modifier_winter_wyvern_cold_embrace", {duration = -1})
	Dmono:SetNewTurn()
end