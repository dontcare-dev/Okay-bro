--[[
    velarium.dev.nyxz
    VERSION: V46 (FINAL PROGRESSION ENGINE)
    CREDITS: NYXZ / VELARIUM
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local player = Players.LocalPlayer

-- [ GLOBAL CONFIG ] --
_G.Farm = false
_G.MobMagnet = false
_G.Speed = false
_G.Jump = false
_G.InfGeppo = false
_G.NoClip = false
_G.PlayerESP = false
_G.MobESP = false
_G.AutoClicker = false
_G.FullBright = false
_G.TweenFarm = true 
_G.AutoQuest = false 
_G.AutoEquip = true
_G.TargetMobName = "" 

local ImageID = "rbxassetid://1000040230"

-- [ UI BUILDER ] --
if player.PlayerGui:FindFirstChild("velarium_dev") then player.PlayerGui.velarium_dev:Destroy() end
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.Name = "velarium_dev"; gui.DisplayOrder = 10

local miniBtn = Instance.new("ImageButton", gui)
miniBtn.Size = UDim2.new(0, 55, 0, 55); miniBtn.Position = UDim2.new(0, 10, 0, 10); miniBtn.Image = ImageID
miniBtn.Visible = false; miniBtn.ZIndex = 100; Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 320); main.Position = UDim2.new(0.5, -225, 0.4, -160)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0; main.ClipsDescendants = true
main.ZIndex = 1; Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", main).Color = Color3.new(1,1,1)

local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0); bg.Image = ImageID; bg.ScaleType = Enum.ScaleType.Crop; bg.ImageColor3 = Color3.fromRGB(80, 80, 80); bg.BackgroundTransparency = 0.5; bg.ZIndex = 0

-- SCRIPT TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 30); title.Position = UDim2.new(0, 10, 0, 5); title.BackgroundTransparency = 1; title.Text = "velarium.dev.nyxz"; title.TextColor3 = Color3.new(1,1,1); title.Font = Enum.Font.Code; title.TextSize = 16; title.TextXAlignment = "Left"; title.ZIndex = 4

local sideBar = Instance.new("Frame", main)
sideBar.Size = UDim2.new(0, 120, 1, -35); sideBar.Position = UDim2.new(0,0,0,35); sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); sideBar.BackgroundTransparency = 0.3; sideBar.ZIndex = 2
Instance.new("UIListLayout", sideBar).Padding = UDim.new(0, 2)

local function makeTabBtn(name)
    local b = Instance.new("TextButton", sideBar)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundTransparency = 1; b.Text = name; b.TextColor3 = Color3.new(0.6, 0.6, 0.6); b.Font = Enum.Font.Code; b.TextSize = 13; b.ZIndex = 3
    return b
end

local bFarm = makeTabBtn("MAIN FARM"); local bCombat = makeTabBtn("COMBAT"); local bMove = makeTabBtn("MOVEMENT"); local bVis = makeTabBtn("VISUALS")
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -130, 1, -45); container.Position = UDim2.new(0, 125, 0, 40); container.BackgroundTransparency = 1; container.ZIndex = 2

local function makePage()
    local p = Instance.new("ScrollingFrame", container)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,1.5,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    return p
end

local pFarm = makePage(); local pCombat = makePage(); local pMove = makePage(); local pVis = makePage()
local function show(page, btn)
    pFarm.Visible = false; pCombat.Visible = false; pMove.Visible = false; pVis.Visible = false
    bFarm.TextColor3 = Color3.new(0.5,0.5,0.5); bCombat.TextColor3 = Color3.new(0.5,0.5,0.5); bMove.TextColor3 = Color3.new(0.5,0.5,0.5); bVis.TextColor3 = Color3.new(0.5,0.5,0.5)
    page.Visible = true; btn.TextColor3 = Color3.new(1,1,1)
end
bFarm.Activated:Connect(function() show(pFarm, bFarm) end); bCombat.Activated:Connect(function() show(pCombat, bCombat) end); bMove.Activated:Connect(function() show(pMove, bMove) end); bVis.Activated:Connect(function() show(pVis, bVis) end)
show(pFarm, bFarm)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -30, 0, 0); close.Text = "—"; close.TextColor3 = Color3.new(1,1,1); close.BackgroundTransparency = 1; close.ZIndex = 5
close.Activated:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.Activated:Connect(function() main.Visible = true; miniBtn.Visible = false end)

