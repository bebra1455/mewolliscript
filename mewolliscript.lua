-- DelightHub GUI Script для Roblox
-- Автор: Создано для DelightHub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Конфигурация
local Config = {
    Theme = Color3.fromRGB(255, 105, 180),
    Settings = {
        AmbienceType = "День",
        WeatherType = "Нет",
        ESPEnabled = false,
        ESPColor = Color3.fromRGB(255, 105, 180),
        FOVValue = 70,
        CrosshairEnabled = false,
        CrosshairColor = Color3.fromRGB(255, 255, 255),
        CrosshairLength = 8,
        CrosshairThickness = 2,
        CrosshairDot = true,
        NameTagsEnabled = false,
        NameTagsSize = 16,
        NameTagsColor = Color3.fromRGB(255, 255, 255),
        SpeedPower = 16,
        JumpPower = 50,
        Gravity = 196.2,
        FlyEnabled = false,
        FlySpeed = 50
    }
}

-- FPS Counter (стабилизированный)
local FPS = 60
local FPSFrames = {}
RunService.RenderStepped:Connect(function()
    table.insert(FPSFrames, tick())
    local currentTime = tick()
    for i = #FPSFrames, 1, -1 do
        if currentTime - FPSFrames[i] > 1 then
            table.remove(FPSFrames, i)
        end
    end
    FPS = #FPSFrames
end)

-- Ping Calculator (стабилизированный)
local PingValues = {}
local function GetPing()
    local success, ping = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if success and ping then
        table.insert(PingValues, ping)
        if #PingValues > 10 then
            table.remove(PingValues, 1)
        end
        local sum = 0
        for _, v in ipairs(PingValues) do
            sum = sum + v
        end
        return math.floor(sum / #PingValues)
    end
    return 0
end

-- Функция для получения текущей темы
local function GetThemeColor()
    return Config.Theme
end

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DelightHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Создание основного фрейма
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 720, 0, 480)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Обводка GUI
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = GetThemeColor()
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Обновление обводки при смене темы
RunService.RenderStepped:Connect(function()
    UIStroke.Color = GetThemeColor()
end)

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Градиент для заголовка
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🌸 DelightHub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Левая панель для вкладок
local TabPanel = Instance.new("Frame")
TabPanel.Name = "TabPanel"
TabPanel.Size = UDim2.new(0, 150, 1, -38)
TabPanel.Position = UDim2.new(0, 0, 0, 38)
TabPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

-- Градиент для панели вкладок
local TabGradient = Instance.new("UIGradient")
TabGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
TabGradient.Rotation = 0
TabGradient.Parent = TabPanel

-- Правая панель для контента
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -150, 1, -38)
ContentPanel.Position = UDim2.new(0, 150, 0, 38)
ContentPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = MainFrame

-- Скролл для контента с поддержкой колесика мыши
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -20, 1, -20)
ContentScroll.Position = UDim2.new(0, 10, 0, 10)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = GetThemeColor()
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ContentScroll.ScrollingEnabled = true
ContentScroll.Active = true
ContentScroll.Parent = ContentPanel

-- Поддержка колесика мыши для всех вкладок
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local scrollDelta = input.Position.Z
        local current = ContentScroll.CanvasPosition.Y
        
        if scrollDelta > 0 then
            -- Прокрутка вверх
            ContentScroll.CanvasPosition = Vector2.new(0, math.max(current - 50, 0))
        else
            -- Прокрутка вниз
            ContentScroll.CanvasPosition = Vector2.new(0, math.min(current + 50, ContentScroll.AbsoluteCanvasSize.Y - ContentScroll.AbsoluteSize.Y))
        end
    end
end)

-- Вкладки
local Tabs = {"Combat", "Player", "Misc", "Visuals", "KeyBinds", "Settings"}
local TabButtons = {}
local TabContents = {}
local CurrentTab = "Visuals"
local KeyBinds = {}

-- Функция для создания кнопки вкладки
local function CreateTabButton(name, index)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, -10, 0, 42)
    TabButton.Position = UDim2.new(0, 5, 0, 5 + (index - 1) * 47)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = TabPanel
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    -- Обводка для неактивной кнопки
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Color3.fromRGB(50, 50, 60)
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.7
    TabStroke.Parent = TabButton
    
    TabButtons[name] = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = ContentScroll
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabContent
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabContents[name] = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        for tabName, btn in pairs(TabButtons) do
            if tabName == name then
                btn.BackgroundColor3 = GetThemeColor()
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                TabContents[tabName].Visible = true
                CurrentTab = tabName
                
                -- Обновляем обводку активной кнопки
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = GetThemeColor()
                    stroke.Transparency = 0
                    stroke.Thickness = 2
                end
            else
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                TabContents[tabName].Visible = false
                
                -- Обводка для неактивных кнопок
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = Color3.fromRGB(50, 50, 60)
                    stroke.Transparency = 0.7
                    stroke.Thickness = 1
                end
            end
        end
    end)
    
    return TabButton, TabContent
end

for i, tabName in ipairs(Tabs) do
    CreateTabButton(tabName, i)
end

-- Функция для создания чекбокса
local function CreateCheckbox(parent, text, defaultValue, callback)
    local CheckFrame = Instance.new("Frame")
    CheckFrame.Size = UDim2.new(1, 0, 0, 44)
    CheckFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CheckFrame.Parent = parent
    
    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 11)
    CheckCorner.Parent = CheckFrame
    
    -- Обводка
    local CheckStroke = Instance.new("UIStroke")
    CheckStroke.Color = Color3.fromRGB(50, 50, 60)
    CheckStroke.Thickness = 1
    CheckStroke.Transparency = 0.8
    CheckStroke.Parent = CheckFrame
    
    local CheckLabel = Instance.new("TextLabel")
    CheckLabel.Size = UDim2.new(1, -50, 1, 0)
    CheckLabel.Position = UDim2.new(0, 10, 0, 0)
    CheckLabel.BackgroundTransparency = 1
    CheckLabel.Text = text
    CheckLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckLabel.TextSize = 14
    CheckLabel.Font = Enum.Font.Gotham
    CheckLabel.TextXAlignment = Enum.TextXAlignment.Left
    CheckLabel.Parent = CheckFrame
    
    local CheckButton = Instance.new("TextButton")
    CheckButton.Size = UDim2.new(0, 26, 0, 26)
    CheckButton.Position = UDim2.new(1, -34, 0.5, -13)
    CheckButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    CheckButton.Text = ""
    CheckButton.Parent = CheckFrame
    
    local CheckButtonCorner = Instance.new("UICorner")
    CheckButtonCorner.CornerRadius = UDim.new(0, 6)
    CheckButtonCorner.Parent = CheckButton
    
    local CheckMark = Instance.new("TextLabel")
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.BackgroundTransparency = 1
    CheckMark.Text = "✓"
    CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckMark.TextSize = 18
    CheckMark.Font = Enum.Font.GothamBold
    CheckMark.Visible = defaultValue or false
    CheckMark.Parent = CheckButton
    
    local isChecked = defaultValue or false
    if isChecked then
        CheckButton.BackgroundColor3 = GetThemeColor()
    end
    
    CheckButton.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        CheckMark.Visible = isChecked
        CheckButton.BackgroundColor3 = isChecked and GetThemeColor() or Color3.fromRGB(60, 60, 70)
        if callback then callback(isChecked) end
    end)
    
    return CheckFrame
end

-- Функция для создания слайдера
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 11)
    SliderCorner.Parent = SliderFrame
    
    -- Обводка
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Color = Color3.fromRGB(50, 50, 60)
    SliderStroke.Thickness = 1
    SliderStroke.Transparency = 0.8
    SliderStroke.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.7, 0, 0, 22)
    SliderLabel.Position = UDim2.new(0, 10, 0, 6)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0.3, -10, 0, 22)
    SliderValue.Position = UDim2.new(0.7, 0, 0, 6)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(default)
    SliderValue.TextColor3 = GetThemeColor()
    SliderValue.TextSize = 14
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 5)
    SliderBar.Position = UDim2.new(0, 10, 1, -18)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = GetThemeColor()
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 14, 0, 14)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton
    
    local dragging = false
    local currentValue = default
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local relativeX = math.clamp(mouse.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
            local percentage = relativeX / SliderBar.AbsoluteSize.X
            currentValue = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderButton.Position = UDim2.new(percentage, -7, 0.5, -7)
            SliderValue.Text = tostring(currentValue)
            
            if callback then callback(currentValue) end
        end
    end)
    
    return SliderFrame
end

-- Расширенная палитра цветов
local ColorPalette = {
    Color3.fromRGB(255, 255, 255),  -- Белый
    Color3.fromRGB(255, 105, 180),  -- Розовый
    Color3.fromRGB(255, 20, 147),   -- Темно-розовый
    Color3.fromRGB(100, 200, 255),  -- Голубой
    Color3.fromRGB(30, 144, 255),   -- Синий
    Color3.fromRGB(138, 43, 226),   -- Фиолетовый
    Color3.fromRGB(148, 0, 211),    -- Темно-фиолетовый
    Color3.fromRGB(255, 50, 50),    -- Красный
    Color3.fromRGB(220, 20, 60),    -- Темно-красный
    Color3.fromRGB(255, 140, 0),    -- Оранжевый
    Color3.fromRGB(255, 215, 0),    -- Золотой
    Color3.fromRGB(50, 255, 50),    -- Зеленый
    Color3.fromRGB(0, 255, 127),    -- Весенний зеленый
    Color3.fromRGB(255, 255, 0),    -- Желтый
    Color3.fromRGB(0, 255, 255),    -- Циан
    Color3.fromRGB(255, 0, 255),    -- Маджента
    Color3.fromRGB(128, 128, 128),  -- Серый
    Color3.fromRGB(0, 0, 0),        -- Черный
}

-- Улучшенная палитра цветов (открывается справа от GUI)
local ColorPickerWindow = Instance.new("Frame")
ColorPickerWindow.Name = "ColorPickerWindow"
ColorPickerWindow.Size = UDim2.new(0, 250, 0, 350)
ColorPickerWindow.Position = UDim2.new(0, 0, 0.5, -175)
ColorPickerWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ColorPickerWindow.BorderSizePixel = 0
ColorPickerWindow.Visible = false
ColorPickerWindow.ZIndex = 300
ColorPickerWindow.Parent = ScreenGui

local ColorPickerCorner = Instance.new("UICorner")
ColorPickerCorner.CornerRadius = UDim.new(0, 12)
ColorPickerCorner.Parent = ColorPickerWindow

local ColorPickerStroke = Instance.new("UIStroke")
ColorPickerStroke.Color = GetThemeColor()
ColorPickerStroke.Thickness = 2
ColorPickerStroke.Parent = ColorPickerWindow

