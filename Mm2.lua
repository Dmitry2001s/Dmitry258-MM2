local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "MM2_SUPREMACY_ULTIMATE"
sg.ResetOnSpawn = false

-- Глобальные переменные управления
local activeNotifications = {}
local currentTheme = "Радуга"
local shOpen, mdOpen, inOpen, espOpen = true, true, true, true
local espO, espBox, espLine, espDist = false, false, false, false
local flyO, noclO, jumpO, aimO, paniO = false, false, false, false, false
local plat, oldC, bv, bg

-- Эффекты радужного текста и бордеров
local function applyRGB(obj)
    RunService.RenderStepped:Connect(function()
        obj.TextColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1)
    end)
end

local function applyThemeBorder(obj)
    RunService.RenderStepped:Connect(function()
        if currentTheme == "Радуга" then
            obj.BackgroundColor3 = Color3.fromHSV(tick() % 6 / 6, 0.8, 0.8)
        end
    end)
end

-- Компактная очередь уведомлений (без наложения)
local function notify(text)
    local n = Instance.new("Frame", sg)
    n.Size = UDim2.new(0, 180, 0, 35)
    n.Position = UDim2.new(1, 30, 0.75, 0)
    n.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
    
    local border = Instance.new("Frame", n)
    border.Size = UDim2.new(1, 2, 1, 2)
    border.Position = UDim2.new(0, -1, 0, -1)
    border.ZIndex = n.ZIndex - 1
    Instance.new("UICorner", border).CornerRadius = UDim.new(0, 6)
    RunService.RenderStepped:Connect(function() border.BackgroundColor3 = Color3.fromHSV(tick()%3/3, 1, 1) end)
    
    local nt = Instance.new("TextLabel", n)
    nt.Size, nt.BackgroundTransparency, nt.Text, nt.TextColor3, nt.Font, nt.TextSize = UDim2.new(1, 0, 1, 0), 1, text, Color3.new(1,1,1), Enum.Font.GothamBold, 12
    
    table.insert(activeNotifications, n)
    
    local function updatePositions()
        for i, frame in ipairs(activeNotifications) do
            local targetY = 0.75 - ((#activeNotifications - i) * 0.055)
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -195, targetY, 0)}):Play()
        end
    end
    updatePositions()
    
    task.delay(2.5, function()
        local index = table.find(activeNotifications, n)
        if index then table.remove(activeNotifications, index) end
        local out = TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 30, n.Position.Y.Scale, 0)})
        out:Play()
        out.Completed:Connect(function() n:Destroy() end)
        updatePositions()
    end)
end

-- Стартовая анимация текста
local intro = Instance.new("TextLabel", sg)
intro.Size, intro.Position, intro.BackgroundTransparency, intro.Font, intro.TextSize = UDim2.new(0, 500, 0, 60), UDim2.new(0.5, -250, 0.45, 0), 1, Enum.Font.GothamBold, 45
applyRGB(intro)
task.spawn(function()
    local n = "dmitry258 mm2"
    for i = 1, #n do intro.Text = n:sub(1,i).."_" task.wait(0.06) end
    task.wait(0.8) intro:Destroy() notify("SUPREMACY ЗАПУЩЕН")
end)

-- Создание главного окна меню
local mf = Instance.new("Frame", sg)
mf.Size, mf.Position, mf.BackgroundColor3, mf.Visible, mf.Active = UDim2.new(0, 450, 0, 440), UDim2.new(0.5, -225, 0.5, -220), Color3.fromRGB(8, 8, 8), false, true
Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 18)

local border = Instance.new("Frame", mf)
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.ZIndex = mf.ZIndex - 1
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 18)
applyThemeBorder(border)

local function setupDrag(gui)
    local dS, dP, sP
    gui.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dS = true dP = i.Position sP = gui.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dP gui.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dS = false end end)
end
setupDrag(mf)

