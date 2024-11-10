local InputHandler = {}

local UserInputService = game:GetService("UserInputService")

function InputHandler.Init()
    local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    
    -- Set up platform-specific behaviors
    if isMobile then
        InputHandler.SetupMobileInput()
    else
        InputHandler.SetupDesktopInput()
    end
end

function InputHandler.SetupMobileInput()
    -- Implement mobile-specific touch handling
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        local touchPosition = touch.Position
        -- Handle touch input
    end)
    
    UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        local touchPosition = touch.Position
        -- Handle touch movement
    end)
    
    UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        local touchPosition = touch.Position
        -- Handle touch release
    end)
end

function InputHandler.SetupDesktopInput()
    -- Implement desktop-specific mouse handling
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Handle mouse click
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            -- Handle mouse movement
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Handle mouse release
        end
    end)
end

function InputHandler.IsTouch()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

return InputHandler
