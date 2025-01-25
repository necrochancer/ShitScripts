--if getgenv then
--    getgenv().DebugNotifications = false -- Use this only if you need to
--end

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local DebugNotifications = getgenv and getgenv().DebugNotifications or false
local VirtualBallsManager = game:GetService('VirtualInputManager')
local BlockRemote = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent
local RunService = game:GetService("RunService")
local SigmaData, JoinedSigmaServer = {}, false
local HttpService = game:GetService("HttpService")
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()
local GUI, PlayerTab, VisualsTab, GeneratorTab, BlatantTab, BabyShark, KillerFartPart, HRP, SkibidiDistance, BlockEnabled = Mercury:Create{ Name = "FartSaken", Size = UDim2.fromOffset(600, 400), Theme = Mercury.Themes.Dark, Link = "https://github.com/ivannetta/ShitScripts/Forsaken" }, nil, nil, nil, nil, nil, nil, nil, 6, false
local executorname = (pcall(function() return getexecutorname() end) and getexecutorname()) or (pcall(function() return identifyexecutor() end) and identifyexecutor()) or "Unknown"
local supportedExecutors = { AWP = true, Wave = true, Nihon = true, ["Synapse Z"] = true, Swift = true }
local SoundList = {"rbxassetid://112809109188560", "rbxassetid://101199185291628", "rbxassetid://102228729296384", "rbxassetid://140242176732868"}
local CurrentFartsActive, processedGenerators =  {}, {}

GUI:Notification{
    Title = supportedExecutors[executorname] and "Executor Supported" or "Executor Not Supported",
    Text = supportedExecutors[executorname] and "No Errors Expected" or "Errors Expected",
    Duration = 5
}

local highlightingEnabled, SkibidiStaminaLoop, running, ItemFartsEnabled, Do1x1PopupsLoop, SkibidiWait, LopticaWaitTime = false, false, false, false, false, 0.5, 0.5
local generatorHighlightColor, survivorHighlightColor, killerHighlightColor, itemHighlightColor = Color3.fromRGB(173, 162, 236), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 255, 0)

local Items = {"Medkit", "BloxyCola", "Bunny", "Mafioso1", "Mafioso2", "Mafioso3", "Shockwave"}

local function LoadSigmaData()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local data = HttpService:JSONDecode(readfile("FartHub.json"))
        generatorHighlightColor = data.ColorOptions.Generator and Color3.fromHex(data.ColorOptions.Generator) or Color3.fromRGB(255, 0, 0)
        survivorHighlightColor = data.ColorOptions.Survivor and Color3.fromHex(data.ColorOptions.Survivor) or Color3.fromRGB(0, 255, 0)
        killerHighlightColor = data.ColorOptions.Killer and Color3.fromHex(data.ColorOptions.Killer) or Color3.fromRGB(0, 0, 255)
        itemHighlightColor = data.ColorOptions.Item and Color3.fromHex(data.ColorOptions.Item) or Color3.fromRGB(255, 255, 0)
        JoinedSigmaServer = data.Info.JoinedSigmaServer or false
        SigmaData = data
    end)
end

local function WriteSigmaData()
    local HttpService = game:GetService("HttpService")
    SigmaData.ColorOptions = {
        Generator = generatorHighlightColor:ToHex(),
        Survivor = survivorHighlightColor:ToHex(),
        Killer = killerHighlightColor:ToHex(),
        Item = itemHighlightColor:ToHex()
    }
    SigmaData.Info = SigmaData.Info or {}
    SigmaData.Info.JoinedSigmaServer = JoinedSigmaServer

    writefile("FartHub.json", HttpService:JSONEncode(SigmaData))
end

LoadSigmaData()

