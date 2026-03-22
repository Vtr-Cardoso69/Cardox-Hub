local VisualsModule = {}

function VisualsModule.Init(VisualsTab, Rayfield)
    local Players = game:GetService("Players")
    local ESPEnabled = false
    local NameESPEnabled = false
    local JoinLogEnabled = false

    -- ====================
    -- ESP (VER JOGADORES)
    -- ====================

    local function AddESP(character)
        if not ESPEnabled then return end
        if character:FindFirstChild("HighlightESP") then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(1, 137, 249)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.1
        highlight.Adornee = character
        highlight.Parent = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

    local function RemoveESP()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HighlightESP") then
                player.Character.HighlightESP:Destroy()
            end
        end
    end

    VisualsTab:CreateToggle({
        Name = "ESP (Ver Jogadores)",
        CurrentValue = false,
        Flag = "ToggleESP", 
        Callback = function(Value)
            ESPEnabled = Value
            if ESPEnabled then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        AddESP(player.Character)
                    end
                end
                game.Players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Connect(function(character)
                        if ESPEnabled then
                            task.wait(1)
                            AddESP(character)
                        end
                    end)
                end)
            else
                RemoveESP()
            end
        end,
    })

    -- ================
    -- ESP (VER NOMES)
    -- ================

    local function AddNameESP(character, playerName)
        if character:FindFirstChild("NameESP") then return end
        local head = character:FindFirstChild("Head")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = character

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = playerName
        text.TextColor3 = Color3.fromRGB(1, 137, 249)
        text.TextStrokeTransparency = 0.3
        text.TextScaled = false
        text.TextSize = 18
        text.Font = Enum.Font.SourceSansBold
        text.Parent = billboard
    end

    local function RemoveNameESP()
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("NameESP") then
                plr.Character.NameESP:Destroy()
            end
        end
    end

    VisualsTab:CreateToggle({
        Name = "ESP Nome dos jogadores",
        CurrentValue = false,
        Flag = "ToggleNameESP",
        Callback = function(v)
            NameESPEnabled = v
            if v then
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= game.Players.LocalPlayer and plr.Character then
                        AddNameESP(plr.Character, plr.Name)
                    end
                end
                game.Players.PlayerAdded:Connect(function(plr)
                    plr.CharacterAdded:Connect(function(char)
                        if NameESPEnabled then
                            task.wait(1)
                            AddNameESP(char, plr.Name)
                        end
                    end)
                end)
            else
                RemoveNameESP()
            end
        end,
    })

    -- ==============
    -- DATA (ENTRADA)
    -- ==============

    VisualsTab:CreateToggle({
        Name = "DATA (ENTRADA)",
        CurrentValue = false,
        Flag = "ToggleJoinLog",
        Callback = function(v)
            JoinLogEnabled = v
        end,
    })

    game.Players.PlayerAdded:Connect(function(plr)
        if JoinLogEnabled then
            Rayfield:Notify({
                Title = "Novo Jogador!",
                Content = plr.Name .. " entrou no servidor.",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end)

    -- =========================
    -- ESP IDADE DA CONTA
    -- =========================

    local AccountAgeESPEnabled = false
    local cache = {}

    -- FUNÇÃO CACHE
    local function getAccountAgeDays(plr)
        if cache[plr.UserId] then
            return cache[plr.UserId]
        end

        local days = plr.AccountAge
        if days then
            cache[plr.UserId] = days
            return days
        end
        return nil
    end

    -- CRIAR ESP
    local function AddAccountAgeESP(character, plr)
        if not AccountAgeESPEnabled then return end
        if character:FindFirstChild("AccountAgeESP") then return end

        local head = character:FindFirstChild("Head")
        if not head then return end

        local days = getAccountAgeDays(plr)
        if not days then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AccountAgeESP"
        billboard.Size = UDim2.new(0, 120, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 100
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = days .. " dias"
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Parent = billboard
    end

    -- REMOVER
    local function RemoveAccountAgeESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local esp = plr.Character:FindFirstChild("AccountAgeESP")
                if esp then esp:Destroy() end
            end
        end
    end

    -- TOGGLE
    VisualsTab:CreateToggle({
        Name = "Idade da conta (dias)",
        CurrentValue = false,
        Flag = "AccountAgeESP",
        Callback = function(v)
            AccountAgeESPEnabled = v

            if v then
                -- Aplica nos jogadores atuais
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Players.LocalPlayer and plr.Character then
                        AddAccountAgeESP(plr.Character, plr)
                    end
                end

                -- Conecta para novos jogadores
                Players.PlayerAdded:Connect(function(plr)
                    plr.CharacterAdded:Connect(function(char)
                        if AccountAgeESPEnabled then
                            task.wait(1)
                            AddAccountAgeESP(char, plr)
                        end
                    end)
                end)

                -- Conecta para respawn de jogadores atuais
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Players.LocalPlayer then
                        plr.CharacterAdded:Connect(function(char)
                            if AccountAgeESPEnabled then
                                task.wait(1)
                                AddAccountAgeESP(char, plr)
                            end
                        end)
                    end
                end
            else
                RemoveAccountAgeESP()
            end
        end,
    })
end

return VisualsModule
