require('libraries/timers')
None = class({}) 

function None:OnSpellStart()
	local caster = self:GetCaster()
	caster:RemoveAbility("Buy")
	caster:RemoveAbility("None")
	caster:AddAbility("Roll"):SetLevel(1);
	Dmono:SetNewTurn()
end