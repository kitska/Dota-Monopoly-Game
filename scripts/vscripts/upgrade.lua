LinkLuaModifier("upgrade_modifier", "modifiers/upgrade_modifier.lua", LUA_MODIFIER_MOTION_NONE)
Upgrade = class({})


function Upgrade:OnSpellStart()
    local caster = self:GetCaster()
    local pID = caster:GetPlayerID()
    local teamID = PlayerResource:GetTeam(pID)
    local target = self:GetCursorTarget()
    local sectorIndex = 0
    local cost = 0
    local updateCost = 0
    if target ~= nil then 
        local targetName = target:GetName()
        local targetNameLength = string.len(targetName)
        if targetNameLength <= 9 then
            sectorIndex = tonumber(string.match(targetName, "%d+"))
            cost = Dmono:GetFromSectorUpgradePriceTable(sectorIndex)
            updateCost = Dmono:GetFromBaseUpgrade(sectorIndex)
        end
        if Dmono:GetFromSectorStatusBought(sectorIndex) == teamID then
            if Dmono:CheckStreetCondition(teamID) then
                if Dmono:GetFromSectorStatusUpgradeTable(sectorIndex) == "NoUpgrade" then
                    Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "Upgrade1")
                    Dmono:UpdateFromSectorRentTable(sectorIndex, Dmono:GetFromUpgrade1RentCost(sectorIndex))
                elseif Dmono:GetFromSectorStatusUpgradeTable(sectorIndex) == "Upgrade1" then
                    Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "Upgrade2")
                    Dmono:UpdateFromSectorRentTable(sectorIndex, Dmono:GetFromUpgrade2RentCost(sectorIndex))
                elseif Dmono:GetFromSectorStatusUpgradeTable(sectorIndex) == "Upgrade2" then
                    Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "Upgrade3")
                    Dmono:UpdateFromSectorRentTable(sectorIndex, Dmono:GetFromUpgrade3RentCost(sectorIndex))
                elseif Dmono:GetFromSectorStatusUpgradeTable(sectorIndex) == "Upgrade3" then
                    Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "Upgrade4")
                    Dmono:UpdateFromSectorRentTable(sectorIndex, Dmono:GetFromUpgrade4RentCost(sectorIndex))
                elseif Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "Upgrade4") then
                    Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "FinalUpgrade")
                    Dmono:UpdateFromSectorRentTable(sectorIndex, Dmono:GetFromUpgradeFinaleRentCost(sectorIndex))
                elseif Dmono:UpdateFromSectorStatusUpgradeTable(sectorIndex, "FinalUpgrade") then
                    return 1
                end
                if caster:GetGold() > Dmono:GetFromSectorUpgradePriceTable(sectorIndex) then 
                    caster:ModifyGold(Dmono:GetFromSectorUpgradePriceTable(sectorIndex) * -1, false, 0)
                    Dmono:UpdateFromSectorUpgradePriceTable(sectorIndex, (cost + updateCost))
                end
            else
                Say(caster,"You have no access to this street", false)
            end
        else
            Say(caster,"You have no access to this sector", false)
        end
    end
end

