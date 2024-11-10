local OrionLib = {}
OrionLib.__index = OrionLib

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Components
local Window = require(script.Components.Window)
local Elements = require(script.Components.Elements)
local SpaceTheme = require(script.Themes.SpaceTheme)
local InputHandler = require(script.Utils.InputHandler)
local ConfigSystem = require(script.Utils.ConfigSystem)

-- Properties
OrionLib.Windows = {}
OrionLib.Flags = {}
OrionLib.Theme = SpaceTheme

function OrionLib.new()
    local self = setmetatable({}, OrionLib)
    self.Initialized = false
    return self
end

function OrionLib:MakeWindow(config)
    assert(type(config) == "table", "Config must be a table!")
    
    local windowConfig = {
        Name = config.Name or "Orion Library",
        Theme = self.Theme,
        HidePremium = config.HidePremium or false,
        SaveConfig = config.SaveConfig or false,
        ConfigFolder = config.ConfigFolder or "OrionConfig"
    }
    
    local newWindow = Window.new(windowConfig)
    table.insert(self.Windows, newWindow)
    
    if config.SaveConfig then
        ConfigSystem.InitializeConfig(config.ConfigFolder)
    end
    
    return newWindow
end

function OrionLib:MakeNotification(config)
    assert(type(config) == "table", "Config must be a table!")
    
    local notification = Elements.CreateNotification(config)
    return notification
end

function OrionLib:Init()
    if self.Initialized then return end
    
    -- Initialize input handling
    InputHandler.Init()
    
    -- Load saved configs if any
    if self.SaveConfig then
        ConfigSystem.LoadConfigs()
    end
    
    self.Initialized = true
end

function OrionLib:Destroy()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    
    self.Windows = {}
    self.Flags = {}
    self.Initialized = false
end

return OrionLib
