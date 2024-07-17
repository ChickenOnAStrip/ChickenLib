local UILibrary = {}

local function create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

function UILibrary:CreateWindow(title)
    local ScreenGui = create("ScreenGui", {
        Parent = game.CoreGui
    })

    local MainFrame = create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 300, 0, 250),
        Position = UDim2.new(0.5, -150, 0.5, -125),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })

    local TopBar = create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0
    })

    local Title = create("TextLabel", {
        Parent = TopBar,
        Size = UDim2.new(1, -30, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        Position = UDim2.new(0, 10, 0, 0)
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

    local window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        Tabs = {}
    }

    function window:CreateTab(name)
        local TabButton = create("TextButton", {
            Parent = self.TabContainer,
            Size = UDim2.new(0, 70, 0, 25),
            Position = UDim2.new(0, #self.Tabs * 75, 0, 0),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            BorderSizePixel = 0,
            Text = name,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false
        })

        local TabFrame = create("Frame", {
            Parent = self.TabContainer,
            Size = UDim2.new(1, 0, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Visible = false
        })

        local tab = {
            Button = TabButton,
            Frame = TabFrame,
            Elements = {}
        }

        table.insert(self.Tabs, tab)

        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(self.Tabs) do
                t.Frame.Visible = (t == tab)
                t.Button.BackgroundColor3 = (t == tab) and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(50, 50, 50)
            end
        end)

        if #self.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            TabFrame.Visible = true
        end

        function tab:AddButton(text, callback)
            local Button = create("TextButton", {
                Parent = self.Frame,
                Size = UDim2.new(0.9, 0, 0, 30),
                Position = UDim2.new(0.05, 0, 0, #self.Elements * 35),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Text = text,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                AutoButtonColor = false
            })

            Button.MouseButton1Click:Connect(callback)
            table.insert(self.Elements, Button)
        end

        function tab:AddToggle(text, default, callback)
            local Toggle = create("Frame", {
                Parent = self.Frame,
                Size = UDim2.new(0.9, 0, 0, 30),
                Position = UDim2.new(0.05, 0, 0, #self.Elements * 35),
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

            table.insert(self.Elements, Toggle)
        end

        return tab
    end

    return window
end

return UILibrary
