local ThemeManager = {}

-- Default themes
local DefaultThemes = {
    Space = require(script.Parent.SpaceTheme),
    Dark = {
        WindowBackground = Color3.fromRGB(25, 25, 25),
        TitleBarBackground = Color3.fromRGB(30, 30, 30),
        TitleGradient = {
            Color3.fromRGB(40, 40, 40),
            Color3.fromRGB(30, 30, 30)
        },
        TabContainerBackground = Color3.fromRGB(20, 20, 20),
        ContentBackground = Color3.fromRGB(30, 30, 30),
        ButtonBackground = Color3.fromRGB(45, 45, 45),
        ButtonHover = Color3.fromRGB(55, 55, 55),
        ToggleBackground = Color3.fromRGB(45, 45, 45),
        ToggleEnabled = Color3.fromRGB(0, 255, 128),
        SliderBackground = Color3.fromRGB(45, 45, 45),
        SliderFill = Color3.fromRGB(0, 255, 128),
        TextColor = Color3.fromRGB(255, 255, 255),
        SubTextColor = Color3.fromRGB(180, 180, 180),
        AccentColor = Color3.fromRGB(0, 255, 128)
    },
    Light = {
        WindowBackground = Color3.fromRGB(240, 240, 240),
        TitleBarBackground = Color3.fromRGB(250, 250, 250),
        TitleGradient = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(245, 245, 245)
        },
        TabContainerBackground = Color3.fromRGB(235, 235, 235),
        ContentBackground = Color3.fromRGB(250, 250, 250),
        ButtonBackground = Color3.fromRGB(225, 225, 225),
        ButtonHover = Color3.fromRGB(215, 215, 215),
        ToggleBackground = Color3.fromRGB(225, 225, 225),
        ToggleEnabled = Color3.fromRGB(0, 200, 100),
        SliderBackground = Color3.fromRGB(225, 225, 225),
        SliderFill = Color3.fromRGB(0, 200, 100),
        TextColor = Color3.fromRGB(50, 50, 50),
        SubTextColor = Color3.fromRGB(100, 100, 100),
        AccentColor = Color3.fromRGB(0, 200, 100)
    }
}

local CurrentTheme = "Space"
local CustomThemes = {}

-- Apply theme to a window instance
function ThemeManager.ApplyTheme(window, themeName)
    local theme = CustomThemes[themeName] or DefaultThemes[themeName]
    if not theme then return end
    
    -- Update window components
    window.MainFrame.BackgroundColor3 = theme.WindowBackground
    window.TitleBar.BackgroundColor3 = theme.TitleBarBackground
    window.Title.TextColor3 = theme.TextColor
    window.TabContainer.BackgroundColor3 = theme.TabContainerBackground
    window.TabContent.BackgroundColor3 = theme.ContentBackground
    
    -- Update gradient
    local gradient = window.TitleBar:FindFirstChild("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.TitleGradient[1]),
            ColorSequenceKeypoint.new(1, theme.TitleGradient[2])
        })
    end
    
    -- Update all tabs and their elements
    for _, tab in ipairs(window.Tabs) do
        tab.Button.BackgroundColor3 = theme.ButtonBackground
        tab.Button.TextColor3 = theme.TextColor
        
        -- Update all elements in the tab
        for _, element in ipairs(tab.Elements) do
            if element:IsA("TextButton") then -- Button
                element.BackgroundColor3 = theme.ButtonBackground
                element.TextColor3 = theme.TextColor
            elseif element:IsA("Frame") then -- Toggle, Slider, etc.
                local toggle = element:FindFirstChild("TextButton")
                if toggle then
                    toggle.BackgroundColor3 = theme.ToggleBackground
                end
                
                local slider = element:FindFirstChild("SliderBar")
                if slider then
                    slider.BackgroundColor3 = theme.SliderBackground
                    slider.SliderFill.BackgroundColor3 = theme.SliderFill
                end
                
                local title = element:FindFirstChild("TextLabel")
                if title then
                    title.TextColor3 = theme.TextColor
                end
            end
        end
    end
end

-- Register a new custom theme
function ThemeManager.RegisterTheme(name, theme)
    CustomThemes[name] = theme
end

-- Get current theme name
function ThemeManager.GetCurrentTheme()
    return CurrentTheme
end

-- Set active theme
function ThemeManager.SetTheme(themeName)
    if DefaultThemes[themeName] or CustomThemes[themeName] then
        CurrentTheme = themeName
        return true
    end
    return false
end

-- Get list of available themes
function ThemeManager.GetThemes()
    local themes = {}
    for name, _ in pairs(DefaultThemes) do
        table.insert(themes, name)
    end
    for name, _ in pairs(CustomThemes) do
        table.insert(themes, name)
    end
    return themes
end

return ThemeManager
