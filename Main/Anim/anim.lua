local AnimModule = {}

function AnimModule.Init(AnimTab)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    -- =================== 
    -- CARREGA SCRIPT ANIM
    -- ===================

    AnimTab:CreateButton({
        Name = "Carregar Anims",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
            end)

            if not success then
                warn("Erro ao carregar script:", err)
            end
        end
    })

    -- ================= 
    -- EMOTES CLASSICOS
    -- =================

    local Emotes = {
        [1] = {name="Dance 1", id=507771019},
        [2] = {name="Dance 2", id=507776043},
        [3] = {name="Dance 3", id=507777268},
        [4] = {name="Wave", id=507770239},
        [5] = {name="Point", id=507770453},
        [6] = {name="Laugh", id=507770818},
        [7] = {name="Clap", id=507770677},
        [8]  = {name="Cheer", id=507770677},
        [9]  = {name="Salute", id=421245537},
        [10] = {name="Tilt", id=3360689775},
        [11] = {name="Hero Landing", id=5104374556},
        [12] = {name="Shrug", id=3576968026},
        [13] = {name="Applaud", id=5915779043},
        [14] = {name="Stadium", id=3360686498},
        [15] = {name="Jumping Jack", id=5895009708},
        [16] = {name="Confused", id=4940561610},
        [17] = {name="Happy", id=4841405708},
        [18] = {name="Robot", id=6160882116},
        [19] = {name="Twirl", id=3716636630},
        [20] = {name="Shy", id=3576968026},
        [21] = {name="Wave Loop", id=128777973},
        [22] = {name="Arm Wave", id=128853357},
        [23] = {name="Celebrate", id=3994127840},
        [24] = {name="Spin", id=913402848},
        [25] = {name="Idle Pose", id=180435571},
        [26] = {name="Excited", id=507770239},
        [27] = {name="Victory", id=155065061},
        [28] = {name="Sit Relax", id=2506281703},
        [29] = {name="Stretch", id=507776043},
        [30] = {name="Dance Loop", id=3189773368},
    }

    local SelectedEmote = 1
    local CurrentAnimation = nil

    local function PlayAnim(id)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")

        if CurrentAnimation then
            CurrentAnimation:Stop()
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..id
        local track = animator:LoadAnimation(animation)
        track:Play()
        CurrentAnimation = track

        humanoid.Jumping:Connect(function()
            if CurrentAnimation then
                CurrentAnimation:Stop()
            end
        end)
    end

    local Options = {}
    for i,v in pairs(Emotes) do
        table.insert(Options, v.name)
    end

    AnimTab:CreateDropdown({
        Name = "Selecionar Emote",
        Options = Options,
        CurrentOption = {Options[1]},
        Callback = function(option)
            local selection = type(option) == "table" and option[1] or option
            for i,v in pairs(Emotes) do
                if v.name == selection then
                    SelectedEmote = i
                    break
                end
            end
        end
    })

    AnimTab:CreateButton({
        Name = "Play Emote",
        Callback = function()
            local id = Emotes[SelectedEmote].id
            PlayAnim(id)
        end
    })
end

return AnimModule
