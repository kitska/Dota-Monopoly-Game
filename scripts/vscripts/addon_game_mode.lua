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
	self.nCurrentTurn = 0 
	self.nHousesInBank = 40 
	self.nComboThrow = 0 
	self.nPreviousTurn = -1

	self.vNextPos = {}
	self.vCurrentPos = {} 
	self.vPlayerIDs = {} 
	self.vUserIDs = {} 
	self.vModelName = {} 
	self.vPlayerOwnership = {} 
	self.vHeroIndex = {} 
	self.vPlayersInJail = {}
	self.vRoundsInJail = {} 
	self.vLastDiceThrown = {} 
	self.vPlayersInGame = {} 

	Dmono.RollCount = 0
	Dmono.BougntSectors = 0
	Dmono.FakePos = Vector(0,0,0)
	Dmono.TeamSectorValues = {}

	self.bStartTimer = false

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
<<<<<<< HEAD
<<<<<<< HEAD
	
=======

>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
=======

>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
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
	GameMode:SetTopBarTeamValuesVisible(true)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetBuybackEnabled(false)
	GameMode:SetCustomGameForceHero("npc_dota_hero_weaver")

	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)

	ListenToGameEvent('npc_spawned', OnNPCSpawned, nil)
<<<<<<< HEAD
	local unit
	for i = 1, 4 do
		unit = Entities:FindByName(nil,("pay_tax_entity_"..i))
		DressPayTaxer(unit)
	end
=======
>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
end

function OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)
    if npc:IsRealHero() then
      local duration = 2
      local modifier = npc:AddNewModifier(nil, nil, "modifier_stunned", {duration = duration})
	  local modifier2 = npc:AddNewModifier(nil, nil, "modifier_silence", {duration = duration})
    end
end

<<<<<<< HEAD
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
end

=======
>>>>>>> a6fe26846f2a24476fe9c9295bce4c47b2c31eae
function Dmono:OnPlaeyrChat(keys)
	return false
end	

function Dmono:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		if Utilities:GetTimer() == nil then
			Utilities:SetTimer("Pre-Game Timer", 1)
		end

	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		Dmono:CheckGamePause()

		if self.bStartTimer == true then
			Utilities:CountdownTimer()
			Dmono:CheckPlayerTurn()
		end
		elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function Dmono:GetNextHero()
    local hero = nil
    local lastHero = self.lastHero or nil
    for _, playerID in ipairs(self.playerIDs) do
        local player = PlayerResource:GetPlayer(playerID)
        if player then
            local heroList = player:GetAssignedHero()
            for _, h in ipairs(heroList) do
                if h ~= lastHero then
                    hero = h
                    break
                end
            end
        end
        if hero then
            break
        end
    end
    self.lastHero = hero
    return hero
end

function Dmono:OnPlayerPickHero(keys)
	print("--OnPlayerPickHero called!--")

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()
	local team = player:GetTeamNumber()

	-- push into tables
	self.vUserIDs[playerID] = keys.player
	self.vPlayerIDs[keys.player] = playerID
	self.vCurrentPos[playerID] = 0
	self.vNextPos[playerID] = 0
	self.vHeroIndex[playerID] = hero
	self.vPlayersInGame[playerID] = 1
end

function Dmono:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } 
	end
	return color
end

function Dmono:CheckSectorStatus(sector)
	return true
end

function Dmono:GetHeroEntity(pID)
	return self.vHeroIndex[pID]
end

function Dmono:GetCurrentTurn()
	return self.nCurrentTurn
end

function Dmono:GetCurrentPos(pID)
	return self.vCurrentPos[pID]
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

function Dmono:SetCurrentPos(nPos, pID)
	print("PlayerID ",pID, "set to position",nPos)
	self.vCurrentPos[pID] = nPos
end

function Dmono:GetAllPlayersID(pID)
	local playerIDs = {}

	for k,v in pairs(pID) do
		table.insert(playerIDs,v)
	end
	return playerIDs
end

function Dmono:CheckGamePause()
	if GameRules:IsGamePaused() == true then
		self.bStartTimer = false
	end

	if GameRules:IsGamePaused() == false then
		self.bStartTimer = true
	end

end

function Dmono:SetPlayerToJail(pID)
	self.vPlayersInJail[pID+1] = pID
	self.vRoundsInJail[pID+1] = 0
end

function Dmono:RemovePlayerFromJail(pID)
	table.remove(self.vPlayersInJail, pID+1)
	table.remove(self.vRoundsInJail, pID+1)
end

function Dmono:GetRoundsInJail(pID)
	return self.vRoundsInJail[pID+1]
end

function Dmono:IncreaseRoundsInJail(pID)
	self.vRoundsInJail[pID+1] = self.vRoundsInJail[pID+1] + 1
end

function Dmono:SetPreviousTurn(pID)
	self.nPreviousTurn = pID
end

function Dmono:GetPreviousTurn()
	return self.nPreviousTurn
end

function Dmono:SetNextPlayerTurn()
	local curTurn = self.nCurrentTurn
	local firstPlayer = -1 -- pID of the first player if everybody finished the round

	-- Check who is going to be the first player
	local i = 1
	for k,v in pairs(self.vPlayerIDs) do
		if self.vCurrentPos[i-1] ~= -1 then
			firstPlayer = i - 1
			break
		end
		i = i + 1
	end

	local i = self.nCurrentTurn
	for k,v in pairs(self.vPlayerIDs) do
		-- Table size has been reached, start from the first player that is in the game
		if self.nCurrentTurn + 1 > Utilities:TableSize(self.vPlayerIDs) - 1 then
			self.nCurrentTurn = firstPlayer
			return
		elseif self.vCurrentPos[i + 1] ~= -1 then
			self.nCurrentTurn = i + 1
			return
		end
		i = i + 1
	end

end

function Dmono:NextPlayerTurn()
	if Utilities:GetTimer() > 0 then
		Utilities:SetTimer("Next Player", 0)
	end
end