local ColorPickerTitle = Instance.new("TextLabel")
ColorPickerTitle.Size = UDim2.new(1, 0, 0, 40)
ColorPickerTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ColorPickerTitle.Text = "🎨 Выбор цвета"
ColorPickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerTitle.TextSize = 16
ColorPickerTitle.Font = Enum.Font.GothamBold
ColorPickerTitle.Parent = ColorPickerWindow

local ColorPickerTitleCorner = Instance.new("UICorner")
ColorPickerTitleCorner.CornerRadius = UDim.new(0, 12)
ColorPickerTitleCorner.Parent = ColorPickerTitle

local ColorPickerClose = Instance.new("TextButton")
ColorPickerClose.Size = UDim2.new(0, 30, 0, 30)
ColorPickerClose.Position = UDim2.new(1, -35, 0, 5)
ColorPickerClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ColorPickerClose.Text = "×"
ColorPickerClose.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerClose.TextSize = 20
ColorPickerClose.Font = Enum.Font.GothamBold
ColorPickerClose.Parent = ColorPickerTitle

local ColorPickerCloseCorner = Instance.new("UICorner")
ColorPickerCloseCorner.CornerRadius = UDim.new(0, 6)
ColorPickerCloseCorner.Parent = ColorPickerClose

ColorPickerClose.MouseButton1Click:Connect(function()
    ColorPickerWindow.Visible = false
end)

local ColorPickerScroll = Instance.new("ScrollingFrame")
ColorPickerScroll.Size = UDim2.new(1, -30, 1, -90)
ColorPickerScroll.Position = UDim2.new(0, 15, 0, 55)
ColorPickerScroll.BackgroundTransparency = 1
ColorPickerScroll.BorderSizePixel = 0
ColorPickerScroll.ScrollBarThickness = 4
ColorPickerScroll.ScrollBarImageColor3 = GetThemeColor()
ColorPickerScroll.Parent = ColorPickerWindow

local ColorPickerGrid = Instance.new("Frame")
ColorPickerGrid.Size = UDim2.new(1, 0, 1, 0)
ColorPickerGrid.BackgroundTransparency = 1
ColorPickerGrid.Parent = ColorPickerScroll

local ColorPickerLayout = Instance.new("UIGridLayout")
ColorPickerLayout.CellSize = UDim2.new(0, 50, 0, 50)
ColorPickerLayout.CellPadding = UDim2.new(0, 10, 0, 10)
ColorPickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ColorPickerLayout.Parent = ColorPickerGrid

ColorPickerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ColorPickerScroll.CanvasSize = UDim2.new(0, 0, 0, ColorPickerLayout.AbsoluteContentSize.Y + 10)
    ColorPickerGrid.Size = UDim2.new(1, 0, 0, ColorPickerLayout.AbsoluteContentSize.Y + 10)
end)

local currentColorCallback = nil

-- Функция для создания выбора цвета с палитрой
local function CreateColorPicker(parent, text, defaultColor, callback)
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Size = UDim2.new(1, 0, 0, 44)
    ColorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ColorFrame.Parent = parent
    
    local ColorCorner = Instance.new("UICorner")
    ColorCorner.CornerRadius = UDim.new(0, 11)
    ColorCorner.Parent = ColorFrame
    
    -- Обводка
    local ColorStroke = Instance.new("UIStroke")
    ColorStroke.Color = Color3.fromRGB(50, 50, 60)
    ColorStroke.Thickness = 1
    ColorStroke.Transparency = 0.8
    ColorStroke.Parent = ColorFrame
    
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Size = UDim2.new(0.65, 0, 1, 0)
    ColorLabel.Position = UDim2.new(0, 10, 0, 0)
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Text = text
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 14
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ColorLabel.Parent = ColorFrame
    
    local ColorPreview = Instance.new("Frame")
    ColorPreview.Size = UDim2.new(0, 70, 0, 30)
    ColorPreview.Position = UDim2.new(1, -80, 0.5, -15)
    ColorPreview.BackgroundColor3 = defaultColor
    ColorPreview.BorderSizePixel = 0
    ColorPreview.Parent = ColorFrame
    
    local ColorPreviewCorner = Instance.new("UICorner")
    ColorPreviewCorner.CornerRadius = UDim.new(0, 8)
    ColorPreviewCorner.Parent = ColorPreview
    
    local ColorPreviewStroke = Instance.new("UIStroke")
    ColorPreviewStroke.Color = Color3.fromRGB(80, 80, 90)
    ColorPreviewStroke.Thickness = 2
    ColorPreviewStroke.Parent = ColorPreview
    
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(1, 0, 1, 0)
    ColorButton.BackgroundTransparency = 1
    ColorButton.Text = ""
    ColorButton.Parent = ColorPreview
    
    ColorButton.MouseButton1Click:Connect(function()
        currentColorCallback = function(color)
            ColorPreview.BackgroundColor3 = color
            if callback then callback(color) end
        end
        
        -- Очищаем старые цвета
        for _, child in pairs(ColorPickerGrid:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Создаем новые кнопки цветов
        for i, color in ipairs(ColorPalette) do
            local ColorCell = Instance.new("TextButton")
            ColorCell.Size = UDim2.new(0, 50, 0, 50)
            ColorCell.BackgroundColor3 = color
            ColorCell.BorderSizePixel = 0
            ColorCell.Text = ""
            ColorCell.AutoButtonColor = false
            ColorCell.Parent = ColorPickerGrid
            
            local CellCorner = Instance.new("UICorner")
            CellCorner.CornerRadius = UDim.new(0, 10)
            CellCorner.Parent = ColorCell
            
            local CellStroke = Instance.new("UIStroke")
            CellStroke.Color = Color3.fromRGB(255, 255, 255)
            CellStroke.Thickness = 0
            CellStroke.Transparency = 1
            CellStroke.Parent = ColorCell
            
            ColorCell.MouseEnter:Connect(function()
                CellStroke.Thickness = 3
                CellStroke.Transparency = 0
            end)
            
            ColorCell.MouseLeave:Connect(function()
                CellStroke.Thickness = 0
                CellStroke.Transparency = 1
            end)
            
            ColorCell.MouseButton1Click:Connect(function()
                if currentColorCallback then
                    currentColorCallback(color)
                end
                ColorPickerWindow.Visible = false
            end)
        end
        
        -- Показываем окно справа от GUI
        local mainFramePos = MainFrame.AbsolutePosition
        local mainFrameSize = MainFrame.AbsoluteSize
        ColorPickerWindow.Position = UDim2.new(0, mainFramePos.X + mainFrameSize.X + 15, 0, mainFramePos.Y + 50)
        ColorPickerWindow.Visible = true
        
        -- Обновляем обводку
        ColorPickerStroke.Color = GetThemeColor()
    end)
    
    return ColorFrame
end

-- Окно дропдауна (открывается справа от GUI как палитра)
local DropdownWindow = Instance.new("Frame")
DropdownWindow.Name = "DropdownWindow"
DropdownWindow.Size = UDim2.new(0, 250, 0, 300)
DropdownWindow.Position = UDim2.new(0, 0, 0.5, -150)
DropdownWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
DropdownWindow.BorderSizePixel = 0
DropdownWindow.Visible = false
DropdownWindow.ZIndex = 300
DropdownWindow.Parent = ScreenGui

local DropdownWindowCorner = Instance.new("UICorner")
DropdownWindowCorner.CornerRadius = UDim.new(0, 12)
DropdownWindowCorner.Parent = DropdownWindow

local DropdownWindowStroke = Instance.new("UIStroke")
DropdownWindowStroke.Color = GetThemeColor()
DropdownWindowStroke.Thickness = 2
DropdownWindowStroke.Parent = DropdownWindow

local DropdownWindowTitle = Instance.new("TextLabel")
DropdownWindowTitle.Size = UDim2.new(1, 0, 0, 40)
DropdownWindowTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
DropdownWindowTitle.Text = "📋 Выбор"
DropdownWindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownWindowTitle.TextSize = 16
DropdownWindowTitle.Font = Enum.Font.GothamBold
DropdownWindowTitle.Parent = DropdownWindow

local DropdownWindowTitleCorner = Instance.new("UICorner")
DropdownWindowTitleCorner.CornerRadius = UDim.new(0, 12)
DropdownWindowTitleCorner.Parent = DropdownWindowTitle

local DropdownWindowClose = Instance.new("TextButton")
DropdownWindowClose.Size = UDim2.new(0, 30, 0, 30)
DropdownWindowClose.Position = UDim2.new(1, -35, 0, 5)
DropdownWindowClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DropdownWindowClose.Text = "×"
DropdownWindowClose.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownWindowClose.TextSize = 20
DropdownWindowClose.Font = Enum.Font.GothamBold
DropdownWindowClose.Parent = DropdownWindowTitle

local DropdownWindowCloseCorner = Instance.new("UICorner")
DropdownWindowCloseCorner.CornerRadius = UDim.new(0, 6)
DropdownWindowCloseCorner.Parent = DropdownWindowClose

DropdownWindowClose.MouseButton1Click:Connect(function()
    DropdownWindow.Visible = false
end)

local DropdownWindowScroll = Instance.new("ScrollingFrame")
DropdownWindowScroll.Size = UDim2.new(1, -30, 1, -90)
DropdownWindowScroll.Position = UDim2.new(0, 15, 0, 55)
DropdownWindowScroll.BackgroundTransparency = 1
DropdownWindowScroll.BorderSizePixel = 0
DropdownWindowScroll.ScrollBarThickness = 6
DropdownWindowScroll.ScrollBarImageColor3 = GetThemeColor()
DropdownWindowScroll.Parent = DropdownWindow

local DropdownWindowList = Instance.new("Frame")
DropdownWindowList.Size = UDim2.new(1, 0, 0, 0)
DropdownWindowList.BackgroundTransparency = 1
DropdownWindowList.Parent = DropdownWindowScroll

local DropdownWindowLayout = Instance.new("UIListLayout")
DropdownWindowLayout.Padding = UDim.new(0, 8)
DropdownWindowLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropdownWindowLayout.Parent = DropdownWindowList

DropdownWindowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    DropdownWindowScroll.CanvasSize = UDim2.new(0, 0, 0, DropdownWindowLayout.AbsoluteContentSize.Y + 10)
    DropdownWindowList.Size = UDim2.new(1, 0, 0, DropdownWindowLayout.AbsoluteContentSize.Y + 10)
end)

local currentDropdownCallback = nil

