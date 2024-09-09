-- Addon infos
local DFM_Lang
local DFM_Title
local DFM_Author
local DFM_Version

-- Sync variables
local DFM_Prefix = "DFM_SYNC"
local DFM_WaitingPetRequest         -- Pet species ID in queue
local DFM_SummoningInProgress       -- State for summoning (API request must be take 2 sec to return the good summoning value)
local DFM_UpdatesPerSecond = 5      -- Update per second to check character states
local DFM_LastUpdate = 0

-- States
local isStealth
local isAFK
local isFalling
local isCombatLockdown
local isPetSummoned
local isFlying
local isOnTaxi
local isDeadOrGhost
local isCasting

-- Lists for favorites, non-favorites pets, owned pets and database references
local DFM_FavoritePets = {}
local DFM_NonFavoritePets = {}
local DFM_OwnedPets = {}
local DFM_KnownPetNames = {}
local DFM_FavoritesWithDuplicatedCount = 0
local DFM_NonFavoritesWithDuplicatedCount = 0
local DFM_OwnedWithDuplicatedCount = 0

-- Initialize saved settings table
DFM_Settings = DFM_Settings or
{
    DFM_Setting_FavoriteOnly = true,
    DFM_Setting_SyncPet = true
}

--- METHOD : On Load - Display Addon name and version
function DFM_OnLoad()
    DFM_InitializeLocales()

    DFM_Title = C_AddOns.GetAddOnMetadata("DontForgetMe", "Title")
    DFM_Author = C_AddOns.GetAddOnMetadata("DontForgetMe", "Author")
    DFM_Version = C_AddOns.GetAddOnMetadata("DontForgetMe", "Version")

    --Welcome message
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
    icon:SetTexture("2341435")
    icon:SetSize(32, 32)
    icon:SetPoint("TOPLEFT", 16, -16) 

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    title:SetText("|cff0066d1"..DFM_Title.."|r".." - ".. DFM_Version)

    local author = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    author:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    author:SetText(string.format(DFM_Locale["BY"], DFM_Author))
    
    -- Favorite only check option
    local checkboxFavoriteOnly = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxFavoriteOnly:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10)
    checkboxFavoriteOnly.text:SetText(DFM_Locale["SETTINGS_FAVORITE_ONLY"])
    checkboxFavoriteOnly:SetChecked(DFM_Settings.DFM_Setting_FavoriteOnly)
    checkboxFavoriteOnly:SetScript("OnClick", function(self)
        DFM_Settings.DFM_Setting_FavoriteOnly = self:GetChecked()
    end)
    
    -- Sync over GUILD, PARTY or RAID check option
    local checkboxSyncPet = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkboxSyncPet:SetPoint("TOPLEFT", checkboxFavoriteOnly, "BOTTOMLEFT", 0, 0)
    checkboxSyncPet.text:SetText(DFM_Locale["SETTINGS_ENABLE_SYNC"])
    checkboxSyncPet:SetChecked(DFM_Settings.DFM_Setting_SyncPet)
    checkboxSyncPet:SetScript("OnClick", function(self)
        DFM_Settings.DFM_Setting_SyncPet = self:GetChecked()
    end)
end

-- METHOD : Return count of entries in a dictionary
local function DFM_DictionaryCount(dictionary)
    if (not dictionary) then
        return 0
    end

    local count = 0

    for _ in pairs(dictionary) do
        count = count + 1
    end

    return count
end

-- METHOD : Check if a pet (by species ID) is owned by the player
local function DFM_PetIsOwned(speciesID)
    return DFM_OwnedPets[speciesID] ~= nil
end

-- METHOD : Get petName from speciesID
local function DFM_GetPetNameFromSpeciesID(speciesID)
    local tempSpeciesID, tempPetName

    for tempSpeciesID, tempPetName in pairs(DFM_KnownPetNames) do
        if (tempSpeciesID == speciesID) then
            return tempPetName
        end
    end

    return nil
end

