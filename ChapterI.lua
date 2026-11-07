local success, KazeUILib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeHub/UI/refs/heads/main/testproject"))()
end)
local KazeUI = KazeUI or (success and KazeUILib)

if not KazeUI then
    warn("Failed to load KazeUI library!")
    return
end

local Window = KazeUI:CreateWindow({
    Title = "THE MIMIC",
    Author = "KAZE",
    Version = "BOOK III",
    Size = UDim2.fromOffset(700, 400),
    Icon = "79414074886215",
    Theme = "https://images3.alphacoders.com/124/1244059.jpg",
    GlowStyle = "Sequence",
    GlowColor = true,
    HidableTab = true,
    PerformanceMode = true, 
    
    PopupTitle = "Welcome to KAZE HUB",
    PopupContent = "Thank You for using my script!",
    DiscordLink = "https://discord.gg/DKGRny4DD",
    DiscordName = "Join our server",
    YoutubeLink = "https://www.youtube.com/@Kaze_Hub",
    YoutubeName = "KazeHub",

    OpenButton = {
        Icon = "79414074886215",
        Shape = "square", 
        Hidable = false,
        Size = UDim2.fromOffset(60, 60)
    },
})

local PlayerTab = Window:CreateTab({ Title = "Player", Icon = "user" })
local CityTab = Window:CreateTab({ Title = "City", Icon = "Building-2" })
local SchoolTab = Window:CreateTab({ Title = "School", Icon = "school" })
local ForestTab = Window:CreateTab({ Title = "Forest", Icon = "trees" })
local IJOTab = Window:CreateTab({ Title = "IJO", Icon = "flask-conical" })
local WaterTab = Window:CreateTab({ Title = "Water", Icon = "droplet" })

-- ==========================================
-- PLAYER TAB
-- ==========================================
local PlayerMain = PlayerTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local fbConnection
local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime
local origShadows = Lighting.GlobalShadows

PlayerMain:Toggle({
    Title = "FullBright",
    Default = false,
    Callback = function(state)
        if fbConnection then fbConnection:Disconnect() fbConnection = nil end
        if state then
            local function applyBright()
                if Lighting.Ambient ~= Color3.fromRGB(178, 178, 178) then Lighting.Ambient = Color3.fromRGB(178, 178, 178) end
                if Lighting.OutdoorAmbient ~= Color3.fromRGB(178, 178, 178) then Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178) end
                if Lighting.Brightness ~= 2 then Lighting.Brightness = 2 end
                if Lighting.ClockTime ~= 14 then Lighting.ClockTime = 14 end
                if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
            end
            applyBright()
            fbConnection = Lighting.Changed:Connect(applyBright)
        else
            Lighting.Ambient = origAmbient
            Lighting.OutdoorAmbient = origOutdoorAmbient
            Lighting.Brightness = origBrightness
            Lighting.ClockTime = origClockTime
            Lighting.GlobalShadows = origShadows
        end
    end
})

PlayerMain:Button({
    Title = "Low GFX",
    Description = "Reduces lag and boosts FPS by disabling heavy visuals.",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        local DISABLE_SHADOWS = true
        local DISABLE_POST_PROCESSING = true
        local DISABLE_PARTICLES = true
        local DISABLE_TEXTURES = true
        local DISABLE_TERRAIN_DETAILS = true

        task.spawn(function()
            pcall(function()
                if DISABLE_SHADOWS then
                    Lighting.GlobalShadows = false
                    Lighting.ShadowSoftness = 0
                end

                if DISABLE_POST_PROCESSING then
                    for _, child in ipairs(Lighting:GetChildren()) do
                        if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Sky") then
                            child:Destroy()
                        end
                    end
                end

                if DISABLE_TERRAIN_DETAILS and Terrain then
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveTransparency = 1
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 1
                    pcall(function() sethiddenproperty(Terrain, "Decoration", false) end)
                end

                local count = 0
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if DISABLE_PARTICLES and (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")) then
                        obj.Enabled = false
                    elseif DISABLE_TEXTURES and (obj:IsA("Decal") or obj:IsA("Texture")) then
                        obj.Transparency = 1
                    elseif obj:IsA("BasePart") then
                        obj.CastShadow = false
                        obj.Material = Enum.Material.SmoothPlastic
                    end
                    
                    count = count + 1
                    if count % 1000 == 0 then
                        task.wait()
                    end
                end
            end)

            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Performance Booster",
                    Text = "Low GFX Applied Successfully!",
                    Duration = 3
                })
            end)
        end)
    end
})

