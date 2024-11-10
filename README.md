# Nebula UI Library

A unified cross-platform Roblox UI library providing core interface components and window management functionality. The library implements window management, tab systems, standard UI controls, notifications, configuration persistence, and animation presets with optimized initialization order.

## Features

- Window and tab management system
- UI controls (buttons, toggles, sliders, textboxes)
- Theme management with default and custom theme support
- Notification system with animated transitions
- Animation presets and tweening system
- Configuration saving functionality
- Cross-platform compatibility (PC and Mobile)

## Installation

```lua
local NebulaLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/remoDevv/nebula-ui/main/NebulaLibrary.lua'))()
```

## Basic Usage

```lua
-- Create main window
local Window = NebulaLib:MakeWindow({
    Name = "Nebula Demo",
    SaveConfig = true,
    ConfigFolder = "NebulaConfig"
})

-- Create a tab
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998"
})

-- Add elements
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

-- Initialize the library
NebulaLib:Init()
```

## Themes

The library comes with three built-in themes:
- Space (Default)
- Dark
- Light

You can switch themes using:
```lua
NebulaLib:SetTheme("Dark")
```

Or create custom themes:
```lua
NebulaLib:RegisterTheme("Custom", {
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
    }
})
```

## License

MIT License - See LICENSE file for details.