-- Toggle ESP
local function ToggleFarts(state)
    highlightingEnabled = state
    local localPlayer = game.Players.LocalPlayer
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") then
            if DebugNotifications then GUI:Notification{Title = "Highlight deleted", Text = (pcall(function() return obj:GetFullName() end) and obj:GetFullName() or "Deleted"), Duration = 3} else end
            obj:Destroy()
        end
    end
    if not state then return end
    local function AddFart(object, color)
        if object:IsA("Model") and object ~= localPlayer.Character and not object:FindFirstChildOfClass("Highlight") then
            local h = Instance.new("Highlight", object)
            if DebugNotifications then GUI:Notification{Title = "Highlight added", Text  = (pcall(function() return h:GetFullName() end) and h:GetFullName() or "Deleted"), Duration = 3} else end
            h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.7, 0.6
        end
    end
    for _, folder in ipairs({workspace.Players.Survivors, workspace.Players.Killers}) do
        for _, obj in ipairs(folder:GetChildren()) do
            AddFart(obj, folder.Name == "Survivors" and survivorHighlightColor or killerHighlightColor)
        end
        folder.ChildAdded:Connect(function(child)
            if highlightingEnabled then
                AddFart(child, folder.Name == "Survivors" and survivorHighlightColor or killerHighlightColor)
            end
        end)
    end
    local function SetupSigmaListener()
        local ingameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
        if not ingameFolder then return end
        local mapFolder = ingameFolder:FindFirstChild("Map")
        if not mapFolder then return end
        for _, g in ipairs(mapFolder:GetChildren()) do
            if g.Name == "Generator" then AddFart(g, generatorHighlightColor) end
        end
        mapFolder.ChildAdded:Connect(function(child)
            if highlightingEnabled and child.Name == "Generator" then
                AddFart(child, generatorHighlightColor)
            end
        end)
    end
    SetupSigmaListener()
    workspace.Map.ChildAdded:Connect(function(child)
        if highlightingEnabled then
            SetupSigmaListener()
        end
    end)
    workspace.Map.Ingame.ChildAdded:Connect(function(child)
        if highlightingEnabled then
            SetupSigmaListener()
        end
    end)
end
local function ToggleSigmaItemsHighlights(state)
    ItemFartsEnabled = state
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") and table.find(Items, obj.Parent.Name) then
            if DebugNotifications then GUI:Notification{Title = "Highlight deleted", Text = (pcall(function() return obj:GetFullName() end) and obj:GetFullName() or "Deleted"), Duration = 3} else end
            task.wait(.1)
            obj:Destroy()
        end
    end
    if not state then return end
    local function AddLopticaHighlight(object, color)
        if object:IsA("BasePart") and object.Parent:IsA("Model") and not object:FindFirstChildOfClass("Highlight") then
            local h = Instance.new("Highlight", object)
            h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.7, 0.6
            if DebugNotifications then GUI:Notification{Title = "Highlight added", Text = (pcall(function() return h:GetFullName() end) and h:GetFullName() or "Added"), Duration = 3} else end
        end
    end
    for _, item in ipairs(Items) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == item then
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("BasePart") then
                        AddLopticaHighlight(child, itemHighlightColor)
                    end
                end
            end
        end
    end
    workspace.DescendantAdded:Connect(function(descendant)
        if ItemFartsEnabled and descendant:IsA("Model") and table.find(Items, descendant.Name) then
            for _, child in ipairs(descendant:GetChildren()) do
                if child:IsA("BasePart") then
                    AddLopticaHighlight(child, itemHighlightColor)
                end
            end
        end
    end)
end

-- change esp colors



local function Do1x1x1x1Popups()
    while true do
        if Do1x1PopupsLoop then
            local player = game:GetService("Players").LocalPlayer
            local popups = player.PlayerGui.TemporaryUI:GetChildren()

            for _, i in ipairs(popups) do
                if i.Name == "1x1x1x1Popup" then
                    local centerX = i.AbsolutePosition.X + (i.AbsoluteSize.X / 2)
                    local centerY = i.AbsolutePosition.Y + (i.AbsoluteSize.Y / 2)
                    if DebugNotifications then GUI:Notification{Title = "1x1x1x1 Popup Closed", Text = (pcall(function() return i:GetFullName() end) and i:GetFullName() or "Closed"), Duration = 3} else end
                    VirtualBallsManager:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, true, player.PlayerGui, 1)
                    VirtualBallsManager:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, false, player.PlayerGui, 1)
                end
            end
        end
        task.wait(0.1)
    end
end