-- Функция для создания дропдауна
local function CreateDropdown(parent, text, options, default, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 44)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 11)
    DropdownCorner.Parent = DropdownFrame
    
    -- Обводка
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Color3.fromRGB(50, 50, 60)
    DropdownStroke.Thickness = 1
    DropdownStroke.Transparency = 0.8
    DropdownStroke.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, -10, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = text
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.5, -20, 0, 30)
    DropdownButton.Position = UDim2.new(0.5, 5, 0.5, -15)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    DropdownButton.Text = default or options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 12
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Parent = DropdownFrame
    
    local DropdownButtonCorner = Instance.new("UICorner")
    DropdownButtonCorner.CornerRadius = UDim.new(0, 8)
    DropdownButtonCorner.Parent = DropdownButton
    
    DropdownButton.MouseButton1Click:Connect(function()
        currentDropdownCallback = function(option)
            DropdownButton.Text = option
            if callback then callback(option) end
        end
        
        -- Очищаем старые опции
        for _, child in pairs(DropdownWindowList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Создаем новые опции
        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 45)
            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.GothamBold
            OptionButton.AutoButtonColor = false
            OptionButton.Parent = DropdownWindowList
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 10)
            OptionCorner.Parent = OptionButton
            
            local OptionStroke = Instance.new("UIStroke")
            OptionStroke.Color = Color3.fromRGB(255, 255, 255)
            OptionStroke.Thickness = 0
            OptionStroke.Transparency = 1
            OptionStroke.Parent = OptionButton
            
            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundColor3 = GetThemeColor()
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
            
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                if currentDropdownCallback then
                    currentDropdownCallback(option)
                end
                DropdownWindow.Visible = false
            end)
        end
        
        -- Показываем окно справа от GUI
        local mainFramePos = MainFrame.AbsolutePosition
        local mainFrameSize = MainFrame.AbsoluteSize
        DropdownWindow.Position = UDim2.new(0, mainFramePos.X + mainFrameSize.X + 15, 0, mainFramePos.Y + 50)
        DropdownWindow.Visible = true
        DropdownWindowTitle.Text = "📋 " .. text
        
        -- Обновляем обводку
        DropdownWindowStroke.Color = GetThemeColor()
    end)
    
    return DropdownFrame
end

-- HUD Watermark
local HudWatermark = Instance.new("ScreenGui")
HudWatermark.Name = "HudWatermark"
HudWatermark.ResetOnSpawn = false
HudWatermark.IgnoreGuiInset = true
HudWatermark.Parent = PlayerGui

local TopPanel = Instance.new("Frame")
TopPanel.Size = UDim2.new(0, 420, 0, 36)
TopPanel.Position = UDim2.new(0.5, -210, 0, 12)
TopPanel.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
TopPanel.BackgroundTransparency = 0.12
TopPanel.BorderSizePixel = 0
TopPanel.Parent = HudWatermark

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = TopPanel

-- Обводка для ватермарки
local TopStroke = Instance.new("UIStroke")
TopStroke.Color = GetThemeColor()
TopStroke.Thickness = 1.5
TopStroke.Transparency = 0.5
TopStroke.Parent = TopPanel

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(0, 115, 1, 0)
LogoText.Position = UDim2.new(0, 12, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "🌸 DelightHub"
LogoText.TextSize = 14
LogoText.Font = Enum.Font.GothamBold
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = TopPanel

-- Градиентное переливание для текста (вправо)
local LogoGradient = Instance.new("UIGradient")
LogoGradient.Parent = LogoText

-- Анимация градиентного переливания (оптимизированная)
task.spawn(function()
    while wait(0.03) do
        local offset = (tick() % 2) / 2
        LogoGradient.Offset = Vector2.new(offset, 0)
        
        local baseColor = GetThemeColor()
        local r, g, b = baseColor.R, baseColor.G, baseColor.B
        
        -- Создаем переливающийся градиент
        local color1 = Color3.new(r * 0.7, g * 0.7, b * 0.7)
        local color2 = baseColor
        local color3 = Color3.new(
            math.min(r * 1.3, 1),
            math.min(g * 1.3, 1),
            math.min(b * 1.3, 1)
        )
        
        LogoGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(0.5, color2),
            ColorSequenceKeypoint.new(1, color3)
        })
    end
end)

local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(0, 2, 0, 22)
Divider1.Position = UDim2.new(0, 130, 0.5, -11)
Divider1.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
Divider1.BorderSizePixel = 0
Divider1.Parent = TopPanel

local PlayerText = Instance.new("TextLabel")
PlayerText.Size = UDim2.new(0, 100, 1, 0)
PlayerText.Position = UDim2.new(0, 140, 0, 0)
PlayerText.BackgroundTransparency = 1
PlayerText.Text = "👤 " .. Player.Name
PlayerText.TextColor3 = Color3.fromRGB(200, 200, 200)
PlayerText.TextSize = 11
PlayerText.Font = Enum.Font.Gotham
PlayerText.TextXAlignment = Enum.TextXAlignment.Left
PlayerText.TextTruncate = Enum.TextTruncate.AtEnd
PlayerText.Parent = TopPanel

local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(0, 2, 0, 22)
Divider2.Position = UDim2.new(0, 245, 0.5, -11)
Divider2.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
Divider2.BorderSizePixel = 0
Divider2.Parent = TopPanel

local TimeText = Instance.new("TextLabel")
TimeText.Size = UDim2.new(0, 85, 1, 0)
TimeText.Position = UDim2.new(0, 252, 0, 0)
TimeText.BackgroundTransparency = 1
TimeText.TextColor3 = Color3.fromRGB(200, 200, 200)
TimeText.TextSize = 11
TimeText.Font = Enum.Font.Gotham
TimeText.TextXAlignment = Enum.TextXAlignment.Left
TimeText.Parent = TopPanel

local Divider3 = Instance.new("Frame")
Divider3.Size = UDim2.new(0, 2, 0, 22)
Divider3.Position = UDim2.new(0, 342, 0.5, -11)
Divider3.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
Divider3.BorderSizePixel = 0
Divider3.Parent = TopPanel

local FPSText = Instance.new("TextLabel")
FPSText.Size = UDim2.new(0, 70, 1, 0)
FPSText.Position = UDim2.new(1, -73, 0, 0)
FPSText.BackgroundTransparency = 1
FPSText.TextColor3 = Color3.fromRGB(200, 200, 200)
FPSText.TextSize = 11
FPSText.Font = Enum.Font.Gotham
FPSText.TextXAlignment = Enum.TextXAlignment.Left
FPSText.Parent = TopPanel

local BottomPanel = Instance.new("Frame")
BottomPanel.Size = UDim2.new(0, 420, 0, 36)
BottomPanel.Position = UDim2.new(0.5, -210, 0, 53)
BottomPanel.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
BottomPanel.BackgroundTransparency = 0.12
BottomPanel.BorderSizePixel = 0
BottomPanel.Parent = HudWatermark

local BottomCorner = Instance.new("UICorner")
BottomCorner.CornerRadius = UDim.new(0, 9)
BottomCorner.Parent = BottomPanel

-- Обводка для нижней панели
local BottomStroke = Instance.new("UIStroke")
BottomStroke.Color = GetThemeColor()
BottomStroke.Thickness = 1.5
BottomStroke.Transparency = 0.5
BottomStroke.Parent = BottomPanel

local PingText = Instance.new("TextLabel")
PingText.Size = UDim2.new(0.33, -10, 1, 0)
PingText.Position = UDim2.new(0, 12, 0, 0)
PingText.BackgroundTransparency = 1
PingText.TextColor3 = Color3.fromRGB(200, 200, 200)
PingText.TextSize = 11
PingText.Font = Enum.Font.Gotham
PingText.TextXAlignment = Enum.TextXAlignment.Center
PingText.Parent = BottomPanel

local CoordText = Instance.new("TextLabel")
CoordText.Size = UDim2.new(0.34, 0, 1, 0)
CoordText.Position = UDim2.new(0.33, 0, 0, 0)
CoordText.BackgroundTransparency = 1
CoordText.TextColor3 = Color3.fromRGB(200, 200, 200)
CoordText.TextSize = 10
CoordText.Font = Enum.Font.Gotham
CoordText.TextXAlignment = Enum.TextXAlignment.Center
CoordText.Parent = BottomPanel

local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(0.33, -12, 1, 0)
SpeedText.Position = UDim2.new(0.67, 0, 0, 0)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = ""
SpeedText.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedText.TextSize = 11
SpeedText.Font = Enum.Font.Gotham
SpeedText.TextXAlignment = Enum.TextXAlignment.Center
SpeedText.Parent = BottomPanel

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = ""
ToggleButton.Parent = TopPanel

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local draggingWatermark = false
local dragInputWatermark, mousePosWatermark, framePosWatermark

TopPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWatermark = true
        mousePosWatermark = input.Position
        framePosWatermark = TopPanel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingWatermark = false
            end
        end)
    end
end)

TopPanel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputWatermark = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputWatermark and draggingWatermark then
        local delta = input.Position - mousePosWatermark
        local newPos = UDim2.new(
            framePosWatermark.X.Scale,
            framePosWatermark.X.Offset + delta.X,
            framePosWatermark.Y.Scale,
            framePosWatermark.Y.Offset + delta.Y
        )
        TopPanel.Position = newPos
        BottomPanel.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset, 0, newPos.Y.Offset + 41)
    end
end)

local lastSpeedUpdate = tick()
local bytesReceived = 0
local lastInfoUpdate = tick()

