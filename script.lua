--[[ 
    =========================================================
    velarium.dev.scr // THE ULTIMATE FIXED PROTOCOL
    =========================================================
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- [ 1. CONFIG ] --
local DiscordLink = "https://discord.gg/velarium"
local CorrectKey = "VELARIUM_ON_TOP" 
local ScriptURL = "https://raw.githubusercontent.com/dontcare-dev/Okay-bro/main/script.lua"

-- [ 2. UI SETUP ] --
if CoreGui:FindFirstChild("VelariumGate") then CoreGui.VelariumGate:Destroy() end
local GateGui = Instance.new("ScreenGui", CoreGui)
GateGui.Name = "VelariumGate"

local Main = Instance.new("Frame", GateGui)
Main.Size = UDim2.new(0, 420, 0, 260)
Main.Position = UDim2.new(0.5, -210, 0.5, -130)
Main.BackgroundColor3 = Color3.new(0, 0, 0)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(50, 50, 50)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.Text = "velarium.dev.scr // ACCESS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20

local KeyInput = Instance.new("TextBox", Main)
KeyInput.Size = UDim2.new(1, -60, 0, 45)
KeyInput.Position = UDim2.new(0, 30, 0, 110)
KeyInput.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
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
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 4)

local VerifyBtn = Instance.new("TextButton", Main)
VerifyBtn.Size = UDim2.new(0, 175, 0, 45)
VerifyBtn.Position = UDim2.new(0, 215, 0, 175)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
VerifyBtn.Font = Enum.Font.Code
VerifyBtn.Text = "Locked"
VerifyBtn.TextColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 4)

-- [ 3. LOGIC ] --
local LinkCopied = false

CopyBtn.Activated:Connect(function()
    setclipboard(DiscordLink)
    LinkCopied = true
    CopyBtn.Text = "Link Copied!"
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

VerifyBtn.Activated:Connect(function()
    if not LinkCopied then return end

    if KeyInput.Text == CorrectKey then
        VerifyBtn.Text = "Access Granted"
        VerifyBtn.TextColor3 = Color3.new(0, 1, 0)
        
        task.wait(0.5)
        GateGui:Destroy() -- UI is gone, now for the actual script

        -- [ 4. THE POWER LOADER ] --
        task.spawn(function()
            local success, content = pcall(function()
                return game:HttpGet(ScriptURL)
            end)

            if success and content then
                local func, err = loadstring(content)
                if func then
                    pcall(func) -- RUN THE SAILOR PIECE SCRIPT
                else
                    warn("SYNTAX ERROR IN GITHUB SCRIPT: " .. tostring(err))
                end
            else
                warn("HTTP ERROR: COULD NOT FETCH FROM GITHUB")
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
