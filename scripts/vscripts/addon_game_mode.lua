---------------------------------------------------------------------------
-- Dmono class
---------------------------------------------------------------------------
if Dmono == nil then
	_G.Dmono = class({}) -- put Dmono in the global scope
end

---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
require("utilities")
require('libraries/timers')
---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache(context)
    PrecacheResource("file", "panorama/layouts/custom_game/timer.xml", context)
	PrecacheResource("file", "panorama/layouts/custom_game/my_panel.xml", context)
end

function Activate()
    GameRules.Dmono = Dmono()
    GameRules.Dmono:InitGameMode()
end
---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------

function Dmono:InitGameMode()
	print( "Load complete" )

	Dmono.RollCount = 0
	
	Dmono.BougntSectors = 0
	Dmono.FakePos = {}
	Dmono.TeamSectorValues = {}

	Dmono.pIDs = {}
	Dmono.TurnsQueue = {}
	Dmono.PlayerNPCs = {}
	Dmono.CurrentPlayerIndex = 1
	Dmono.TurnFlag = false

	Dmono.JailTable = {}
	Dmono.JailDiceCounter = 0

	Dmono.SectorStatusBought = {}
	Dmono.SectorRentTable = {}
	Dmono.SectorStatusUpgradeTable = {}
	Dmono.SectorUpgradePriceTable = {}
	Dmono.PriceSectorIndex = {}
	Dmono.SectorMortgageTable = {}

	Dmono.Upgrade1RentCost = {}
	Dmono.Upgrade2RentCost = {}
	Dmono.Upgrade3RentCost = {}
	Dmono.Upgrade4RentCost = {}
	Dmono.UpgradeFinaleRentCost = {}

	Dmono.StationTable = {}
	Dmono.UtilityTable = {}

	Dmono.Rand1ForUtility = 0
	Dmono.Rand2ForUtility = 0

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	
	Dmono.JailCoords = Vector(-2048, 1856, 128)

	Dmono.places = {
		Vector(-1732.92, -1565.54, 128),
		Vector(-1575.39, -1129.84, 128),
		Vector(-1575.39, -839.384, 128),
		Vector(-1575.39, -548.923, 128),
		Vector(-1575.39, -258.462, 128),
		Vector(-1575.39, 32.0001, 128),
		Vector(-1575.39, 322.462, 128),
		Vector(-1575.39, 612.923, 128),
		Vector(-1575.39, 903.385, 128),
		Vector(-1575.39, 1193.85, 128),
		Vector(-1732.92, 1629.54, 128),
		Vector(-1260.31, 1484.31, 128),
		Vector(-945.231, 1484.31, 128),
		Vector(-630.154, 1484.31, 128),
		Vector(-315.077, 1484.31, 128),
		Vector(-0.000305176, 1484.31, 128),
		Vector(315.077, 1484.31, 128),
		Vector(630.154, 1484.31, 128),
		Vector(945.231, 1484.31, 128),
		Vector(1260.31, 1484.31, 128),
		Vector(1732.92, 1629.54, 128),
		Vector(1575.38, 1193.85, 128),
		Vector(1575.38, 903.385, 128),
		Vector(1575.38, 612.923, 128),
		Vector(1575.38, 322.462, 128),
		Vector(1575.38, 32.0001, 128),
		Vector(1575.38, -258.462, 128),
		Vector(1575.38, -548.923, 128),
		Vector(1575.38, -839.384, 128),
		Vector(1575.38, -1129.85, 128),
		Vector(1732.92, -1565.54, 128),
		Vector(1260.31, -1420.31, 128),
		Vector(945.231, -1420.31, 128),
		Vector(630.154, -1420.31, 128),
		Vector(315.077, -1420.31, 128),
		Vector(-0.000305176, -1420.31, 128),
		Vector(-315.077, -1420.31, 128),
		Vector(-630.154, -1420.31, 128),
		Vector(-945.231, -1420.31, 128),
		Vector(-1260.31, -1420.31, 128)
	}

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(0)
	GameRules:SetPreGameTime(10)
	GameRules:SetPostGameTime(10)
	GameRules:SetStartingGold(1500)
	GameRules:SetTreeRegrowTime(1)

	GameRules:SetShowcaseTime(0)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,1)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,1)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1,1)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2,1)
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:LockCustomGameSetupTeamAssignment(false)
	GameRules:SetHeroSelectionTime(999)
	GameRules:SetPreGameTime(5)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
	
	
	GameMode = GameRules:GetGameModeEntity()
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetAlwaysShowPlayerInventory(false)
	GameMode:SetTopBarTeamValuesOverride(true)
	GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetBuybackEnabled(false)
	GameMode:SetDaynightCycleDisabled(false)
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
	ListenToGameEvent("npc_spawned", OnNPCSpawned, nil)

	local paytax1 = Entities:FindByName(nil,("pay_tax_entity_1"))
	local paytax2 = Entities:FindByName(nil,("pay_tax_entity_4"))
	DressPayTaxer(paytax1)
	DressPayTaxer(paytax2)
	local furion = Entities:FindByName(nil,("sector_16"))
	local trent = Entities:FindByName(nil,("sector_17"))
	DressFurionSector(furion)
	DressTrentSector(trent)
	local morphling = Entities:FindByName(nil,("sector_utility_2"))
	DressMorphSector(morphling)

	self:LoadAllKV()
	self:FromKVToTables()
