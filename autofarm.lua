task.wait(5)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function findGenerators()
    print("Finding generators...")
    local folder = workspace:WaitForChild("Map") and workspace.Map:WaitForChild("Ingame")
    local map = folder and folder:WaitForChild("Map")
    local generators = {}
    if map then
        for _, g in ipairs(map:GetChildren()) do
            if g.Name == "Generator" and g.Progress.Value < 100 then
                table.insert(generators, g)
            end
        end
    end
    print("Generators found:", #generators)
    return generators
end

local function TpDoGenerator()
    print("Starting generator tasks...")
    local lastPosition = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    while true do
        local generators = findGenerators()
        if #generators == 0 then
            print("All generators completed.")
            return true
        end
        for _, g in ipairs(generators) do
            print("Teleporting to generator...")
            local player = game.Players.LocalPlayer
            local generatorPosition = g.Instances.Generator.Progress.CFrame.Position
            local generatorDirection = (g.Instances.Generator.Cube.CFrame.Position - generatorPosition).Unit
            player.Character.HumanoidRootPart.CFrame = CFrame.new(generatorPosition + Vector3.new(0, 0.5, 0), generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z))
            task.wait(0.3)
            print("Activating proximity prompt...")
            fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
            task.wait((0.1))
            for _ = 1, 6 do
                task.wait(0.1)
                g.Remotes.RE:FireServer()
            end
            task.wait(0.1)
            g.Remotes.RF:InvokeServer("leave")
            print("Generator task completed.")
        end
    end
    if lastPosition then
        print("Returning to last position...")
        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lastPosition
    end
    return true
end

local function teleportToRandomServer()
    print("Fetching server list...")
    local Request = http_request or syn.request or request
    if Request then
        local url = "https://games.roblox.com/v1/games/18687417158/servers/Public?sortOrder=Asc&limit=100"
        local success, response = pcall(function()
            return Request({
                Url = url,
                Method = "GET",
                Headers = { ["Content-Type"] = "application/json" }
            })
        end)
        if success and response and response.Body then
            local data = HttpService:JSONDecode(response.Body)
            if data and data.data and #data.data > 0 then
                local server = data.data[math.random(1, #data.data)]
                if server.id then
                    print("Teleporting to new server...")
                    TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
                end
            end
        end
    end
end

local function Main()
    print("Checking game state...")
    local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local roundTimer = playerGui and playerGui:FindFirstChild("RoundTimer")
    local main = roundTimer and roundTimer:FindFirstChild("Main")
    local title = main and main:FindFirstChild("Title")

    if not title then 
        print("Game UI not found, exiting...")
        return
    end

    print("Game status:", title.Text)
    if title.Text == "Round ends in:" then
        print("Round ending, queueing teleport...")
        local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
        if queueteleport then
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/autofarm.lua', true))()")
        end
        task.wait(1)
        teleportToRandomServer()
    else
        print("Starting generator tasks...")
        local generatorsDone = TpDoGenerator()
        if generatorsDone then
            print("All generators done, teleporting...")
            local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
            if queueteleport then
                    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/autofarm.lua', true))()")
            end
            task.wait(1)
            teleportToRandomServer()
        end
    end
end

Main()
