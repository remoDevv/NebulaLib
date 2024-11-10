local Tweens = {}

local TweenService = game:GetService("TweenService")
local SpaceTheme = require(script.Parent.Parent.Themes.SpaceTheme)

function Tweens.ButtonPress(button)
    local tweenInfo = TweenInfo.new(
        0.1,
        SpaceTheme.EasingStyle,
        SpaceTheme.EasingDirection
    )
    
    local pressDown = TweenService:Create(button, tweenInfo, {
        BackgroundColor3 = SpaceTheme.ButtonPress
    })
    
    local pressUp = TweenService:Create(button, tweenInfo, {
        BackgroundColor3 = SpaceTheme.ButtonBackground
    })
    
    pressDown:Play()
    wait(0.1)
    pressUp:Play()
end

function Tweens.ToggleSwitch(toggle, value)
    local tweenInfo = TweenInfo.new(
        0.2,
        SpaceTheme.EasingStyle,
        SpaceTheme.EasingDirection
    )
    
    local colorTween = TweenService:Create(toggle, tweenInfo, {
        BackgroundColor3 = value and SpaceTheme.ToggleEnabled or SpaceTheme.ToggleBackground
    })
    
    colorTween:Play()
end

function Tweens.SliderMove(sliderFill, percent)
    local tweenInfo = TweenInfo.new(
        0.1,
        SpaceTheme.EasingStyle,
        SpaceTheme.EasingDirection
    )
    
    local sizeTween = TweenService:Create(sliderFill, tweenInfo, {
        Size = UDim2.new(percent, 0, 1, 0)
    })
    
    sizeTween:Play()
end

function Tweens.NotificationSlide(notification)
    local tweenInfo = TweenInfo.new(
        0.5,
        SpaceTheme.EasingStyle,
        SpaceTheme.EasingDirection
    )
    
    notification.Position = UDim2.new(1, 20, 1, -100)
    
    local slideTween = TweenService:Create(notification, tweenInfo, {
        Position = UDim2.new(1, -320, 1, -100)
    })
    
    slideTween:Play()
end

function Tweens.NotificationFade(notification)
    local tweenInfo = TweenInfo.new(
        0.5,
        SpaceTheme.EasingStyle,
        SpaceTheme.EasingDirection
    )
    
    local fadeTween = TweenService:Create(notification, tweenInfo, {
        Position = UDim2.new(1, 20, 1, -100),
        Transparency = 1
    })
    
    fadeTween:Play()
end

return Tweens
