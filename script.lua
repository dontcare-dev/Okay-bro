-- [[ Velarium.dev.scr Universal Loader ]] --
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/dontcare-dev/Okay-bro/main/script.lua", true)
end)

if success then
    local load_func, err = loadstring(result)
    if load_func then
        load_func()
    else
        warn("Velarium Error (Loadstring): " .. tostring(err))
    end
else
    warn("Velarium Error (HTTP): " .. tostring(result))
    -- Fallback for executors that hate the 'true' argument
    local fallback = game:HttpGet("https://raw.githubusercontent.com/dontcare-dev/Okay-bro/main/script.lua")
    loadstring(fallback)()
end
