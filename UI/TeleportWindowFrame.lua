local addonName, addon = ...


addon.UIWindows.TeleportWindowFrame = {}
local window = addon.UIWindows.TeleportWindowFrame

local mainFrame

local size = 50

-- All currently known(by Oskar) dungeon teleporter ID's
-- Tables automitically sort tables by key value, so below is not how they will generate in game
local dungeonsByExpansion = addon.data.DungeonTeleportersByExpansion()


function window:SetupWindow()
    local frame, button, fs -- temps used below
	-- main frame
	mainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    mainFrame:Hide()
    mainFrame:SetMouseClickEnabled()
	mainFrame:SetMouseMotionEnabled()
	mainFrame:SetFrameStrata("MEDIUM")
	mainFrame:SetMovable(true)
	mainFrame:SetToplevel(true)
	mainFrame:RegisterEvent("ADDON_LOADED")
	mainFrame:SetScript("OnEvent", function(self, event, ...)
		if (event == "ADDON_LOADED") and select(1,...) == addonName then
			addon.profile = HaveGroupWillTravelDB
			window:LoadFramePosition()
			addon:EmitEvent("AddonLoaded")
		end
	end)
	-- Size of background
	local sizeOfBackground = size*1.5
	mainFrame:SetWidth(sizeOfBackground)
	mainFrame:SetHeight(sizeOfBackground)

	-- button size
	local backdropSize = size/2
	local backdropInsets = backdropSize/4
    mainFrame:SetBackdrop( {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = backdropSize, edgeSize = backdropSize,
		insets = { left = backdropInsets, right = backdropInsets, top = backdropInsets, bottom = backdropInsets}
	})
    local BorderColor = {r = 0,g = 0,b = 0, a = 0.85}
    local BackgroundColor = {r = 0.1,g = 0,b = 0, a = 1}
	mainFrame:SetBackdropColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b, BackgroundColor.a)
	mainFrame:SetBackdropBorderColor(BorderColor.r, BorderColor.g, BorderColor.b, BorderColor.a)

    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)


    mainFrame:SetScript("OnMouseDown",function(self, button)
		if ( button == "LeftButton" ) then
			self:StartMoving()
		end
	end)
	mainFrame:SetScript("OnMouseUp",function(self, button)
		if ( button == "LeftButton" ) then
			self:StopMovingOrSizing()
			window:SaveFramePosition()
		end
	end)
	mainFrame:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
	mainFrame:SetClampedToScreen(true)

    window:setupTeleportButtons()
end

function window:setupTeleportButtons()
	local yPos = 0
	local xPos
	for exp, spells in pairs(dungeonsByExpansion) do
		xPos = 0
		for _, spell in ipairs(spells) do
			window:setupTeleportButton(spell, xPos, yPos)
			xPos = xPos - size
		end
		yPos = yPos - size
	end
end

function window:setupTeleportButton(spellData, xPos, yPos)
	local spellID = spellData.spellID
	spellData.button = CreateFrame("button", nil, mainFrame, "SecureActionButtonTemplate")
    local button = spellData.button
	button.spellData = spellData
    button.texture = button:CreateTexture()
    button.texture:SetAllPoints(button)
    local name, _, icon = GetSpellInfo(spellID)
	--print(name, spellID, xPos, yPos)
    button.texture:SetTexture(spellData.icon)

    button:SetWidth(size)
    button:SetHeight(size)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:SetPoint("CENTER", mainFrame, "CENTER", xPos, yPos)
	button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	local overlayText = button:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	button.overlayText = overlayText
	overlayText:SetWidth(button:GetWidth())
	overlayText:SetHeight(20)
	overlayText:SetFont(overlayText:GetFont(),17,"OUTLINE")
	overlayText:SetPoint("TOP", button, "TOP", 0, -5)
	overlayText:SetText(spellData.shortName)

	button.ChangeIsKnown = function (self)
		if self.spellData.isKnown then
			self:SetAttribute("type", "spell")
			self:SetAttribute("spell", self.spellData.spellID)
			self.texture:SetDesaturated(false)
		else
			self.texture:SetDesaturated(true)
		end
	end
end

function window:SaveFramePosition()
	addon.profile.mainFramePosX = mainFrame:GetLeft()
	addon.profile.mainFramePosY = mainFrame:GetTop()
end

function window:LoadFramePosition()
	mainFrame:ClearAllPoints()
	if (addon.profile.mainFramePosX or 0 ~= 0) or (addon.profile.mainFramePosY or 0 ~= 0) then
		mainFrame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", addon.profile.mainFramePosX, addon.profile.mainFramePosY)
	else
		mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end


function window:Show()
	if (InCombatLockdown()) then
		return
	end
	ShowUIPanel(mainFrame)
end

function window:Hide()
	if (InCombatLockdown()) then
		return
	end
	HideUIPanel(mainFrame)
end

function window:isWindowHidden()
	return mainFrame:IsShown() == false
end