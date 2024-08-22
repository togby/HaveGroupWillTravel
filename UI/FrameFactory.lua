local addonName, addon = ...

addon.FrameFactory = {}
local factory = addon.FrameFactory


local teleportButtonPool = CreateFramePool("Button", nil, "SecureActionButtonTemplate")
local teleportCooldownPool = CreateFramePool("Cooldown", nil, "CooldownFrameTemplate")

local teleportTooltip = GameTooltip

local teleportTooltipOffsetX = 0;
local teleportTooltipOffsetY = 0;


local function CooldownUpdate(self, spellId)
	local spellCooldown = C_Spell.GetSpellCooldown(spellId)
	
	self:SetCooldown(spellCooldown.startTime, spellCooldown.duration)
end


function factory:CreateTeleportButtonForSpellData(spellData, parent, size, xPos, yPos)

    spellData.button = teleportButtonPool:Acquire()
    local button = spellData.button
	button.spellData = spellData
    button:Show()
    button:SetParent(parent)
    local spellId = spellData.spellId
    button.texture = button:CreateTexture()
    button.texture:SetAllPoints(button)
    
	button:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xPos, yPos)
    button.texture:SetTexture(spellData.icon)
	print(spellData.icon)

    button:SetWidth(size)
    button:SetHeight(size)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	local cooldown = teleportCooldownPool:Acquire()
	button.cooldown = cooldown
    cooldown:SetParent(button)
	cooldown:SetAllPoints()
	cooldown.UpdateFunction = function(self)
		CooldownUpdate(self, spellId)
	end

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
			self:SetAttribute("spell", self.spellData.spellId)
			self.texture:SetDesaturated(false)
		else
			self.texture:SetDesaturated(true)
		end
	end

	button:HookScript("OnEnter", function()
		teleportTooltip:SetOwner(button, "ANCHOR_NONE")
		teleportTooltip:SetHyperlink("spell:".. spellId)
		teleportTooltip:SetPoint("TOPLEFT", button, "BOTTOMRIGHT", teleportTooltipOffsetX, teleportTooltipOffsetY)
		teleportTooltip:Show()
    end)
    button:HookScript("OnLeave", function()
        teleportTooltip:Hide()
    end)



    return button
end
