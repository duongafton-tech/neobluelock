-- Blue Lock Rival - Auto Farm Neo Ego 2.0
-- Palofsc | No Key | Toggle F9

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local CONFIG = {
    Speed = 60,
    JumpPower = 150,
    TeleportDistance = 30,
    AutoClaimReward = true,
    AutoCollectXP = true,
    TaskInterval = 1.0,
    AutoResetTasks = true,
    ToggleKey = Enum.KeyCode.F9
}

local TASKS = {"Score", "Assist", "Tackle", "Pass", "Distance"}
local taskStatus = {}
for _, name in ipairs(TASKS) do taskStatus[name] = false end
local currentTask, isRunning = nil, true

local function getBall() return workspace:FindFirstChild("Ball") end
local function getGoals()
    local goals = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Goal" and obj:IsA("BasePart") then
            table.insert(goals, obj)
        end
    end
    return goals
end
local function getNearestGoal(pos)
    local goals = getGoals()
    local nearest, minDist = nil, math.huge
    for _, goal in ipairs(goals) do
        local d = (pos - goal.Position).Magnitude
        if d < minDist then minDist = d; nearest = goal end
    end
    return nearest
end
local function getTeammates()
    local list = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Team == player.Team and p.Character then
            table.insert(list, p)
        end
    end
    return list
end
local function getEnemies()
    local list = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character then
            table.insert(list, p)
        end
    end
    return list
end
local function teleportTo(pos) root.CFrame = CFrame.new(pos, root.Position) end

local function selectTask()
    for _, name in ipairs(TASKS) do
        if not taskStatus[name] then
            currentTask = name
            taskStatus[name] = true
            print("[KANZ] Task: " .. name)
            return
        end
    end
    currentTask = nil
    if CONFIG.AutoResetTasks then
        for _, name in ipairs(TASKS) do taskStatus[name] = false end
        print("[KANZ] Reset tasks")
    end
end

local function executeTask(task)
    local ball = getBall()
    local goal = getNearestGoal(root.Position)
    if task == "Score" and ball and goal then
        local target = ball.Position + Vector3.new(0,1,4)
        if (root.Position - target).Magnitude > CONFIG.TeleportDistance then teleportTo(target) end
        wait(0.1)
        ball.Velocity = (goal.Position - ball.Position).Unit * 420 + Vector3.new(0,35,0)
        wait(0.2)
        if ball and goal then ball.Velocity = (goal.Position - ball.Position).Unit * 380 + Vector3.new(0,25,0) end
    elseif task == "Assist" then
        local tm = getTeammates()
        if #tm > 0 and ball then
            local t = tm[math.random(#tm)]
            local tr = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if tr then ball.Position = tr.Position + Vector3.new(0,2.5,0); ball.Velocity = Vector3.new(0,0,0) end
        end
    elseif task == "Tackle" then
        for _, e in ipairs(getEnemies()) do
            local er = e.Character and e.Character:FindFirstChild("HumanoidRootPart")
            if er and (root.Position - er.Position).Magnitude < 25 then
                teleportTo(er.Position + Vector3.new(0,0,2))
                wait(0.1)
                er.Velocity = Vector3.new(0,20,-55)
                break
            end
        end
    elseif task == "Pass" then
        local tm = getTeammates()
        if #tm > 0 and ball then
            local t = tm[math.random(#tm)]
            local tr = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if tr then ball.Velocity = (tr.Position - ball.Position).Unit * 160 end
        end
    elseif task == "Distance" then
        local pts = {Vector3.new(-50,2,-50), Vector3.new(50,2,-50), Vector3.new(50,2,50), Vector3.new(-50,2,50)}
        for _, pt in ipairs(pts) do teleportTo(pt); wait(0.2) end
    end
    print("[KANZ] ✅ " .. task)
end

local function collectXP()
    if not CONFIG.AutoCollectXP then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "XP" and obj:IsA("BasePart") then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < 30 then
                obj.Position = root.Position + Vector3.new(0,1,0)
                firetouchinterest(root, obj, 0)
                firetouchinterest(root, obj, 1)
            end
        end
    end
end

local function claimReward()
    local gui = player.PlayerGui
    local btn = gui:FindFirstChild("RewardButton") or gui:FindFirstChild("Claim")
    if btn and btn:IsA("TextButton") then btn:Click(); return end
    for _, b in ipairs(gui:GetDescendants()) do
        if b:IsA("TextButton") and (b.Name:lower():find("claim") or b.Name:lower():find("reward")) then
            pcall(b.Click, b)
        end
    end
end

local function farmLoop()
    while isRunning do
        selectTask()
        if currentTask then executeTask(currentTask) end
        collectXP()
        if CONFIG.AutoClaimReward then pcall(claimReward) end
        wait(CONFIG.TaskInterval)
    end
end

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Health = humanoid.MaxHealth
    humanoid.WalkSpeed = CONFIG.Speed
    humanoid.JumpPower = CONFIG.JumpPower
    wait(0.5)
    if isRunning then spawn(farmLoop) end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == CONFIG.ToggleKey then
        isRunning = not isRunning
        print("[KANZ] " .. (isRunning and "ON" or "OFF"))
        if isRunning then spawn(farmLoop) end
    end
end)

local function bypass()
    local ac = game:FindFirstChild("AntiCheat") or game:FindFirstChild("DeltaGuard") or game:FindFirstChild("ExploitGuard")
    if ac then ac:Destroy() end
    game.Players.LocalPlayer.Kick = function() end
    game:GetService("TeleportService").Teleport = function() end
    for _, rem in ipairs(game:GetDescendants()) do
        if rem:IsA("RemoteEvent") and rem.Name:lower():find("log") then
            rem.OnServerEvent:Connect(function() end)
        end
    end
end
bypass()

humanoid.WalkSpeed = CONFIG.Speed
humanoid.JumpPower = CONFIG.JumpPower
print("[KANZ] Ready - Press F9 to toggle")
wait(0.5)
spawn(farmLoop)