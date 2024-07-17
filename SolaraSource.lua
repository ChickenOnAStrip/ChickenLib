local UIS = game:GetService("UserInputService")

local UILibrary = {}

-- Utility function to make a UI element draggable
local function makeDraggable(topbarObject, object)
    local dragging, dragInput, mousePos, framePos
    
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            object.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function UILibrary.new(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local self = {
        gui = ScreenGui,
        windows = {}
    }
    
    function self:createWindow(title, size)
        local window = {}
        
        window.frame = Instance.new("Frame")
        window.frame.Size = size or UDim2.new(0, 400, 0, 300)
        window.frame.Position = UDim2.new(0.5, -200, 0.5, -150)
        window.frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        window.frame.Parent = self.gui
        
        window.topBar = Instance.new("Frame")
        window.topBar.Size = UDim2.new(1, 0, 0, 30)
        window.topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        window.topBar.Parent = window.frame
        
        window.title = Instance.new("TextLabel")
        window.title.Size = UDim2.new(1, -10, 1, 0)
        window.title.Position = UDim2.new(0, 10, 0, 0)
        window.title.BackgroundTransparency = 1
        window.title.Text = title
        window.title.TextColor3 = Color3.new(1, 1, 1)
        window.title.TextXAlignment = Enum.TextXAlignment.Left
        window.title.Parent = window.topBar
        
        makeDraggable(window.topBar, window.frame)
        
        window.content = Instance.new("Frame")
        window.content.Size = UDim2.new(1, 0, 1, -30)
        window.content.Position = UDim2.new(0, 0, 0, 30)
        window.content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        window.content.Parent = window.frame
        
        function window:addButton(text, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 30)
            button.Position = UDim2.new(0, 10, 0, #self.content:GetChildren() * 40)
            button.Text = text
            button.Parent = self.content
            button.MouseButton1Click:Connect(callback)
            return button
        end
        
        function window:addDropdown(text, options, callback)
            local dropdown = {}
            
            dropdown.frame = Instance.new("Frame")
            dropdown.frame.Size = UDim2.new(0, 200, 0, 30)
            dropdown.frame.Position = UDim2.new(0, 10, 0, #self.content:GetChildren() * 40)
            dropdown.frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            dropdown.frame.Parent = self.content
            
            dropdown.button = Instance.new("TextButton")
            dropdown.button.Size = UDim2.new(1, 0, 1, 0)
            dropdown.button.Text = text
            dropdown.button.Parent = dropdown.frame
            
            dropdown.list = Instance.new("Frame")
            dropdown.list.Size = UDim2.new(1, 0, 0, #options * 30)
            dropdown.list.Position = UDim2.new(0, 0, 1, 0)
            dropdown.list.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            dropdown.list.Visible = false
            dropdown.list.Parent = dropdown.frame
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                optionButton.Text = option
                optionButton.Parent = dropdown.list
                optionButton.MouseButton1Click:Connect(function()
                    dropdown.button.Text = option
                    dropdown.list.Visible = false
                    if callback then callback(option) end
                end)
            end
            
            dropdown.button.MouseButton1Click:Connect(function()
                dropdown.list.Visible = not dropdown.list.Visible
            end)
            
            return dropdown
        end
        
        table.insert(self.windows, window)
        return window
    end
    
    return self
end

return UILibrary
