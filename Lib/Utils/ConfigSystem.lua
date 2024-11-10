local ConfigSystem = {}

local HttpService = game:GetService("HttpService")

function ConfigSystem.InitializeConfig(configFolder)
    -- Create config folder if it doesn't exist
    if not isfolder(configFolder) then
        makefolder(configFolder)
    end
end

function ConfigSystem.SaveConfig(configFolder, flags)
    local config = {}
    
    -- Convert flags to saveable format
    for flagName, flagData in pairs(flags) do
        if flagData.Save then
            config[flagName] = flagData.Value
        end
    end
    
    -- Generate config name based on game ID
    local gameId = game.GameId
    local configName = string.format("%s/%d.json", configFolder, gameId)
    
    -- Save config to file
    writefile(configName, HttpService:JSONEncode(config))
end

function ConfigSystem.LoadConfig(configFolder, flags)
    -- Generate config name based on game ID
    local gameId = game.GameId
    local configName = string.format("%s/%d.json", configFolder, gameId)
    
    -- Check if config exists
    if not isfile(configName) then
        return
    end
    
    -- Load and parse config
    local success, config = pcall(function()
        return HttpService:JSONDecode(readfile(configName))
    end)
    
    if not success then
        warn("Failed to load config:", config)
        return
    end
    
    -- Apply config values to flags
    for flagName, value in pairs(config) do
        if flags[flagName] and flags[flagName].Set then
            flags[flagName]:Set(value)
        end
    end
end

return ConfigSystem
