local FlipCooldown = false

local function FortniteFlips()
    if FlipCooldown then
        return
    end

    FlipCooldown = true
    local character = game:GetService("Players").LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not hrp or not humanoid then
        FlipCooldown = false
        return
    end

    humanoid:ChangeState("Jumping")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end

    local duration = 0.25
    local steps = 90
    local startCFrame = hrp.CFrame
    local forwardVector = startCFrame.LookVector
    local upVector = Vector3.new(0, 1, 0)

    for i = 1, steps do
        local t = i / steps
        local height = 4 * (t - t ^ 2) * 10
        local nextPos = startCFrame.Position + forwardVector * (35 * t) + upVector * height
        local rotation = startCFrame.Rotation * CFrame.Angles(-math.rad(i * (360 / steps)), 0, 0)

        hrp.CFrame = CFrame.new(nextPos) * rotation
        task.wait(duration / steps)
    end

    hrp.CFrame = CFrame.new(startCFrame.Position + forwardVector * 35) * startCFrame.Rotation

    if animator then
        humanoid:Move(Vector3.zero)
    end

    task.wait(0.1)
    FlipCooldown = false
end

local function PlayBoing()
    local sound = Instance.new("Sound", game:GetService("Players").LocalPlayer.Character)
    sound.SoundId = getcustomasset("FartHub/Assets/Boing.mp3")
    sound.PlaybackSpeed = math.random() * 1.3 + 1

    sound:Play()
end

PlayBoing()
FortniteFlips()