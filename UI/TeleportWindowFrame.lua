local addonName, addon = ...


addon.UIWindows.Dashboard = {}
local window = addon.UIWindows.Dashboard

local MainFrame

function window:SetupWindow()
    local frame, Button, fs -- temps used below
	-- main frame
	MainFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    MainFrame:EnableMouse(true)
	MainFrame:SetFrameStrata("MEDIUM")
	MainFrame:SetMovable(true)
	MainFrame:SetToplevel(true)
	MainFrame:SetWidth(400)
	MainFrame:SetHeight(400)
    MainFrame:SetBackdrop( {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
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

    Button:SetWidth(50)
    Button:SetHeight(50)
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