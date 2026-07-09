local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local sg = Instance.new("ScreenGui", lp.PlayerGui)
sg.Name = "MM2_SUPREMACY_GODMODE_EDITION"
sg.ResetOnSpawn = false

local activeNotifications = {}
local currentTheme = "Радуга"
local themeMenuOpen = false
local shOpen, mdOpen, inOpen, espOpen, tpPlayerOpen = false, false, false, false, false
local espO, espBox, espLine, espDist, espGunDrop, espTraps = false, false, false, false, false, false
local flyO, noclO, jumpO, aimO, paniO, coinFarmO, autoEvadeO, killAuraO, fullBrightO, antiAfkO = false, false, false, false, false, false, false, false, false, true
local shootBtnVisible = false
local itemOrder = 0
local plat, oldC, bv, bg
local currentTabFunc = nil

-- ТЕМЫ И ИХ НАСТРОЙКИ (8 ШТУК)
local themes = {
    ["Радуга"] = {bg = Color3.fromRGB(8, 8, 8), border = "RGB"},
    ["Ne0n"] = {bg = Color3.fromRGB(10, 15, 20), border = Color3.fromHSV(0.5, 1, 1)},
    ["Желтая"] = {bg = Color3.fromRGB(20, 20, 10), border = Color3.fromRGB(255, 215, 0)},
    ["Темная"] = {bg = Color3.fromRGB(5, 5, 5), border = Color3.fromRGB(45, 45, 45)},
    ["Сакура"] = {bg = Color3.fromRGB(25, 15, 20), border = Color3.fromRGB(255, 105, 180)},
    ["Океан"] = {bg = Color3.fromRGB(10, 18, 28), border = Color3.fromRGB(0, 191, 255)},
    ["Изумруд"] = {bg = Color3.fromRGB(10, 25, 15), border = Color3.fromRGB(0, 255, 127)},
    ["Фиолетовая"] = {bg = Color3.fromRGB(18, 10, 25), border = Color3.fromRGB(148, 0, 211)}
}

local function applyRGB(obj)
    RunService.RenderStepped:Connect(function() obj.TextColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1) end)
end

-- СОЗДАНИЕ ОБЪЕКТОВ ИНТЕРФЕЙСА СРАЗУ
local mf = Instance.new("Frame", sg)
local border = Instance.new("Frame", mf)
local pill = Instance.new("Frame", sg)
local pillBorder = Instance.new("Frame", pill)

local floatGui = Instance.new("ScreenGui", sg)
floatGui.Name = "MM2_FLOAT_SHOOT"
floatGui.Enabled = shootBtnVisible

local floatBtn = Instance.new("TextButton", floatGui)
local fBorder = Instance.new("Frame", floatBtn)

-- ЕДИНЫЙ КОНТРОЛЛЕР ДИНАМИЧЕСКИХ ТЕМ
RunService.RenderStepped:Connect(function()
    local cfg = themes[currentTheme]
    if cfg then
        mf.BackgroundColor3 = cfg.bg
        pill.BackgroundColor3 = cfg.bg
        local clr = cfg.border == "RGB" and Color3.fromHSV(tick() % 6 / 6, 0.8, 0.8) or cfg.border
        border.BackgroundColor3 = clr
        pillBorder.BackgroundColor3 = clr
        fBorder.BackgroundColor3 = clr
    end
end)

local function notify(text)
    local n = Instance.new("Frame", sg)
    n.Size, n.Position, n.BackgroundColor3 = UDim2.new(0, 180, 0, 35), UDim2.new(1, 30, 0.75, 0), Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 6)
    
    local bnd = Instance.new("Frame", n)
    bnd.Size, bnd.Position, bnd.ZIndex = UDim2.new(1, 2, 1, 2), UDim2.new(0, -1, 0, -1), n.ZIndex - 1
    Instance.new("UICorner", bnd).CornerRadius = UDim.new(0, 6)
    RunService.RenderStepped:Connect(function() bnd.BackgroundColor3 = Color3.fromHSV(tick()%3/3, 1, 1) end)
    
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