end

function Dmono:SetRandForUtility(rand1, rand2)
	Dmono.Rand1ForUtility = rand1
	Dmono.Rand2ForUtility = rand2
end

function Dmono:GetRand1ForUtility()
	return Dmono.Rand1ForUtility
end

function Dmono:GetRand2ForUtility()
	return Dmono.Rand2ForUtility
end

function Dmono:GetStationTable(playerID)
	return self.StationTable[playerID]
end

function Dmono:SetStationTable(playerID, count)
	self.StationTable[playerID] = count
end

function Dmono:IncrementStationTable(playerID)
	self.StationTable[playerID] = self.StationTable[playerID] + 1
end

function Dmono:GetUtilityTable(playerID)
	return self.UtilityTable[playerID]
end

function Dmono:SetUtilityTable(playerID, count)
	self.UtilityTable[playerID] = count
end

function Dmono:IncrementUtilityTable(playerID)
	self.UtilityTable[playerID] = self.UtilityTable[playerID] + 1
end

function Dmono:GetFromSectorStatusBought(index)
	return self.SectorStatusBought[index]
end

function Dmono:GetFromSectorRentTable(index)
	return self.SectorRentTable[index]
end

function Dmono:GetFromSectorStatusUpgradeTable(index)
	return self.SectorStatusUpgradeTable[index]
end

function Dmono:GetFromSectorUpgradePriceTable(index)
	return self.SectorUpgradePriceTable[index]
end

function Dmono:GetFromPriceSectorIndex(index)
	return self.PriceSectorIndex[index]
end

function Dmono:GetFromSectorMortgageTable(index)
	return self.SectorMortgageTable[index]
end

function Dmono:UpdateFromSectorStatusBought(index, value)
	self.SectorStatusBought[index] = value
end

function Dmono:UpdateFromSectorRentTable(index, value)
	self.SectorRentTable[index] = value
end

function Dmono:UpdateFromSectorStatusUpgradeTable(index, value)
	self.SectorStatusUpgradeTable[index] = value
end

function Dmono:UpdateFromSectorUpgradePriceTable(index, value)
	self.SectorUpgradePriceTable[index] = value
end

function Dmono:UpdateFromPriceSectorIndex(index, value)
	self.PriceSectorIndex[index] = value
end

function Dmono:UpdateFromSectorMortgageTable(index, value)
	self.SectorMortgageTable[index] = value
end

function Dmono:LoadAllKV()
	print("Loading all KVs")
	GameRules.kvSector = LoadKeyValues("scripts/KV/sectors.kv")
end

function Dmono:FromKVToTables()
	local sectorKV = GameRules.kvSector
	local numCounter = 1

	repeat
		for k,v in pairs(sectorKV) do
			local sector = sectorKV[k]
			if tonumber(sector.Number) == numCounter then
				Dmono:FillSectorsTables(Dmono.SectorStatusBought, 0)
				Dmono:FillSectorsTables(Dmono.SectorRentTable, sector.Rent)
				Dmono:FillSectorsTables(Dmono.SectorStatusUpgradeTable, "NoUpgrade")
				Dmono:FillSectorsTables(Dmono.SectorUpgradePriceTable, sector.UpgradeCost)
				Dmono:FillSectorsTables(Dmono.PriceSectorIndex, sector.Price)
				Dmono:FillSectorsTables(Dmono.SectorMortgageTable, sector.Mortgage)

				Dmono:FillSectorsTables(Dmono.Upgrade1RentCost, sector.Upgrade1)
				Dmono:FillSectorsTables(Dmono.Upgrade2RentCost, sector.Upgrade2)
				Dmono:FillSectorsTables(Dmono.Upgrade3RentCost, sector.Upgrade3)
				Dmono:FillSectorsTables(Dmono.Upgrade4RentCost, sector.Upgrade4)
				Dmono:FillSectorsTables(Dmono.UpgradeFinaleRentCost, sector.FinalUpgrade)
				numCounter = numCounter + 1
			end
		end
	until numCounter > 28
