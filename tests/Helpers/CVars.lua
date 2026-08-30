-- SaneCVars caches C_CVar.SetCVar and RegisterCVar into file-local variables the moment the
-- file loads, so the recording stubs have to be in place before the addon loads. AddonHarness
-- .Load bundles the mock install and the file load into one call, so this replicates those two
-- steps itself with an override in between, the way AddonHarness.LoadFiles is meant to be used.

local harness = require("AddonHarness")
local Toc = require("Toc")
local WowMock = require("WowMock")

local M = {}

---Loads SaneCVars with C_CVar.SetCVar/RegisterCVar replaced by recorders.
---@return table env
function M.Build()
	local toc = Toc.Parse(Toc.Find("SaneCVars"))

	WowMock.Install()

	local env = {
		Toc = toc,
		Mock = WowMock,
		SetCVarCalls = {},
		RegisterCVarCalls = {},
	}

	_G.C_CVar.SetCVar = function(name, value)
		env.SetCVarCalls[#env.SetCVarCalls + 1] = { Name = name, Value = value }
	end

	_G.C_CVar.RegisterCVar = function(name, value)
		env.RegisterCVarCalls[#env.RegisterCVarCalls + 1] = { Name = name, Value = value }
	end

	local addonTable = {}

	env.Addon = addonTable
	env.Loaded = harness.LoadFiles("SaneCVars", toc.Files, addonTable)

	function env.FireAddonLoaded(name)
		return WowMock.FireEvent("ADDON_LOADED", name)
	end

	return env
end

return M