-- ==========================================
-- CITY TAB
-- ==========================================
local CityMain = CityTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })
local CityESP = CityTab:CreateSubTab({ Title = "ESP", Icon = "eye" })

local autoShootGataEnabled = false
CityMain:Toggle({
    Title = "Auto Shoot Gata",
    Default = false,
    Callback = function(state)
        autoShootGataEnabled = state
        if not autoShootGataEnabled then return end
        task.spawn(function()
            while autoShootGataEnabled do
                RunService.Heartbeat:Wait()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local gruntsFolder = workspace:FindFirstChild("Section1") and workspace.Section1:FindFirstChild("Grunts")
                    if gruntsFolder then
                        for _, gata in ipairs(gruntsFolder:GetChildren()) do
                            if autoShootGataEnabled and gata.Name:find("Gata") then
                                local hitbox = gata:FindFirstChild("HumanoidRootPart") or gata:FindFirstChildWhichIsA("BasePart", true)
                                local remote = gata:FindFirstChild("RemoteEvent")
                                if hitbox and remote then
                                    local dist = (hrp.Position - hitbox.Position).Magnitude
                                    if dist <= 150 then pcall(function() remote:FireServer() end) end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

local espGruntsEnabled = false
local gruntsHighlights = {}
CityESP:Toggle({
    Title = "ESP Grunts",
    Default = false,
    Callback = function(state)
        espGruntsEnabled = state
        for _, hl in pairs(gruntsHighlights) do hl:Destroy() end
        table.clear(gruntsHighlights)
        if not espGruntsEnabled then return end
        local function apply(model)
            if gruntsHighlights[model] or not model:IsA("Model") then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = model; hl.Parent = model
            gruntsHighlights[model] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = model.Name
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
        end
        local folder = workspace:FindFirstChild("Section1") and workspace.Section1:FindFirstChild("Grunts")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espGruntsEnabled then apply(m) end end)
        end
    end
})

local espDeadCivEnabled = false
local deadCivHighlights = {}
CityESP:Toggle({
    Title = "ESP Dead Civilians",
    Default = false,
    Callback = function(state)
        espDeadCivEnabled = state
        for _, hl in pairs(deadCivHighlights) do hl:Destroy() end
        table.clear(deadCivHighlights)
        if not espDeadCivEnabled then return end
        local function apply(part)
            if deadCivHighlights[part] or not (part:IsA("BasePart") or part:IsA("Model")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 255, 0); hl.OutlineColor = Color3.fromRGB(0, 255, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = part; hl.Parent = part
            deadCivHighlights[part] = hl
        end
        local folder = workspace:FindFirstChild("Section1") and workspace.Section1:FindFirstChild("DeadCivilians")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espDeadCivEnabled then apply(m) end end)
        end
    end
})

-- ==========================================
-- SCHOOL TAB
-- ==========================================
local SchoolMain = SchoolTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })
local SchoolESP = SchoolTab:CreateSubTab({ Title = "ESP", Icon = "eye" })

SchoolMain:Button({
    Title = "Grab Bandage",
    Description = "",
    Callback = function()
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            if reliable then pcall(function() reliable:FireServer("Section2/BandagePickedUp") end) end
        end)
    end
})

SchoolMain:Button({
    Title = "Heal Hideo",
    Description = "",
    Callback = function()
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            if reliable then pcall(function() reliable:FireServer("Section2/HideoHealed") end) end
        end)
    end
})

