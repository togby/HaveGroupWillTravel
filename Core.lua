local addonName, addon = ...

HaveGroupWillTravelDB = HaveGroupWillTravelDB or {}

addon:SetupFrames()


SLASH_HaveGroupWillTravel1 = "/hgwt"
SLASH_HaveGroupWillTravel2 = "/HaveGroupWillTravel"
SlashCmdList["HaveGroupWillTravel"] = function(msg)
   addon:ToggleWindow("TeleportWindowFrame")
end
