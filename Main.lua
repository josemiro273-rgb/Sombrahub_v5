-- ============================================
-- 🌑 SOMBRA HUB v5.0 | Blox Fruits
-- Open-Source | Auto Farm Funcional
-- GitHub: github.com/josemiro273-rgb/Sombra
-- ============================================

-- Biblioteca de UI (open-source - MIT)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Serviços
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
    AutoFarmAtivo = false,
    AutoQuestAtivo = false,
    AutoAttackAtivo = false,
    AutoCollectAtivo = false,
    NPCSelecionado = "Bandits",
    DistanciaFarm = 30,
    Velocidade = 50,
    SpeedAtivo = false,
    JumpAtivo = false,
    FlyAtivo = false,
    ESPAtivo = false,
    ESPCor = Color3.fromRGB(150, 80, 255),
    Fullbright = false,
    NoClip = false,
    objetosESP = {},
}

-- Lista de NPCs (você pode adicionar mais)
local ListaNPCs = {
    "Bandits", "Monkey", "Toga Warriors", "Pirate", "Galley Pirate",
    "Fishman", "Desert Bandit", "Snow Bandit", "Reborn Skeleton",
    "Living Zombie", "Demonic Soul", "Posessed Mummy", "Mob Leader",
    "Vice Admiral", "Saber Expert", "Greybeard", "Darkbeard",
    "Cursed Captain", "Cursed Skeleton", "Reborn Skeleton"
}

