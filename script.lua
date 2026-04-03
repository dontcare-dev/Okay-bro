local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

_G.NYXZ = {
    AutoFarm = false, AutoClick = false, AutoSkills = false, BringMobs = false,
    HitboxExpander = false, SelectedMob = "Thief", FarmDistance = 3.5,
    Speed = false, NoClip = true, InfGeppo = false, WalkOnWater = false,
    PlayerESP = false, MobESP = false, Fullbright = false, AutoLoot = false, AntiAFK = true
}

-- [ ANTI-AFK HOOK ] --
player.Idled:Connect(function()
    if _G.NYXZ.AntiAFK then
        VU:Button2Down(Vector2.new(0,0), cam.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0), cam.CFrame)
    end
end)

-- [ UI BUILDER ] --
if player.PlayerGui:FindFirstChild("Zenith_V23") then player.PlayerGui.Zenith_V23:Destroy() end
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.Name = "Zenith_V23"; gui.ResetOnSpawn = false

-- Main Window
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 330); main.Position = UDim2.new(0.5, -260, 0.5, -165)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 255, 120); Instance.new("UIStroke", main).Thickness = 1.5

-- Minimize Button (Top Right)
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30); minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.BackgroundTransparency = 1; minBtn.Text = "—"; minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.Code; minBtn.TextSize = 20; minBtn.ZIndex = 10

-- Sidebar
local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 130, 1, 0); side.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", side)
local sLayout = Instance.new("UIListLayout", side); sLayout.Padding = UDim.new(0, 5); sLayout.HorizontalAlignment = "Center"; sLayout.VerticalAlignment = "Center"

local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -140, 1, -20); container.Position = UDim2.new(0, 135, 0, 10); container.BackgroundTransparency = 1

-- STATUS BAR (Minimized State)
local restore = Instance.new("Frame", gui)
restore.Size = UDim2.new(0, 220, 0, 35); restore.Position = UDim2.new(0.5, -110, 0, 15)
restore.BackgroundColor3 = Color3.fromRGB(15, 15, 15); restore.Visible = false
Instance.new("UICorner", restore); Instance.new("UIStroke", restore).Color = Color3.fromRGB(0, 255, 120)
local vStats = Instance.new("TextButton", restore)
vStats.Size = UDim2.new(1, 0, 1, 0); vStats.BackgroundTransparency = 1; vStats.Font = Enum.Font.Code
vStats.Text = "STATUS: IDLE"; vStats.TextColor3 = Color3.new(1,1,1); vStats.TextSize = 13

-- Toggle Logic
minBtn.Activated:Connect(function() main.Visible = false; restore.Visible = true end)
vStats.Activated:Connect(function() main.Visible = true; restore.Visible = false end)

local function createTab(name, active)
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = active; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = "Y"
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    local b = Instance.new("TextButton", side); b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = active and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(18, 18, 18); b.Text = name; b.TextColor3 = active and Color3.fromRGB(0, 255, 120) or Color3.new(0.6, 0.6, 0.6); b.Font = Enum.Font.Code; b.TextSize = 13; Instance.new("UICorner", b)
    b.Activated:Connect(function()
        for _, t in pairs(container:GetChildren()) do if t:IsA("ScrollingFrame") then t.Visible = false end end
        for _, btn in pairs(side:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.6,0.6,0.6); btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18) end end
        p.Visible = true; b.TextColor3 = Color3.fromRGB(0, 255, 120); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    return p
end

local function addToggle(p, name, var)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.Text = "  " .. name; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.Code; b.TextXAlignment = 0; Instance.new("UICorner", b)
    local box = Instance.new("Frame", b); box.Size = UDim2.new(0, 12, 0, 12); box.Position = UDim2.new(1, -25, 0.5, -6); box.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", box)
    b.Activated:Connect(function()
        _G.NYXZ[var] = not _G.NYXZ[var]
        box.BackgroundColor3 = _G.NYXZ[var] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(40,40,40)
    end)
end

-- TABS
local mainT = createTab("COMBAT", true)
local playerT = createTab("PLAYER", false)
local visT = createTab("VISUALS", false)
local miscT = createTab("MISC", false)

local mobInput = Instance.new("TextBox", mainT); mobInput.Size = UDim2.new(1, -10, 0, 38); mobInput.BackgroundColor3 = Color3.fromRGB(15,15,15); mobInput.Text = "Thief"; mobInput.TextColor3 = Color3.new(1,1,1); mobInput.Font = Enum.Font.Code; Instance.new("UICorner", mobInput)
mobInput.FocusLost:Connect(function() _G.NYXZ.SelectedMob = mobInput.Text end)

