local addonName, addon = ...


addon.UIWindows.TeleportWindowFrame = {}
local window = addon.UIWindows.TeleportWindowFrame

local mainFrame

local size = 50
local windowMargin = 20

local dungeonsByExpansion = addon.data.DungeonTeleportersByExpansion()


local size = 200

function window:SetupWindow()
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
    local BackgroundColor = {r = 0.1,g = 0,b = 0, a = 0.75}
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
	local yPos = -windowMargin
	local xPos
	local windowWidth = 0
	local windowHeight = windowMargin * 2
	for expansionName, dungeonInExpansion in pairs(dungeonsByExpansion) do
		xPos = -windowMargin
		local overlayText = mainFrame:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
		overlayText:SetWidth(100)
		overlayText:SetHeight(20)
		overlayText:SetFont(overlayText:GetFont(),17,"OUTLINE")
		overlayText:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", xPos, yPos)
		overlayText:SetText(expansionName)
		xPos = xPos - 100
		for _, spellData in ipairs(dungeonInExpansion) do
			addon.FrameFactory:CreateTeleportButtonForSpellData(spellData, mainFrame, size, xPos, yPos)
			xPos = xPos - size
			windowWidth = windowWidth < xPos and windowWidth or xPos
		end
		yPos = yPos - size
		windowHeight = windowHeight + size
	end
	windowWidth = windowWidth - windowMargin * 2
	mainFrame:SetWidth(-windowWidth)
	mainFrame:SetHeight(windowHeight)
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