-- METHOD : Return a random SpeciesID from dictionnaries
local function DFM_GetRandomSpeciesID(petDictionary)
    local keys = {}
    local key
    
    for key in pairs(petDictionary) do
        table.insert(keys, key)
    end
    
    if #keys == 0 then
        return nil
    end

    local randomIndex = math.random(#keys)
    local randomKey = keys[randomIndex]

    return randomKey
end

-- METHOD : Get petGUID from speciesID
local function DFM_GetPetGUIDFromSpeciesID(speciesID)
    return DFM_OwnedPets[speciesID] or nil
end

-- METHOD : Get speciesID from petGUID
local function DFM_GetSpeciesIDByPetGUID(petGUID)
    local tempSpeciesID, tempPetGUID

    for tempSpeciesID, tempPetGUID in pairs(DFM_OwnedPets) do
        if (tempPetGUID == petGUID) then
            return tempSpeciesID
        end
    end
    return nil
end

-- METHOD : Get full player name with server
local function DFM_GetFullPlayerName()
    local name, server = UnitFullName("player")

    if (server) then
        return name .. "-" .. server
    else
        return name
    end
end

-- METHOD : Return count of favorites pet, non favorites pet and owned pet
local function DFM_CheckDifferences()
    local favoritesCount = 0
    local nonFavoritesCount = 0
    local ownedCount = 0

    local numPets, _ = C_PetJournal.GetNumPets()

    for i = 1, numPets do
        local petGUID, speciesID, owned, _, _, favorite, _, petName = C_PetJournal.GetPetInfoByIndex(i)

        if (owned) then
            ownedCount = ownedCount + 1
            
            if (favorite) then
                favoritesCount = favoritesCount + 1
            else
                nonFavoritesCount = nonFavoritesCount + 1
            end
        end
    end

    return favoritesCount, nonFavoritesCount, ownedCount
end

-- METHOD : Update the favorite and non-favorite pet lists
local function DFM_UpdatePetDictionaries()   
    local favoritesCount, nonFavoritesCount, ownedCount = DFM_CheckDifferences()

    -- If update is not needed
    if (DFM_FavoritesWithDuplicatedCount == favoritesCount and DFM_NonFavoritesWithDuplicatedCount == nonFavoritesCount and DFM_OwnedWithDuplicatedCount == ownedCount) then
        return;
    end

    -- Clear existing data
    wipe(DFM_FavoritePets)
    wipe(DFM_NonFavoritePets)
    wipe(DFM_OwnedPets)
    wipe(DFM_KnownPetNames)
    
    local numPets, ownedPets = C_PetJournal.GetNumPets()

    for i = 1, numPets do
        local petGUID, speciesID, owned, _, _, favorite, _, petName = C_PetJournal.GetPetInfoByIndex(i)

        -- Update known pets name (speciesID => Pet name)
        DFM_KnownPetNames[speciesID] = petName

        if (owned) then            
            DFM_OwnedWithDuplicatedCount = DFM_OwnedWithDuplicatedCount + 1

            -- Update owned pets as dictionary (speciesID => petGUID)
            DFM_OwnedPets[speciesID] = petGUID
            
            -- Update favorite and non-favorite pets as dictionaries (speciesID => petGUID)
            if (favorite) then
                DFM_FavoritesWithDuplicatedCount = DFM_FavoritesWithDuplicatedCount + 1
                DFM_FavoritePets[speciesID] = petGUID
            else
                DFM_NonFavoritesWithDuplicatedCount = DFM_NonFavoritesWithDuplicatedCount + 1
                DFM_NonFavoritePets[speciesID] = petGUID
            end
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["LIST_UPDATED"], DFM_Title))
end

-- CALLBACK : When summon is completed
local function DFM_OnSummonedEnded()
    DFM_WaitingPetRequest = nil
    DFM_SummoningInProgress = false
end

-- METHOD : Summon a random pet from the appropriate list (favorite or not)
local function DFM_SummonPet()
    -- Select appropriate list based on settings
    local tempPetList

    if (DFM_Settings.DFM_Setting_FavoriteOnly) then
        tempPetList = DFM_FavoritePets
    else
        tempPetList = DFM_NonFavoritePets
    end

    -- If there are no pets in the list, do nothing
    if (DFM_DictionaryCount(tempPetList) == 0) then
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
            local currentSpeciesId = DFM_GetSpeciesIDByPetGUID(currentPetGUID)

            if (not currentSpeciesId) then
                return
            end

            -- The request and current pet the same
            if (currentSpeciesId == DFM_WaitingPetRequest) then  
                DFM_WaitingPetRequest = nil
                return
            end              
        end      
    end

    -- If pet is no in waiting request, get a random pet name from list
    if (not DFM_WaitingPetRequest) then
        speciesIdToSummon = DFM_GetRandomSpeciesID(tempPetList)
    else
        speciesIdToSummon = DFM_WaitingPetRequest 
    end

    local petGUID = DFM_GetPetGUIDFromSpeciesID(speciesIdToSummon)

    if (petGUID) then
        C_PetJournal.SummonPetByGUID(petGUID)
        DFM_SummoningInProgress = true
        C_Timer.After(2, DFM_OnSummonedEnded)
    end