RunService.RenderStepped:Connect(function()
    local currentTick = tick()
    
    -- Обновляем информацию только раз в 0.5 секунд для экономии FPS
    if currentTick - lastInfoUpdate >= 0.5 then
        lastInfoUpdate = currentTick
        
        local timeOffset = 3 * 60 * 60
        local currentTime = os.time() + timeOffset
        TimeText.Text = "🕐 " .. os.date("%H:%M:%S", currentTime)
        
        FPSText.Text = "📊 " .. tostring(FPS) .. " FPS"
        
        local ping = GetPing()
        PingText.Text = "📶 " .. tostring(ping) .. "ms"
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Player.Character.HumanoidRootPart.Position
            CoordText.Text = string.format("📍 %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        end
        
        -- Обновляем обводки
        TopStroke.Color = GetThemeColor()
        BottomStroke.Color = GetThemeColor()
    end
end)

-- Перетаскивание MainFrame
local dragging = false
local dragInput, mousePos, framePos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- ===== COMBAT TAB =====
local CombatContent = TabContents["Combat"]

-- AimBot (полностью исправленная версия)
local aimbotEnabled = false
local aimbotConnection = nil
local aimbotTargetPart = "Head"
local targetHudEnabled = false

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild(aimbotTargetPart)
                if targetPart then
                    local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

CreateCheckbox(CombatContent, "AimBot (Авто-прицеливание)", false, function(enabled)
    aimbotEnabled = enabled
    
    if enabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            if not aimbotEnabled then return end
            
            local target = GetClosestPlayer()
            if target and target.Character then
                local targetPart = target.Character:FindFirstChild(aimbotTargetPart)
                if targetPart then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                end
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end)

CreateDropdown(CombatContent, "Целиться в", {"Голова", "Туловище", "Нога"}, "Голова", function(selected)
    if selected == "Голова" then
        aimbotTargetPart = "Head"
    elseif selected == "Туловище" then
        aimbotTargetPart = "UpperTorso"
    elseif selected == "Нога" then
        aimbotTargetPart = "LeftUpperLeg"
    end
end)

CreateSlider(CombatContent, "AimBot Дистанция", 50, 500, 200, function(value)
    -- Можно добавить ограничение дистанции если нужно
end)

-- TargetHUD (с перетаскиванием и настройками)
local targetHudSettings = {
    size = 320,
    backgroundTransparency = 0.15,
    strokeEnabled = true
}
local targetHudSettingsMenuOpen = false

CreateCheckbox(CombatContent, "TargetHUD", false, function(enabled)
    targetHudEnabled = enabled
    
    if enabled then
        -- Создаем TargetHUD
        local TargetHudGui = Instance.new("ScreenGui")
        TargetHudGui.Name = "TargetHudGui"
        TargetHudGui.ResetOnSpawn = false
        TargetHudGui.IgnoreGuiInset = true
        TargetHudGui.DisplayOrder = 100
        TargetHudGui.Parent = PlayerGui
        
        local TargetFrame = Instance.new("Frame")
        TargetFrame.Name = "TargetFrame"
        TargetFrame.Size = UDim2.new(0, targetHudSettings.size, 0, targetHudSettings.size * 0.28125)
        TargetFrame.Position = UDim2.new(0.5, -targetHudSettings.size/2, 0.3, 0)
        TargetFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        TargetFrame.BackgroundTransparency = targetHudSettings.backgroundTransparency
        TargetFrame.BorderSizePixel = 0
        TargetFrame.Visible = false
        TargetFrame.Parent = TargetHudGui
        
        local TargetCorner = Instance.new("UICorner")
        TargetCorner.CornerRadius = UDim.new(0, 12)
        TargetCorner.Parent = TargetFrame
        
        local TargetStroke = Instance.new("UIStroke")
        TargetStroke.Color = GetThemeColor()
        TargetStroke.Thickness = 2
        TargetStroke.Transparency = targetHudSettings.strokeEnabled and 0 or 1
        TargetStroke.Parent = TargetFrame
        
        -- Перетаскивание TargetHUD
        local draggingTarget = false
        local dragInputTarget, mousePosTarget, framePosTarget
        
        TargetFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingTarget = true
                mousePosTarget = input.Position
                framePosTarget = TargetFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingTarget = false
                    end
                end)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                -- Предотвращаем создание множества меню
                if targetHudSettingsMenuOpen then return end
                targetHudSettingsMenuOpen = true
                
                -- ПКМ - открываем настройки
                local SettingsMenu = Instance.new("Frame")
                SettingsMenu.Name = "TargetHudSettings"
                SettingsMenu.Size = UDim2.new(0, 200, 0, 150)
                SettingsMenu.Position = UDim2.new(0, input.Position.X, 0, input.Position.Y)
                SettingsMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                SettingsMenu.BorderSizePixel = 0
                SettingsMenu.ZIndex = 500
                SettingsMenu.Parent = ScreenGui
                
                local SettingsCorner = Instance.new("UICorner")
                SettingsCorner.CornerRadius = UDim.new(0, 10)
                SettingsCorner.Parent = SettingsMenu
                
                local SettingsStroke = Instance.new("UIStroke")
                SettingsStroke.Color = GetThemeColor()
                SettingsStroke.Thickness = 2
                SettingsStroke.Parent = SettingsMenu
                
                -- Перетаскивание меню настроек
                local draggingSettings = false
                local dragInputSettings, mousePosSettings, framePosSettings
                
                SettingsMenu.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSettings = true
                        mousePosSettings = inp.Position
                        framePosSettings = SettingsMenu.Position
                        
                        inp.Changed:Connect(function()
                            if inp.UserInputState == Enum.UserInputState.End then
                                draggingSettings = false
                            end
                        end)
                    end
                end)
                
                SettingsMenu.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        dragInputSettings = inp
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(inp)
                    if inp == dragInputSettings and draggingSettings then
                        local delta = inp.Position - mousePosSettings
                        SettingsMenu.Position = UDim2.new(
                            framePosSettings.X.Scale,
                            framePosSettings.X.Offset + delta.X,
                            framePosSettings.Y.Scale,
                            framePosSettings.Y.Offset + delta.Y
                        )
                    end
                end)
                
                -- Заголовок
                local SettingsTitle = Instance.new("TextLabel")
                SettingsTitle.Size = UDim2.new(1, -40, 0, 30)
                SettingsTitle.Position = UDim2.new(0, 10, 0, 5)
                SettingsTitle.BackgroundTransparency = 1
                SettingsTitle.Text = "⚙️ Настройки"
                SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingsTitle.TextSize = 14
                SettingsTitle.Font = Enum.Font.GothamBold
                SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
                SettingsTitle.Parent = SettingsMenu
                
                -- Кнопка закрытия
                local CloseBtn = Instance.new("TextButton")
                CloseBtn.Size = UDim2.new(0, 25, 0, 25)
                CloseBtn.Position = UDim2.new(1, -30, 0, 5)
                CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                CloseBtn.Text = "×"
                CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                CloseBtn.TextSize = 16
                CloseBtn.Font = Enum.Font.GothamBold
                CloseBtn.Parent = SettingsMenu
                
                local CloseBtnCorner = Instance.new("UICorner")
                CloseBtnCorner.CornerRadius = UDim.new(0, 6)
                CloseBtnCorner.Parent = CloseBtn
                
                CloseBtn.MouseButton1Click:Connect(function()
                    SettingsMenu:Destroy()
                    targetHudSettingsMenuOpen = false
                end)
                
                -- Слайдер размера
                local SizeLabel = Instance.new("TextLabel")
                SizeLabel.Size = UDim2.new(1, -20, 0, 20)
                SizeLabel.Position = UDim2.new(0, 10, 0, 40)
                SizeLabel.BackgroundTransparency = 1
                SizeLabel.Text = "Размер: " .. targetHudSettings.size
                SizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                SizeLabel.TextSize = 12
                SizeLabel.Font = Enum.Font.Gotham
                SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
                SizeLabel.Parent = SettingsMenu
                
                local SizeSlider = Instance.new("Frame")
                SizeSlider.Size = UDim2.new(1, -20, 0, 4)
                SizeSlider.Position = UDim2.new(0, 10, 0, 65)
                SizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                SizeSlider.BorderSizePixel = 0
                SizeSlider.Parent = SettingsMenu
                
                local SizeFill = Instance.new("Frame")
                SizeFill.Size = UDim2.new((targetHudSettings.size - 200) / 300, 0, 1, 0)
                SizeFill.BackgroundColor3 = GetThemeColor()
                SizeFill.BorderSizePixel = 0
                SizeFill.Parent = SizeSlider
                
                local SizeButton = Instance.new("TextButton")
                SizeButton.Size = UDim2.new(1, 0, 0, 20)
                SizeButton.Position = UDim2.new(0, 0, 0, -8)
                SizeButton.BackgroundTransparency = 1
                SizeButton.Text = ""
                SizeButton.Parent = SizeSlider
                
                local draggingSize = false
                SizeButton.MouseButton1Down:Connect(function() draggingSize = true end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSize = false end
                end)
                
                RunService.RenderStepped:Connect(function()
                    if draggingSize then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = math.clamp(mouse.X - SizeSlider.AbsolutePosition.X, 0, SizeSlider.AbsoluteSize.X)
                        local percentage = relativeX / SizeSlider.AbsoluteSize.X
                        targetHudSettings.size = math.floor(200 + (percentage * 300))
                        
                        SizeFill.Size = UDim2.new(percentage, 0, 1, 0)
                        SizeLabel.Text = "Размер: " .. targetHudSettings.size
                        
                        -- Обновляем размер TargetFrame И контейнера головы
                        TargetFrame.Size = UDim2.new(0, targetHudSettings.size, 0, targetHudSettings.size * 0.28125)
                        PlayerHeadContainer.Size = UDim2.new(0, targetHudSettings.size * 0.21875, 0, targetHudSettings.size * 0.21875)
                    end
                end)
                
                -- Слайдер прозрачности
                local TranspLabel = Instance.new("TextLabel")
                TranspLabel.Size = UDim2.new(1, -20, 0, 20)
                TranspLabel.Position = UDim2.new(0, 10, 0, 80)
                TranspLabel.BackgroundTransparency = 1
                TranspLabel.Text = "Прозрачность: " .. math.floor(targetHudSettings.backgroundTransparency * 100) .. "%"
                TranspLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                TranspLabel.TextSize = 12
                TranspLabel.Font = Enum.Font.Gotham
                TranspLabel.TextXAlignment = Enum.TextXAlignment.Left
                TranspLabel.Parent = SettingsMenu
                
                local TranspSlider = Instance.new("Frame")
                TranspSlider.Size = UDim2.new(1, -20, 0, 4)
                TranspSlider.Position = UDim2.new(0, 10, 0, 105)
                TranspSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                TranspSlider.BorderSizePixel = 0
                TranspSlider.Parent = SettingsMenu
                
                local TranspFill = Instance.new("Frame")
                TranspFill.Size = UDim2.new(targetHudSettings.backgroundTransparency, 0, 1, 0)
                TranspFill.BackgroundColor3 = GetThemeColor()
                TranspFill.BorderSizePixel = 0
                TranspFill.Parent = TranspSlider
                
                local TranspButton = Instance.new("TextButton")
                TranspButton.Size = UDim2.new(1, 0, 0, 20)
                TranspButton.Position = UDim2.new(0, 0, 0, -8)
                TranspButton.BackgroundTransparency = 1
                TranspButton.Text = ""
                TranspButton.Parent = TranspSlider
                
                local draggingTransp = false
                TranspButton.MouseButton1Down:Connect(function() draggingTransp = true end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingTransp = false end
                end)
                
                RunService.RenderStepped:Connect(function()
                    if draggingTransp then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = math.clamp(mouse.X - TranspSlider.AbsolutePosition.X, 0, TranspSlider.AbsoluteSize.X)
                        local percentage = relativeX / TranspSlider.AbsoluteSize.X
                        targetHudSettings.backgroundTransparency = percentage
                        
                        TranspFill.Size = UDim2.new(percentage, 0, 1, 0)
                        TranspLabel.Text = "Прозрачность: " .. math.floor(percentage * 100) .. "%"
                        TargetFrame.BackgroundTransparency = percentage
                    end
                end)
                
                -- Чекбокс обводки
                local StrokeCheck = Instance.new("TextButton")
                StrokeCheck.Size = UDim2.new(0, 20, 0, 20)
                StrokeCheck.Position = UDim2.new(0, 10, 0, 120)
                StrokeCheck.BackgroundColor3 = targetHudSettings.strokeEnabled and GetThemeColor() or Color3.fromRGB(60, 60, 70)
                StrokeCheck.Text = targetHudSettings.strokeEnabled and "✓" or ""
                StrokeCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
                StrokeCheck.TextSize = 14
                StrokeCheck.Font = Enum.Font.GothamBold
                StrokeCheck.Parent = SettingsMenu
                
                local StrokeCheckCorner = Instance.new("UICorner")
                StrokeCheckCorner.CornerRadius = UDim.new(0, 5)
                StrokeCheckCorner.Parent = StrokeCheck
                
                local StrokeLabel = Instance.new("TextLabel")
                StrokeLabel.Size = UDim2.new(1, -40, 0, 20)
                StrokeLabel.Position = UDim2.new(0, 35, 0, 120)
                StrokeLabel.BackgroundTransparency = 1
                StrokeLabel.Text = "Обводка"
                StrokeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                StrokeLabel.TextSize = 12
                StrokeLabel.Font = Enum.Font.Gotham
                StrokeLabel.TextXAlignment = Enum.TextXAlignment.Left
                StrokeLabel.Parent = SettingsMenu
                
                StrokeCheck.MouseButton1Click:Connect(function()
                    targetHudSettings.strokeEnabled = not targetHudSettings.strokeEnabled
                    StrokeCheck.BackgroundColor3 = targetHudSettings.strokeEnabled and GetThemeColor() or Color3.fromRGB(60, 60, 70)
                    StrokeCheck.Text = targetHudSettings.strokeEnabled and "✓" or ""
                    TargetStroke.Transparency = targetHudSettings.strokeEnabled and 0 or 1
                end)
            end
        end)
        
        TargetFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInputTarget = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInputTarget and draggingTarget then
                local delta = input.Position - mousePosTarget
                TargetFrame.Position = UDim2.new(
                    framePosTarget.X.Scale,
                    framePosTarget.X.Offset + delta.X,
                    framePosTarget.Y.Scale,
                    framePosTarget.Y.Offset + delta.Y
                )
            end
        end)
        
        -- Контейнер для головы игрока
        local PlayerHeadContainer = Instance.new("Frame")
        PlayerHeadContainer.Name = "PlayerHeadContainer"
        PlayerHeadContainer.Size = UDim2.new(0, 70, 0, 70)
        PlayerHeadContainer.Position = UDim2.new(0, 10, 0, 10)
        PlayerHeadContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        PlayerHeadContainer.BorderSizePixel = 0
        PlayerHeadContainer.Parent = TargetFrame
        
        local HeadCorner = Instance.new("UICorner")
        HeadCorner.CornerRadius = UDim.new(0, 10)
        HeadCorner.Parent = PlayerHeadContainer
        
        local PlayerHeadViewport = Instance.new("ViewportFrame")
        PlayerHeadViewport.Size = UDim2.new(1, 0, 1, 0)
        PlayerHeadViewport.BackgroundTransparency = 1
        PlayerHeadViewport.Parent = PlayerHeadContainer
        
        local ViewportCamera = Instance.new("Camera")
        ViewportCamera.Parent = PlayerHeadViewport
        PlayerHeadViewport.CurrentCamera = ViewportCamera
        
        -- Имя игрока
        local PlayerNameLabel = Instance.new("TextLabel")
        PlayerNameLabel.Size = UDim2.new(0, 220, 0, 35)
        PlayerNameLabel.Position = UDim2.new(0, 90, 0, 10)
        PlayerNameLabel.BackgroundTransparency = 1
        PlayerNameLabel.Text = ""
        PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerNameLabel.TextSize = 22
        PlayerNameLabel.Font = Enum.Font.GothamBold
        PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayerNameLabel.Parent = TargetFrame
        
        -- Health bar фон
        local HealthBarBg = Instance.new("Frame")
        HealthBarBg.Size = UDim2.new(0, 220, 0, 20)
        HealthBarBg.Position = UDim2.new(0, 90, 0, 55)
        HealthBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        HealthBarBg.BorderSizePixel = 0
        HealthBarBg.Parent = TargetFrame
        
        local HealthBgCorner = Instance.new("UICorner")
        HealthBgCorner.CornerRadius = UDim.new(0, 8)
        HealthBgCorner.Parent = HealthBarBg
        
        -- Health bar заполнение
        local HealthBar = Instance.new("Frame")
        HealthBar.Size = UDim2.new(1, 0, 1, 0)
        HealthBar.BackgroundColor3 = GetThemeColor()
        HealthBar.BorderSizePixel = 0
        HealthBar.Parent = HealthBarBg
        
        local HealthCorner = Instance.new("UICorner")
        HealthCorner.CornerRadius = UDim.new(0, 8)
        HealthCorner.Parent = HealthBar
        
        -- Обновление TargetHUD
        RunService.RenderStepped:Connect(function()
            -- Показываем только если аимбот включен
            if not aimbotEnabled or not targetHudEnabled then
                TargetFrame.Visible = false
                return
            end
            
            local target = GetClosestPlayer()
            
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                local humanoid = target.Character.Humanoid
                
                if humanoid.Health > 0 then
                    TargetFrame.Visible = true
                    PlayerNameLabel.Text = target.Name
                    
                    -- Анимация health bar
                    local healthPercentage = humanoid.Health / humanoid.MaxHealth
                    HealthBar:TweenSize(
                        UDim2.new(healthPercentage, 0, 1, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    
                    -- Обновляем цвет в зависимости от здоровья
                    if healthPercentage > 0.6 then
                        HealthBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                    elseif healthPercentage > 0.3 then
                        HealthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                    else
                        HealthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    end
                    
                    -- Рендерим голову игрока
                    local head = target.Character:FindFirstChild("Head")
                    if head then
                        -- Очищаем viewport
                        for _, obj in pairs(PlayerHeadViewport:GetChildren()) do
                            if obj ~= ViewportCamera then
                                obj:Destroy()
                            end
                        end
                        
                        -- Клонируем голову
                        local headClone = head:Clone()
                        headClone.Parent = PlayerHeadViewport
                        
                        -- Позиционируем камеру
                        ViewportCamera.CFrame = CFrame.new(headClone.Position + Vector3.new(0, 0, 2.5), headClone.Position)
                    end
                    
                    TargetStroke.Color = GetThemeColor()
                else
                    TargetFrame.Visible = false
                end
            else
                TargetFrame.Visible = false
            end
        end)
    else
        local existingGui = PlayerGui:FindFirstChild("TargetHudGui")
        if existingGui then
            existingGui:Destroy()
        end
        targetHudSettingsMenuOpen = false
    end
end)

-- ===== PLAYER TAB =====
local PlayerContent = TabContents["Player"]

CreateSlider(PlayerContent, "Speed Power", 16, 200, 16, function(value)
    Config.Settings.SpeedPower = value
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = value
    end
end)

CreateSlider(PlayerContent, "Jump Power", 50, 300, 50, function(value)
    Config.Settings.JumpPower = value
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = value
    end
end)

CreateSlider(PlayerContent, "Jump Power", 50, 300, 50, function(value)
    Config.Settings.JumpPower = value
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = value
    end
end)

CreateSlider(PlayerContent, "Gravity", 0, 196, 196, function(value)
    Config.Settings.Gravity = value
    Workspace.Gravity = value
end)

local flyConnection = nil
CreateCheckbox(PlayerContent, "Fly (Полет)", false, function(enabled)
    Config.Settings.FlyEnabled = enabled
    
    if enabled then
        local character = Player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not Config.Settings.FlyEnabled then return end
            
            local camera = Workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveDirection * Config.Settings.FlySpeed
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                for _, obj in pairs(humanoidRootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

CreateSlider(PlayerContent, "Fly Speed", 10, 200, 50, function(value)
    Config.Settings.FlySpeed = value
end)

-- Misc ESP
local MiscContent = TabContents["Misc"]

local ESPEnabled = false
local ESPConnections = {}

CreateCheckbox(MiscContent, "ESP (Подсветка игроков)", false, function(enabled)
    ESPEnabled = enabled
    Config.Settings.ESPEnabled = enabled
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                local character = player.Character
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Config.Settings.ESPColor
                highlight.OutlineColor = Config.Settings.ESPColor
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
            end
        end
        
        table.insert(ESPConnections, Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if ESPEnabled then
                    wait(0.5)
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Config.Settings.ESPColor
                    highlight.OutlineColor = Config.Settings.ESPColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = character
                end
            end)
        end))
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        
        for _, connection in pairs(ESPConnections) do
            connection:Disconnect()
        end
        ESPConnections = {}
    end
end)

CreateColorPicker(MiscContent, "Цвет ESP", Config.Settings.ESPColor, function(color)
    Config.Settings.ESPColor = color
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                end
            end
        end
    end
end)

CreateSlider(MiscContent, "FOV Changer", 70, 120, 70, function(value)
    Config.Settings.FOVValue = value
    Camera.FieldOfView = value
end)

-- NameTags (перемещены в Misc)
local nameTagsEnabled = false
local nameTags = {}

local function CreateNameTag(player)
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "NameTag"
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Parent = player.Character.Head
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Config.Settings.NameTagsColor
    NameLabel.TextSize = Config.Settings.NameTagsSize
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.Parent = BillboardGui
    
    nameTags[player.UserId] = BillboardGui
end

local function RemoveNameTag(player)
    if nameTags[player.UserId] then
        nameTags[player.UserId]:Destroy()
        nameTags[player.UserId] = nil
    end
end

local function UpdateAllNameTags()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            local tag = nameTags[player.UserId]
            if tag and tag:FindFirstChild("TextLabel") then
                tag.TextLabel.TextColor3 = Config.Settings.NameTagsColor
                tag.TextLabel.TextSize = Config.Settings.NameTagsSize
            end
        end
    end
end

CreateCheckbox(MiscContent, "NameTags (Никнеймы)", false, function(enabled)
    nameTagsEnabled = enabled
    Config.Settings.NameTagsEnabled = enabled
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                CreateNameTag(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if nameTagsEnabled then
                    wait(0.5)
                    CreateNameTag(player)
                end
            end)
        end)
    else
        for userId, tag in pairs(nameTags) do
            tag:Destroy()
        end
        nameTags = {}
    end
end)

