Chest_Sector_Card = class({})

function Chest_Sector_Card:OnSpellStart()
    local caster = self:GetCaster()
	local pID = caster:GetPlayerID()
    Dmono:SetNewTurn()
end