--[[
    Rainbow UI Library - Thư viện giao diện đẹp cho Roblox
    Tác giả: [Tên của bạn]
    Phiên bản: 1.0
]]

local RainbowUI = {}
RainbowUI.__index = RainbowUI

-- Màu sắc mặc định
RainbowUI.Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 150, 255)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(220, 220, 220),
        Text = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(0, 100, 255)
    }
}

-- Tạo một cửa sổ mới
function RainbowUI:CreateWindow(options)
    options = options or {}
    local window = setmetatable({}, RainbowUI)
    
    -- Cài đặt mặc định
    window.Title = options.Title or "Rainbow UI"
    window.Size = options.Size or UDim2.new(0, 400, 0, 500)
    window.Position = options.Position or UDim2.new(0.5, -200, 0.5, -250)
    window.Theme = options.Theme or "Dark"
    window.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    window.Visible = options.StartVisible or false
    
    -- Tạo giao diện
    window:InitializeUI()
    
    -- Thêm sự kiện bàn phím
    if window.ToggleKey then
        game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == window.ToggleKey then
                window:Toggle()
            end
        end)
    end
    
    return window
end

-- Khởi tạo giao diện
function RainbowUI:InitializeUI()
    -- Tạo ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RainbowUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Tạo Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = self.Themes[self.Theme].Main
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Visible = self.Visible
    self.MainFrame.Parent = self.ScreenGui
    
    -- Hiệu ứng bo góc
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Thêm bóng đổ
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Tạo thanh tiêu đề
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Themes[self.Theme].Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Tiêu đề
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Themes[self.Theme].Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.Parent = self.TitleBar
    
    -- Nút đóng
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = self.Themes[self.Theme].Text
    self.CloseButton.TextSize = 16
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Toggle(false)
    end)
    
    -- Tạo TabHolder
    self.TabHolder = Instance.new("Frame")
    self.TabHolder.Name = "TabHolder"
    self.TabHolder.Size = UDim2.new(1, -20, 0, 30)
    self.TabHolder.Position = UDim2.new(0, 10, 0, 40)
    self.TabHolder.BackgroundTransparency = 1
    self.TabHolder.Parent = self.MainFrame
    
    self.TabListLayout = Instance.new("UIListLayout")
    self.TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    self.TabListLayout.Padding = UDim.new(0, 5)
    self.TabListLayout.Parent = self.TabHolder
    
    -- Tạo PageContainer
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.Size = UDim2.new(1, -20, 1, -80)
    self.PageContainer.Position = UDim2.new(0, 10, 0, 80)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Parent = self.MainFrame
    
    -- Kéo thả cửa sổ
    self:Dragify(self.TitleBar)
    
    -- Ẩn/hiện animation
    self.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
    if self.Visible then
        self.MainFrame.Size = self.Size
    end
end

-- Thêm tab mới
function RainbowUI:AddTab(tabName)
    tabName = tabName or "Tab"
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Size = UDim2.new(0, 80, 1, 0)
    tabButton.BackgroundColor3 = self.Themes[self.Theme].Secondary
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.TextColor3 = self.Themes[self.Theme].Text
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = self.TabHolder
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Name = tabName .. "Page"
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.Position = UDim2.new(0, 0, 0, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.ScrollBarThickness = 3
    tabPage.ScrollBarImageColor3 = self.Themes[self.Theme].Accent
    tabPage.Visible = false
    tabPage.Parent = self.PageContainer
    
    local tabPageList = Instance.new("UIListLayout")
    tabPageList.Padding = UDim.new(0, 10)
    tabPageList.Parent = tabPage
    
    local tabPagePadding = Instance.new("UIPadding")
    tabPagePadding.PaddingTop = UDim.new(0, 5)
    tabPagePadding.PaddingLeft = UDim.new(0, 5)
    tabPagePadding.Parent = tabPage
    
    -- Chọn tab đầu tiên nếu chưa có tab nào
    if #self.TabHolder:GetChildren() == 2 then -- 1 layout + 1 tab
        self:SwitchTab(tabPage)
    end
    
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tabPage)
    end)
    
    return tabPage
end

-- Chuyển tab
function RainbowUI:SwitchTab(tabPage)
    for _, child in ipairs(self.PageContainer:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = false
        end
    end
    tabPage.Visible = true
end

-- Tạo section trong tab
function RainbowUI:AddSection(tabPage, sectionName)
    sectionName = sectionName or "Section"
    
    local section = Instance.new("Frame")
    section.Name = sectionName .. "Section"
    section.Size = UDim2.new(1, -10, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = self.Themes[self.Theme].Secondary
    section.BorderSizePixel = 0
    section.Parent = tabPage
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, -10, 0, 20)
    sectionTitle.Position = UDim2.new(0, 5, 0, 5)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = sectionName
    sectionTitle.TextColor3 = self.Themes[self.Theme].Text
    sectionTitle.TextSize = 14
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Font = Enum.Font.GothamSemibold
    sectionTitle.Parent = section
    
    local sectionContent = Instance.new("Frame")
    sectionContent.Name = "Content"
    sectionContent.Size = UDim2.new(1, -10, 0, 0)
    sectionContent.Position = UDim2.new(0, 5, 0, 30)
    sectionContent.AutomaticSize = Enum.AutomaticSize.Y
    sectionContent.BackgroundTransparency = 1
    sectionContent.Parent = section
    
    local sectionList = Instance.new("UIListLayout")
    sectionList.Padding = UDim.new(0, 5)
    sectionList.Parent = sectionContent
    
    return sectionContent
end

-- Tạo nút
function RainbowUI:AddButton(section, buttonText, callback)
    buttonText = buttonText or "Button"
    callback = callback or function() end
    
    local button = Instance.new("TextButton")
    button.Name = buttonText .. "Button"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = self.Themes[self.Theme].Accent
    button.BorderSizePixel = 0
    button.Text = buttonText
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = section
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Hiệu ứng hover
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(
            math.floor(self.Themes[self.Theme].Accent.R * 255 + 30),
            math.floor(self.Themes[self.Theme].Accent.G * 255 + 30),
            math.floor(self.Themes[self.Theme].Accent.B * 255 + 30)
        )}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = self.Themes[self.Theme].Accent}):Play()
    end)
    
    return button
end

-- Toggle UI
function RainbowUI:Toggle(visible)
    if visible ~= nil then
        self.Visible = visible
    else
        self.Visible = not self.Visible
    end
    
    if self.Visible then
        self.MainFrame.Visible = true
        self.MainFrame:TweenSize(self.Size, "Out", "Quad", 0.3, true)
    else
        self.MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
        wait(0.3)
        self.MainFrame.Visible = false
    end
end

-- Kéo thả cửa sổ
function RainbowUI:Dragify(frame)
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local dragPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            dragPos.X.Scale, dragPos.X.Offset + delta.X,
            dragPos.Y.Scale, dragPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            dragPos = self.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

return RainbowUI