end

-- METHOD : Revoke pet
local function DFM_RevokePet()
    -- Ensure pet is summoned before revoke it
    local isPetSummoned = C_PetJournal.GetSummonedPetGUID()

    if (isPetSummoned) then
        C_PetJournal.SummonPetByGUID(isPetSummoned)
    end    
end

-- METHOD : Check states and set flag on DFM_SummonRequired only if necessary
local function DFM_CheckStates()
    isCombatLockdown = InCombatLockdown()               -- If combatlock mode is enabled (prevent error for trying to summon action in combat mode)

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
    if ((not isFalling) and (not isStealth) and (not isAFK) and (not isCombatLockdown) and (not isPetSummoned or DFM_WaitingPetRequest) and (not isFlying) and (not isOnTaxi) and (not isDeadOrGhost) and (not isCasting)) then
        DFM_SummonPet()
    elseif (isStealth and isPetSummoned) then
        DFM_RevokePet()
    end
end

-- METHOD : Get filter text in the pet journal filter input text
local function DFM_PetJournalHasSearchText()
    if (PetJournal and PetJournal:IsShown()) then
        local searchBox = PetJournalSearchBox

        if (searchBox) then
            if (searchBox:GetText() == "") then
                return false
            else
                return true
            end
        else
            return false
        end
    end

    return false
end

-- METHOD : Update falling state
local function OnUpdate(self, elapsed)
    DFM_LastUpdate = DFM_LastUpdate + elapsed

    if (DFM_LastUpdate >= DFM_UpdatesPerSecond) then
        DFM_CheckStates()
        DFM_LastUpdate = 0
    end
end

-- METHOD : Sync pet over GUILD, PARTY, or RAID
local function DFM_SyncPet(channel)
    if (DFM_Settings.DFM_Setting_SyncPet == false) then
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["ERROR_SYNC_NOT_ENABLED"], DFM_Title))
        return
    end

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

    -- Convert PetGUID to speciesID
    local speciesID = DFM_GetSpeciesIDByPetGUID(petID)

    if (speciesID) then
        C_ChatInfo.SendAddonMessage(DFM_Prefix, speciesID, channel)
        local petName = DFM_GetPetNameFromSpeciesID(speciesID)
        DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["SYNC_REQUEST_FEEDBACK"], DFM_Title, petName))
    else
        --ERREUR : SpeciesID non trouvé à gerer
    end
end

-- METHOD : Handle received synchronization messages
local function DFM_HandleSyncMessage(prefix, sender, speciesId)
    if (prefix == DFM_Prefix and sender ~= DFM_GetFullPlayerName() and speciesId ~= nil) then
        -- Handle the synchronization request here     
        if (DFM_Settings.DFM_Setting_SyncPet) then
            speciesIdNum = tonumber(speciesId)

            if (speciesIdNum) then
                local petName = DFM_GetPetNameFromSpeciesID(speciesIdNum)

                if (petName) then
                    DEFAULT_CHAT_FRAME:AddMessage(string.format(DFM_Locale["SYNC_REQUEST_RECEIVED"], DFM_Title, sender, petName))

                    -- Check if player owned this pet (with his name)
                    if (DFM_PetIsOwned(speciesIdNum) == true) then
                        DFM_WaitingPetRequest = speciesIdNum
                    else
                        DoEmote("cry")
                    end
                end                
            end           
        end
    end
end

-- Create frame for events
local f = CreateFrame("Frame")

-- Register commands
SLASH_DFMSYNC1 = "/DFM_sync"
SlashCmdList["DFMSYNC"] = function(msg)
    local param = strtrim(msg):upper()
    DFM_SyncPet(param)
end

-- Register events
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
f:RegisterEvent("CHAT_MSG_ADDON")

-- Manage events
f:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
    if (event == "PLAYER_LOGIN") then
        DFM_OnLoad()
    elseif (event == "PET_JOURNAL_LIST_UPDATE") then
        -- Only if text is empty in pet journal search filter bar
        if (DFM_PetJournalHasSearchText() == false) then
            DFM_UpdatePetDictionaries()
        end
    elseif (event == "CHAT_MSG_ADDON") then
        DFM_HandleSyncMessage(prefix, sender, message)
    end
end)

-- Update check for falling state
f:SetScript("OnUpdate", OnUpdate)