local _, namespace = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

namespace.L = L

local LOCALE = GetLocale()

if LOCALE == "enUS" then
	L["LOADED"] = "loaded";
	L["ASKS"] = "asks ";
	L["TO_COME"] = " to come";
	L["HUMANOID"] = ". Let's go for a new adventure. ";
	L["DRAGONKIN"] = ". A dragon roars away... ";
	L["FLYING"] = ". The wind starts to blow... ";
	L["UNDEAD"] = ". A putrid smell appears... ";
	L["CRITTER"] = " and pushes an almost unbearable high-pitched moan ! ";
	L["MAGIC"] = ". A strange arcane power surrounds it. ";
	L["ELEMENTAL"] = ". The earth is roaring ! ";
	L["BEAST"] = ". The beast looks happy to get some fresh air ! ";
	L["AQUATIC"] = " and gets water in the face ! ";
	L["MECHANICAL"] = ". A few cogs fall to the ground... ";
	L["GENDER_M"] = "him";
	L["GENDER_F"] = "her";
	L["FAVORITE_1"] = " is happy to see ";
	L["FAVORITE_2"] = " again !! ";
return end

if LOCALE == "frFR" then
	L["LOADED"] = "chargé";
	L["ASKS"] = "demande à ";
	L["TO_COME"] = " de venir";
	L["HUMANOID"] = ". En avant pour une nouvelle aventure. ";
	L["DRAGONKIN"] = ". Un dragon rugit au loin... ";
	L["FLYING"] = ". Le vent se met à souffler... ";
	L["UNDEAD"] = ". Une odeur putride apparait... ";
	L["CRITTER"] = " et pousse un gémissement aigüe presque insupportable ! ";
	L["MAGIC"] = ". Une étrange puissance arcanique l'entoure. ";
	L["ELEMENTAL"] = ". La terre gronde ! ";
	L["BEAST"] = ". La bête à l'air heureuse de prendre l'air ! ";
	L["AQUATIC"] = " et reçoit de l'eau dans la figure ! ";
	L["MECHANICAL"] = ". Quelques rouages tombent au sol... ";
	L["FAVORITE"] = " semble heureux ";
	L["GENDER_M"] = "le";
	L["GENDER_F"] = "la";
	L["FAVORITE_1"] = " est heureux de ";
	L["FAVORITE_2"] = " revoir !! ";
return end