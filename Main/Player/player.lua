-- =================================================================
--                      ABA: PLAYER 
-- =================================================================

local PlayerTab = Window:CreateTab("Player", 4483362458) -- Ícone genérico

-- =========
-- GIRO 360
-- =========

local SpinEnabled = false
local SpinConnection = nil

PlayerTab:CreateToggle({
    Name = "Giro Rápido (360°)",
    CurrentValue = false,
    Flag = "ToggleSpinNormal",
    Callback = function(Value)
        SpinEnabled = Value

        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not root then return end

        if SpinEnabled then
            SpinConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
                local speed = math.rad(1440) -- duas voltas por segundo
                root.CFrame = root.CFrame * CFrame.Angles(0, speed * dt, 0)
            end)
        else
            if SpinConnection then
                SpinConnection:Disconnect()
                SpinConnection = nil
            end
        end
    end,
})

-- ===========
-- VELOCIDADE
-- ===========

PlayerTab:CreateSlider({
    Name = "Velocidade (WalkSpeed)",
    Range = {16, 600}, -- Mínimo 16, Máximo 300
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "SliderWalkSpeed", 
   Callback = function(Value)
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")

    if hum then
        hum.WalkSpeed = Value
    end

    FlightSpeed = Value -- 👈 voo = corrida
end

})

-- ===========
-- POWER JUMP 
-- ===========

local player = game.Players.LocalPlayer

PlayerTab:CreateSlider({
    Name = "Força do Pulo (JumpPower)",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "SliderJumpPower",
    Callback = function(Value)
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = Value
            end
        end
    end,
})

-- ==========================
-- RESETAR VELOCIDADE E PULO
-- ==========================

PlayerTab:CreateButton({
    Name = "Resetar velocidade e pulo",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")

        if hum then
            hum.WalkSpeed = 16
            hum.UseJumpPower = true
            hum.JumpPower = 50
        end

    end
})

-- ===============
-- VOAR (FLY)
-- ===============

local FlightEnabled = false

local BodyVelocity = nil
local BodyGyro = nil
FlightSpeed = 50
PlayerTab:CreateToggle({
    Name = "Voar (Fly)",
    CurrentValue = false,
    Flag = "ToggleFly", 
    Callback = function(Value)
        FlightEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if FlightEnabled and root then
          
            -- ATIVAÇÃO

           local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
            
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0,0,0)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Parent = root
            
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.P = 9e4
            BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.cframe = root.CFrame
            BodyGyro.Parent = root
            
            task.spawn(function()
    while FlightEnabled and humanoid and humanoid.Health > 0 do
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        task.wait(0.2)
    end
end)

            -- LOOP

            task.spawn(function()
                while FlightEnabled and character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 do
                    local camera = workspace.CurrentCamera
                    local moveDir = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls():GetMoveVector()
                    
                    BodyGyro.cframe = camera.CFrame
                    BodyVelocity.Velocity = (camera.CFrame.LookVector * moveDir.Z * -FlightSpeed) + (camera.CFrame.RightVector * moveDir.X * FlightSpeed)
                    
                    -- Subir e Descer com Espaço e Ctrl (Simulação simples)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        BodyVelocity.Velocity = BodyVelocity.Velocity + Vector3.new(0, FlightSpeed, 0)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                        BodyVelocity.Velocity = BodyVelocity.Velocity - Vector3.new(0, FlightSpeed, 0)
                    end
                    
                    task.wait()
                end
            end)
        else

            -- DESATIVAÇÃO

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
        
        local humanoid = character and character:FindFirstChild("Humanoid")
    
      if humanoid then
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)

        end
    end
end,

})

-- ============================
-- NOCLIP (ATRAVESSAR PAREDES)
-- ============================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local NoclipEnabled = false
local noclipConnection = nil

local function SetNoclip(character, state)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end
end

local function StartNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
	end

	noclipConnection = game:GetService("RunService").Stepped:Connect(function()
		if not NoclipEnabled then return end

		local character = player.Character
		if character then
			SetNoclip(character, true)
		end
	end)
end

local function StopNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	local character = player.Character
	if character then
		SetNoclip(character, false)
	end
end

-- Caso o player morra com noclip ativo
player.CharacterAdded:Connect(function(char)
	if NoclipEnabled then
		task.wait(0.5)
		SetNoclip(char, true)
	end
end)

PlayerTab:CreateToggle({
	Name = "Noclip (Atravessar paredes)",
	CurrentValue = false,
	Flag = "ToggleNoclip",
	Callback = function(Value)
		NoclipEnabled = Value

		if Value then
			StartNoclip()
		else
			StopNoclip()
		end
	end,
})