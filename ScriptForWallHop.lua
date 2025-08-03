local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- Variáveis de controle
local canWallHop = false
local isWallHopping = false
local wallHopAtivado = true

-- Criar o mini hubzinho
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "WallHopHub"

local botao = Instance.new("TextButton", screenGui)
botao.Size = UDim2.new(0, 120, 0, 40)
botao.Position = UDim2.new(0, 20, 0, 80)
botao.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.Font = Enum.Font.GothamBold
botao.TextSize = 16
botao.Text = "WallHop: ON"

-- Quando clicar no botão
botao.MouseButton1Click:Connect(function()
	wallHopAtivado = not wallHopAtivado
	botao.Text = "WallHop: " .. (wallHopAtivado and "ON" or "OFF")
end)

-- Detectar parede
local function encostadoNaParede()
	local origin = rootPart.Position
	local direction = rootPart.CFrame.LookVector * 2
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local hit = workspace:Raycast(origin, direction, params)
	return hit ~= nil
end

-- Verifica se pode WallHop
rs.RenderStepped:Connect(function()
	if humanoid.FloorMaterial == Enum.Material.Air and encostadoNaParede() then
		canWallHop = true
	else
		canWallHop = false
	end
end)

-- Fazer o WallHop
local function fazerWallHop()
	if isWallHopping then return end
	isWallHopping = true

	-- Girar para o lado
	local oldCFrame = rootPart.CFrame
	local offset = CFrame.Angles(0, math.rad(30), 0)
	rootPart.CFrame = oldCFrame * offset

	-- Impulso
	rootPart.Velocity = Vector3.new(0, 50, 0)

	wait(1)

	-- Voltar a posição original
	rootPart.CFrame = oldCFrame
	isWallHopping = false
end

-- Detectar pulo
uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Space and canWallHop and wallHopAtivado then
		fazerWallHop()
	end
end)

-- Atualizar se morrer
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end)
