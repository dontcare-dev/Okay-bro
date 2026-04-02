--[[
    AROSE GNG - BEHIND TARGET REWRITE
    FIX: POSITION BEHIND MOB / NO SHAKE / ALL ISLANDS
    UI: BLACK STATUS BAR + MINIMIZE
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- [ CONFIG ] --
_G.Farm = false
_G.Click = false
_G.Equip = false
_G.Speed = false
_G.StaffCheck = true

local Blacklist = {"quest", "shop", "citizen", "doctor", "spawn", "blacksmith", "trainer", "dummy", "set home", "travel", "boat"}

-- [ UI - STATUS BAR ] --
if player.PlayerGui:FindFirstChild("AroseGng") then player.PlayerGui.AroseGng:Destroy() end
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.Name = "AroseGng"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300); main.Position = UDim2.new(0.5, -180, 0.4, -150)
main.BackgroundColor3 = Color3.new(0,0,0); main.BorderSizePixel = 1; main.BorderColor3 = Color3.new(1,1,1)

local infoBar = Instance.new("Frame", main)
infoBar.Size = UDim2.new(1, -10, 0, 45); infoBar.Position = UDim2.new(0, 5, 0, 5)
infoBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); infoBar.BorderSizePixel = 0

local statusText = Instance.new("TextLabel", infoBar)
statusText.Size = UDim2.new(1, -40, 1, 0); statusText.Position = UDim2.new(0, 8, 0, 0)
statusText.BackgroundTransparency = 1; statusText.TextColor3 = Color3.new(1,1,1)
statusText.Font = Enum.Font.Code; statusText.TextSize = 10; statusText.TextXAlignment = "Left"; statusText.TextWrapped = true
statusText.Text = "SYSTEM: READY"

-- [ STAT UPDATER ] --
task.spawn(function()
    while task.wait(1) do
        local lv = "0"
        for _, folder in pairs(player:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Configuration") then
                local lObj = folder:FindFirstChild("Level") or folder:FindFirstChild("Lv") or folder:FindFirstChild("LevelValue")
                if lObj then lv = tostring(lObj.Value) end
            end
        end
        local hp = (player.Character and player.Character:FindFirstChild("Humanoid")) and math.floor(player.Character.Humanoid.Health) or 0
        statusText.Text = string.format("USER: %s\nLV: %s | HP: %d | POS: BEHIND", player.Name:upper(), lv, hp)
    end
end)

local minBtn = Instance.new("TextButton", infoBar)
minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -35, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); minBtn.Text = "-"; minBtn.TextColor3 = Color3.new(1,1,1); minBtn.BorderSizePixel = 0

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -65); scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,0,400); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

minBtn.Activated:Connect(function()
    scroll.Visible = not scroll.Visible
    main:TweenSize(scroll.Visible and UDim2.new(0, 360, 0, 300) or UDim2.new(0, 360, 0, 50), "Out", "Quad", 0.1, true)
    minBtn.Text = scroll.Visible and "-" or "+"
end)

local function addToggle(name, var)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 42); btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "  " .. name .. ": OFF"; btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    btn.Font = Enum.Font.Code; btn.TextSize = 11; btn.TextXAlignment = "Left"; btn.BorderSizePixel = 0
    btn.Activated:Connect(function()
        _G[var] = not _G[var]
        btn.Text = "  " .. name .. ": " .. (_G[var] and "ON" or "OFF")
        btn.TextColor3 = _G[var] and Color3.new(1,1,1) or Color3.new(0.7, 0.7, 0.7)
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(20, 20, 20)
    end)
end

addToggle("AUTO FARM (BEHIND)", "Farm")
addToggle("AUTO CLICK", "Click")
addToggle("AUTO EQUIP", "Equip")
addToggle("SPEED HACK", "Speed")
addToggle("STAFF PROTECTION", "StaffCheck")

-- [ GLOBAL NEAREST SEARCH ] --
local function getTarget()
    local target, dist = nil, 5000 
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent:IsA("Model") and v.Parent ~= player.Character then
            if v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                local name = v.Parent.Name:lower()
                local isF = false
                for _, word in pairs(Blacklist) do if name:find(word) then isF = true break end end
                
                if not isF and (name:find("thief") or name:find("lv") or name:find("%[") or name:find("pirate") or name:find("marine") or name:find("boss")) then
                    local d = (v.Parent.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then target = v.Parent; dist = d end
                end
            end
        end
    end
    return target
end

-- [ V17 STABLE ENGINE - BEHIND TARGET ] --
RS.Stepped:Connect(function()
    if _G.Farm and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local mob = getTarget()
        if mob then
            -- POSITION: 3 studs behind them (-Z), 1 stud up (Y)
            -- This makes you hit their back where hitboxes are usually largest
            local targetPos = mob.HumanoidRootPart.CFrame * CFrame.new(0, 1, 3) 
            player.Character:PivotTo(CFrame.lookAt(targetPos.p, mob.HumanoidRootPart.Position))
            
            -- RESET VELOCITY TO PREVENT KICKS
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            player.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
            
            -- NOCLIP
            for _, p in pairs(player.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- [ UTILITY LOOPS ] --
task.spawn(function()
    while task.wait(0.1) do
        if _G.Speed and player.Character:FindFirstChild("Humanoid") then 
            player.Character.Humanoid.WalkSpeed = 100 
        elseif player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        if _G.Click then VIM:SendMouseButtonEvent(0,0,0,true,game,1); VIM:SendMouseButtonEvent(0,0,0,false,game,1) end
        if _G.Equip and not player.Character:FindFirstChildOfClass("Tool") then
            local t = player.Backpack:FindFirstChildOfClass("Tool"); if t then t.Parent = player.Character end
        end
    end
end)

Players.PlayerAdded:Connect(function(p) if _G.StaffCheck and p:GetRankInGroup(0) >= 200 then player:Kick("Staff Joined") end end)