local function addToggle(p, name, var)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, -10, 0, 32); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.BackgroundTransparency = 0.4
    b.Text = "  " .. name; b.TextColor3 = Color3.new(0.7,0.7,0.7); b.Font = Enum.Font.Code; b.TextXAlignment = "Left"; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.Activated:Connect(function()
        _G[var] = not _G[var]
        b.TextColor3 = _G[var] and Color3.new(1,1,1) or Color3.new(0.7,0.7,0.7)
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(100, 0, 0) or Color3.fromRGB(20, 20, 20)
    end)
end

local tBox = Instance.new("TextBox", pFarm)
tBox.Size = UDim2.new(1, -10, 0, 32); tBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30); tBox.TextColor3 = Color3.new(1,1,1)
tBox.PlaceholderText = "Mob Name..."; tBox.Font = Enum.Font.Code; tBox.ZIndex = 3; Instance.new("UICorner", tBox).CornerRadius = UDim.new(0, 4)
tBox.FocusLost:Connect(function() _G.TargetMobName = tBox.Text end)

addToggle(pFarm, "AUTO FARM", "Farm")
addToggle(pFarm, "AUTO QUEST CYCLE", "AutoQuest")
addToggle(pFarm, "MOB MAGNET", "MobMagnet")
addToggle(pFarm, "TWEEN FARM", "TweenFarm")
addToggle(pCombat, "AUTO CLICKER", "AutoClicker")
addToggle(pCombat, "AUTO EQUIP", "AutoEquip")
addToggle(pMove, "SPEED HACK", "Speed")
addToggle(pMove, "INF GEPPO", "InfGeppo")
addToggle(pMove, "NO CLIP", "NoClip")
addToggle(pVis, "MOB ESP", "MobESP")

-- [ CORE LOGIC ] --
local function click()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.01)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function hasQuest()
    for _, g in pairs(player.PlayerGui:GetDescendants()) do
        if g:IsA("TextLabel") and g.Visible then
            local t = g.Text:lower()
            if t:find("quest") or t:find("target") or t:find("goal") then return true end
        end
    end
    return false
end

local function getQuestNPC()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            local n = v.Parent.Name:lower()
            if n:find("quest") or v.ActionText:lower():find("quest") then return v end
        end
    end
    return nil
end

local function getTarget()
    local dist, target = 1000, nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent ~= player.Character and v.Health > 0 then
            local hrp = v.Parent:FindFirstChild("HumanoidRootPart")
            if hrp then
                local n = v.Parent.Name:lower()
                if _G.TargetMobName == "" or n:find(_G.TargetMobName:lower()) then
                    local mag = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if mag < dist then dist = mag; target = v.Parent end
                end
            end
        end
    end
    return target
end

-- [ MASTER LOOP ] --
task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.Farm then
                -- Quest Check
                if _G.AutoQuest and not hasQuest() then
                    local prompt = getQuestNPC()
                    if prompt then
                        player.Character:PivotTo(prompt.Parent:GetPivot() * CFrame.new(0,0,3))
                        prompt.HoldDuration = 0
                        fireproximityprompt(prompt)
                        task.wait(0.5)
                    end
                end

                -- Kill Loop
                local mob = getTarget()
                if mob then
                    if _G.AutoEquip then 
                        local t = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
                        if t then player.Character.Humanoid:EquipTool(t) end
                    end

                    local targetCF = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.8) -- TIGHT HITBOX
                    if _G.TweenFarm then
                        TS:Create(player.Character.HumanoidRootPart, TweenInfo.new(0.2), {CFrame = targetCF}):Play()
                    else
                        player.Character:PivotTo(targetCF)
                    end
                    player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    click()
                end
            end

            if _G.MobMagnet and not _G.Farm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= player.Character and v.Health > 0 then
                        local hrp = v.Parent:FindFirstChild("HumanoidRootPart")
                        if hrp and (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 400 then
                            hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                            hrp.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end
                click()
            end
        end)
    end
end)

-- Secondary Hacks
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoClicker and not _G.Farm then click() end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = _G.Speed and 100 or 16
        end
        if _G.NoClip then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

player.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new(0,0)) end)
UIS.JumpRequest:Connect(function() if _G.InfGeppo and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)
