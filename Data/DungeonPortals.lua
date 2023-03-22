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

local function CreateDungeonTeleportData(spellID, expansion)
    local data = {}
    data.spellID = spellID
    data.expansion = expansion

    local name, _, icon = GetSpellInfo(spellID)
    data.name = name
    data.icon = icon
    data.isKnown = IsSpellKnown(spellID)
    return data
end

DungeonsTeleporters = {
    [131204] = CreateDungeonTeleportData(131204, "MoP"),
    [159899] = CreateDungeonTeleportData(159899, "WOD"),
    [159900] = CreateDungeonTeleportData(159900, "WOD"),
    [159896] = CreateDungeonTeleportData(159896, "WOD"),
    [373262] = CreateDungeonTeleportData(373262, "LEGION"),
    [393766] = CreateDungeonTeleportData(393766, "LEGION"),
    [393256] = CreateDungeonTeleportData(393256, "DF"),
    [393273] = CreateDungeonTeleportData(393273, "DF"),
    [373274] = CreateDungeonTeleportData(373274, "BFA"),
    [354462] = CreateDungeonTeleportData(354462, "SL"),
    [354463] = CreateDungeonTeleportData(354463, "SL"),
    [354464] = CreateDungeonTeleportData(354464, "SL"),
    [354465] = CreateDungeonTeleportData(354465, "SL"),
    [354466] = CreateDungeonTeleportData(354466, "SL"),
    [354467] = CreateDungeonTeleportData(354467, "SL"),
    [354468] = CreateDungeonTeleportData(354468, "SL"),
    [354469] = CreateDungeonTeleportData(354469, "SL"),
    [367416] = CreateDungeonTeleportData(367416, "SL"),

}

for key, value in pairs(DungeonsTeleporters) do
    data.EveryTeleporter[key] = value
    data.DungeonTeleporters[key] = value
end