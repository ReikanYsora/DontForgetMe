local DFM_Title
local DFM_Author
local DFM_Version
local DFM_IsFalling = false

-- Init saved settings
if DFM_Settings == nil then
    DFM_Settings = {}
end

if DFM_Settings.DFM_FavoriteOnly == nil then
    DFM_Settings.DFM_FavoriteOnly = true
end

--- METHOD : On Load - Display Addon name and version
function DFM_OnLoad()
    DFM_Title = C_AddOns.GetAddOnMetadata("DontForgetMe", "Title")
    DFM_Author = C_AddOns.GetAddOnMetadata("DontForgetMe", "Author")
    DFM_Version = C_AddOns.GetAddOnMetadata("DontForgetMe", "Version")
    DEFAULT_CHAT_FRAME:AddMessage("|cff0066d1".. DFM_Title .."|r |cffffff00-|r |cffeb7800"..DFM_Version.."|r |cffffff00 by "..DFM_Author.."|r")

    -- Register addon message prefix
    C_ChatInfo.RegisterAddonMessagePrefix("DFM_PetSync")

   -- Create option panel
    local panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
    panel.name = "Don't Forget Me!"
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)

    -- Add an icon next to the title
    local icon = panel:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("2341435")  -- Change this to the texture path or ID you want
    icon:SetSize(32, 32)  -- Set the size of the icon
    icon:SetPoint("TOPLEFT", 16, -16)  -- Adjust the position of the icon

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 0)  -- Position the title to the right of the icon
    title:SetText("|cff0066d1"..DFM_Title.."|r".." - ".. DFM_Version)

    local author = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    author:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    author:SetText("by " .. DFM_Author)
    
    -- Favorite only check option
    local checkboxFavoriteOnly = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxFavoriteOnly:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10)
    checkboxFavoriteOnly.text:SetText("Summon favorite pets only")
    checkboxFavoriteOnly:SetChecked(DFM_Settings.DFM_FavoriteOnly)
    checkboxFavoriteOnly:SetScript("OnClick", function(self)
        DFM_Settings.DFM_FavoriteOnly = self:GetChecked()
    end)
end

-- METHOD : Check if a pet is summon, if not, summon a random favorite pet
local function DFM_SummonPet()
    local DFM_petGUID = C_PetJournal.GetSummonedPetGUID()

    -- If player has not current pet summoned
    if (not DFM_petGUID) then
        C_PetJournal.SummonRandomPet(DFM_Settings.DFM_FavoriteOnly)
    end
end

-- METHOD : On player flag changed (after an AFK)
local function OnPlayerFlagsChanged()
    local isAFK = UnitIsAFK("player")
    if (not isAFK) then
        DFM_SummonPet()
    end
end

-- METHOD : Update falling state
local function OnUpdate()
    if (IsFalling()) then
        DFM_IsFalling = true
    elseif (DFM_IsFalling) then
        DFM_SummonPet()
        DFM_IsFalling = false
    end
end

-- Create frame for events
local f = CreateFrame("Frame")

-- Register events
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
f:RegisterEvent("PLAYER_UNGHOST")
f:RegisterEvent("PLAYER_FLAGS_CHANGED")

-- Manage events
f:SetScript("OnEvent", function(self, event, unit, ...)
    local arg1, arg2, arg3, arg4 = ...

    if (event == "PLAYER_LOGIN") then
        DFM_OnLoad()
    elseif (event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_UNGHOST") then
        DFM_SummonPet()
    elseif (event == "PLAYER_MOUNT_DISPLAY_CHANGED") then
        local isMounted = IsMounted()
        if not isMounted then
            DFM_SummonPet()
        end   
    elseif (event == "PLAYER_FLAGS_CHANGED") then
        if unit == "player" then
            OnPlayerFlagsChanged()
        end
    end
end)

-- Update check for falling state
f:SetScript("OnUpdate", OnUpdate)