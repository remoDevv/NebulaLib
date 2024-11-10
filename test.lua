-- Initialize the library
local NebulaLib = loadstring(game:HttpGet('YOUR_RAW_GITHUB_URL'))()

-- Create main window
local Window = NebulaLib:MakeWindow({
    Name = "Nebula Library Demo",
    SaveConfig = true,
    ConfigFolder = "NebulaDemo"
})

-- Create tabs
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998"
})

local ThemeTab = Window:MakeTab({
    Name = "Themes",
    Icon = "rbxassetid://4483345998"
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998"
})

-- Add theme selector to Theme tab
local themes = NebulaLib:GetAvailableThemes()
ThemeTab:AddDropdown({
    Name = "Select Theme",
    Default = NebulaLib:GetCurrentTheme(),
    Options = themes,
    Callback = function(Value)
        NebulaLib:SetTheme(Value)
    end
})

-- Add custom theme example
NebulaLib:RegisterTheme("Custom", {
    WindowBackground = Color3.fromRGB(35, 35, 45),
    TitleBarBackground = Color3.fromRGB(40, 40, 50),
    TitleGradient = {
        Color3.fromRGB(50, 50, 60),
        Color3.fromRGB(40, 40, 50)
    },
    TabContainerBackground = Color3.fromRGB(30, 30, 40),
    ContentBackground = Color3.fromRGB(40, 40, 50),
    ButtonBackground = Color3.fromRGB(55, 55, 65),
    ButtonHover = Color3.fromRGB(65, 65, 75),
    ToggleBackground = Color3.fromRGB(55, 55, 65),
    ToggleEnabled = Color3.fromRGB(130, 200, 255),
    SliderBackground = Color3.fromRGB(55, 55, 65),
    SliderFill = Color3.fromRGB(130, 200, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(200, 200, 200),
    AccentColor = Color3.fromRGB(130, 200, 255)
})

-- Add elements to Main tab
MainTab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:AddToggle({
    Name = "Toggle Feature",
    Default = false,
    Save = true,
    Flag = "mainToggle",
    Callback = function(Value)
        print("Toggle is now: " .. tostring(Value))
    end
})

MainTab:AddSlider({
    Name = "Speed Adjustment",
    Min = 0,
    Max = 100,
    Default = 50,
    Save = true,
    Flag = "speedSlider",
    Callback = function(Value)
        print("Speed set to: " .. tostring(Value))
    end
})

-- Add elements to Settings tab
SettingsTab:AddToggle({
    Name = "Enable Notifications",
    Default = true,
    Save = true,
    Flag = "notifyToggle",
    Callback = function(Value)
        if Value then
            NebulaLib:MakeNotification({
                Name = "Notifications Enabled",
                Content = "You will now receive notifications",
                Time = 5
            })
        end
    end
})

-- Show welcome notification
NebulaLib:MakeNotification({
    Name = "Welcome!",
    Content = "Thanks for trying Nebula Library",
    Time = 5
})

-- Initialize the library
NebulaLib:Init()