CreateColorPicker(MiscContent, "Цвет никнеймов", Config.Settings.NameTagsColor, function(color)
    Config.Settings.NameTagsColor = color
    UpdateAllNameTags()
end)

CreateSlider(MiscContent, "Размер никнеймов", 10, 30, 16, function(value)
    Config.Settings.NameTagsSize = value
    UpdateAllNameTags()
end)

-- ===== VISUALS TAB =====
local VisualsContent = TabContents["Visuals"]

CreateDropdown(VisualsContent, "Небо", {"Дефолт", "День", "Ночь", "Вечер", "Северное сияние"}, "Дефолт", function(selected)
    Config.Settings.AmbienceType = selected
    
    task.spawn(function()
        -- Удаляем старые эффекты
        for _, child in pairs(Lighting:GetChildren()) do
            if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") then
                if child.Name ~= "CustomSkyAtmosphere" then
                    child:Destroy()
                end
            end
        end
        
        wait(0.1)
        
        if selected == "Дефолт" then
            -- Возвращаем дефолтные настройки
            Lighting.TimeOfDay = "14:00:00"
            Lighting.ClockTime = 14
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.FogEnd = 100000
            
        elseif selected == "День" then
            Lighting.TimeOfDay = "14:00:00"
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(170, 170, 170)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.FogEnd = 100000
            
            local sky = Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://271042516"
            sky.SkyboxDn = "rbxassetid://271077243"
            sky.SkyboxFt = "rbxassetid://271042556"
            sky.SkyboxLf = "rbxassetid://271042310"
            sky.SkyboxRt = "rbxassetid://271042467"
            sky.SkyboxUp = "rbxassetid://271077958"
            sky.Parent = Lighting
            
        elseif selected == "Ночь" then
            Lighting.TimeOfDay = "00:00:00"
            Lighting.ClockTime = 0
            Lighting.Brightness = 0.5
            Lighting.Ambient = Color3.fromRGB(30, 30, 60)
            Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
            Lighting.FogEnd = 100000
            
            local sky = Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://12064107"
            sky.SkyboxDn = "rbxassetid://12064152"
            sky.SkyboxFt = "rbxassetid://12064121"
            sky.SkyboxLf = "rbxassetid://12063984"
            sky.SkyboxRt = "rbxassetid://12064115"
            sky.SkyboxUp = "rbxassetid://12064131"
            sky.Parent = Lighting
            
        elseif selected == "Вечер" then
            Lighting.TimeOfDay = "18:00:00"
            Lighting.ClockTime = 18
            Lighting.Brightness = 1.5
            Lighting.Ambient = Color3.fromRGB(200, 120, 80)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 120, 80)
            Lighting.FogEnd = 100000
            
            local sky = Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://570557514"
            sky.SkyboxDn = "rbxassetid://570557775"
            sky.SkyboxFt = "rbxassetid://570557559"
            sky.SkyboxLf = "rbxassetid://570557620"
            sky.SkyboxRt = "rbxassetid://570557672"
            sky.SkyboxUp = "rbxassetid://570557727"
            sky.SunAngularSize = 14
            sky.Parent = Lighting
            
            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Intensity = 0.2
            sunRays.Spread = 1
            sunRays.Parent = Lighting
            
        elseif selected == "Северное сияние" then
            Lighting.TimeOfDay = "23:00:00"
            Lighting.ClockTime = 23
            Lighting.Brightness = 1.2
            Lighting.Ambient = Color3.fromRGB(100, 220, 150)
            Lighting.OutdoorAmbient = Color3.fromRGB(80, 200, 120)
            Lighting.FogEnd = 100000
            
            local sky = Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://318557550"
            sky.SkyboxDn = "rbxassetid://318557780"
            sky.SkyboxFt = "rbxassetid://318557645"
            sky.SkyboxLf = "rbxassetid://318557664"
            sky.SkyboxRt = "rbxassetid://318557690"
            sky.SkyboxUp = "rbxassetid://318557725"
            sky.StarCount = 5000
            sky.Parent = Lighting
            
            local atmosphere = Instance.new("Atmosphere")
            atmosphere.Density = 0.4
            atmosphere.Offset = 0.5
            atmosphere.Color = Color3.fromRGB(120, 255, 180)
            atmosphere.Decay = Color3.fromRGB(100, 220, 150)
            atmosphere.Glare = 0.6
            atmosphere.Haze = 1.5
            atmosphere.Parent = Lighting
            
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.TintColor = Color3.fromRGB(200, 255, 220)
            colorCorrection.Brightness = 0.05
            colorCorrection.Parent = Lighting
            
            local bloom = Instance.new("BloomEffect")
            bloom.Intensity = 0.5
            bloom.Size = 24
            bloom.Threshold = 0.8
            bloom.Parent = Lighting
        end
    end)