end

function OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)
    if npc:IsRealHero() then
      local modifier = npc:AddNewModifier(nil, nil, "modifier_stunned", {duration = -1})
	  local modifier2 = npc:AddNewModifier(nil, nil, "modifier_silence", {duration = -1})
    end

	Dmono.playerCountTeam1 = PlayerResource:GetPlayerCountForTeam(2)
	Dmono.playerCountTeam2 = PlayerResource:GetPlayerCountForTeam(3)
	Dmono.playerCountTeam3 = PlayerResource:GetPlayerCountForTeam(6)
	Dmono.playerCountTeam4 = PlayerResource:GetPlayerCountForTeam(7)
	Dmono.PlayerCount = Dmono.playerCountTeam1 + Dmono.playerCountTeam2 + Dmono.playerCountTeam3 + Dmono.playerCountTeam4

	if Dmono.PlayerCount == 1 then
		Dmono.pIDs = {0}
	elseif Dmono.PlayerCount == 2 then
		Dmono.pIDs = {0, 1}
	elseif Dmono.PlayerCount == 3 then
		Dmono.pIDs = {0, 1, 2}
	elseif Dmono.PlayerCount == 4 then
		Dmono.pIDs = {0, 1, 2, 3}
	end

	if Dmono.PlayerCount > 1 then
		Dmono:ShuffleQueue(Dmono.pIDs)
	else
		Dmono.TurnsQueue = {0}
	end
	Dmono:InsertNPC(npc)
	Dmono:HandleTurn()

	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.SectorStatusBought[i])
	-- end
	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.SectorRentTable[i])
	-- end
	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.SectorStatusUpgradeTable[i])
	-- end
	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.SectorUpgradePriceTable[i])
	-- end
	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.PriceSectorIndex[i])
	-- end
	-- print("-------------------------------------------------------------------")
	-- for i = 1, 28 do
	-- 	print(Dmono.SectorMortgageTable[i])
	-- end
	-- print("-------------------------------------------------------------------")
		
end

function Dmono:SendMoneyToOwner(teamID, cost)
    local playerCount = PlayerResource:GetPlayerCount()
    for i = 0, playerCount - 1 do
        local player = PlayerResource:GetPlayer(i)
        if player and player:GetTeam() == teamID then
            if player:GetAssignedHero() then -- Добавляем проверку на наличие героя у игрока
                player:GetAssignedHero():ModifyGold(cost, false, 0)
            end
        end
    end
end

function Dmono:GetPosForSector(pos)
	local index = 0
	if pos == Dmono:GetSectorPos(2) then
		index = 1
	elseif pos == Dmono:GetSectorPos(4) then
		index = 2
	elseif pos == Dmono:GetSectorPos(6) then
		index = 3
	elseif pos == Dmono:GetSectorPos(7) then
		index = 4
	elseif pos == Dmono:GetSectorPos(9) then
		index = 5
	elseif pos == Dmono:GetSectorPos(10) then
		index = 6
	elseif pos == Dmono:GetSectorPos(12) then
		index = 7
	elseif pos == Dmono:GetSectorPos(13) then
		index = 8
	elseif pos == Dmono:GetSectorPos(14) then
		index = 9
	elseif pos == Dmono:GetSectorPos(15) then
		index = 10
	elseif pos == Dmono:GetSectorPos(16) then
		index = 11
	elseif pos == Dmono:GetSectorPos(17) then
		index = 12
	elseif pos == Dmono:GetSectorPos(19) then
		index = 13
	elseif pos == Dmono:GetSectorPos(20) then
		index = 14
	elseif pos == Dmono:GetSectorPos(22) then
		index = 15
	elseif pos == Dmono:GetSectorPos(24) then
		index = 16
	elseif pos == Dmono:GetSectorPos(25) then
		index = 17
	elseif pos == Dmono:GetSectorPos(26) then
		index = 18
	elseif pos == Dmono:GetSectorPos(27) then
		index = 19
	elseif pos == Dmono:GetSectorPos(28) then
		index = 20
	elseif pos == Dmono:GetSectorPos(29) then
		index = 21
	elseif pos == Dmono:GetSectorPos(30) then
		index = 22
	elseif pos == Dmono:GetSectorPos(32) then
		index = 23
	elseif pos == Dmono:GetSectorPos(33) then
		index = 24
	elseif pos == Dmono:GetSectorPos(35) then
		index = 25
	elseif pos == Dmono:GetSectorPos(36) then
		index = 26
	elseif pos == Dmono:GetSectorPos(38) then
		index = 27
	elseif pos == Dmono:GetSectorPos(40) then
		index = 28
	end
	return index