-- Верхняя плашка быстрого развертывания (Pill UI)
local pill = Instance.new("Frame", sg)
pill.Size, pill.Position, pill.BackgroundColor3, pill.BackgroundTransparency = UDim2.new(0, 350, 0, 45), UDim2.new(0.5, -175, 0, 2), Color3.new(0,0,0), 0.2
Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
local pillBorder = Instance.new("Frame", pill)
pillBorder.Size = UDim2.new(1, 4, 1, 4)
pillBorder.Position = UDim2.new(0, -2, 0, -2)
pillBorder.ZIndex = pill.ZIndex - 1
Instance.new("UICorner", pillBorder).CornerRadius = UDim.new(1, 0)
applyThemeBorder(pillBorder)

local pt = Instance.new("TextLabel", pill)
pt.Size, pt.Position, pt.BackgroundTransparency, pt.Font, pt.TextSize = UDim2.new(0.8, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), 1, Enum.Font.GothamBold, 15
pt.Text = "dmitry258 mm2 (СКРЫТО)"
applyRGB(pt)
local openBtn = Instance.new("TextButton", pill)
openBtn.Size, openBtn.Position, openBtn.Text, openBtn.BackgroundColor3, openBtn.TextColor3 = UDim2.new(0, 34, 0, 34), UDim2.new(0.88, 0, 0.5, -17), "▲", Color3.fromRGB(35,35,35), Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)

-- Сессионный таймер
local uBox = Instance.new("TextLabel", mf)
uBox.Size, uBox.Position, uBox.BackgroundColor3, uBox.BackgroundTransparency, uBox.TextColor3, uBox.Font, uBox.TextSize = UDim2.new(0, 90, 0, 28), UDim2.new(1, -100, 0, 12), Color3.new(0,0,0), 0.6, Color3.new(0, 1, 1), Enum.Font.Code, 15
Instance.new("UICorner", uBox)
local startT = tick()
RunService.RenderStepped:Connect(function() local e = tick() - startT uBox.Text = string.format("%02d:%02d", math.floor(e/60), math.floor(e%60)) end)

-- Заголовок меню и Ватермарка
local title = Instance.new("TextLabel", mf)
title.Size, title.Position, title.BackgroundTransparency, title.Font, title.TextSize, title.Text = UDim2.new(0.7, 0, 0, 50), UDim2.new(0.1, 0, 0, 0), 1, Enum.Font.GothamBold, 20, "dmitry258 mm2"
applyRGB(title)

local watermark = Instance.new("TextLabel", mf)
watermark.Size, watermark.Position, watermark.BackgroundTransparency, watermark.Font, watermark.TextSize, watermark.Text = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 1, -55), 1, Enum.Font.Code, 13, "Создатель описания: dmitry258 mm2"
applyRGB(watermark)

-- Вкладки и скролл-контейнер
local th = Instance.new("Frame", mf)
th.Size, th.Position, th.BackgroundTransparency = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0.13, 0), 1
local container = Instance.new("ScrollingFrame", mf)
container.Size, container.Position, container.BackgroundTransparency, container.ScrollBarThickness, container.CanvasSize = UDim2.new(1, -20, 0.62, 0), UDim2.new(0, 10, 0.23, 0), 1, 2, UDim2.new(0,0,0,1500)
Instance.new("UIListLayout", container).Padding = UDim.new(0, 6)

-- Функция полноценного контролируемого выстрела шерифа
local function shootMurderer()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
            target = p.Character break
        end
    end
    if target and target:FindFirstChild("HumanoidRootPart") and lp.Character then
        local gun = lp.Character:FindFirstChild("Gun") or lp.Character:FindFirstChild("Revolver") or lp.Backpack:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Revolver")
        if gun then
            gun.Parent = lp.Character
            task.wait(0.05)
            local lookAtPos = target.HumanoidRootPart.Position
            workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, lookAtPos)
            task.wait(0.04)
            gun:Activate()
            notify("Выстрел произведен!")
        else notify("Вы не шериф!") end
    else notify("Убийца не найден!") end