end)

local currentWeatherEffect = nil
local weatherUpdateConnection = nil

CreateDropdown(VisualsContent, "Погода", {"Нет", "Снег", "Дождь", "Молния"}, "Нет", function(selected)
    Config.Settings.WeatherType = selected
    
    task.spawn(function()
        -- Удаляем старую погоду
        if currentWeatherEffect then
            pcall(function() currentWeatherEffect:Destroy() end)
            currentWeatherEffect = nil
        end
        
        if weatherUpdateConnection then
            weatherUpdateConnection:Disconnect()
            weatherUpdateConnection = nil
        end
        
        -- Удаляем все старые эффекты погоды
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "WeatherEffect" or obj.Name == "LightningBolt" then
                pcall(function() obj:Destroy() end)
            end
        end
        
        wait(0.2)
        
        if selected == "Снег" then
            local Snow = Instance.new("Part")
            Snow.Name = "WeatherEffect"
            Snow.Size = Vector3.new(500, 1, 500)
            Snow.Position = Vector3.new(0, 200, 0)
            Snow.Anchored = true
            Snow.Transparency = 1
            Snow.CanCollide = false
            Snow.Parent = Workspace
            
            local Emitter = Instance.new("ParticleEmitter")
            Emitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
            Emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            Emitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(0.5, 1.2),
                NumberSequenceKeypoint.new(1, 0.6)
            })
            Emitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.5)
            })
            Emitter.Lifetime = NumberRange.new(15, 25)
            Emitter.Rate = 200
            Emitter.Rotation = NumberRange.new(0, 360)
            Emitter.RotSpeed = NumberRange.new(-200, 200)
            Emitter.Speed = NumberRange.new(5, 12)
            Emitter.SpreadAngle = Vector2.new(30, 30)
            Emitter.Acceleration = Vector3.new(0, -15, 0)
            Emitter.Drag = 3
            Emitter.VelocityInheritance = 0
            Emitter.Parent = Snow
            
            currentWeatherEffect = Snow
            
            weatherUpdateConnection = RunService.Heartbeat:Connect(function()
                if currentWeatherEffect and currentWeatherEffect.Parent then
                    local camPos = Camera.CFrame.Position
                    currentWeatherEffect.Position = Vector3.new(camPos.X, camPos.Y + 120, camPos.Z)
                end
            end)
            
        elseif selected == "Дождь" then
            local Rain = Instance.new("Part")
            Rain.Name = "WeatherEffect"
            Rain.Size = Vector3.new(500, 1, 500)
            Rain.Position = Vector3.new(0, 200, 0)
            Rain.Anchored = true
            Rain.Transparency = 1
            Rain.CanCollide = false
            Rain.Parent = Workspace
            
            local Emitter = Instance.new("ParticleEmitter")
            Emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            Emitter.Color = ColorSequence.new(Color3.fromRGB(120, 180, 255))
            Emitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 0.3)
            })
            Emitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.4)
            })
            Emitter.Lifetime = NumberRange.new(0.8, 1.5)
            Emitter.Rate = 600
            Emitter.Rotation = NumberRange.new(0, 0)
            Emitter.Speed = NumberRange.new(120, 150)
            Emitter.SpreadAngle = Vector2.new(2, 2)
            Emitter.Acceleration = Vector3.new(0, -200, 0)
            Emitter.Drag = 0
            Emitter.VelocityInheritance = 0
            Emitter.Parent = Rain
            
            currentWeatherEffect = Rain
            
            weatherUpdateConnection = RunService.Heartbeat:Connect(function()
                if currentWeatherEffect and currentWeatherEffect.Parent then
                    local camPos = Camera.CFrame.Position
                    currentWeatherEffect.Position = Vector3.new(camPos.X, camPos.Y + 120, camPos.Z)
                end
            end)
            
        elseif selected == "Молния" then
            -- Затемняем небо для эффекта грозы
            Lighting.ClockTime = 1
            Lighting.Brightness = 0.3
            Lighting.Ambient = Color3.fromRGB(50, 50, 80)
            Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
            
            -- Создаем молнии
            weatherUpdateConnection = task.spawn(function()
                while Config.Settings.WeatherType == "Молния" do
                    wait(math.random(2, 6))
                    
                    -- Вспышка молнии
                    local flash = Instance.new("ColorCorrectionEffect")
                    flash.Brightness = 0.8
                    flash.TintColor = Color3.fromRGB(200, 220, 255)
                    flash.Parent = Lighting
                    
                    -- Звук грома
                    local thunder = Instance.new("Sound")
                    thunder.SoundId = "rbxassetid://130818250"
                    thunder.Volume = 0.5
                    thunder.Parent = Workspace
                    thunder:Play()
                    
                    -- Визуальная молния
                    local bolt = Instance.new("Part")
                    bolt.Name = "LightningBolt"
                    bolt.Size = Vector3.new(1, 200, 1)
                    bolt.CFrame = CFrame.new(
                        Camera.CFrame.Position + Vector3.new(
                            math.random(-100, 100),
                            100,
                            math.random(-100, 100)
                        )
                    )
                    bolt.Anchored = true
                    bolt.CanCollide = false
                    bolt.Material = Enum.Material.Neon
                    bolt.BrickColor = BrickColor.new("Electric blue")
                    bolt.Transparency = 0.3
                    bolt.Parent = Workspace
                    
                    local light = Instance.new("PointLight")
                    light.Brightness = 10
                    light.Range = 100
                    light.Color = Color3.fromRGB(150, 200, 255)
                    light.Parent = bolt
                    
                    -- Анимация исчезновения
                    task.wait(0.1)
                    TweenService:Create(flash, TweenInfo.new(0.3), {Brightness = 0}):Play()
                    task.wait(0.05)
                    bolt.Transparency = 0.7
                    task.wait(0.05)
                    bolt.Transparency = 1
                    task.wait(0.2)
                    flash:Destroy()
                    bolt:Destroy()
                    task.wait(0.5)
                    thunder:Destroy()
                end
            end)
        end
    end)
end)

-- Пользовательский цвет неба с хром-эффектом (ТОЛЬКО НЕБО, НЕ ТЕКСТУРЫ!)
local customSkyColorEnabled = false
local customSkyColor = Color3.fromRGB(255, 105, 180)
local skyColorConnection = nil

