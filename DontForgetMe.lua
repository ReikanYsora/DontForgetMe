-- Author      : Reikan
-- Create Date : 10/09/2020 3:19:28 PM
-- Update Date : 10/10/2020 5:57:12 PM

local ADDON_NAME, namespace = ...
local L = namespace.L
local ADDON_VERSION = "1.0.0";
local ADDON_NAME = "Don't forget me !";
SLASH_DFM1 = "/dfm";

function DFM_OnLoad()
    DFMFrame:RegisterEvent("PLAYER_CONTROL_GAINED");
    DFMFrame:RegisterEvent("PLAYER_UNGHOST");
    DFMFrame:RegisterEvent("UNIT_EXITING_VEHICLE");
    DFMFrame:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA");
    DFMFrame:RegisterEvent("PLAYER_ALIVE");
    
    DFMFrame:SetScript("OnEvent", DFM_OnEvent);
    DFM_AddInterfaceOptionPanel();
    PrintMessage(L["LOADED"]);
end

function DFM_AddInterfaceOptionPanel()
    MyAddon = {};
    frame = CreateFrame("Frame", "DFM_OptionPanel", UIParent);
    MyAddon.panel = frame;
    MyAddon.panel.name = ADDON_NAME;
    InterfaceOptions_AddCategory(MyAddon.panel);
end

function PrintMessage(msg)
      DEFAULT_CHAT_FRAME:AddMessage("|cff267dcf["..ADDON_NAME.."]: |r"..msg)
end

function DFMHandler()    
    coroutine.wrap(SummonRandomPet)(0);
end

function DFM_OnEvent(self, event, ...)      
    if (event == "PLAYER_CONTROL_GAINED") then 
        coroutine.wrap(SummonRandomPet)(0);
    end
     
    if (event == "PLAYER_UNGHOST") then  
        coroutine.wrap(SummonRandomPet)(0);
    end     
     
    if (event == "UNIT_EXITING_VEHICLE") then   
        coroutine.wrap(SummonRandomPet)(0);
    end

    if (event == "PLAYER_LOSES_VEHICLE_DATA") then  
        coroutine.wrap(SummonRandomPet)(0);
    end

    if (event == "PLAYER_ALIVE") then     
        coroutine.wrap(SummonRandomPet)(0);
    end     
end

local function delay(tick)
    local th = coroutine.running()
    C_Timer.After(tick, function() coroutine.resume(th) end)
    coroutine.yield()
end

function SummonRandomPet()
	--numPets, count = C_PetJournal.GetNumPets(false);
    --if (count == 0) then
    --    return;
    --end

    C_PetJournal.SummonRandomPet(false);
    delay(0.5);
    petId = C_PetJournal.GetSummonedPetGUID();

    if (petId) then
        speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable = C_PetJournal.GetPetInfoByPetID(petId);
        
        if (customName) then
            displayName = customName;
        else
            displayName = name;
        end

        displayText = L["ASKS"]..displayName..L["TO_COME"];

        if (petType == 1) then
            displayText = displayText..L["HUMANOID"];
        end

        if (petType == 2) then
            displayText = displayText..L["DRAGONKIN"];
        end
        
        if (petType == 3) then
            displayText = displayText..L["FLYING"];
        end

        if (petType == 4) then
            displayText = displayText..L["UNDEAD"];
        end

        if (petType == 5) then
            displayText = displayText..L["CRITTER"];
        end

        if (petType == 6) then
            displayText = displayText..L["MAGIC"];
        end

        if (petType == 7) then
            displayText = displayText..L["ELEMENTAL"];
        end

        if (petType == 8) then
            displayText = displayText..L["BEAST"];
        end

        if (petType == 9) then
            displayText = displayText..L["AQUATIC"] ;
        end

        if (petType == 10) then
            displayText = displayText..L["MECHANICAL"];
        end

        if (isFavorite) then
            gender = UnitSex("player");
            if (gender == 3) then
                displayText = displayText..displayName..L["FAVORITE_1"]..L["GENDER_F"]..L["FAVORITE_2"];
            else
                displayText = displayText..displayName..L["FAVORITE_1"]..L["GENDER_M"]..L["FAVORITE_2"];
            end
        end

        if (displayText) then
            SendChatMessage(displayText ,"EMOTE");
        end
    end
end

SlashCmdList["DFM"] = DFMHandler