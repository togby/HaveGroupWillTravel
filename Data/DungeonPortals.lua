local addonName, addon = ...

addon.data = {}


local data = {}
data.EveryTeleporter = {}
data.DungeonTeleporters = {}

local currentSeason = {
    [354462] = true, -- The Necrotic Wake
    [354464] = true, -- Mists of Tirna Scithe
    --[] = true, -- 
    --[] = true, -- 
    --[] = true, -- 
    --[] = true, -- 
    --[] = true, -- 
    --[] = true, -- 
}
addon:RegisterCallback("AddonLoaded", function ()
    C_Timer.After(10, function ()
        for _, value in pairs(data.EveryTeleporter) do
            value.isKnown = IsSpellKnown(value.spellId)

            value.button:ChangeIsKnown()
        end
    end)

    C_Timer.NewTicker(5, function ()
        for _, value in pairs(data.EveryTeleporter) do
            value.button.cooldown:UpdateFunction()
        end
    end)
 
end)

addon.data.DungeonTeleportersByExpansion = function()
    local teleportersByExpansion = {}
    teleportersByExpansion["CurrentSeason"] = {}

    for _, value in pairs(data.DungeonTeleporters) do
        if currentSeason[value.spellId] then
            table.insert(teleportersByExpansion["CurrentSeason"], value)
        else
            teleportersByExpansion[value.expansion] = teleportersByExpansion[value.expansion] or {}
            table.insert(teleportersByExpansion[value.expansion], value)
        end
    end
    return teleportersByExpansion
end

DungeonsTeleporters = {}
local function CreateDungeonTeleportData(spellId, expansion, dungeonFullName, dungeonShortName)
    local data = {}
    data.spellId = spellId
    data.expansion = expansion
    data.fullName = dungeonFullName
    data.shortName = dungeonShortName

    data.name = C_Spell.GetSpellName(spellId)
    data.icon = C_Spell.GetSpellTexture(spellId)
    data.isKnown = IsSpellKnown(spellId)

    DungeonsTeleporters[spellId] = data
    return data
end

CreateDungeonTeleportData(410080, "CATA",    "Vortex Pinnacle",                  "VP")
CreateDungeonTeleportData(424142, "CATA",    "Throne of the Tides",              "TotT")
CreateDungeonTeleportData(131204, "MOP",     "Temple of the Jade Serpent",       "TotJS")
CreateDungeonTeleportData(159899, "WOD",     "Shadowmoon Burial Grounds",        "SBG")
CreateDungeonTeleportData(159900, "WOD",     "Grimrail Depot",                   "DG")
CreateDungeonTeleportData(159896, "WOD",     "Iron Docks",                       "ID")
CreateDungeonTeleportData(159901, "WOD",     "The Everbloom",                    "EB")
CreateDungeonTeleportData(373262, "LEGION",  "Karazhan",                         "KZ")
CreateDungeonTeleportData(393766, "LEGION",  "Court of Stars",                   "CoS")
CreateDungeonTeleportData(393764, "LEGION",  "Halls of Valor",                   "HoV")
CreateDungeonTeleportData(410078, "LEGION",  "Neltharion's Lair",                "NL")
CreateDungeonTeleportData(424153, "LEGION",  "Black Rook Hold",                  "BRH")
CreateDungeonTeleportData(424163, "LEGION",  "Darkheart Thicket",                "DT")
CreateDungeonTeleportData(373274, "BFA",     "Operation: Mechagon",              "O:M")
CreateDungeonTeleportData(410071, "BFA",     "Feehold",                          "FH")
CreateDungeonTeleportData(410074, "BFA",     "Underrot",                         "UR")
CreateDungeonTeleportData(424187, "BFA",     "Atal'Dazar",                       "A'D")
CreateDungeonTeleportData(424167, "BFA",     "Waycrest Manor",                   "WM")
CreateDungeonTeleportData(354462, "SL",      "The Necrotic Wake",                "tNW")
CreateDungeonTeleportData(354463, "SL",      "Plaguefall",                       "PF")
CreateDungeonTeleportData(354464, "SL",      "Mists of Tirna Scithe",            "MoTS")
CreateDungeonTeleportData(354465, "SL",      "Halls of Atonement",               "HoA")
CreateDungeonTeleportData(354466, "SL",      "Spires of Ascension",              "SoA")
CreateDungeonTeleportData(354467, "SL",      "Theater of Pain",                  "ToP")
CreateDungeonTeleportData(354468, "SL",      "De Other Side",                    "DOS")
CreateDungeonTeleportData(354469, "SL",      "Sanguine Depths",                  "SD")
CreateDungeonTeleportData(367416, "SL",      "Tazavesh, the Veiled Market",      "Ttvm")
CreateDungeonTeleportData(393256, "DF",      "Ruby Life Pools",                  "RLP")
CreateDungeonTeleportData(393273, "DF",      "Algeth'ar Academy",                "AA")
CreateDungeonTeleportData(393279, "DF",      "The Azure Vault",                  "TAV")
CreateDungeonTeleportData(393262, "DF",      "The Nokhud Offensive",             "TNO")
CreateDungeonTeleportData(393267, "DF",      "Brackenhide Hollow",               "BH")
CreateDungeonTeleportData(393283, "DF",      "Halls of Infusion",                "HoI")
CreateDungeonTeleportData(393276, "DF",      "Neltharus",                        "N")
CreateDungeonTeleportData(393222, "DF",      "Uldaman: Legacy of Tyr",           "ULoT")
CreateDungeonTeleportData(424197, "DF",      "Dawn of the Infinite",             "DotI")


for key, value in pairs(DungeonsTeleporters) do
    data.EveryTeleporter[key] = value
    data.DungeonTeleporters[key] = value
end