CreateCheckbox(VisualsContent, "Свой цвет неба", false, function(enabled)
    customSkyColorEnabled = enabled
    
    if enabled then
        -- Хром-анимация для НЕБА (не текстур!)
        local lastUpdate = tick()
        skyColorConnection = RunService.Heartbeat:Connect(function()
            if not customSkyColorEnabled then return end
            
            local currentTime = tick()
            if currentTime - lastUpdate < 0.05 then return end
            lastUpdate = currentTime
            
            local time = currentTime * 0.8
            local wave = math.sin(time) * 0.5 + 0.5
            local wave2 = math.sin(time * 1.3 + 1) * 0.5 + 0.5
            local wave3 = math.sin(time * 0.7 + 2) * 0.5 + 0.5
            
            local r = customSkyColor.R + (wave - 0.5) * 0.2
            local g = customSkyColor.G + (wave2 - 0.5) * 0.2
            local b = customSkyColor.B + (wave3 - 0.5) * 0.2
            
            r = math.clamp(r, 0, 1)
            g = math.clamp(g, 0, 1)
            b = math.clamp(b, 0, 1)
            
            local animatedColor = Color3.new(r, g, b)
            
            -- Создаем Atmosphere для изменения ТОЛЬКО неба
            local atmos = Lighting:FindFirstChild("CustomSkyAtmosphere")
            if not atmos then
                atmos = Instance.new("Atmosphere")
                atmos.Name = "CustomSkyAtmosphere"
                atmos.Parent = Lighting
            end
            
            -- Настраиваем атмосферу чтобы менялось только небо
            atmos.Density = 0.5
            atmos.Offset = 1
            atmos.Color = animatedColor
            atmos.Decay = animatedColor
            atmos.Glare = 1
            atmos.Haze = 3
        end)
    else
        if skyColorConnection then
            skyColorConnection:Disconnect()
            skyColorConnection = nil
        end
        
        -- Убираем кастомную атмосферу
        local atmos = Lighting:FindFirstChild("CustomSkyAtmosphere")
        if atmos then
            atmos:Destroy()
        end
    end
end)

CreateColorPicker(VisualsContent, "Цвет неба (хром)", customSkyColor, function(color)
    customSkyColor = color
end)

-- Crosshair (исправленный и центрированный)
local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "CrosshairGui"
CrosshairGui.ResetOnSpawn = false
CrosshairGui.IgnoreGuiInset = true
CrosshairGui.Enabled = false
CrosshairGui.DisplayOrder = 999
CrosshairGui.Parent = PlayerGui

local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Size = UDim2.new(0, 100, 0, 100)
CrosshairFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Parent = CrosshairGui

local HorizontalLineLeft = Instance.new("Frame")
HorizontalLineLeft.Name = "HLeft"
HorizontalLineLeft.BackgroundColor3 = Config.Settings.CrosshairColor
HorizontalLineLeft.BorderSizePixel = 0
HorizontalLineLeft.Parent = CrosshairFrame

local HorizontalLineRight = Instance.new("Frame")
HorizontalLineRight.Name = "HRight"
HorizontalLineRight.BackgroundColor3 = Config.Settings.CrosshairColor
HorizontalLineRight.BorderSizePixel = 0
HorizontalLineRight.Parent = CrosshairFrame

local VerticalLineTop = Instance.new("Frame")
VerticalLineTop.Name = "VTop"
VerticalLineTop.BackgroundColor3 = Config.Settings.CrosshairColor
VerticalLineTop.BorderSizePixel = 0
VerticalLineTop.Parent = CrosshairFrame

local VerticalLineBottom = Instance.new("Frame")
VerticalLineBottom.Name = "VBottom"
VerticalLineBottom.BackgroundColor3 = Config.Settings.CrosshairColor
VerticalLineBottom.BorderSizePixel = 0
VerticalLineBottom.Parent = CrosshairFrame

local CenterDot = Instance.new("Frame")
CenterDot.Name = "Dot"
CenterDot.BackgroundColor3 = Config.Settings.CrosshairColor
CenterDot.BorderSizePixel = 0
CenterDot.Visible = Config.Settings.CrosshairDot
CenterDot.Parent = CrosshairFrame

local function UpdateCrosshair()
    local gap = 4
    local length = Config.Settings.CrosshairLength
    local thickness = Config.Settings.CrosshairThickness
    local centerX = 50
    local centerY = 50
    
    -- Горизонтальная левая линия
    HorizontalLineLeft.Size = UDim2.new(0, length, 0, thickness)
    HorizontalLineLeft.Position = UDim2.new(0, centerX - gap - length, 0, centerY - thickness/2)
    
    -- Горизонтальная правая линия
    HorizontalLineRight.Size = UDim2.new(0, length, 0, thickness)
    HorizontalLineRight.Position = UDim2.new(0, centerX + gap, 0, centerY - thickness/2)
    
    -- Вертикальная верхняя линия
    VerticalLineTop.Size = UDim2.new(0, thickness, 0, length)
    VerticalLineTop.Position = UDim2.new(0, centerX - thickness/2, 0, centerY - gap - length)
    
    -- Вертикальная нижняя линия
    VerticalLineBottom.Size = UDim2.new(0, thickness, 0, length)
    VerticalLineBottom.Position = UDim2.new(0, centerX - thickness/2, 0, centerY + gap)
    
    -- Центральная точка
    CenterDot.Size = UDim2.new(0, 3, 0, 3)
    CenterDot.Position = UDim2.new(0, centerX - 1.5, 0, centerY - 1.5)
    CenterDot.Visible = Config.Settings.CrosshairDot
end

UpdateCrosshair()

CreateCheckbox(VisualsContent, "Crosshair (Прицел)", false, function(enabled)
    Config.Settings.CrosshairEnabled = enabled
    CrosshairGui.Enabled = enabled
end)

CreateColorPicker(VisualsContent, "Цвет прицела", Config.Settings.CrosshairColor, function(color)
    Config.Settings.CrosshairColor = color
    HorizontalLineLeft.BackgroundColor3 = color
    HorizontalLineRight.BackgroundColor3 = color
    VerticalLineTop.BackgroundColor3 = color
    VerticalLineBottom.BackgroundColor3 = color
    CenterDot.BackgroundColor3 = color
end)

CreateSlider(VisualsContent, "Длина прицела", 4, 20, 8, function(value)
    Config.Settings.CrosshairLength = value
    UpdateCrosshair()
end)

CreateSlider(VisualsContent, "Толщина прицела", 1, 5, 2, function(value)
    Config.Settings.CrosshairThickness = value
    UpdateCrosshair()
end)

CreateCheckbox(VisualsContent, "Точка в центре", true, function(enabled)
    Config.Settings.CrosshairDot = enabled
    UpdateCrosshair()
end)

-- ===== SETTINGS TAB =====
local SettingsContent = TabContents["Settings"]

local ThemeFrame = Instance.new("Frame")
ThemeFrame.Size = UDim2.new(1, 0, 0, 120)
ThemeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ThemeFrame.Parent = SettingsContent

local ThemeCorner = Instance.new("UICorner")
ThemeCorner.CornerRadius = UDim.new(0, 11)
ThemeCorner.Parent = ThemeFrame

-- Обводка
local ThemeStroke = Instance.new("UIStroke")
ThemeStroke.Color = Color3.fromRGB(50, 50, 60)
ThemeStroke.Thickness = 1
ThemeStroke.Transparency = 0.8
ThemeStroke.Parent = ThemeFrame

local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Size = UDim2.new(1, -20, 0, 30)
ThemeLabel.Position = UDim2.new(0, 10, 0, 8)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "🎨 Тема GUI"
ThemeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ThemeLabel.TextSize = 16
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
ThemeLabel.Parent = ThemeFrame

local ColorScroll = Instance.new("ScrollingFrame")
ColorScroll.Size = UDim2.new(1, -20, 0, 72)
ColorScroll.Position = UDim2.new(0, 10, 0, 42)
ColorScroll.BackgroundTransparency = 1
ColorScroll.BorderSizePixel = 0
ColorScroll.ScrollBarThickness = 4
ColorScroll.ScrollBarImageColor3 = GetThemeColor()
ColorScroll.ScrollingDirection = Enum.ScrollingDirection.X
ColorScroll.Parent = ThemeFrame

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(0, 0, 1, 0)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = ColorScroll

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 6)
ColorLayout.SortOrder = Enum.SortOrder.LayoutOrder
ColorLayout.Parent = ColorContainer

ColorLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ColorScroll.CanvasSize = UDim2.new(0, ColorLayout.AbsoluteContentSize.X + 10, 0, 0)
    ColorContainer.Size = UDim2.new(0, ColorLayout.AbsoluteContentSize.X + 10, 1, 0)
end)

local themeButtons = {}
for i, color in ipairs(ColorPalette) do
    local ColorButton = Instance.new("TextButton")
    ColorButton.Size = UDim2.new(0, 38, 0, 38)
    ColorButton.BackgroundColor3 = color
    ColorButton.BorderSizePixel = 0
    ColorButton.Text = ""
    ColorButton.AutoButtonColor = false
    ColorButton.Parent = ColorContainer
    
    local ColorButtonCorner = Instance.new("UICorner")
    ColorButtonCorner.CornerRadius = UDim.new(0, 9)
    ColorButtonCorner.Parent = ColorButton
    
    local ColorButtonStroke = Instance.new("UIStroke")
    ColorButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ColorButtonStroke.Thickness = Config.Theme == color and 3 or 0
    ColorButtonStroke.Transparency = Config.Theme == color and 0 or 1
    ColorButtonStroke.Parent = ColorButton
    
    table.insert(themeButtons, {button = ColorButton, stroke = ColorButtonStroke, color = color})
    
    ColorButton.MouseEnter:Connect(function()
        if Config.Theme ~= color then
            ColorButtonStroke.Thickness = 2
            ColorButtonStroke.Transparency = 0.5
        end
    end)
    
    ColorButton.MouseLeave:Connect(function()
        if Config.Theme ~= color then
            ColorButtonStroke.Thickness = 0
            ColorButtonStroke.Transparency = 1
        end
    end)
    
    ColorButton.MouseButton1Click:Connect(function()
        Config.Theme = color
        
        for _, themeBtn in pairs(themeButtons) do
            if themeBtn.color == color then
                themeBtn.stroke.Thickness = 3
                themeBtn.stroke.Transparency = 0
            else
                themeBtn.stroke.Thickness = 0
                themeBtn.stroke.Transparency = 1
            end
        end
        
        TabButtons[CurrentTab].BackgroundColor3 = GetThemeColor()
        ContentScroll.ScrollBarImageColor3 = GetThemeColor()
    end)
end

-- ===== KEYBINDS TAB =====
local KeyBindsContent = TabContents["KeyBinds"]

