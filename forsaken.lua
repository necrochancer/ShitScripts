local KeySystem
local Frame
local TextBox
local UICorner14
local UIPadding
local UICorner_2
local TextLabel
local CheckKeyButton
local UICorner_3
local GetKey
local UICorner_4

-- this is like the worst script ever bro
-- like allat needs to be deleted 🙏

local function FartHubLoad()
	local Players = game:GetService("Players")
	local SoundService = game:GetService("SoundService")
	local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	local VIM = game:GetService("VirtualInputManager")
	local BlockRemote = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local Rayfield = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua")
	)()

	local DebugNotifications = getgenv and getgenv().DebugNotifications or false
	local SigmaData, JoinedSigmaServer = {}, false
	local CurrentFartsActive, NameProtectNames, aimbotActive = {}, {}, false
	local WowWhatTheZestIsThis
	local pizzaConnections = {}
	local PlayerTab, VisualsTab, GeneratorTab, BlatantTab, MiscTab = nil, nil, nil, nil, nil
	local BabyShark, KillerFartPart, HRP = nil, nil, nil
	local Runners = false
	local SkibidiDistance, BlockEnabled, AimLockTimer = 6, false, 2

	local executorname = (pcall(getexecutorname) and getexecutorname())
		or (pcall(identifyexecutor) and identifyexecutor())
		or "Unknown"
	local supportedExecutors = { AWP = true, Wave = true, Nihon = true, ["Synapse Z"] = true, Swift = true }

	task.spawn(function()
		if executorname == "AWP" then
			local folder, originalFile, tempFile = "FartHub", "FartHub/AmazingExecutor.mp3.Fart3", "FartHub/temp.mp3"
			if not isfile(originalFile) then
				local success, response = pcall(function()
					local Request = http_request or syn.request or request
					return Request
						and Request({
							Url = "https://raw.githubusercontent.com/ivannetta/ShitScripts/main/Assets/random/AmazingExecutor.mp3",
							Method = "GET",
						})
				end)
				if success and response and response.Body then
					writefile(originalFile, response.Body)
				end
			else
				return
			end
			if isfile(originalFile) then
				writefile(tempFile, readfile(originalFile))
				local sound = Instance.new("Sound", game:GetService("SoundService"))
				sound.SoundId = getcustomasset(tempFile)
				sound:Play()
			end
			delfile(tempFile)
		end
	end)

	if setclipboard then
		setclipboard("https://discord.gg/JkWFbJQMtg")
	end

	local fart = {
		aimbot = {},
		abilities = {},
		characterChange = nil,
	}

	local SkibidiPomniOhioList = {
		Killers = {
			Jason = { Duration1 = 0.5 },
			["1x1x1x1"] = { Duration1 = 0.5, Duration2 = 2.5, Duration3 = 1 },
			JohnDoe = { Duration1 = 0.5, Duration2 = 5 },
			C00lkidd = { Duration1 = 0.5 },
		},
		Survivors = {
			Guest1337 = { Duration2 = 2 },
			Chance = { Duration2 = 2 },
		},
	}

	local GUI = Rayfield:CreateWindow({
		Name = "FartSaken",
		Theme = "Default",
		LoadingTitle = "Fart Hub",
		LoadingSubtitle = "meow meow meow meow meow meow",
		Icon = 0,
		Link = "https://github.com/ivannetta/ShitScripts/Forsaken",

		DisableBuildWarnings = true,
		DisableRayfieldPrompts = true,

		KeySystem = true,
		KeySettings = {
			Title = "Fartsaken Key System",
			Subtitle = "grrrrrrrrr",
			Note = "Join Discord Server To Get Key discord.gg/JkWFbJQMtg (copied to clipboard)",
			FileName = "FartHubKey",
			SaveKey = true,
			GrabKeyFromSite = false,
			Key = { "sigma" }, -- this is very protected trust 😭
		},
	})

	local function GetCharAndFold()
		local Me = game.Players.LocalPlayer
		if not Me or not Me.Character then
			return nil, nil
		end
		return Me.Character.Name, Me.Character.Parent.Name
	end

	local function JanitorModeEnabled(oklolloolloololololol)
		for _, connection in pairs(oklolloolloololololol) do
			if connection and connection.Connected then
				connection:Disconnect()
			end
		end
		table.clear(oklolloolloololololol)
	end

	local function Aimbot(Dur)
		if not Dur then
			return
		end
		local Char, CharacterGender = GetCharAndFold()
		if not Char or not CharacterGender then
			return
		end

		local Me = game.Players.LocalPlayer
		local MeButCharacter = Me.Character
		if not MeButCharacter or not MeButCharacter:FindFirstChild("HumanoidRootPart") then
			return
		end

		local HornyFolder = workspace:FindFirstChild("Players")
			and workspace.Players:FindFirstChild(CharacterGender == "Killers" and "Survivors" or "Killers")
		if not HornyFolder then
			return
		end

		local function FindClosestPerson()
			local ClosestTarget, ClosestDistance = nil, math.huge
			local MyPosition = MeButCharacter.HumanoidRootPart.Position

			for _, v in pairs(HornyFolder:GetChildren()) do
				if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
					local distance = (v.HumanoidRootPart.Position - MyPosition).Magnitude
					if distance < ClosestDistance then
						ClosestDistance = distance
						ClosestTarget = v
					end
				end
			end
			return ClosestTarget
		end

		task.spawn(function()
			local startTime = tick()
			while tick() - startTime < Dur do
				local target = FindClosestPerson()
				if target and target:FindFirstChild("HumanoidRootPart") then
					local wawa = MeButCharacter.HumanoidRootPart
					local wawaza = target.HumanoidRootPart.Position
					local MathematicalCalculations = (wawaza - wawa.Position).unit
					wawa.CFrame = CFrame.new(
						wawa.Position,
						wawa.Position + Vector3.new(MathematicalCalculations.X, 0, MathematicalCalculations.Z)
					)
					--local Cumera = game.Workspace.CurrentCamera
					--Cumera.CFrame = CFrame.lookAt(Cumera.CFrame.Position, Cumera.CFrame.Position + Vector3.new(MathematicalCalculations.X, MathematicalCalculations.Y, MathematicalCalculations.Z))
				end
				task.wait()
			end
		end)
	end

	local function WatchPizzaTower(state)
		if not state then
			for _, connection in ipairs(pizzaConnections) do
				connection:Disconnect()
			end
			table.clear(pizzaConnections)
			return
		end

		local function onChildAdded(child)
			if child.Name == "Pizza" then
				local player = game.Players.LocalPlayer
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					child.CFrame = hrp.CFrame
				end
			end
		end

		local function watchFolder()
			local ingameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
			if ingameFolder then
				table.insert(pizzaConnections, ingameFolder.ChildAdded:Connect(onChildAdded))
			else
				table.insert(
					pizzaConnections,
					workspace.ChildAdded:Connect(function(child)
						if child.Name == "Map" then
							table.insert(
								pizzaConnections,
								child.ChildAdded:Connect(function(subChild)
									if subChild.Name == "Ingame" then
										table.insert(pizzaConnections, subChild.ChildAdded:Connect(onChildAdded))
									end
								end)
							)
						end
					end)
				)
			end
		end

		watchFolder()
	end

	local function HandleFartContainer(LKFVJNWEFLKJWNEFLKJWNEF)
		local Me = game.Players.LocalPlayer
		local LastSkibidi, LastSkebede = GetCharAndFold()

		if fart.characterChange then
			fart.characterChange:Disconnect()
		end

		fart.characterChange = Me:GetPropertyChangedSignal("Character"):Connect(function()
			task.wait(0.1)
			local newCharacter, newTeam = GetCharAndFold()

			if newCharacter ~= LastSkibidi or newTeam ~= LastSkebede then
				LastSkibidi, LastSkebede = newCharacter, newTeam
				JanitorModeEnabled(fart.abilities)
				HandleFartContainer(true)
			end
		end)

		if not LKFVJNWEFLKJWNEFLKJWNEF then
			JanitorModeEnabled(fart.abilities)
			return
		end

		local AbilityContainer =
			game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainUI"):WaitForChild("AbilityContainer")

		local function EvilEmoji(lol)
			local CharacterGender, Wowzaer = GetCharAndFold()
			if not SkibidiPomniOhioList[Wowzaer] or not SkibidiPomniOhioList[Wowzaer][CharacterGender] then
				return
			end

			local sigmaboy = lol.LayoutOrder
			local DDDDDDDurationm = "Duration" .. sigmaboy
			local VeryLongDuration = SkibidiPomniOhioList[Wowzaer][CharacterGender][DDDDDDDurationm]

			if VeryLongDuration then
				local IsSkibidiToiletMode = false
				local CONNECTOR
				if CharacterGender ~= "Chance" then
					CONNECTOR = lol:WaitForChild("CooldownTime", .2):GetPropertyChangedSignal("Text"):Connect(function()
						if not IsSkibidiToiletMode and lol.CooldownTime.Text ~= "" then
							IsSkibidiToiletMode = true
							task.spawn(Aimbot, VeryLongDuration)

							task.spawn(function()
								repeat
									task.wait()
								until lol:WaitForChild("CooldownTime", .2).Text == ""
								task.wait(0.1)
								IsSkibidiToiletMode = false
							end)
						end
					end)
					table.insert(fart.abilities, CONNECTOR)
				end
			end

			local function onFlintlockTransparencyChange()
				local Flintlock = Players.LocalPlayer.Character:FindFirstChild("FlintlockGun")
					or Players.LocalPlayer.Character:FindFirstChild("Flintlock")
				if Flintlock then
					local function checkTransparency()
						if Flintlock.Transparency == 0 then
							task.spawn(Aimbot, VeryLongDuration)
						end
					end
					table.insert(
						fart.abilities,
						Flintlock:GetPropertyChangedSignal("Transparency"):Connect(checkTransparency)
					)
					checkTransparency()
				end
			end

			onFlintlockTransparencyChange()
		end

		for _, blahblahblah in ipairs(AbilityContainer:GetChildren()) do
			if blahblahblah:IsA("Frame") and blahblahblah:FindFirstChild("CooldownTime") then
				EvilEmoji(blahblahblah)
			end
		end

		for _, grrrrrr in pairs(AbilityContainer:GetChildren()) do
			if (grrrrrr:IsA("TextButton") or grrrrrr:IsA("ImageButton")) and grrrrrr:FindFirstChild("CooldownTime") then
				EvilEmoji(grrrrrr)
			end
		end

		table.insert(
			fart.abilities,
			AbilityContainer.ChildAdded:Connect(function(child)
				if (child:IsA("TextButton") or child:IsA("ImageButton")) and child:FindFirstChild("CooldownTime") then
					EvilEmoji(child)
				end
			end)
		)
	end

	local function GetAssetList()
		local url = "https://api.github.com/repos/ivannetta/ShitScripts/git/trees/main?recursive=1"
		local assetList = {}

		local success, errorMessage = pcall(function()
			local Request = http_request or syn.request or request
			if Request then
				local response = Request({
					Url = url,
					Method = "GET",
					Headers = { ["Content-Type"] = "application/json" },
				})

				if response and response.Body then
					local data = game:GetService("HttpService"):JSONDecode(response.Body)
					for _, item in ipairs(data.tree) do
						if item.path:match("^Assets/.+%.png$") or item.path:match("^Assets/.+%.mp4$") then
							local rawUrl = "https://raw.githubusercontent.com/ivannetta/ShitScripts/main/" .. item.path
							table.insert(assetList, rawUrl)

							local name = item.path:match("Assets/(.+)%.png$") or item.path:match("Assets/(.+)%.mp4$")
							if name then
								table.insert(NameProtectNames, name)
							end
						end
					end
				end
			end
		end)

		if not success then
			Rayfield:Notify({ Title = "Error", Content = errorMessage, Duration = 5 })
		end
		return assetList
	end

	local function DownloadBallers(url, path)
		if not isfile(path) then
			local suc, res = pcall(function()
				return game:HttpGet(url, true)
			end)
			if not suc or res == "404: Not Found" then
				Rayfield:Notify({ Title = "Error", Content = "erm not found", Duration = 5 })
			end
			writefile(path, res)
		end
	end

	local function CheckIfFartsDownloaded()
		local assetList = GetAssetList()
		local basePath = "FartHub/Assets/"

		if not isfolder("FartHub") then
			makefolder("FartHub")
		end

		if not isfolder(basePath) then
			makefolder(basePath)
		end

		for _, url in ipairs(assetList) do
			local filePath = basePath .. url:match("Assets/(.+)")
			local newFilePath = filePath:gsub("%.png$", ".png.Fart"):gsub("%.mp4$", ".mp4.Fart4")

			if not isfile(newFilePath) then
				DownloadBallers(url, newFilePath)
				task.wait(0.1)
				Rayfield:Notify({ Title = "Downloaded", Content = newFilePath, Duration = 5 })
			end
		end
	end

	local function LoadAsset(assetName)
		local basePath = "FartHub/Assets/"
		local assetPath = basePath .. assetName

		if isfile(assetPath) then
			return getcustomasset(assetPath)
		else
			return nil
		end
	end

	local function ToggleFatMan(state)
		if state then
			WowWhatTheZestIsThis = Instance.new("ScreenGui", game:GetService("CoreGui"))
			WowWhatTheZestIsThis.Name = "FatMan"
			WowWhatTheZestIsThis.ResetOnSpawn = false
			WowWhatTheZestIsThis.DisplayOrder = 999999999

			local Frame = Instance.new("Frame", WowWhatTheZestIsThis)
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.AnchorPoint = Vector2.new(1, 0.5)
			Frame.Name = "YAPPING"
			Frame.Position = UDim2.new(1, 0, 0.5, 0)
			Frame.Size = UDim2.new(0, 150, 0, 150)

			local VideoFrame = Instance.new("VideoFrame", Frame)
			VideoFrame.Size = UDim2.new(1, 0, 1, 0)
			VideoFrame.Video = LoadAsset("FatMan.mp4.Fart4")
			VideoFrame.Looped = true
			VideoFrame.Playing = true
		else
			WowWhatTheZestIsThis:Destroy()
		end
	end

	local function NameProtect(state)
		local function updateNames()
			local CurrentSurvivors = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TemporaryUI")
				and game:GetService("Players").LocalPlayer.PlayerGui.TemporaryUI:FindFirstChild("PlayerInfo")
				and game:GetService("Players").LocalPlayer.PlayerGui.TemporaryUI.PlayerInfo
					:FindFirstChild("CurrentSurvivors")
			if CurrentSurvivors then
				local indices = {}
				for index in pairs(NameProtectNames) do
					table.insert(indices, index)
				end
				for i = #indices, 2, -1 do
					local j = math.random(i)
					indices[i], indices[j] = indices[j], indices[i]
				end
				for _, People in pairs(CurrentSurvivors:GetChildren()) do
					if People:IsA("Frame") then
						local name
						local success = false
						repeat
							name = NameProtectNames[indices[math.random(#indices)]]
							local asset = LoadAsset(name .. ".png.Fart")
							if asset then
								People.Icon.Image = asset
								success = true
							end
						until success
						People.Username.Text = name
					end
				end
			end
		end

		if state then
			local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
			local function setupConnections()
				local TemporaryUI = PlayerGui:WaitForChild("TemporaryUI", math.huge)
				local PlayerInfo = TemporaryUI:WaitForChild("PlayerInfo", math.huge)

				PlayerGui.ChildAdded:Connect(function(child)
					if child.Name == "TemporaryUI" then
						updateNames()
					end
				end)
				TemporaryUI.ChildAdded:Connect(function(child)
					if child.Name == "PlayerInfo" then
						updateNames()
					end
				end)
				PlayerInfo.ChildAdded:Connect(function(child)
					if child.Name == "CurrentSurvivors" then
						updateNames()
					end
				end)
			end

			setupConnections()
			updateNames()

			if PlayerGui.MainUI.PlayerListHolder then
				PlayerGui.MainUI.PlayerListHolder:Destroy()
			end
			if PlayerGui.MainUI.Spectate.Username then
				PlayerGui.MainUI.Spectate.Username.Visible = false
			end
		end
	end

	Rayfield:Notify({
		Title = supportedExecutors[executorname] and executorname .. " Executor Supported"
			or executorname .. " Executor Not Supported",
		Content = supportedExecutors[executorname] and executorname .. " No Errors Expected"
			or executorname .. " Errors Expected",
		Image = supportedExecutors[executorname] and "check" or "ban",
		Duration = 2,
	})

	local highlightingEnabled, SkibidiStaminaLoop, running, ItemFartsEnabled, Do1x1PopupsLoop, SkibidiWait, LopticaWaitTime =
		false, false, false, false, false, 2, 2
	local generatorHighlightColor, survivorHighlightColor, killerHighlightColor, itemHighlightColor =
		Color3.fromRGB(173, 162, 236),
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(255, 100, 100),
		Color3.fromRGB(255, 255, 0)

	local Items = { "Medkit", "BloxyCola" }

	local function LoadSigmaData()
		pcall(function()
			local HttpService = game:GetService("HttpService")
			local data = HttpService:JSONDecode(readfile("FartHub.json"))
			generatorHighlightColor = data.ColorOptions.Generator and Color3.fromHex(data.ColorOptions.Generator)
				or Color3.fromRGB(255, 0, 0)
			survivorHighlightColor = data.ColorOptions.Survivor and Color3.fromHex(data.ColorOptions.Survivor)
				or Color3.fromRGB(0, 255, 0)
			killerHighlightColor = data.ColorOptions.Killer and Color3.fromHex(data.ColorOptions.Killer)
				or Color3.fromRGB(0, 0, 255)
			itemHighlightColor = data.ColorOptions.Item and Color3.fromHex(data.ColorOptions.Item)
				or Color3.fromRGB(255, 255, 0)
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
			Item = itemHighlightColor:ToHex(),
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
			if obj:IsA("Highlight") or obj:IsA("BillboardGui") then
				obj:Destroy()
			end
		end
		if not state then
			return
		end
		local function AddFart(object, color)
			if
				object:IsA("Model")
				and object ~= localPlayer.Character
				and not object:FindFirstChildOfClass("Highlight")
			then
				local h = Instance.new("Highlight", object)
				h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.7, 0.6
			end
		end
		for _, folder in ipairs({ workspace.Players.Survivors, workspace.Players.Killers }) do
			for _, obj in ipairs(folder:GetChildren()) do
				AddFart(obj, folder.Name == "Survivors" and survivorHighlightColor or killerHighlightColor)
				local billboard = Instance.new("BillboardGui", obj:WaitForChild("Head"))
				billboard.Name = "FartHubBillboard"
				billboard.Size = UDim2.new(0, 100, 0, 50)
				billboard.StudsOffset = Vector3.new(0, 2, 0)
				local textLabel = Instance.new("TextLabel", billboard)
				textLabel.Size = UDim2.new(1, 0, 1, 0)
				textLabel.Text = obj:GetAttribute("Username") and obj.Name
				textLabel.TextColor3 = Color3.new(1, 1, 1)
				textLabel.TextStrokeTransparency = 0
				textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				billboard.AlwaysOnTop = true
				textLabel.BackgroundTransparency = 1
			end
			folder.ChildAdded:Connect(function(child)
				if highlightingEnabled then
					AddFart(child, folder.Name == "Survivors" and survivorHighlightColor or killerHighlightColor)
					local billboard = Instance.new("BillboardGui", child:WaitForChild("Head"))
					billboard.Name = "FartHubBillboard"
					billboard.Size = UDim2.new(0, 100, 0, 50)
					billboard.StudsOffset = Vector3.new(0, 2, 0)
					local textLabel = Instance.new("TextLabel", billboard)
					textLabel.TextColor3 = Color3.new(1, 1, 1)
					textLabel.TextStrokeTransparency = 0
					textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
					textLabel.Size = UDim2.new(1, 0, 1, 0)
					textLabel.Text = child:GetAttribute("Username") and child.Name
					billboard.AlwaysOnTop = true
					textLabel.BackgroundTransparency = 1
				end
			end)
		end
		local function SetupSigmaListener()
			local ingameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
			if not ingameFolder then
				return
			end
			local mapFolder = ingameFolder:FindFirstChild("Map")
			if not mapFolder then
				return
			end
			for _, g in ipairs(mapFolder:GetChildren()) do
				if g.Name == "Generator" then
					AddFart(g, generatorHighlightColor)
				end
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

	local function Do1x1x1x1Popups()
		while true do
			if Do1x1PopupsLoop then
				local player = game:GetService("Players").LocalPlayer
				local popups = player.PlayerGui.TemporaryUI:GetChildren()

				for _, i in ipairs(popups) do
					if i.Name == "1x1x1x1Popup" then
						local centerX = i.AbsolutePosition.X + (i.AbsoluteSize.X / 2)
						local centerY = i.AbsolutePosition.Y + (i.AbsoluteSize.Y / 2)
						VIM:SendMouseButtonEvent(
							centerX,
							centerY,
							Enum.UserInputType.MouseButton1.Value,
							true,
							player.PlayerGui,
							1
						)
						VIM:SendMouseButtonEvent(
							centerX,
							centerY,
							Enum.UserInputType.MouseButton1.Value,
							false,
							player.PlayerGui,
							1
						)
					end
				end
			end
			task.wait(0.1)
		end
	end

	local function SetupSurfers(PuzzlesUi)
		local Container = PuzzlesUi:WaitForChild("Container")
		local GridHolder = Container:WaitForChild("GridHolder")
		local Surfers = Instance.new("VideoFrame", GridHolder)
		Surfers.Size = UDim2.new(1, -20, 1, -20)
		Surfers.AnchorPoint = Vector2.new(0.5, 0.5)
		Surfers.Position = UDim2.new(0.5, 0, 0.5, 0)

		Surfers.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Surfers.Video = LoadAsset("SubwaySurfers.mp4.Fart4")
		Surfers.Looped = true
		Surfers.Playing = true

		for _, silly in ipairs(GridHolder.Grid:GetChildren()) do
			if silly:IsA("Frame") then
				silly.Transparency = 0.6
				silly.Button.BackgroundTransparency = 0.6
			end
		end
	end

	local function SkibidiGenerator(shouldLoop)
		while shouldLoop and running do
			local PuzzleUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PuzzleUI", 9999)

			task.wait(SkibidiWait + (math.random() * (SkibidiWait / 5 * 2) - SkibidiWait / 5))

			local FartNapFolder = workspace:FindFirstChild("Map")
				and workspace.Map:FindFirstChild("Ingame")
				and workspace.Map.Ingame:FindFirstChild("Map")
			if FartNapFolder then
				local closestGenerator, closestDistance = nil, math.huge
				local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
				for _, g in ipairs(FartNapFolder:GetChildren()) do
					if g.Name == "Generator" and g.Progress.Value < 100 then
						local distance = (g.Main.Position - playerPosition).Magnitude
						if distance < closestDistance then
							closestDistance = distance
							closestGenerator = g
						end
					end
				end
				if closestGenerator then
					closestGenerator.Remotes.RE:FireServer()
				end
			end
		end
	end

	local function GeneratorOnce()
		local FartIngameFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
		local FartNapFolder = FartIngameFolder and FartIngameFolder:FindFirstChild("Map")
		if FartNapFolder then
			for _, g in ipairs(FartNapFolder:GetChildren()) do
				if g.Name == "Generator" and g.Progress.Value < 100 then
					g.Remotes.RE:FireServer()
				end
			end
		end
	end

	local function TpDoGenerator()
		local Geneators = workspace:WaitForChild("Map")
			and workspace.Map:WaitForChild("Ingame")
			and workspace.Map.Ingame:WaitForChild("Map")
		local lastPosition = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		local function findGenerators()
			local folder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
			local map = folder and folder:FindFirstChild("Map")
			local generators = {}
			if map then
				for _, g in ipairs(map:GetChildren()) do
					if g.Name == "Generator" and g.Progress.Value < 100 then
						local playersNearby = false
						for _, player in ipairs(game.Players:GetPlayers()) do
							if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
								local distance = (player.Character.HumanoidRootPart.Position - g.Main.Position).Magnitude
								if distance < 10 then
									playersNearby = true
									break
								end
							end
						end
						if not playersNearby then
							table.insert(generators, g)
						end
					end
				end
			end
			return generators
		end

		while true do
			local generators = findGenerators()
			if #generators == 0 then
				break
			end
			for _, g in ipairs(generators) do
				local player = game.Players.LocalPlayer
				local generatorPosition = g.Instances.Generator.Progress.CFrame.Position
				local generatorDirection = (g.Instances.Generator.Cube.CFrame.Position - generatorPosition).Unit
				player.Character.HumanoidRootPart.CFrame = CFrame.new(
					generatorPosition + Vector3.new(0, 0.5, 0),
					generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z)
				)
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

	local function HawkTuah()
		if not BlockEnabled then
			return
		end

		local lastActionTime = 0
		local cooldown = 2

		if Runners then
			return
		end

		Runners = true

		local success, err = pcall(function()
			local BabyShark = workspace:WaitForChild("Players"):FindFirstChild("Killers")
			local Killer = BabyShark and BabyShark:GetChildren()[1] or nil
			local KillerHumanoid = Killer and Killer:FindFirstChildOfClass("Humanoid") or nil
			local KillerHRP = Killer and Killer:FindFirstChild("HumanoidRootPart") or nil
			local Player = game.Players.LocalPlayer
			local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") or nil

			if KillerHumanoid and KillerHRP and HRP then
				local animationTrack = nil
				KillerHumanoid.Animator.AnimationPlayed:Connect(function(track)
					if track.Animation and track.Priority == Enum.AnimationPriority.Action then
						animationTrack = track
					end
				end)

				game:GetService("RunService").Heartbeat:Connect(function()
					if not animationTrack or not BlockEnabled then
						return
					end

					local currentTime = tick()
					if currentTime - lastActionTime < cooldown then
						return
					end

					local distance = (HRP.Position - KillerHRP.Position).Magnitude

					if distance < SkibidiDistance and (animationTrack.Length - animationTrack.TimePosition) > 0.5 then
						BlockRemote:FireServer("UseActorAbility", "Block")
						lastActionTime = currentTime

						if distance < SkibidiDistance - 1 then
							local humanoid = Player.Character:FindFirstChild("Humanoid")
							if humanoid and humanoid.Animator then
								for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
									if track.Name == "rbxassetid://72722244508749" then
										Aimbot(0.5)
										BlockRemote:FireServer("UseActorAbility", "Punch")
										break
									end
								end
							end
						end
					end
					task.wait(0.1)
				end)
			end
		end)

		Runners = false

		if not success then
			Rayfield:Notify({ Title = "An error occurred!", Content = err, Duration = 10 })
			return
		end
	end

	local function testiclegod12()
		local killers = workspace.Players:WaitForChild("Killers")
		local survivors = workspace.Players:WaitForChild("Survivors")

		local function resetBlock()
			task.wait(5)
			Runners = false
			HawkTuah()
		end

		for _, folder in ipairs({killers, survivors}) do
			folder.ChildAdded:Connect(resetBlock)
			folder.ChildRemoved:Connect(resetBlock)
		end
	end

	game.Players.PlayerAdded:Connect(function()
		testiclegod12()
	end)

	if game.Players.LocalPlayer then
		testiclegod12()
	end

	game:GetService("Players").ChildAdded:Connect(function(child)
		if not BlockEnabled then
			return
		end
		local success, err = pcall(function()
			if child.Name == "Killers" then
				HawkTuah()
			end
		end)
		if not success then
			Rayfield:Notify({ Title = "An error occured!", Content = err, Duration = 10, Image = "ban" })
		end
	end)

	game:GetService("Players").ChildRemoved:Connect(function(child)
		if not BlockEnabled then
			return
		end
		local success, err = pcall(function()
			if child.Name == "Killers" then
				HawkTuah()
			end
		end)
		if not success then
			Rayfield:Notify({ Title = "An error occured!", Content = err, Duration = 10, Image = "ban" })
		end
	end)

	local function ToggleFart(state)
		SkibidiStaminaLoop = state
		local success, SkibidiSprinting = pcall(function()
			return require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
		end)

		if not success then
			Rayfield:Notify({
				Title = "Error",
				Content = "Your executor doesn't support this.",
				Duration = 5,
				Image = "ban",
			})
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
			Rayfield:Notify({ Title = "Error", Content = err, Duration = 5 })
		end
	end

	local function ToggleSigmaItemsHighlights(state)
		ItemFartsEnabled = state
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Highlight") and table.find(Items, obj.Parent.Name) then
				task.wait(0.1)
				obj:Destroy()
			end
		end
		if not state then
			return
		end
		local function AddLopticaHighlight(object, color)
			if
				object:IsA("BasePart")
				and object.Parent:IsA("Model")
				and not object:FindFirstChildOfClass("Highlight")
			then
				local h = Instance.new("Highlight", object)
				h.FillColor, h.FillTransparency, h.OutlineTransparency = color, 0.7, 0.6
			end
		end
		for _, item in ipairs(Items) do
			for _, obj in ipairs(workspace.Map.Ingame:GetDescendants()) do
				if obj:IsA("Model") and obj.Name == item then
					for _, child in ipairs(obj:GetChildren()) do
						if child:IsA("BasePart") then
							AddLopticaHighlight(child, itemHighlightColor)
						end
					end
				end
			end
		end
		workspace.Map.Ingame.DescendantAdded:Connect(function(descendant)
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
		WriteSigmaData()
	end

	local function InitializeButtonGUI()
		local visible = true
		local sausageHolder = game:GetService("CoreGui").TopBarApp.UnibarLeftFrame.UnibarMenu["2"]
		local originalSize = sausageHolder.Size.X.Offset

		sausageHolder.Size = UDim2.new(0, originalSize + 48, 0, sausageHolder.Size.Y.Offset)

		local buttonFrame = Instance.new("Frame", sausageHolder)
		buttonFrame.Size = UDim2.new(0, 44, 0, 44)
		buttonFrame.BackgroundTransparency = 1
		buttonFrame.BorderSizePixel = 0
		buttonFrame.Position = UDim2.new(0, sausageHolder.Size.X.Offset - 48, 0, 0)

		local imageButton = Instance.new("ImageButton", buttonFrame)
		imageButton.BackgroundTransparency = 1
		imageButton.BorderSizePixel = 0
		imageButton.Size = UDim2.new(0, 36, 0, 36)
		imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
		imageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
		imageButton.Image = "http://www.roblox.com/asset/?id=131523679474566"

		local function toggleGUI()
			visible = not visible
			Rayfield:SetVisibility(visible, false)
			sausageHolder.Size = UDim2.new(0, originalSize + (visible and 48 or 0), 0, sausageHolder.Size.Y.Offset)
		end

		imageButton.Activated:Connect(toggleGUI)

		sausageHolder:GetPropertyChangedSignal("Size"):Connect(function()
			if sausageHolder.Size.X.Offset == originalSize then
				sausageHolder.Size = UDim2.new(0, originalSize + 48, 0, sausageHolder.Size.Y.Offset)
			end
		end)
	end

	local function CreateSigmaFrame()
		local visible = true
		local topBarApp = game:GetService("CoreGui"):WaitForChild("TopBarApp")
		local leftFrame = topBarApp:WaitForChild("TopBarFrame"):WaitForChild("LeftFrame")

		local sigmaFrame = Instance.new("Frame", leftFrame)
		sigmaFrame.Name = "SigmaFrame"
		sigmaFrame.Size = UDim2.new(0, 32, 0, 32)
		sigmaFrame.Position = UDim2.new(0, 0, 1, 0)
		sigmaFrame.BackgroundTransparency = 1
		sigmaFrame.LayoutOrder = 5

		local background = Instance.new("ImageLabel", sigmaFrame)
		background.Name = "Background"
		background.Size = UDim2.new(0, 32, 0, 32)
		background.Position = UDim2.new(0, 0, 0, 0)
		background.Image = "rbxasset://textures/ui/TopBar/iconBase.png"
		background.BackgroundTransparency = 1

		local icon = Instance.new("ImageButton", background)
		icon.Name = "Icon"
		icon.Size = UDim2.new(0, 36, 0, 36)
		icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Image = "http://www.roblox.com/asset/?id=131523679474566"
		icon.BackgroundTransparency = 1

		local function toggleGUI()
			visible = not visible
			Rayfield:show(visible)
		end
		icon.Activated:Connect(toggleGUI)
	end

	local function MakeButton()
		if game:GetService("CoreGui"):FindFirstChild("TopBarApp"):FindFirstChild("UnibarLeftFrame") then
			InitializeButtonGUI()
		else
			CreateSigmaFrame()
		end
	end

	local function InitializeGUI()
		GeneratorTab = GUI:CreateTab("Generators", "siren")
		VisualsTab = GUI:CreateTab("Visuals", "eye")
		PlayerTab = GUI:CreateTab("Player", "user")
		MiscTab = GUI:CreateTab("Misc", "ghost")
		BlatantTab = GUI:CreateTab("Blatant", "angry")

		--GUI:Credit({ Name = "ivannetta", Description = "meowzer", Discord = "ivannetta" })

		Rayfield:Notify({
			Title = "NOTE: Highlights Not Working Fix.",
			Content = "Reset Your Bloxtrap Settings.",
			Duration = 3.6,
			Image = "layout-grid",
		})

		Rayfield:Notify({
			Title = "NOTE: Made by ivannetta",
			Content = "Pls Join DC Server 😼",
			Duration = 5.2,
			Image = "paperclip",
		})

		-- Visuals Tab
		local VisualsSection = VisualsTab:CreateSection("Highlights for things.")

		local GeneratorColor = VisualsTab:CreateColorPicker({
			Name = "Generator Color",
			Color = generatorHighlightColor,
			Callback = function(Value)
				generatorHighlightColor = Value
				UpdateFarts()
			end,
		})

		local SurvivorColor = VisualsTab:CreateColorPicker({
			Name = "Survivor Highlight Color",
			Color = survivorHighlightColor,
			Callback = function(Value)
				survivorHighlightColor = Value
				UpdateFarts()
			end,
		})

		local KillerColor = VisualsTab:CreateColorPicker({
			Name = "Killer Highlight Color",
			Color = killerHighlightColor,
			Callback = function(Value)
				killerHighlightColor = Value
				UpdateFarts()
			end,
		})

		local ItemColor = VisualsTab:CreateColorPicker({
			Name = "Item Highlight Color",
			Color = itemHighlightColor,
			Callback = function(Value)
				itemHighlightColor = Value
				UpdateFarts()
			end,
		})

		local VisuialsDivider = VisualsTab:CreateDivider()

		local VisualsToggle = VisualsTab:CreateToggle({
			Name = "Highlight Objects",
			CurrentValue = false,
			Callback = function(state)
				ToggleFarts(state)
				ToggleSigmaItemsHighlights(state)
			end,
		})

		-- Player Tab
		local PlayerSection = PlayerTab:CreateSection("Player related stuff.")

		local QuickPromptsButton = PlayerTab:CreateButton({
			Name = "Quick Proximity Prompts",
			Description = "Make Proximity Prompts Finish Instantly.",
			Callback = function()
				SetProximity()
			end,
		})

		local CoolKidAimbotToggle = PlayerTab:CreateToggle({
			Name = "C00lkid Aimbot ( Tell the game ur on mobile. )",
			CurrentValue = false,
			Callback = function(state)
				game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent
					:FireServer("SetDevice", state and "Mobile" or "PC")
			end,
		})

		local BringMePizza = PlayerTab:CreateToggle({
			Name = "Bring Me Some Pizza",
			CurrentValue = false,
			Callback = function(state)
				task.spawn(function()
					WatchPizzaTower(state)
				end)
			end,
		})

		local Do1x1x1x1PopupToggle = PlayerTab:CreateToggle({
			Name = "Do 1x1x1x1 Popups",
			CurrentValue = false,
			Callback = function(state)
				Do1x1PopupsLoop = state
				if state then
					task.spawn(Do1x1x1x1Popups)
				end
			end,
		})

		PlayerTab:CreateSection("This might not work on free executors.")

		local DisableStaminaDrainSigmaToggle = PlayerTab:CreateToggle({
			Name = "Disable Stamina Drain",
			CurrentValue = false,
			Callback = function(state)
				task.spawn(function()
					ToggleFart(state)
				end)
			end,
		})

		-- Generator Tab
		local GeneratorSection = GeneratorTab:CreateSection("Solves the puzzle for you.")

		local QuickNewGens = GeneratorTab:CreateToggle({
			Name = "Quick Generators",
			CurrentValue = false,
			Callback = function(state)
				running = state
				if state then
					task.spawn(function()
						SkibidiGenerator(true)
					end)
				end
			end,
		})

		GeneratorTab:CreateDivider()

		local GeneratorKeybind = GeneratorTab:CreateKeybind({
			Name = "Do Current Generator.",
			CurrentKeybind = "H",
			Callback = function(keybind)
				GeneratorOnce()
			end,
		})

		local GeneratorSpeedSlider = GeneratorTab:CreateSlider({
			Name = "Generator Speed",
			Range = { 0.1, 10 },
			Increment = 0.1,
			Suffix = "Seconds",
			CurrentValue = 2,
			Flag = "GeneratorSpeed",
			Callback = function(value)
				SkibidiWait = value
			end,
		})

		-- Blatant Tab
		BlatantTab:CreateSection("Aimbot and Auto Block.")

		local AimbotToggle = BlatantTab:CreateToggle({
			Name = "Aimbot",
			CurrentValue = false,
			Callback = function(state)
				HandleFartContainer(state)
			end,
		})

		local AutoBlockToggle = BlatantTab:CreateToggle({
			Name = "Auto Block (Experimental)",
			CurrentValue = false,
			Callback = function(state)
				BlockEnabled = state
				local success, err = pcall(function()
					if BlockEnabled then
						HawkTuah()
					end
				end)
				if not success then
					Rayfield:Notify({ Title = "An error occured!", Text = err, Duration = 10, Image = "ban" })
				end
			end,
		})

		local DistanceSlider = BlatantTab:CreateSlider({
			Name = "Auto Block Distance",
			Range = { 1, 20 },
			Increment = 1,
			Suffix = "Studs",
			CurrentValue = 6,
			Flag = "AutoBlockDistance",
			Callback = function(value)
				SkibidiDistance = value
			end,
		})

		BlatantTab:CreateSection("Generator Farms.")

		local AutoFarmGeneratorsButton = BlatantTab:CreateButton({
			Name = "AutoFarm Generators",
			Description = "Serverhops, Does Generators, Forever and ever.",
			Callback = function()
				Rayfield:Notify({ Title = "Loading", Content = "pls wait stinky boy", Duration = 20, Image = "check" })
				loadstring(
					game:HttpGet(
						"https://raw.githubusercontent.com/ivannetta/ShitScripts/main/AutoSigma.lua",
						true
					)
				)()
			end,
		})

		local DoAllGeneratorsButton = BlatantTab:CreateButton({
			Name = "Do ALL Generators",
			Description = "Teleport to all generators and do them.",
			Callback = function()
				TpDoGenerator()
			end,
		})

		local DoAllGenSpeedSlider = BlatantTab:CreateSlider({
			Name = "Do ALL Generators Speed",
			Range = { 0.1, 10 },
			Increment = 0.1,
			Suffix = "Seconds",
			CurrentValue = 2,
			Flag = "DoAllGeneratorsSpeed",
			Callback = function(value)
				LopticaWaitTime = value
			end,
		})

		-- Misc Tab
		local MiscTitle = MiscTab:CreateSection("Funny Things")

		local FatManToggle = MiscTab:CreateToggle({
			Name = "Toggle FatMan",
			CurrentValue = false,
			Callback = function(state)
				ToggleFatMan(state)
			end,
		})

		local LowSpanModeButton = MiscTab:CreateButton({
			Name = "Low Attention Span Mode",
			Description = "Activate Low Attention Span Mode",
			Callback = function()
				if not _G.LowAttentionSpanModeActivated then
					_G.LowAttentionSpanModeActivated = true
					PlayerGui.ChildAdded:Connect(function(child)
						if child.Name == "PuzzleUI" then
							SetupSurfers(child)
						end
					end)
				else
					Rayfield:Notify({
						Title = "bro",
						Content = "its already on",
						Duration = 3,
						Image = "ban",
					})
				end
			end,
		})

		MiscTab:CreateSection("Useful things")

		local NameProtectActivated = false
		local NameProtectButton = MiscTab:CreateButton({
			Name = "NameProtect",
			Description = "Replaces everyone's names and images with pmoon.",
			Callback = function()
				if not NameProtectActivated then
					NameProtect(true)
					NameProtectActivated = true
				else
					Rayfield:Notify({
						Title = "Already Activated",
						Content = "NameProtect is already activated.",
						Duration = 5,
						Image = "ban",
					})
				end
			end,
		})
		-- dead cuz no longer mercury lib
		--if not JoinedSigmaServer then
		--	GUI:Prompt({
		--		Title = "Join Fart Hub discord server?",
		--		Text = "It would help alot, and you can get early access to features!!!",
		--		Buttons = {
		--			["Ya :3"] = function()
		--				setclipboard("https://discord.gg/AC4usvpwVY")
		--				GUI:Notification({ Title = "Discord Link Copied", Text = "i love you", Duration = 10 })
		--				JoinedSigmaServer = true
		--				WriteSigmaData()
		--			end,
		--			["No i hate you"] = function()
		--				GUI:Notification({ Title = "Ok :(", Text = "I understand.", Duration = 10 })
		--				WriteSigmaData()
		--			end,
		--		},
		--	})
		--end
	end

	CheckIfFartsDownloaded()
	InitializeGUI()
	MakeButton()
end

-- best key system no longer needed
--local function MakeKeySystem()
--	KeySystem = Instance.new("ScreenGui")
--	Frame = Instance.new("Frame")
--	TextBox = Instance.new("TextBox")
--	UICorner = Instance.new("UICorner")
--	UIPadding = Instance.new("UIPadding")
--	UICorner_2 = Instance.new("UICorner")
--	TextLabel = Instance.new("TextLabel")
--	CheckKeyButton = Instance.new("TextButton")
--	UICorner_3 = Instance.new("UICorner")
--	GetKey = Instance.new("TextButton")
--	UICorner_4 = Instance.new("UICorner")
--
--	KeySystem.Name = "KeySystem"
--	KeySystem.Parent = game:GetService("CoreGui")
--	KeySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
--	KeySystem.ResetOnSpawn = false
--
--	Frame.Parent = KeySystem
--	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
--	Frame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
--	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
--	Frame.BorderSizePixel = 0
--	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
--	Frame.Size = UDim2.new(0, 300, 0, 120)
--	Frame.ZIndex = 2
--
--	TextBox.Parent = Frame
--	TextBox.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
--	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
--	TextBox.BorderSizePixel = 0
--	TextBox.Position = UDim2.new(0, 0, 0, 10)
--	TextBox.Size = UDim2.new(1, 0, 0, 50)
--	TextBox.ClearTextOnFocus = false
--	TextBox.Font = Enum.Font.FredokaOne
--	TextBox.PlaceholderColor3 = Color3.fromRGB(97, 97, 97)
--	TextBox.PlaceholderText = "FartHub Key..."
--	TextBox.Text = ""
--	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
--	TextBox.TextSize = 22.000
--	TextBox.TextWrapped = true
--
--	UICorner.Parent = TextBox
--
--	UIPadding.Parent = Frame
--	UIPadding.PaddingBottom = UDim.new(0, 5)
--	UIPadding.PaddingLeft = UDim.new(0, 5)
--	UIPadding.PaddingRight = UDim.new(0, 5)
--	UIPadding.PaddingTop = UDim.new(0, 5)
--
--	UICorner_2.Parent = Frame
--
--	TextLabel.Parent = Frame
--	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--	TextLabel.BackgroundTransparency = 1.000
--	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
--	TextLabel.BorderSizePixel = 0
--	TextLabel.Position = UDim2.new(0, 0, 0, -20)
--	TextLabel.Size = UDim2.new(1, 0, 0, 30)
--	TextLabel.ZIndex = 0
--	TextLabel.Font = Enum.Font.FredokaOne
--	TextLabel.Text = "Fart Hub | Key System"
--	TextLabel.TextColor3 = Color3.fromRGB(221, 221, 221)
--	TextLabel.TextSize = 25.000
--	TextLabel.TextStrokeTransparency = 0.000
--	TextLabel.TextWrapped = true
--
--	CheckKeyButton.Name = "CheckKey"
--	CheckKeyButton.Parent = Frame
--	CheckKeyButton.AnchorPoint = Vector2.new(0, 1)
--	CheckKeyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--	CheckKeyButton.BackgroundTransparency = 1.000
--	CheckKeyButton.BorderColor3 = Color3.fromRGB(45, 45, 45)
--	CheckKeyButton.BorderSizePixel = 0
--	CheckKeyButton.Position = UDim2.new(0, 3, 1, 0)
--	CheckKeyButton.Size = UDim2.new(0.449999988, 0, 0, 40)
--	CheckKeyButton.Font = Enum.Font.FredokaOne
--	CheckKeyButton.Text = "Check Key"
--	CheckKeyButton.TextColor3 = Color3.fromRGB(106, 255, 103)
--	CheckKeyButton.TextSize = 22.000
--
--	UICorner_3.Parent = CheckKeyButton
--
--	GetKey.Name = "GetKey"
--	GetKey.Parent = Frame
--	GetKey.AnchorPoint = Vector2.new(1, 1)
--	GetKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--	GetKey.BackgroundTransparency = 1.000
--	GetKey.BorderColor3 = Color3.fromRGB(45, 45, 45)
--	GetKey.BorderSizePixel = 0
--	GetKey.Position = UDim2.new(1, -3, 1, 0)
--	GetKey.Size = UDim2.new(0.449999988, 0, 0, 40)
--	GetKey.Font = Enum.Font.FredokaOne
--	GetKey.Text = "Get Key"
--	GetKey.TextColor3 = Color3.fromRGB(255, 102, 125)
--	GetKey.TextSize = 22.000
--
--	UICorner_4.Parent = GetKey
--end

FartHubLoad()
