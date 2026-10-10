-- ============================================
-- 🌑 SOMBRA HUB v6.0 | Blox Fruits
-- Auto Farm Funcional + ESP + Movimento
-- GitHub: github.com/josemiro273-rgb/Sombra
-- ============================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- CONFIGURAÇÕES
-- ============================================
local Config = {
    -- Auto Farm
    AutoFarmAtivo = false,
    NPCSelecionado = "Bandits",
    DistanciaAtaque = 8,
    CooldownAtaque = 0.4,
    AutoEquiparArma = true,
    
    -- Movimento
    SpeedAtivo = false,
    SpeedValor = 50,
    JumpAtivo = false,
    JumpValor = 100,
    FlyAtivo = false,
    FlyVelocidade = 100,
    NoClip = false,
    
    -- Visual
    ESPAtivo = false,
    ESPCor = Color3.fromRGB(150, 80, 255),
    ESPNome = true,
    ESPDist = true,
    Fullbright = false,
    
    objetosESP = {},
}

-- Lista de NPCs do Blox Fruits
local ListaNPCs = {
    "Bandits", "Monkey", "Toga Warriors", "Pirate", "Galley Pirate",
    "Fishman", "Desert Bandit", "Snow Bandit", "Reborn Skeleton",
    "Living Zombie", "Demonic Soul", "Posessed Mummy", "Mob Leader",
    "Vice Admiral", "Saber Expert", "Greybeard", "Darkbeard",
    "Cursed Captain", "Cursed Skeleton", "Bobby", "Citizen"
}

-- ============================================
-- JANELA PRINCIPAL
-- ============================================
local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Blox Fruits | v6.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Farm = Window:AddTab({ Title = "Auto Farm", Icon = "zap" }),
    Mov = Window:AddTab({ Title = "Movimento", Icon = "move" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "settings" })
}

-- ============================================
-- ABA: AUTO FARM
-- ============================================
Tabs.Farm:AddParagraph({
    Title = "🌾 Auto Farm",
    Content = "Farm automático que funciona de verdade"
})

Tabs.Farm:AddDropdown("NPC", {
    Title = "Selecionar NPC",
    Description = "Qual inimigo farmar?",
    Values = ListaNPCs,
    Default = "Bandits",
    Callback = function(valor)
        Config.NPCSelecionado = valor
    end
})

Tabs.Farm:AddToggle("AutoFarm", {
    Title = "🌾 Auto Farm",
    Description = "Farmar XP automaticamente",
    Default = false,
    Callback = function(valor)
        Config.AutoFarmAtivo = valor
        Fluent:Notify({
            Title = "Sombra Hub",
            Content = valor and "Auto Farm LIGADO ✅" or "Auto Farm DESLIGADO ❌",
            Duration = 3
        })
    end
})

Tabs.Farm:AddToggle("AutoArma", {
    Title = "⚔️ Auto Equipar Arma",
    Description = "Equipa arma automaticamente",
    Default = true,
    Callback = function(valor)
        Config.AutoEquiparArma = valor
    end
})

Tabs.Farm:AddSlider("Cooldown", {
    Title = "Cooldown de Ataque",
    Description = "Tempo entre ataques (segundos)",
    Default = 0.4,
    Min = 0.1,
    Max = 1,
    Rounding = 1,
    Callback = function(valor)
        Config.CooldownAtaque = valor
    end
})

Tabs.Farm:AddButton({
    Title = "🎯 Teleportar para NPC",
    Description = "Vai direto pro NPC selecionado",
    Callback = function()
        local npc = acharNPC()
        if npc then
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            local meuHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and meuHRP then
                meuHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
                Fluent:Notify({
                    Title = "Sombra Hub",
                    Content = "Teleportado para " .. npc.Name,
                    Duration = 2
                })
            end
        else
            Fluent:Notify({
                Title = "Sombra Hub",
                Content = "NPC não encontrado!",
                Duration = 3
            })
        end
    end
})

-- ============================================
-- ABA: MOVIMENTO
-- ============================================
Tabs.Mov:AddParagraph({
    Title = "⚡ Movimento",
    Content = "Modificadores de movimento"
})

Tabs.Mov:AddToggle("Speed", {
    Title = "⚡ Speed Hack",
    Default = false,
    Callback = function(valor)
        Config.SpeedAtivo = valor
        if not valor then
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid.WalkSpeed = 16
            end
        end
    end
})

Tabs.Mov:AddSlider("SpeedSlider", {
    Title = "Velocidade",
    Default = 50,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(valor)
        Config.SpeedValor = valor
    end
})

Tabs.Mov:AddToggle("Jump", {
    Title = "🦘 Jump Power",
    Default = false,
    Callback = function(valor)
        Config.JumpAtivo = valor
    end
})

