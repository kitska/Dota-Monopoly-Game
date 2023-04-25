<<<<<<< HEAD
require('libraries/timers')
=======

>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
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

function startTrigger( event )
	player = event.activator
	player:ModifyGold(200, false, 0)
end

function changeAbility( event )
	player = event.activator

	local pos = player:GetOrigin()
	local fakePos = Dmono:GetFakePos()
	local cost = 0
	local index = 0

	if pos == Vector(-1856, -1421.731445, 186) or pos == Vector(-1664, -1408, 186) or pos == Vector(-1664, -1719.28, 186) or pos == Vector(-1856, -1728, 186) then
		pos = caster:GetOrigin()
	elseif pos ~= fakePos then
		pos = fakePos
		print(pos)
	end

	if pos == Dmono:GetSectorPos(2) then
		index = 1
		cost = 60
	elseif pos == Dmono:GetSectorPos(4) then
		index = 3
		cost = 60
	elseif pos == Dmono:GetSectorPos(6) then
		index = 5
		cost = 200
	elseif pos == Dmono:GetSectorPos(7) then
		index = 6
		cost = 100
	elseif pos == Dmono:GetSectorPos(9) then
		index = 8
		cost = 100
	elseif pos == Dmono:GetSectorPos(10) then
		index = 9
		cost = 120
	elseif pos == Dmono:GetSectorPos(12) then
		index = 10
		cost = 140
	elseif pos == Dmono:GetSectorPos(14) then
		index = 12
		cost = 140
	elseif pos == Dmono:GetSectorPos(15) then
		index = 13
		cost = 160
	elseif pos == Dmono:GetSectorPos(16) then
		index = 14
		cost = 200
	elseif pos == Dmono:GetSectorPos(17) then
		index = 15
		cost = 180
	elseif pos == Dmono:GetSectorPos(19) then
		index = 17
		cost = 180
	elseif pos == Dmono:GetSectorPos(20) then
		index = 18
		cost = 200
	elseif pos == Dmono:GetSectorPos(22) then
		index = 19
		cost = 220
	elseif pos == Dmono:GetSectorPos(24) then
		index = 21
		cost = 220
	elseif pos == Dmono:GetSectorPos(25) then
		index = 22
		cost = 240
	elseif pos == Dmono:GetSectorPos(26) then
		index = 23
		cost = 200
	elseif pos == Dmono:GetSectorPos(27) then
		index = 24
		cost = 260
	elseif pos == Dmono:GetSectorPos(28) then
		index = 25
		cost = 260
	elseif pos == Dmono:GetSectorPos(30) then
		index = 27
		cost = 280
	elseif pos == Dmono:GetSectorPos(32) then
		index = 28
		cost = 300
	elseif pos == Dmono:GetSectorPos(33) then
		index = 29
		cost = 300
	elseif pos == Dmono:GetSectorPos(35) then
		index = 31
		cost = 320
	elseif pos == Dmono:GetSectorPos(36) then
		index = 32
		cost = 200
	elseif pos == Dmono:GetSectorPos(38) then
		index = 34
		cost = 350
	elseif pos == Dmono:GetSectorPos(40) then
		index = 36
		cost = 400
	end

	local visible_sectors = Entities:FindByName(nil,("sec_"..index.."_visible"))
	local pID = player:GetPlayerID()
	local teamID = PlayerResource:GetTeam(pID)
	local teamColor = visible_sectors:GetRenderColor()
	local FIRST_COLOR = Vector(255, 255, 255)
	local heroTeamColor = Vector(0 ,0 ,0)

	if teamID == 2 then
		heroTeamColor = Vector(61, 210, 150)
	elseif teamID == 3 then
		heroTeamColor = Vector(243, 201, 9)
	elseif teamID == 6 then
		heroTeamColor = Vector(197, 77, 168)
	elseif teamID == 7 then
		heroTeamColor = Vector(255, 108, 0)
	end

	if teamColor == FIRST_COLOR then
		player:RemoveAbility("Roll")
		player:AddAbility("None"):SetLevel(1)
		player:AddAbility("Buy"):SetLevel(1)
		return
	elseif teamColor == heroTeamColor then
		player:RemoveAbility("Roll")
		player:AddAbility("None"):SetLevel(1)
		return
	else
		player:RemoveAbility("Roll")
		player:AddAbility("None"):SetLevel(1)
		caster:ModifyGold(cost * -1, false, 0)
		Say(player, "You got into property. You paid ".. cost .." to the owner", false)
	end
end

function OnFirstSpawn( event )
	player = event.activator
	player:RemoveAbility("None")
	player:RemoveAbility("Roll")
	player:RemoveAbility("Buy")
	player:AddAbility("Roll"):SetLevel(1)
<<<<<<< HEAD
end

function OnPayTaxSector( event )
	player = event.activator
	local index = 0
	local pos = player:GetOrigin()
	local fakePos = Dmono:GetFakePos()

	if pos == Vector(-1856, -1421.731445, 186) or pos == Vector(-1664, -1408, 186) or pos == Vector(-1664, -1719.28, 186) or pos == Vector(-1856, -1728, 186) then
		pos = caster:GetOrigin()
	elseif pos ~= fakePos then
		pos = fakePos
		print(pos)
	end

	if pos == Dmono:GetSectorPos(5) then
		index = 1
	elseif pos == Dmono:GetSectorPos(13) then
		index = 2
	elseif pos == Dmono:GetSectorPos(29) then
		index = 3
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
=======
>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
end