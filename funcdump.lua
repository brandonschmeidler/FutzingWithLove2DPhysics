-- This file is just a place to put functions when I have nowhere to put them
function string_to_function(text)
    local func = assert(loadstring(text))
    if (func) then return func end

    return nil
end