-- ИНТРО АНИМАЦИЯ + АВТООТКРЫТИЕ МЕНЮ
local intro = Instance.new("TextLabel", sg)
intro.Size, intro.Position, intro.BackgroundTransparency, intro.Font, intro.TextSize = UDim2.new(0, 500, 0, 60), UDim2.new(0.5, -250, 0.45, 0), 1, Enum.Font.GothamBold, 45
applyRGB(intro)
task.spawn(function()
    local n = "dmitry258 mm2"
    for i = 1, #n do intro.Text = n:sub(1,i).."_" task.wait(0.06) end
    task.wait(0.8) 
    intro:Destroy() 
    notify("СИСТЕМА АКТИВИРОВАНА")
    mf.Visible = true
end)

-- НАСТРОЙКА ГЛАВНОГО ОКНА МЕНЮ
mf.Size, mf.Position, mf.Visible, mf.Active = UDim2.new(0, 450, 0, 440), UDim2.new(0.5, -225, 0.5, -220), false, true
Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 18)

border.Size, border.Position, border.ZIndex = UDim2.new(1, 4, 1, 4), UDim2.new(0, -2, 0, -2), mf.ZIndex - 1
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 18)

local function setupDrag(gui)
    local dS, dP, sP
    gui.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dS = true dP = i.Position sP = gui.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dP gui.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dS = false end end)
end
setupDrag(mf)

-- ТАБЛЕТКА СКРЫТИЯ
pill.Size, pill.Position, pill.BackgroundTransparency, pill.Visible = UDim2.new(0, 350, 0, 45), UDim2.new(0.5, -175, 0, 2), 0.2, false
Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
pillBorder.Size, pillBorder.Position, pillBorder.ZIndex = UDim2.new(1, 4, 1, 4), UDim2.new(0, -2, 0, -2), pill.ZIndex - 1
Instance.new("UICorner", pillBorder).CornerRadius = UDim.new(1, 0)

local pt = Instance.new("TextLabel", pill)
pt.Size, pt.Position, pt.BackgroundTransparency, pt.Font, pt.TextSize = UDim2.new(0.8, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), 1, Enum.Font.GothamBold, 15
pt.Text = "dmitry258 mm2 (СКРЫТО)"
applyRGB(pt)

local openBtn = Instance.new("TextButton", pill)
openBtn.Size, openBtn.Position, openBtn.Text, openBtn.BackgroundColor3, openBtn.TextColor3 = UDim2.new(0, 34, 0, 34), UDim2.new(0.88, 0, 0.5, -17), "▲", Color3.fromRGB(35,35,35), Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)

-- ТАЙМЕР И ЗАГОЛОВОК
local uBox = Instance.new("TextLabel", mf)
uBox.Size, uBox.Position, uBox.BackgroundColor3, uBox.BackgroundTransparency, uBox.TextColor3, uBox.Font, uBox.TextSize = UDim2.new(0, 90, 0, 28), UDim2.new(1, -100, 0, 12), Color3.new(0,0,0), 0.6, Color3.new(0, 1, 1), Enum.Font.Code, 15
Instance.new("UICorner", uBox)
local startT = tick()
RunService.RenderStepped:Connect(function() local e = tick() - startT uBox.Text = string.format("%02d:%02d", math.floor(e/60), math.floor(e%60)) end)

local title = Instance.new("TextLabel", mf)
title.Size, title.Position, title.BackgroundTransparency, title.Font, title.TextSize, title.Text = UDim2.new(0.7, 0, 0, 50), UDim2.new(0.1, 0, 0, 0), 1, Enum.Font.GothamBold, 20, "dmitry258 mm2"
applyRGB(title)

local container = Instance.new("ScrollingFrame", mf)
container.Size, container.Position, container.BackgroundTransparency, container.ScrollBarThickness, container.CanvasSize = UDim2.new(1, -20, 0.62, 0), UDim2.new(0, 10, 0.23, 0), 1, 2, UDim2.new(0,0,0,2500)
local layout = Instance.new("UIListLayout", container)
layout.Padding, layout.SortOrder = UDim.new(0, 8), Enum.SortOrder.LayoutOrder

local watermark = Instance.new("TextLabel", mf)
watermark.Size, watermark.Position, watermark.BackgroundTransparency, watermark.Font, watermark.TextSize, watermark.Text = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 1, -55), 1, Enum.Font.Code, 13, "Создатель описания: dmitry258 mm2"
applyRGB(watermark)