Tabs.Mov:AddSlider("JumpSlider", {
    Title = "Força do Pulo",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(valor)
        Config.JumpValor = valor
    end
})

Tabs.Mov:AddToggle("Fly", {
    Title = "🕊️ Fly (Voo)",
    Description = "Use WASD + Space/Ctrl",
    Default = false,
    Callback = function(valor)
        Config.FlyAtivo = valor
        if valor then
            ativarVoo()
        else
            desativarVoo()
        end
    end
})

Tabs.Mov:AddToggle("NoClip", {
    Title = "👻 NoClip",
    Default = false,
    Callback = function(valor)
        Config.NoClip = valor
    end
})

-- ============================================
-- ABA: VISUAL
-- ============================================
Tabs.Visual:AddParagraph({
    Title = "👁️ Visual",
    Content = "ESP e melhorias visuais"
})

Tabs.Visual:AddToggle("ESP", {
    Title = "👁️ ESP Players",
    Default = false,
    Callback = function(valor)
        Config.ESPAtivo = valor
        if not valor then
            for _, obj in pairs(Config.objetosESP) do
                if obj.Highlight then obj.Highlight:Destroy() end
                if obj.Billboard then obj.Billboard:Destroy() end
            end
            Config.objetosESP = {}
        end
    end
})

Tabs.Visual:AddToggle("ESPNome", {
    Title = "📝 Mostrar Nome",
    Default = true,
    Callback = function(valor)
        Config.ESPNome = valor
    end
})

Tabs.Visual:AddToggle("ESPDist", {
    Title = "📏 Mostrar Distância",
    Default = true,
    Callback = function(valor)
        Config.ESPDist = valor
    end
})

Tabs.Visual:AddColorpicker("ESPCor", {
    Title = "🎨 Cor do ESP",
    Default = Color3.fromRGB(150, 80, 255),
    Callback = function(cor)
        Config.ESPCor = cor
        for _, obj in pairs(Config.objetosESP) do
            if obj.Highlight then
                obj.Highlight.FillColor = cor
                obj.Highlight.OutlineColor = cor
            end
        end
    end
})