local autoUnlockDoorEnabled = false
SchoolMain:Toggle({
    Title = "Auto Unlock Door",
    Default = false,
    Callback = function(state)
        autoUnlockDoorEnabled = state
        if not autoUnlockDoorEnabled then return end
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            while autoUnlockDoorEnabled do
                if reliable then
                    local doorsFolder = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("School") and workspace.Section2.School:FindFirstChild("Doors") and workspace.Section2.School.Doors:FindFirstChild("ClassRoomDoors")
                    if doorsFolder then
                        for _, door in ipairs(doorsFolder:GetChildren()) do
                            if not autoUnlockDoorEnabled then break end
                            pcall(function() reliable:FireServer("Section2/RoomADoorSkillCheckDone", door) end)
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

local autoSpiderRemoteEnabled = false
SchoolMain:Toggle({
    Title = "Kill Aura Spiders",
    Default = false,
    Callback = function(state)
        autoSpiderRemoteEnabled = state
        if not autoSpiderRemoteEnabled then return end
        task.spawn(function()
            while autoSpiderRemoteEnabled do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local section2 = workspace:FindFirstChild("Section2")
                    local mainObjective2 = section2 and section2:FindFirstChild("MAINOBJECTIVE2")
                    local spidersFolder = mainObjective2 and mainObjective2:FindFirstChild("Spiders")
                    if spidersFolder then
                        for _, spider in ipairs(spidersFolder:GetChildren()) do
                            if not autoSpiderRemoteEnabled then break end
                            local hitbox = spider:FindFirstChild("Hitbox")
                            local remoteEvent = hitbox and hitbox:FindFirstChild("RemoteEvent")
                            if hitbox and remoteEvent then
                                local dist = (hrp.Position - hitbox.Position).Magnitude
                                if dist <= 30 then pcall(function() remoteEvent:FireServer() end) end
                            end
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
})

local espMonstersEnabled = false
local monsterHighlights = {}
local monsterBillboards = {}
SchoolESP:Toggle({
    Title = "ESP Monsters",
    Default = false,
    Callback = function(state)
        espMonstersEnabled = state
        for _, hl in pairs(monsterHighlights) do hl:Destroy() end
        for _, bb in pairs(monsterBillboards) do bb:Destroy() end
        table.clear(monsterHighlights); table.clear(monsterBillboards)
        if not espMonstersEnabled then return end
        local function apply(model)
            if monsterHighlights[model] or not model then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = model; hl.Parent = model
            monsterHighlights[model] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = model.Name
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
            monsterBillboards[model] = bb
        end
        local function checkAndApply()
            local s2 = workspace:FindFirstChild("Section2")
            if not s2 then return end
            local mf = s2:FindFirstChild("Monster"); if mf then local akari = mf:FindFirstChild("AkariNM"); if akari then apply(akari) end end
            local rf = s2:FindFirstChild("Rage"); if rf then local akariR = rf:FindFirstChild("AkariRageNM"); if akariR then apply(akariR) end end
        end
        checkAndApply()
        workspace.DescendantAdded:Connect(function(inst) if espMonstersEnabled and (inst.Name == "AkariNM" or inst.Name == "AkariRageNM") then apply(inst) end end)
    end
})

local espSpidersEnabled = false
local spiderHighlights = {}
SchoolESP:Toggle({
    Title = "ESP Spiders",
    Default = false,
    Callback = function(state)
        espSpidersEnabled = state
        for _, hl in pairs(spiderHighlights) do hl:Destroy() end
        table.clear(spiderHighlights)
        if not espSpidersEnabled then return end
        local function apply(spider)
            if spiderHighlights[spider] then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 100, 0); hl.OutlineColor = Color3.fromRGB(255, 100, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = spider; hl.Parent = spider
            spiderHighlights[spider] = hl
        end
        local folder = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("MAINOBJECTIVE2") and workspace.Section2.MAINOBJECTIVE2:FindFirstChild("Spiders")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espSpidersEnabled then apply(m) end end)
        end
    end
})

local espGruntsSchoolEnabled = false
local gruntSchoolHL = {}
SchoolESP:Toggle({
    Title = "ESP Grunts (School)",
    Default = false,
    Callback = function(state)
        espGruntsSchoolEnabled = state
        for _, hl in pairs(gruntSchoolHL) do hl:Destroy() end
        table.clear(gruntSchoolHL)
        if not espGruntsSchoolEnabled then return end
        local function apply(model)
            if gruntSchoolHL[model] or not model:IsA("Model") then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = model; hl.Parent = model
            gruntSchoolHL[model] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = model.Name
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
        end
        local folder = workspace:FindFirstChild("Section2") and workspace.Section2:FindFirstChild("Grunts")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espGruntsSchoolEnabled then apply(m) end end)
        end
    end
})

-- ==========================================
-- FOREST TAB
-- ==========================================
local ForestMain = ForestTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })
local ForestESP = ForestTab:CreateSubTab({ Title = "ESP", Icon = "eye" })