-- КНОПКА СТРЕЛЬБЫ
floatBtn.Size, floatBtn.Position, floatBtn.BackgroundColor3, floatBtn.Font, floatBtn.TextSize, floatBtn.TextColor3, floatBtn.Text = UDim2.new(0, 70, 0, 70), UDim2.new(1, -85, 0.5, -35), Color3.fromRGB(160, 30, 30), Enum.Font.GothamBold, 30, Color3.new(1,1,1), "🔫"
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
fBorder.Size, fBorder.Position, fBorder.ZIndex = UDim2.new(1, 4, 1, 4), UDim2.new(0, -2, 0, -2), floatBtn.ZIndex - 1
Instance.new("UICorner", fBorder).CornerRadius = UDim.new(1, 0)

-- ВЫСТРЕЛ В ТАЗ
local function executeSheriffShot()
    local tc = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
            tc = p.Character break
        end
    end
    if tc and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local targetPart = tc:FindFirstChild("LowerTorso") or tc:FindFirstChild("Torso") or tc:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local gun = lp.Character:FindFirstChild("Gun") or lp.Character:FindFirstChild("Revolver") or lp.Backpack:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Revolver")
            if gun then
                if gun.Parent == lp.Backpack then 
                    lp.Character.Humanoid:EquipTool(gun)
                    task.wait(0.15)
                end
                local oldCFrame = workspace.CurrentCamera.CFrame
                workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                task.wait(0.05)
                gun:Activate()
                task.wait(0.05)
                workspace.CurrentCamera.CFrame = oldCFrame
            else notify("Вы не шериф!") end
        else notify("Таз убийцы не найден!") end
    else notify("Убийца не найден!") end
end
floatBtn.MouseButton1Click:Connect(executeSheriffShot)

