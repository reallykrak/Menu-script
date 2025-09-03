--[[
    Script: Fly Menu (Luna Library)
    Author: Gemini (for reallykrak)
    Date: 03.09.2025
    Description: Luna kütüphanesi kullanılarak oluşturulmuş örnek bir fly menüsü.
]]

-- 1. Luna Kütüphanesini Yüklüyoruz
-- Bu satır, kütüphanenin kodlarını internetten çeker ve çalıştırır.
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

-- Script'imizin durumunu tutacak değişkenler
local flyEnabled = false
local flySpeed = 50 -- Varsayılan hız

-- ===================================================================================
-- ||                        KENDİ FONKSİYONLARINI BURAYA YAZ                         ||
-- =================================em==================================================
-- Not: Aşağıdakiler sadece birer örnektir. Bu fonksiyonların içini
-- kendi fly script'inin mantığıyla doldurman gerekiyor.

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local BodyGyro, BodyVelocity -- Uçuş için gerekli physics objeleri

local function enableFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end

    BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 500000

    BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    -- Karakterin zıplarken veya düşerkenki durumunu sabitler
    Humanoid.PlatformStand = true

    print("Fly Aktif Edildi!")
end

local function disableFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    
    Humanoid.PlatformStand = false

    print("Fly Devre Dışı Bırakıldı!")
end

local function setFlySpeed(newSpeed)
    flySpeed = newSpeed
    print("Yeni Uçuş Hızı: " .. tostring(flySpeed))
    -- Eğer fly aktif ise hızı anında güncelle
    if flyEnabled and BodyVelocity then
        -- Hız direkt BodyVelocity üzerinden ayarlanmaz, karakterin hareket input'u ile ayarlanır.
        -- Bu fonksiyon sadece hız değişkenini günceller.
        -- Gerçek bir script'te bu hızı hareket döngüsünde kullanırsın.
    end
end

-- Karakterin hareketini kontrol eden ana döngü (Örnek)
game:GetService("RunService").RenderStepped:Connect(function()
    if flyEnabled and BodyVelocity and BodyGyro then
        local camera = workspace.CurrentCamera
        BodyGyro.CFrame = camera.CFrame
        
        local moveDirection = Vector3.new(0, 0, 0)
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection - Vector3.new(0,0,1)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0,0,1)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Vector3.new(1,0,0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(1,0,0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0,1,0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0,1,0)
        end

        BodyVelocity.Velocity = (camera.CFrame.LookVector * moveDirection.Z + camera.CFrame.RightVector * moveDirection.X + camera.CFrame.UpVector * moveDirection.Y) * flySpeed
    end
end)


-- ===================================================================================
-- ||                             MENÜ TASARIMI (LUNA)                              ||
-- ===================================================================================

-- 2. Ana Pencereyi (Window) Oluşturuyoruz
-- Luna.new("Başlık", Genişlik, Yükseklik)
local Window = Luna.new("Krak's Fly Menu", 500, 350)

-- 3. Pencereye bir Sekme (Tab) Ekliyoruz
-- Window:add_tab("Sekme Adı", IkonID) -- IkonID Roblox'taki bir resmin ID'si olabilir.
local FlyTab = Window:add_tab("Fly Ayarları", 4483345998) -- Örnek bir ikon ID'si

-- 4. Sekmeye bir Bölüm (Section) Ekliyoruz
-- Bu, menüdeki elemanları gruplamak için kullanılır.
local ControlsSection = FlyTab:add_section("Ana Kontroller")

-- 5. Bölüme Menü Elemanlarını Ekliyoruz

-- AÇ/KAPA için bir Toggle (anahtar)
-- add_toggle("İsim", varsayılanDeğer, fonksiyon)
-- 'toggled' parametresi, anahtarın yeni durumunu (true/false) verir.
local flyToggle = ControlsSection:add_toggle("Fly Aktif", flyEnabled, function(toggled)
    flyEnabled = toggled -- Değişkenimizi güncelliyoruz
    if flyEnabled then
        enableFly()
    else
        disableFly()
    end
end)

-- HIZ AYARI için bir Slider (kaydırıcı)
-- add_slider("İsim", minimumDeğer, maximumDeğer, varsayılanDeğer, fonksiyon)
-- 'value' parametresi, kaydırıcının mevcut değerini verir.
ControlsSection:add_slider("Uçuş Hızı", 10, 1000, flySpeed, function(value)
    -- Değeri tam sayıya yuvarlayalım
    local speed = math.floor(value)
    setFlySpeed(speed)
end)

-- TUŞ ATAMASI için bir Keybind
-- add_keybind("İsim", varsayılanTuş, fonksiyon)
-- Bu tuşa basıldığında içindeki fonksiyon çalışır.
ControlsSection:add_keybind("Fly Tuşu (Toggle)", "E", function()
    -- Mevcut durumun tersini yap (açıksa kapat, kapalıysa aç)
    local newState = not flyEnabled
    
    -- Hem değişkeni hem de yukarıdaki toggle butonunu güncelle
    flyToggle:set(newState) 
end)


-- BİLGİLENDİRME için bir Label (etiket)
ControlsSection:add_label("Fly'ı açmak/kapatmak için butonu veya 'E' tuşunu kullanın.")


-- İkinci bir sekme (Credits) ekleyelim
local CreditsTab = Window:add_tab("Hakkında", 5122979213)
local CreditsSection = CreditsTab:add_section("Geliştiriciler")

CreditsSection:add_label("Script Sahibi: reallykrak")
CreditsSection:add_label("UI Tasarımı: Gemini (Google AI)")
CreditsSection:add_label("UI Kütüphanesi: Luna by Nebula Softworks")