end

-- Новая круглая статичная кнопка стрельбы справа от меню
local circleShoot = Instance.new("TextButton", mf)
circleShoot.Size = UDim2.new(0, 65, 0, 65)
circleShoot.Position = UDim2.new(1, 15, 0, 80) -- справа от стены меню, статично
circleShoot.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
circleShoot.Text = "🔫"
circleShoot.TextSize = 26
Instance.new("UICorner", circleShoot).CornerRadius = UDim.new(1, 0) -- Идеальный круг
local csBorder = Instance.new("Frame", circleShoot)
csBorder.Size, csBorder.Position, csBorder.ZIndex = UDim2.new(1,4,1,4), UDim2.new(0,-2,0,-2), circleShoot.ZIndex - 1
Instance.new("UICorner", csBorder).CornerRadius = UDim.new(1, 0)
applyThemeBorder(csBorder)
circleShoot.MouseButton1Click:Connect(shootMurderer)

-- Генератор кнопок меню
local activeLoops = {}
local function clearContainer()
    for _, c in pairs(activeLoops) do c:Disconnect() end
    activeLoops = {}
    for _,v in pairs(container:GetChildren()) do 
        if not v:IsA("UIListLayout") then v:Destroy() end 
    end
end

local function addMenuButton(txt, clr, cb, isLooping)
    local b = Instance.new("TextButton", container)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.TextSize = UDim2.new(1, -10, 0, 38), clr or Color3.fromRGB(24,24,24), txt, Color3.new(1,1,1), Enum.Font.Gotham, 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    if isLooping then
        local conn = RunService.RenderStepped:Connect(function() b.BackgroundColor3 = Color3.fromHSV(tick() % 4 / 4, 0.8, 0.4) end)
        table.insert(activeLoops, conn)
    end
    b.MouseButton1Click:Connect(cb) return b
end

local function addMenuHeader(txt, clr)
    local l = Instance.new("TextLabel", container)
    l.Size, l.BackgroundColor3, l.Text, l.TextColor3, l.Font, l.TextSize = UDim2.new(1, -10, 0, 26), clr or Color3.fromRGB(35,35,45), txt, Color3.new(1,1,1), Enum.Font.GothamBold, 13
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
end