local activeLoops = {}
local function clear()
    for _, c in pairs(activeLoops) do c:Disconnect() end
    activeLoops = {}
    for _,v in pairs(container:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("ImageLabel") then v:Destroy() end end
    itemOrder = 0
end

local function bGen(txt, isOn, clr, cb)
    itemOrder = itemOrder + 1
    local b = Instance.new("TextButton", container)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.Font, b.LayoutOrder = UDim2.new(1, -10, 0, 42), clr or Color3.fromRGB(25,25,25), txt, Color3.new(1,1,1), Enum.Font.Gotham, itemOrder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    if isOn then
        local conn = RunService.RenderStepped:Connect(function() b.BackgroundColor3 = Color3.fromHSV(tick() % 4 / 4, 0.8, 0.5) end)
        table.insert(activeLoops, conn)
    end
    b.MouseButton1Click:Connect(cb) return b
end

local tab1, tab2, tab3, tab4

-- ВЫДЕЛЕННАЯ ФУНКЦИЯ ОБНОВЛЕНИЯ ИНТЕРФЕЙСА ПРИ НАЖАТИЯХ ТУМБЛЕРОВ
local function refreshCurrentTab()
    if currentTabFunc then currentTabFunc() end
end

-- ВКЛАДКА ИГРА
tab1 = function()
    currentTabFunc = tab1
    clear()
    bGen(shOpen and "Функции шерифа ▲" or "Функции шерифа ▼", false, Color3.fromRGB(45, 45, 80), function() shOpen = not shOpen tab1() end)
    if shOpen then
        bGen("Стрельнуть в убийцу", false, Color3.fromRGB(140, 30, 30), executeSheriffShot)
        bGen("АВТО-НАВОДКА НА УБИЙЦУ: " .. (aimO and "ВКЛ" or "ВЫКЛ"), aimO, Color3.fromRGB(35, 35, 55), function() aimO = not aimO tab1() end)
        bGen("ПОКАЗАТЬ КНОПКУ СТРЕЛЬБЫ: " .. (shootBtnVisible and "ВКЛ" or "ВЫКЛ"), shootBtnVisible, Color3.fromRGB(35, 35, 55), function()
            shootBtnVisible = not shootBtnVisible floatGui.Enabled = shootBtnVisible tab1()
        end)
    end
    
    bGen(mdOpen and "Функции убийцы ▲" or "Функции убийцы ▼", false, Color3.fromRGB(80, 45, 45), function() mdOpen = not mdOpen tab1() end)
    if mdOpen then
        bGen("УБИТЬ ВСЕХ (БЫСТРЫЙ КРУГ)", false, Color3.fromRGB(130, 30, 30), function()
            local kn = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if kn and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                if kn.Parent == lp.Backpack then kn.Parent = lp.Character end
                local myHrp = lp.Character.HumanoidRootPart
                local startPos = myHrp.CFrame
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                        task.wait(0.01) kn:Activate()
                    end
                end
                myHrp.CFrame = startPos notify("Матч зачищен!")
            else notify("Вы не убийца!") end
        end)
        bGen("КИЛЛАУРА (KILL AURA): " .. (killAuraO and "ВКЛ" or "ВЫКЛ"), killAuraO, Color3.fromRGB(110, 35, 35), function() killAuraO = not killAuraO tab1() end)
    end
    
    bGen(inOpen and "Функции невиновного ▲" or "Функции невиновного ▼", false, Color3.fromRGB(45, 80, 45), function() inOpen = not inOpen tab1() end)
    if inOpen then
        bGen("АВТО-ФАРМ МОНЕТ: " .. (coinFarmO and "ВКЛ" or "ВЫКЛ"), coinFarmO, Color3.fromRGB(45, 110, 45), function() coinFarmO = not coinFarmO tab1() end)
        bGen("АВТО-УКЛОНЕНИЕ ОТ МАНЬЯКА: " .. (autoEvadeO and "ВКЛ" or "ВЫКЛ"), autoEvadeO, Color3.fromRGB(35, 85, 35), function() autoEvadeO = not autoEvadeO tab1() end)
        bGen("СЕЙФ ЛОКАЦИЯ: " .. (paniO and "ВКЛ" or "ВЫКЛ"), paniO, Color3.fromRGB(35, 55, 35), function()
            paniO = not paniO local r = lp.Character.HumanoidRootPart
            if paniO then
                oldC = r.CFrame plat = Instance.new("Part", workspace)
                plat.Size, plat.Position, plat.Anchored, plat.Color, plat.Material = Vector3.new(60,1,60), Vector3.new(r.Position.X, 1500, r.Position.Z), true, Color3.new(0, 1, 1), Enum.Material.Neon
                r.CFrame = plat.CFrame + Vector3.new(0, 3, 0)
            else if plat then plat:Destroy() end if oldC then r.CFrame = oldC end end tab1()
        end)
        bGen("ПОЛЕТ (КНОПКА 'E'): " .. (flyO and "ВКЛ" or "ВЫКЛ"), flyO, Color3.fromRGB(35, 55, 35), function()
            flyO = not flyO
            if flyO then
                bv, bg = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart), Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
                bv.MaxForce, bg.MaxTorque = Vector3.new(1,1,1)*math.huge, Vector3.new(1,1,1)*math.huge
            else if bv then bv:Destroy() end if bg then bg:Destroy() end end tab1()
        end)
        bGen("СКВОЗЬ СТЕНЫ (NOCLIP): " .. (noclO and "ВКЛ" or "ВЫКЛ"), noclO, Color3.fromRGB(35, 55, 35), function() noclO = not noclO tab1() end)
        bGen("БЕСКОНЕЧНЫЙ ПРЫЖОК: " .. (jumpO and "ВКЛ" or "ВЫКЛ"), jumpO, Color3.fromRGB(35, 55, 35), function() jumpO = not jumpO tab1() end)
    end
    
    bGen(espOpen and "Функции ESP ▲" or "Функции ESP ▼", false, Color3.fromRGB(80, 80, 45), function() espOpen = not espOpen tab1() end)
    if espOpen then
        bGen("Обычный ESP игроков: " .. (espO and "ВКЛ" or "ВЫКЛ"), espO, Color3.fromRGB(55, 55, 35), function() espO = not espO tab1() end)
        bGen("В виде коробки (3D Box): " .. (espBox and "ВКЛ" or "ВЫКЛ"), espBox, Color3.fromRGB(55, 55, 35), function() espBox = not espBox tab1() end)
        bGen("Стрелки линии (Tracers): " .. (espLine and "ВКЛ" or "ВЫКЛ"), espLine, Color3.fromRGB(55, 55, 35), function() espLine = not espLine tab1() end)
        bGen("Показывать расстояние: " .. (espDist and "ВКЛ" or "ВЫКЛ"), espDist, Color3.fromRGB(55, 55, 35), function() espDist = not espDist tab1() end)
        bGen("ESP Выпавшей Пушки: " .. (espGunDrop and "ВКЛ" or "ВЫКЛ"), espGunDrop, Color3.fromRGB(75, 55, 25), function() espGunDrop = not espGunDrop tab1() end)
        bGen("ESP Ловушек маньяка: " .. (espTraps and "ВКЛ" or "ВЫКЛ"), espTraps, Color3.fromRGB(75, 55, 25), function() espTraps = not espTraps tab1() end)
    end
