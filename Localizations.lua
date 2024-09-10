DFM_Locale = 
{
	["WELCOME_MESSAGE"]								= "|cff20a5f8%s|r - |cffeb7800%s|r by %s",
	["BY"]											= "by %s",
	["SETTINGS_FAVORITE_ONLY"]						= "Summon favorite pets only",
	["SETTINGS_ENABLE_SYNC"]						= "Allow synchronization over GUILD, PARTY and RAID",
	["ERROR_CMD_PARAM_MISSING"]						= "|cff20a5f8%s|r : |cffffffff[/dfm sync]|r must be used with parameter '|cff45f237GUILD|r', '|cff37aef2PARTY|r' or '|cfff7913cRAID|r'",
	["ERROR_SYNC_NOT_ENABLED"]						= "|cff20a5f8%s|r : You need to enable sync to send a sync request",
	["ERROR_SYNC_NOT_SUMMONED_PET_GUILD"]			= "|cff20a5f8%s|r : You need to have a summoned pet to sync pet with '|cff45f237GUILD|r' members",
	["ERROR_SYNC_NOT_SUMMONED_PET_PARTY"]			= "|cff20a5f8%s|r : You need to have a summoned pet to sync pet with '|cff37aef2PARTY|r' members",
	["ERROR_SYNC_NOT_SUMMONED_PET_RAID"]			= "|cff20a5f8%s|r : You need to have a summoned pet to sync pet with '|cfff7913cRAID|r' members",
	["ERROR_SYNC_NOT_IN_GUILD"]						= "|cff20a5f8%s|r : You need to join a guild before using this command",
	["ERROR_SYNC_NOT_IN_GROUP"]						= "|cff20a5f8%s|r : You need to join a party before using this command",
	["ERROR_SYNC_NOT_IN_RAID"]						= "|cff20a5f8%s|r : You need to join a raid before using this command",
	["SYNC_REQUEST_RECEIVED"]						= "|cff20a5f8%s|r : %s wants you to summon %s !",
	["SYNC_REQUEST_FEEDBACK"]						= "|cff20a5f8%s|r : You send a sync request for summon %s !",
	["UNKNOWN_NAME"]								= "an unknown pet... Perhaps it's gone on in vacation ?",
	["LIST_UPDATED"]								= "|cff20a5f8%s|r : Pet list updated !",
	["UNKWOWN_COMMAND"]								= "|cff20a5f8%s|r : Unknown command. Type '|cfff8e620/dfm help|r' for help",
	["HELP"]										= "|cff20a5f8%s|r : commands list :\n|cfff8e620/dfm update|r : force update the pet list\n|cfff8e620/dfm sync guild|r : sync pet with your |cff45f237guild|r\n|cfff8e620/dfm sync party|r : sync pet with your |cff37aef2party|r\n|cfff8e620/dfm sync raid|r : sync pet with your |cfff7913craid|r\n"
};

