local addonName, addon = ...

addon.FrameFactory = {}
local factory = addon.FrameFactory


local teleportButtonPool = CreateFramePool("Button", nil, "SecureActionButtonTemplate")


function factory:CreateTeleportButtonForSpellData(spellData, parent, size,xPos, yPos)

    spellData.button = teleportButtonPool:Acquire()
    local button = spellData.button
	button.spellData = spellData
    button:Show()
    button:SetParent(parent)
    local spellID = spellData.spellID
    button.texture = button:CreateTexture()
    button.texture:SetAllPoints(button)
    
	--print(name, spellID, xPos, yPos)
	button:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xPos, yPos)
    button.texture:SetTexture(spellData.icon)

    button:SetWidth(size)
    button:SetHeight(size)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
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
    return button
end

