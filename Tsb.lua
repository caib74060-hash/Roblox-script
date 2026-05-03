local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size, Frame.Position = UDim2.new(0, 200, 0, 150), UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3, Frame.Active, Frame.Draggable = Color3.fromRGB(30, 30, 30), true, true

local Title = Instance.new("TextLabel", Frame)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 25), "自動原地放招 + 計時"
Title.BackgroundColor3, Title.TextColor3 = Color3.fromRGB(50, 50, 50), Color3.new(1, 1, 1)

-- 計時器顯示面板 (文字已改為白色)
local TimerLabel = Instance.new("TextLabel", Frame)
TimerLabel.Size, TimerLabel.Position = UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 25)
TimerLabel.BackgroundColor3, TimerLabel.TextColor3 = Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)
TimerLabel.Text = "掛機時間: 00:00:00"

local Btn = Instance.new("TextButton", Frame)
Btn.Size, Btn.Position = UDim2.new(0, 180, 0, 80), UDim2.new(0, 10, 0, 60)
Btn.Text, Btn.BackgroundColor3, Btn.TextColor3 = "開始放招：關", Color3.fromRGB(150, 0, 0), Color3.new(1, 1, 1)

local running, fixedPos = false, nil
local totalSeconds = 0
local VIM = game:GetService("VirtualInputManager")

-- 時間格式化函數
local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("掛機時間: %02d:%02d:%02d", h, m, s)
end

Btn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            fixedPos = char.HumanoidRootPart.CFrame
            Btn.Text, Btn.BackgroundColor3 = "放招中 (鎖定位置)\n點擊暫停", Color3.fromRGB(0, 150, 0)
        end
    else
        Btn.Text, Btn.BackgroundColor3 = "已暫停\n點擊繼續", Color3.fromRGB(150, 0, 0)
    end
end)

-- 座標鎖定邏輯
game:GetService("RunService").Heartbeat:Connect(function()
    if running and fixedPos then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.Velocity = Vector3.new(0,0,0)
            root.CFrame = fixedPos
        end
    end
end)

-- 計時器獨立循環
task.spawn(function()
    while true do
        if running then
            totalSeconds = totalSeconds + 1
            TimerLabel.Text = formatTime(totalSeconds)
        end
        task.wait(1)
    end
end)

-- 模擬按鍵函數
local function tapKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, key, false, game)
end

-- 循環邏輯
task.spawn(function()
    while true do
        if running then
            pcall(function()
                -- 極速 M1 普攻
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.02)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                
                -- 依序按 1, 2, 3, Q
                tapKey(Enum.KeyCode.One)
                tapKey(Enum.KeyCode.Two)
                tapKey(Enum.KeyCode.Three)
                tapKey(Enum.KeyCode.Q)
            end)
        end
        task.wait(0.1)
    end
end)
