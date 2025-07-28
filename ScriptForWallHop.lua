local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local canWallHop = false
local isWallHopping = false

-- Verifica se está encostando numa parede
local function encostadoNaParede()
	local origin = rootPart.Position
	local direction = rootPart.CFrame.LookVector * 2 -- distância do "raio"
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local hit = workspace:Raycast(origin, direction, params)
	return hit ~= nil
end

-- Atualiza se pode fazer WallHop
rs.RenderStepped:Connect(function()
	if humanoid.FloorMaterial == Enum.Material.Air and encostadoNaParede() then
		canWallHop = true
	else
		canWallHop = false
	end
end)

-- Faz o efeito do giro e impulso
local function fazerWallHop()
	if isWallHopping then return end
	isWallHopping = true

	-- Vira o personagem levemente pro lado
	local oldCFrame = rootPart.CFrame
	local offset = CFrame.Angles(0, math.rad(30), 0)
	rootPart.CFrame = oldCFrame * offset

	-- Impulso pra cima
	rootPart.Velocity = Vector3.new(0, 50, 0)

	-- Espera 1 segundo
	wait(1)

	-- Volta a olhar pra frente
	rootPart.CFrame = oldCFrame
	isWallHopping = false
end

-- Detecta quando o player pula
uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Space and canWallHop then
		fazerWallHop()
	end
end)

-- Atualizar referências quando morrer
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end)