local function SkibidiGenerator(shouldLoop)
    repeat
        if not running then break end
        local FartIngameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
        local FartNapFolder = FartIngameFolder and FartIngameFolder:FindFirstChild("Map")
        if FartNapFolder then
            for _, g in ipairs(FartNapFolder:GetChildren()) do
                if g.Name == "Generator" and g.Progress.Value < 100 then
                    g.Remotes.RE:FireServer()
                    if DebugNotifications then
                        GUI:Notification{Title = "Generator Done", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Generator Done"), Duration = 3}
                    end
                end
            end
        end
        if shouldLoop then task.wait(SkibidiWait) end
    until not shouldLoop
end


local function TpDoGenerator()
    local lastPosition = Players.LocalPlayer.Character.HumanoidRootPart.CFrame

    local function findGenerators()
        local folder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
        local map = folder and folder:FindFirstChild("Map")
        local generators = {}
        if map then
            for _, g in ipairs(map:GetChildren()) do
                if g.Name == "Generator" and g.Progress.Value < 100 then
                    table.insert(generators, g)
                end
            end
        end
        return generators
    end

    while true do
        local generators = findGenerators()
        if #generators == 0 then break end
        for _, g in ipairs(generators) do
            local player = game.Players.LocalPlayer
            local generatorPosition = g.Instances.Generator.Progress.CFrame.Position
            local generatorDirection = (g.Instances.Generator.Cube.CFrame.Position - generatorPosition).Unit
            player.Character.HumanoidRootPart.CFrame = CFrame.new(generatorPosition + Vector3.new(0, 0.5, 0), generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z))
            task.wait(LopticaWaitTime / 2)
            fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
            task.wait(LopticaWaitTime / 2)
            if DebugNotifications then
                GUI:Notification{Title = "Teleported to Generator", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Teleported"), Duration = 3}
            end
            for _ = 1, 6 do
                fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
                g.Remotes.RE:FireServer()
            end
            task.wait(LopticaWaitTime)
        end
    end

    if lastPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lastPosition
    end
end

local function InjectRobux(sound)
    while sound.Parent and BlockEnabled do
        local success, err = pcall(function()
            HRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if HRP and KillerFartPart and KillerFartPart.Parent then
                local killerHRP = KillerFartPart.Parent:FindFirstChild("HumanoidRootPart")
                if killerHRP then
                    local directionToPlayer = (HRP.Position - killerHRP.Position).Unit
                    local killerLookVector = killerHRP.CFrame.LookVector
                    local dotProduct = directionToPlayer:Dot(killerLookVector)
                    if dotProduct > 0.5 then
                        local distance = (KillerFartPart.Position - HRP.Position).Magnitude
                        if distance < SkibidiDistance then
                            BlockRemote:FireServer("UseActorAbility", "Block")
                            return
                        end
                    end
                end
            end
        end)
        if not success then GUI:Notification{Title = "An error occurred!", Text = err, Duration = 10} end
        task.wait(0.1)
    end
    CurrentFartsActive[sound] = nil
end


local function HawkTuah()
    if not BlockEnabled then return end
    local success, err = pcall(function()
        BabyShark = workspace:WaitForChild("Players"):FindFirstChild("Killers")
        BabyShark = BabyShark and BabyShark:GetChildren()[1] or nil
        KillerFartPart = BabyShark and BabyShark:FindFirstChild("HumanoidRootPart") or nil
    end)
    if not success then GUI:Notification{Title = "An error occured!", Text = err, Duration = 10} end
    
    if KillerFartPart then
        KillerFartPart.ChildAdded:Connect(function(descendant)
            if not BlockEnabled then return end
            local success, err = pcall(function()
                if descendant:IsA("Sound") and table.find(SoundList, descendant.SoundId) then
                    if not CurrentFartsActive[descendant] then
                        CurrentFartsActive[descendant] = true
                        task.spawn(InjectRobux, descendant)
                    end
                end
            end)
            if not success then GUI:Notification{Title = "An error occured!", Text = err, Duration = 10} end
        end)
    end
end

game:GetService("Players").ChildAdded:Connect(function(child)
    if not BlockEnabled then return end
    local success, err = pcall(function()
        if child.Name == "Killers" then HawkTuah() end
    end)
    if not success then GUI:Notification{Title = "An error occured!", Text = err, Duration = 10} end
end)

game:GetService("Players").ChildRemoved:Connect(function(child)
    if not BlockEnabled then return end
    local success, err = pcall(function()
        if child.Name == "Killers" then HawkTuah() end
    end)
    if not success then GUI:Notification{Title = "An error occured!", Text = err, Duration = 10} end
end)

local function ToggleFart(state)
    SkibidiStaminaLoop = state
    local success, SkibidiSprinting = pcall(function() return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting) end)

    if not success then
        if DebugNotifications then
            GUI:Notification{
                Title = "Error",
                Text = "Your executor doesn't support this.",
                Duration = 5
            }
        end
        return
    end

    while SkibidiStaminaLoop do
        SkibidiSprinting.StaminaLossDisabled = function() end
        task.wait(1)
    end

    SkibidiSprinting.StaminaLossDisabled = nil