end

function DressPayTaxer( unit )
	local weaponModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/bounty_hunter/gold_ripperbounty_hunter_weapon/gold_ripperbounty_hunter_weapon.vmdl",
		origin = unit:GetAbsOrigin(),
		scale = 1.0, 
	})
	weaponModel:SetParent(unit, "attach_attack1") 
	weaponModel:FollowEntity(unit, true) 

	local offhandModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/bounty_hunter/gold_ripperbounty_hunter_off_hand/gold_ripperbounty_hunter_off_hand.vmdl",
		origin = unit:GetAbsOrigin(),
		scale = 1.0, 
	})
	offhandModel:SetParent(unit, "attach_attack2") 
	offhandModel:FollowEntity(unit, true) 
	

	local headModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/bounty_hunter/hunternoname_head/hunternoname_head.vmdl",
		origin = unit:GetAbsOrigin(),
		scale = 1.0, 
	})
	headModel:SetParent(unit, "attach_head") 
	headModel:FollowEntity(unit, true) 


	local chestModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/bounty_hunter/old_man_gondar_armor/old_man_gondar_armor.vmdl",
		origin = unit:GetAbsOrigin(),
		scale = 1.0, 
	})
	chestModel:SetParent(unit, "attach_hitloc")
	chestModel:FollowEntity(unit, true)


	local backModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/bounty_hunter/old_man_gondar_back/old_man_gondar_back.vmdl",
		origin = unit:GetAbsOrigin(),
		scale = 1.0, 
	})
	backModel:SetParent(unit, "attach_hitloc")
	backModel:FollowEntity(unit, true)
	
end

function DressFurionSector( furion )
	local weaponModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_weapon/allfather_of_nature_weapon.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    weaponModel:SetParent(furion, "attach_attack1")
    weaponModel:FollowEntity(furion, true)

    local shoulderModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_shoulder/allfather_of_nature_shoulder.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    shoulderModel:SetParent(furion, "attach_shoulder")
    shoulderModel:FollowEntity(furion, true)

    local neckModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_neck/allfather_of_nature_neck.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    neckModel:SetParent(furion, "attach_neck")
    neckModel:FollowEntity(furion, true)

    local headModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_head/allfather_of_nature_head.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    headModel:SetParent(furion, "attach_head")
    headModel:FollowEntity(furion, true)

    local backModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_back/allfather_of_nature_back.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    backModel:SetParent(furion, "attach_back")
    backModel:FollowEntity(furion, true)

    local armsModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
        model = "models/items/furion/allfather_of_nature_arms/allfather_of_nature_arms.vmdl",
        origin = furion:GetAbsOrigin(),
        scale = 1.0,
    })
    armsModel:SetParent(furion, "attach_armsgloves")
    armsModel:FollowEntity(furion, true)
end

function DressTrentSector( trent )
	local armsModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/treant/halloweentree_arms/halloweentree_arms.vmdl",
		origin = trent:GetAbsOrigin(),
		scale = 1.0,
	})
	armsModel:SetParent(trent, "attach_attack1")
	armsModel:FollowEntity(trent, true)
	
	local headModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/treant/halloweentree_head/halloweentree_head.vmdl",
		origin = trent:GetAbsOrigin(),
		scale = 1.0,
	})
	headModel:SetParent(trent, "attach_head")
	headModel:FollowEntity(trent, true)
	
	local legsModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/treant/halloweentree_legs/halloweentree_legs.vmdl",
		origin = trent:GetAbsOrigin(),
		scale = 1.0,
	})
	legsModel:SetParent(trent, "attach_feet")
	legsModel:FollowEntity(trent, true)
	
	local shoulderModel = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/treant/halloweentree_shoulder/halloweentree_shoulder.vmdl",
		origin = trent:GetAbsOrigin(),
		scale = 1.0,
	})
	shoulderModel:SetParent(trent, "attach_attack2")
	shoulderModel:FollowEntity(trent, true)