-- Циклы обработки классического ESP, Хитбоксов, Полёта и Наводки
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local isM = char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local isS = char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            local designColor = isM and Color3.new(1,0,0) or (isS and Color3.new(0,0,1) or Color3.new(0,1,0))
            
            -- Старый стабильный заливной ESP (Highlight)
            if espO then
                local h = char:FindFirstChild("CL_ESP") or Instance.new("Highlight", char)
                h.Name = "CL_ESP" h.FillColor = designColor h.FillTransparency = 0.4
                h.OutlineColor = Color3.new(1,1,1) h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop h.Enabled = true
            else if char:FindFirstChild("CL_ESP") then char.CL_ESP:Destroy() end end
            
            -- Классический Хитбокс (SelectionBox)
            if espBox then
                local b = char:FindFirstChild("CL_BOX") or Instance.new("SelectionBox", char)
                b.Name = "CL_BOX" b.Adornee = char b.LineThickness = 0.06 b.Color3 = designColor b.Visible = true
            else if char:FindFirstChild("CL_BOX") then char.CL_BOX:Destroy() end end
            
            -- Дистанция над головой
            if espDist then
                local tag = char.Head:FindFirstChild("CL_TAG") or Instance.new("BillboardGui", char.Head)
                tag.Name = "CL_TAG" tag.Size, tag.AlwaysOnTop, tag.StudsOffset = UDim2.new(0, 140, 0, 50), true, Vector3.new(0, 3, 0)
                local lbl = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
                lbl.Name = "L" lbl.Size, lbl.BackgroundTransparency, lbl.TextSize, lbl.Font = UDim2.new(1,0,1,0), 1, 13, Enum.Font.GothamBold
                lbl.Text = string.format("%s\n[%s]\n%dм", p.Name, (isM and "МАНИЯК" or (isS and "ШЕРИФ" or "МИРНЫЙ")), math.floor((lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude))
                lbl.TextColor3 = designColor tag.Enabled = true
            else if char.Head:FindFirstChild("CL_TAG") then char.Head.CL_TAG:Destroy() end end
            
            -- Классические линии трассеров (LineHandleAdornment)
            if espLine and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local line = char:FindFirstChild("CL_LINE") or Instance.new("LineHandleAdornment", char)
                line.Name = "CL_LINE" line.Adornee = lp.Character.HumanoidRootPart line.AlwaysOnTop = true
                line.Length = (lp.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                line.CFrame = CFrame.lookAt(Vector3.new(), lp.Character.HumanoidRootPart.CFrame:ToObjectSpace(hrp.CFrame).Position)
                line.Color3 = designColor line.Thickness = 2 line.ZIndex = 10
            else if char:FindFirstChild("CL_LINE") then char.CL_LINE:Destroy() end end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyO and lp.Character and bv and bg then
        local h = lp.Character:FindFirstChildOfClass("Humanoid")
        if h and lp.Character:FindFirstChild("HumanoidRootPart") then
            bg.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = h.MoveDirection
            if moveDir.Magnitude > 0 then
                local cam = workspace.CurrentCamera
                local lookXZ = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
                local rightXZ = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z).Unit
                bv.Velocity = (cam.CFrame.LookVector * moveDir:Dot(lookXZ) + cam.CFrame.RightVector * moveDir:Dot(rightXZ)).Unit * 75
            else bv.Velocity = Vector3.new(0, 0, 0) end
        end
    end
    if aimO then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, hrp.Position)
                end
            end
        end
    end
end)