end

local function SetProximity()
    local success, err = pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
    end)
    if not success and DebugNotifications then
        GUI:Notification{Title = "Error", Text = err, Duration = 5}
    end
end

local function ToggleSigmaItemsHighlights(state)
    ItemFartsEnabled = state
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") and table.find(Items, obj.Parent.Name) then
            if DebugNotifications then GUI:Notification{Title = "Highlight deleted", Text = (pcall(function() return obj:GetFullName() end) and obj:GetFullName() or "Deleted"), Duration = 3} else end
            task.wait(.1)
            obj:Destroy()
        end
    end
    if not state then return end
    local function AddLopticaHighlight(object, color)
        if object:IsA("BasePart") and object.Parent:IsA("Model") and not object:FindFirstChildOfClass("Highlight") then
            local h = Instance.new("Highlight", object)
            h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.7, 0.6
            if DebugNotifications then GUI:Notification{Title = "Highlight added", Text = (pcall(function() return h:GetFullName() end) and h:GetFullName() or "Added"), Duration = 3} else end
        end
    end
    for _, item in ipairs(Items) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == item then
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("BasePart") then
                        AddLopticaHighlight(child, itemHighlightColor)
                    end
                end
            end
        end
    end
    workspace.DescendantAdded:Connect(function(descendant)
        if ItemFartsEnabled and descendant:IsA("Model") and table.find(Items, descendant.Name) then
            for _, child in ipairs(descendant:GetChildren()) do
                if child:IsA("BasePart") then
                    AddLopticaHighlight(child, itemHighlightColor)
                end
            end
        end
    end)
end

local function UpdateFarts()
    ToggleFarts(false)
    ToggleFarts(true)
    ToggleSigmaItemsHighlights(false)
    ToggleSigmaItemsHighlights(true)
end