end

function Dmono:FillSectorsTables(array, value)
	table.insert(array, value)
end

function DressMorphSector( morphling )
	local armsProp = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/morphling/abyss_overlord_arms/abyss_overlord_arms.vmdl",
		origin = morphling:GetAbsOrigin(),
		scale = 1.0,
	})
	armsProp:SetParent(morphling, "attach_attack1")
	armsProp:FollowEntity(morphling, true)
	
	local backProp = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/morphling/abyss_overlord_back/abyss_overlord_back.vmdl",
		origin = morphling:GetAbsOrigin(),
		scale = 1.0,
	})
	backProp:SetParent(morphling, "attach_back")
	backProp:FollowEntity(morphling, true)
	
	local headProp = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/morphling/abyss_overlord_head/abyss_overlord_head.vmdl",
		origin = morphling:GetAbsOrigin(),
		scale = 1.0,
	})
	headProp:SetParent(morphling, "attach_head")
	headProp:FollowEntity(morphling, true)
	
	local miscProp = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/morphling/abyss_overlord_misc/abyss_overlord_misc.vmdl",
		origin = morphling:GetAbsOrigin(),
		scale = 1.0,
	})
	miscProp:SetParent(morphling, "attach_misc")
	miscProp:FollowEntity(morphling, true)
	
	local shoulderProp = SpawnEntityFromTableSynchronous("prop_dynamic", {
		model = "models/items/morphling/abyss_overlord_shoulder/abyss_overlord_shoulder.vmdl",
		origin = morphling:GetAbsOrigin(),
		scale = 1.0,
	})
	shoulderProp:SetParent(morphling, "attach_shoulder")
	shoulderProp:FollowEntity(morphling, true)
end

function Dmono:OnPlaeyrChat(keys)
	return false
end	

function Dmono:InsertNPC( npc )
	table.insert(self.PlayerNPCs, npc)
end

function Dmono:SetPlayerCount( value )
	self.PlayerCount = value
end

function Dmono:GetCountPlayers()
	return self.PlayerCount
end

function Dmono:PrintNPC()
	for i = 1, Utilities:TableSize(self.PlayerNPCs) do
		print(tostring(self.PlayerNPCs[i]) .. ", ")
	end
end

function Dmono:GetValueFromNPC(index)
	return self.PlayerNPCs[index]
end


function Dmono:OnThink()
	Dmono:ParticleToSectors()
	return 1
end

function Dmono:ParticleToSectors()
	local sectorUnit
	local digitsCount

	for i = 1, 28 do
		if i == 3 then
			sectorUnit = Entities:FindByName(nil,("sector_station_1"))
		elseif i == 8 then
			sectorUnit = Entities:FindByName(nil,("sector_utility_1"))
			local particleShine = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, sectorUnit )
			ParticleManager:DestroyParticle(particleShine, false)
			ParticleManager:ReleaseParticleIndex(particleShine)
		elseif i == 11 then
			sectorUnit = Entities:FindByName(nil,("sector_station_2"))
		elseif i == 18 then
			sectorUnit = Entities:FindByName(nil,("sector_station_3"))
		elseif i == 21 then
			sectorUnit = Entities:FindByName(nil,("sector_utility_2"))
		elseif i == 26 then
			sectorUnit = Entities:FindByName(nil,("sector_station_4"))
		else
			sectorUnit = Entities:FindByName(nil,("sector_"..i))
		end

		local particle = ParticleManager:CreateParticle("particles/msg_fx/msg_goldbounty.vpcf", PATTACH_OVERHEAD_FOLLOW, sectorUnit )
		if Dmono:GetFromSectorStatusBought(i) > 0 then
			if i ~= 8 or i ~= 21 then
				digitsCount = string.len(tostring(Dmono.SectorRentTable[i]))
				ParticleManager:SetParticleControl(particle, 0, sectorUnit:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, Vector(0, Dmono.SectorRentTable[i], 0))
				ParticleManager:SetParticleControl(particle, 2, Vector(2.0, digitsCount, 0))
				ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
				ParticleManager:DestroyParticle(particle, false)
				ParticleManager:ReleaseParticleIndex(particle)
			end
		else
			digitsCount = string.len(tostring(Dmono.PriceSectorIndex[i]))
			ParticleManager:SetParticleControl(particle, 0, sectorUnit:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(0, Dmono.PriceSectorIndex[i], 0))
			ParticleManager:SetParticleControl(particle, 2, Vector(2.0, digitsCount, 0))
			ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end
	
