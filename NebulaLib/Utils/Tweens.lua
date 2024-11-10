local Tweens = {}

local TweenService = game:GetService("TweenService")

-- Animation presets
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
    NotificationSlide = {
        Duration = 0.4,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.Out
    },
    NotificationFade = {
        Duration = 0.3,
        EasingStyle = Enum.EasingStyle.Linear,
        EasingDirection = Enum.EasingDirection.Out
    },
    WindowTransition = {
        Duration = 0.3,
        EasingStyle = Enum.EasingStyle.Sine,
        EasingDirection = Enum.EasingDirection.Out
    }
}

-- Button animations
function Tweens.ButtonPress(button)
    local preset = ANIMATION_PRESETS.ButtonPress
    local originalSize = button.Size
    local originalPosition = button.Position
    
    -- Scale down effect
    local scaleDown = TweenService:Create(button, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        Size = originalSize * UDim2.new(0.95, 0, 0.95, 0),
        Position = originalPosition + UDim2.new(0.025, 0, 0.025, 0)
    })
    
    -- Scale up effect
    local scaleUp = TweenService:Create(button, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        Size = originalSize,
        Position = originalPosition
    })
    
    scaleDown:Play()
    scaleDown.Completed:Connect(function()
        scaleUp:Play()
    end)
end

function Tweens.ButtonHover(button, isHovering)
    local preset = ANIMATION_PRESETS.ButtonHover
    local targetColor = isHovering and button.Parent.Theme.ButtonHover or button.Parent.Theme.ButtonBackground
    
    local tween = TweenService:Create(button, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        BackgroundColor3 = targetColor
    })
    
    tween:Play()
end

-- Toggle animations
function Tweens.ToggleSwitch(toggleButton, enabled)
    local preset = ANIMATION_PRESETS.ToggleSwitch
    local targetColor = enabled and toggleButton.Parent.Theme.ToggleEnabled or toggleButton.Parent.Theme.ToggleBackground
    
    local colorTween = TweenService:Create(toggleButton, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        BackgroundColor3 = targetColor
    })
    
    colorTween:Play()
end

-- Slider animations
function Tweens.SliderMove(sliderFill, percentage)
    local preset = ANIMATION_PRESETS.SliderMove
    
    local tween = TweenService:Create(sliderFill, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        Size = UDim2.new(percentage, 0, 1, 0)
    })
    
    tween:Play()
end

-- Notification animations
function Tweens.NotificationSlide(notification)
    local preset = ANIMATION_PRESETS.NotificationSlide
    
    notification.Position = UDim2.new(1, 20, 1, -100)
    local tween = TweenService:Create(notification, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    
    tween:Play()
end

function Tweens.NotificationFade(notification)
    local preset = ANIMATION_PRESETS.NotificationFade
    
    local tween = TweenService:Create(notification, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    
    -- Also fade out all child TextLabels
    for _, child in ipairs(notification:GetDescendants()) do
        if child:IsA("TextLabel") then
            local textTween = TweenService:Create(child, TweenInfo.new(
                preset.Duration,
                preset.EasingStyle,
                preset.EasingDirection
            ), {
                TextTransparency = 1
            })
            textTween:Play()
        end
    end
    
    tween:Play()
end

-- Window animations
function Tweens.WindowTransition(window, showing)
    local preset = ANIMATION_PRESETS.WindowTransition
    
    local targetProperties = {
        BackgroundTransparency = showing and 0 or 1,
        Position = showing and 
            UDim2.new(0.5, -300, 0.5, -200) or 
            UDim2.new(0.5, -300, 0.6, -200)
    }
    
    local tween = TweenService:Create(window, TweenInfo.new(
        preset.Duration,
        preset.EasingStyle,
        preset.EasingDirection
    ), targetProperties)
    
    tween:Play()
    return tween
end

return Tweens
