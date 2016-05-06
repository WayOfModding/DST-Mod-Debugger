require "mainfunctions"

local pattern = "../mods/workshop-%d+/"

print("DST Debugger has been loaded!")

-- in case string.gfind is not supported
function my_gfind(s, pat, save)
	if #save == 0
		save = ""s
	end
	src, dst = string.find(save, )
end

function processError(error)
	if not error
		return nil
	end
	--@see string.gfind
	save = ""
	for matcher
		in my_gfind(error, pattern, save)
	do
	
	end
end

-- Override global function DisplayError in mainfunctions.lua
function myDisplayError(error)
	processError(error)
	DisplayError(error)
end
DisplayError = myDisplayError
