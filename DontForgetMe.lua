local DFM_Lang
local DFM_Title
local DFM_Author
local DFM_Version
local DFM_Prefix = "DFM_SYNC"
local DFM_WaitingPetRequest         -- Pet name in waiting list
local DFM_SummoningInProgress

-- States
local isStealth
local isAFK
local isFalling
local isPetSummoned
local isFlying
local isOnTaxi
local isDeadOrGhost
local isCasting
local isInCinematic
local isAtAuctionHouse
local isAtMerchant
local isMailing

-- Lists for favorite, non-favorite pets and owned pets
local DFM_FavoritePets = {}
local DFM_NonFavoritePets = {}
local DFM_OwnedPets = {}

-- Initialize saved settings table
DFM_Settings = DFM_Settings or {}

-- Ensure older versions of DFM_Settings are compatible with the new structure
if type(DFM_Settings.DFM_FavoriteOnly) ~= "boolean" then
    DFM_Settings.DFM_FavoriteOnly = true
end

if type(DFM_Settings.DFM_SyncPet) ~= "boolean" then
    DFM_Settings.DFM_SyncPet = true
end

--- METHOD : On Load - Display Addon name and version
function DFM_OnLoad()
    DFM_InitializeLocales()

    DFM_Title = C_AddOns.GetAddOnMetadata("DontForgetMe", "Title")
    DFM_Author = C_AddOns.GetAddOnMetadata("DontForgetMe", "Author")
    DFM_Version = C_AddOns.GetAddOnMetadata("DontForgetMe", "Version")
    DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["WELCOME_MESSAGE"], DFM_Title, DFM_Version, DFM_Author))

    -- Register addon message prefix
    C_ChatInfo.RegisterAddonMessagePrefix(DFM_Prefix)

   -- Create option panel
    local panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
    panel.name = "Don't Forget Me!"
    local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)

    -- Add an icon next to the title
    local icon = panel:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("2341435") -- Change this to the texture path or ID you want
    icon:SetSize(32, 32) -- Set the size of the icon
    icon:SetPoint("TOPLEFT", 16, -16) -- Adjust the position of the icon

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 0) -- Position the title to the right of the icon
    title:SetText("|cff0066d1"..DFM_Title.."|r".." - ".. DFM_Version)

    local author = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    author:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    author:SetText(string.format(DFM_Locale["BY"], DFM_Author))
    
    -- Favorite only check option
    local checkboxFavoriteOnly = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxFavoriteOnly:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10)
    checkboxFavoriteOnly.text:SetText(DFM_Locale["SETTINGS_FAVORITE_ONLY"])
    checkboxFavoriteOnly:SetChecked(DFM_Settings.DFM_FavoriteOnly)
    checkboxFavoriteOnly:SetScript("OnClick", function(self)
        DFM_Settings.DFM_FavoriteOnly = self:GetChecked()
    end)
    
    -- Sync over GUILD, PARTY or RAID check option
    local checkboxSyncPet = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxSyncPet:SetPoint("TOPLEFT", checkboxFavoriteOnly, "BOTTOMLEFT", 0, 0)
    checkboxSyncPet.text:SetText(DFM_Locale["SETTINGS_ENABLE_SYNC"])
    checkboxSyncPet:SetChecked(DFM_Settings.DFM_SyncPet)
    checkboxSyncPet:SetScript("OnClick", function(self)
        DFM_Settings.DFM_SyncPet = self:GetChecked()
    end)
end

-- METHOD : Check if a pet (by species ID) is owned by the player
function PetIsOwned(speciesID)
    for _, tempSpeciesID in pairs(DFM_OwnedPets) do
        if (tempSpeciesID == speciesID) then        
            return true
        end
    end
    return false
end

-- METHOD : Update the favorite and non-favorite pet lists
local function DFM_UpdatePetLists()
    -- Clear existing data
    wipe(DFM_FavoritePets)
    wipe(DFM_NonFavoritePets)
    wipe(DFM_OwnedPets)

    local numPets, numOwned = C_PetJournal.GetNumPets(false)

    for i = 1, numPets do
        petID, speciesID, owned, _, _, favorite, _, petName = C_PetJournal.GetPetInfoByIndex(i)
        
        if (owned) then         
            -- Update favorite and non-favorite pets as dictionaries
            if (favorite) then
                table.insert(DFM_FavoritePets, speciesID)                
            else
                table.insert(DFM_NonFavoritePets, speciesID)
            end

            -- Update owned pets as dictionary
            table.insert(DFM_OwnedPets, speciesID)
        end
    end
end

