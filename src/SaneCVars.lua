local addonName = ...
local frame
local enabled = true
local SetCVar = C_CVar and C_CVar.SetCVar or SetCVar
local RegisterCVar = C_CVar and C_CVar.RegisterCVar or RegisterCVar

local function Init()
	local cvars = {
		-- gfx sharpen
		{ Name = "ResampleAlwaysSharpen", Value = 1 },
		{ Name = "ResampleSharpness", Value = 0 },

		-- nameplates
		{ Name = "nameplateShowEnemyMinions", Value = 0 },
		{ Name = "nameplateShowEnemyMinus", Value = 0 },
		{ Name = "nameplateShowEnemyPets", Value = 1 },
		{ Name = "nameplateShowEnemyGuardians", Value = 1 },
		{ Name = "nameplateShowEnemyTotems", Value = 1 },
		{ Name = "nameplateShowFriendlyMinions", Value = 0 },
		{ Name = "nameplateShowFriendlyMinus", Value = 0 },
		{ Name = "nameplateShowFriendlyPets", Value = 1 },
		{ Name = "nameplateShowFriendlyGuardians", Value = 0 },
		{ Name = "nameplateShowFriendlyTotems", Value = 0 },

		-- don't auto place new spells to action bars
		{ Name = "AutoPushSpellToActionBar", Value = 0 },

		-- hide the "new profession skill" tooltip
		{ Name = "hideHelptips", Value = 1, IsSession = true },

		-- hear more audio events
		{ Name = "Sound_NumChannels", Value = 128 },

		-- class colour unit frames
		{ Name = "raidFramesDisplayClassCOlor", Value = 1 },
		{ Name = "pvpFramesDisplayClassColor", Value = 1 },

		-- disable tutorials
		{ Name = "showTutorials", Value = 0 },

		-- disable error speech
		{ Name = "Sound_EnableErrorSpeech", Value = 0 },

		-- disable pet sounds
		{ Name = "Sound_EnablePetSounds", Value = 0 },

		-- camera zoom
		{ Name = "cameraDistanceMaxZoomFactor", Value = 2.6 },

		-- enable motion sickness setting
		{ Name = "CameraReduceUnexpectedMovement", Value = 1 },

		-- disable sticky select
		{ Name = "deselectOnClick", Value = 1 },

		-- combine bags view
		{ Name = "combinedBags", Value = 1 },

		-- cast on mouseover raid frames and nameplates
		{ Name = "enableMouseoverCast", Value = 1 },

		-- enable target of target frames
		{ Name = "showTargetOfTarget", Value = 1 },
	}

	for _, cvar in ipairs(cvars) do
		local value = enabled and cvar.Value or GetCVarDefaut(cvar.Name)

		if cvar.IsSession then
			RegisterCVar(cvar.Name, value)
		else
			SetCVar(cvar.Name, value)
		end
	end
end

local function OnAddonLoaded(_, _, name)
	if name ~= addonName then
		return
	end

	Init()

	frame:UnregisterEvent("ADDON_LOADED")
end

frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)
