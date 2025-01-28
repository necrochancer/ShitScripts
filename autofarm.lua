task.wait(5)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function findGenerators()
    print("i look for generators")
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
    print("i found", #generators, "generators")
    return generators
end

local function TpDoGenerator()
    print("Starting generator tasks...")
    local lastPosition = Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    while true do
        local generators = findGenerators()
        if #generators == 0 then
            print("All generators completed.")
            task.wait(3)
            if #findGenerators() == 0 then
                print("Confirmed: All generators completed.")
                return true
            end
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
    local retryCount = 0
    local maxRetries = 10
    local retryDelay = 10

    print("i get servers")
    local Request = http_request or syn.request or request
    if Request then
        local url = "https://games.roblox.com/v1/games/18687417158/servers/Public?sortOrder=Asc&limit=100"

        while retryCount < maxRetries do
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
                        print("i teleport :shy:")
                        TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
                        return
                    end
                end
            end

            retryCount = retryCount + 1
            print("omg it fail, i retry (" .. retryCount .. "/" .. maxRetries .. ")...")
            task.wait(retryDelay)
        end

        print("grrrrrrrrr")
    end
end


local function Main()
    print("hmmmmmmm")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local roundTimer = playerGui and playerGui:WaitForChild("RoundTimer")
    local main = roundTimer and roundTimer:WaitForChild("Main")
    local title = main and main:WaitForChild("Title")

    print("game is", title.Text)
    if title.Text == "Round ends in:" then
        print("its ongoing so i leave")


    elseif title.Text == "Waiting for more players." then
        local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
        if queueteleport then
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/autofarm.lua', true))()")
        end
        task.wait(1)
        teleportToRandomServer()

    else
        print("i do generators")
        local generatorsDone = TpDoGenerator()
        if generatorsDone then
            print("yay i did the generators!")
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