local autoCircuitEnabled = false
local connections = {}
local function executeHack()
    if not autoCircuitEnabled then return end
    local RS = game:GetService("ReplicatedStorage")
    local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
    local reliable = packet and packet:FindFirstChild("Reliable")
    if not reliable then return end
    task.spawn(function()
        local timeout = tick() + 5
        local circuitsFolder
        repeat
            local section3 = workspace:FindFirstChild("Section3")
            local objective = section3 and section3:FindFirstChild("OBJECTIVE")
            circuitsFolder = objective and objective:FindFirstChild("Circuits")
            if not circuitsFolder then task.wait(0.1) end
        until circuitsFolder or not autoCircuitEnabled or tick() > timeout
        if not circuitsFolder then return end
        for _, circuit in ipairs(circuitsFolder:GetChildren()) do
            local promptPart = circuit:FindFirstChild("PromptPart")
            if promptPart then
                task.spawn(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local originalCFrame = hrp and hrp.CFrame
                    for i = 1, 3 do
                        if not autoCircuitEnabled then break end
                        pcall(function() reliable:FireServer("Section3/CircuitRoundComplete", circuit) end)
                        task.wait(0.15)
                    end
                    task.wait(0.2)
                    if autoCircuitEnabled and hrp and char.Parent then
                        char:PivotTo(CFrame.new(-3585, 8, 248))
                        task.wait(0.3)
                        if originalCFrame and char.Parent then char:PivotTo(originalCFrame) end
                    end
                end)
            end
        end
    end)
end

ForestMain:Toggle({
    Title = "Auto Fix Generator",
    Default = false,
    Callback = function(state)
        autoCircuitEnabled = state
        for _, conn in ipairs(connections) do pcall(function() conn:Disconnect() end) end
        table.clear(connections)
        if not autoCircuitEnabled then return end
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end
        local function checkGui(gui) if gui.Name == "CircuitsMinigame" then executeHack() end end
        local existing = playerGui:FindFirstChild("CircuitsMinigame")
        if existing then executeHack() end
        table.insert(connections, playerGui.ChildAdded:Connect(checkGui))
    end
})

local espGeneratorsEnabled = false
local genHighlights = {}
ForestESP:Toggle({
    Title = "ESP Generators",
    Default = false,
    Callback = function(state)
        espGeneratorsEnabled = state
        for _, hl in pairs(genHighlights) do hl:Destroy() end
        table.clear(genHighlights)
        if not espGeneratorsEnabled then return end
        local function apply(obj)
            if genHighlights[obj] or not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 255, 0); hl.OutlineColor = Color3.fromRGB(0, 255, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = obj; hl.Parent = obj
            genHighlights[obj] = hl
        end
        local folder = workspace:FindFirstChild("Section3") and workspace.Section3:FindFirstChild("OBJECTIVE") and workspace.Section3.OBJECTIVE:FindFirstChild("Circuits")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espGeneratorsEnabled then apply(m) end end)
        end
    end
})

local espForestMonsterEnabled = false
local forestMonsterHL, forestMonsterBB
ForestESP:Toggle({
    Title = "ESP Monster",
    Default = false,
    Callback = function(state)
        espForestMonsterEnabled = state
        if forestMonsterHL then forestMonsterHL:Destroy() forestMonsterHL = nil end
        if forestMonsterBB then forestMonsterBB:Destroy() forestMonsterBB = nil end
        if not espForestMonsterEnabled then return end
        local function apply(model)
            if forestMonsterHL then return end
            forestMonsterHL = Instance.new("Highlight")
            forestMonsterHL.FillColor = Color3.fromRGB(255, 0, 0); forestMonsterHL.OutlineColor = Color3.fromRGB(0, 0, 0)
            forestMonsterHL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; forestMonsterHL.Adornee = model; forestMonsterHL.Parent = model
            forestMonsterBB = Instance.new("BillboardGui")
            forestMonsterBB.Size = UDim2.new(0, 200, 0, 50); forestMonsterBB.StudsOffset = Vector3.new(0, 3, 0); forestMonsterBB.AlwaysOnTop = true; forestMonsterBB.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = "MizunoNM"
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = forestMonsterBB
        end
        local s3 = workspace:FindFirstChild("Section3")
        local mf = s3 and s3:FindFirstChild("Monster")
        local mizuno = mf and mf:FindFirstChild("MizunoNM")
        if mizuno then apply(mizuno) end
        workspace.DescendantAdded:Connect(function(inst) if espForestMonsterEnabled and inst.Name == "MizunoNM" then apply(inst) end end)
    end
})

