local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

_G.NYXZ = {
    AutoFarm = false,
    AutoClick = false,
    NoClip = true,
    Speed = false,
    InfGeppo = false,
    SelectedMob = "Thief", 
    FarmDistance = 3, -- 3 studs behind
    FarmHeight = 2.5
}

-- [ UI BUILDER ] --
if player.PlayerGui:FindFirstChild("Midnight_V15") then player.PlayerGui.Midnight_V15:Destroy() end
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.Name = "Midnight_V15"; gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 320); main.Position = UDim2.new(0.5, -250, 0.4, -160)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.BorderSizePixel = 0; main.ZIndex = 2
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local glow = Instance.new("UIStroke", main); glow.Color = Color3.fromRGB(0, 255, 150); glow.Thickness = 1.5

-- Snowy Background Image
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0); bg.Image = "rbxassetid://16127116933"
bg.ScaleType = Enum.ScaleType.Crop; bg.ImageTransparency = 0.75; bg.BackgroundTransparency = 1; bg.ZIndex = 1

-- Top Nav Bar 
local nav = Instance.new("Frame", main); nav.Size = UDim2.new(1, 0, 0, 40); nav.BackgroundColor3 = Color3.fromRGB(15, 15, 20); nav.BorderSizePixel = 0; nav.ZIndex = 3
Instance.new("UICorner", nav)

-- Isolated container for tabs 
local tabHolder = Instance.new("Frame", nav); tabHolder.Size = UDim2.new(1, -80, 1, 0); tabHolder.Position = UDim2.new(0, 10, 0, 0); tabHolder.BackgroundTransparency = 1; tabHolder.ZIndex = 4
local nLayout = Instance.new("UIListLayout", tabHolder); nLayout.FillDirection = "Horizontal"; nLayout.HorizontalAlignment = "Center"; nLayout.VerticalAlignment = "Center"; nLayout.Padding = UDim.new(0, 15)

-- MINIMIZE BUTTON (Anchored top right)
local closeBtn = Instance.new("TextButton", nav)
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 5); closeBtn.BackgroundTransparency = 1
closeBtn.Text = "—"; closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.Code; closeBtn.TextSize = 20; closeBtn.ZIndex = 5

local container = Instance.new("Frame", main); container.Size = UDim2.new(1, -20, 1, -55); container.Position = UDim2.new(0, 10, 0, 50); container.BackgroundTransparency = 1; container.ZIndex = 3

-- [ STATUS-ONLY MINIMIZED WINDOW ] --
local restore = Instance.new("Frame", gui)
restore.Size = UDim2.new(0, 180, 0, 35); restore.Position = UDim2.new(0, 20, 0, 20)
restore.BackgroundColor3 = Color3.fromRGB(10, 10, 10); restore.Visible = false
Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", restore).Color = Color3.fromRGB(0, 255, 150)

local vStats = Instance.new("TextButton", restore)
vStats.Size = UDim2.new(1, -10, 1, 0); vStats.Position = UDim2.new(0, 5, 0, 0); vStats.BackgroundTransparency = 1
vStats.Text = "Status: Idle"; vStats.TextColor3 = Color3.new(1, 1, 1); vStats.Font = Enum.Font.Code; vStats.TextSize = 12; vStats.TextXAlignment = 0

