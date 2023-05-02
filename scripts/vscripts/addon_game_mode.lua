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
	Dmono.FakePos = Vector(0,0,0)
	Dmono.TeamSectorValues = {}
	Dmono.pIDs = {}
	Dmono.TurnsQueue = {}
	Dmono.PlayerNPCs = {}
	Dmono.CurrentPlayerIndex = 1


	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange

	Dmono.priceSectorIndex = {}
	self.priceSectorIndex[1] = 60
	self.priceSectorIndex[3] = 60
	self.priceSectorIndex[5] = 200
	self.priceSectorIndex[6] = 100
	self.priceSectorIndex[8] = 100
	self.priceSectorIndex[9] = 120
	self.priceSectorIndex[10] = 140
	self.priceSectorIndex[12] = 140
	self.priceSectorIndex[13] = 160
	self.priceSectorIndex[14] = 200
	self.priceSectorIndex[15] = 180
	self.priceSectorIndex[17] = 180
	self.priceSectorIndex[18] = 200
	self.priceSectorIndex[19] = 220
	self.priceSectorIndex[21] = 220
	self.priceSectorIndex[22] = 240
	self.priceSectorIndex[23] = 200
	self.priceSectorIndex[24] = 260
	self.priceSectorIndex[25] = 260
	self.priceSectorIndex[27] = 280
	self.priceSectorIndex[28] = 300
	self.priceSectorIndex[29] = 300
	self.priceSectorIndex[31] = 320
	self.priceSectorIndex[32] = 200
	self.priceSectorIndex[34] = 350
	self.priceSectorIndex[36] = 400
	
	Dmono.places = {
		Vector(-1732.92, -1565.54, 186),
		Vector(-1575.39, -1129.84, 186),
		Vector(-1575.39, -839.384, 186),
		Vector(-1575.39, -548.923, 186),
		Vector(-1575.39, -258.462, 186),
		Vector(-1575.39, 32.0001, 186),
		Vector(-1575.39, 322.462, 186),
		Vector(-1575.39, 612.923, 186),
		Vector(-1575.39, 903.385, 186),
		Vector(-1575.39, 1193.85, 186),
		Vector(-1732.92, 1629.54, 186),
		Vector(-1260.31, 1484.31, 186),
		Vector(-945.231, 1484.31, 186),
		Vector(-630.154, 1484.31, 186),
		Vector(-315.077, 1484.31, 186),
		Vector(-0.000305176, 1484.31, 186),
		Vector(315.077, 1484.31, 186),
		Vector(630.154, 1484.31, 186),
		Vector(945.231, 1484.31, 186),
		Vector(1260.31, 1484.31, 186),
		Vector(1732.92, 1629.54, 186),
		Vector(1575.38, 1193.85, 186),
		Vector(1575.38, 903.385, 186),
		Vector(1575.38, 612.923, 186),
		Vector(1575.38, 322.462, 186),
		Vector(1575.38, 32.0001, 186),
		Vector(1575.38, -258.462, 186),
		Vector(1575.38, -548.923, 186),
		Vector(1575.38, -839.384, 186),
		Vector(1575.38, -1129.85, 186),
		Vector(1732.92, -1565.54, 186),
		Vector(1260.31, -1420.31, 186),
		Vector(945.231, -1420.31, 186),
		Vector(630.154, -1420.31, 186),
		Vector(315.077, -1420.31, 186),
		Vector(-0.000305176, -1420.31, 186),
		Vector(-315.077, -1420.31, 186),
		Vector(-630.154, -1420.31, 186),
		Vector(-945.231, -1420.31, 186),
		Vector(-1260.31, -1420.31, 186)
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
	GameRules:SetStartingGold(1000)
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
    if npc:IsRealHero() then
      local duration = 2
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
	return 1
end

function Dmono:HandleTurn()
	local QueueTurns = self.TurnsQueue[self.CurrentPlayerIndex] + 1
	local playerHero = Dmono:GetValueFromNPC(QueueTurns)
	if playerHero ~= nil then
		playerHero:RemoveModifierByName("modifier_stunned")
		playerHero:RemoveModifierByName("modifier_silence")
		print("turn" ..QueueTurns)
	  else
		print("turn" .. QueueTurns)
		print("Player with ID 0 has no hero registered in the game.")
	end
    Timers:CreateTimer("turn_timer", {
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
end

function Dmono:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } 
	end
	return color
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

function Dmono:GetFakePos()
	return self.FakePos
end

function Dmono:SetFakePos(pos)
	self.FakePos = pos
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