end

function Dmono:HandleTurn()
	local QueueTurns = self.TurnsQueue[self.CurrentPlayerIndex] + 1
	local jailCondition = self.TurnsQueue[self.CurrentPlayerIndex]
	local playerHero = Dmono:GetValueFromNPC(QueueTurns)
	local prevIndex = QueueTurns - 1
	local prevPlayerHero = Dmono:GetValueFromNPC(prevIndex)
	if self.TurnFlag and prevPlayerHero == nil then
		prevPlayerHero = Dmono:GetValueFromNPC(self.PlayerCount)
		prevPlayerHero:AddNewModifier(nil, nil, "modifier_stunned", {duration = -1})
		prevPlayerHero:AddNewModifier(nil, nil, "modifier_silence", {duration = -1})
		self.TurnFlag = false
	end
	if Dmono:GetJailStatus(jailCondition) == 0 then
		playerHero:RemoveAbility("Jail_Roll")
		playerHero:RemoveAbility("Pay_Jail")
		playerHero:AddAbility("Pay_Jail"):SetLevel(1)
	end
	if playerHero ~= nil then
		playerHero:RemoveModifierByName("modifier_stunned")
		playerHero:RemoveModifierByName("modifier_silence")
	  else
		print("Player with ID 0 has no hero registered in the game.")
	end
	local timerHandle = Timers:CreateTimer("turn_timer", {
    	endTime = 45,
    	callback = function()
			playerHero:AddNewModifier(nil, nil, "modifier_stunned", {duration = -1})
			playerHero:AddNewModifier(nil, nil, "modifier_silence", {duration = -1})
			self.CurrentPlayerIndex = self.CurrentPlayerIndex + 1
			if self.PlayerCount < self.CurrentPlayerIndex then
				self.CurrentPlayerIndex = 1
			end
			Say(nil, "turn changed " .. QueueTurns .. " turn index " .. self.CurrentPlayerIndex .. " player count " .. self.PlayerCount, false)
			self:HandleTurn()
    	end
   	})
	self.currentTurnTimerHandle = timerHandle
end

function Dmono:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } 
	end
	return color
end

function Dmono:SetNewTurn()
	self.TurnFlag = true
	if self.currentTurnTimerHandle ~= nil then
		Timers:RemoveTimer(self.currentTurnTimerHandle)
	end
	self.CurrentPlayerIndex = self.CurrentPlayerIndex + 1
	if self.PlayerCount < self.CurrentPlayerIndex then
		self.CurrentPlayerIndex = 1
	end
	Say(nil, "turn changed", false)
	self:HandleTurn()
end

function Dmono:GetJailCoords()
	return self.JailCoords
end

function Dmono:GetSectorPos( index )
	return self.places[index]
end

function Dmono:MakeTeamWin(teamID)
	GameRules:SetGameWinner(teamID)
	return
end

function Dmono:MakeTeamLose(teamID)
	GameRules:MakeTeamLose(teamID)
	return
end

function Dmono:GetFakePos(playerID)
	return self.FakePos[playerID]
end

function Dmono:SetFakePos(playerID, pos)
	self.FakePos[playerID] = pos
end

function Dmono:IncrimentOfRolls()
	self.RollCount = self.RollCount + 1
end

function Dmono:IncrimentOfBoughts()
	self.BougntSectors = self.BougntSectors + 1
end

function Dmono:GetRollCount()
	return self.RollCount
end

function Dmono:GetBoughtSectors()
	return self.BougntSectors
end

function Dmono:InsertPlayerID(playerID)
    table.insert(self.pIDs, playerID)
end

function Dmono:InsertJail(playerID, amountOfTurns)
	self.JailTable[playerID] = amountOfTurns
end

function Dmono:GetJailStatus(playerID)
	return self.JailTable[playerID]
end

function Dmono:DecrementJailCount(playerID)
	self.JailTable[playerID] = self.JailTable[playerID] - 1
end

function Dmono:PrintID()
	for i = 1, Utilities:TableSize(self.pIDs) do 
		print(self.pIDs[i])
	end
	print("----------------------------" .. Utilities:TableSize(self.pIDs) .. " " .. Utilities:TableSize(self.TurnsQueue))
	for i = 1, Utilities:TableSize(self.TurnsQueue) do 
		print(self.TurnsQueue[i])
	end
end

