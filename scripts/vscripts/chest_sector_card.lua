Chest_Sector_Card = class({})

function Chest_Sector_Card:OnSpellStart()
    local caster = self:GetCaster()
	local pID = caster:GetPlayerID()
    local playerPos = Dmono:GetFakePos(pID)
	local randForChance = RandomInt(1, 16)
	Dmono.ChanceSectorScriptTable[randForChance](player)
	caster:RemoveAbility("Chest_Sector_Card")
	caster:RemoveAbility("Pay_Chest_Sector")
	caster:AddAbility("Roll"):SetLevel(1)
	if Dmono:GetChanceFlag() then
		return
	else
		Dmono:SetNewTurn()
	end
end