task.wait(5)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
if queueteleport then
	queueteleport(
		"loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/main/PathfindGens.lua'))()"
	)
end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "PathfindGens",
	Text = "Wait plsss",
	Duration = 10,
})

task.spawn(function()
	pcall(function()
		game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer(
			"UpdateSettings",
			game:GetService("Players").LocalPlayer.PlayerData.Settings.Game.MaliceDisabled,
			true
		)
	end)
end)

if _G.CancelPathEvent then
	_G.CancelPathEvent:Fire()
end

_G.CancelPathEvent = Instance.new("BindableEvent")

local Controller =
	require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
Controller:Disable()

local success, SkibidiSprinting = pcall(function()
	local a = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
	a.StaminaLossDisabled = nil
end)

local function teleportToRandomServer()
	local Counter = 0
	local MaxRetry = 10
	local RetryingDelays = 10

	local Request = http_request or syn.request or request
	if Request then
		local url = "https://games.roblox.com/v1/games/18687417158/servers/Public?sortOrder=Asc&limit=100"

		while Counter < MaxRetry do
			local success, response = pcall(function()
				return Request({
					Url = url,
					Method = "GET",
					Headers = { ["Content-Type"] = "application/json" },
				})
			end)

			if success and response and response.Body then
				local data = HttpService:JSONDecode(response.Body)
				if data and data.data and #data.data > 0 then
					local server = data.data[math.random(1, #data.data)]
					if server.id then
						TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
						return
					end
				end
			end

			Counter = Counter + 1
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Grahh",
				Text = "Serverhop got ratelimited im angry",
				Duration = 11,
			})
			task.wait(RetryingDelays)
		end
	end
end

task.delay(5, function()
	pcall(function()
		local timer = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("RoundTimer").Main.Time.ContentText
		local minutes, seconds = timer:match("(%d+):(%d+)")
		local totalSeconds = tonumber(minutes) * 60 + tonumber(seconds)
		print(totalSeconds .. " Left till round end.")
		if totalSeconds > 90 then
			teleportToRandomServer()
		end
	end)
end)


local function findGenerators()
	local folder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
	local map = folder and folder:FindFirstChild("Map")
	local generators = {}
	if map then
		for _, g in ipairs(map:GetChildren()) do
			if g.Name == "Generator" and g.Progress.Value < 100 then
				local playersNearby = false
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= Players.LocalPlayer and player:DistanceFromCharacter(g:GetPivot().Position) <= 25 then
						playersNearby = true
					end
				end
				if not playersNearby then
					table.insert(generators, g)
				end
			end
		end
	end

	table.sort(generators, function(a, b)
		local player = Players.LocalPlayer
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return false
		end
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local aPosition = a:IsA("Model") and a:GetPivot().Position or a.Position
		local bPosition = b:IsA("Model") and b:GetPivot().Position or b.Position
		return (aPosition - rootPart.Position).Magnitude < (bPosition - rootPart.Position).Magnitude
	end)

	return generators
end

