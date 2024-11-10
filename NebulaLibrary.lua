--[[
    Nebula UI Library
    Version: 1.0.0
    Description: Professional Roblox UI library with cross-platform support
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local DEBOUNCE_TIME = 0.1
local INSTANCE_POOL_SIZE = 50
local MOBILE_THRESHOLD = 600
local SNAP_THRESHOLD = 20
local TAB_HEIGHT = 35
local WINDOW_MIN_SIZE = Vector2.new(400, 300)

-- Input Handler
local InputHandler = {
    Connections = {},
    
    Init = function()
        -- Clear existing connections
        for _, connection in pairs(InputHandler.Connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        InputHandler.Connections = {}
        
        -- Set up global input handlers
        table.insert(InputHandler.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                InputHandler.HandleInput(input, true)
            end
        end))
        
        table.insert(InputHandler.Connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if not gameProcessed then
                InputHandler.HandleInput(input, false)
            end
        end))
    end,
    
    HandleInput = function(input, began)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            -- Handle click/touch events
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            -- Handle keyboard events
        end
    end,
    
    Cleanup = function()
        for _, connection in pairs(InputHandler.Connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        InputHandler.Connections = {}
    end
}

-- Config System
local ConfigSystem = {
    Configs = {},
    SavePath = "NebulaConfig",
    
    InitializeConfig = function(configFolder)
        ConfigSystem.SavePath = configFolder
        -- Create config folder if it doesn't exist
        if not isfolder(ConfigSystem.SavePath) then
            makefolder(ConfigSystem.SavePath)
        end
    end,
    
    SaveConfig = function(name, data)
        if not isfolder(ConfigSystem.SavePath) then
            makefolder(ConfigSystem.SavePath)
        end
        
        local success, encoded = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        
        if success then
            writefile(ConfigSystem.SavePath .. "/" .. name .. ".json", encoded)
            return true
        end
        return false
    end,
    
    LoadConfig = function(name)
        local path = ConfigSystem.SavePath .. "/" .. name .. ".json"
        if isfile(path) then
            local success, decoded = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            
            if success then
                return decoded
            end
        end
        return nil
    end,
    
    DeleteConfig = function(name)
        local path = ConfigSystem.SavePath .. "/" .. name .. ".json"
        if isfile(path) then
            delfile(path)
            return true
        end
        return false
    end
}

-- Theme System
local DefaultThemes = {
    Space = {
        Window = {
            Background = Color3.fromRGB(25, 25, 35),
            Border = Color3.fromRGB(60, 60, 80),
            Shadow = Color3.fromRGB(0, 0, 0),
            Gradient = {
                Color3.fromRGB(40, 40, 60),
                Color3.fromRGB(30, 30, 50)
            }
        },
        Elements = {
            Primary = Color3.fromRGB(100, 100, 240),
            Secondary = Color3.fromRGB(80, 80, 200),
            Text = Color3.fromRGB(255, 255, 255),
            Disabled = Color3.fromRGB(60, 60, 80)
        },
        Effects = {
            Ripple = Color3.fromRGB(255, 255, 255),
            Hover = Color3.fromRGB(70, 70, 90)
        }
    },
    Dark = {
        Window = {
            Background = Color3.fromRGB(30, 30, 30),
            Border = Color3.fromRGB(60, 60, 60),
            Shadow = Color3.fromRGB(0, 0, 0),
            Gradient = {
                Color3.fromRGB(40, 40, 40),
                Color3.fromRGB(30, 30, 30)
            }
        },
        Elements = {
            Primary = Color3.fromRGB(0, 255, 128),
            Secondary = Color3.fromRGB(0, 200, 100),
            Text = Color3.fromRGB(255, 255, 255),
            Disabled = Color3.fromRGB(60, 60, 60)
        },
        Effects = {
            Ripple = Color3.fromRGB(255, 255, 255),
            Hover = Color3.fromRGB(50, 50, 50)
        }
    },
    Light = {
        Window = {
            Background = Color3.fromRGB(240, 240, 240),
            Border = Color3.fromRGB(200, 200, 200),
            Shadow = Color3.fromRGB(180, 180, 180),
            Gradient = {
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(240, 240, 240)
            }
        },
        Elements = {
            Primary = Color3.fromRGB(0, 200, 100),
            Secondary = Color3.fromRGB(0, 180, 90),
            Text = Color3.fromRGB(50, 50, 50),
            Disabled = Color3.fromRGB(180, 180, 180)
        },
        Effects = {
            Ripple = Color3.fromRGB(0, 0, 0),
            Hover = Color3.fromRGB(230, 230, 230)
        }
    }
}

-- Animation Presets
local ANIMATION_PRESETS = {
    ButtonPress = {
        Duration = 0.1,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    },
    ButtonHover = {
        Duration = 0.2,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.Out
    },
    ToggleSwitch = {
        Duration = 0.3,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out
    },
    SliderMove = {
        Duration = 0.2,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    },
    WindowSnap = {
        Duration = 0.2,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.Out
    }
}

-- Instance Pool
local InstancePool = {
    Instances = {},
    
    Get = function(self, className)
        if not self.Instances[className] then
            self.Instances[className] = {}
        end
        
        if #self.Instances[className] > 0 then
            return table.remove(self.Instances[className])
        end
        
        return Instance.new(className)
    end,
    
    Return = function(self, instance)
        if not self.Instances[instance.ClassName] then
            self.Instances[instance.ClassName] = {}
        end
        
        if #self.Instances[instance.ClassName] < INSTANCE_POOL_SIZE then
            instance.Parent = nil
            table.insert(self.Instances[instance.ClassName], instance)
        else
            instance:Destroy()
        end
    end
}

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NebulaLibrary"
    self.GUI.ResetOnSpawn = false
    
    -- Create main frame with mobile responsiveness
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = config.Theme.Window.Background
    self.MainFrame.Parent = self.GUI
    
    -- Initialize components
    self:InitializeComponents(config)
    
    -- Initialize dragging
    self:InitializeDragging()
    
    -- Set up window snapping
    self:InitializeSnapping()
    
    -- Set up mobile support
    self:InitializeMobileSupport()
    
    -- Store tabs
    self.Tabs = {}
    
    return self
end

[Previous Window methods implementation remains unchanged]

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Tab.new(config, window)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Theme = window.Theme
    self.Elements = {}
    
    -- Create tab button
    self.Button = Instance.new("TextButton")
    self.Button.Name = config.Name
    self.Button.Size = UDim2.new(1, -10, 0, 30)
    self.Button.Position = UDim2.new(0, 5, 0, #window.Tabs * 35)
    self.Button.BackgroundColor3 = self.Theme.Elements.Secondary
    self.Button.Text = config.Name
    self.Button.TextColor3 = self.Theme.Elements.Text
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextSize = 14
    self.Button.Parent = window.TabContainer
    
    -- Create content container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = config.Name .. "Content"
    self.Container.Size = UDim2.new(1, -20, 1, -20)
    self.Container.Position = UDim2.new(0, 10, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.Elements.Primary
    self.Container.Visible = #window.Tabs == 0
    self.Container.Parent = window.ContentArea
    
    -- Add auto-layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.Container
    
    -- Handle selection
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
    end)
    
    return self
end

[Previous Tab methods implementation remains unchanged]

-- Main Library Interface
local NebulaLib = {
    Windows = {},
    Flags = {},
    Theme = DefaultThemes.Space,
    CustomThemes = {},
    ConfigFolder = "NebulaConfig",
    
    Init = function(self)
        -- Initialize input handling
        InputHandler.Init()
        
        -- Set up auto-save
        if self.SaveConfig then
            RunService.Heartbeat:Connect(function()
                self:SaveAllConfigs()
            end)
        end
        
        return self
    end,
    
    MakeWindow = function(self, config)
        local window = Window.new({
            Name = config.Name or "Nebula Library",
            Theme = self.Theme,
            SaveConfig = config.SaveConfig,
            ConfigFolder = config.ConfigFolder
        })
        
        table.insert(self.Windows, window)
        return window
    end,
    
    SetTheme = function(self, themeName)
        if self.CustomThemes[themeName] then
            self.Theme = self.CustomThemes[themeName]
        elseif DefaultThemes[themeName] then
            self.Theme = DefaultThemes[themeName]
        end
        
        self:UpdateAllWindows()
    end,
    
    RegisterTheme = function(self, name, theme)
        self.CustomThemes[name] = theme
    end,
    
    SaveAllConfigs = function(self)
        if not self.SaveConfig then return end
        
        for _, window in ipairs(self.Windows) do
            local config = {}
            for flag, value in pairs(self.Flags) do
                config[flag] = value.Value
            end
            ConfigSystem.SaveConfig(window.ConfigFolder, config)
        end
    end,
    
    UpdateAllWindows = function(self)
        for _, window in ipairs(self.Windows) do
            -- Update window theme
            window.MainFrame.BackgroundColor3 = self.Theme.Window.Background
            -- Update all elements
            for _, tab in ipairs(window.Tabs) do
                for _, element in ipairs(tab.Elements) do
                    if element.UpdateTheme then
                        element:UpdateTheme(self.Theme)
                    end
                end
            end
        end
    end,
    
    Destroy = function(self)
        InputHandler.Cleanup()
        for _, window in ipairs(self.Windows) do
            window:Destroy()
        end
        self.Windows = {}
        self.Flags = {}
    end
}

return NebulaLib