function Dmono:ShuffleQueue(pIDTable)
	local shuffled = {}

    for i = 0, Utilities:TableSize(pIDTable)  do shuffled[i] = pIDTable[i] end

    for i = Utilities:TableSize(shuffled), 2, -1 do
        local j = RandomInt(1,i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
	
	for i = 0, Utilities:TableSize(shuffled) do self.TurnsQueue[i] = shuffled[i] end
end

-- ⠄⠂⠄⠐⠄⠄⠄⠄⠄⢀⣠⣶⣶⣿⣿⣿⣷⣶⣶⣤⣀⡀⠄⠄⠄⠄⠄⠄⠂⠄⠐⠄⠄⠂⠄⠐⠄
-- ⠄⠐⠈⠄⠄⠄⠄⣀⣴⣿⣿⣿⣿⣿⢿⣿⢿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠄⠄⠄⠄⠁⢀⠈⠄⠈⠄⡀
-- ⠐⠄⠄⠄⠄⢀⣴⣿⣿⡿⣿⢽⣾⣽⢿⣺⡯⣷⣻⣽⣻⣟⣿⣿⣿⣿⣦⡀⠄⠄⠄⠄⡀⠐⠈⠄⠄
-- ⠄⠄⠄⠄⢀⣾⣿⣿⢿⡽⡯⣿⢾⣟⣿⣳⢿⡽⣾⣺⣳⣻⣺⣽⣻⡿⣿⣿⣦⠄⠄⠄⠄⠄⠄⠄⠂
-- ⠄⠄⠄⠄⣿⣿⣿⣯⢿⣽⣻⣽⣿⣿⣯⣿⣿⣿⣷⣻⢮⣗⡯⣞⡾⡹⡵⣻⣿⣇⠄⠄⠄⠂⠄⠄⠠
-- ⠄⠄⠄⣸⣿⣿⣿⣿⡿⡾⣳⢿⢿⢿⠿⠿⠟⠟⠟⠿⣯⡾⣝⣗⣯⢪⢎⢗⣯⣿⣇⠄⠄⠄⠄⢀⠄
-- ⠄⠄⠄⠋⠉⠁⠑⠁⢉⣁⡁⠁⠁⠄⠄⠄⠄⠄⠄⠄⢉⢻⢽⣞⢾⣕⢕⢝⢎⣿⣿⡀⠄⠄⠄⠄⢀
-- ⠄⠄⠄⡧⠠⡀⠐⠂⣸⣿⢿⢔⢔⢤⢈⠡⡱⣩⢤⢴⣞⣾⣽⢾⣽⣺⡕⡕⡕⡽⣿⣿⠟⢶⠄⠄⠄
-- ⠄⠄⠄⣿⡳⡄⡢⡂⣿⣿⢯⣫⢗⣽⣳⡣⣗⢯⣟⣿⣿⢿⡽⣳⢗⡷⣻⡎⢎⢎⣿⡇⠻⣦⠃⠄⠄
-- ⠄⠄⠄⡿⡝⡜⣜⣬⣿⣿⣿⣷⣯⢺⠻⡻⣜⢔⠡⢓⢝⢕⢏⢗⢏⢯⡳⡝⡸⡸⣸⣧⡀⣹⣠⠄⠄
-- ⠄⠄⠄⣇⢪⢎⡧⡛⠛⠋⠋⠉⠙⣨⣮⣦⢅⡃⠇⡕⡌⡪⡨⢸⢨⢣⠫⡨⢪⢸⠰⣿⣇⣾⡞⠄⠄
-- ⠄⠄⠄⢑⡕⡵⡻⣕⠄⠄⠄⠔⡜⡗⡟⣟⢿⢮⢆⡑⢕⣕⢎⢮⡪⡎⡪⡐⢅⢇⢣⠹⡛⣿⡅⠄⠄
-- ⠄⠄⠄⢸⢎⠪⡊⣄⣰⣰⣵⣕⣮⣢⣳⡸⡨⠪⡨⠂⠄⠑⢏⠗⢍⠪⡢⢣⢃⠪⡂⣹⣽⣿⣷⡄⠄
-- ⠄⠄⠄⡸⠐⠝⠋⠃⠡⡕⠬⠎⠬⠩⠱⢙⣘⣑⣁⡈⠄⠄⡕⢌⢊⢪⠸⡘⡜⢌⠢⣸⣾⢿⣿⣿⡀
-- ⠄⠄⠄⡎⣐⠲⢒⢚⢛⢛⢛⢛⠛⠝⡋⡫⢉⠪⡱⠡⠄⠠⢣⢑⠱⡨⡊⡎⢜⢐⠅⢼⡾⣟⣿⣿⣷
-- ⠄⠄⣠⡃⡢⠨⢀⢂⢐⢐⢄⠑⠌⢌⢂⠢⠡⡑⡘⢌⠠⡘⡌⢎⠜⡌⢎⠜⡌⠢⠨⡸⣿⡽⣿⣿⣿
-- ⢴⠋⠁⡢⡑⡨⢐⢐⢌⠢⣂⢣⠩⡂⡢⡑⡑⡌⢜⠰⡨⢪⢘⠔⡱⢘⠔⡑⠨⢈⠐⢼⡷⣿⣻⢷⢯
-- ⠂⠄⠄⡢⡃⡢⢊⢔⢢⠣⡪⡢⢣⠪⡢⡑⡕⡜⡜⡌⢎⢢⠱⠨⡂⡑⠨⠄⠁⡂⡨⣺⡽⡯⡫⠣⠡
-- ⠄⠄⣰⡸⠐⠌⠆⢇⠎⡎⢎⢎⢎⢎⢎⢎⠎⡎⡪⠘⠌⠂⠁⠁⠄⢀⠄⢄⢢⢚⢮⢏⠞⡨⢂⠕⠉
-- ⡀⢀⡯⡃⡌⠈⠈⠄⠄⠈⠄⠄⠄⠄⠄⠂⠁⠄⠄⠄⠄⠄⠄⢄⢂⢢⢱⢱⢱⠱⢡⢑⠌⢂⠡⠠⠡
-- ⣀⡸⠨⢂⠌⡊⢄⢂⠠⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⠠⢐⢨⣘⢔⢵⠱⡃⡃⡕⡸⠐⡁⠌⡐⡨⠨⢊
-- ⢣⢎⠨⠄⠄⠨⢊⢪⢪⡫⡪⡊⡐⡐⡐⡌⡬⡪⡪⣎⢗⡕⡎⡣⠃⢅⠊⠆⠡⠠⡁⠢⡑⡐⢌⢌⠢
-- ⡎⡎⠄⠈⠄⠡⢂⠂⡕⡕⡕⠕⢌⢌⢢⢱⢸⡸⣪⢮⡣⡓⠌⠠⢑⠡⢈⠌⢌⢂⠪⠨⡂⣊⠢⡢⢣
-- ⢢⢣⠊⢀⠨⠨⢐⠐⡸⡸⡪⡱⡑⡌⡆⡇⡇⣏⢮⢪⢪⠊⠄⢑⢐⠨⡐⢌⠢⡪⡘⢌⠢⡢⢣⠪⠊
-- ⡣⡑⢅⠄⠄⠨⢐⠨⢰⢱⢣⢣⢪⢸⢨⡚⣞⢜⢎⢎⢎⠪⠐⠄⡆⡣⡪⡊⡪⡂⡪⡘⡌⡎⠊⠄⡐
-- ⡣⠊⠄⣷⣄⠄⠄⠌⢸⢸⠱⡱⡡⡣⡣⡳⡕⡇⡇⡇⠥⠑⠄⢡⢑⠕⢔⢑⠔⡌⡆⠇⠁⡀⠄⠁⠄
-- ⡊⠌⠄⣿⣿⣷⣤⣤⣂⣅⣑⠰⠨⠢⢑⣕⣜⣘⣨⣦⣥⣬⠄⢐⢅⢊⢢⢡⠣⠃⠄⡐⠠⠄⡂⠡⢈
-- ⢨⠨⠄⢹⢛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⠟⠄⢰⢰⢱⠑⠁⢀⠐⡀⠂⠄⠡⠐⠐⡀
-- ⡱⢐⠄⢸⡲⡠⠄⠉⠙⠻⠿⣿⠿⠿⢛⠫⡩⡳⣸⠾⠁⢀⢢⠣⠃⠄⠠⠐⡀⠂⠄⠡⠈⠄⡁⠂⠄
-- ⢌⠆⢕⠈⣗⢥⢣⢡⢑⢌⡢⡢⢅⢇⢇⢯⢾⡽⠃⢀⠔⡅⠁⠄⠄⠨⢀⠡⠐⠈⠄⠡⢈⠐⡀⠅⠌
-- ⠢⠭⢆⠦⡿⡷⡷⡵⡷⡷⣵⢽⡮⣷⢽⡽⡓⠤⠤⠕⡁⠠⠄⠅⠄⠅⠄⠂⠌⠠⠡⠈⠄⢂⠐⠠⠨