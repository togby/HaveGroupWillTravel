local addonName, addon = ...

addon.data = {}


local data = {}
data.EveryTeleporter = {}
data.DungeonTeleporters = {}



addon.data.DungeonTeleportersByExpansion = function()
    local teleportersByExpansion = {}

    for _, value in pairs(data.DungeonTeleporters) do
        teleportersByExpansion[value.expansion] = teleportersByExpansion[value.expansion] or {}
        table.insert(teleportersByExpansion[value.expansion], value)
    end

    return teleportersByExpansion
end

local function CreateDungeonTeleportData(spellID, expansion, dungeonName)
    local data = {}
    data.spellID = spellID
    data.expansion = expansion
    data.dungeonName = dungeonName

    local name, _, icon = GetSpellInfo(spellID)
    data.name = name
    data.icon = icon
    data.isKnown = IsSpellKnown(spellID)
    return data
end

DungeonsTeleporters = {
    [131204] = CreateDungeonTeleportData(131204, "MOP",     "Temple of the Jade Serpent"),
    [159899] = CreateDungeonTeleportData(159899, "WOD",     "Shadowmoon Burial Grounds"),
    [159900] = CreateDungeonTeleportData(159900, "WOD",     "Grimrail Depot"),
    [159896] = CreateDungeonTeleportData(159896, "WOD",     "Iron Docks"),
    [373262] = CreateDungeonTeleportData(373262, "LEGION",  "Karazhan"),
    [393766] = CreateDungeonTeleportData(393766, "LEGION",  "Court of Stars"),
    [393256] = CreateDungeonTeleportData(393256, "DF",      "Ruby Life Pools"),
    [393273] = CreateDungeonTeleportData(393273, "DF",      "Algeth'ar Academy"),
    [373274] = CreateDungeonTeleportData(373274, "BFA",     "Operation: Mechagon"),
    [354462] = CreateDungeonTeleportData(354462, "SL",      "The Necrotic Wake"),
    [354463] = CreateDungeonTeleportData(354463, "SL",      "Plaguefall"),
    [354464] = CreateDungeonTeleportData(354464, "SL",      "Mists of Tirna Scithe"),
    [354465] = CreateDungeonTeleportData(354465, "SL",      "Halls of Atonement"),
    [354466] = CreateDungeonTeleportData(354466, "SL",      "Spires of Ascension"),
    [354467] = CreateDungeonTeleportData(354467, "SL",      "Theater of Pain"),
    [354468] = CreateDungeonTeleportData(354468, "SL",      "De Other Side"),
    [354469] = CreateDungeonTeleportData(354469, "SL",      "Sanguine Depths"),
    [367416] = CreateDungeonTeleportData(367416, "SL",      "Tazavesh, the Veiled Market"),
    [2061] = CreateDungeonTeleportData(2061, "TEST",        "Hearthstone"),
}

for key, value in pairs(DungeonsTeleporters) do
    data.EveryTeleporter[key] = value
    data.DungeonTeleporters[key] = value
end