local BaseURL = "https://raw.githubusercontent.com/Vtr-Cardoso69/Cardox-Hub/main/Main/"

local function LoadModule(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. path)
    end)

    if success and content then
        local func = loadstring(content)
        if func then
            return func()
        end
    end
end
-- Inicializa Rayfield (uma única vez)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()  

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "Cardox Hub - v3",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "Por Trae AI x Cardox x GPT",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CardoxHubV3", 
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

-- Cria abas (tabs)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local TrollTab = Window:CreateTab("Troll", 4483362458)
local AnimTab = Window:CreateTab("Animações", 4483362458)

-- Carrega os módulos remotamente do GitHub
local Player = LoadModule("Player/player.lua")
local Visuals = LoadModule("Visuals/visual.lua")
local Troll = LoadModule("Troll/troll.lua")
local Anim = LoadModule("Anim/anim.lua")

-- Inicializa cada aba com suas funções
if Player and Player.Init then Player.Init(PlayerTab) end
if Visuals and Visuals.Init then Visuals.Init(VisualsTab, Rayfield) end
if Troll and Troll.Init then Troll.Init(TrollTab) end
if Anim and Anim.Init then Anim.Init(AnimTab) end

-- Notificação de sucesso
Rayfield:Notify({
    Title = "Hub Carregado!",
    Content = "Cardox Hub v3 inicializado com sucesso via GitHub.",
    Duration = 5,
    Image = 4483362458,
})
