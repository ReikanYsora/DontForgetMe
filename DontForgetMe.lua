local DFM_Title
local DFM_Author
local DFM_Version

-- Init saved settings
if DFM_Settings == nil then
    DFM_Settings = {}
end

if DFM_Settings.DFM_FavoriteOnly == nil then
    DFM_Settings.DFM_FavoriteOnly = true
end

if DFM_Settings.DFM_SyncPets == nil then
    DFM_Settings.DFM_SyncPets = true
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
    panel.name = "Don't Forget Me"
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(DFM_Title .. " - " .. DFM_Version)

    local author = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    author:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    author:SetText("by " .. DFM_Author)
    
    -- Favorite only check option
    local checkboxFavoriteOnly = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxFavoriteOnly:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -16)
    checkboxFavoriteOnly.text:SetText("Summon favorite pets only")
    checkboxFavoriteOnly:SetChecked(DFM_Settings.DFM_FavoriteOnly)

    checkboxFavoriteOnly:SetScript("OnClick", function(self)
        DFM_Settings.DFM_FavoriteOnly = self:GetChecked()
    end)
end

-- METHOD : Check if a pet is summon, if not, summon a random favorite pet
local function DFM_EnsurePet()
    local DFM_petGUID = C_PetJournal.GetSummonedPetGUID()

    if not DFM_petGUID then
        C_PetJournal.SummonRandomPet(DFM_Settings.DFM_FavoriteOnly)
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
f:RegisterEvent("ADDON_LOADED")

-- Manage events
f:SetScript("OnEvent", function(self, event, ...)
    local arg1, arg2, arg3, arg4 = ...

    if event == "PLAYER_LOGIN" then
        DFM_OnLoad()
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
        DFM_EnsurePet()
    elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
        local isMounted = IsMounted()
        if not isMounted then
            DFM_EnsurePet()
        end        
    elseif event == "CHAT_MSG_ADDON" then
        DFM_OnAddonMessage(arg1, arg2, arg3, arg4)
    end
end)