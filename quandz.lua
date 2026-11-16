local targetScript = [==[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local AssetService = game:GetService("AssetService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("QuandzUI") then
    playerGui.QuandzUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuandzUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- NÚT BẬT/TẮT (Avatar + Chữ MENU)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
toggleBtn.BackgroundTransparency = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 255, 255)
btnStroke.Thickness = 2
btnStroke.Parent = toggleBtn

local menuText = Instance.new("TextLabel")
menuText.Size = UDim2.new(1, 0, 0, 15)
menuText.Position = UDim2.new(0, 0, 1, -15)
menuText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuText.BackgroundTransparency = 0.3
menuText.Text = "MENU"
menuText.TextColor3 = Color3.new(1, 1, 1)
menuText.Font = Enum.Font.GothamBold
menuText.TextSize = 10
menuText.ZIndex = 2
menuText.Parent = toggleBtn
Instance.new("UICorner", menuText).CornerRadius = UDim.new(0, 4)

task.spawn(function()
    local success, img = pcall(function()
        return AssetService:GetAssetIdsForDecal(79085869292292)
    end)
    if success and typeof(img) == "table" and #img > 0 then
        toggleBtn.Image = "rbxassetid://" .. img[1]
    else
        toggleBtn.Image = "rbxassetid://79085869292292" 
    end
end)

-- HUD Cảnh báo
local warnFrame = Instance.new("TextLabel")
warnFrame.Size = UDim2.new(0, 250, 0, 40)
warnFrame.Position = UDim2.new(0, 20, 0, 85)
warnFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
warnFrame.BackgroundTransparency = 0.2
warnFrame.TextColor3 = Color3.new(1, 1, 1)
warnFrame.Font = Enum.Font.GothamBlack
warnFrame.TextSize = 16
warnFrame.Text = ""
warnFrame.Visible = false
warnFrame.ZIndex = 10
warnFrame.Parent = screenGui
Instance.new("UICorner", warnFrame).CornerRadius = UDim.new(0, 8)

-- KHUNG MENU CHÍNH
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 270, 0, 330)
mainFrame.Position = UDim2.new(0.08, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.ImageTransparency = 0.35
bgImage.ZIndex = 0
bgImage.Parent = mainFrame
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 12)

task.spawn(function()
    local success, img = pcall(function()
        return AssetService:GetAssetIdsForDecal(99593941503572)
    end)
    if success and typeof(img) == "table" and #img > 0 then
        bgImage.Image = "rbxassetid://" .. img[1]
    else
        bgImage.Image = "rbxassetid://99593941503572" 
    end
end)

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = mainFrame
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 12, 0, 4)
title.BackgroundTransparency = 1
title.Text = "🐦 Quândz Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
title.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local CONFIG = { DoorESP = true, ItemESP = true, EntityESP = true, AutoCoins = true, AutoPickup = true, Bright = false }

local function addToggle(name, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 34)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 52)
    btn.Text = name .. (default and " : BẬT" or " : TẮT")
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.ZIndex = 2
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 52)
        btn.Text = name .. (state and " : BẬT" or " : TẮT")
        callback(state)
    end)
end

