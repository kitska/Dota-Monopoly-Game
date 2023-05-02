require('utilities')
require('libraries/timers')
Buy = class({})

function Buy:OnSpellStart()
	local caster = self:GetCaster()
	local pID = caster:GetPlayerID()
	local index = 0
	local playerName = PlayerResource:GetPlayerName(pID)
	local pos = caster:GetOrigin()
	local cost = 0
	local fakePos = Dmono:GetFakePos()
	Dmono:IncrimentOfBoughts()
	local sectorsbought = Dmono:GetBoughtSectors()

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local amountUnits = Utilities:TableSize(units)

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

	local sectors = Entities:FindByName(nil,("sector_trigger_"..index))
	local visible_sectors = Entities:FindByName(nil,("sec_"..index.."_visible"))
	local teamID = PlayerResource:GetTeam(pID)
	print(teamID.." sector was bougnt "..index)
	print("sectors "..sectorsbought)
	if caster:GetGold() < cost then
		print("You can't afford to buy this sector " .. index)
		Say(caster, "Can't afford to buy this sector #" .. index .. ". Sector costs " .. cost .. ". " .. "You have " .. caster:GetGold() .. " gold " , false)
		caster:RemoveAbility("Buy")
		caster:RemoveAbility("None")
		caster:AddAbility("Roll"):SetLevel(1);
		return
	else
		caster:ModifyGold(cost * -1, false, 0)
	end
	if teamID == 2 then
		visible_sectors:SetRenderColor(61, 210, 150)
	elseif teamID == 3 then
		visible_sectors:SetRenderColor(243, 201, 9)
	elseif teamID == 6 then
		visible_sectors:SetRenderColor(197, 77, 168)
	elseif teamID == 7 then
		visible_sectors:SetRenderColor(255, 108, 0)
	end
	Say(caster, "Bought sector #" .. index .. " for ".. cost .. " gold", false)
	caster:RemoveAbility("Buy")
	caster:RemoveAbility("None")
	caster:AddAbility("Roll"):SetLevel(1)
end