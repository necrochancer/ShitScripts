local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LopticaWaitTime = 0.1


local function TpDoGenerator()
    local Geneators = workspace:WaitForChild("Map") and workspace.Map:WaitForChild("Ingame") and workspace.Map.Ingame:WaitForChild("Map")
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
            for _ = 1, 6 do
                task.wait(LopticaWaitTime / 5)
                g.Remotes.RE:FireServer()
            end
            task.wait(LopticaWaitTime / 5)
            g.Remotes.RF:InvokeServer("leave")
        end
    end

    if lastPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lastPosition
    end
end

local function teleportToRandomServer()
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
                    TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
                end
            end
        end
    end
end

local function Main()
    if Players.LocalPlayer.PlayerGui:WaitForChild("RoundTimer"):WaitForChild("Main"):WaitForChild("Title").Text == "Round ends in:" then
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/autofarm.lua'))()")
        teleportToRandomServer()
    else
        TpDoGenerator()
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/refs/heads/main/autofarm.lua'))()")
        teleportToRandomServer()
    end
end

Main()