local function PathFinding(Model)
	local activeNodes = {}

	local function clearNodes()
		for _, node in ipairs(activeNodes) do
			if node and node.Parent then
				node:Destroy()
			end
		end
		activeNodes = {}
	end

	local function createNode(position)
		local part = Instance.new("Part")
		part.Size = Vector3.new(1.2, 1.2, 1.2)
		part.Shape = Enum.PartType.Ball
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(248, 255, 150)
		part.Transparency = 0.5
		part.Anchored = true
		part.CanCollide = false
		part.Position = position + Vector3.new(0, 1.5, 0)
		part.Parent = workspace
		table.insert(activeNodes, part)
		game:GetService("Debris"):AddItem(part, 15)
	end

	local function SkibidiPathfinding(targetObject)
		clearNodes()

		local VIMVIM = game:GetService("VirtualInputManager")
		VIMVIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, nil)

		local player = Players.LocalPlayer
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") or not targetObject then
			return false
		end

		local humanoidus = character:FindFirstChildOfClass("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")

		local targetPosition = targetObject:IsA("Model") and targetObject:GetPivot().Position or targetObject.Position

		local pathination = PathfindingService:CreatePath({
			AgentRadius = 1,
			AgentHeight = 0,
			AgentCanJump = false,
			AgentWalkableFloorAngle = 50,
			Costs = { Acid = math.huge },
		})

		pathination:ComputeAsync(rootPart.Position, targetPosition)
		if pathination.Status ~= Enum.PathStatus.Success then
			return false
		end

		local waypoints = pathination:GetWaypoints()
		for i = 1, #waypoints - 1 do
			local start = waypoints[i].Position
			local finish = waypoints[i + 1].Position
			local distance = (finish - start).Magnitude
			local step = 2
			for j = 0, distance, step do
				createNode(start:Lerp(finish, j / distance))
			end
		end

		local stopped = false
		_G.CancelPathEvent.Event:Connect(function()
			stopped = true
		end)

		for _, wayponentos in ipairs(waypoints) do
			if stopped then
				return false
			end
			humanoidus:MoveTo(wayponentos.Position)
			local moveStartTime = tick()
			humanoidus.MoveToFinished:Wait()
			if stopped or (tick() - moveStartTime) > 1 then
				return false
			end
		end

		return true
	end

	local acidContainer = workspace:FindFirstChild("Map")
		and workspace.Map:FindFirstChild("Ingame")
		and workspace.Map.Ingame:FindFirstChild("Map")
		and workspace.Map.Ingame.Map:FindFirstChild("AcidContainer")
		and workspace.Map.Ingame.Map.AcidContainer:FindFirstChild("AcidDirt")
	if acidContainer then
		for _, part in ipairs(acidContainer:GetChildren()) do
			if part.Name == "Dirt" and part.Size.Y < 12 then
				part.Size = Vector3.new(part.Size.X, 13, part.Size.Z)
			end
		end
	end

	return SkibidiPathfinding(Model)
end

local function DoAllGenerators()
	for _, g in ipairs(findGenerators()) do
		local pathStarted = false
		for attempt = 1, 3 do
			local playersNearby = false
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= Players.LocalPlayer and player:DistanceFromCharacter(g:GetPivot().Position) <= 25 then
					playersNearby = true
					break
				end
			end

			if (Players.LocalPlayer.Character:GetPivot().Position - g:GetPivot().Position).Magnitude > 500 then
				break
			end

			if not playersNearby and g:FindFirstChild("Progress") and g.Progress.Value < 100 then
				g:GetPivot()
			end

			pathStarted = PathFinding(g)
			if pathStarted then
				break
			else
				task.wait(1)
			end
		end
		if pathStarted then
			task.wait(0.5)
			local prompt = g:FindFirstChild("Main") and g.Main:FindFirstChild("Prompt")
			if prompt then
				fireproximityprompt(prompt)
			end
			for i = 1, 6 do
				if g.Progress.Value < 100 and g:FindFirstChild("Remotes") and g.Remotes:FindFirstChild("RE") then
					g.Remotes.RE:FireServer()
				else
					break
				end
				if i < 6 and g.Progress.Value < 100 then
					task.wait(2.5)
				end
			end
		else
			return
		end
	end
	teleportToRandomServer()
end

local function AmIInGameYet()
	workspace.Players.Survivors.ChildAdded:Connect(function(child)
		task.wait(1)
		if child == game:GetService("Players").LocalPlayer.Character then
			task.wait(5)
			DoAllGenerators()
		end
	end)
end

local function DidiDie()
	while task.wait(0.5) do
		if Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			if Players.LocalPlayer.Character.Humanoid.Health == 0 then
				task.wait(5)
				teleportToRandomServer()
			end
		end
	end
end

pcall(task.spawn(DidiDie))
AmIInGameYet()