DFM_Locale = 
{
	["WELCOME_MESSAGE"]								= "|cff0066d1%s|r - |cffeb7800%s|r by %s",
	["BY"]											= "by %s",
	["SETTINGS_FAVORITE_ONLY"]						= "Summon favorite pets only",
	["SETTINGS_ENABLE_SYNC"]						= "Allow synchronization over GUILD, PARTY and RAID",
	["SETTINGS_SESSION_DURATION"]					= "Duration of the pet session (in minutes)",
	["ERROR_CMD_PARAM_MISSING"]						= "|cff0066d1%s|r : |cffffffff[/dfm_sync]|r must be used with parameter '|cff45f237GUILD|r', '|cff37aef2PARTY|r' or '|cfff7913cRAID|r'",
	["ERROR_SYNC_NOT_SUMMONED_PET_GUILD"]			= "|cff0066d1%s|r : You need to have a summoned pet to sync pet with '|cff45f237GUILD|r' members",
	["ERROR_SYNC_NOT_SUMMONED_PET_PARTY"]			= "|cff0066d1%s|r : You need to have a summoned pet to sync pet with '|cff37aef2PARTY|r' members",
	["ERROR_SYNC_NOT_SUMMONED_PET_RAID"]			= "|cff0066d1%s|r : You need to have a summoned pet to sync pet with '|cfff7913cRAID|r' members",
	["ERROR_SYNC_NOT_IN_GUILD"]						= "|cff0066d1%s|r : You need to join a guild before using this command",
	["ERROR_SYNC_NOT_IN_GROUP"]						= "|cff0066d1%s|r : You need to join a party before using this command",
	["ERROR_SYNC_NOT_IN_RAID"]						= "|cff0066d1%s|r : You need to join a raid before using this command",
	["SYNC_REQUEST_RECEIVED"]						= "|cff0066d1%s|r : %s wants you to summon %s !"
};

-- METHOD : Initialize locales
function DFM_InitializeLocales()
	local DFM_Lang = GetLocale();

	if DFM_Lang == "frFR" then
		DFM_Locale.WELCOME_MESSAGE									= "|cff0066d1%s|r - |cffeb7800%s|r par %s"
		DFM_Locale.BY												= "par %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY							= "Invocation des mascottes favorites uniquement"
		DFM_Locale.SETTINGS_ENABLE_SYNC								= "Autoriser la synchronisation depuis la canal GUILDE, GROUPE et RAID"
		DFM_Locale.SETTINGS_SESSION_DURATION						= "Durée de la promenade (en minutes)"
		DFM_Locale.ERROR_CMD_PARAM_MISSING							= "|cff0066d1%s|r : |cffffffff[/dfm_sync]|r doit être utilisé avec les paramètres suivants : '|cff45f237GUILD|r' (pour la guilde), '|cff37aef2PARTY|r' (pour le groupe) or '|cfff7913cRAID|r' (pour le raid)"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD				= "|cff0066d1%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec la '|cff45f237GUILDE|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY				= "|cff0066d1%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec le '|cff37aef2GROUPE|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID					= "|cff0066d1%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec le groupe de '|cfff7913cRAID|r'"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD							= "|cff0066d1%s|r : Vous devez rejoindre une guilde avant d'utiliser cette commande"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP							= "|cff0066d1%s|r : Vous devez rejoindre un groupe avant d'utiliser cette commande"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID							= "|cff0066d1%s|r : Vous devez rejoindre un groupe de raid avant d'utiliser cette commande"
		DFM_Locale.SYNC_REQUEST_RECEIVED							= "|cff0066d1%s|r : %s veut que tu invoques %s !"
	end
end