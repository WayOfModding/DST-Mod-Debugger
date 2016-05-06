GLOBAL.require("mainfunctions")

local pattern = "%.%./mods/(workshop-%d+)/"

print("DST Debugger has been loaded!")

-- in case string.gfind is not supported
function myfind(s, pat)
	if string.gfind then
		return string.gfind(s, pat)
	elseif string.gmatch then
		return string.gmatch(s,pat)
	else
		return nil
	end
end

function processError(error)
	if not error then
		return nil
	end
	
	local result = ""

	-- retrieve mod name
	for modname
	in myfind(error, pattern)
	do
		print("[Debugger-master]: Bad mod detected, disabling...")
		GLOBAL.KnownModIndex:Disable(modname)
		print("[Debugger-master]: Done. Marking disabled_bad...")
		GLOBAL.KnownModIndex.savedata.known_mods[modname].disabled_bad = true
		print("[Debugger-master]: Done.")
		result = result.."\""..KnownModIndex:GetModFancyName(modname).."\" "
	end

	return result
end

-- Override global function DisplayError in mainfunctions.lua
function myDisplayError(error)

    SetPause(true,"DisplayError")
    if global_error_widget ~= nil then
        return nil
    end

    print (error) -- Failsafe since sometimes the error screen is no shown
	
	local modnamesstr = processError(error)

    local modnames = ModManager:GetEnabledModNames()

    if #modnames > 0 then
		--[[
        for k,modname in ipairs(modnames) do
            modnamesstr = modnamesstr.."\""..KnownModIndex:GetModFancyName(modname).."\" "
        end
		--]]
		-- Instead of displaying all possible mods, only display bad mod detected by function processError

        local buttons = nil
        if PLATFORM ~= "PS4" then
            buttons = {
                {text=STRINGS.UI.MAINSCREEN.SCRIPTERRORQUIT, cb = function() TheSim:ForceAbort() end},
                {text="Mainscreen", cb = function()
                                                            --KnownModIndex:DisableAllMods()
                                                            ForceAssetReset()
                                                            KnownModIndex:Save(function()
                                                                SimReset()
                                                            end)
                                                        end},
                {text=STRINGS.UI.MAINSCREEN.MODFORUMS, nopop=true, cb = function()
				VisitURL("http://forums.kleientertainment.com/index.php?/forum/26-dont-starve-mods-and-tools/") end }
            }
        end
        SetGlobalErrorWidget(
                STRINGS.UI.MAINSCREEN.MODFAILTITLE,
                error,
                buttons,
                ANCHOR_LEFT,
                STRINGS.UI.MAINSCREEN.SCRIPTERRORMODWARNING..modnamesstr,
                20
                )
    else
        local buttons = nil

        -- If we know what happened, display a better message for the user
        local known_error = known_error_key ~= nil and ERRORS[known_error_key] or nil
        if known_error ~= nil then
            error = known_error.message
        end

        if PLATFORM ~= "PS4" then
            buttons = {
                {text=STRINGS.UI.MAINSCREEN.SCRIPTERRORQUIT, cb = function() TheSim:ForceAbort() end},
            }

            if known_error_key == nil or ERRORS[known_error_key] == nil then
                table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.ISSUE, nopop=true, cb = function() VisitURL("http://forums.kleientertainment.com/klei-bug-tracker/dont-starve-together/") end })
            else
                table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.GETHELP, nopop=true, cb = function() VisitURL(known_error.url) end })
            end
        end

        SetGlobalErrorWidget(
                STRINGS.UI.MAINSCREEN.MODFAILTITLE,
                error,
                buttons,
                known_error ~= nil and ANCHOR_MIDDLE or ANCHOR_LEFT,
                nil,
                known_error ~= nil and 30 or 20
                )
    end
end

DisplayError = myDisplayError