-- HỆ THỐNG ESP
local activeESPs = {}
local function attachESP(target, text, color, tagType, isDoor)
    if not target or target:FindFirstChild("QuandzESP") then return end

    local hl = Instance.new("Highlight")
    hl.Name = "QuandzESP"
    hl:SetAttribute("Type", tagType)
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = isDoor and 1 or 0.8
    hl.OutlineTransparency = 0.1
    hl.Adornee = target
    hl.Parent = target

    local bb = nil
    if text ~= "" then
        bb = Instance.new("BillboardGui")
        bb.Name = "QuandzESPLabel"
        bb:SetAttribute("Type", tagType)
        bb.Adornee = target
        bb.Size = UDim2.new(0, 100, 0, 18)
        bb.StudsOffset = Vector3.new(0, 1.5, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 100
        bb.Parent = target

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color
        lbl.TextStrokeTransparency = 0.4
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.Parent = bb
    end

    table.insert(activeESPs, {target = target, hl = hl, bb = bb, tagType = tagType})
end

local function checkDoor(obj)
    if not CONFIG.DoorESP or not obj:IsA("Model") then return end
    if obj.Name == "Door" or obj.Name == "ExitDoor" then
        task.delay(0.2, function()
            if obj.Parent and CONFIG.DoorESP then
                local roomNum = 0
                local attr = obj:GetAttribute("RoomNumber") or obj:GetAttribute("Number")
                if attr then roomNum = tonumber(attr) end
                
                local text = roomNum > 0 and ("Door " .. tostring(roomNum)) or "Door"
                if roomNum == 0 then
                    for _, d in ipairs(obj:GetDescendants()) do
                        if d:IsA("TextLabel") then
                            local num = string.match(d.Text, "%d+")
                            if num then 
                                text = "Door " .. num 
                                break 
                            end
                        end
                    end
                end
                attachESP(obj, text, Color3.fromRGB(40, 255, 130), "Door", true)
            end
        end)
    end
end

local usefulItems = {
    ["key"] = {name = "Key", color = Color3.fromRGB(255, 220, 40)},
    ["skeleton"] = {name = "Skeleton Key", color = Color3.fromRGB(255, 220, 40)},
    ["lockpick"] = {name = "Lockpick", color = Color3.fromRGB(255, 220, 40)},
    ["shears"] = {name = "Shears", color = Color3.fromRGB(255, 220, 40)},
    ["bandage"] = {name = "Bandage", color = Color3.fromRGB(100, 255, 200)},
    ["vitamins"] = {name = "Vitamins", color = Color3.fromRGB(100, 255, 200)},
    ["crucifix"] = {name = "Crucifix", color = Color3.fromRGB(255, 65, 65)},
    ["laser"] = {name = "Laser Pointer", color = Color3.fromRGB(255, 50, 50)},
    ["flashlight"] = {name = "Flashlight", color = Color3.fromRGB(100, 200, 255)},
    ["lighter"] = {name = "Lighter", color = Color3.fromRGB(100, 200, 255)},
    ["glowstick"] = {name = "Glowstick", color = Color3.fromRGB(100, 255, 100)},
    ["straplight"] = {name = "Straplight", color = Color3.fromRGB(100, 200, 255)},
    ["bulklight"] = {name = "Bulklight", color = Color3.fromRGB(100, 200, 255)},
    ["starlight"] = {name = "Barrel of Starlight", color = Color3.fromRGB(255, 255, 100)},
    ["battery"] = {name = "Battery Pack", color = Color3.fromRGB(255, 150, 50)},
    ["fuse"] = {name = "Fuse", color = Color3.fromRGB(0, 255, 255)},
    ["breaker"] = {name = "Breaker", color = Color3.fromRGB(255, 150, 50)},
    ["lever"] = {name = "Lever", color = Color3.fromRGB(255, 150, 50)},
    ["switch"] = {name = "Switch", color = Color3.fromRGB(255, 150, 50)},
    ["generator"] = {name = "Generator", color = Color3.fromRGB(255, 150, 50)},
    ["circuit"] = {name = "Circuit", color = Color3.fromRGB(0, 255, 255)},
    ["book"] = {name = "Book", color = Color3.fromRGB(255, 100, 255)},
    ["paper"] = {name = "Paper", color = Color3.fromRGB(255, 100, 255)},
    ["note"] = {name = "Paper", color = Color3.fromRGB(255, 100, 255)}
}

local function checkItem(obj)
    if not CONFIG.ItemESP or not obj:IsA("Model") then return end
    if player.Character and obj:IsDescendantOf(player.Character) then return end
    if obj:FindFirstChildOfClass("Humanoid") then return end
    
    local n = string.lower(obj.Name)
    if string.find(n, "shop") or string.find(n, "jeff") then return end

    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then return end

    for kw, data in pairs(usefulItems) do
        if string.find(n, kw) then
            if not obj:FindFirstChild("QuandzESP") then
                attachESP(obj, "✨ " .. data.name, data.color, "Item", false)
            end
            return
        end
    end
end

local function checkEntity(obj)
    if not CONFIG.EntityESP or not obj:IsA("Model") then return end
    local n = string.lower(obj.Name)
    
    if string.find(n, "window") or string.find(n, "broken") or string.find(n, "crack") 
    or string.find(n, "door") or string.find(n, "shop") or string.find(n, "jeff") then 
        return 
    end

    local entityList = {"rush", "ambush", "seek", "figure", "eyes", "screech", "halt", "hide", "jack", "timothy", "snare", "giggle", "gloombat", "grumble", "groundskeeper", "surge", "mandrake", "eyestalk", "bramble", "honcho", "ransom", "drone", "bash"}

    for _, ent in ipairs(entityList) do
        if string.find(n, ent) then
            attachESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 65, 65), "Entity", false)
            return
        end
    end
