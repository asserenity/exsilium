local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()

if _G.NeverloseLoaded then return end
_G.NeverloseLoaded = true

local isRunning = false
local mainCodeLoaded = false

local Translations = {
    en = {
        ["language"] = "Language",
        ["section_main"] = "Main",
        ["section_checks"] = "Checks",
        ["section_fov"] = "FOV",
        ["section_extra_combat"] = "Extra",
        ["combat_main_enable"] = "Enable",
        ["combat_main_target_role"] = "Target (role)",
        ["combat_main_target_part"] = "Target Part",
        ["combat_checks_team_check"] = "Team Check (backup)",
        ["combat_checks_visible_check"] = "Visibility Check",
        ["combat_fov_radius"] = "Radius",
        ["combat_fov_show_circle"] = "Show Circle",
        ["combat_extra_hit_chance"] = "Hit Chance",
        ["combat_extra_show_target"] = "Show Target",
        ["combat_extra_prediction"] = "Prediction (horizontal)",
        ["section_core"] = "Core",
        ["section_distance"] = "Distance",
        ["section_misc"] = "Misc",
        ["section_colors"] = "Colors",
        ["section_extra_vis"] = "Extra",
        ["core_enable_esp"] = "Enable ESP",
        ["core_show_boxes"] = "Show Boxes",
        ["core_show_text"] = "Show Text",
        ["core_show_tracers"] = "Show Tracers",
        ["core_show_gun"] = "Show Gun ESP",
        ["distance_max_distance"] = "Max Distance",
        ["misc_text_size"] = "Text Size",
        ["misc_box_thickness"] = "Box Thickness",
        ["colors_murderer"] = "Murderer Color",
        ["colors_sheriff"] = "Sheriff Color",
        ["colors_innocent"] = "Innocent Color",
        ["colors_gun"] = "Gun Color",
        ["extra_only_murderer"] = "Only Murderer (for Sheriff)",
        ["section_teleports"] = "Teleports",
        ["section_speed"] = "Speed",
        ["movement_tp_murderer"] = "TP to Murderer",
        ["movement_tp_sheriff"] = "TP to Sheriff",
        ["movement_tp_gun"] = "TP to Gun",
        ["movement_walkspeed"] = "Walk Speed",
        ["section_unload"] = "Emergency",
        ["misc_unload"] = "⚠ Unload script",
        ["section_fake"] = "Fake Items",
        ["fake_korblox"] = "Korblox",
        ["fake_headless"] = "Headless",
        ["anti_fling"] = "Anti-Fling",
    },
    ru = {
        ["language"] = "Язык",
        ["section_main"] = "Основное",
        ["section_checks"] = "Проверки",
        ["section_fov"] = "Поле зрения",
        ["section_extra_combat"] = "Дополнительно",
        ["combat_main_enable"] = "Включить",
        ["combat_main_target_role"] = "Цель (роль)",
        ["combat_main_target_part"] = "Часть тела",
        ["combat_checks_team_check"] = "Команда (запасной)",
        ["combat_checks_visible_check"] = "Видимость",
        ["combat_fov_radius"] = "Радиус",
        ["combat_fov_show_circle"] = "Показ. круг",
        ["combat_extra_hit_chance"] = "Шанс попадания",
        ["combat_extra_show_target"] = "Индикатор цели",
        ["combat_extra_prediction"] = "Предсказание (гориз.)",
        ["section_core"] = "Ядро",
        ["section_distance"] = "Дистанция",
        ["section_misc"] = "Разное",
        ["section_colors"] = "Цвета",
        ["section_extra_vis"] = "Дополнительно",
        ["core_enable_esp"] = "Включить ESP",
        ["core_show_boxes"] = "Показать боксы",
        ["core_show_text"] = "Показать текст",
        ["core_show_tracers"] = "Показать трассеры",
        ["core_show_gun"] = "Показать пистолет",
        ["distance_max_distance"] = "Макс. дистанция",
        ["misc_text_size"] = "Размер текста",
        ["misc_box_thickness"] = "Толщина бокса",
        ["colors_murderer"] = "Цвет убийцы",
        ["colors_sheriff"] = "Цвет шерифа",
        ["colors_innocent"] = "Цвет невиновного",
        ["colors_gun"] = "Цвет пистолета",
        ["extra_only_murderer"] = "Только убийца (для шерифа)",
        ["section_teleports"] = "Телепорты",
        ["section_speed"] = "Скорость",
        ["movement_tp_murderer"] = "TP к убийце",
        ["movement_tp_sheriff"] = "TP к шерифу",
        ["movement_tp_gun"] = "TP к оружию",
        ["movement_walkspeed"] = "Скорость бега",
        ["section_unload"] = "Экстренно",
        ["misc_unload"] = "⚠ Выгрузить скрипт",
        ["section_fake"] = "Фейк-предметы",
        ["fake_korblox"] = "Korblox",
        ["fake_headless"] = "Headless",
        ["anti_fling"] = "Анти-флинг",
    }
}

local Settings = {
    Enabled = false,
    TargetPart = "HumanoidRootPart",
    TargetRole = "All",
    TeamCheck = false,
    VisibleCheck = false,
    HitChance = 100,
    FOVRadius = 130,
    FOVVisible = false,
    ShowTarget = false,
    Prediction = 0.12,

    ESP_Enabled = false,
    ESP_ShowBoxes = true,
    ESP_ShowText = true,
    ESP_ShowTracers = false,
    ESP_ShowGun = true,
    ESP_MaxDistance = 1500,
    ESP_TextSize = 14,
    ESP_BoxThickness = 1.5,
    ESP_ColorMurderer = Color3.fromRGB(255, 0, 0),
    ESP_ColorSheriff = Color3.fromRGB(0, 0, 255),
    ESP_ColorInnocent = Color3.fromRGB(0, 255, 0),
    ESP_ColorGun = Color3.fromRGB(255, 255, 0),
    ESP_OnlyMurderer = false,

    Language = "en",
}

local function getText(key)
    local lang = Settings.Language or "en"
    local dict = Translations[lang]
    if dict and dict[key] ~= nil then
        return dict[key]
    end
    return key
end

local uiLabels = {}
local uiSectionLabels = {}
local uiButtons = {}

local function registerLabel(key, label)
    if label then
        uiLabels[key] = label
    end
end

local function registerSectionLabel(key, label)
    if label then
        uiSectionLabels[key] = label
    end
end

local function registerButton(key, button)
    if button then
        uiButtons[key] = button
    end
end

local function updateUI()
    if not isRunning then return end
    for key, label in pairs(uiLabels) do
        if label and type(label.SetText) == "function" then
            pcall(function() label:SetText(getText(key)) end)
        end
    end
    for key, label in pairs(uiSectionLabels) do
        if label and type(label) == "table" and label.Text ~= nil then
            pcall(function() label.Text = getText(key) end)
        end
    end
    for key, button in pairs(uiButtons) do
        if button and type(button.SetText) == "function" then
            pcall(function() button:SetText(getText(key)) end)
        end
    end
end

local function addSection(tab, nameKey, position)
    local sec = tab:AddSection({ Name = getText(nameKey), Position = position or "left" })
    local label = nil
    if sec.Root then
        for _, child in ipairs(sec.Root:GetChildren()) do
            if child:IsA("TextLabel") then
                label = child
                break
            end
        end
    end
    if label then
        registerSectionLabel(nameKey, label)
    end
    return sec
end

