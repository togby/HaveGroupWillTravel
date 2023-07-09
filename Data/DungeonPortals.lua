local addonName, addon = ...

addon.data = {}


local data = {}
data.EveryTeleporter = {}
data.DungeonTeleporters = {}

local currentSeason = {
    [393267] = true, -- Brackenhide Hollow
    [410071] = true, -- Freehold
    [410080] = true, -- The Vortex Pinnacle
    [410078] = true, -- Neltharion's Lair
    [410074] = true, -- The Underrot
}

addon:RegisterCallback("AddonLoaded", function ()
    C_Timer.After(10, function ()
        for key, value in pairs(data.EveryTeleporter) do
            value.isKnown = IsSpellKnown(value.spellID)

            value.button:ChangeIsKnown()
        end
    end)
end)

addon.data.DungeonTeleportersByExpansion = function()
    local teleportersByExpansion = {}
    teleportersByExpansion["CurrentSeason"] = {}

    for _, value in pairs(data.DungeonTeleporters) do
        teleportersByExpansion[value.expansion] = teleportersByExpansion[value.expansion] or {}
        if currentSeason[value.spellID] then
            table.insert(teleportersByExpansion["CurrentSeason"], value)
        else
            table.insert(teleportersByExpansion[value.expansion], value)
        end
    end
    return teleportersByExpansion
end

DungeonsTeleporters = {}
local function CreateDungeonTeleportData(spellID, expansion, dungeonFullName, dungeonShortName)
    local data = {}
    data.spellID = spellID
    data.expansion = expansion
    data.fullName = dungeonFullName
    data.shortName = dungeonShortName

    local name, _, icon = GetSpellInfo(spellID)
    data.name = name
    data.icon = icon
    data.isKnown = IsSpellKnown(spellID)

    DungeonsTeleporters[spellID] = data
    return data
end

CreateDungeonTeleportData(410080, "Cata",    "The Vortex Pinnacle",             "tVP")
CreateDungeonTeleportData(131204, "MOP",     "Temple of the Jade Serpent",       "TotJS")
CreateDungeonTeleportData(159899, "WOD",     "Shadowmoon Burial Grounds",        "SBG")
CreateDungeonTeleportData(159900, "WOD",     "Grimrail Depot",                   "DG")
CreateDungeonTeleportData(159896, "WOD",     "Iron Docks",                       "ID")
CreateDungeonTeleportData(373262, "LEGION",  "Karazhan",                         "KZ")
CreateDungeonTeleportData(393766, "LEGION",  "Court of Stars",                   "CoS")
CreateDungeonTeleportData(410078, "LEGION",  "Neltharion's Lair",                "NL")
CreateDungeonTeleportData(393256, "DF",      "Ruby Life Pools",                  "RLP")
CreateDungeonTeleportData(393273, "DF",      "Algeth'ar Academy",                "AA")
CreateDungeonTeleportData(393279, "DF",      "The Azure Vault",                  "TAV")
CreateDungeonTeleportData(393262, "DF",      "The Nokhud Offensive",             "TNO")
CreateDungeonTeleportData(393267, "DF",      "Brackenhide Hollow",               "BH")
CreateDungeonTeleportData(373274, "BFA",     "Operation: Mechagon",              "O:M")
CreateDungeonTeleportData(410071, "BFA",     "Freehold",                         "FH")
CreateDungeonTeleportData(410074, "BFA",     "The Underrot",                     "tUR")
CreateDungeonTeleportData(354462, "SL",      "The Necrotic Wake",                "tNW")
CreateDungeonTeleportData(354463, "SL",      "Plaguefall",                       "PF")
CreateDungeonTeleportData(354464, "SL",      "Mists of Tirna Scithe",            "MoTS")
CreateDungeonTeleportData(354465, "SL",      "Halls of Atonement",               "HoA")
CreateDungeonTeleportData(354466, "SL",      "Spires of Ascension",              "SoA")
CreateDungeonTeleportData(354467, "SL",      "Theater of Pain",                  "ToP")
CreateDungeonTeleportData(354468, "SL",      "De Other Side",                    "DOS")
CreateDungeonTeleportData(354469, "SL",      "Sanguine Depths",                  "SD")
CreateDungeonTeleportData(367416, "SL",      "Tazavesh, the Veiled Market",      "Ttvm")
CreateDungeonTeleportData(2061,   "TEST",    "Hearthstone",                      "HTEST")

for key, value in pairs(DungeonsTeleporters) do
    data.EveryTeleporter[key] = value
    data.DungeonTeleporters[key] = value
end