-- ============================================
-- JANELA PRINCIPAL
-- ============================================
local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Blox Fruits | v5.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Farm = Window:AddTab({ Title = "Auto Farm", Icon = "zap" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Mov = Window:AddTab({ Title = "Movimento", Icon = "move" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "settings" })
}

-- ============================================
-- ABA: AUTO FARM
-- ============================================
Tabs.Farm:AddParagraph({
    Title = "🌾 Auto Farm",
    Content = "Automatize seu progresso no Blox Fruits"
})

Tabs.Farm:AddDropdown("NPC_Dropdown", {
    Title = "Selecionar NPC",
    Description = "Qual inimigo farmar?",
    Values = ListaNPCs,
    Default = "Bandits",
    Multi = false,
    Callback = function(valor)
        Config.NPCSelecionado = valor
    end
})

Tabs.Farm:AddToggle("Farm_Toggle", {
    Title = "🌾 Auto Farm Level",
    Description = "Farmar XP automaticamente",
    Default = false,
    Callback = function(valor)
        Config.AutoFarmAtivo = valor
        Fluent:Notify({
            Title = "Sombra Hub",
            Content = "Auto Farm: " .. (valor and "LIGADO ✅" or "DESLIGADO ❌"),
            Duration = 3
        })
    end
})

Tabs.Farm:AddToggle("Quest_Toggle", {
    Title = "📜 Auto Quest",
    Description = "Completar missões automaticamente",
    Default = false,
    Callback = function(valor)
        Config.AutoQuestAtivo = valor
    end
})

Tabs.Farm:AddSlider("Distancia_Slider", {
    Title = "Distância do Farm",
    Description = "Distância para teleportar até o NPC",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(valor)
        Config.DistanciaFarm = valor
    end
})

Tabs.Farm:AddButton({
    Title = "🎯 Teleportar para NPC",
    Description = "Vai direto pro NPC selecionado",
    Callback = function()
        local npc = acharNPC()
        if npc then
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            local meuChar = LocalPlayer.Character
            local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
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
-- ABA: COMBAT
-- ============================================
Tabs.Combat:AddParagraph({
    Title = "⚔️ Combate",
    Content = "Automação de ataques"
})

Tabs.Combat:AddToggle("Attack_Toggle", {
    Title = "⚔️ Auto Attack",
    Description = "Ataca automaticamente quando perto do NPC",
    Default = false,
    Callback = function(valor)
        Config.AutoAttackAtivo = valor
    end
})

Tabs.Combat:AddButton({
    Title = "🗡️ Ativar Arma",
    Description = "Equipa a primeira arma do inventário",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local mochila = LocalPlayer:FindFirstChild("Backpack")
        if mochila then
            for _, item in ipairs(mochila:GetChildren()) do
                if item:IsA("Tool") then
                    item.Parent = char
                    Fluent:Notify({
                        Title = "Sombra Hub",
                        Content = "Equipou: " .. item.Name,
                        Duration = 2
                    })
                    return
                end
            end
        end
        Fluent:Notify({
            Title = "Sombra Hub",
            Content = "Nenhuma arma encontrada",
            Duration = 3
        })
    end
})

-- ============================================
-- ABA: VISUAL (ESP)
-- ============================================
Tabs.Visual:AddParagraph({
    Title = "👁️ Visual",
    Content = "ESP e melhorias visuais"
})

Tabs.Visual:AddToggle("ESP_Toggle", {
    Title = "👁️ ESP Players",
    Description = "Ver players através das paredes",
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

Tabs.Visual:AddColorpicker("Cor_ESP", {
    Title = "🎨 Cor do ESP",
    Description = "Cor do contorno dos players",
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

Tabs.Visual:AddToggle("Fullbright_Toggle", {
    Title = "💡 Fullbright",
    Description = "Visão noturna total",
    Default = false,
    Callback = function(valor)
        Config.Fullbright = valor
        local lighting = game:GetService("Lighting")
        if valor then
            lighting.Brightness = 5
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            lighting.FogEnd = 100000
        else
            lighting.Brightness = 2
            lighting.Ambient = Color3.fromRGB(70, 70, 70)
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
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

Tabs.Mov:AddToggle("Speed_Toggle", {
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

Tabs.Mov:AddSlider("Speed_Slider", {
    Title = "Velocidade",
    Default = 50,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(valor)
        Config.Velocidade = valor
    end
})

Tabs.Mov:AddToggle("Jump_Toggle", {
    Title = "🦘 Jump Power",
    Default = false,
    Callback = function(valor)
        Config.JumpAtivo = valor
    end
})

Tabs.Mov:AddSlider("Jump_Slider", {
    Title = "Força do Pulo",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(valor)
        Config.JumpValor = valor
    end
})

Tabs.Mov:AddToggle("Fly_Toggle", {
    Title = "🕊️ Fly",
    Default = false,
    Callback = function(valor)
        Config.FlyAtivo = valor
        if valor then
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local bg = Instance.new("BodyGyro", hrp)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = hrp.CFrame
            
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            
            task.spawn(function()
                while Config.FlyAtivo and hrp.Parent do
                    local mov = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mov += Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mov -= Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mov -= Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mov += Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mov += Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mov -= Vector3.new(0, 1, 0) end
                    bv.Velocity = mov * 50
                    bg.CFrame = Camera.CFrame
                    RunService.RenderStepped:Wait()
                end
                bg:Destroy()
                bv:Destroy()
            end)
        end
    end
})

Tabs.Mov:AddToggle("NoClip_Toggle", {
    Title = "👻 NoClip",
    Default = false,
    Callback = function(valor)
        Config.NoClip = valor
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
-- FUNÇÃO: ACHAR NPC
-- ============================================
function acharNPC()
    local melhorAlvo = nil
    local menorDist = 500
    local meuHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not meuHRP then return nil end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            
            if humanoid and hrp and humanoid.Health > 0 then
                if string.find(string.lower(obj.Name), string.lower(Config.NPCSelecionado)) then
                    local dist = (meuHRP.Position - hrp.Position).Magnitude
                    if dist < menorDist then
                        menorDist = dist
                        melhorAlvo = obj
                    end
                end
            end
        end
    end
    
    return melhorAlvo
end

-- ============================================
-- LOOP PRINCIPAL
-- ============================================
RunService.Heartbeat:Connect(function()
    -- AUTO FARM
    if Config.AutoFarmAtivo then
        local npc = acharNPC()
        if npc then
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            local meuChar = LocalPlayer.Character
            local meuHRP = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
            
            if hrp and meuHRP then
                -- Teleporta pra perto do NPC
                meuHRP.CFrame = hrp.CFrame * CFrame.new(0, 3, Config.DistanciaFarm/3)
                
                -- Auto attack
                if Config.AutoAttackAtivo then
                    local tool = meuChar:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end
    
    -- SPEED
    if Config.SpeedAtivo then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = Config.Velocidade
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
                    bb.Size = UDim2.new(0, 200, 0, 40)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = hrp
                    
                    local nome = Instance.new("TextLabel")
                    nome.Size = UDim2.new(1, 0, 1, 0)
                    nome.BackgroundTransparency = 1
                    nome.Text = p.Name
                    nome.TextColor3 = Config.ESPCor
                    nome.TextStrokeTransparency = 0
                    nome.TextSize = 15
                    nome.Font = Enum.Font.GothamBold
                    nome.Parent = bb
                    
                    Config.objetosESP[p] = {Highlight = hl, Billboard = bb}
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
-- NOTIFICAÇÃO
-- ============================================
Fluent:Notify({
    Title = "Sombra Hub v5.0",
    Content = "Blox Fruits carregado! 🌑",
    Duration = 5
})

print("🌑 Sombra Hub v5.0 (Blox Fruits) carregado!")
