local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ProtectGui = (syn and syn.protect_gui) or (function() end)

local function Create(instance, properties, children)
    local obj = Instance.new(instance)

    for i, v in pairs(properties or {}) do
        obj[i] = v
    end

    for i, v in pairs(children or {}) do
        v.Parent = obj
    end

    return obj
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = Position})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function UILibrary:CreateWindow(windowName)
    local Window = {}
    
    local OrionLib = Create("ScreenGui", {
        Name = "OrionLib",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
    })

    ProtectGui(OrionLib)

    if syn then
        syn.protect_gui(OrionLib)
    end

    if gethui then
        OrionLib.Parent = gethui()
    elseif not runservice:IsStudio() then
        OrionLib.Parent = LocalPlayer:WaitForChild("PlayerGui")
    else
        OrionLib.Parent = game:GetService("CoreGui")
    end

    local Main = Create("Frame", {
        Name = "Main",
        Parent = OrionLib,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400)
    })

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })

    local WindowName = Create("TextLabel", {
        Name = "WindowName",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14.000,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14.000,
    })

    CloseButton.MouseButton1Click:Connect(function()
        OrionLib:Destroy()
    end)

    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 150, 1, -30)
    })

    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 0
    })

    local UIListLayout = Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 30),
        Size = UDim2.new(1, -150, 1, -30)
    })

    MakeDraggable(TopBar, Main)

    function Window:CreateTab(tabName)
        local Tab = {}

        local TabButton = Create("TextButton", {
            Name = "TabButton",
            Parent = TabList,
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 30),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14.000
        })

        local TabContent = Create("ScrollingFrame", {
            Name = "TabContent",
            Parent = ContentContainer,
            Active = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 0,
            Visible = false
        })

        local UIListLayout = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        function Tab:CreateButton(buttonText, callback)
            local Button = Create("TextButton", {
                Name = "Button",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = buttonText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14.000
            })

            Button.MouseButton1Click:Connect(function()
                callback()
            end)
        end

        function Tab:CreateToggle(toggleText, default, callback)
            local Toggle = Create("Frame", {
                Name = "Toggle",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 30)
            })

            local ToggleButton = Create("TextButton", {
                Name = "ToggleButton",
                Parent = Toggle,
                BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 30, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = "",
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextSize = 14.000
            })

            local ToggleText = Create("TextLabel", {
                Name = "ToggleText",
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1.000,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = toggleText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14.000,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local toggled = default
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                callback(toggled)
            end)
        end

        return Tab
    end

    return Window
end

return UILibrary