end

-- ВКЛАДКА НАСТРОЙКИ
tab2 = function()
    currentTabFunc = tab2
    clear()
    bGen(themeMenuOpen and "Выбор Темы ▲" or "Выбор Темы ▼", false, Color3.fromRGB(45, 45, 80), function() themeMenuOpen = not themeMenuOpen tab2() end)
    if themeMenuOpen then
        for name, _ in pairs(themes) do
            bGen(currentTheme == name and "(Выбрано) " .. name or name, false, Color3.fromRGB(35, 35, 35), function() currentTheme = name tab2() end)
        end
    end

    bGen("Освещение (FullBright): " .. (fullBrightO and "ВКЛ" or "ВЫКЛ"), fullBrightO, Color3.fromRGB(35, 65, 65), function() fullBrightO = not fullBrightO tab2() end)
    bGen("Анти-AFK (Защита от кика): " .. (antiAfkO and "ВКЛ" or "ВЫКЛ"), antiAfkO, Color3.fromRGB(35, 65, 65), function() antiAfkO = not antiAfkO tab2() end)

    local function ed(ph, cb)
        local e = Instance.new("TextBox", container) itemOrder = itemOrder + 1
        e.Size, e.BackgroundColor3, e.PlaceholderText, e.Text, e.TextColor3, e.Font, e.LayoutOrder = UDim2.new(1,-10,0,42), Color3.fromRGB(22,22,22), ph, "", Color3.new(1,1,1), Enum.Font.Gotham, itemOrder
        Instance.new("UICorner", e)
        e.FocusLost:Connect(function(en) if en then cb(tonumber(e.Text)) end end)
    end
    ed("СКОРОСТЬ (WalkSpeed)", function(v) if v and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end)
    ed("ПРЫЖОК (JumpPower)", function(v) if v and lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.JumpPower = v end end)
    ed("ГРАВИТАЦИЯ (Gravity)", function(v) if v then workspace.Gravity = v end end)
end

-- ВКЛАДКА ТЕЛЕПОРТЫ
tab4 = function()
    currentTabFunc = tab4
    clear()
    bGen(tpPlayerOpen and "Телепорт к игроку ▲" or "Телепорт к игроку ▼", false, Color3.fromRGB(45, 45, 80), function() tpPlayerOpen = not tpPlayerOpen tab4() end)
    if tpPlayerOpen then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then
                bGen("ТП к " .. p.Name, false, Color3.fromRGB(35, 35, 55), function()
                    if lp.Character and p.Character then
                        lp.Character:PivotTo(p.Character:GetPivot())
                    end
                end)
            end
        end
    end
    
    bGen("Телепорт к выпавшему пистолету", false, Color3.fromRGB(120, 60, 25), function()
        local gd = workspace:FindFirstChild("GunDrop")
        if gd and lp.Character then
            lp.Character:PivotTo(gd.CFrame + Vector3.new(0, 3, 0))
            notify("Подлетел к пистолету!")
        else notify("Пистолет ещё не выпал!") end
    end)

    bGen("Телепорт на локацию (Карта)", false, Color3.fromRGB(45, 60, 45), function()
        local map = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map") or workspace:FindFirstChild("Maps")
        if map and lp.Character then
            lp.Character:PivotTo(map:GetPivot() + Vector3.new(0, 6, 0))
            notify("Телепортировано на карту")
        else notify("Карта игры не найдена!") end
    end)
    
    bGen("Телепорт в Лобби", false, Color3.fromRGB(45, 60, 45), function()
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby and lp.Character then
            lp.Character:PivotTo(lobby:GetPivot() + Vector3.new(0, 6, 0))
            notify("Телепортировано в лобби")
        else notify("Лобби не найдено!") end
    end)
