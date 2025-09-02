-- ===================================================================================
-- KÜTÜPHANE YÜKLEME
-- ===================================================================================

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

-- ===================================================================================
-- ANA PENCERE
-- ===================================================================================

local Window = Luna:new({
    Name = "Script Hub by reallykrak & Kayra",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Luna"
    }
})

-- ===================================================================================
-- ANA SEKMELER
-- ===================================================================================

local MainTab = Window:addPage({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})

local AutoFarmTab = Window:addPage({
    Name = "Auto Farm",
    Icon = "rbxassetid://6023426922"
})

-- ===================================================================================
-- HIZ VE DİĞER ARAÇLAR
-- ===================================================================================

local SpeedSection = MainTab:addSection({
    Name = "Movement"
})

local player = game:GetService("Players").LocalPlayer
local walkSpeed = 16

SpeedSection:addSlider({
    Name = "Walk Speed",
    Default = 16,
    Minimum = 16,
    Maximum = 200,
    ValueName = "Speed",
    Callback = function(Value)
        walkSpeed = Value
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local infiniteJumpEnabled = false
SpeedSection:addToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
        if infiniteJumpEnabled then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

MainTab:addButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

-- ===================================================================================
-- FLY MENÜSÜ
-- ===================================================================================

local FlySection = MainTab:addSection({
    Name = "Fly Settings"
})

local speeds = 1
local flyEnabled = false

local function updateFlyState()
    local speaker = game:GetService("Players").LocalPlayer
    local chr = speaker.Character
    if not chr then return end
    local hum = chr:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if flyEnabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "reallykrak & Kayra",
            Text = "Fly ON!",
            Duration = 3
        })

        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        hum:ChangeState(Enum.HumanoidStateType.Swimming)

        local bodyPart = chr:FindFirstChild("UpperTorso") or chr:FindFirstChild("Torso")
        if not bodyPart then return end

        local bg = Instance.new("BodyGyro", bodyPart)
        bg.Name = "FlyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = bodyPart.CFrame
        local bv = Instance.new("BodyVelocity", bodyPart)
        bv.Name = "FlyVelocity"
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        hum.PlatformStand = true

        spawn(function()
            while flyEnabled and chr and hum and hum.Health > 0 do
                game:GetService("RunService").RenderStepped:Wait()
                bv.velocity = (game.Workspace.CurrentCamera.CoordinateFrame.lookVector * speeds)
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame
            end
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            if hum then hum.PlatformStand = false end
        end)

    else
        for _, part in pairs(chr:GetChildren()) do
            if part:IsA("BasePart") then
                local gyro = part:FindFirstChild("FlyGyro")
                local velocity = part:FindFirstChild("FlyVelocity")
                if gyro then gyro:Destroy() end
                if velocity then velocity:Destroy() end
            end
        end
        hum.PlatformStand = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "reallykrak & Kayra",
            Text = "Fly OFF!",
            Duration = 3
        })
    end
end

FlySection:addToggle({
    Name = "Enable Fly",
    Callback = function(Value)
        flyEnabled = Value
        updateFlyState()
    end    
})

FlySection:addSlider({
    Name = "Fly Speed",
    Default = 1,
    Minimum = 1,
    Maximum = 100,
    ValueName = "Speed",
    Callback = function(Value)
        speeds = Value
        Luna:Notify({
            Title = "Speed Changed!",
            Content = "New fly speed: " .. tostring(speeds),
            Duration = 5
        })
    end
})

local clockLabel = MainTab:addLabel({
    Name = "Time: Loading..."
})

spawn(function()
    while wait(1) do
        clockLabel:update({
            Name = "Time: " .. os.date("%H:%M:%S")
        })
    end
end)

MainTab:addLabel({
    Name = "made by reallykrak"
})

-- ===================================================================================
-- AUTO FARM BÖLÜMÜ
-- ===================================================================================

local autoFarmSection = AutoFarmTab:addSection({
    Name = "Beach Ball Collector"
})

