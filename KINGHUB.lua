
-- KING HUB - AUTO FARM DEMO
-- Dùng trong Roblox Studio với NPC thử nghiệm.
-- Đặt LocalScript trong StarterPlayerScripts.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local running = false
local attackDistance = 7
local teleportDistance = 12

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KING_HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 160)
frame.Position = UDim2.new(0.5, -120, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "KING HUB - AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 60)
title.BackgroundTransparency = 1
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.fromOffset(10, 50)
button.Text = "START AUTO FARM"
button.BackgroundColor3 = Color3.fromRGB(30, 150, 75)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 45)
status.Position = UDim2.fromOffset(10, 100)
status.Text = "Status: OFF"
status.TextColor3 = Color3.new(1, 1, 1)
status.BackgroundTransparency = 1
status.Parent = frame

-- Tìm NPC trong Workspace.NPCs
local function getNearestNPC()
    local folder = workspace:FindFirstChild("NPCs")
    if not folder then return nil end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local nearest = nil
    local shortest = math.huge

    for _, npc in ipairs(folder:GetChildren()) do
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        local npcRoot = npc:FindFirstChild("HumanoidRootPart")

        if humanoid and npcRoot and humanoid.Health > 0 then
            local distance = (root.Position - npcRoot.Position).Magnitude

            if distance < shortest then
                shortest = distance
                nearest = npc
            end
        end
    end

    return nearest
end

-- Vòng lặp demo
local function farmLoop()
    while running do
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local npc = getNearestNPC()

        if root and npc then
            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
            local humanoid = npc:FindFirstChildOfClass("Humanoid")

            if npcRoot and humanoid and humanoid.Health > 0 then
                status.Text = "Target: " .. npc.Name

                -- Di chuyển demo đến gần NPC
                if (root.Position - npcRoot.Position).Magnitude > teleportDistance then
                    root.CFrame = npcRoot.CFrame * CFrame.new(0, 0, 5)
                end

                -- Chờ NPC bị hạ bởi cơ chế chiến đấu của game demo
                status.Text = "Target: " .. npc.Name .. " | Waiting"
                repeat
                    task.wait(0.3)
                until not running or humanoid.Health <= 0
            end
        else
            status.Text = "Waiting for NPC..."
            task.wait(1)
        end

        task.wait(0.5)
    end

    status.Text = "Status: OFF"
end

button.MouseButton1Click:Connect(function()
    running = not running

    if running then
        button.Text = "STOP AUTO FARM"
        button.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
        task.spawn(farmLoop)
    else
        button.Text = "START AUTO FARM"
        button.BackgroundColor3 = Color3.fromRGB(30, 150, 75)
        status.Text = "Status: OFF"
    end
end)
