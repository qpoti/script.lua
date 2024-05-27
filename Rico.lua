local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local dragging, dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        local newPos = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos})
        tween:Play()
    end
end)

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local isEnabled = false

toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleButton.Text = "ON"
        toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        -- شغّل السكربت هنا
    else
        toggleButton.Text = "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        -- أوقف السكربت هنا
    end
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, -10, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- سكربت تغيير حجم ومظهر HumanoidRootPart للاعبين الآخرين
_G.HeadSize = 20
_G.Disabled = true

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then
        for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
            if player.Name ~= game.Players.LocalPlayer.Name then
                pcall(function()
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Bright yellow") -- اللون الأصفر
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end
end)
