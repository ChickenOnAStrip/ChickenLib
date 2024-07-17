local Library = {}

local UIS = game:GetService("UserInputService")

-- Utility function to make a UI element draggable
local function makeDraggable(topbarObject, object)
    local dragging = false
    local dragInput, mousePos, framePos

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

-- Create the main UI frame
function Library:CreateMainFrame(name, width, height)
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = name
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, width or 400, 0, height or 300)
    MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    makeDraggable(TopBar, MainFrame)
    self.MainFrame = MainFrame
    self.TopBar = TopBar

    return MainFrame, TopBar
end

-- Create a tab system
function Library:CreateTabs(tabs)
    local Tabs = Instance.new("Frame", self.MainFrame)
    Tabs.Size = UDim2.new(1, 0, 0, 30)
    Tabs.Position = UDim2.new(0, 0, 0, 30)
    Tabs.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local TabContainer = Instance.new("Frame", self.MainFrame)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    self.TabContainer = TabContainer
    self.Tabs = {}

    for i, tabName in ipairs(tabs) do
        local TabButton = Instance.new("TextButton", Tabs)
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Position = UDim2.new(0, (i-1) * 100, 0, 0)
        TabButton.Text = tabName
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

        local TabContent = Instance.new("Frame", TabContainer)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        TabContent.Visible = i == 1

        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(self.Tabs) do
                content.Visible = false
            end
            TabContent.Visible = true
        end)

        self.Tabs[tabName] = TabContent
    end
end

-- Create a button
function Library:CreateButton(tabName, text, callback)
    local Button = Instance.new("TextButton", self.Tabs[tabName])
    Button.Size = UDim2.new(0, 100, 0, 50)
    Button.Position = UDim2.new(0.5, -50, 0.5, -25)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.MouseButton1Click:Connect(callback)
end

-- Create a dropdown
function Library:CreateDropdown(tabName, options, callback)
    local Dropdown = Instance.new("Frame", self.Tabs[tabName])
    Dropdown.Size = UDim2.new(0, 200, 0, 50)
    Dropdown.Position = UDim2.new(0.5, -100, 0.5, -25)
    Dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

    local DropdownButton = Instance.new("TextButton", Dropdown)
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.Text = "Select Option"
    DropdownButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)

    local DropdownList = Instance.new("Frame", Dropdown)
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 50)
    DropdownList.Position = UDim2.new(0, 0, 1, 0)
    DropdownList.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    DropdownList.Visible = false

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton", DropdownList)
        OptionButton.Size = UDim2.new(1, 0, 0, 50)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
        OptionButton.Text = option
        OptionButton.BackgroundColor3 = Color3.fromRGB(110, 110, 110)

        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = option
            DropdownList.Visible = false
            callback(option)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
end

return Library
