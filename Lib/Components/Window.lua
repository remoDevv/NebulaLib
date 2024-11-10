local Window = {}
Window.__index = Window

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Tab = require(script.Parent.Tab)
local InputHandler = require(script.Parent.Parent.Utils.InputHandler)
local Tweens = require(script.Parent.Parent.Utils.Tweens)

function Window.new(config)
    local self = setmetatable({}, Window)
    
    -- Create main GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "OrionLibrary"
    self.GUI.ResetOnSpawn = false
    
    -- Create main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = config.Theme.WindowBackground
    self.MainFrame.Parent = self.GUI
    
    -- Create title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = config.Theme.TitleBarBackground
    self.TitleBar.Parent = self.MainFrame
    
    -- Create title
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -10, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.Text = config.Name
    self.Title.TextColor3 = config.Theme.TextColor
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 14
    self.Title.Parent = self.TitleBar
    
    -- Create tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 130, 1, -30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = config.Theme.TabContainerBackground
    self.TabContainer.Parent = self.MainFrame
    
    -- Create tab content
    self.TabContent = Instance.new("Frame")
    self.TabContent.Name = "TabContent"
    self.TabContent.Size = UDim2.new(1, -130, 1, -30)
    self.TabContent.Position = UDim2.new(0, 130, 0, 30)
    self.TabContent.BackgroundColor3 = config.Theme.ContentBackground
    self.TabContent.Parent = self.MainFrame
    
    -- Initialize dragging
    self:InitializeDragging()
    
    -- Store tabs
    self.Tabs = {}
    
    return self
end

function Window:InitializeDragging()
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Window:MakeTab(config)
    local newTab = Tab.new(config, self)
    table.insert(self.Tabs, newTab)
    return newTab
end

function Window:Destroy()
    self.GUI:Destroy()
end

return Window
