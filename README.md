# Nebula UI Library
A professional Roblox UI library with cross-platform support, offering a clean and modern interface for both mobile and PC users.

## Features
- Clean and professional design with space/nebula theme
- Cross-platform support (PC and Mobile)
- Draggable windows
- Customizable UI elements
- Smooth animations
- Config saving system

## Installation
```lua
local NebulaLib = loadstring(game:HttpGet('YOUR_RAW_GITHUB_URL'))()
```

## Basic Usage
```lua
-- Create a new window
local Window = NebulaLib:MakeWindow({
    Name = "Nebula Example",
    SaveConfig = true,
    ConfigFolder = "NebulaConfig"
})

-- Create a tab
local Tab = Window:MakeTab({
    Name = "Example Tab",
    Icon = "rbxassetid://4483345998"
})

-- Add elements
Tab:AddButton({
    Name = "Click me!",
    Callback = function()
        print("Button clicked!")
    end
})

Tab:AddToggle({
    Name = "Toggle me!",
    Default = false,
    Callback = function(Value)
        print(Value)
    end
})
```

## Documentation
For detailed documentation and examples, visit [documentation link].

## License
MIT License - feel free to use in your projects.