RunService.WorkspaceTracker:Connect(function()
    if noclO and lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if jumpO and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Рендеринг Вкладок меню
local renderTab1, renderTab2

renderTab1 = function()
    clearContainer()
    
    addMenuHeader("⚔️ ФУНКЦИИ ШЕРИФА", Color3.fromRGB(35, 40, 75))
    addMenuButton("Стрельнуть в убийцу", Color3.fromRGB(45, 55, 110), shootMurderer)
    addMenuButton("Авто-наводка на убийцу: " .. (aimO and "ВКЛ" or "ВЫКЛ"), nil, function() aimO = not aimO renderTab1() end, aimO)
    
    addMenuHeader("🩸 ФУНКЦИИ УБИЙЦЫ", Color3.fromRGB(75, 35, 35))
    addMenuButton("Убить всех (Мгновенный круг)", Color3.fromRGB(140, 30, 30), function()
        local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
        if knife and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            knife.Parent = lp.Character
            local currentPos = lp.Character.HumanoidRootPart.CFrame
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                    task.wait(0.01)
                    knife:Activate()
                end
            end
            lp.Character.HumanoidRootPart.CFrame = currentPos
            notify("Все цели уничтожены!")
        else notify("Вы не убийца!") end
    end)
    
    addMenuHeader("🏃 ФУНКЦИИ НЕВИНОВНОГО", Color3.fromRGB(35, 75, 45))
    addMenuButton("Сейф локация: " .. (paniO and "ВКЛ" or "ВЫКЛ"), nil, function()
        paniO = not paniO
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local r = lp.Character.HumanoidRootPart
            if paniO then
                oldC = r.CFrame
                plat = Instance.new("Part", workspace)
                plat.Size, plat.Position, plat.Anchored, plat.Color, plat.Material = Vector3.new(50,1,50), Vector3.new(r.Position.X, 1200, r.Position.Z), true, Color3.new(1,0,1), Enum.Material.Neon
                r.CFrame = plat.CFrame + Vector3.new(0, 3, 0)
            else
                if plat then plat:Destroy() end if oldC then r.CFrame = oldC end
            end
        end
        renderTab1()
    end, paniO)
    
    addMenuButton("Полет (Камера): " .. (flyO and "ВКЛ" or "ВЫКЛ"), nil, function()
        flyO = not flyO
        if flyO and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            bv, bg = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart), Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
            bv.MaxForce, bg.MaxTorque = Vector3.new(1,1,1)*math.huge, Vector3.new(1,1,1)*math.huge
        else if bv then bv:Destroy() end if bg then bg:Destroy() end end
        renderTab1()
    end, flyO)
    
    addMenuButton("Сквозь стены (Noclip): " .. (noclO and "ВКЛ" or "ВЫКЛ"), nil, function()
        noclO = not noclO
        if not noclO and lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
        end
        renderTab1()
    end, noclO)
    
    addMenuButton("Бесконечный прыжок: " .. (jumpO and "ВКЛ" or "ВЫКЛ"), nil, function() jumpO = not jumpO renderTab1() end, jumpO)
    
    addMenuHeader("👁️ СИСТЕМА ESP", Color3.fromRGB(75, 75, 35))
    addMenuButton("Обычный ESP: " .. (espO and "ВКЛ" or "ВЫКЛ"), nil, function() espO = not espO renderTab1() end, espO)
    addMenuButton("Классический Хитбокс (Box): " .. (espBox and "ВКЛ" or "ВЫКЛ"), nil, function() espBox = not espBox renderTab1() end, espBox)
    addMenuButton("Классические Линии: " .. (espLine and "ВКЛ" or "ВЫКЛ"), nil, function() espLine = not espLine renderTab1() end, espLine)
    addMenuButton("Показывать Дистанцию: " .. (espDist and "ВКЛ" or "ВЫКЛ"), nil, function() espDist = not espDist renderTab1() end, espDist)

    addMenuHeader("⚙️ МОДИФИКАЦИИ ХАРАКТЕРИСТИК", Color3.fromRGB(40,40,40))
    local function addStatBox(ph, cb)
        local box = Instance.new("TextBox", container)
        box.Size, box.BackgroundColor3, box.PlaceholderText, box.Text, box.TextColor3, box.Font, box.TextSize = UDim2.new(1, -10, 0, 36), Color3.fromRGB(20,20,20), ph, "", Color3.new(1,1,1), Enum.Font.Gotham, 13
        Instance.new("UICorner", box)
        box.FocusLost:Connect(function(enter) if enter then cb(tonumber(box.Text)) end end)
    end
    addStatBox("Изменить скорость (WalkSpeed)", function(v) if v and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end)
    addStatBox("Изменить прыжок (JumpPower)", function(v) if v and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.JumpPower = v end end)
    addStatBox("Изменить гравитацию (Gravity)", function(v) if v then workspace.Gravity = v end end)

    addMenuButton("РЕЖИМ БОГА (GOD MODE)", Color3.fromRGB(65, 45, 90), function()
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") then 
            char.Humanoid:Destroy() Instance.new("Humanoid", char) notify("Режим Бога активирован!") 
        end
    end)
    
    addMenuButton("СБРОСИТЬ ВСЕ НАСТРОЙКИ", Color3.fromRGB(150, 40, 40), function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed, lp.Character.Humanoid.JumpPower, workspace.Gravity = 16, 50, 196.2
        end
        espO, espBox, espLine, espDist = false, false, false, false
        flyO, noclO, jumpO, aimO, paniO = false, false, false, false, false
        if bv then bv:Destroy() end if bg then bg:Destroy() end
        if plat then plat:Destroy() end
        if lp.Character then
            for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
        end
        notify("Сброс выполнен") renderTab1()
    end)
end