end

local function clearESP(tagType)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if (v.Name == "QuandzESP" or v.Name == "QuandzESPLabel") and v:GetAttribute("Type") == tagType then
            v:Destroy()
        end
    end
    for i = #activeESPs, 1, -1 do
        if activeESPs[i].tagType == tagType then table.remove(activeESPs, i) end
    end
end

local function scanAll()
    task.spawn(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            checkDoor(v)
            checkItem(v)
            checkEntity(v)
        end
    end)
end

addToggle("ESP Cửa Chính", 35, CONFIG.DoorESP, function(s) CONFIG.DoorESP = s; if s then scanAll() else clearESP("Door") end end)
addToggle("ESP Vật phẩm", 73, CONFIG.ItemESP, function(s) CONFIG.ItemESP = s; if s then scanAll() else clearESP("Item") end end)
addToggle("ESP Quái vật", 111, CONFIG.EntityESP, function(s) CONFIG.EntityESP = s; if s then scanAll() else clearESP("Entity") end end)
addToggle("Auto Nhặt Tiền", 149, CONFIG.AutoCoins, function(s) CONFIG.AutoCoins = s end)
addToggle("Auto Nhặt Vật Phẩm", 187, CONFIG.AutoPickup, function(s) CONFIG.AutoPickup = s end)
addToggle("Sáng bản đồ", 225, CONFIG.Bright, function(s)
    CONFIG.Bright = s
    Lighting.Brightness = s and 3 or 1
    Lighting.GlobalShadows = not s
    Lighting.FogEnd = s and 100000 or 1000
end)

scanAll()

Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    checkDoor(obj)
    checkItem(obj)
    checkEntity(obj)
end)

-- ================= VÒNG LẶP QUÉT NHẸ (CHỐNG SPAM & XÓA ESP CŨ) =================
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude

local alertKeywords = {
    ["rush"] = "RUSH",
    ["ambush"] = "AMBUSH",
    ["screech"] = "SCREECH",
    ["grumble"] = "GRUMBLE"
}