-- METHOD : Return pet name from speciesID
local function GetPetNameFromSpeciesID(speciesID)
    local numPets, numOwned = C_PetJournal.GetNumPets(false)

    for i = 1, numPets do
        _, tempSpeciesID, _, _, _, _, _, petName = C_PetJournal.GetPetInfoByIndex(i)

        if (speciesID == tempSpeciesID) then
            return petName
        end        
    end

    return nil
end

-- METHOD : Get petGUID from speciesID
local function GetPetGUIDBySpeciesID(speciesID)
    local numPets = C_PetJournal.GetNumPets(false)

    for i = 1, numPets do
        local petID, petSpeciesID = C_PetJournal.GetPetInfoByIndex(i)

        if petSpeciesID == speciesID then
            return petID, petSpeciesID
        end
    end

    -- Return nil if no petGUID was found
    return nil
end

-- CALLBACK : When summon is completed
local function OnSummonedEnded()
    DFM_WaitingPetRequest = nil
    DFM_SummoningInProgress = false
end

-- METHOD : Summon a random pet from the appropriate list (favorite or not)
local function DFM_SummonPet()
    -- Select appropriate list based on settings
    local tempPetList

    if (DFM_Settings.DFM_FavoriteOnly) then
        tempPetList = DFM_FavoritePets
    else
        tempPetList = DFM_NonFavoritePets
    end

    -- If there are no pets in the list, do nothing
    if (#tempPetList == 0) then
        return
    end

    -- If a summoning is in progress, do nothing
    if (DFM_SummoningInProgress == true) then
        return
    end

    -- Check if pet is summoned
    local currentPetGUID = C_PetJournal.GetSummonedPetGUID()

    -- If a pet is summoned and no query in queue, do nothing
    if (currentPetGUID and not DFM_WaitingPetRequest) then
        return
    -- If a request is in progress
    elseif (DFM_WaitingPetRequest) then
        -- If a pet is summoned, check if pet are the same
        if (currentPetGUID) then
             -- Convert speciesID to petGUID
            local currentSpeciesId, petGUID = GetPetGUIDBySpeciesID(currentPetGUID)

            -- The request and current pet the same
            if (currentSpeciesId == DFM_WaitingPetRequest) then           
                return
            end              
        end      
    end

    -- If pet is no in waiting request, get a random pet name from list
    if (not DFM_WaitingPetRequest) then
        local randomIndex = math.random(1, #tempPetList)
        speciesIdToSummon = tempPetList[randomIndex]
    else
        speciesIdToSummon = DFM_WaitingPetRequest
    end

    local petGUID = GetPetGUIDBySpeciesID(speciesIdToSummon)
    C_PetJournal.SummonPetByGUID(petGUID)
    DFM_SummoningInProgress = true
    C_Timer.After(2, OnSummonedEnded)
end

-- METHOD : Revoke pet
local function DFM_RevokePet()
    -- Ensure pet is summoned before revoke it
    local isPetSummoned = C_PetJournal.GetSummonedPetGUID()

    if (isPetSummoned) then
        C_PetJournal.SummonPetByGUID(C_PetJournal.GetSummonedPetGUID())
    end    
end

-- METHOD : Check states and set flag on DFM_SummonRequired only if necessary
local function DFM_CheckStates()
    local isCombatLockdown = InCombatLockdown()                     -- If combatlock mode is enabled (prevent error for trying to summon action in combat mode)

    if (isCombatLockdown) then
        return
    end

    isStealth = IsStealthed()                                 -- If player is stealth
    isAFK = UnitIsAFK("player")                               -- If player is AFK
    isFalling = IsFalling()                                   -- If player is falling
    isPetSummoned = C_PetJournal.GetSummonedPetGUID()         -- If pet is currently summoned
    isFlying = IsFlying()                                     -- If player is mounted
    isOnTaxi = UnitOnTaxi("player")                           -- If player is on taxi
    isDeadOrGhost = UnitIsDeadOrGhost("player")               -- If player is dead or ghost
    isCasting, _, _, _, _ = UnitChannelInfo("player")         -- If player is casting

    -- If player is not falling, is not in stealth, is not locked by combat and is not on AFK mode
    if ((not isFalling) and (not isStealth) and (not isAFK) and (not isCombatLockdown) and (not isPetSummoned or DFM_WaitingPetRequest) and (not isFlying) and (not isOnTaxi) and (not isDeadOrGhost) and (not isCasting) and (not isInCinematic) and (not isAtMerchant) and (not isAtAuctionHouse) and (not isMailing)) then
        DFM_SummonPet()
    elseif (isStealth and isPetSummoned) then
        DFM_RevokePet()
    end
end

-- METHOD : Update falling state
local function OnUpdate(self, elapsed)
    DFM_CheckStates()
end

-- METHOD : Sync pet over GUILD, PARTY, or RAID
local function DFM_SyncPet(channel)
    local petID = C_PetJournal.GetSummonedPetGUID()     -- If pet is currently summoned    
    
    -- Check if parameter channel is correct
    if ((channel ~= "GUILD") and (channel ~= "PARTY") and (channel ~= "RAID")) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_CMD_PARAM_MISSING"], DFM_Title))
        return
    end

    -- Check if player has pet summoned before sync
    if (not petID) then
        if (channel == "GUILD") then
            DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_SUMMONED_PET_GUILD"], DFM_Title))
        elseif (channel == "PARTY") then
            DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_SUMMONED_PET_PARTY"], DFM_Title))
        elseif (channel == "RAID") then
            DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_SUMMONED_PET_RAID"], DFM_Title))
        end
        return
    end

    -- Check if the player is in a guild before trying to sync with guild
    if ((channel == "GUILD") and (not IsInGuild())) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_IN_GUILD"], DFM_Title))
        return
    end

    -- Check if the player is in a party before trying to sync with party
    if ((channel == "PARTY") and (not IsInGroup())) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_IN_GROUP"], DFM_Title))
        return
    end
    
    -- Check if the player is in a raid before trying to sync with raid
    if ((channel == "RAID") and (not IsInRaid())) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_IN_RAID"], DFM_Title))
        return
    end

    -- Convert PetGUID to pet name
    local speciesId = C_PetJournal.GetPetInfoByPetID(petID)
    C_ChatInfo.SendAddonMessage(DFM_Prefix, speciesId, channel)
end

-- METHOD : Get full player name with server
local function GetFullPlayerName()
    local name, server = UnitFullName("player")

    if (server) then
        return name .. "-" .. server
    else
        return name
    end
end

-- METHOD : Handle received synchronization messages
local function DFM_HandleSyncMessage(prefix, sender, speciesId)
    if (prefix == DFM_Prefix and sender ~= GetFullPlayerName() and speciesId ~= nil) then
        -- Handle the synchronization request here     
        if (DFM_Settings.DFM_SyncPet) then
            speciesIdNum = tonumber(speciesId)
            local petName = GetPetNameFromSpeciesID(speciesIdNum)
            DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["SYNC_REQUEST_RECEIVED"], DFM_Title, sender, petName))

            -- Check if player owned this pet (with his name)
            if (PetIsOwned(speciesIdNum) == true) then
                DFM_WaitingPetRequest = speciesIdNum
            else
                DoEmote("cry")
            end
        end
    end
