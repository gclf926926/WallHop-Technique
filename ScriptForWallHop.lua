-- Referências
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Criar a interface
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "WallHopHub"

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0, 20, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Text = "WallHop: OFF"
button.Parent = screenGui
button.Active = true
button.Draggable = true

-- Estado do WallHop
local wallhopAtivo = false

-- Função pra detectar parede na frente
local function estaNaParede()
	local rayOrigin = rootPart.Position
	local rayDirection = rootPart.CFrame.LookVector * 2
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local resultado = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	return resultado ~= nil
end

-- Loop do WallHop
RunService.RenderStepped:Connect(function()
	if wallhopAtivo and humanoid.FloorMaterial == Enum.Material.Air and estaNaParede() then
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = Vector3.new(rootPart.CFrame.LookVector.X * 20, 40, rootPart.CFrame.LookVector.Z * 20)
		bv.MaxForce = Vector3.new(100000, 100000, 100000)
		bv.Parent = rootPart
		game.Debris:AddItem(bv, 0.1)
	end
end)

-- Ativar / Desativar
button.MouseButton1Click:Connect(function()
	wallhopAtivo = not wallhopAtivo
	if wallhopAtivo then
		button.Text = "WallHop: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	else
		button.Text = "WallHop: OFF"
		button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	end
end)

-- Atualizar quando o player morrer/renascer
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end)
