-- [[ 背景專用防掉線 (Anti-AFK Background) ]]
local sg = Instance.new("ScreenGui", game.CoreGui)
local notify = Instance.new("TextLabel", sg)
notify.Size, notify.Position = UDim2.new(0, 250, 0, 50), UDim2.new(1, -260, 1, -60)
notify.BackgroundColor3, notify.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1, 1, 1)
notify.Text = "🛡️ Anti-AFK Background: Activated"
task.delay(3, function() sg:Destroy() end)

-- 核心邏輯：直接繞過按鍵模擬，改用虛擬用戶行為
task.spawn(function()
    while task.wait(300) do
        pcall(function()
            -- 直接告訴遊戲引擎有用戶操作，這在視窗失去焦點時依然有效
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
            -- 讓角色跳一下（背景執行時可能看不到，但伺服器會收到狀態改變）
            game.Players.LocalPlayer.Character.Humanoid.Jump = true
        end)
    end
end)
