local Tab = {}
Tab.__index = Tab

local Elements = require(script.Parent.Elements)
local Tweens = require(script.Parent.Parent.Utils.Tweens)

function Tab.new(config, window)
    local self = setmetatable({}, Tab)
    
    -- Store references
    self.Window = window
    self.Theme = window.Theme
    self.Elements = {}
    
    -- Create tab button with icon support
    self.Button = Instance.new("TextButton")
    self.Button.Name = config.Name
    self.Button.Size = UDim2.new(1, -10, 0, 30)
    self.Button.Position = UDim2.new(0, 5, 0, #window.Tabs * 35)
    self.Button.BackgroundColor3 = self.Theme.ButtonBackground
    self.Button.Text = config.Name
    self.Button.TextColor3 = self.Theme.TextColor
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextSize = 14
    self.Button.Parent = window.TabContainer
    
    -- Add icon if provided
    if config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 5, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = config.Icon
        icon.Parent = self.Button
        
        -- Adjust text position
        self.Button.TextXAlignment = Enum.TextXAlignment.Right
        self.Button.Text = "  " .. config.Name
    end
    
    -- Create content container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = config.Name .. "Content"
    self.Container.Size = UDim2.new(1, -20, 1, -20)
    self.Container.Position = UDim2.new(0, 10, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.AccentColor
    self.Container.Visible = #window.Tabs == 0
    self.Container.Parent = window.TabContent
    
    -- Create auto-layout for elements
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 5)
    self.UIListLayout.Parent = self.Container
    
    -- Handle tab selection
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
    end)
    
    -- Update canvas size when elements are added
    self.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self:UpdateCanvasSize()
    end)
    
    return self
end

function Tab:Select()
    -- Hide all other tabs
    for _, tab in ipairs(self.Window.Tabs) do
        tab.Container.Visible = false
        tab.Button.BackgroundColor3 = self.Theme.ButtonBackground
    end
    
    -- Show this tab
    self.Container.Visible = true
    self.Button.BackgroundColor3 = self.Theme.ButtonHover
end

-- Add all the UI element creation functions
function Tab:AddButton(config)
    local button = Elements.CreateButton(config, self)
    button.Parent = self.Container
    table.insert(self.Elements, button)
    self:UpdateCanvasSize()
    return button
end

function Tab:AddToggle(config)
    local toggle = Elements.CreateToggle(config, self)
    toggle.Parent = self.Container
    table.insert(self.Elements, toggle)
    self:UpdateCanvasSize()
    return toggle
end

function Tab:AddSlider(config)
    local slider = Elements.CreateSlider(config, self)
    slider.Parent = self.Container
    table.insert(self.Elements, slider)
    self:UpdateCanvasSize()
    return slider
end

function Tab:AddTextbox(config)
    local textbox = Elements.CreateTextbox(config, self)
    textbox.Parent = self.Container
    table.insert(self.Elements, textbox)
    self:UpdateCanvasSize()
    return textbox
end

function Tab:UpdateCanvasSize()
    local contentSize = self.UIListLayout.AbsoluteContentSize
    self.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
end

return Tab