end

-- ВКЛАДКА О КЛИЕНТЕ
tab3 = function()
    currentTabFunc = tab3
    clear()
    bGen("СБРОСИТЬ ВСЕ НАСТРОЙКИ", false, Color3.fromRGB(130, 30, 30), function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed, lp.Character.Humanoid.JumpPower, workspace.Gravity = 16, 50, 196.2
        end
        espO, espBox, espLine, espDist, espGunDrop, espTraps = false, false, false, false, false, false
        flyO, noclO, jumpO, aimO, paniO, coinFarmO, autoEvadeO, killAuraO, fullBrightO = false, false, false, false, false, false, false, false, false
        if bv then bv:Destroy() end if bg then bg:Destroy() end
        if plat then plat:Destroy() end
        notify("Все настройки сброшены") tab1()
    end)

    itemOrder = itemOrder + 1
    local nl = Instance.new("TextLabel", container)
    nl.Size, nl.BackgroundColor3, nl.Text, nl.TextColor3, nl.Font, nl.TextSize, nl.LayoutOrder = UDim2.new(1, -10, 0, 24), Color3.fromRGB(15, 15, 15), "Ник создателя", Color3.new(1, 1, 1), Enum.Font.GothamBold, 13, itemOrder
    Instance.new("UICorner", nl)

    itemOrder = itemOrder + 1
    local nb = Instance.new("TextLabel", container)
    nb.Size, nb.BackgroundColor3, nb.Text, nb.TextColor3, nb.Font, nb.TextSize, nb.LayoutOrder = UDim2.new(1, -10, 0, 34), Color3.fromRGB(10, 10, 10), "| Frommytypp2 |", Color3.fromRGB(0, 235, 235), Enum.Font.Code, 15, itemOrder
    Instance.new("UICorner", nb)

    bGen("Скопировать тык", false, Color3.fromRGB(45, 75, 45), function()
        if setclipboard then setclipboard("Frommytypp2") elseif toclipboard then toclipboard("Frommytypp2") end notify("Ник скопирован!")
    end)
    
    itemOrder = itemOrder + 1
    local footer = Instance.new("TextLabel", container)
    footer.Size, footer.BackgroundTransparency, footer.Text, footer.TextColor3, footer.Font, footer.TextSize, footer.LayoutOrder = UDim2.new(1, -10, 0, 70), 1, "Это я создавал неделю Сам и у меня получилось! верьте в себя и все получится..\nDmitry", Color3.new(1, 1, 1), Enum.Font.GothamBold, 13, itemOrder
    footer.TextWrapped = true

    itemOrder = itemOrder + 1
    local img = Instance.new("ImageLabel", container)
    img.Size, img.BackgroundTransparency, img.Image, img.LayoutOrder = UDim2.new(0, 130, 0, 130), 1, "rbxassetid://0", itemOrder
end

-- НАВИГАЦИОННАЯ ПАНЕЛЬ
local th = Instance.new("Frame", mf)
th.Size, th.Position, th.BackgroundTransparency = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0.13, 0), 1
local function makeT(n, x, cb)
    local b = Instance.new("TextButton", th)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3, b.Font = UDim2.new(0.22,0,1,0), UDim2.new(x,0,0,0), n, Color3.fromRGB(32,32,32), Color3.new(1,1,1), Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
end
makeT("ИГРА", 0.02, tab1)
makeT("НАСТР", 0.26, tab2)
makeT("ТЕЛЕПОРТ", 0.50, tab4)
makeT("О КЛИЕНТЕ", 0.74, tab3)

