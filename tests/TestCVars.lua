-- Init() and OnAddonLoaded are file-local, so these drive the whole thing through ADDON_LOADED
-- and read back what it called on the mocked C_CVar, via tests/Helpers/CVars.lua.

local fw = require("TestFramework")
local CVars = require("CVars")

-- The count of entries in SaneCVars.lua's own cvars list. Keeping this here as a named
-- constant means adding or dropping a cvar without touching this file fails the suite.
local EXPECTED_CVAR_COUNT = 27

local function findCall(calls, name)
	for _, call in ipairs(calls) do
		if call.Name == name then
			return call
		end
	end
end

fw.describe("SaneCVars - applying the list", function()
	fw.it("applies every cvar in the list on ADDON_LOADED", function()
		local env = CVars.Build()

		env.FireAddonLoaded("SaneCVars")

		local total = #env.SetCVarCalls + #env.RegisterCVarCalls
		fw.eq(total, EXPECTED_CVAR_COUNT, "total cvars applied")
	end)

	fw.it("routes the one IsSession entry through RegisterCVar, not SetCVar", function()
		local env = CVars.Build()

		env.FireAddonLoaded("SaneCVars")

		fw.eq(#env.RegisterCVarCalls, 1, "only one cvar is session-registered")

		local call = findCall(env.RegisterCVarCalls, "hideHelptips")

		fw.not_nil(call, "hideHelptips went through RegisterCVar")
		fw.eq(call.Value, 1, "with its listed value")
		fw.is_nil(findCall(env.SetCVarCalls, "hideHelptips"), "and not through SetCVar as well")
	end)

	fw.it("routes every other entry through SetCVar", function()
		local env = CVars.Build()

		env.FireAddonLoaded("SaneCVars")

		fw.eq(#env.SetCVarCalls, EXPECTED_CVAR_COUNT - 1, "every cvar but the session one")

		-- Spot checks across the list rather than repeating all 26 entries here.
		local sharpen = findCall(env.SetCVarCalls, "ResampleAlwaysSharpen")
		fw.not_nil(sharpen, "a gfx cvar reached SetCVar")
		fw.eq(sharpen.Value, 1, "with its listed value")

		local zoom = findCall(env.SetCVarCalls, "cameraDistanceMaxZoomFactor")
		fw.not_nil(zoom, "a non-integer valued cvar reached SetCVar")
		fw.eq(zoom.Value, 2.6, "with its listed value")

		local classColor = findCall(env.SetCVarCalls, "raidFramesDisplayClassColor")
		fw.not_nil(classColor, "the class-colour cvar reached SetCVar")
	end)

	fw.it("ignores ADDON_LOADED for a different addon", function()
		local env = CVars.Build()

		env.FireAddonLoaded("SomeOtherAddon")

		fw.eq(#env.SetCVarCalls, 0, "nothing applied")
		fw.eq(#env.RegisterCVarCalls, 0, "nothing applied")
	end)

	fw.it("unregisters ADDON_LOADED after running, applying the list once", function()
		local env = CVars.Build()

		env.FireAddonLoaded("SaneCVars")
		local firstTotal = #env.SetCVarCalls + #env.RegisterCVarCalls

		env.FireAddonLoaded("SaneCVars")
		local secondTotal = #env.SetCVarCalls + #env.RegisterCVarCalls

		fw.eq(firstTotal, EXPECTED_CVAR_COUNT, "applied once on the first fire")
		fw.eq(secondTotal, firstTotal, "a second ADDON_LOADED for the same addon changes nothing")
	end)
end)
