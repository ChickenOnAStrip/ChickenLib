local UILibrary = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local function create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function makeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function UILibrary:CreateWindow(title, config)
    config = config or {}
    local player = Players.LocalPlayer
    if not player then
        error("Player not found")
    end

    local ScreenGui = create("ScreenGui", {
        Parent = player:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local MainFrame = create("Frame", {
        Parent = ScreenGui,
        Size = config.Size or UDim2.new(0, 400, 0, 300),
        Position = config.Position or UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })

    local TopBar = create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = config.TopBarColor or Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0
    })

    local Title = create("TextLabel", {
        Parent = TopBar,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })

    local CloseButton = create("TextButton", {
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20
    })

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local TabContainer = create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1
    })

    local TabButtons = create("Frame", {
        Parent = TabContainer,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0
    })

    local TabButtonList = create("UIListLayout", {
        Parent = TabButtons,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local TabContent = create("Frame", {
        Parent = TabContainer,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 100, 0, 0),
        BackgroundTransparency = 1
    })

    makeDraggable(MainFrame)

    local window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabButtons = TabButtons,
        TabContent = TabContent,
        Tabs = {}
    }

    function window:CreateTab(name)
        local TabButton = create("TextButton", {
            Parent = self.TabButtons,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderSizePixel = 0,
            Text = name,
            Font = Enum.Font.SourceSans,
            TextSize = 16,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false
        })

        local TabFrame = create("ScrollingFrame", {
            Parent = self.TabContent,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            Visible = false
        })

        local UIListLayout = create("UIListLayout", {
            Parent = TabFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        local UIPadding = create("UIPadding", {
            Parent = TabFrame,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })

        local tab = {
            Button = TabButton,
            Frame = TabFrame
        }

        table.insert(self.Tabs, tab)

        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do
                t.Frame.Visible = (t == tab)
                t.Button.BackgroundColor3 = (t == tab) and Color3.fromRGB(55, 55, 55) or Color3.fromRGB(45, 45, 45)
            end
        end)

        if #self.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            TabFrame.Visible = true
        end

        function tab:AddButton(text, callback)
            local Button = create("TextButton", {
                Parent = self.Frame,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Text = text,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                AutoButtonColor = false
            })

            Button.MouseButton1Click:Connect(callback)
        end

        function tab:AddToggle(text, default, callback)
            local Toggle = create("Frame", {
                Parent = self.Frame,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1
            })

            local ToggleButton = create("TextButton", {
                Parent = Toggle,
                Size = UDim2.new(0, 30, 0, 30),
                BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })

            local ToggleText = create("TextLabel", {
                Parent = Toggle,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 40, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                callback(toggled)
            end)
        end

        return tab
    end

    return window
end

return UILibrary
