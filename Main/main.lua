--[[
    LINK    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vtr-Cardoso69/Cardox-Hub/main/Main/main.lua"))()

    SCRIPT DE TESTE - CARDOX HUB
    Compatível com: Delta, Fluxus, Hydrogen, Arceus X, etc.
    
    Este script usa a biblioteca 'Rayfield Interface Suite' para criar um menu bonito e organizado.
    O código está aberto e comentado para estudo.
]]

local BaseURL = "https://raw.githubusercontent.com/Vtr-Cardoso69/Cardox-Hub/main/Main/"

local function LoadModule(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseURL .. path)
    end)

    if not success then
        warn("Erro ao baixar módulo: " .. path)
        return nil
    end

    if content then
        local func, err = loadstring(content)
        if not func then
            warn("Erro de sintaxe no módulo " .. path .. ": " .. err)
            return nil
        end

        local ok, result = pcall(func)
        if not ok then
            warn("Erro ao executar módulo " .. path .. ": " .. result)
            return nil
        end

        return result
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