local function createTab(name, active)
    local p = Instance.new("ScrollingFrame", container); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = active; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = "Y"; p.ZIndex = 4
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    
    local b = Instance.new("TextButton", tabHolder); b.Size = UDim2.new(0, 80, 0, 30); b.BackgroundTransparency = 1; b.Text = name; b.TextColor3 = active and Color3.fromRGB(0, 255, 150) or Color3.new(0.6, 0.6, 0.6); b.Font = Enum.Font.Code; b.TextSize = 14; b.ZIndex = 5
    b.Activated:Connect(function()
        for _, t in pairs(container:GetChildren()) do if t:IsA("ScrollingFrame") then t.Visible = false end end
        for _, btn in pairs(tabHolder:GetChildren()) do if btn:IsA("TextButton") then btn.TextColor3 = Color3.new(0.6, 0.6, 0.6) end end
        p.Visible = true; b.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    return p
end

local function addToggle(p, name, var)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = "  " .. name; b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = Enum.Font.Code; b.TextXAlignment = 0; Instance.new("UICorner", b); b.ZIndex = 5
    local ind = Instance.new("Frame", b); ind.Size = UDim2.new(0, 10, 0, 10); ind.Position = UDim2.new(1, -25, 0.5, -5); ind.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Instance.new("UICorner", ind); ind.ZIndex = 6
    b.Activated:Connect(function()
        _G.NYXZ[var] = not _G.NYXZ[var]
        ind.BackgroundColor3 = _G.NYXZ[var] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)
        b.TextColor3 = _G.NYXZ[var] and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
    end)
end

local mainT = createTab("Main", true); local playerT = createTab("Player", false); local socialT = createTab("Socials", false)

local mobInput = Instance.new("TextBox", mainT)
mobInput.Size = UDim2.new(1, 0, 0, 40); mobInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20); mobInput.Text = "Thief"; mobInput.PlaceholderText = "Type Mob Name Here..."; mobInput.TextColor3 = Color3.new(1,1,1); mobInput.Font = Enum.Font.Code; Instance.new("UICorner", mobInput); mobInput.ZIndex = 5
mobInput.FocusLost:Connect(function() _G.NYXZ.SelectedMob = mobInput.Text end)

addToggle(mainT, "Auto Farm", "AutoFarm"); addToggle(mainT, "Auto Click", "AutoClick")
addToggle(playerT, "Speed Hack", "Speed"); addToggle(playerT, "NoClip", "NoClip"); addToggle(playerT, "Infinite Geppo", "InfGeppo")

-- Socials
local function addSocial(name, link)
    local b = Instance.new("TextButton", socialT); b.Size = UDim2.new(1,0,0,40); b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Code; Instance.new("UICorner", b); b.ZIndex = 5
    b.Activated:Connect(function() setclipboard(link) end)
end
addSocial("Discord: discord.gg/velarium", "https://discord.gg/velarium")
addSocial("YouTube: @nyxz_dev", "https://youtube.com/@nyxz_dev")

closeBtn.Activated:Connect(function() main.Visible = false; restore.Visible = true end)
vStats.Activated:Connect(function() main.Visible = true; restore.Visible = false end)

-- [ LOGIC - 3 STUDS BEHIND TARGET ] --
local function getTarget()
    local target, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(v) then
                local name = v.Name:lower()
                if not (name:find("dummy") or name:find("seller") or name:find("shop") or v:FindFirstChildWhichIsA("ProximityPrompt", true)) then
                    local isTarget = name:find(_G.NYXZ.SelectedMob:lower())
                    local d = (player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if (isTarget or d < 50) and d < dist then target = v; dist = d end
                end
            end
        end
    end
    return target
end

RS.Stepped:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if _G.NYXZ.NoClip or _G.NYXZ.AutoFarm then
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if _G.NYXZ.AutoFarm then
        local target = getTarget()
        if target then
            vStats.Text = "Farming: " .. target.Name
            player.Character.HumanoidRootPart.Velocity = Vector3.zero
            
            local goal = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.NYXZ.FarmHeight, _G.NYXZ.FarmDistance)
            player.Character.HumanoidRootPart.CFrame = CFrame.lookAt(goal.Position, target.HumanoidRootPart.Position)
        else
            vStats.Text = "Status: IDLE"
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.NYXZ.AutoFarm or _G.NYXZ.AutoClick then
            local tool = player.Character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                if tool.Parent ~= player.Character then player.Character.Humanoid:EquipTool(tool) end
                tool:Activate()
                VIM:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, true, game, 1)
            end
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = _G.NYXZ.Speed and 100 or 16
        end
    end
end)