end

-- Create frame for events
local f = CreateFrame("Frame")

-- Register commands
SLASH_DFMSYNC1 = "/DFM_sync"
SlashCmdList["DFMSYNC"] = function(msg)
    -- Trim leading and trailing whitespace
    local param = strtrim(msg):upper()
    DFM_SyncPet(param)
end

-- Register events
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("COMPANION_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("CINEMATIC_START")
f:RegisterEvent("CINEMATIC_STOP")
f:RegisterEvent("MERCHANT_SHOW")
f:RegisterEvent("MERCHANT_CLOSED")
f:RegisterEvent("AUCTION_HOUSE_SHOW")
f:RegisterEvent("AUCTION_HOUSE_CLOSED")
f:RegisterEvent("MAIL_SHOW")
f:RegisterEvent("MAIL_CLOSED")

-- Manage events
f:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
    if (event == "PLAYER_LOGIN") then
        DFM_OnLoad()
        DFM_UpdatePetLists()
    elseif (event == "COMPANION_UPDATE") then
        DFM_UpdatePetLists()
    elseif (event == "CHAT_MSG_ADDON") then
        DFM_HandleSyncMessage(prefix, sender, message)
    elseif (event == "CINEMATIC_START") then
        isInCinematic = true
    elseif (event == "CINEMATIC_STOP") then
        isInCinematic = false
    elseif (event == "MERCHANT_SHOW") then
        isAtMerchant = true
    elseif (event == "MERCHANT_CLOSED") then
        isAtMerchant = false
    elseif (event == "AUCTION_HOUSE_SHOW") then
        isAtAuctionHouse = true
    elseif (event == "AUCTION_HOUSE_CLOSED") then
        isAtAuctionHouse = false
    elseif (event == "MAIL_SHOW") then
        isMailing = true
    elseif (event == "MAIL_CLOSED") then
        isMailing = false
    end
end)

-- Update check for falling state
f:SetScript("OnUpdate", OnUpdate)