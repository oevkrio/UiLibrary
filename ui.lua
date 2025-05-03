-- ModernUILib (Full Version)
local ModernUILib = {}
ModernUILib.__index = ModernUILib

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

function ModernUILib:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "ModernUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 16)

    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(60, 60, 60)
    UIStroke.Thickness = 2

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = MainFrame

    return setmetatable({Frame = MainFrame}, ModernUILib)
end

function ModernUILib:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Parent = self.Frame

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 12)

    local function hover(on)
        local goal = {BackgroundColor3 = on and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)}
        TweenService:Create(button, TweenInfo.new(0.2), goal):Play()
    end

    button.MouseEnter:Connect(function() hover(true) end)
    button.MouseLeave:Connect(function() hover(false) end)

    button.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
end

function ModernUILib:AddToggle(text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 16
    toggle.Parent = self.Frame

    local state = default or false
    local function update()
        toggle.Text = (state and "[ON] " or "[OFF] ") .. text
    end

    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 12)
    update()

    toggle.MouseButton1Click:Connect(function()
        state = not state
        update()
        if callback then pcall(callback, state) end
    end)
end

function ModernUILib:AddSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = self.Frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = text .. ": " .. tostring(default)
    label.Parent = frame

    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, 0, 0, 10)
    sliderBack.Position = UDim2.new(0, 0, 0, 30)
    sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBack.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.Parent = sliderBack

    local dragging = false

    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local percent = math.clamp((mouse.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            local value = math.floor(min + (max - min) * percent)
            label.Text = text .. ": " .. tostring(value)
            if callback then pcall(callback, value) end
        end
    end)
end

function ModernUILib:AddTextbox(placeholder, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.ClearTextOnFocus = false
    box.Parent = self.Frame

    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 12)

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            pcall(callback, box.Text)
        end
    end)
end

function ModernUILib:AddDropdown(title, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = self.Frame

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title .. ": [Select]"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    frame.MouseButton1Click:Connect(function()
        for _, v in pairs(self.Frame:GetChildren()) do
            if v:IsA("TextButton") and v.Name == "DropdownOption" then v:Destroy() end
        end

        for _, option in ipairs(options) do
            local opt = Instance.new("TextButton")
            opt.Name = "DropdownOption"
            opt.Size = UDim2.new(1, -40, 0, 30)
            opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            opt.Text = option
            opt.TextColor3 = Color3.new(1, 1, 1)
            opt.Font = Enum.Font.Gotham
            opt.TextSize = 14
            opt.Parent = self.Frame

            local corner = Instance.new("UICorner", opt)
            corner.CornerRadius = UDim.new(0, 8)

            opt.MouseButton1Click:Connect(function()
                label.Text = title .. ": " .. option
                if callback then pcall(callback, option) end
                for _, v in pairs(self.Frame:GetChildren()) do
                    if v:IsA("TextButton") and v.Name == "DropdownOption" then v:Destroy() end
                end
            end)
        end
    end)
end

return ModernUILib