-- ==========================================
-- IJO TAB
-- ==========================================
local IJOMain = IJOTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })
local IJOESP = IJOTab:CreateSubTab({ Title = "ESP", Icon = "eye" })

IJOMain:Button({
    Title = "Auto Password Laptop",
    Description = "",
    Callback = function()
        task.spawn(function()
            local s4 = workspace:FindFirstChild("Section4")
            local lab = s4 and s4:FindFirstChild("Lab")
            local floor1 = lab and lab:FindFirstChild("Floor1")
            local objective = floor1 and floor1:FindFirstChild("Objective")
            local stickyNote = objective and objective:FindFirstChild("StickyNote")
            local passwordObj = stickyNote and stickyNote:FindFirstChild("PASSWORD")
            local surfaceGui = passwordObj and passwordObj:FindFirstChild("SurfaceGui")
            local randomNumberLabel = surfaceGui and surfaceGui:FindFirstChild("RandomNumber")
            if randomNumberLabel and randomNumberLabel:IsA("TextLabel") then
                local password = randomNumberLabel.Text
                local RS = game:GetService("ReplicatedStorage")
                local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
                local reliable = packet and packet:FindFirstChild("Reliable")
                if reliable then pcall(function() reliable:FireServer("Section4/LaptopSubmit", password) end) end
            end
        end)
    end
})

IJOMain:Button({
    Title = "Auto Shape Terminal",
    Description = "",
    Callback = function()
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            local s4 = workspace:FindFirstChild("Section4")
            local lab = s4 and s4:FindFirstChild("Lab")
            local cleanseRoom = lab and lab:FindFirstChild("CleanseRoomObjective")
            local terminals = cleanseRoom and cleanseRoom:FindFirstChild("ShapeTerminals")
            if reliable and terminals then
                local terminalList = {}
                for _, terminal in ipairs(terminals:GetChildren()) do
                    if (terminal:IsA("Model") or terminal:IsA("BasePart")) and terminal.Name ~= "ControlSystemOnline" then
                        table.insert(terminalList, terminal)
                    end
                end
                table.sort(terminalList, function(a, b) return (tonumber(a.Name:match("%d+")) or 0) < (tonumber(b.Name:match("%d+")) or 0) end)
                for _, terminal in ipairs(terminalList) do
                    pcall(function()
                        reliable:FireServer("ShapeTerminal/RoundComplete", terminal)
                        task.wait(0.1)
                        reliable:FireServer("ShapeTerminal/RoundComplete", terminal)
                        task.wait(0.1)
                        reliable:FireServer("ShapeTerminal/Release", terminal)
                    end)
                    task.wait(0.2)
                end
            end
        end)
    end
})

IJOMain:Button({
    Title = "Auto Skill Hit",
    Description = "",
    Callback = function()
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            if reliable then
                for i = 1, 2 do
                    pcall(function() reliable:FireServer("Section4/LockdownSkillCheckHit") end)
                    task.wait(0.1)
                end
            end
        end)
    end
})

