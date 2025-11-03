# BASF-SDK
BASF-SDK is an open-source library. Is it created for make an exploit software/script for [BASF](https://www.roblox.com/games/4435144047/) easier

### Install
```luau
local BASF do
    BASF = {}

    local Attempt = 0
    repeat
        local Code = nil

        local Success, Result = pcall( function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/Conesquarewad/BASF-SDK/refs/heads/main/Source.lua")

            if Soruce then
                Code = loadstring( Source )
            end
        end)

        if Success then
            if Code then
                BASF = Code()
            end

            break
        else
            Attempt = Attempt + 1
        end
    until Attempt > 3

    if Attempt > 3 then
        warn("Failed to load module")
    end
end
```

# Usage
You can learn more from this wiki