local function InitializeGUI()
    GeneratorTab = GUI:Tab{Name = "Generators", Icon = "rbxassetid://12549056837"}
    VisualsTab = GUI:Tab{Name = "Visuals", Icon = "rbxassetid://129972183138590"}
    PlayerTab = GUI:Tab{Name = "Player", Icon = "rbxassetid://86412006218107"}
    BlatantTab = GUI:Tab{Name = "Blatant", Icon = "rbxassetid://17183582911"}

    GUI:Credit{Name = "ivannetta", Description = "meowzer", Discord = "ivannetta"}
    GUI:Notification{Title = "NOTE: Default Keybinds:", Text = "DEL to minimize.", Duration = 10}
    GUI:Notification{Title = "NOTE: Auto Block Is In BETA!!!:", Text = "This has NOT been tested much so DONT rely on it.", Duration = 10}
    GUI:Notification{Title = "NOTE: Highlights Not Working Fix.", Text = "Reset ur bloxtrap settings.", Duration = 10}
    GUI:Notification{Title = "Made by ivannetta", Text = "Like on rbxscripts or rscripts plssssssss 🥺", Duration = 60}

    VisualsTab:ColorPicker{
        Style = Mercury.ColorPickerStyles.Legacy,
        Callback = function(color ) generatorHighlightColor = color UpdateFarts() end,
        Name = "Generator Highlight Color",
        Default = generatorHighlightColor
    }

    VisualsTab:ColorPicker{
        Style = Mercury.ColorPickerStyles.Legacy,
        Callback = function(color) survivorHighlightColor = color UpdateFarts() end,
        Name = "Survivor Highlight Color",
        Default = survivorHighlightColor
    }

    VisualsTab:ColorPicker{
        Style = Mercury.ColorPickerStyles.Legacy,
        Callback = function(color) killerHighlightColor = color UpdateFarts() end,
        Name = "Killer Highlight Color",
        Default = killerHighlightColor
    }

    VisualsTab:ColorPicker{
        Style = Mercury.ColorPickerStyles.Legacy,
        Callback = function(color) itemHighlightColor = color UpdateFarts() end,
        Name = "Item Highlight Color",
        Default = itemHighlightColor
    }

    VisualsTab:Toggle{
        Name = "Highlight Objects",
        Description = "Toggle highlights for objects in-game.",
        StartingState = false,
        Callback = function(state) ToggleFarts(state) ToggleSigmaItemsHighlights(state) end
    }

    PlayerTab:Button{
        Name = "Quick Proximity Prompts",
        Description = "Make Proximity Prompts Finish Instantly.",
        Callback = function() SetProximity() end
    }

    PlayerTab:Toggle{
        Name = "C00lkid Aimbot",
        Description = "Tell the game that ur on mobile so u get aimbot for free",
        StartingState = false,
        Callback = function(state) running = state game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer("SetDevice", state and "Mobile" or "PC") end
    }

    GeneratorTab:Toggle{
        Name = "Quick Generators",
        Description = "Do generators at pro speed.",
        StartingState = false,
        Callback = function(state)
            running = state
            if state then
                task.spawn(function() SkibidiGenerator(true) end)
            end
        end
    }

    GeneratorTab:Keybind{
        Name = "Do Current Generator.",
        Key = Enum.KeyCode.RightControl,
        Callback = function()
            task.spawn(function() SkibidiGenerator(false) end)
        end
    }

    PlayerTab:Toggle{
        Name = "Disable Stamina Drain",
        Description = "Disable stamina drain for sprinting.",
        StartingState = false,
        Callback = function(state) task.spawn(function() ToggleFart(state) end) end
    }

    PlayerTab:Toggle{
        Name = "Do 1x1x1x1 Popups",
        Description = "Does popups on its own.",
        StartingState = false,
        Callback = function(state) Do1x1PopupsLoop = state if state then task.spawn(Do1x1x1x1Popups) end end
    }

    GeneratorTab:Slider{
        Name = "Generator Speed",
        Description = "Change the speed of the generator.",
        Default = 0.5,
        Min = 0.1,
        Max = 10,
        Value = 0.5,
        Callback = function(value)
            SkibidiWait = value
        end
    }

    BlatantTab:Toggle{
        Name = "Auto Block",
        Description = "Automatically Use Block On Guest 1337, Currently only working on M1",
        StartingState = false,
        Callback = function(state)
            BlockEnabled = state
            local success, err = pcall(function()
                if BlockEnabled then
                    HawkTuah()
                end
            end)
            if not success then GUI:Notification{Title = "An error occured!", Text = err, Duration = 10} end
        end
    }

    BlatantTab:Button{
        Name = "Do ALL Generators",
        Description = "Teleport to all generators and do them.",
        Callback = function() TpDoGenerator() end
    }

    BlatantTab:Slider{
        Name = "Do ALL Generators Speed",
        Description = "Change the speed of how fast to teleport to the generator.",
        Default = 0.5,
        Min = 0.1,
        Max = 10,
        Callback = function(value)
            LopticaWaitTime = value
        end
    }

    BlatantTab:Slider{
        Name = "Auto Block Distance",
        Description = "Change Treshold Of Magnitude To Block Killer, Change if you know what ur doing.",
        Default = 6,
        Min = 1,
        Max = 20,
        Callback = function(value)
            SkibidiDistance = value
        end
    }
    if not JoinedSigmaServer then
        GUI:Prompt{
            Title = "Join Fart Hub discord server?",
            Text = "w-would you like to join our discord server? it would be very nice and sigma",
            Buttons = {
                Yes = function()
                    setclipboard("https://discord.gg/AC4usvpwVY")
                    GUI:Notification{Title = "Copied!", Text = "Discord link copied.", Duration = 3}
                    JoinedSigmaServer = true
                    WriteSigmaData()
                end,
                No = function() end
            }
        }
    end
end

InitializeGUI()
