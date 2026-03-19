-- =================================================================
--                          ABA: VISUALS
-- =================================================================

local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local ESPEnabled = false

-- ====================
-- ESP (VER JOGADORES)
-- ====================

local function AddESP(character)
    if not ESPEnabled then return end
    if character:FindFirstChild("HighlightESP") then return end -- Já tem ESP
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "HighlightESP"
    highlight.FillColor = Color3.fromRGB(255, 255, 255) -- Branco
    highlight.OutlineColor = Color3.fromRGB(1, 137, 249) -- Azul
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.1
    highlight.Adornee = character
    highlight.Parent = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Vê através das paredes
end

-- Função para Remover ESP
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
            -- Adiciona em quem já está no jogo
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    AddESP(player.Character)
                end
            end
            
            -- Conecta evento para novos personagens
            
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if ESPEnabled then
                        task.wait(1) -- Espera carregar
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

local NameESPEnabled = false

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

    -- 🔒 tamanho fixo:
    text.TextScaled = false
    text.TextSize = 18  -- ajuste aqui (16–22 é um bom intervalo)

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

-- ================
-- ESP (VER NOMES)
-- ================

VisualsTab:CreateToggle({
    Name = "ESP Nome dos jogadores",
    CurrentValue = false,
    Flag = "ToggleNameESP",
    Callback = function(v)
        NameESPEnabled = v

        if v then
            -- jogadores atuais
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    AddNameESP(plr.Character, plr.Name)
                end
            end

            -- novos jogadores
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

local JoinLogEnabled = false

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