local espBoulderC4Enabled = false
local boulderHighlights = {}
IJOESP:Toggle({
    Title = "ESP Boulder Seal & C4",
    Default = false,
    Callback = function(state)
        espBoulderC4Enabled = state
        for _, hl in pairs(boulderHighlights) do hl:Destroy() end
        table.clear(boulderHighlights)
        if not espBoulderC4Enabled then return end
        local function apply(obj)
            if boulderHighlights[obj] or not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 255, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = obj; hl.Parent = obj
            boulderHighlights[obj] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = obj
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = obj.Name
            tl.TextColor3 = Color3.fromRGB(0, 255, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
        end
        local s4 = workspace:FindFirstChild("Section4")
        local f1 = s4 and s4:FindFirstChild("Lab") and s4.Lab:FindFirstChild("Floor1")
        if f1 then
            local obj2 = f1:FindFirstChild("Objective2")
            local boulder = obj2 and obj2:FindFirstChild("C4Explode") and obj2.C4Explode:FindFirstChild("BoulderSeal")
            if boulder then apply(boulder) end
            local obj3 = f1:FindFirstChild("Objective3")
            local c4Explode3 = obj3 and obj3:FindFirstChild("C4Explode")
            if c4Explode3 then
                for _, m in ipairs(c4Explode3:GetChildren()) do apply(m) end
                c4Explode3.ChildAdded:Connect(function(m) if espBoulderC4Enabled then apply(m) end end)
            end
        end
    end
})

local espLabMonsterEnabled = false
local labMonsterHL = {}
IJOESP:Toggle({
    Title = "ESP Lab Monster",
    Default = false,
    Callback = function(state)
        espLabMonsterEnabled = state
        for _, hl in pairs(labMonsterHL) do hl:Destroy() end
        table.clear(labMonsterHL)
        if not espLabMonsterEnabled then return end
        local function apply(model)
            if labMonsterHL[model] or not (model:IsA("Model") or model:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = model; hl.Parent = model
            labMonsterHL[model] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = model.Name
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
        end
        local folder = workspace:FindFirstChild("Section4") and workspace.Section4:FindFirstChild("Monster")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espLabMonsterEnabled then apply(m) end end)
        end
    end
})

local espTerminalValveEnabled = false
local objHighlights = {}
IJOESP:Toggle({
    Title = "ESP Terminal & Valve",
    Default = false,
    Callback = function(state)
        espTerminalValveEnabled = state
        for _, hl in pairs(objHighlights) do hl:Destroy() end
        table.clear(objHighlights)
        if not espTerminalValveEnabled then return end
        local function apply(obj)
            if objHighlights[obj] or not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 255, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = obj; hl.Parent = obj
            objHighlights[obj] = hl
        end
        local function setup(folder)
            if not folder then return end
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espTerminalValveEnabled then apply(m) end end)
        end
        local s4 = workspace:FindFirstChild("Section4")
        local cleanse = s4 and s4:FindFirstChild("Lab") and s4.Lab:FindFirstChild("CleanseRoomObjective")
        if cleanse then
            setup(cleanse:FindFirstChild("Valves"))
            setup(cleanse:FindFirstChild("ShapeTerminals"))
        end
    end
})

-- ==========================================
-- WATER TAB
-- ==========================================
local WaterMain = WaterTab:CreateSubTab({ Title = "Main", Icon = "gamepad-2", Default = true })
local WaterESP = WaterTab:CreateSubTab({ Title = "ESP", Icon = "eye" })

local autoShootBlocksEnabled = false
WaterMain:Toggle({
    Title = "Auto Shoot Blocks",
    Default = false,
    Callback = function(state)
        autoShootBlocksEnabled = state
        if not autoShootBlocksEnabled then return end
        task.spawn(function()
            while autoShootBlocksEnabled do
                local section5 = workspace:FindFirstChild("Section5")
                local stairs = section5 and section5:FindFirstChild("StairsSection")
                local fleshBlock = stairs and stairs:FindFirstChild("FleshBlock")
                if fleshBlock then
                    for _, block in ipairs(fleshBlock:GetChildren()) do
                        if not autoShootBlocksEnabled then break end
                        local body = block:FindFirstChild("body")
                        local remote = body and body:FindFirstChild("RemoteEvent")
                        if remote then pcall(function() remote:FireServer() end) end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
})

local autoShootHogoEnabled = false
WaterMain:Toggle({
    Title = "Auto Shoot HogoGuntai",
    Default = false,
    Callback = function(state)
        autoShootHogoEnabled = state
        if not autoShootHogoEnabled then return end
        task.spawn(function()
            while autoShootHogoEnabled do
                local section5 = workspace:FindFirstChild("Section5")
                local stairs = section5 and section5:FindFirstChild("StairsSection")
                local monster = stairs and stairs:FindFirstChild("Monster")
                local hogo = monster and monster:FindFirstChild("HogoGuntai")
                if hogo then
                    local remote = hogo:FindFirstChild("RemoteEvent") or hogo:FindFirstChildWhichIsA("RemoteEvent", true)
                    if remote then pcall(function() remote:FireServer() end) end
                end
                task.wait(0.05)
            end
        end)
    end
})

WaterMain:Button({
    Title = "Auto Wirebox",
    Description = "",
    Callback = function()
        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local packet = RS:FindFirstChild("modules") and RS.modules:FindFirstChild("Packet")
            local reliable = packet and packet:FindFirstChild("Reliable")
            if not reliable then return end
            local function GetNil(Name)
                local ok, instances = pcall(getnilinstances)
                if ok and instances then
                    for _, Object in ipairs(instances) do
                        if Object.Name == Name then return Object end
                    end
                end
                return nil
            end
            local section5 = workspace:FindFirstChild("Section5")
            local mainObjective = section5 and section5:FindFirstChild("MainObjective")
            local boxesFolder = mainObjective and mainObjective:FindFirstChild("Boxes")
            if boxesFolder then
                local wireBoxes = {}
                for _, box in ipairs(boxesFolder:GetChildren()) do
                    if box.Name == "WireBox" then table.insert(wireBoxes, box) end
                end
                for _, wireBox in ipairs(wireBoxes) do
                    pcall(function() reliable:FireServer("Section5/WireBoxClaim", wireBox) end)
                    local screw = wireBox:FindFirstChild("Screw", true) or GetNil("Screw")
                    if screw then pcall(function() reliable:FireServer("Section5/WireBoxScrewDone", screw) end) end
                    local lid = wireBox:FindFirstChild("Lid", true) or GetNil("Lid")
                    if lid then pcall(function() reliable:FireServer("Section5/WireBoxLidOpen", lid) end) end
                    local cuttable = wireBox:FindFirstChild("Cuttable")
                    if cuttable then
                        for _, cutItem in ipairs(cuttable:GetChildren()) do
                            pcall(function() reliable:FireServer("Section5/WireBoxCutDone", cutItem) end)
                        end
                    end
                    pcall(function() reliable:FireServer("Section5/WireBoxComplete", wireBox) end)
                end
            end
        end)
    end
})