local lootedItems = {} 

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            -- 1. CẢNH BÁO QUÁI (Dùng GetDescendants để quét sâu vào mọi ngóc ngách)
            local closestDist = math.huge
            local closestMsg = ""
            local isAlerting = false

            if CONFIG.EntityESP then
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        local n = string.lower(v.Name)
                        if n ~= "eyes" and n ~= "seekarms" and n ~= "seekhand" and n ~= "seekgoo" then
                            for kw, msg in pairs(alertKeywords) do
                                if string.find(n, kw) then
                                    local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        local dist = (root.Position - part.Position).Magnitude
                                        if dist < closestDist then
                                            closestDist = dist
                                            closestMsg = msg
                                            isAlerting = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if isAlerting then
                warnFrame.Visible = true
                warnFrame.Text = "⚠️ " .. closestMsg .. " (" .. math.floor(closestDist) .. "m)"
                warnFrame.BackgroundColor3 = (tick() % 0.6 < 0.3) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 0, 0)
            else
                warnFrame.Visible = false
            end

            -- 2. Auto Nhặt (Có thời gian hồi chiêu chống spam)
            if CONFIG.AutoCoins or CONFIG.AutoPickup then
                overlapParams.FilterDescendantsInstances = {char}
                local partsInRange = Workspace:GetPartBoundsInRadius(root.Position, 8, overlapParams)
                
                for _, part in ipairs(partsInRange) do
                    local obj = part:FindFirstAncestorOfClass("Model") or part
                    local n = string.lower(obj.Name)
                    
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true) 
                                  or part:FindFirstChildWhichIsA("ProximityPrompt", true)
                    
                    if prompt and prompt.Enabled then
                        if lootedItems[prompt] and (tick() - lootedItems[prompt] < 5) then
                            continue
                        end

                        local shouldLoot = false
                        local isShop = false
                        
                        local actionText = string.lower(prompt.ActionText)
                        if string.find(actionText, "buy") or string.find(actionText, "purchase") 
                        or string.find(n, "shop") or string.find(n, "jeff") then
                            isShop = true
                        end
                        
                        if not isShop then
                            if CONFIG.AutoCoins then
                                if string.find(n, "gold") or string.find(n, "coin") or string.find(n, "knob") then
                                    shouldLoot = true
                                end
                            end
                            
                            if not shouldLoot and CONFIG.AutoPickup then
                                for kw, _ in pairs(usefulItems) do
                                    if string.find(n, kw) then
                                        shouldLoot = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        if shouldLoot then
                            fireproximityprompt(prompt)
                            lootedItems[prompt] = tick()
                            break 
                        end
                    end
                end
            end

            -- 3. Dọn dẹp ESP (Xóa khi nhặt, khi vật thể bị game hủy, hoặc khi ở quá xa > 250 studs)
            if char then
                for i = #activeESPs, 1, -1 do
                    local item = activeESPs[i]
                    local shouldRemove = false
                    
                    if not item.target or not item.target.Parent then
                        shouldRemove = true
                    elseif item.target:IsDescendantOf(char) then
                        shouldRemove = true
                    else
                        local part = item.target:IsA("Model") and (item.target.PrimaryPart or item.target:FindFirstChildWhichIsA("BasePart")) or item.target:IsA("BasePart") and item.target
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist > 300 then
                                shouldRemove = true
                            end
                        end
                    end

                    if shouldRemove then
                        if item.hl then item.hl:Destroy() end
                        if item.bb then item.bb:Destroy() end
                        table.remove(activeESPs, i)
                    end
                end
            end
        end)
    end
end)
]==]

local secretKey = "Quandz_Hub_Super_Secure_Key_2024_!@#%^&*()"

local function xor_encrypt(text, key)
    local result = {}
    for i = 1, #text do
        local charCode = string.byte(text, i)
        local keyChar = string.byte(key, (i - 1) % #key + 1)
        table.insert(result, string.char(bit32.bxor(charCode, keyChar)))
    end
    return table.concat(result)
end

local function toHex(text)
    return (text:gsub('.', function(c)
        return string.format('%02x', string.byte(c))
    end))
end

local encrypted = xor_encrypt(targetScript, secretKey)
local hexEncrypted = toHex(encrypted)

-- Chia nhỏ chuỗi Hex để tránh giới hạn độ dài
local chunks = {}
for i = 1, #hexEncrypted, 2000 do
    table.insert(chunks, string.format('    "%s"', hexEncrypted:sub(i, i + 1999)))
end
local chunkString = table.concat(chunks, ",\n")

local loader = string.format([[
local _0x1 = {
%s
}
local _0x2 = table.concat(_0x1)
local _0x3 = "%s"
local _0x4 = ""
for _0x5 = 1, #_0x2, 2 do
    local _0x6 = tonumber(_0x2:sub(_0x5, _0x5+1), 16)
    local _0x7 = string.byte(_0x3, (math.floo