Tabs.Visual:AddToggle("Fullbright", {
    Title = "💡 Fullbright",
    Default = false,
    Callback = function(valor)
        Config.Fullbright = valor
        local lighting = game:GetService("Lighting")
        if valor then
            lighting.Brightness = 5
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            lighting.Brightness = 2
            lighting.Ambient = Color3.fromRGB(70, 70, 70)
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

-- ============================================
-- ABA: UTILS
-- ============================================
Tabs.Utils:AddParagraph({
    Title = "⚙️ Utilitários",
    Content = "Funções extras"
})

Tabs.Utils:AddButton({
    Title = "🚫 Anti-AFK",
    Description = "Evita kick por inatividade",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Fluent:Notify({
            Title = "Sombra Hub",
            Content = "Anti-AFK ativado!",
            Duration = 3
        })
    end
})

Tabs.Utils:AddButton({
    Title = "🔄 Resetar Personagem",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end
})

Tabs.Utils:AddButton({
    Title = "📋 Copiar Discord",
    Callback = function()
        setclipboard("discord.gg/sombrahub")
        Fluent:Notify({
            Title = "Sombra Hub",
            Content = "Discord copiado!",
            Duration = 2
        })
    end
})

-- ============================================
-- FUNÇÃO: ACHAR NPC MAIS PRÓXIMO
-- ============================================
function acharNPC()
    local melhor = nil
    local menorDist = 300
    local meuHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not meuHRP then return nil end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp and hum.Health > 0 then
                if string.find(string.lower(obj.Name), string.lower(Config.NPCSelecionado)) then
                    local dist = (meuHRP.Position - hrp.Position).Magnitude
                    if dist < menorDist then
                        menorDist = dist
                        melhor = obj
                    end
                end
            end
        end
    end
    return melhor
end

-- ============================================
-- FUNÇÃO: EQUIPAR ARMA
-- ============================================
local function equiparArma()
    if not Config.AutoEquiparArma then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    if char:FindFirstChildOfClass("Tool") then return end
    
    local mochila = LocalPlayer:FindFirstChild("Backpack")
    if not mochila then return end
    
    for _, item in ipairs(mochila:GetChildren()) do
        if item:IsA("Tool") then
            pcall(function()
                char.Humanoid:EquipTool(item)
            end)
            return
        end
    end
end

-- ============================================
-- FUNÇÃO: ATACAR COM COOLDOWN
-- ============================================
local ultimoAtaque = 0
local function atacar()
    local agora = tick()
    if agora - ultimoAtaque < Config.CooldownAtaque then return end
    ultimoAtaque = agora
    
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    
    if tool then
        pcall(function()
            tool:Activate()
        end)
    end
end

-- ============================================
-- FUNÇÃO: VOO
-- ============================================
local bgVoo, bvVoo

function ativarVoo()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    bgVoo = Instance.new("BodyGyro", hrp)
    bgVoo.P = 9e4
    bgVoo.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bgVoo.CFrame = hrp.CFrame
    
    bvVoo = Instance.new("BodyVelocity", hrp)
    bvVoo.Velocity = Vector3.new(0, 0, 0)
    bvVoo.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        while Config.FlyAtivo and hrp.Parent do
            local mov = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mov += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mov -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mov -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mov += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mov += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mov -= Vector3.new(0, 1, 0) end
            bvVoo.Velocity = mov * Config.FlyVelocidade
            bgVoo.CFrame = Camera.CFrame
            RunService.RenderStepped:Wait()
        end
        if bgVoo then bgVoo:Destroy() end
        if bvVoo then bvVoo:Destroy() end
    end)
end

function desativarVoo()
    if bgVoo then bgVoo:Destroy() end
    if bvVoo then bvVoo:Destroy() end
    bgVoo = nil
    bvVoo = nil
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================
RunService.Heartbeat:Connect(function()
    -- AUTO FARM (lógica que funciona)
    if Config.AutoFarmAtivo then
        equiparArma()
        
        local npc = acharNPC()
        if npc then
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local meuChar = LocalPlayer.Character
            local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
            local meuHum = meuChar and meuChar:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum and hum.Health > 0 and meuHRP and meuHum then
                local dist = (meuHRP.Position - hrp.Position).Magnitude
                
                if dist > Config.DistanciaAtaque then
                    -- ANDA até o NPC (movimento válido)
                    meuHum:MoveTo(hrp.Position)
                else
                    -- Para e ataca
                    meuHum:MoveTo(meuHRP.Position)
                    atacar()
                end
            end
        end
    end
    
    -- SPEED
    if Config.SpeedAtivo then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = Config.SpeedValor
        end
    end
    
    -- JUMP
    if Config.JumpAtivo then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.JumpPower = Config.JumpValor
            c.Humanoid.UseJumpPower = true
        end
    end
    
    -- NOCLIP
    if Config.NoClip then
        local c = LocalPlayer.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
    
    -- ESP
    if Config.ESPAtivo then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not Config.objetosESP[p] then
                local char = p.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Config.ESPCor
                    hl.OutlineColor = Config.ESPCor
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 200, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = hrp
                    
                    local nome = Instance.new("TextLabel")
                    nome.Name = "Nome"
                    nome.Size = UDim2.new(1, 0, 0, 22)
                    nome.BackgroundTransparency = 1
                    nome.Text = p.Name
                    nome.TextColor3 = Config.ESPCor
                    nome.TextStrokeTransparency = 0
                    nome.TextSize = 15
                    nome.Font = Enum.Font.GothamBold
                    nome.Visible = Config.ESPNome
                    nome.Parent = bb
                    
                    local dist = Instance.new("TextLabel")
                    dist.Name = "Dist"
                    dist.Size = UDim2.new(1, 0, 0, 18)
                    dist.Position = UDim2.new(0, 0, 0, 22)
                    dist.BackgroundTransparency = 1
                    dist.Text = "0 studs"
                    dist.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dist.TextStrokeTransparency = 0
                    dist.TextSize = 12
                    dist.Font = Enum.Font.Gotham
                    dist.Visible = Config.ESPDist
                    dist.Parent = bb
                    
                    Config.objetosESP[p] = {
                        Highlight = hl, Billboard = bb, Nome = nome, Dist = dist, Character = char
                    }
                end
            end
        end
        
        -- Atualiza info
        local meuHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for p, obj in pairs(Config.objetosESP) do
            if not obj.Character.Parent then
                if obj.Highlight then obj.Highlight:Destroy() end
                if obj.Billboard then obj.Billboard:Destroy() end
                Config.objetosESP[p] = nil
            else
                if obj.Nome then obj.Nome.Visible = Config.ESPNome end
                if obj.Dist and meuHRP then
                    local hrp = obj.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = math.floor((meuHRP.Position - hrp.Position).Magnitude)
                        obj.Dist.Text = d .. " studs"
                        obj.Dist.Visible = Config.ESPDist
                    end
                end
            end
        end
    end
end)

-- ============================================
-- LIMPEZA
-- ============================================
Players.PlayerRemoving:Connect(function(p)
    if Config.objetosESP[p] then
        local o = Config.objetosESP[p]
        if o.Highlight then o.Highlight:Destroy() end
        if o.Billboard then o.Billboard:Destroy() end
        Config.objetosESP[p] = nil
    end
end)

-- ============================================
-- NOTIFICAÇÃO FINAL
-- ============================================
Fluent:Notify({
    Title = "Sombra Hub v6.0",
    Content = "Carregado com sucesso!",
    Duration = 5
})

print("🌑 Sombra Hub v6.0 carregado!")
