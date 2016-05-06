require "mainfunctions"

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

  -- retrieve mod name
  for modname
  in myfind(error, pattern)
  do
  end
  
  return nil
end

-- Override global function DisplayError in mainfunctions.lua
function myDisplayError(error)
  processError(error)
  DisplayError(error)
end
DisplayError = myDisplayError