-- РЕАЛТАЙМ ХАРТБИТ ЦИКЛ ДЛЯ ПОЛЕТА, ESP, КИЛЛАУРЫ И ЭВЕЙДА
RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local myHrp = lp.Character.HumanoidRootPart
    
    -- Цикл по игрокам (ESP + Киллаура + Уклонение)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character local hrp = char.HumanoidRootPart
            local m = char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")
            local s = char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
            local teamColor = m and Color3.new(1,0,0) or (s and Color3.new(0,0,1) or Color3.new(0,1,0))
            
            if espO then
                local h = char:FindFirstChild("ESP_SUP") or Instance.new("Highlight", char)
                h.Name = "ESP_SUP" h.FillColor = teamColor h.FillTransparency = 0.5
                h.OutlineColor = Color3.new(1,1,1) h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop h.Enabled = true
            else if char:FindFirstChild("ESP_SUP") then char.ESP_SUP:Destroy() end end
            
            if espBox then
                local box = char:FindFirstChild("BOX_SUP") or Instance.new("BoxHandleAdornment", char)
                box.Name = "BOX_SUP" box.Adornee = hrp box.Size = char:GetExtentsSize()
                box.Color3 = teamColor box.AlwaysOnTop = true box.ZIndex = 10 box.Transparency = 0.6
            else if char:FindFirstChild("BOX_SUP") then char.BOX_SUP:Destroy() end end
            
            if espDist then
                local tag = char.Head:FindFirstChild("TAG_SUP") or Instance.new("BillboardGui", char.Head)
                tag.Name = "TAG_SUP" tag.Size, tag.AlwaysOnTop, tag.StudsOffset = UDim2.new(0, 150, 0, 60), true, Vector3.new(0, 3.5, 0)
                local l = tag:FindFirstChild("L_SUP") or Instance.new("TextLabel", tag)
                l.Name = "L_SUP" l.Size, l.BackgroundTransparency, l.TextSize, l.Font = UDim2.new(1, 0, 1, 0), 1, 14, Enum.Font.GothamBold
                l.Text = string.format("%s\n[%s]\n%d Метров", p.Name, (m and "МАНЬЯК" or (s and "ШЕРИФ" or "МИРНЫЙ")), math.floor((myHrp.Position - hrp.Position).Magnitude))
                l.TextColor3 = teamColor tag.Enabled = true
            else if char.Head:FindFirstChild("TAG_SUP") then char.Head.TAG_SUP:Destroy() end end
            
            if espLine then
                local line = char:FindFirstChild("LINE_SUP") or Instance.new("LineHandleAdornment")
                line.Name = "LINE_SUP" line.AlwaysOnTop, line.ZIndex, line.Color3, line.Thickness = true, 10, teamColor, 2.5
                line.Adornee = workspace.Terrain line.Length = (myHrp.Position - hrp.Position).Magnitude
                line.CFrame = CFrame.lookAt(myHrp.Position, hrp.Position) line.Parent = char
            else if char:FindFirstChild("LINE_SUP") then char.LINE_SUP:Destroy() end end

            -- АВТО-УКЛОНЕНИЕ ОТ МАНЬЯКА
            if autoEvadeO and m then
                local d = (myHrp.Position - hrp.Position).Magnitude
                if d < 25 then
                    lp.Character:PivotTo(myHrp.CFrame * CFrame.new(0, 45, 0))
                    notify("Маньяк близко! Побег вверх!")
                end
            end

            -- КИЛЛАУРА (ДЛЯ МАНЬЯКА)
            if killAuraO then
                local kn = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
                if kn then
                    if kn.Parent == lp.Backpack then kn.Parent = lp.Character end
                    local d = (myHrp.Position - hrp.Position).Magnitude
                    if d < 15 then kn:Activate() end
                end
            end
        end
    end

    -- ESP НА ВЫПАВШИЙ ПИСТОЛЕТ И ЛОВУШКИ
    local gd = workspace:FindFirstChild("GunDrop")
    if gd and gd:IsA("BasePart") then
        if espGunDrop then
            local h = gd:FindFirstChild("G_ESP") or Instance.new("BoxHandleAdornment", gd)
            h.Name = "G_ESP" h.Adornee = gd h.Size = gd.Size * 1.5 h.Color3 = Color3.fromRGB(0, 191, 255)
            h.AlwaysOnTop, h.ZIndex, h.Transparency = true, 11, 0.4
        else if gd:FindFirstChild("G_ESP") then gd.G_ESP:Destroy() end end
    end

    if espTraps then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Trap" and v:IsA("BasePart") then
                local h = v:FindFirstChild("T_ESP") or Instance.new("BoxHandleAdornment", v)
                h.Name = "T_ESP" h.Adornee = v h.Size = v.Size * 1.2 h.Color3 = Color3.fromRGB(255, 69, 0)
                h.AlwaysOnTop, h.ZIndex, h.Transparency = true, 11, 0.3
            end
        end
    end
