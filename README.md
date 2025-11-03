# BASF-SDK
BASF-SDK is an open-source library. Is it created for make an exploiting software/script for [BASF](https://www.roblox.com/games/4435144047/) easier.

Preston, please don't take this repo down. :sob::pray:
### Install
```luau
local BASF do
    BASF = {}

    local Attempt = 0
    repeat
        local Code = nil

        local Success, Result = pcall( function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/Conesquarewad/BASF-SDK/refs/heads/main/Source.luau")

            if Source then
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

### Example
```luau
local BASF do
    BASF = {}

    local Attempt = 0
    repeat
        local Code = nil

        local Success, Result = pcall( function()
            local Source = game:HttpGet("https://raw.githubusercontent.com/Conesquarewad/BASF-SDK/refs/heads/main/Source.luau")

            if Source then
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

BASF.Execute("Claim 5")
```
There is no wiki for this repo, so you will have to learn it yourself.
