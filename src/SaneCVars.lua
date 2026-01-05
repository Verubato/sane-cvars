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

		-- misc
		{ Name = "AutoPushSpellToActionBar", Value = 0 },
		{ Name = "hideHelptips", Value = 1, IsSession = true },
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
