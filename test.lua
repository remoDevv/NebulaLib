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

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998"
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