local espPowerSwitchEnabled = false
local psHighlight
WaterESP:Toggle({
    Title = "ESP Power Switch",
    Default = false,
    Callback = function(state)
        espPowerSwitchEnabled = state
        if psHighlight then psHighlight:Destroy() psHighlight = nil end
        if not espPowerSwitchEnabled then return end
        local ps = workspace:FindFirstChild("Section5") and workspace.Section5:FindFirstChild("MainObjective") and workspace.Section5.MainObjective:FindFirstChild("PowerSwitch")
        if ps then
            psHighlight = Instance.new("Highlight")
            psHighlight.FillColor = Color3.fromRGB(0, 255, 0); psHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            psHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; psHighlight.Adornee = ps; psHighlight.Parent = ps
        end
    end
})

local espWaterMonsterEnabled = false
local waterMonsterHL = {}
WaterESP:Toggle({
    Title = "ESP Monster",
    Default = false,
    Callback = function(state)
        espWaterMonsterEnabled = state
        for _, hl in pairs(waterMonsterHL) do hl:Destroy() end
        table.clear(waterMonsterHL)
        if not espWaterMonsterEnabled then return end
        local function apply(model)
            if waterMonsterHL[model] or not (model:IsA("Model") or model:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(255, 0, 0); hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = model; hl.Parent = model
            waterMonsterHL[model] = hl
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Parent = model
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = model.Name
            tl.TextColor3 = Color3.fromRGB(255, 0, 0); tl.TextStrokeTransparency = 0; tl.TextSize = 13
            tl.Font = Enum.Font.FredokaOne; tl.Parent = bb
        end
        local folder = workspace:FindFirstChild("Section5") and workspace.Section5:FindFirstChild("Monster")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espWaterMonsterEnabled then apply(m) end end)
        end
    end
})

local espBoxesEnabled = false
local boxHighlights = {}
WaterESP:Toggle({
    Title = "ESP Boxes",
    Default = false,
    Callback = function(state)
        espBoxesEnabled = state
        for _, hl in pairs(boxHighlights) do hl:Destroy() end
        table.clear(boxHighlights)
        if not espBoxesEnabled then return end
        local function apply(obj)
            if boxHighlights[obj] or not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 255, 0); hl.OutlineColor = Color3.fromRGB(0, 255, 0)
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = obj; hl.Parent = obj
            boxHighlights[obj] = hl
        end
        local folder = workspace:FindFirstChild("Section5") and workspace.Section5:FindFirstChild("MainObjective") and workspace.Section5.MainObjective:FindFirstChild("Boxes")
        if folder then
            for _, m in ipairs(folder:GetChildren()) do apply(m) end
            folder.ChildAdded:Connect(function(m) if espBoxesEnabled then apply(m) end end)
        end
    end
})
