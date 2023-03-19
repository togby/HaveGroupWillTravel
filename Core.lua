local addonName, addon = ...




local isInCombat = false

addon:SetupFrames()

function addon:IsInCombat()
	return isInCombat
end