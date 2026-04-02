--[[ 
    =========================================================
    velarium.dev.scr // THE COMPLETE PROTOCOL (FIXED)
    =========================================================
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [ 1. CONFIGURATION ] --
local DiscordLink = "https://discord.gg/velarium"
local CorrectKey = "VELARIUM_ON_TOP" 
local ScriptURL = "https://raw.githubusercontent.com/dontcare-dev/Okay-bro/main/script.lua"

-- [ 2. KEY SYSTEM GATE ] --
if CoreGui:FindFirstChild("VelariumGate") then CoreGui.VelariumGate:Destroy() end

local GateGui = Instance.new("ScreenGui", CoreGui)
GateGui.Name = "VelariumGate"

local Main = Instance.new("Frame", GateGui)
Main.Size = UDim2.new(0, 420, 0, 260)
Main.Position = UDim2.new(0.5, -210, 0.5, -130)
Main.BackgroundColor3 = Color3.new(0, 0, 0)
Main.BorderSizePixel = 0
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.Text = "velarium.dev.scr // ACCESS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20

local Msg = Instance.new("TextLabel", Main)
Msg.Size = UDim2.new(1, -40, 0, 40)
Msg.Position = UDim2.new(0, 20, 0, 60)
Msg.BackgroundTransparency = 1
Msg.Font = Enum.Font.Code
Msg.Text = "Access Locked: Copy Discord link to unlock verification."
Msg.TextColor3 = Color3.fromRGB(160, 160, 160)
Msg.TextSize = 13
Msg.TextWrapped = true

local KeyInput = Instance.new("TextBox", Main)
KeyInput.Size = UDim2.new(1, -60, 0, 45)
KeyInput.Position = UDim2.new(0, 30, 0, 110)
KeyInput.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KeyInput.BorderSizePixel = 0
KeyInput.Font = Enum.Font.Code
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.TextSize = 14
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 175, 0, 45)
CopyBtn.Position = UDim2.new(0, 30, 0, 175)
CopyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CopyBtn.Font = Enum.Font.Code
CopyBtn.Text = "Copy Discord"
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.TextSize = 14
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 4)

local VerifyBtn = Instance.new("TextButton", Main)
VerifyBtn.Size = UDim2.new(0, 175, 0, 45)
VerifyBtn.Position = UDim2.new(0, 215, 0, 175)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
VerifyBtn.Font = Enum.Font.Code
VerifyBtn.Text = "Locked"
VerifyBtn.TextColor3 = Color3.fromRGB(60, 60, 60)
VerifyBtn.TextSize = 14
VerifyBtn.AutoButtonColor = false
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

-- [ 3. GATE LOGIC ] --
local LinkCopied = false

CopyBtn.Activated:Connect(function()
    setclipboard(DiscordLink)
    LinkCopied = true
    CopyBtn.Text = "Link Copied!"
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    VerifyBtn.AutoButtonColor = true
end)

VerifyBtn.Activated:Connect(function()
    if not LinkCopied then return end

    if KeyInput.Text == CorrectKey then
        VerifyBtn.Text = "Access Granted"
        VerifyBtn.TextColor3 = Color3.new(0, 1, 0)
        
        -- THE FIX: Spawn the loader separately and kill UI immediately
        task.spawn(function()
            task.wait(0.5)
            GateGui:Destroy()
            
            local success, result = pcall(function()
                return game:HttpGet(ScriptURL)
            end)
            
            if success then
                local load_func = loadstring(result)
                if load_func then
                    load_func()
                else
                    warn("Velarium Error: GitHub Script Syntax Error")
                end
            else
                warn("Velarium Error: Connection Failed")
            end
        end)
    else
        VerifyBtn.Text = "Invalid Key"
        VerifyBtn.TextColor3 = Color3.new(1, 0, 0)
        task.wait(1)
        VerifyBtn.Text = "Verify Key"
        VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
    end
end)
