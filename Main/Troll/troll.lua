-- =================================================================
--                          ABA: TROLL 
-- =================================================================

local TrollTab = Window:CreateTab("Troll", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- =========================
-- CARREGA SCRIPT (ATUALIZAR PLAYERS)
-- =========================

TrollTab:CreateButton({
    Name = "Atualizar Players",
    Callback = function()
        local ScriptURL = "https://raw.githubusercontent.com/Vtr-Cardoso69/Cardox-Hub/main/href v2 (RECOMENDADO)"

        local success, err = pcall(function()
            loadstring(game:HttpGet(ScriptURL))()
        end)
    end
})

-- ===================
-- LISTA DE JOGADORES
-- ===================

local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

local SelectedPlayer = nil
local SpectateEnabled = false
local ESPEnabled = false
local FollowEnabled = false
local ESPHighlight = nil

local function GetSelectedPlayerObject()
    if not SelectedPlayer then return nil end
    return Players:FindFirstChild(SelectedPlayer)
end

-- =========
-- DROPDOWN
-- =========

TrollTab:CreateDropdown({
    Name = "Selecionar jogador",
    Options = GetPlayerNames(),
    CurrentOption = {},
    Flag = "SelectPlayer",
    Callback = function(option)
        SelectedPlayer = option[1]
        print("Selecionado:", SelectedPlayer)

        if SpectateEnabled then UpdateSpectate() end
        if ESPEnabled then UpdateESP() end
    end,
})

-- =========
-- SPECTATE
-- =========

function UpdateSpectate()
    local cam = workspace.CurrentCamera

    if SpectateEnabled then
        local plr = GetSelectedPlayerObject()
        if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = plr.Character.Humanoid
        end
    else
        local myChar = Players.LocalPlayer.Character
        if myChar and myChar:FindFirstChild("Humanoid") then
            cam.CameraSubject = myChar.Humanoid
        end
    end
end

TrollTab:CreateToggle({
    Name = "Spectar jogador",
    CurrentValue = false,
    Flag = "ToggleSpectatePlayer",
    Callback = function(v)
        SpectateEnabled = v
        UpdateSpectate()
    end,
})

-- =========
-- TELEPORT
-- =========

local function TeleportToPlayer()
    local plr = GetSelectedPlayerObject()
    local myChar = Players.LocalPlayer.Character
    if not plr or not plr.Character or not myChar then return end

    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")

    if tRoot and myRoot then
        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
    end
end

TrollTab:CreateButton({
    Name = "Teleportar até jogador",
    Callback = TeleportToPlayer
})

-- ===============
-- SEGUIR JOGADOR
-- ===============

RunService.RenderStepped:Connect(function()
    if FollowEnabled then
        local plr = GetSelectedPlayerObject()
        local myChar = Players.LocalPlayer.Character

        if plr and plr.Character and myChar then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")

            if tRoot and myRoot then
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
end)

TrollTab:CreateToggle({
    Name = "Seguir jogador",
    CurrentValue = false,
    Callback = function(v)
        FollowEnabled = v
    end,
})

-- ==========
-- ESP VISÃO
-- ==========

function UpdateESP()
    if ESPHighlight then
        ESPHighlight:Destroy()
        ESPHighlight = nil
    end

    if ESPEnabled then
        local plr = GetSelectedPlayerObject()
        if plr and plr.Character then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee = plr.Character
            h.Parent = plr.Character
            ESPHighlight = h
        end
    end
end

TrollTab:CreateToggle({
    Name = "ESP no jogador",
    CurrentValue = false,
    Callback = function(v)
        ESPEnabled = v
        UpdateESP()
    end,
})

-- ===============
-- COPIAR POSIÇÃO
-- ===============

local SavedPosition = nil

TrollTab:CreateButton({
    Name = "Copiar posição do jogador",
    Callback = function()
        local plr = GetSelectedPlayerObject()
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            SavedPosition = plr.Character.HumanoidRootPart.CFrame
            print("Posição copiada")
        end
    end,
})

TrollTab:CreateButton({
    Name = "Ir para posição copiada",
    Callback = function()
        if SavedPosition then
            local myChar = Players.LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = SavedPosition
            end
        end
    end,
})

-- ====================
-- PERCORRER JOGADORES
-- ====================

local TourDuration = 2

local FollowAllActive = false
local FollowTaskRunning = false
local FollowStartCFrame = nil

local function FollowTargetForSeconds(tRoot, seconds)
    local myChar = Players.LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not tRoot then return end
    local start = os.clock()
    while os.clock() - start < seconds do
        if not FollowAllActive or not myRoot.Parent or not tRoot.Parent then break end
        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2)
        game:GetService("RunService").RenderStepped:Wait()
    end
end

local function FollowThroughAllPlayersOnce()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                FollowTargetForSeconds(tRoot, TourDuration)
            end
        end
    end
end

TrollTab:CreateToggle({
    Name = "Seguir todos",
    CurrentValue = false,
    Flag = "ToggleFollowAll",
    Callback = function(v)
        FollowAllActive = v
        local myChar = Players.LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if v then
            FollowStartCFrame = myRoot and myRoot.CFrame or nil
            if not FollowTaskRunning then
                FollowTaskRunning = true
                task.spawn(function()
                    FollowThroughAllPlayersOnce()
                    FollowTaskRunning = false
                    local finalChar = Players.LocalPlayer.Character
                    local finalRoot = finalChar and finalChar:FindFirstChild("HumanoidRootPart")
                    if FollowStartCFrame and finalRoot then
                        finalRoot.CFrame = FollowStartCFrame
                    end
                end)
            end
        else
            -- Desliga: o retorno à posição inicial será feito ao encerrar a thread
        end
    end,
})