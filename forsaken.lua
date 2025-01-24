--if getgenv then
--    getgenv().DebugNotifications = false -- Use this only if you need to
--end

local SoundService = game:GetService("SoundService")
local DebugNotifications = getgenv and getgenv().DebugNotifications or false
local VirtualInputManager = game:GetService('VirtualInputManager')
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local GUI, PlayerTab, VisualsTab, GeneratorTab, BlatantTab = Mercury:Create{ Name = "Fart Hub : Forsaken", Size = UDim2.fromOffset(600, 400), Theme = Mercury.Themes.Dark, Link = "https://github.com/ivannetta" }, nil, nil, nil, nil
local executorname = (pcall(function() return getexecutorname() end) and getexecutorname()) or (pcall(function() return identifyexecutor() end) and identifyexecutor()) or "Unknown"
local supportedExecutors = { AWP = true, Wave = true, Nihon = true, ["Synapse Z"] = true, Swift = true }

GUI:Notification{
    Title = supportedExecutors[executorname] and "Executor Supported" or "Executor Not Supported",
    Text = supportedExecutors[executorname] and "No Errors Expected" or "Errors Expected",
    Duration = 5
}

local highlightingEnabled, SkibidiStaminaLoop, running, ItemFartsEnabled, Do1x1PopupsLoop, SkibidiWait, LopticaWaitTime = false, false, false, false, false, 0.5, 0.5
local generatorHighlightColor, survivorHighlightColor, killerHighlightColor, itemHighlightColor = Color3.fromRGB(173, 162, 236), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 255, 0)

local Items = {"Medkit", "BloxyCola", "Bunny", "Mafioso1", "Mafioso2", "Mafioso3", "Shockwave"}

local function UpdateFarts()
    local FartPlayers = workspace:FindFirstChild("Players")
    local SigmaGenerators = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
    local SigmaMap = SigmaGenerators and SigmaGenerators:FindFirstChild("Map")

    if FartPlayers then
        for _, g in ipairs(FartPlayers:GetDescendants()) do
            if g:IsA("Highlight") then
                local SkebedeName = g.Parent and g.Parent.Name
                if SkebedeName == "Survivor" then
                    g.FillColor = survivorHighlightColor
                    if DebugNotifications then GUI:Notification{Title = "Survivor Highlight Color Changed", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Color"), Duration = 3} else end
                elseif SkebedeName == "Killer" then
                    g.FillColor = killerHighlightColor
                    if DebugNotifications then GUI:Notification{Title = "Killer Highlight Color Changed", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Color"), Duration = 3} else end
                end
            end
        end
    end

    if SigmaMap then
        for _, g in ipairs(SigmaMap:GetDescendants()) do
            if g:IsA("Highlight") then
                g.FillColor = g.Parent and g.Parent.Name == "Generator" and generatorHighlightColor or itemHighlightColor
                GUI:Notification{Title = "Generator/Item Highlight Color Changed", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Color"), Duration = 3}
            end
        end
    end
end


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
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, true, player.PlayerGui, 1)
                    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, Enum.UserInputType.MouseButton1.Value, false, player.PlayerGui, 1)
                end
            end
        end
        task.wait(0.1)
    end
end

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
            h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.85, 0.5
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
            h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.85, 0.5
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

local function DoGenebator()
    running = true
    while running do
        local FartIngameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
        local FartNapFolder = FartIngameFolder and FartIngameFolder:FindFirstChild("Map")
        if FartNapFolder then
            for _, g in ipairs(FartNapFolder:GetChildren()) do
                if g.Name == "Generator" then
                    if g.Progress.Value < 100 then
                        g.Remotes.RE:FireServer()
                        if DebugNotifications then GUI:Notification{Title = "Generator Done", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Generator Done"), Duration = 3} else end
                    end
                end
            end
        end
        task.wait(SkibidiWait)
    end
end
local function TpDoGenerator()
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
            task.wait(LopticaWaitTime)
            fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
            if DebugNotifications then
                GUI:Notification{Title = "Teleported to Generator", Text = (pcall(function() return g:GetFullName() end) and g:GetFullName() or "Teleported"), Duration = 3}
            end
            for sigma = 1, 5 do
                g.Remotes.RE:FireServer()
            end
        end
    end
end


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

local function InitializeGUI()
    GeneratorTab = GUI:Tab{Name = "Generators", Icon = "rbxassetid://12549056837"}
    VisualsTab = GUI:Tab{Name = "Visuals", Icon = "rbxassetid://129972183138590"}
    PlayerTab = GUI:Tab{Name = "Player", Icon = "rbxassetid://86412006218107"}
    BlatantTab = GUI:Tab{Name = "Blatant", Icon = "rbxassetid://11197520961"}

    GUI:Credit{Name = "ivannetta", Description = "meowzer", Discord = "ivannetta"}
    GUI:Notification{Title = "NOTE: Default Keybinds:", Text = "DEL to minimize.", Duration = 10}
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
        Description = "Do generators at light speed.",
        StartingState = false,
        Callback = function(state) running = state if state then task.spawn(DoGenebator) end end
    }

    GeneratorTab:Keybind{
        Name = "Do Current Generator.",
        Key = Enum.KeyCode.RightControl,
        Callback = function() task.spawn(function() DoGenebator() end) end
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

    BlatantTab:Button{
        Name = "Fart",
        Description = "This is a highly bannable feature, use at your own risk.",

        Callback = function()
            local fartSound = Instance.new("Sound")
            fartSound.SoundId = "rbxassetid://8551016315"
            fartSound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            fartSound:Play()
        end
    }

    BlatantTab:Slider{
        Name = "Do ALL Generators Speed",
        Description = "Change the speed of how fast to teleport to the generator.",
        Default = 0.5,
        Min = 0.1,
        Max = 10,
        Value = 0.5,
        Callback = function(value)
            LopticaWaitTime = value
        end
    }

    GUI:Prompt{
        Title = "Join Fart Hub discord server?",
        Text = "w-would you like to join our discord server? it would be very nice and sigma",
        Buttons = {
            Yes = function()
                setclipboard("https://discord.gg/AC4usvpwVY")
                GUI:Notification{Title = "Copied!", Text = "Discord link copied.", Duration = 3}
            end,
            No = function() end
        }
    }
end

InitializeGUI()