local function startMain()
    if mainCodeLoaded then return end
    mainCodeLoaded = true
    isRunning = true

    -- Полная очистка при старте
    if _G.NeverloseESPObjects then
        for _, data in pairs(_G.NeverloseESPObjects) do
            for _, obj in pairs(data) do
                pcall(function() obj:Remove() end)
            end
        end
        _G.NeverloseESPObjects = nil
    end
    _G.NeverloseESPObjects = {}
    local espCache = _G.NeverloseESPObjects

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local GetPlayers = Players.GetPlayers
    local WorldToScreen = Camera.WorldToScreenPoint
    local WorldToViewportPoint = Camera.WorldToViewportPoint
    local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
    local FindFirstChild = game.FindFirstChild
    local GetMouseLocation = UserInputService.GetMouseLocation

    local mouseBox = Drawing.new("Square")
    mouseBox.Visible = false
    mouseBox.ZIndex = 999
    mouseBox.Color = Color3.fromRGB(54, 57, 241)
    mouseBox.Thickness = 20
    mouseBox.Size = Vector2.new(20, 20)
    mouseBox.Filled = true

    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.NumSides = 100
    fovCircle.Radius = 130
    fovCircle.Filled = false
    fovCircle.Visible = false
    fovCircle.ZIndex = 999
    fovCircle.Transparency = 1
    fovCircle.Color = Color3.fromRGB(54, 57, 241)

    -- ========== СОЗДАНИЕ GUI ДЛЯ ИКОНКИ ПИСТОЛЕТА ==========
    local gunIconGui = Instance.new("ScreenGui")
    gunIconGui.Name = "GunIconGUI"
    gunIconGui.IgnoreGuiInset = true
    gunIconGui.ResetOnSpawn = false
    gunIconGui.Parent = game:GetService("CoreGui")

    local gunIcon = Instance.new("ImageLabel")
    gunIcon.Name = "GunIcon"
    gunIcon.Size = UDim2.new(0, 40, 0, 40)
    gunIcon.BackgroundTransparency = 1
    gunIcon.Visible = false
    gunIcon.ZIndex = 999
    gunIcon.ImageColor3 = Settings.ESP_ColorGun
    gunIcon.Parent = gunIconGui

    local gunTextFallback = Instance.new("TextLabel")
    gunTextFallback.Name = "GunTextFallback"
    gunTextFallback.Size = UDim2.new(0, 50, 0, 30)
    gunTextFallback.BackgroundTransparency = 1
    gunTextFallback.Text = "🔫"
    gunTextFallback.TextSize = 24
    gunTextFallback.TextColor3 = Settings.ESP_ColorGun
    gunTextFallback.Font = Enum.Font.GothamBold
    gunTextFallback.Visible = false
    gunTextFallback.ZIndex = 999
    gunTextFallback.Parent = gunIconGui

    local function updateGunColor(color)
        gunIcon.ImageColor3 = color
        gunTextFallback.TextColor3 = color
        Settings.ESP_ColorGun = color
    end

    local gunImagePath = "C:\\Users\\egork\\AppData\\Local\\Madium\\Workspace\\NLAssets\\rev.png"
    if isfile and isfile(gunImagePath) then
        gunIcon.Image = getcustomasset(gunImagePath)
    else
        gunIcon.Image = "https://raw.githubusercontent.com/asserenity/exsilium/main/rev.png"
        print("[Gun] Локальная иконка не найдена, используется GitHub-ссылка")
    end

    gunIcon:GetPropertyChangedSignal("Image"):Connect(function()
        if gunIcon.Image ~= "" and gunIcon.Image ~= "rbxasset://textures/ui/Placeholder.png" then
            gunTextFallback.Visible = false
        end
    end)

    local connections = {}
    local function addConnection(conn)
        table.insert(connections, conn)
        return conn
    end

    -- ====== ДИНАМИЧЕСКОЕ ОБНОВЛЕНИЕ РОЛЕЙ ======
    local roleCache = {}
    local roleCacheValid = false

    local function normalizeRole(raw)
        local r = tostring(raw):gsub("^%s*(.-)%s*$", "%1")
        local lower = r:lower()
        if lower == "murderer" then return "Murderer"
        elseif lower == "sheriff" or lower == "hero" then return "Sheriff"
        elseif lower == "innocent" then return "Innocent"
        else return "Unknown" end
    end

    local function updateRoles(data)
        if not data or next(data) == nil then
            roleCacheValid = false
            return
        end
        local newCache = {}
        for name, info in pairs(data) do
            newCache[name] = {
                UserId = info.UserId,
                Role = normalizeRole(info.Role),
                Dead = info.Dead,
                Killed = info.Killed,
            }
        end
        roleCache = newCache
        roleCacheValid = true
    end

    local function onPlayerDataChanged(data)
        if not isRunning then return end
        updateRoles(data)
    end

    local playerDataChangedEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("PlayerDataChanged")
    addConnection(playerDataChangedEvent.OnClientEvent:Connect(onPlayerDataChanged))

    local function onRoundStart(_, data)
        if not isRunning then return end
        updateRoles(data)
    end

    local roundStartEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("RoundStart")
    addConnection(roundStartEvent.OnClientEvent:Connect(onRoundStart))

    local currentRoundClient = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CurrentRoundClient"))
    task.spawn(function()
        while isRunning do
            task.wait(0.5)
            if not roleCacheValid then
                local data = currentRoundClient.GetLatestPlayerData()
                if data and next(data) ~= nil then
                    updateRoles(data)
                end
            end
        end
    end)

    local function onPlayerAdded()
        if not isRunning then return end
        local data = currentRoundClient.GetLatestPlayerData()
        if data and next(data) ~= nil then
            updateRoles(data)
        end
    end
    addConnection(Players.PlayerAdded:Connect(onPlayerAdded))

    local function getRole(player)
        if player == LocalPlayer then return "Local" end
        local data = roleCache[player.Name]
        if data then
            if data.Dead then
                return "Dead"
            end
            return data.Role
        end
        return "Unknown"
    end

    local function findPlayerByRole(role)
        for name, data in pairs(roleCache) do
            if data.Dead then continue end
            if data.Role == role then
                local plr = Players:FindFirstChild(name)
                if plr and plr.Character then return plr end
            end
        end
        return nil
    end

    -- ====== КЕШИРОВАННЫЙ ПОИСК ПИСТОЛЕТА ======
    local gunCache = nil
    local gunCacheTime = 0
    local GUN_SEARCH_INTERVAL = 1

    local function findDroppedGun()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                return obj
            end
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower():find("gun") then
                local parent = obj.Parent
                if parent == workspace or (parent and parent:IsA("Folder")) then
                    return obj
                end
            end
        end
        return nil
    end

    local function getCachedGun()
        local now = tick()
        if now - gunCacheTime > GUN_SEARCH_INTERVAL then
            gunCache = findDroppedGun()
            gunCacheTime = now
        end
        return gunCache
    end

    local function teleportToPart(part)
        if not part then return end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local pos
            if part:IsA("BasePart") then
                pos = part.Position
            elseif part:IsA("Tool") then
                local handle = part:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    pos = handle.Position
                else
                    pos = part:GetPivot().Position
                end
            elseif part:IsA("Model") then
                local primary = part.PrimaryPart
                pos = primary and primary.Position or part:GetPivot().Position
            else
                return
            end
            root.CFrame = CFrame.new(pos) * CFrame.new(0, 2, 0)
        end
    end

    local function teleportTo(target)
        if not target or not target.Character then return end
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        if root then
            teleportToPart(root)
        end
    end

    local function onScreen(pos)
        local vec, on = WorldToScreen(Camera, pos)
        return Vector2.new(vec.X, vec.Y), on
    end

    local function mousePos()
        return GetMouseLocation(UserInputService)
    end

    local function isVisible(plr)
        local char = plr.Character
        local lchar = LocalPlayer.Character
        if not (char and lchar) then return false end
        local root = FindFirstChild(char, Settings.TargetPart) or FindFirstChild(char, "HumanoidRootPart")
        if not root then return false end
        local ignore = {lchar, char}
        local obs = #GetPartsObscuringTarget(Camera, {root.Position, lchar, char}, ignore)
        return obs == 0
    end

    local function getClosestTarget()
        if not Settings.TargetPart then return nil end
        local myRoleFromCache = roleCache[LocalPlayer.Name]
        local myRoleStr = myRoleFromCache and myRoleFromCache.Role or "Unknown"

        local best, bestDist = nil, nil
        for _, plr in ipairs(GetPlayers(Players)) do
            if plr == LocalPlayer then continue end

            local data = roleCache[plr.Name]
            if data and data.Dead then continue end

            if Settings.TargetRole ~= "All" then
                local targetRole = getRole(plr)
                if Settings.TargetRole == "Murderer" and targetRole ~= "Murderer" then continue end
                if Settings.TargetRole == "Sheriff" and targetRole ~= "Sheriff" then continue end
            end

            local targetRole = getRole(plr)
            if myRoleStr == "Murderer" then
                -- can target anyone
            elseif myRoleStr == "Sheriff" or myRoleStr == "Innocent" then
                if targetRole ~= "Murderer" then
                    continue
                end
            else
                if Settings.TeamCheck and plr.Team == LocalPlayer.Team then
                    continue
                end
            end

            local char = plr.Character
            if not char then continue end
            if Settings.VisibleCheck and not isVisible(plr) then continue end
            local root = FindFirstChild(char, "HumanoidRootPart")
            local hum = FindFirstChild(char, "Humanoid")
            if not root or not hum or hum.Health <= 0 then continue end
            local screenPos, on = onScreen(root.Position)
            if not on then continue end
            local dist = (mousePos() - screenPos).Magnitude
            if dist <= (bestDist or Settings.FOVRadius) then
                local part = char[Settings.TargetPart] or char["HumanoidRootPart"]
                if part then
                    best = part
                    bestDist = dist
                end
            end
        end
        return best
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        if isRunning and Settings.Enabled and args[1] == workspace and method == "Raycast" and not checkcaller() then
            if math.random(1, 100) <= Settings.HitChance then
                local targetPart = getClosestTarget()
                if targetPart then
                    local origin = args[2]
                    local originalDir = args[3]
                    local length = originalDir.Magnitude

                    local velocity = targetPart.AssemblyLinearVelocity
                    if velocity.Magnitude == 0 and targetPart.Velocity then
                        velocity = targetPart.Velocity
                    end

                    local horizVelocity = Vector3.new(velocity.X, 0, velocity.Z)
                    local predictedPos = Vector3.new(
                        targetPart.Position.X + horizVelocity.X * Settings.Prediction,
                        targetPart.Position.Y,
                        targetPart.Position.Z + horizVelocity.Z * Settings.Prediction
                    )

                    local newDir = (predictedPos - origin).Unit * length
                    args[3] = newDir

                    return oldNamecall(unpack(args))
                end
            end
        end
        return oldNamecall(...)
    end))

    local Window = NeverLose:CreateWindow({
        Logo = NeverLose.GlobalLogo,
        Name = "exsilium",
        Content = "by @fadepotion",
        Size = NeverLose.Scales.Default,
        ConfigFolder = "esiliumcfg",
        Keybind = "Insert"
    })

    -- Загружаем иконки NeverLose
    NeverLose:LoadIcon()

    local wm = Window:Watermark()
    local fpsBlock = wm:AddBlock("clock", "FPS: 0")
    local pingBlock = wm:AddBlock("chart-four-vertical-bars", "PING: 0")

    local fpsCounter = 0
    local currentFPS = 0
    addConnection(RunService.RenderStepped:Connect(function()
        if not isRunning then return end
        fpsCounter = fpsCounter + 1
    end))

    task.spawn(function()
        while isRunning do
            task.wait(1)
            currentFPS = fpsCounter
            fpsCounter = 0
            fpsBlock:SetText(currentFPS .. " FPS")
            pingBlock:SetText(tostring(math.floor(LocalPlayer:GetNetworkPing() * 1000)) .. "MS")
        end
    end)

    local userSettingsWindow = Window.UserSettings
    if userSettingsWindow then
        local langLabel = userSettingsWindow:AddLabel(getText("language"), false)
        registerLabel("language", langLabel)
        local langDropdown = langLabel:AddDropdown({
            Default = (Settings.Language == "en" and "English") or "Русский",
            Values = {"English", "Русский"},
            Flag = "UILanguage",
            Callback = function(v)
                if not isRunning then return end
                local newLang = (v == "English" and "en") or "ru"
                if Settings.Language ~= newLang then
                    Settings.Language = newLang
                    updateUI()
                end
            end
        })
    end

    local combatTab = Window:AddTab({ Icon = "crosshairs", Name = "Combat" })

    local mainSec = addSection(combatTab, "section_main")
    local row = mainSec:AddLabel(getText("combat_main_enable"), false)
    registerLabel("combat_main_enable", row)
    row:AddToggle({
        Default = false,
        Flag = "Aim_Enabled",
        Callback = function(v)
            Settings.Enabled = v
            mouseBox.Visible = v and Settings.ShowTarget
            fovCircle.Visible = v and Settings.FOVVisible
        end
    })

    row = mainSec:AddLabel(getText("combat_main_target_role"), false)
    registerLabel("combat_main_target_role", row)
    row:AddDropdown({
        Default = Settings.TargetRole,
        Values = {"All", "Murderer", "Sheriff"},
        Flag = "TargetRole",
        Callback = function(v) Settings.TargetRole = v end
    })

    row = mainSec:AddLabel(getText("combat_main_target_part"), false)
    registerLabel("combat_main_target_part", row)
    row:AddDropdown({
        Default = Settings.TargetPart,
        Values = {"Head", "HumanoidRootPart"},
        Flag = "TargetPart",
        Callback = function(v) Settings.TargetPart = v end
    })

    local checkSec = addSection(combatTab, "section_checks")
    row = checkSec:AddLabel(getText("combat_checks_team_check"), false)
    registerLabel("combat_checks_team_check", row)
    row:AddToggle({
        Default = false,
        Flag = "TeamCheck",
        Callback = function(v) Settings.TeamCheck = v end
    })

    row = checkSec:AddLabel(getText("combat_checks_visible_check"), false)
    registerLabel("combat_checks_visible_check", row)
    row:AddToggle({
        Default = false,
        Flag = "VisibleCheck",
        Callback = function(v) Settings.VisibleCheck = v end
    })

    local fovSec = addSection(combatTab, "section_fov")
    row = fovSec:AddLabel(getText("combat_fov_radius"), false)
    registerLabel("combat_fov_radius", row)
    row:AddSlider({
        Default = Settings.FOVRadius,
        Min = 0,
        Max = 360,
        Type = "",
        Size = 90,
        Flag = "FOVRadius",
        Callback = function(v)
            Settings.FOVRadius = v
            fovCircle.Radius = v
        end
    })

    row = fovSec:AddLabel(getText("combat_fov_show_circle"), false)
    registerLabel("combat_fov_show_circle", row)
    row:AddToggle({
        Default = false,
        Flag = "FOVVisible",
        Callback = function(v)
            Settings.FOVVisible = v
            fovCircle.Visible = v and Settings.Enabled
        end
    })

    local extraSec = addSection(combatTab, "section_extra_combat")
    row = extraSec:AddLabel(getText("combat_extra_hit_chance"), false)
    registerLabel("combat_extra_hit_chance", row)
    row:AddSlider({
        Default = 100,
        Min = 0,
        Max = 100,
        Type = "%",
        Size = 90,
        Flag = "HitChance",
        Callback = function(v) Settings.HitChance = v end
    })

    row = extraSec:AddLabel(getText("combat_extra_show_target"), false)
    registerLabel("combat_extra_show_target", row)
    row:AddToggle({
        Default = false,
        Flag = "ShowTarget",
        Callback = function(v)
            Settings.ShowTarget = v
            mouseBox.Visible = v and Settings.Enabled
        end
    })

    row = extraSec:AddLabel(getText("combat_extra_prediction"), false)
    registerLabel("combat_extra_prediction", row)
    row:AddSlider({
        Default = Settings.Prediction,
        Min = 0,
        Max = 0.5,
        Type = "s",
        Size = 90,
        Rounding = 3,
        Flag = "Prediction",
        Callback = function(v) Settings.Prediction = v end
    })

    local visTab = Window:AddTab({ Icon = "eye", Name = "Visuals", Type = "Double" })

    local coreSec = addSection(visTab, "section_core", "left")
    row = coreSec:AddLabel(getText("core_enable_esp"), false)
    registerLabel("core_enable_esp", row)
    row:AddToggle({
        Default = false,
        Flag = "ESP_Enabled",
        Callback = function(v) Settings.ESP_Enabled = v end
    })

    row = coreSec:AddLabel(getText("core_show_boxes"), false)
    registerLabel("core_show_boxes", row)
    row:AddToggle({
        Default = true,
        Flag = "ESP_ShowBoxes",
        Callback = function(v) Settings.ESP_ShowBoxes = v end
    })

    row = coreSec:AddLabel(getText("core_show_text"), false)
    registerLabel("core_show_text", row)
    row:AddToggle({
        Default = true,
        Flag = "ESP_ShowText",
        Callback = function(v) Settings.ESP_ShowText = v end
    })

    row = coreSec:AddLabel(getText("core_show_tracers"), false)
    registerLabel("core_show_tracers", row)
    row:AddToggle({
        Default = false,
        Flag = "ESP_ShowTracers",
        Callback = function(v) Settings.ESP_ShowTracers = v end
    })

    row = coreSec:AddLabel(getText("core_show_gun"), false)
    registerLabel("core_show_gun", row)
    row:AddToggle({
        Default = true,
        Flag = "ESP_ShowGun",
        Callback = function(v) Settings.ESP_ShowGun = v end
    })

    local distSec = addSection(visTab, "section_distance", "left")
    row = distSec:AddLabel(getText("distance_max_distance"), false)
    registerLabel("distance_max_distance", row)
    row:AddSlider({
        Default = 1500,
        Min = 100,
        Max = 5000,
        Type = "",
        Size = 90,
        Flag = "ESP_MaxDistance",
        Callback = function(v) Settings.ESP_MaxDistance = v end
    })

    local miscSecVis = addSection(visTab, "section_misc", "right")
    row = miscSecVis:AddLabel(getText("misc_text_size"), false)
    registerLabel("misc_text_size", row)
    row:AddSlider({
        Default = 14,
        Min = 8,
        Max = 30,
        Type = "",
        Size = 90,
        Flag = "ESP_TextSize",
        Callback = function(v) Settings.ESP_TextSize = v end
    })

    row = miscSecVis:AddLabel(getText("misc_box_thickness"), false)
    registerLabel("misc_box_thickness", row)
    row:AddSlider({
        Default = 1.5,
        Min = 0.5,
        Max = 5,
        Type = "",
        Size = 90,
        Rounding = 1,
        Flag = "ESP_BoxThickness",
        Callback = function(v) Settings.ESP_BoxThickness = v end
    })

    local colorsSec = addSection(visTab, "section_colors", "right")
    row = colorsSec:AddLabel(getText("colors_murderer"), false)
    registerLabel("colors_murderer", row)
    row:AddColorPicker({
        Default = Settings.ESP_ColorMurderer,
        Flag = "ESP_ColorMurderer",
        Callback = function(c) Settings.ESP_ColorMurderer = c end
    })

    row = colorsSec:AddLabel(getText("colors_sheriff"), false)
    registerLabel("colors_sheriff", row)
    row:AddColorPicker({
        Default = Settings.ESP_ColorSheriff,
        Flag = "ESP_ColorSheriff",
        Callback = function(c) Settings.ESP_ColorSheriff = c end
    })

    row = colorsSec:AddLabel(getText("colors_innocent"), false)
    registerLabel("colors_innocent", row)
    row:AddColorPicker({
        Default = Settings.ESP_ColorInnocent,
        Flag = "ESP_ColorInnocent",
        Callback = function(c) Settings.ESP_ColorInnocent = c end
    })

    row = colorsSec:AddLabel(getText("colors_gun"), false)
    registerLabel("colors_gun", row)
    row:AddColorPicker({
        Default = Settings.ESP_ColorGun,
        Flag = "ESP_ColorGun",
        Callback = function(c)
            updateGunColor(c)
        end
    })

    local extraVisSec = addSection(visTab, "section_extra_vis", "right")
    row = extraVisSec:AddLabel(getText("extra_only_murderer"), false)
    registerLabel("extra_only_murderer", row)
    row:AddToggle({
        Default = false,
        Flag = "ESP_OnlyMurderer",
        Callback = function(v) Settings.ESP_OnlyMurderer = v end
    })

    local movTab = Window:AddTab({ Icon = "person-standing", Name = "Movement" })

    local tpSec = addSection(movTab, "section_teleports")
    local btn = tpSec:AddButton({
        Name = getText("movement_tp_murderer"),
        Icon = "skull",
        Callback = function()
            if not isRunning then return end
            local m = findPlayerByRole("Murderer")
            if m then teleportTo(m) else print("Убийца не найден") end
        end
    })
    registerButton("movement_tp_murderer", btn)

    btn = tpSec:AddButton({
        Name = getText("movement_tp_sheriff"),
        Icon = "badge",
        Callback = function()
            if not isRunning then return end
            local s = findPlayerByRole("Sheriff")
            if s then teleportTo(s) else print("Шериф не найден") end
        end
    })
    registerButton("movement_tp_sheriff", btn)

    btn = tpSec:AddButton({
        Name = getText("movement_tp_gun"),
        Icon = "gun",
        Callback = function()
            if not isRunning then return end
            local gun = getCachedGun()
            if gun then
                teleportToPart(gun)
                print("Телепорт к пистолету")
            else
                print("Оружие не найдено")
            end
        end
    })
    registerButton("movement_tp_gun", btn)

    local speedSec = addSection(movTab, "section_speed")
    row = speedSec:AddLabel(getText("movement_walkspeed"), false)
    registerLabel("movement_walkspeed", row)
    row:AddSlider({
        Default = 16,
        Min = 16,
        Max = 100,
        Type = " WS",
        Size = 90,
        Flag = "Walkspeed",
        Callback = function(value)
            if not isRunning then return end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = value end
            end
        end
    })

    -- ===================================================================
    -- ВКЛАДКА PLAYERS (перенесена ВЫШЕ Misc)
    -- ===================================================================
    print("[Players] Создание вкладки...")
    local playersTab = Window:AddTab({
        Icon = "person",
        Name = "Players",
        Type = "Double"
    })

    -- Создаём секции
    local listSection = playersTab:AddSection({
        Name = "Player List",
        Position = "left"
    })
    local actionSection = playersTab:AddSection({
        Name = "Actions",
        Position = "right"
    })

    -- Функция получения контейнера секции
    local function getContainerFromSection(section)
        local dummy = section:AddLabel("_temp_dummy_", false)
        local container
        if dummy.Root then
            container = dummy.Root.Parent
        else
            container = dummy.Parent
        end
        dummy:SetVisible(false)
        return container
    end

    -- Получаем контейнеры
    local listContainer = getContainerFromSection(listSection)
    local actionContainer = getContainerFromSection(actionSection)

    if not listContainer or not actionContainer then
        print("[Players] Не удалось получить контейнеры, вкладка не будет работать")
    else
        print("[Players] Контейнеры получены")
    end

    -- Состояние
    local selectedPlayer = nil
    local isSpectating = false
    local currentSpectateTarget = nil
    local originalCameraCFrame = nil
    local spectateConnection = nil
    local playerRows = {}

    -- Функция обновления панели действий
    local function updateActionPanel()
        if not actionContainer then return end
        -- очищаем
        for _, child in ipairs(actionContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("ImageButton") then
                child:Destroy()
            end
        end

        if not selectedPlayer then
            local info = Instance.new("TextLabel")
            info.Parent = actionContainer
            info.Size = UDim2.new(1, -20, 0, 30)
            info.BackgroundTransparency = 1
            info.ZIndex = 9
            info.Font = Enum.Font.GothamMedium
            info.Text = "Select a player from the list"
            info.TextColor3 = Color3.fromRGB(200, 200, 200)
            info.TextSize = 14
            info.TextTransparency = 0.5
            return
        end

        -- Фрейм с аватаркой и именем
        local avatarFrame = Instance.new("Frame")
        avatarFrame.Parent = actionContainer
        avatarFrame.Size = UDim2.new(1, -20, 0, 40)
        avatarFrame.BackgroundTransparency = 1
        avatarFrame.ZIndex = 9

        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Parent = avatarFrame
        avatarImage.Size = UDim2.new(0, 32, 0, 32)
        avatarImage.Position = UDim2.new(0, 0, 0.5, -16)
        avatarImage.BackgroundTransparency = 1
        avatarImage.ZIndex = 10
        local thumb = Players:GetUserThumbnailAsync(selectedPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        avatarImage.Image = thumb
        avatarImage.ImageColor3 = Color3.fromRGB(255, 255, 255)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = avatarFrame
        nameLabel.Size = UDim2.new(1, -40, 1, 0)
        nameLabel.Position = UDim2.new(0, 40, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.ZIndex = 10
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = selectedPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 16
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center

        local function createActionButton(text, icon, callback)
            local frame = Instance.new("Frame")
            frame.Parent = actionContainer
            frame.Size = UDim2.new(1, -20, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
            frame.BackgroundTransparency = 0.5
            frame.ZIndex = 10
            local corner = Instance.new("UICorner", frame)
            corner.CornerRadius = UDim.new(0, 4)

            local iconLabel = Instance.new("TextLabel")
            iconLabel.Parent = frame
            iconLabel.Size = UDim2.new(0, 30, 1, 0)
            iconLabel.BackgroundTransparency = 1
            iconLabel.FontFace = NeverLose.BuiltInBold
            iconLabel.Text = icon
            iconLabel.TextColor3 = Color3.fromRGB(223, 223, 223)
            iconLabel.TextSize = 18
            iconLabel.TextTransparency = 0.25
            iconLabel.ZIndex = 11

            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = frame
            textLabel.Size = UDim2.new(1, -35, 1, 0)
            textLabel.Position = UDim2.new(0, 35, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.Text = text
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 13
            textLabel.TextTransparency = 0.2
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.ZIndex = 11

            local btn = Instance.new("ImageButton")
            btn.Parent = frame
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.ZIndex = 12
            btn.ImageTransparency = 1

            btn.MouseButton1Click:Connect(callback)

            btn.MouseEnter:Connect(function()
                frame.BackgroundTransparency = 0.2
            end)
            btn.MouseLeave:Connect(function()
                frame.BackgroundTransparency = 0.5
            end)

            return frame
        end

        -- Fling (с отключением Anti-Fling и увеличенной задержкой)
        createActionButton("Fling", "arrow-large-up", function()
            local wasActive = antiFlingActive
            if wasActive then
                disableAntiFling()
                print("[Fling] Anti-Fling временно отключён")
                task.wait(0.3) -- увеличенная задержка для гарантии остановки циклов
            end

            local success, err = pcall(function()
                if not selectedPlayer or not selectedPlayer.Character then return end
                local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not targetRoot then return end

                local localChar = LocalPlayer.Character
                if not localChar then return end
                local localRoot = localChar:FindFirstChild("HumanoidRootPart")
                if not localRoot then return end

                local fakePart = Instance.new("Part")
                fakePart.Size = Vector3.new(5,5,5)
                fakePart.Anchored = true
                fakePart.CanCollide = false
                fakePart.Transparency = 0.5
                fakePart.Material = Enum.Material.ForceField
                fakePart.Parent = workspace
                fakePart.CFrame = targetRoot.CFrame

                local att1 = Instance.new("Attachment", fakePart)
                local att2 = Instance.new("Attachment", localRoot)
                local alignPos = Instance.new("AlignPosition")
                alignPos.Attachment0 = att2
                alignPos.Attachment1 = att1
                alignPos.RigidityEnabled = true
                alignPos.Responsiveness = math.huge
                alignPos.MaxForce = math.huge
                alignPos.MaxVelocity = math.huge
                alignPos.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                alignPos.Visible = true
                alignPos.Mode = Enum.PositionAlignmentMode.TwoAttachment
                alignPos.Parent = fakePart

                local hum = localChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.StrafingNoPhysics)
                end

                local startCF = localRoot.CFrame

                localRoot.CFrame = CFrame.new(Vector3.new(0, 40000000, 0)) * CFrame.fromEulerAnglesXYZ(math.rad(180),0,0)
                localRoot.Velocity = Vector3.new(0, 1000000, 0)
                task.wait(3)

                localRoot.Velocity = Vector3.new(0,0,0)
                localRoot.CFrame = startCF
                task.wait(0.05)

                localRoot.CFrame = targetRoot.CFrame
                fakePart.Position = targetRoot.Position

                local startTime = tick()
                local power = 1000
                local flingThread = game:GetService("RunService").Heartbeat:Connect(function()
                    if tick() - startTime > 4 then
                        flingThread:Disconnect()
                        return
                    end
                    fakePart.Position = targetRoot.Position
                    localRoot.CFrame = fakePart.CFrame
                    localRoot.AssemblyAngularVelocity = Vector3.new(math.random(-1000,1000), math.random(-1000,1000) * power, math.random(-1000,1000))
                    localRoot.Velocity = Vector3.new(math.random(-500,500), math.random(-500,500), math.random(-500,500))
                    if tick() % 0.1 < 0.05 then
                        targetRoot:ApplyImpulse(Vector3.new(math.random(-300,300), 500, math.random(-300,300)))
                    end
                end)

                task.wait(4)
                flingThread:Disconnect()
                fakePart:Destroy()

                localRoot.Velocity = Vector3.new(0,0,0)
                localRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
                localRoot.CFrame = startCF

                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                print("Flinged " .. selectedPlayer.Name)
            end)

            if not success then
                warn("[Fling] Ошибка: " .. tostring(err))
            end

            if wasActive then
                enableAntiFling()
                print("[Fling] Anti-Fling восстановлен")
            end
        end)

        -- TP To Player
        createActionButton("TP To Player", "person-standing", function()
            if not selectedPlayer then return end
            teleportTo(selectedPlayer)
        end)

        -- Spectate
        createActionButton(isSpectating and "Stop Spectate" or "Spectate", "eye", function()
            if isSpectating then
                isSpectating = false
                currentSpectateTarget = nil
                if spectateConnection then
                    spectateConnection:Disconnect()
                    spectateConnection = nil
                end
                if originalCameraCFrame then
                    workspace.CurrentCamera.CFrame = originalCameraCFrame
                    originalCameraCFrame = nil
                end
                updateActionPanel()
            else
                if selectedPlayer then
                    if not selectedPlayer.Character then
                        print("Target has no character")
                        return
                    end
                    local head = selectedPlayer.Character:FindFirstChild("Head")
                    if not head then
                        print("Target has no Head")
                        return
                    end
                    isSpectating = true
                    currentSpectateTarget = selectedPlayer
                    originalCameraCFrame = workspace.CurrentCamera.CFrame
                    if spectateConnection then spectateConnection:Disconnect() end
                    spectateConnection = RunService.RenderStepped:Connect(function()
                        if not isSpectating or not selectedPlayer or not selectedPlayer.Character then
                            isSpectating = false
                            if spectateConnection then
                                spectateConnection:Disconnect()
                                spectateConnection = nil
                            end
                            if originalCameraCFrame then
                                workspace.CurrentCamera.CFrame = originalCameraCFrame
                                originalCameraCFrame = nil
                            end
                            updateActionPanel()
                            return
                        end
                        local targetHead = selectedPlayer.Character:FindFirstChild("Head")
                        if targetHead then
                            local offset = targetHead.CFrame.LookVector * -5
                            local camPos = targetHead.Position + offset + Vector3.new(0, 1, 0)
                            workspace.CurrentCamera.CFrame = CFrame.new(camPos, targetHead.Position)
                        end
                    end)
                    updateActionPanel()
                end
            end
        end)

        -- Copy Name
        createActionButton("Copy Name", "document-circle-slash", function()
            if not selectedPlayer then return end
            local success = pcall(function()
                if setclipboard then
                    setclipboard(selectedPlayer.Name)
                elseif toclipboard then
                    toclipboard(selectedPlayer.Name)
                else
                    print("Copied: " .. selectedPlayer.Name)
                end
            end)
            if success then
                print("Copied username: " .. selectedPlayer.Name)
            else
                print("Clipboard not available")
            end
        end)

        -- Copy ID
        createActionButton("Copy ID", "hashtag", function()
            if not selectedPlayer then return end
            local success = pcall(function()
                if setclipboard then
                    setclipboard(tostring(selectedPlayer.UserId))
                elseif toclipboard then
                    toclipboard(tostring(selectedPlayer.UserId))
                else
                    print("Copied: " .. selectedPlayer.UserId)
                end
            end)
            if success then
                print("Copied UserId: " .. selectedPlayer.UserId)
            else
                print("Clipboard not available")
            end
        end)
    end

    -- Функция перестроения списка игроков
    local function rebuildPlayerList()
        if not listContainer then return end
        for _, row in ipairs(playerRows) do
            pcall(function() row:Destroy() end)
        end
        table.clear(playerRows)

        local players = Players:GetPlayers()
        for _, plr in ipairs(players) do
            if plr == LocalPlayer then continue end

            local row = Instance.new("Frame")
            row.Name = "PlayerRow_" .. plr.UserId
            row.Parent = listContainer
            row.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
            row.BackgroundTransparency = 1
            row.Size = UDim2.new(1, -10, 0, 40)
            row.ZIndex = 9

            local avatar = Instance.new("ImageLabel")
            avatar.Parent = row
            avatar.AnchorPoint = Vector2.new(0, 0.5)
            avatar.Position = UDim2.new(0, 10, 0.5, 0)
            avatar.Size = UDim2.new(0, 30, 0, 30)
            avatar.BackgroundTransparency = 1
            avatar.ZIndex = 10
            local thumb = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            avatar.Image = thumb
            avatar.ImageColor3 = Color3.fromRGB(255, 255, 255)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = row
            nameLabel.AnchorPoint = Vector2.new(0, 0.5)
            nameLabel.Position = UDim2.new(0, 50, 0.5, 0)
            nameLabel.Size = UDim2.new(1, -60, 0, 20)
            nameLabel.BackgroundTransparency = 1
            nameLabel.ZIndex = 10
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.Text = plr.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local clickButton = Instance.new("ImageButton")
            clickButton.Parent = row
            clickButton.Size = UDim2.new(1, 0, 1, 0)
            clickButton.BackgroundTransparency = 1
            clickButton.ZIndex = 11
            clickButton.ImageTransparency = 1

            clickButton.MouseButton1Click:Connect(function()
                if isSpectating then
                    isSpectating = false
                    if spectateConnection then
                        spectateConnection:Disconnect()
                        spectateConnection = nil
                    end
                    if originalCameraCFrame then
                        workspace.CurrentCamera.CFrame = originalCameraCFrame
                        originalCameraCFrame = nil
                    end
                end
                selectedPlayer = plr
                updateActionPanel()
            end)

            local function onHover(enter)
                if enter then
                    row.BackgroundTransparency = 0.35
                else
                    row.BackgroundTransparency = 1
                end
            end
            clickButton.MouseEnter:Connect(function() onHover(true) end)
            clickButton.MouseLeave:Connect(function() onHover(false) end)

            table.insert(playerRows, row)
        end

        if #playerRows == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Parent = listContainer
            emptyLabel.Size = UDim2.new(1, -10, 0, 30)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.ZIndex = 9
            emptyLabel.Font = Enum.Font.GothamMedium
            emptyLabel.Text = "No other players in server"
            emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            emptyLabel.TextSize = 14
            emptyLabel.TextTransparency = 0.5
            table.insert(playerRows, emptyLabel)
        end
    end

    -- Инициализация списка игроков
    if listContainer and actionContainer then
        rebuildPlayerList()
        updateActionPanel()

        local function onPlayerAddedHandler(plr)
            rebuildPlayerList()
            if selectedPlayer and selectedPlayer == plr then
                selectedPlayer = nil
                updateActionPanel()
            end
        end

        local function onPlayerRemovingHandler(plr)
            if selectedPlayer and selectedPlayer == plr then
                if isSpectating then
                    isSpectating = false
                    if spectateConnection then
                        spectateConnection:Disconnect()
                        spectateConnection = nil
                    end
                    if originalCameraCFrame then
                        workspace.CurrentCamera.CFrame = originalCameraCFrame
                        originalCameraCFrame = nil
                    end
                end
                selectedPlayer = nil
            end
            rebuildPlayerList()
            updateActionPanel()
        end

        if not _G.PlayerListHandlersAdded then
            _G.PlayerListHandlersAdded = true
            Players.PlayerAdded:Connect(onPlayerAddedHandler)
            Players.PlayerRemoving:Connect(onPlayerRemovingHandler)
        end
    else
        print("[Players] Ошибка: контейнеры не получены")
    end

    print("[Players] Вкладка создана")
    -- ===================================================================
    -- КОНЕЦ ВКЛАДКИ PLAYERS
    -- ===================================================================

    -- ===================================================================
    -- ВКЛАДКА MISC (теперь ниже Players)
    -- ===================================================================
    local miscTab = Window:AddTab({ Icon = "gear", Name = "Misc" })

    local fakeSec = addSection(miscTab, "section_fake")

    local korbloxActive = false
    local korbloxPart = nil
    local headlessActive = false

    local function toggleKorblox(state)
        korbloxActive = state
        local character = LocalPlayer.Character
        if not character then return end

        if korbloxActive then
            if korbloxPart and korbloxPart.Parent then
                korbloxPart:Destroy()
                korbloxPart = nil
            end

            local origUpper = character:FindFirstChild("RightUpperLeg")
            local origLower = character:FindFirstChild("RightLowerLeg")
            local origFoot = character:FindFirstChild("RightFoot")
            if not (origUpper and origLower and origFoot) then
                print("[Korblox] Части ноги не найдены")
                korbloxActive = false
                return
            end

            local sizeY = 0.50
            local scaleY = 0.95
            local offsetY = 0.20
            local thickness = 0.75

            local newLeg = Instance.new("Part")
            newLeg.Name = "RightLeg_Korblox"
            newLeg.Size = Vector3.new(0.8, sizeY, 0.8)
            newLeg.Anchored = false
            newLeg.CanCollide = false
            newLeg.Locked = true
            newLeg.BrickColor = BrickColor.White()
            newLeg.Material = Enum.Material.SmoothPlastic
            newLeg.Transparency = 0
            newLeg.Parent = character

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshId = "rbxassetid://902942096"
            mesh.TextureId = "rbxassetid://902843398"
            mesh.Scale = Vector3.new(thickness, scaleY, thickness)
            mesh.Parent = newLeg

            newLeg.CFrame = origUpper.CFrame + Vector3.new(0, offsetY, 0)

            local weld = Instance.new("Weld")
            weld.Part0 = origUpper
            weld.Part1 = newLeg
            weld.C0 = origUpper.CFrame:Inverse() * newLeg.CFrame
            weld.Parent = newLeg

            origUpper.Transparency = 1
            origLower.Transparency = 1
            origFoot.Transparency = 1

            for _, part in ipairs({origUpper, origLower, origFoot}) do
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child:Destroy()
                    end
                end
            end

            korbloxPart = newLeg
        else
            if korbloxPart and korbloxPart.Parent then
                korbloxPart:Destroy()
            end
            korbloxPart = nil

            local char = LocalPlayer.Character
            if char then
                local origUpper = char:FindFirstChild("RightUpperLeg")
                local origLower = char:FindFirstChild("RightLowerLeg")
                local origFoot = char:FindFirstChild("RightFoot")
                if origUpper then origUpper.Transparency = 0 end
                if origLower then origLower.Transparency = 0 end
                if origFoot then origFoot.Transparency = 0 end
            end
        end
    end

    local function toggleHeadless(state)
        headlessActive = state
        local character = LocalPlayer.Character
        if not character then return end

        if headlessActive then
            if character.Head then
                character.Head.Transparency = 1
            end
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("Decal") and v.Name == "face" then
                    v:Destroy()
                end
            end
        else
            if character.Head then
                character.Head.Transparency = 0
            end
        end
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if korbloxActive then
            toggleKorblox(true)
        end
        if headlessActive then
            toggleHeadless(true)
        end
    end)

    local korbloxLabel = fakeSec:AddLabel(getText("fake_korblox"), false)
    registerLabel("fake_korblox", korbloxLabel)
    korbloxLabel:AddToggle({
        Default = false,
        Flag = "Fake_Korblox",
        Callback = function(v)
            toggleKorblox(v)
        end
    })

    local headlessLabel = fakeSec:AddLabel(getText("fake_headless"), false)
    registerLabel("fake_headless", headlessLabel)
    headlessLabel:AddToggle({
        Default = false,
        Flag = "Fake_Headless",
        Callback = function(v)
            toggleHeadless(v)
        end
    })

    -- ============================================================
    -- НОВАЯ СЕКЦИЯ: ANTI-FLING (исправленный, без отключения CanCollide)
    -- ============================================================
    local antiFlingSec = miscTab:AddSection({
        Name = "Anti-Fling",
        Position = "left"
    })
    local antiFlingLabel = antiFlingSec:AddLabel(getText("anti_fling"), false)
    registerLabel("anti_fling", antiFlingLabel)

    -- Переменные
    local antiFlingActive = false
    local antiFlingConnections = {}
    local LastPosition = nil

    -- Функция нейтрализации персонажа (только сброс скоростей, без изменения CanCollide)
    local function neutralizeCharacter(character)
        if not character then return end
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                -- Не трогаем CanCollide и CustomPhysicalProperties
            end
        end
    end

    -- Функция включения
    local function enableAntiFling()
        if antiFlingActive then return end
        antiFlingActive = true

        -- Функция обработки Heartbeat для локального игрока
        local function antiFlingLoop()
            if not antiFlingActive then return end
            local character = LocalPlayer.Character
            if not character then return end
            local primaryPart = character.PrimaryPart
            if not primaryPart then return end

            if primaryPart.AssemblyLinearVelocity.Magnitude > 250 or primaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                primaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                primaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                if LastPosition then
                    primaryPart.CFrame = LastPosition
                end
                neutralizeCharacter(character)
                print("[Anti-Fling] Neutralized fling.")
            elseif primaryPart.AssemblyLinearVelocity.Magnitude < 50 and primaryPart.AssemblyAngularVelocity.Magnitude < 50 then
                LastPosition = primaryPart.CFrame
            end
        end

        local conn = RunService.Heartbeat:Connect(antiFlingLoop)
        table.insert(antiFlingConnections, conn)

        local function onCharacterAdded(character)
            if not antiFlingActive then return end
            task.wait(0.1)
            neutralizeCharacter(character)
        end

        local charConn = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        table.insert(antiFlingConnections, charConn)

        if LocalPlayer.Character then
            neutralizeCharacter(LocalPlayer.Character)
        end

        print("[Anti-Fling] Включён (только сброс скоростей)")
    end

    -- Функция выключения
    local function disableAntiFling()
        if not antiFlingActive then return end
        antiFlingActive = false

        -- Отключаем все подключения
        for _, conn in ipairs(antiFlingConnections) do
            pcall(conn.Disconnect, conn)
        end
        table.clear(antiFlingConnections)

        LastPosition = nil
        print("[Anti-Fling] Выключён")
    end

    -- Тумблер
    local antiFlingToggle = antiFlingLabel:AddToggle({
        Default = false,
        Flag = "AntiFling",
        Callback = function(state)
            if state then
                enableAntiFling()
            else
                disableAntiFling()
            end
        end
    })

    -- При респавне автоматически применяем, если включено
    LocalPlayer.CharacterAdded:Connect(function()
        if antiFlingActive then
            task.wait(0.1)
            local character = LocalPlayer.Character
            if character then
                neutralizeCharacter(character)
            end
        end
    end)

    -- При старте, если тумблер уже включён (сохранён в настройках)
    task.wait(0.5)
    if antiFlingToggle:GetValue() then
        antiFlingActive = true
        enableAntiFling()
    end

    local unloadSec = addSection(miscTab, "section_unload")
    btn = unloadSec:AddButton({
        Name = getText("misc_unload"),
        Icon = "trash-can",
        Callback = function()
            if not isRunning then return end
            isRunning = false

            if oldNamecall then
                pcall(function()
                    hookmetamethod(game, "__namecall", oldNamecall)
                end)
                oldNamecall = nil
            end

            if connections and type(connections) == "table" then
                for _, conn in ipairs(connections) do
                    pcall(function()
                        if conn and conn.Disconnect then
                            conn:Disconnect()
                        end
                    end)
                end
                table.clear(connections)
            end

            if _G.NeverloseESPObjects then
                for _, data in pairs(_G.NeverloseESPObjects) do
                    for _, obj in pairs(data) do
                        pcall(function() obj:Remove() end)
                    end
                end
                _G.NeverloseESPObjects = nil
            end

            if fovCircle then pcall(fovCircle.Remove, fovCircle) end
            if mouseBox then pcall(mouseBox.Remove, mouseBox) end
            if gunIconGui then pcall(gunIconGui.Destroy, gunIconGui) end

            if korbloxPart and korbloxPart.Parent then korbloxPart:Destroy() end
            local char = LocalPlayer.Character
            if char and char.Head then
                char.Head.Transparency = 0
            end

            _G.NeverloseLoaded = false

            pcall(function()
                NeverLose.UnloadEnabled = true
                NeverLose:Unload()
                if NeverLose.ScreenGui then
                    NeverLose.ScreenGui:Destroy()
                end
            end)

        end
    })
    registerButton("misc_unload", btn)

    -- ============================================================
    -- ESP для игроков
    -- ============================================================

    local function createESPObjects(id)
        if espCache[id] then
            for _, obj in pairs(espCache[id]) do
                pcall(function() obj:Remove() end)
            end
            espCache[id] = nil
        end

        local e = {
            Out = Drawing.new("Square"),
            Box = Drawing.new("Square"),
            Text = Drawing.new("Text"),
            Tracer = Drawing.new("Line"),
        }
        e.Out.Thickness = Settings.ESP_BoxThickness + 2
        e.Out.Filled = false
        e.Out.Color = Color3.new(0, 0, 0)
        e.Out.Transparency = 0.6
        e.Out.ZIndex = 0
        e.Out.Visible = false

        e.Box.Thickness = Settings.ESP_BoxThickness
        e.Box.Filled = false
        e.Box.ZIndex = 1
        e.Box.Visible = false

        e.Text.Size = Settings.ESP_TextSize
        e.Text.Center = true
        e.Text.Outline = true
        e.Text.Font = 2
        e.Text.ZIndex = 2
        e.Text.Visible = false

        e.Tracer.Thickness = 1.5
        e.Tracer.ZIndex = 1
        e.Tracer.Visible = false

        espCache[id] = e
        return e
    end

    local frameCounter = 0
    local VALIDATION_INTERVAL = 30

    local function ensureESPValid(id)
        local e = espCache[id]
        if not e then return false end
        frameCounter = frameCounter + 1
        if frameCounter % VALIDATION_INTERVAL == 0 then
            local ok, _ = pcall(function()
                local _ = e.Out.Visible
                _ = e.Box.Visible
                _ = e.Text.Visible
                _ = e.Tracer.Visible
            end)
            if not ok then
                for _, obj in pairs(e) do
                    pcall(function() obj:Remove() end)
                end
                espCache[id] = nil
                return false
            end
        end
        return true
    end

    local function updateESP(id, char, root, name, role, cam)
        if not isRunning or not Settings.ESP_Enabled then return end

        if role == "Dead" then
            local e = espCache[id]
            if e then
                if e.Box then e.Box.Visible = false end
                if e.Out then e.Out.Visible = false end
                if e.Text then e.Text.Visible = false end
                if e.Tracer then e.Tracer.Visible = false end
            end
            return
        end

        if espCache[id] and not ensureESPValid(id) then
        end

        if not espCache[id] then
            createESPObjects(id)
        end

        local e = espCache[id]
        local out, box, text, tracer = e.Out, e.Box, e.Text, e.Tracer

        out.Thickness = Settings.ESP_BoxThickness + 2
        box.Thickness = Settings.ESP_BoxThickness
        text.Size = Settings.ESP_TextSize

        local dist = (cam.CFrame.Position - root.Position).Magnitude
        local shouldShow = (dist <= Settings.ESP_MaxDistance)

        if shouldShow then
            local myRole = roleCache[LocalPlayer.Name] and roleCache[LocalPlayer.Name].Role or "Unknown"
            if Settings.ESP_OnlyMurderer and myRole == "Sheriff" and role ~= "Murderer" then
                shouldShow = false
            end
        end

        if shouldShow then
            local head = char:FindFirstChild("Head") or root
            local topPoint = head.Position + Vector3.new(0, 0.6, 0)
            local bottomPoint = root.Position - Vector3.new(0, 3.2, 0)

            local topView, onTop = cam:WorldToViewportPoint(topPoint)
            local botView, onBot = cam:WorldToViewportPoint(bottomPoint)
            if not onTop or not onBot then
                shouldShow = false
            else
                local height = math.abs(botView.Y - topView.Y)
                local width = height * 0.5
                if height < 6 then height = 6; width = 4 end

                local roleColor
                if role == "Murderer" then
                    roleColor = Settings.ESP_ColorMurderer
                elseif role == "Sheriff" then
                    roleColor = Settings.ESP_ColorSheriff
                elseif role == "Innocent" then
                    roleColor = Settings.ESP_ColorInnocent
                else
                    roleColor = Color3.fromRGB(128, 128, 128)
                end

                local boxPos = Vector2.new(topView.X - width/2, topView.Y)
                local boxSize = Vector2.new(width, height)

                if Settings.ESP_ShowBoxes then
                    out.Visible = true
                    out.Position = boxPos
                    out.Size = boxSize

                    box.Visible = true
                    box.Position = boxPos
                    box.Size = boxSize
                    box.Color = roleColor
                else
                    out.Visible = false
                    box.Visible = false
                end

                if Settings.ESP_ShowText then
                    local distM = math.floor(dist / 3.5)
                    local textStr = string.format("%s [%dm] (%s)", name, distM, role)
                    text.Text = textStr
                    text.Position = Vector2.new(topView.X, topView.Y - Settings.ESP_TextSize - 2)
                    text.Color = roleColor
                    text.Visible = true
                else
                    text.Visible = false
                end

                if Settings.ESP_ShowTracers then
                    tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    tracer.To = Vector2.new(topView.X, botView.Y)
                    tracer.Color = roleColor
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            end
        end

        if not shouldShow then
            out.Visible = false
            box.Visible = false
            text.Visible = false
            tracer.Visible = false
        end
    end

    local function removeESPForPlayer(id)
        if espCache[id] then
            for _, obj in pairs(espCache[id]) do
                pcall(function() obj:Remove() end)
            end
            espCache[id] = nil
        end
    end

    addConnection(Players.PlayerRemoving:Connect(function(plr)
        removeESPForPlayer(tostring(plr.UserId))
    end))

    addConnection(RunService.RenderStepped:Connect(function()
        if not isRunning then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        if Settings.ESP_Enabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local role = getRole(plr)
                    updateESP(tostring(plr.UserId), plr.Character, root, plr.Name, role, cam)
                else
                    local e = espCache[tostring(plr.UserId)]
                    if e then
                        e.Out.Visible = false
                        e.Box.Visible = false
                        e.Text.Visible = false
                        e.Tracer.Visible = false
                    end
                end
            end
        else
            for _, e in pairs(espCache) do
                if e.Box then e.Box.Visible = false end
                if e.Out then e.Out.Visible = false end
                if e.Text then e.Text.Visible = false end
                if e.Tracer then e.Tracer.Visible = false end
            end
        end

        if Settings.ESP_Enabled and Settings.ESP_ShowGun then
            local gun = getCachedGun()
            if gun then
                local pos
                if gun:IsA("BasePart") then
                    pos = gun.Position
                elseif gun:IsA("Tool") then
                    local handle = gun:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        pos = handle.Position
                    else
                        pos = gun:GetPivot().Position
                    end
                elseif gun:IsA("Model") then
                    local primary = gun.PrimaryPart
                    pos = primary and primary.Position or gun:GetPivot().Position
                else
                    pos = nil
                end

                if pos then
                    local dist = (cam.CFrame.Position - pos).Magnitude
                    if dist <= Settings.ESP_MaxDistance then
                        local screenPos, on = cam:WorldToViewportPoint(pos)
                        if on and screenPos.Z > 0 then
                            local x = screenPos.X
                            local y = screenPos.Y
                            local viewSize = cam.ViewportSize
                            if x > 0 and x < viewSize.X and y > 0 and y < viewSize.Y then
                                if gunIcon.Image ~= "" and gunIcon.Image ~= "rbxasset://textures/ui/Placeholder.png" then
                                    gunIcon.Visible = true
                                    gunIcon.Position = UDim2.new(0, x - 20, 0, y - 20)
                                    gunIcon.ImageColor3 = Settings.ESP_ColorGun
                                    gunTextFallback.Visible = false
                                else
                                    gunIcon.Visible = false
                                    gunTextFallback.Visible = true
                                    gunTextFallback.Position = UDim2.new(0, x - 25, 0, y - 15)
                                    gunTextFallback.TextColor3 = Settings.ESP_ColorGun
                                end
                            else
                                gunIcon.Visible = false
                                gunTextFallback.Visible = false
                            end
                        else
                            gunIcon.Visible = false
                            gunTextFallback.Visible = false
                        end
                    else
                        gunIcon.Visible = false
                        gunTextFallback.Visible = false
                    end
                else
                    gunIcon.Visible = false
                    gunTextFallback.Visible = false
                end
            else
                gunIcon.Visible = false
                gunTextFallback.Visible = false
            end
        else
            gunIcon.Visible = false
            gunTextFallback.Visible = false
        end

        if Settings.ShowTarget and Settings.Enabled then
            local target = getClosestTarget()
            if target then
                local pos, on = WorldToViewportPoint(Camera, target.Position)
                if on then
                    mouseBox.Visible = true
                    mouseBox.Position = Vector2.new(pos.X, pos.Y)
                else
                    mouseBox.Visible = false
                end
            else
                mouseBox.Visible = false
            end
        else
            mouseBox.Visible = false
        end

        if Settings.FOVVisible and Settings.Enabled then
            fovCircle.Visible = true
            fovCircle.Position = mousePos()
        else
            fovCircle.Visible = false
        end
    end))

    task.delay(0.5, function()
        updateUI()
    end)

    print("ty for using exsilium<3>")
end

local function showLoader()
    local LoaderModule = nil
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/loader.luau"))()
    end)
    if success and result then
        LoaderModule = result
    else
        return loadLegacyLoader()
    end

    local Loader = nil
    local params = {
        Name = "exsilium",
        Content = "by @fadepotion",
        Process = "Введите ключ для активации",
        Default = "",
        Yield = false,
        DefaultVersion = nil,
        Versions = {
            { Idx = "stable", Name = "Stable", Content = "Релизная версия" },
            { Idx = "beta", Name = "Beta", Content = "Тестовая версия" },
        },
        OnGetKey = function()
            local link = "@fadepotion"
            if setclipboard then
                setclipboard(link)
                local notif = NeverLose:CreateNotification()
                if notif and notif.new then
                    notif.new({
                        Title = "Ключ скопирован",
                        Content = "Ссылка скопирована в буфер обмена!",
                        Duration = 5
                    })
                else
                    print("link coppied")
                end
            else
                local notif = NeverLose:CreateNotification()
                if notif and notif.new then
                    notif.new({
                        Title = "Получение ключа",
                        Content = "Ссылка: " .. link,
                        Duration = 7
                    })
                else
                    print("get key from pm Discord: " .. link)
                end
            end
        end,
        OnRedeem = function(key)
            if key == "123" or key == "exsilium" then
                task.spawn(startMain)
                if Loader and type(Loader.Unload) == "function" then
                    Loader:Unload()
                end
                return true, nil
            else
                return false, "Неверный ключ!"
            end
        end
    }

    if type(LoaderModule) == "table" and type(LoaderModule.new) == "function" then
        Loader = LoaderModule.new(params)
    elseif type(LoaderModule) == "function" then
        Loader = LoaderModule(params)
    else
        warn("Неизвестный тип LoaderModule, используем резервный загрузчик")
        return loadLegacyLoader()
    end

    if Loader and type(Loader.Await) == "function" then
        local selectedVersion = Loader:Await()
        if selectedVersion then
            Settings.DefaultVersion = selectedVersion
        end
    end
end

local function loadLegacyLoader()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "exsilium_loader"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 170)
    frame.Position = UDim2.new(0.5, -160, 0.5, -85)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "exsilium loader"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold

    local sub = Instance.new("TextLabel", frame)
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 35)
    sub.BackgroundTransparency = 1
    sub.Text = "Enter your license key"
    sub.TextColor3 = Color3.fromRGB(200, 200, 200)
    sub.TextSize = 12
    sub.Font = Enum.Font.GothamMedium

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.8, 0, 0, 30)
    textBox.Position = UDim2.new(0.1, 0, 0, 65)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
    textBox.BorderSizePixel = 0
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.GothamMedium
    textBox.PlaceholderText = "Enter key..."
    textBox.ClearTextOnFocus = false
    local corner2 = Instance.new("UICorner", textBox)
    corner2.CornerRadius = UDim.new(0, 4)

    local loginBtn = Instance.new("TextButton", frame)
    loginBtn.Size = UDim2.new(0.4, 0, 0, 30)
    loginBtn.Position = UDim2.new(0.3, 0, 0, 105)
    loginBtn.BackgroundColor3 = Color3.fromRGB(78, 127, 252)
    loginBtn.BorderSizePixel = 0
    loginBtn.Text = "Login"
    loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loginBtn.TextSize = 14
    loginBtn.Font = Enum.Font.GothamBold
    local corner3 = Instance.new("UICorner", loginBtn)
    corner3.CornerRadius = UDim.new(0, 4)

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 0, 0, 145)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Visible = false

    local function onLogin()
        local key = textBox.Text
        if key == "123" or key == "exsilium" then
            statusLabel.Visible = false
            screenGui:Destroy()
            startMain()
        else
            statusLabel.Text = "Invalid key!"
            statusLabel.Visible = true
        end
    end

    loginBtn.MouseButton1Click:Connect(onLogin)
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then onLogin() end
    end)

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if textBox.Text == "" then statusLabel.Visible = false end
    end)
end

showLoader()
