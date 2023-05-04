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

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange

	Dmono.priceSectorIndex = {}
	self.priceSectorIndex[1] = 60
	self.priceSectorIndex[2] = 60
	self.priceSectorIndex[3] = 200
	self.priceSectorIndex[4] = 100
	self.priceSectorIndex[5] = 100
	self.priceSectorIndex[6] = 120
	self.priceSectorIndex[7] = 140
	self.priceSectorIndex[8] = 140
	self.priceSectorIndex[9] = 160
	self.priceSectorIndex[10] = 200
	self.priceSectorIndex[11] = 180
	self.priceSectorIndex[12] = 180
	self.priceSectorIndex[13] = 200
	self.priceSectorIndex[14] = 220
	self.priceSectorIndex[15] = 220
	self.priceSectorIndex[16] = 240
	self.priceSectorIndex[17] = 200
	self.priceSectorIndex[18] = 260
	self.priceSectorIndex[19] = 260
	self.priceSectorIndex[20] = 280
	self.priceSectorIndex[21] = 300
	self.priceSectorIndex[22] = 300
	self.priceSectorIndex[23] = 320
	self.priceSectorIndex[24] = 200
	self.priceSectorIndex[25] = 350
	self.priceSectorIndex[26] = 400
	
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

	ListenToGameEvent('npc_spawned', OnNPCSpawned, nil)

	local unit
	for i = 1, 4 do
		unit = Entities:FindByName(nil,("pay_tax_entity_"..i))
		DressPayTaxer(unit)
	end

	local furion = Entities:FindByName(nil,("sector_15"))
	local trent = Entities:FindByName(nil,("sector_16"))
	DressFurionSector(furion)
	DressTrentSector(trent)
	
end

function OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)

	
	if npc:GetClassname() == "npc_dota_creature" then
		npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
	end
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
	Dmono:PrintNPC()
	Dmono:PrintID()
	print(Dmono:GetCountPlayers() .. " count")
	Dmono:HandleTurn()
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

	for i = 1, 26 do
		if i == 3 then
			sectorUnit = Entities:FindByName(nil,("sector_station_1"))
		elseif i == 10 then
			sectorUnit = Entities:FindByName(nil,("sector_station_2"))
		elseif i == 17 then
			sectorUnit = Entities:FindByName(nil,("sector_station_3"))
		elseif i == 24 then
			sectorUnit = Entities:FindByName(nil,("sector_station_4"))
		else
			sectorUnit = Entities:FindByName(nil,("sector_"..i))
		end
		digitsCount = string.len(tostring(Dmono.priceSectorIndex[i]))
		local particle = ParticleManager:CreateParticle("particles/msg_fx/msg_goldbounty.vpcf", PATTACH_OVERHEAD_FOLLOW, sectorUnit )
		ParticleManager:SetParticleControl(particle, 0, sectorUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(0, Dmono.priceSectorIndex[i], 0))
		ParticleManager:SetParticleControl(particle, 2, Vector(2.0, digitsCount, 0))
		ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
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
		print("turn flag activated")
	end
	print(Dmono:GetJailStatus(jailCondition))
	if Dmono:GetJailStatus(jailCondition) == 0 then
		playerHero:RemoveAbility("Jail_Roll")
	end
	if playerHero ~= nil then
		playerHero:RemoveModifierByName("modifier_stunned")
		playerHero:RemoveModifierByName("modifier_silence")
		print("turn" ..QueueTurns)
	  else
		print("turn" .. QueueTurns)
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

function Dmono:PutInJail(CurrentPlayerIndex)
	self.JailTable[CurrentPlayerIndex] = true
end

function Dmono:GetJailCoords()
	return self.JailCoords
end

function Dmono:GetSectorPos( index )
	return self.places[index]
end

function Dmono:SetDictionaryKeyValue( key, value )
	self.priceSectorIndex[key] = value
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