end)

-- НЕОСЯЗАЕМЫЙ АВТО-ФАРМ МОНЕТ
task.spawn(function()
    while task.wait(0.3) do
        if coinFarmO and lp.Character then
            local mContainer = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map") or workspace:FindFirstChild("Maps")
            if mContainer then
                for _, v in pairs(mContainer:GetDescendants()) do
                    if (v.Name == "Coin" or v.Name == "Snowflake" or v.Name == "CandyCane") and v:IsA("BasePart") and v.Transparency == 0 then
                        if not coinFarmO then break end
                        lp.Character:PivotTo(v.CFrame)
                        task.wait(0.4)
                    end
                end
            end
        end
    end
end)

-- РАБОТА ПОЛЕТА, ФУЛБРАЙТА И АВТОНАВОДКИ
RunService.RenderStepped:Connect(function()
    if flyO and lp.Character and bv and bg then
        local h = lp.Character:FindFirstChildOfClass("Humanoid")
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if h and hrp then
            bg.CFrame = workspace.CurrentCamera.CFrame local moveDir = h.MoveDirection
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
    if fullBrightO then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        game:GetService("Lighting").Brightness = 2
    end
end)

-- ХОТКЕЙ 'E' ДЛЯ ПОЛЕТА (ПЕРЕКЛЮЧЕНИЕ С КЛАВИАТУРЫ)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        flyO = not flyO
        notify("Полёт (Клавиша E): " .. (flyO and "ВКЛ" or "ВЫКЛ"))
        if flyO then
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                bv, bg = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart), Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
                bv.MaxForce, bg.MaxTorque = Vector3.new(1,1,1)*math.huge, Vector3.new(1,1,1)*math.huge
            end
        else
            if bv then bv:Destroy() end if bg then bg:Destroy() end
        end
        refreshCurrentTab()
    end
end)

-- ИСПРАВЛЕННЫЙ УМНЫЙ NOCLIP (БОЛЬШЕ НЕ КАМЕНЕЕТ)
RunService.Stepped:Connect(function()
    if noclO and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide = false end 
        end
    end
end)

-- АНТИ-AFK АКТИВАЦИЯ
local vu = game:GetService("VirtualUser")
lp.Idled:Connect(function()
    if antiAfkO then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

UserInputService.JumpRequest:Connect(function() if jumpO and lp.Character:FindFirstChildOfClass("Humanoid") then lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- УПРАВЛЕНИЕ МЕНЮ (СКРЫТЬ/ЗАКРЫТЬ)
local hb = bGen("- СКРЫТЬ МЕНЮ", false, Color3.fromRGB(60,60,60), function() mf.Visible, pill.Visible = false, true end)
hb.Parent, hb.Size, hb.Position = mf, UDim2.new(0, 140, 0, 38), UDim2.new(0.25, -70, 0.9, 0)
local cb = bGen("X ЗАКРЫТЬ МЕНЮ", false, Color3.fromRGB(180,35,35), function() sg:Destroy() floatGui:Destroy() end)
cb.Parent, cb.Size, cb.Position = mf, UDim2.new(0, 140, 0, 38), UDim2.new(0.75, -70, 0.9, 0)

openBtn.MouseButton1Click:Connect(function() mf.Visible, pill.Visible = true, false end)
UserInputService.InputBegan:Connect(function(i) 
    if i.KeyCode == Enum.KeyCode.RightControl then 
        if mf.Visible or pill.Visible then 
            mf.Visible, pill.Visible = false, false 
        else 
            mf.Visible = true 
        end 
    end 
end)

tab1()
