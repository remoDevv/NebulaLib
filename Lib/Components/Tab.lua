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
    
    -- Create tab button
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
    
    -- Create content container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = config.Name .. "Content"
    self.Container.Size = UDim2.new(1, -20, 1, -20)
    self.Container.Position = UDim2.new(0, 10, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Theme.AccentColor
    self.Container.Visible = #window.Tabs == 0 -- Show first tab by default
    self.Container.Parent = window.TabContent
    
    -- Create auto-layout for elements
    self.UIListLayout = Instance.new("UIListLayout")
    self.UIListLayout.Padding = UDim.new(0, 5)
    self.UIListLayout.Parent = self.Container
    
    -- Handle tab selection
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
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

function Tab:AddSection(config)
    local section = Instance.new("Frame")
    section.Name = config.Name
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = config.Name
    title.TextColor3 = self.Theme.SubTextColor
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section
    
    section.Parent = self.Container
    
    -- Return the section for chaining
    return {
        AddButton = function(_, buttonConfig)
            return self:AddButton(buttonConfig)
        end,
        AddToggle = function(_, toggleConfig)
            return self:AddToggle(toggleConfig)
        end,
        AddSlider = function(_, sliderConfig)
            return self:AddSlider(sliderConfig)
        end
    }
end

function Tab:AddButton(config)
    local button = Elements.CreateButton(config, self)
    button.Parent = self.Container
    table.insert(self.Elements, button)
    return button
end

function Tab:AddToggle(config)
    local toggle = Elements.CreateToggle(config, self)
    toggle.Parent = self.Container
    table.insert(self.Elements, toggle)
    return toggle
end

function Tab:AddSlider(config)
    local slider = Elements.CreateSlider(config, self)
    slider.Parent = self.Container
    table.insert(self.Elements, slider)
    return slider
end

function Tab:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Theme.TextColor
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Container
    
    table.insert(self.Elements, label)
    return label
end

function Tab:AddParagraph(title, content)
    local paragraph = Instance.new("Frame")
    paragraph.Size = UDim2.new(1, -20, 0, 45)
    paragraph.BackgroundTransparency = 1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.TextColor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = paragraph
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, 0, 0, 20)
    contentLabel.Position = UDim2.new(0, 0, 0, 25)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = self.Theme.SubTextColor
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 14
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = paragraph
    
    paragraph.Parent = self.Container
    table.insert(self.Elements, paragraph)
    
    return paragraph
end

-- Update container canvas size when elements are added
function Tab:UpdateCanvasSize()
    local contentSize = self.UIListLayout.AbsoluteContentSize
    self.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
end

return Tab