-- METHOD : Initialize locales
function DFM_InitializeLocales()
	local DFM_Lang = GetLocale();

	if (DFM_Lang == "frFR") then
		DFM_Locale.WELCOME_MESSAGE									= "|cff20a5f8%s|r - |cffeb7800%s|r par %s"
		DFM_Locale.BY												= "par %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY							= "Invocation des mascottes favorites uniquement"
		DFM_Locale.SETTINGS_ENABLE_SYNC								= "Autoriser la synchronisation depuis le canal GUILDE, GROUPE et RAID"
		DFM_Locale.ERROR_CMD_PARAM_MISSING							= "|cff20a5f8%s|r : |cffffffff[/dfm sync]|r doit être utilisé avec les paramètres suivants : '|cff45f237GUILD|r' (pour la guilde), '|cff37aef2PARTY|r' (pour le groupe) or '|cfff7913cRAID|r' (pour le raid)"
		DFM_Locale.ERROR_SYNC_NOT_ENABLED							= "|cff20a5f8%s|r : Vous devez activer la synchronisation pour envoyer une requête"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD				= "|cff20a5f8%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec la '|cff45f237GUILDE|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY				= "|cff20a5f8%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec le '|cff37aef2GROUPE|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID					= "|cff20a5f8%s|r : Vous devez avoir une mascotte invoquée pour la synchroniser avec le groupe de '|cfff7913cRAID|r'"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD							= "|cff20a5f8%s|r : Vous devez rejoindre une guilde avant d'utiliser cette commande"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP							= "|cff20a5f8%s|r : Vous devez rejoindre un groupe avant d'utiliser cette commande"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID							= "|cff20a5f8%s|r : Vous devez rejoindre un groupe de raid avant d'utiliser cette commande"
		DFM_Locale.SYNC_REQUEST_RECEIVED							= "|cff20a5f8%s|r : %s veut que tu invoques %s !"
		DFM_Locale.SYNC_REQUEST_FEEDBACK							= "|cff20a5f8%s|r : Requête envoyée pour invoquer %s !"
		DFM_Locale.UNKNOWN_NAME										= "une mascotte inconnue... Peut-être est-elle partie en voyage ?"
		DFM_Locale.LIST_UPDATED										= "|cff20a5f8%s|r : Liste de mascottes mise à jour !"
		DFM_Locale.UNKWOWN_COMMAND									= "|cff20a5f8%s|r : Commande inconnue. Tapez '|cfff8e620/dfm help|r' pour obtenir de l'aide"
		DFM_Locale.HELP												= "|cff20a5f8%s|r : Liste des commandes :\n|cfff8e620/dfm update|r : force la mise à jour de la liste des mascottes\n|cfff8e620/dfm sync guild|r : synchronise votre mascotte avec votre |cff45f237guilde|r\n|cfff8e620/dfm sync party|r : synchronise votre mascotte avec votre |cff37aef2groupe|r\n|cfff8e620/dfm sync raid|r : synchronise votre mascotte avec votre |cfff7913craid|r\n"
	elseif (DFM_Lang == "deDE") then
		DFM_Locale.WELCOME_MESSAGE 									= "|cff20a5f8%s|r - |cffeb7800%s|r von %s"
		DFM_Locale.BY 												= "von %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY 							= "Nur Lieblingshaustiere beschwören"
		DFM_Locale.SETTINGS_ENABLE_SYNC 							= "Synchronisierung über GUILD-, PARTY- oder RAID-Kanal erlauben"
		DFM_Locale.ERROR_CMD_PARAM_MISSING 							= "|cff20a5f8%s|r: |cffffffff[/dfm sync]|r muss mit den folgenden Parametern verwendet werden: '|cff45f237GUILD|r' (für die Gilde), '|cff37aef2PARTY|r' (für die Gruppe) oder '|cfff7913cRAID|r' (für den Raid)"
		DFM_Locale.ERROR_SYNC_NOT_ENABLED 							= "|cff20a5f8%s|r: Du musst die Synchronisierung aktivieren, um eine Anfrage zu senden"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD 				= "|cff20a5f8%s|r: Du musst ein beschworenes Haustier haben, um es mit der '|cff45f237GUILD|r' zu synchronisieren"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY 				= "|cff20a5f8%s|r: Du musst ein beschworenes Haustier haben, um es mit der '|cff37aef2PARTY|r' zu synchronisieren"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID 				= "|cff20a5f8%s|r: Du musst ein beschworenes Haustier haben, um es mit der '|cfff7913cRAID|r'-Gruppe zu synchronisieren"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD 							= "|cff20a5f8%s|r: Du musst einer Gilde beitreten, bevor du diesen Befehl verwenden kannst"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP 							= "|cff20a5f8%s|r: Du musst einer Gruppe beitreten, bevor du diesen Befehl verwenden kannst"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID 							= "|cff20a5f8%s|r: Du musst einer Raid-Gruppe beitreten, bevor du diesen Befehl verwenden kannst"
		DFM_Locale.SYNC_REQUEST_RECEIVED 							= "|cff20a5f8%s|r: %s möchte, dass du %s beschwörst!"
		DFM_Locale.SYNC_REQUEST_FEEDBACK 							= "|cff20a5f8%s|r: Anfrage zum Beschwören von %s gesendet!"
		DFM_Locale.UNKNOWN_NAME										= "ein unbekanntes Haustier... Vielleicht ist es auf Reisen?"
		DFM_Locale.LIST_UPDATED 									= "|cff20a5f8%s|r: Haustierliste aktualisiert!"
		DFM_Locale.UNKWOWN_COMMAND 									= "|cff20a5f8%s|r: Unbekannter Befehl. Tippe '|cfff8e620/dfm help|r', um Hilfe zu erhalten"
		DFM_Locale.HELP 											= "|cff20a5f8%s|r: Befehlsübersicht:\n|cfff8e620/dfm update|r: aktualisiert die Haustierliste\n|cfff8e620/dfm sync guild|r: synchronisiert dein Haustier mit deiner |cff45f237Gilde|r\n|cfff8e620/dfm sync party|r: synchronisiert dein Haustier mit deiner |cff37aef2Gruppe|r\n|cfff8e620/dfm sync raid|r: synchronisiert dein Haustier mit deinem |cfff7913cRaid|r\n"
	elseif ((DFM_Lang == "esES")  or (DFM_Lang == "esMX")) then
		DFM_Locale.WELCOME_MESSAGE 									= "|cff20a5f8%s|r - |cffeb7800%s|r por %s"
		DFM_Locale.BY 												= "por %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY 							= "Invocación solo de mascotas favoritas"
		DFM_Locale.SETTINGS_ENABLE_SYNC 							= "Permitir sincronización desde el canal GUILD, PARTY o RAID"
		DFM_Locale.ERROR_CMD_PARAM_MISSING 							= "|cff20a5f8%s|r: |cffffffff[/dfm sync]|r debe ser usado con los siguientes parámetros: '|cff45f237GUILD|r' (para la guild), '|cff37aef2PARTY|r' (para el grupo) o '|cfff7913cRAID|r' (para el raid)"
		DFM_Locale.ERROR_SYNC_NOT_ENABLED 							= "|cff20a5f8%s|r: Debes habilitar la sincronización para enviar una solicitud"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD 				= "|cff20a5f8%s|r: Debes tener una mascota invocada para sincronizarla con la '|cff45f237GUILD|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY 				= "|cff20a5f8%s|r: Debes tener una mascota invocada para sincronizarla con el '|cff37aef2PARTY|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID 				= "|cff20a5f8%s|r: Debes tener una mascota invocada para sincronizarla con el grupo de '|cfff7913cRAID|r'"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD 							= "|cff20a5f8%s|r: Debes unirte a una guild antes de usar este comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP 							= "|cff20a5f8%s|r: Debes unirte a un grupo antes de usar este comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID 							= "|cff20a5f8%s|r: Debes unirte a un grupo de raid antes de usar este comando"
		DFM_Locale.SYNC_REQUEST_RECEIVED 							= "|cff20a5f8%s|r: %s quiere que invoques a %s!"
		DFM_Locale.SYNC_REQUEST_FEEDBACK							= "|cff20a5f8%s|r: ¡Solicitud enviada para invocar a %s!"
		DFM_Locale.UNKNOWN_NAME 									= "una mascota desconocida... ¿Quizás se ha ido de viaje?"
		DFM_Locale.LIST_UPDATED 									= "|cff20a5f8%s|r: ¡Lista de mascotas actualizada!"
		DFM_Locale.UNKWOWN_COMMAND 									= "|cff20a5f8%s|r: Comando desconocido. Escribe '|cfff8e620/dfm help|r' para obtener ayuda"
		DFM_Locale.HELP 											= "|cff20a5f8%s|r: Lista de comandos:\n|cfff8e620/dfm update|r: actualiza la lista de mascotas\n|cfff8e620/dfm sync guild|r: sincroniza tu mascota con tu |cff45f237guild|r\n|cfff8e620/dfm sync party|r: sincroniza tu mascota con tu |cff37aef2grupo|r\n|cfff8e620/dfm sync raid|r: sincroniza tu mascota con tu |cfff7913craid|r\n"
	elseif (DFM_Lang == "ptBR") then
		DFM_Locale.WELCOME_MESSAGE									= "|cff20a5f8%s|r - |cffeb7800%s|r por %s"
		DFM_Locale.BY 												= "por %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY 							= "Invocar apenas mascotes favoritas"
		DFM_Locale.SETTINGS_ENABLE_SYNC 							= "Permitir sincronização através dos canais GUILD, PARTY ou RAID"
		DFM_Locale.ERROR_CMD_PARAM_MISSING 							= "|cff20a5f8%s|r: |cffffffff[/dfm sync]|r deve ser usado com os seguintes parâmetros: '|cff45f237GUILD|r' (para a guilda), '|cff37aef2PARTY|r' (para o grupo) ou '|cfff7913cRAID|r' (para o raid)"
		DFM_Locale.ERROR_SYNC_NOT_ENABLED 							= "|cff20a5f8%s|r: Você precisa ativar a sincronização para enviar uma solicitação"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD 				= "|cff20a5f8%s|r: Você deve ter uma mascote invocada para sincronizá-la com a '|cff45f237GUILD|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY 				= "|cff20a5f8%s|r: Você deve ter uma mascote invocada para sincronizá-la com o '|cff37aef2PARTY|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID 				= "|cff20a5f8%s|r: Você deve ter uma mascote invocada para sincronizá-la com o grupo de '|cfff7913cRAID|r'"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD 							= "|cff20a5f8%s|r: Você deve entrar em uma guilda antes de usar este comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP 							= "|cff20a5f8%s|r: Você deve entrar em um grupo antes de usar este comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID 							= "|cff20a5f8%s|r: Você deve entrar em um grupo de raid antes de usar este comando"
		DFM_Locale.SYNC_REQUEST_RECEIVED 							= "|cff20a5f8%s|r: %s quer que você invoque %s!"
		DFM_Locale.SYNC_REQUEST_FEEDBACK 							= "|cff20a5f8%s|r: Solicitação enviada para invocar %s!"
		DFM_Locale.UNKNOWN_NAME 									= "uma mascote desconhecida... Talvez tenha saído para uma aventura?"
		DFM_Locale.LIST_UPDATED 									= "|cff20a5f8%s|r: Lista de mascotes atualizada!"
		DFM_Locale.UNKWOWN_COMMAND 									= "|cff20a5f8%s|r: Comando desconhecido. Digite '|cfff8e620/dfm help|r' para obter ajuda"
		DFM_Locale.HELP 											= "|cff20a5f8%s|r: Lista de comandos:\n|cfff8e620/dfm update|r: força a atualização da lista de mascotes\n|cfff8e620/dfm sync guild|r: sincroniza sua mascote com sua |cff45f237guilda|r\n|cfff8e620/dfm sync party|r: sincroniza sua mascote com seu |cff37aef2grupo|r\n|cfff8e620/dfm sync raid|r: sincroniza sua mascote com seu |cfff7913craid|r\n"
	elseif (DFM_Lang == "itIT") then
		DFM_Locale.WELCOME_MESSAGE 									= "|cff20a5f8%s|r - |cffeb7800%s|r di %s"
		DFM_Locale.BY 												= "di %s"
		DFM_Locale.SETTINGS_FAVORITE_ONLY 							= "Evoca solo mascotte preferite"
		DFM_Locale.SETTINGS_ENABLE_SYNC 							= "Consenti sincronizzazione tramite i canali GUILD, PARTY o RAID"
		DFM_Locale.ERROR_CMD_PARAM_MISSING 							= "|cff20a5f8%s|r: |cffffffff[/dfm sync]|r deve essere utilizzato con i seguenti parametri: '|cff45f237GUILD|r' (per la gilda), '|cff37aef2PARTY|r' (per il gruppo) o '|cfff7913cRAID|r' (per il raid)"
		DFM_Locale.ERROR_SYNC_NOT_ENABLED 							= "|cff20a5f8%s|r: Devi attivare la sincronizzazione per inviare una richiesta"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_GUILD 				= "|cff20a5f8%s|r: Devi avere una mascotte evocata per sincronizzarla con la '|cff45f237GUILD|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_PARTY 				= "|cff20a5f8%s|r: Devi avere una mascotte evocata per sincronizzarla con il '|cff37aef2PARTY|r'"
		DFM_Locale.ERROR_SYNC_NOT_SUMMONED_PET_RAID					= "|cff20a5f8%s|r: Devi avere una mascotte evocata per sincronizzarla con il gruppo di '|cfff7913cRAID|r'"
		DFM_Locale.ERROR_SYNC_NOT_IN_GUILD 							= "|cff20a5f8%s|r: Devi essere in una gilda prima di usare questo comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_GROUP 							= "|cff20a5f8%s|r: Devi essere in un gruppo prima di usare questo comando"
		DFM_Locale.ERROR_SYNC_NOT_IN_RAID 							= "|cff20a5f8%s|r: Devi essere in un gruppo di raid prima di usare questo comando"
		DFM_Locale.SYNC_REQUEST_RECEIVED 							= "|cff20a5f8%s|r: %s vuole che tu evochi %s!"
		DFM_Locale.SYNC_REQUEST_FEEDBACK 							= "|cff20a5f8%s|r: Richiesta inviata per evocare %s!"
		DFM_Locale.UNKNOWN_NAME 									= "una mascotte sconosciuta... Forse è partita per un'avventura?"
		DFM_Locale.LIST_UPDATED 									= "|cff20a5f8%s|r: Lista delle mascotte aggiornata!"
		DFM_Locale.UNKWOWN_COMMAND 									= "|cff20a5f8%s|r: Comando sconosciuto. Digita '|cfff8e620/dfm help|r' per ottenere aiuto"
		DFM_Locale.HELP 											= "|cff20a5f8%s|r: Elenco comandi:\n|cfff8e620/dfm update|r: forza l'aggiornamento della lista delle mascotte\n|cfff8e620/dfm sync guild|r: sincronizza la tua mascotte con la tua |cff45f237gilda|r\n|cfff8e620/dfm sync party|r: sincronizza la tua mascotte con il tuo |cff37aef2gruppo|r\n|cfff8e620/dfm sync raid|r: sincronizza la tua mascotte con il tuo |cfff7913craid|r\n"
	end
end