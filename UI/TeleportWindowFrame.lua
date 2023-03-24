local addonName, addon = ...


addon.UIWindows.Dashboard = {}
local window = addon.UIWindows.Dashboard

local MainFrame

local size = 50

-- All currently known(by Oskar) dungeon teleporter ID's
-- Tables automitically sort tables by key value, so below is not how they will generate in game
local dungeons = addon.data.DungeonTeleportersByExpansion()


function window:SetupWindow()
    local frame, Button, fs -- temps used below
	-- main frame
	MainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    MainFrame:SetMouseClickEnabled(true)
	MainFrame:SetMouseMotionEnabled(true)
	MainFrame:SetFrameStrata("MEDIUM")
	MainFrame:SetMovable(true)
	MainFrame:SetToplevel(true)
	MainFrame:RegisterEvent("ADDON_LOADED")
	MainFrame:SetScript("OnEvent", function(self, event, ...)
		if (event == "ADDON_LOADED") and select(1,...) == addonName then
			addon.profile = HaveGroupWillTravelDB
			window:LoadFramePosition()
		end
	end)
	-- Size of background
	local sizeOfBackground = size*1.5
	MainFrame:SetWidth(sizeOfBackground)
	MainFrame:SetHeight(sizeOfBackground)

	-- button size
	local backdropSize = size/2
	local backdropInsets = backdropSize/4
    MainFrame:SetBackdrop( {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = backdropSize, edgeSize = backdropSize,
		insets = { left = backdropInsets, right = backdropInsets, top = backdropInsets, bottom = backdropInsets}
	})
    local BorderColor = {r = 0,g = 0,b = 0, a = 0.85}
    local BackgroundColor = {r = 0.1,g = 0,b = 0, a = 1}
	MainFrame:SetBackdropColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b, BackgroundColor.a)
	MainFrame:SetBackdropBorderColor(BorderColor.r, BorderColor.g, BorderColor.b, BorderColor.a)

    MainFrame:Show()
    MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)


    MainFrame:SetScript("OnMouseDown",function(self, Button)
		if ( Button == "LeftButton" ) then
			self:StartMoving()
		end
	end)
	MainFrame:SetScript("OnMouseUp",function(self, Button)
		if ( Button == "LeftButton" ) then
			self:StopMovingOrSizing()
			window:SaveFramePosition()
		end
	end)
	MainFrame:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
	MainFrame:SetClampedToScreen(true)

    window:setupTeleportButtons()
end

function window:setupTeleportButtons()
	local yPos = 0
	local xPos
	for exp, spells in pairs(dungeons) do
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
    local Button = CreateFrame("Button", nil, MainFrame, "SecureActionButtonTemplate")
    Button.texture = Button:CreateTexture()
    Button.texture:SetAllPoints(Button)
    local name, _, icon = GetSpellInfo(spellID)
	print(name, spellID, xPos, yPos)
    Button.texture:SetTexture(spellData.icon)

    Button:SetWidth(size)
    Button:SetHeight(size)
    Button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	Button:SetPoint("CENTER", MainFrame, "CENTER", xPos, yPos)
	Button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	if spellData.isKnown then
		Button:SetAttribute("type", "spell")
		Button:SetAttribute("spell", spellID)

		--Button:SetAttribute("type", "macro")
		--Button:SetAttribute("macrotext", "/cast " .. name)
	else
		Button.texture:SetDesaturated(1)
	end
	local overlayText = Button:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	Button.overlayText = overlayText
	overlayText:SetWidth(Button:GetWidth())
	overlayText:SetHeight(20)
	overlayText:SetFont(overlayText:GetFont(),17,"OUTLINE")
	overlayText:SetPoint("TOP", Button, "TOP", 0, -5)
	overlayText:SetText(spellData.shortName)
	overlayText:Show()
    Button:Show()
end

function window:SaveFramePosition()
	addon.profile.MainFramePosX = MainFrame:GetLeft()
	addon.profile.MainFramePosY = MainFrame:GetTop()
end

function window:LoadFramePosition()
	MainFrame:ClearAllPoints()
	if (addon.profile.MainFramePosX or 0 ~= 0) or (addon.profile.MainFramePosY or 0 ~= 0) then
		MainFrame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", addon.profile.MainFramePosX, addon.profile.MainFramePosY)
	else
		MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end


function window:Show()
	if (InCombatLockdown()) then
		return
	end
	ShowUIPanel(MainFrame)
end

function window:Hide()
	if (InCombatLockdown()) then
		return
	end
	HideUIPanel(MainFrame)
end

function window:isWindowHidden()
	return MainFrame:IsShown() == false
end