-- Хранилище функций для биндов
local BindableFunctions = {
    {name = "AimBot", func = function() 
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            aimbotConnection = RunService.RenderStepped:Connect(function()
                if not aimbotEnabled then return end
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                end
            end)
        else
            if aimbotConnection then aimbotConnection:Disconnect() end
        end
    end},
    {name = "ESP", func = function()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Config.Settings.ESPColor
                    highlight.OutlineColor = Config.Settings.ESPColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("ESPHighlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end},
    {name = "Fly", func = function()
        Config.Settings.FlyEnabled = not Config.Settings.FlyEnabled
        
        if Config.Settings.FlyEnabled then
            local character = Player.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = humanoidRootPart
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = humanoidRootPart.CFrame
            bodyGyro.Parent = humanoidRootPart
            
            if flyConnection then
                flyConnection:Disconnect()
            end
            
            flyConnection = RunService.RenderStepped:Connect(function()
                if not Config.Settings.FlyEnabled then return end
                
                local camera = Workspace.CurrentCamera
                local moveDirection = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDirection * Config.Settings.FlySpeed
                bodyGyro.CFrame = camera.CFrame
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            local character = Player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    for _, obj in pairs(humanoidRootPart:GetChildren()) do
                        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                            obj:Destroy()
                        end
                    end
                end
            end
        end
    end},
    {name = "Crosshair", func = function()
        Config.Settings.CrosshairEnabled = not Config.Settings.CrosshairEnabled
        CrosshairGui.Enabled = Config.Settings.CrosshairEnabled
    end},
    {name = "NameTags", func = function()
        nameTagsEnabled = not nameTagsEnabled
        -- Код nametags
    end},
    {name = "GUI Toggle", func = function()
        MainFrame.Visible = not MainFrame.Visible
    end}
}

local KeyBindTitle = Instance.new("TextLabel")
KeyBindTitle.Size = UDim2.new(1, 0, 0, 40)
KeyBindTitle.BackgroundTransparency = 1
KeyBindTitle.Text = "⌨️ Нажмите на функцию и нажмите клавишу для привязки"
KeyBindTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyBindTitle.TextSize = 12
KeyBindTitle.Font = Enum.Font.GothamBold
KeyBindTitle.TextWrapped = true
KeyBindTitle.Parent = KeyBindsContent

for _, bindData in ipairs(BindableFunctions) do
    local BindFrame = Instance.new("Frame")
    BindFrame.Size = UDim2.new(1, 0, 0, 44)
    BindFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    BindFrame.Parent = KeyBindsContent
    
    local BindCorner = Instance.new("UICorner")
    BindCorner.CornerRadius = UDim.new(0, 11)
    BindCorner.Parent = BindFrame
    
    local BindStroke = Instance.new("UIStroke")
    BindStroke.Color = Color3.fromRGB(50, 50, 60)
    BindStroke.Thickness = 1
    BindStroke.Transparency = 0.8
    BindStroke.Parent = BindFrame
    
    local BindLabel = Instance.new("TextLabel")
    BindLabel.Size = UDim2.new(0.6, 0, 1, 0)
    BindLabel.Position = UDim2.new(0, 10, 0, 0)
    BindLabel.BackgroundTransparency = 1
    BindLabel.Text = bindData.name
    BindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindLabel.TextSize = 14
    BindLabel.Font = Enum.Font.Gotham
    BindLabel.TextXAlignment = Enum.TextXAlignment.Left
    BindLabel.Parent = BindFrame
    
    local BindButton = Instance.new("TextButton")
    BindButton.Size = UDim2.new(0.4, -50, 0, 30)
    BindButton.Position = UDim2.new(0.6, 5, 0.5, -15)
    BindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    BindButton.Text = KeyBinds[bindData.name] or "Не привязано"
    BindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindButton.TextSize = 12
    BindButton.Font = Enum.Font.GothamBold
    BindButton.Parent = BindFrame
    
    local BindButtonCorner = Instance.new("UICorner")
    BindButtonCorner.CornerRadius = UDim.new(0, 8)
    BindButtonCorner.Parent = BindButton
    
    -- Кнопка удаления бинда
    local RemoveButton = Instance.new("TextButton")
    RemoveButton.Size = UDim2.new(0, 30, 0, 30)
    RemoveButton.Position = UDim2.new(1, -38, 0.5, -15)
    RemoveButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    RemoveButton.Text = "×"
    RemoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoveButton.TextSize = 18
    RemoveButton.Font = Enum.Font.GothamBold
    RemoveButton.Visible = KeyBinds[bindData.name] ~= nil
    RemoveButton.Parent = BindFrame
    
    local RemoveCorner = Instance.new("UICorner")
    RemoveCorner.CornerRadius = UDim.new(0, 8)
    RemoveCorner.Parent = RemoveButton
    
    RemoveButton.MouseButton1Click:Connect(function()
        KeyBinds[bindData.name] = nil
        BindButton.Text = "Не привязано"
        RemoveButton.Visible = false
    end)
    
    local listening = false
    
    BindButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        -- Проверяем, не занята ли уже эта клавиша
        for funcName, key in pairs(KeyBinds) do
            if funcName ~= bindData.name then
                for _, otherBind in ipairs(BindableFunctions) do
                    if otherBind.name == funcName then
                        -- Сбрасываем другие прослушивания
                    end
                end
            end
        end
        
        listening = true
        BindButton.Text = "Нажмите клавишу..."
        BindButton.BackgroundColor3 = GetThemeColor()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name
                
                -- Проверяем, не занята ли клавиша
                for funcName, existingKey in pairs(KeyBinds) do
                    if existingKey == keyName and funcName ~= bindData.name then
                        BindButton.Text = "Занято!"
                        BindButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        wait(1)
                        BindButton.Text = KeyBinds[bindData.name] or "Не привязано"
                        BindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                        listening = false
                        connection:Disconnect()
                        return
                    end
                end
                
                KeyBinds[bindData.name] = keyName
                BindButton.Text = keyName
                BindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                RemoveButton.Visible = true
                listening = false
                connection:Disconnect()
            end
        end)
    end)
end

-- Обработчик нажатий клавиш для выполнения функций
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        
        for _, bindData in ipairs(BindableFunctions) do
            if KeyBinds[bindData.name] == keyName then
                bindData.func()
            end
        end
    end
end)

-- Установка начальной вкладки
TabButtons["Visuals"].BackgroundColor3 = GetThemeColor()
TabButtons["Visuals"].TextColor3 = Color3.fromRGB(255, 255, 255)
TabContents["Visuals"].Visible = true

-- ===== ВСТУПИТЕЛЬНАЯ АНИМАЦИЯ =====
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = "DelightHubIntro"
IntroGui.ResetOnSpawn = false
IntroGui.IgnoreGuiInset = true
IntroGui.DisplayOrder = 1000
IntroGui.Parent = PlayerGui

local IntroBackground = Instance.new("Frame")
IntroBackground.Size = UDim2.new(1, 0, 1, 0)
IntroBackground.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
IntroBackground.BorderSizePixel = 0
IntroBackground.Parent = IntroGui

local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
})
IntroGradient.Rotation = 45
IntroGradient.Parent = IntroBackground

local IntroLogo = Instance.new("TextLabel")
IntroLogo.Size = UDim2.new(0, 400, 0, 100)
IntroLogo.Position = UDim2.new(0.5, -200, 0.5, -80)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Text = "🌸"
IntroLogo.TextColor3 = GetThemeColor()
IntroLogo.TextSize = 1
IntroLogo.Font = Enum.Font.GothamBold
IntroLogo.TextTransparency = 1
IntroLogo.Parent = IntroBackground

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(0, 400, 0, 60)
IntroTitle.Position = UDim2.new(0.5, -200, 0.5, 20)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "DelightHub"
IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroTitle.TextSize = 1
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextTransparency = 1
IntroTitle.Parent = IntroBackground

local IntroSubtext = Instance.new("TextLabel")
IntroSubtext.Size = UDim2.new(0, 400, 0, 40)
IntroSubtext.Position = UDim2.new(0.5, -200, 0.5, 90)
IntroSubtext.BackgroundTransparency = 1
IntroSubtext.Text = "Загрузка..."
IntroSubtext.TextColor3 = Color3.fromRGB(180, 180, 180)
IntroSubtext.TextSize = 1
IntroSubtext.Font = Enum.Font.Gotham
IntroSubtext.TextTransparency = 1
IntroSubtext.Parent = IntroBackground

-- Анимация появления
task.spawn(function()
    wait(0.3)
    
    -- Анимация логотипа (эмодзи)
    TweenService:Create(IntroLogo, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 80,
        TextTransparency = 0
    }):Play()
    
    -- Переливающийся цвет логотипа (оптимизированный)
    task.spawn(function()
        for i = 1, 30 do -- Сократил с 60 до 30 кадров
            local hue = (tick() % 3) / 3
            local baseColor = GetThemeColor()
            local r, g, b = baseColor.R, baseColor.G, baseColor.B
            
            local max = math.max(r, g, b)
            local min = math.min(r, g, b)
            local l = (max + min) / 2
            
            if max ~= min then
                local s = l > 0.5 and (max - min) / (2 - max - min) or (max - min) / (max + min)
                local q = l < 0.5 and l * (1 + s) or l + s - l * s
                local p = 2 * l - q
                
                local function hueToRgb(pp, qq, t)
                    if t < 0 then t = t + 1 end
                    if t > 1 then t = t - 1 end
                    if t < 1/6 then return pp + (qq - pp) * 6 * t end
                    if t < 1/2 then return qq end
                    if t < 2/3 then return pp + (qq - pp) * (2/3 - t) * 6 end
                    return pp
                end
                
                IntroLogo.TextColor3 = Color3.new(
                    hueToRgb(p, q, hue + 1/3),
                    hueToRgb(p, q, hue),
                    hueToRgb(p, q, hue - 1/3)
                )
            end
            wait(0.1) -- Увеличил с 0.05 до 0.1
        end
    end)
    
    wait(0.4)
    
    -- Анимация названия
    TweenService:Create(IntroTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextSize = 48,
        TextTransparency = 0
    }):Play()
    
    wait(0.3)
    
    -- Анимация подзаголовка
    TweenService:Create(IntroSubtext, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextSize = 18,
        TextTransparency = 0
    }):Play()
    
    wait(1.5)
    
    -- Смена текста
    IntroSubtext.Text = "Инициализация завершена ✓"
    IntroSubtext.TextColor3 = GetThemeColor()
    
    wait(0.8)
    
    -- Исчезновение
    local fadeOut = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(IntroLogo, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(IntroTitle, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(IntroSubtext, fadeOut, {TextTransparency = 1}):Play()
    TweenService:Create(IntroBackground, fadeOut, {BackgroundTransparency = 1}):Play()
    
    wait(0.7)
    
    IntroGui:Destroy()
end)

print("🌸 DelightHub GUI загружен успешно!")
