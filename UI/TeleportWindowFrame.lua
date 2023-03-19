local addonName, addon = ...


addon.UIWindows.Dashboard = {}
local window = addon.UIWindows.Dashboard

local MainFrame

local size = 50

function window:SetupWindow()
    local frame, Button, fs -- temps used below
	-- main frame
	MainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    MainFrame:EnableMouse(true)
	MainFrame:SetFrameStrata("MEDIUM")
	MainFrame:SetMovable(true)
	MainFrame:SetToplevel(true)

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

    window:LoadFramePosition()
    window:setupTeleportButtons()
end

function window:setupTeleportButtons()
    window:setupTeleportButton(131204)
end

function window:setupTeleportButton(spellID)
    
    local Button = CreateFrame("Button", nil, MainFrame, "SecureActionButtonTemplate")
    Button.tex = Button:CreateTexture()
    Button.tex:SetAllPoints(Button)
    local name, _, icon = GetSpellInfo(spellID)
    Button.tex:SetTexture(icon)

    Button:SetWidth(size)
    Button:SetHeight(size)
    Button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	Button:SetPoint("CENTER", MainFrame, "CENTER", 0, 0)

    Button:SetAttribute("type", "spell")
    Button:SetAttribute("spell", spellID)

    Button:Show()
end


function window:SaveFramePosition()
	HaveGroupWillTravelDB.MainFramePosX = MainFrame:GetLeft()
	HaveGroupWillTravelDB.MainFramePosY = MainFrame:GetTop()
end

function window:LoadFramePosition()
	MainFrame:ClearAllPoints()
    
    --print(HaveGroupWillTravelDB.MainFramePosX .. " " .. HaveGroupWillTravelDB.MainFramePosY)
	if (HaveGroupWillTravelDB.MainFramePosX or 0 ~= 0) or (HaveGroupWillTravelDB.MainFramePosY or 0 ~= 0) then
		MainFrame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", HaveGroupWillTravelDB.MainFramePosX, HaveGroupWillTravelDB.MainFramePosY)
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