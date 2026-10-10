-- HUB SOMBRA v5.0 | by Equipe Sombra
-- Corrigido o link oficial de carregamento do Rayfield
local Rayfield = loadstring(game:HttpGet('https://githubusercontent.com'))()

local Window = Rayfield:CreateWindow({
   Name = "Sombra Hub | Blox Fruits",
   LoadingTitle = "Sombra Hub",
   LoadingSubtitle = "by Sombra",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variáveis Globais de Controle
_G.AutoFarm = false
_G.EquipWeapon = true

-- Serviços do Jogo
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Função de Teleporte Seguro (Evita Kick por Anticheat)
local function ToTween(targetCFrame)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local distance = (Player.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local speed = 250 -- Velocidade segura
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Função para Equipar a Arma Automaticamente (Estilo de Luta/Espada)
local function EquipWeapon()
    if _G.EquipWeapon and Player.Character and not Player.Character:FindFirstChildOfClass("Tool") then
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit" or tool.Name == "Combat") then
                    Player.Character.Humanoid:EquipTool(tool)
                    break
                end
            end
        end
    end
end

-- Função para Pegar Dados da Quest Dinamicamente (Base Sea 1)
local function GetQuestData()
    if not Player:FindFirstChild("Data") or not Player.Data:FindFirstChild("Level") then
        return "BanditQuest1", "Bandit", 1, CFrame.new(1059, 16, 1550)
    end
    
    local level = Player.Data.Level.Value
    if level >= 1 and level < 10 then
        return "BanditQuest1", "Bandit", 1, CFrame.new(1059, 16, 1550)
    elseif level >= 10 and level < 15 then
        return "JungleQuest", "Monkey", 1, CFrame.new(-1598, 37, 153)
    else
        return "BanditQuest1", "Bandit", 1, CFrame.new(1059, 16, 1550) -- Padrão Inicial
    end
end

-- Aba Principal
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Sombra Hub - Online 🟢")

MainTab:CreateButton({
   Name = "Copiar Discord",
   Callback = function()
       setclipboard("discord.gg/sombra")
   end,
})

-- Aba de Auto Farm
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Ativar Auto Farm (Nível)",
   CurrentValue = false,
   Flag = "AutoFarmFlag",
   Callback = function(Value)
       _G.AutoFarm = Value
       
       if Value then
           task.spawn(function()
               while _G.AutoFarm do
                   task.wait(0.1)
                   pcall(function()
                       -- Verifica de forma segura se a UI de Quest está ativa
                       local mainGui = Player.PlayerGui:FindFirstChild("Main")
                       local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
                       local questName, mobName, questId, npcPosition = GetQuestData()
                       
                       if not hasQuest then
                           -- Ir até o NPC pegar a Quest
                           ToTween(npcPosition)
                           if (Player.Character.HumanoidRootPart.Position - npcPosition.Position).Magnitude < 15 then
                               task.wait(0.2)
                               ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                           end
                       else
                           -- Procurar o Monstro no mapa
                           local mobFound = false
                           local enemies = workspace:FindFirstChild("Enemies")
                           
                           if enemies then
                               for _, v in ipairs(enemies:GetChildren()) do
                                   if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                                       mobFound = true
                                       EquipWeapon()
                                       
                                       -- Prender o player acima do mob para farmar em segurança
                                       Player.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                                       
                                       -- Executar ataques repetidos
                                       local virtualUser = game:GetService("VirtualUser")
                                       virtualUser:CaptureController()
                                       virtualUser:ClickButton1(Vector2.new(851, 158))
                                       break
                                   end
                                end
                           end
                           
                           -- Se não achar mobs vivos, vai até a posição padrão do NPC/área deles esperar o spawn
                           if not mobFound then
                               ToTween(npcPosition * CFrame.new(0, 20, 20))
                           end
                       end
                   end)
               end
           end)
       end
   end,
})

Rayfield:LoadConfiguration()