local autoFarmEnabled = false
local farmSpeed = 25
local isFarming = false
local beachBallName = "BeachBall" -- OYUN İÇİNDEKİ ADI FARKLIYSA BUNU DEĞİŞTİRİN

local function getClosestBeachBall()
    local closestBall = nil
    local shortestDistance = math.huge
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character

    if not character then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end

    for i, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == beachBallName and v:IsA("BasePart") then
            local distance = (humanoidRootPart.Position - v.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestBall = v
            end
        end
    end
    return closestBall
end

local function startAutoFarm()
    isFarming = true
    local player = game:GetService("Players").LocalPlayer
    
    spawn(function()
        while isFarming and autoFarmEnabled do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if not (character and humanoid and humanoid.Health > 0) then
                isFarming = false
                break
            end
            
            local closestBall = getClosestBeachBall()
            
            if closestBall then
                humanoid:MoveTo(closestBall.Position)
            else
                humanoid:MoveTo(humanoid.Parent.HumanoidRootPart.Position) -- Hareketi durdur
                Luna:Notify({
                    Title = "Auto Farm",
                    Content = "No beach balls found. Waiting for next round.",
                    Duration = 5
                })
                isFarming = false 
            end
            
            wait(0.1)
        end
    end)
end

local function stopAutoFarm()
    isFarming = false
end

autoFarmSection:addToggle({
    Name = "Enable Auto Farm",
    Callback = function(Value)
        autoFarmEnabled = Value
        if not Value then
            stopAutoFarm()
        else
            if not isFarming and game:GetService("ReplicatedStorage").Status.Value ~= "Intermission" then
                startAutoFarm()
            end
        end
    end
})

autoFarmSection:addSlider({
    Name = "Collection Speed",
    Default = 25,
    Minimum = 16,
    Maximum = 100,
    ValueName = "Speed",
    Callback = function(Value)
        farmSpeed = Value
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = farmSpeed
        end
        Luna:Notify({
            Title = "Speed Changed!",
            Content = "New collection speed: " .. tostring(farmSpeed),
            Duration = 5
        })
    end
})

-- ===================================================================================
-- ANTI-AFK BÖLÜMÜ
-- ===================================================================================

local antiAfkSection = AutoFarmTab:addSection({
    Name = "Anti AFK"
})

local antiAfkEnabled = false
local idleConnection
local VirtualUser = game:GetService('VirtualUser')

local function enableAntiAfk()
    if not idleConnection then
        idleConnection = game:GetService('Players').LocalPlayer.Idled:connect(function()
            if antiAfkEnabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                
                Luna:Notify({
                    Title = "Anti-AFK",
                    Content = "Prevented you from being kicked for idling!",
                    Duration = 2
                })
            end
        end)
    end
end

local function disableAntiAfk()
    if idleConnection then
        idleConnection:Disconnect()
        idleConnection = nil
    end
end

antiAfkSection:addToggle({
    Name = "Enable Anti-AFK",
    Default = false,
    Callback = function(Value)
        antiAfkEnabled = Value
        if Value then
            enableAntiAfk()
            Luna:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK Enabled!",
                Duration = 4
            })
        else
            disableAntiAfk()
            Luna:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK Disabled!",
                Duration = 4
            })
        end
    end
})

-- ===================================================================================
-- OTOMASYON YÖNETİCİSİ (TUR BAŞLANGICI/BİTİŞİ)
-- ===================================================================================

local function onRoundChange()
    local status = game:GetService("ReplicatedStorage"):WaitForChild("Status")
    
    status.Changed:Connect(function(newStatus)
        if newStatus ~= "Intermission" and autoFarmEnabled then
            if not isFarming then
                wait(2) -- Turun tamamen başlamasını bekle
                startAutoFarm()
            end
        elseif newStatus == "Intermission" then
            if isFarming then
                stopAutoFarm()
            end
        end
    end)
end

-- ===================================================================================
-- SCRIPT BAŞLATMA VE YENİDEN DOĞMA YÖNETİMİ
-- ===================================================================================

onRoundChange() -- Tur durumunu dinlemeye başla

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = walkSpeed
    end

    if flyEnabled then
        updateFlyState()
    end
end)
