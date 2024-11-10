local Elements = {}

local TweenService = game:GetService("TweenService")
local Tweens = require(script.Parent.Parent.Utils.Tweens)

function Elements.CreateButton(config, parent)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, -20, 0, 30)
    button.BackgroundColor3 = parent.Theme.ButtonBackground
    button.Text = config.Name
    button.TextColor3 = parent.Theme.TextColor
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    
    button.MouseButton1Click:Connect(function()
        Tweens.ButtonPress(button)
        config.Callback()
    end)
    
    return button
end

function Elements.CreateToggle(config, parent)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.BackgroundTransparency = 1
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 24, 0, 24)
    button.Position = UDim2.new(0, 0, 0.5, -12)
    button.BackgroundColor3 = parent.Theme.ToggleBackground
    button.Parent = toggle
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 35, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name
    title.TextColor3 = parent.Theme.TextColor
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = toggle
    
    local value = config.Default or false
    
    local function updateVisual()
        Tweens.ToggleSwitch(button, value)
    end
    
    button.MouseButton1Click:Connect(function()
        value = not value
        updateVisual()
        config.Callback(value)
    end)
    
    updateVisual()
    
    if config.Flag then
        parent.Flags[config.Flag] = {
            Value = value,
            Set = function(newValue)
                value = newValue
                updateVisual()
                config.Callback(value)
            end
        }
    end
    
    return toggle
end

function Elements.CreateSlider(config, parent)
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(1, -20, 0, 50)
    slider.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = config.Name
    title.TextColor3 = parent.Theme.TextColor
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = slider
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, 0, 0, 4)
    sliderBar.Position = UDim2.new(0, 0, 0, 35)
    sliderBar.BackgroundColor3 = parent.Theme.SliderBackground
    sliderBar.Parent = slider
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = parent.Theme.SliderFill
    sliderFill.Parent = sliderBar
    
    local value = config.Default or config.Min
    
    local function updateVisual()
        local percent = (value - config.Min) / (config.Max - config.Min)
        Tweens.SliderMove(sliderFill, percent)
    end
    
    local function setValue(newValue)
        value = math.clamp(newValue, config.Min, config.Max)
        updateVisual()
        config.Callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            setValue(config.Min + (config.Max - config.Min) * percent)
        end
    end)
    
    updateVisual()
    
    if config.Flag then
        parent.Flags[config.Flag] = {
            Value = value,
            Set = setValue
        }
    end
    
    return slider
end

function Elements.CreateNotification(config)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Text = config.Title
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = notification
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -20, 0, 40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.Text = config.Content
    content.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    content.Font = Enum.Font.Gotham
    content.TextSize = 14
    content.Parent = notification
    
    Tweens.NotificationSlide(notification)
    
    delay(config.Time or 5, function()
        Tweens.NotificationFade(notification)
        wait(0.5)
        notification:Destroy()
    end)
    
    return notification
end

return Elements
