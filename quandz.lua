local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Xóa UI cũ nếu có để tránh trùng lặp
if playerGui:FindFirstChild("QuandzUI") then
	playerGui.QuandzUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuandzUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Nút tròn mở menu ở cạnh trái màn hình
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 44, 0, 44)
toggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
toggleBtn.Text = "⚡"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 19
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Khung Menu chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 265)
mainFrame.Position = UDim2.new(0.08, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Thêm Ảnh Nền (Thay rbxassetid://YOUR_IMAGE_ID bằng ID ảnh anime của bạn)
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://YOUR_IMAGE_ID" -- <-- Thay ID ảnh của bạn vào đây
bgImage.ImageTransparency = 0.35
bgImage.ZIndex = 0
bgImage.Parent = mainFrame
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 12)

-- Tiêu đề menu Quândz
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 12, 0, 4)
title.BackgroundTransparency = 1
title.Text = "⚡ Quândz PANEL"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
title.Parent = mainFrame

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Cấu hình tính năng
local CONFIG = {
	DoorESP = true,
	EntityESP = true,
	AutoGold = true,
	Bright = false
}

local function addToggle(name, yPos, default, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.92, 0, 0, 36)
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

-- Hệ thống ESP thông minh quản lý theo số phòng
local activeESPs = {}

local function attachESP(target, text, color, tagType, roomNum)
	if not target or target:FindFirstChild("QuandzESP") then return end

	local hl = Instance.new("Highlight")
	hl.Name = "QuandzESP"
	hl:SetAttribute("Type", tagType)
	hl.FillColor = color
	hl.OutlineColor = color
	hl.FillTransparency = 0.85
	hl.OutlineTransparency = 0.2
	hl.Adornee = target
	hl.Parent = target

	local bb = Instance.new("BillboardGui")
	bb.Name = "QuandzESPLabel"
	bb:SetAttribute("Type", tagType)
	bb.Adornee = target
	bb.Size = UDim2.new(0, 75, 0, 16)
	bb.StudsOffset = Vector3.new(0, 1.2, 0)
	bb.AlwaysOnTop = true
	bb.MaxDistance = 150
	bb.Active = false
	bb.Parent = target

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = color
	lbl.TextStrokeTransparency = 0.3
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 9.5
	lbl.Active = false
	lbl.Parent = bb

	table.insert(activeESPs, {target = target, hl = hl, bb = bb, roomNum = roomNum or 0})
end

local function getDoorNum(door)
	local num = door:GetAttribute("RoomNumber") or door:GetAttribute("Number")
	if num ~= nil and tonumber(num) then return tonumber(num) end
	for _, desc in ipairs(door:GetDescendants()) do
		if desc:IsA("TextLabel") then
			local txt = string.gsub(desc.Text or "", "%s+", "")
			if txt ~= "" and tonumber(txt) then return tonumber(txt) end
		end
	end
	return nil
end

local function getCurrentRoomNumber()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return 0 end

	local highestNum = 0
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == "Door" then
			local num = getDoorNum(v)
			if num and num > highestNum then
				local pos = v:GetPivot().Position
				if (root.Position - pos).Magnitude < 60 then
					highestNum = num
				end
			end
		end
	end
	return highestNum
end

-- Tối ưu hóa vòng lặp (Chạy mượt mà, không gây giật nhân vật)
local clock = 0
RunService.Heartbeat:Connect(function(dt)
	clock += dt
	if clock < 0.2 then return end -- Chỉ quét mỗi 0.2 giây thay vì mỗi khung hình để tránh lag
	clock = 0

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	-- 1. Auto Nhặt Xu mượt mà
	if CONFIG.AutoGold then
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("Model") or v:IsA("BasePart") then
				local name = string.lower(v.Name)
				if string.find(name, "gold") or string.find(name, "coin") or string.find(name, "tiền") or string.find(name, "xu") then
					local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
					if part and (root.Position - part.Position).Magnitude < 12 then
						local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
						if prompt then
							fireproximityprompt(prompt)
						end
					end
				end
			end
		end
	end

	-- 2. Dọn dẹp ESP phòng phía sau
	local currentRoom = getCurrentRoomNumber()
	if currentRoom > 0 then
		for i = #activeESPs, 1, -1 do
			local item = activeESPs[i]
			if not item.target or not item.target.Parent then
				table.remove(activeESPs, i)
			else
				if item.roomNum > 0 and item.roomNum < currentRoom then
					if item.hl then item.hl:Destroy() end
					if item.bb then item.bb:Destroy() end
					table.remove(activeESPs, i)
				end
			end
		end
	end
end)

local function clearESP(tagType)
	for _, v in ipairs(Workspace:GetDescendants()) do
		if (v.Name == "QuandzESP" or v.Name == "QuandzESPLabel") and v:GetAttribute("Type") == tagType then
			v:Destroy()
		end
	end
	activeESPs = {}
end

local function checkObj(obj)
	if not obj:IsA("Model") and not obj:IsA("BasePart") then return end
	local name = string.lower(obj.Name)

	if obj:IsA("Model") and obj.Name == "Door" and CONFIG.DoorESP then
		task.delay(0.1, function()
			if not obj.Parent or not CONFIG.DoorESP then return end
			local n = getDoorNum(obj)
			if n then 
				attachESP(obj, "🚪 Cửa " .. n, Color3.fromRGB(40, 255, 130), "Door", n) 
			end
		end)
	elseif CONFIG.EntityESP then
		if string.find(name, "rush") or string.find(name, "ambush") or string.find(name, "figure") or string.find(name, "eyes") then
			local roomN = getCurrentRoomNumber()
			attachESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 65, 65), "Entity", roomN)
		elseif string.find(name, "key") or string.find(name, "chia") or string.find(name, "lever") or string.find(name, "fuse") then
			local roomN = getCurrentRoomNumber()
			attachESP(obj, "🔑 " .. obj.Name, Color3.fromRGB(255, 220, 40), "Entity", roomN)
		end
	end
end

local function scan()
	for _, v in ipairs(Workspace:GetDescendants()) do checkObj(v) end
end

-- Tạo các nút bấm trên Menu
addToggle("ESP Cửa Có Số", 45, CONFIG.DoorESP, function(s)
	CONFIG.DoorESP = s
	if s then scan() else clearESP("Door") end
end)

addToggle("ESP Chìa & Quái", 90, CONFIG.EntityESP, function(s)
	CONFIG.EntityESP = s
	if s then scan() else clearESP("Entity") end
end)

addToggle("Tự Động Nhặt Xu", 135, CONFIG.AutoGold, function(s)
	CONFIG.AutoGold = s
end)

addToggle("Sáng Bản Đồ", 180, CONFIG.Bright, function(s)
	CONFIG.Bright = s
	Lighting.Brightness = s and 3 or 1
	Lighting.GlobalShadows = not s
end)

scan()
Workspace.DescendantAdded:Connect(checkObj)