-- Feature Toggles
addToggle(mainT, "Auto Farm", "AutoFarm")
addToggle(mainT, "Auto Click", "AutoClick")
addToggle(mainT, "Auto Skills (Z,X,C,V)", "AutoSkills")
addToggle(mainT, "Hitbox Expander (100s)", "HitboxExpander")

addToggle(playerT, "Speed Hack", "Speed")
addToggle(playerT, "NoClip", "NoClip")
addToggle(playerT, "Walk on Water", "WalkOnWater")
addToggle(playerT, "Inf Geppo", "InfGeppo")

addToggle(visT, "Player ESP", "PlayerESP")
addToggle(visT, "Mob ESP", "MobESP")
addToggle(visT, "Fullbright", "Fullbright")

addToggle(miscT, "Auto Loot", "AutoLoot")
addToggle(miscT, "Anti-AFK", "AntiAFK")

-- [ LOGIC ENGINE ] --
local waterPart = Instance.new("Part", workspace); waterPart.Size = Vector3.new(20, 1, 20); waterPart.Anchored = true; waterPart.Transparency = 1; waterPart.CanCollide = false

local function applyESP(v, color)
    if not v:FindFirstChild("N_ESP") then
        local hl = Instance.new("Highlight", v); hl.Name = "N_ESP"; hl.FillColor = color; hl.FillTransparency = 0.5; hl.OutlineColor = Color3.new(1,1,1)
    end
end
local function clearESP(v) if v:FindFirstChild("N_ESP") then v.N_ESP:Destroy() end end

local function getTarget()
    local target, dist = nil, math.huge
    local source = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(source:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(v) and v.Name:lower():find(_G.NYXZ.SelectedMob:lower()) then
                local d = (player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if d < dist then target = v; dist = d end
            end
        end
    end
    return target
end

-- Physics Loop
RS.Stepped:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- NoClip
    if _G.NYXZ.NoClip or _G.NYXZ.AutoFarm then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    
    -- Walk on Water
    if _G.NYXZ.WalkOnWater then
        waterPart.CanCollide = true
        waterPart.Position = char.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0)
    else
        waterPart.CanCollide = false
        waterPart.Position = Vector3.new(0, 99999, 0)
    end
    
    -- Auto Farm CFrame
    if _G.NYXZ.AutoFarm then
        local target = getTarget()
        if target then
            vStats.Text = "FARMING: " .. string.upper(target.Name)
            char.HumanoidRootPart.Velocity = Vector3.zero
            char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.NYXZ.FarmDistance)
        else
            vStats.Text = "STATUS: SEARCHING..."
        end
    else
        if restore.Visible then vStats.Text = "STATUS: IDLE" end
    end
end)

-- Jump Hook
UIS.JumpRequest:Connect(function()
    if _G.NYXZ.InfGeppo and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Background Task Loop
task.spawn(function()
    while task.wait(0.1) do
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        
        -- Auto Clicker
        if _G.NYXZ.AutoFarm or _G.NYXZ.AutoClick then
            local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                tool:Activate()
            end
        end
        
        -- Auto Skills
        if _G.NYXZ.AutoSkills and _G.NYXZ.AutoFarm then
            for _, key in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                VIM:SendKeyEvent(true, key, false, game)
                VIM:SendKeyEvent(false, key, false, game)
            end
        end
        
        -- Speed & Lighting
        char.Humanoid.WalkSpeed = _G.NYXZ.Speed and 100 or 16
        if _G.NYXZ.Fullbright then Lighting.Brightness = 2; Lighting.GlobalShadows = false else Lighting.GlobalShadows = true end
        
        -- ESP & Hitbox Logic
        local source = workspace:FindFirstChild("NPCs") or workspace:FindFirstChild("Enemies") or workspace
        for _, v in pairs(source:GetDescendants()) do
            -- Hitbox & Mob ESP
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                if _G.NYXZ.MobESP then applyESP(v, Color3.new(1,0,0)) else clearESP(v) end
                
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if _G.NYXZ.HitboxExpander and dist <= 100 then
                        hrp.Size = Vector3.new(15, 15, 15); hrp.Transparency = 0.6; hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1
                    end
                end
            end
            
            -- Auto Loot
            if _G.NYXZ.AutoLoot and v:IsA("Tool") and v.Parent == workspace then
                if v:FindFirstChild("Handle") then v.Handle.CFrame = char.HumanoidRootPart.CFrame end
            end
        end
        
        -- Player ESP
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if _G.NYXZ.PlayerESP then applyESP(p.Character, Color3.new(0,1,0)) else clearESP(p.Character) end
            end
        end
    end
end)