renderTab2 = function()
    clearContainer()
    addMenuHeader("ℹ️ ИНФОРМАЦИЯ О КЛИЕНТЕ", Color3.fromRGB(45, 45, 45))
    
    local creatorNameLabel = Instance.new("TextLabel", container)
    creatorNameLabel.Size, creatorNameLabel.BackgroundColor3, creatorNameLabel.Text, creatorNameLabel.TextColor3, creatorNameLabel.Font, creatorNameLabel.TextSize = UDim2.new(1, -10, 0, 36), Color3.fromRGB(15,15,15), "| Frommytypp2 |", Color3.fromRGB(0, 255, 255), Enum.Font.Code, 15
    Instance.new("UICorner", creatorNameLabel)
    
    addMenuButton("Скопировать ник", Color3.fromRGB(30, 60, 35), function()
        if setclipboard then setclipboard("Frommytypp2") notify("Ник скопирован!") end
    end)
    
    addMenuButton("Скопировать тык", Color3.fromRGB(30, 45, 60), function()
        if setclipboard then setclipboard("Frommytypp2") notify("Тык скопирован!") end
    end)

    -- Декоративный разделитель для футера
    local separator = Instance.new("Frame", container)
    separator.Size, separator.BackgroundTransparency = UDim2.new(1, -10, 0, 10), 1

    -- Твой авторский блок в самом конце
    local textFooter = Instance.new("TextLabel", container)
    textFooter.Size, textFooter.BackgroundTransparency, textFooter.Text, textFooter.TextColor3, textFooter.Font, textFooter.TextSize, textFooter.TextWrapped = UDim2.new(1, -10, 0, 50), 1, "Это я создавал неделю Сам и у меня получилось! верьте в себя и все получится..", Color3.fromRGB(220, 220, 220), Enum.Font.GothamItalic, 13, true
    
    local textDmitry = Instance.new("TextLabel", container)
    textDmitry.Size, textDmitry.BackgroundTransparency, textDmitry.Text, textDmitry.TextColor3, textDmitry.Font, textDmitry.TextSize, textDmitry.TextAlignment = UDim2.new(1, -10, 0, 30), 1, "Dmitry", Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 16, Enum.TextXAlignment.Center
    
    local textPhoto = Instance.new("TextLabel", container)
    textPhoto.Size, textPhoto.BackgroundTransparency, textPhoto.Text, textPhoto.TextColor3, textPhoto.Font, textPhoto.TextSize = UDim2.new(1, -10, 0, 30), 1, "[Фото Frommytypp2]", Color3.fromRGB(0, 180, 255), Enum.Font.Code, 14
end

-- Создание панели навигации по вкладкам
local function buildTabLink(name, offset, action)
    local btn = Instance.new("TextButton", th)
    btn.Size, btn.Position, btn.Text, btn.BackgroundColor3, btn.TextColor3, btn.Font = UDim2.new(0.46, 0, 1, 0), UDim2.new(offset, 0, 0, 0), name, Color3.fromRGB(30,30,30), Color3.new(1,1,1), Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(action)
end
buildTabLink("ИГРА", 0.02, renderTab1)
buildTabLink("О КЛИЕНТЕ", 0.52, renderTab2)

-- Системные кнопки нижней панели управления
local hideBtn = addMenuButton("- СКРЫТЬ МЕНЮ", Color3.fromRGB(50,50,50), function() mf.Visible, pill.Visible = false, true end)
hideBtn.Parent, hideBtn.Size, hideBtn.Position = mf, UDim2.new(0, 130, 0, 36), UDim2.new(0.25, -65, 0.91, 0)

local destroyBtn = addMenuButton("X ЗАКРЫТЬ", Color3.fromRGB(150,30,30), function() sg:Destroy() end)
destroyBtn.Parent, destroyBtn.Size, destroyBtn.Position = mf, UDim2.new(0, 130, 0, 36), UDim2.new(0.75, -65, 0.91, 0)

-- Триггеры видимости интерфейса
openBtn.MouseButton1Click:Connect(function() mf.Visible, pill.Visible = true, false end)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mf.Visible or pill.Visible then
            mf.Visible, pill.Visible = false, false
        else
            mf.Visible = true
        end
    end
end)

-- Первая загрузка контента
renderTab1()
