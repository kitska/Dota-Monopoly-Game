Pay_tax = class({})

function Pay_tax:GetIntrinsicModifierName()
    return "modifier_pay_tax"
end
    
modifier_pay_tax = class({})
    
function modifier_pay_tax:IsHidden()
    return true
end
    
function modifier_pay_tax:IsPurgable()
    return false
end
    
function modifier_pay_tax:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
    
function modifier_pay_tax:OnAttackLanded( params )
    if IsServer() then
        if params.attacker == self:GetParent() then
        local target = params.target
        local goldToSteal = 200
        -- Check if target has enough gold
         if target and target:IsRealHero() and target:GetGold() >= goldToSteal then
            target:SpendGold(goldToSteal, DOTA_ModifyGold_Unspecified)
            self:GetCaster():ModifyGold(goldToSteal, true, DOTA_ModifyGold_Unspecified)
    
            -- Display gold steal message
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, target, goldToSteal, nil)
    
            EmitSoundOn("Item.MoonShard.Consume", target)
            end
        end
    end
end