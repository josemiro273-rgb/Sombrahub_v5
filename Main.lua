-- HUB SOMBRA v4.0 | by Equipe Sombra
-- Link corrigido para a versão oficial e funcional do Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Inicialização da Janela Principal
local Window = Rayfield:CreateWindow({
   Name = "Sombra Hub | Blox Fruits",
   LoadingTitle = "Sombra Hub",
   LoadingSubtitle = "by Sombra Team",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "Sombra Hub Key",
      Subtitle = "Key System",
      Note = "Key: SOMBRA_V4_FREE",
      FileName = "SombraKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SOMBRA_V4_FREE"}
   }
})

-- =========================================================
-- CONFIGURAÇÕES E VARIÁVEIS DO AUTO FARM
-- =========================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.AutoFarm = false
_G.ArmaParaUsar = "Melee" 

-- Função de movimentação suave (Tween) modificada para desativar gravidade temporariamente (Evita prender no chão)
local function ToPos(TargetCFrame, Speed)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local HRP = LocalPlayer.Character.HumanoidRootPart
    local Distance = (HRP.Position - TargetCFrame.Position).Magnitude
    local Duration = Distance / Speed
    
    -- Evita colisões e quedas enquanto voa
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = true
    end
    
    local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(HRP, TweenInfo, {CFrame = TargetCFrame})
    Tween:Play()
    
    task.spawn(function()
        while Tween.PlaybackState == Enum.PlaybackState.Playing do
            if not _G.AutoFarm or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
                Tween:Cancel()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
                break
            end
            task.wait(0.1)
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end)
    
    return Tween
end

-- Função para equipar o estilo de luta / arma automaticamente
local function EquiparArma()
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Character = LocalPlayer.Character
    
    if Character and not Character:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == _G.ArmaParaUsar or tool.Name == _G.ArmaParaUsar or _G.ArmaParaUsar == "Melee" and tool.ToolTip == "Melee") then
                Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- Tabela de Quests automática por Level (Ajustada para o padrão do mapa inicial)
local function PegarInformacoesQuest()
    if not LocalPlayer:FindFirstChild("Data") or not LocalPlayer.Data:FindFirstChild("Level") then 
        return { MyLevel = 1 } 
    end
    
    local MyLevel = LocalPlayer.Data.Level.Value
    
    -- Inicial (Bandits)
    if MyLevel >= 1 and MyLevel < 10 then
        return {
            NPC_Pos = CFrame.new(1059.3, 16.4, 1549.2), 
            QuestName = "BanditQuest1",
            QuestNumber = 1,
            MobName = "Bandit",
            Mob_Pos = CFrame.new(1145, 17, 1630)   
        }
    -- Selva (Monkeys)
    elseif MyLevel >= 10 and MyLevel < 15 then
        return {
            NPC_Pos = CFrame.new(-1598, 37, 153),
            QuestName = "JungleQuest",
            QuestNumber = 1,
            MobName = "Monkey",
            Mob_Pos = CFrame.new(-1610, 40, 200)
        }
    else
        -- Fallback caso o nível seja maior que 15
        return {
            NPC_Pos = CFrame.new(-1598, 37, 153),
            QuestName = "JungleQuest",
            QuestNumber = 1,
            MobName = "Monkey",
            Mob_Pos = CFrame.new(-1610, 40, 200)
        }
    end
end

-- SISTEMA ANTI-AFK (Evita que o Roblox desconecte por inatividade)
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

-- =========================================================
-- ABAS DA INTERFACE (RAYFIELD)
-- =========================================================

-- Aba Principal (Main)
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Status: ONLINE | v4.0")

MainTab:CreateButton({
   Name = "Copy Discord",
   Callback = function() setclipboard("discord.gg/sombrahub") end,
})

-- Nova Aba de Automações (Auto Farm)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Ativar Auto Farm Level",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
      
      if Value then
          task.spawn(function()
              while _G.AutoFarm do
                  task.wait(0.1)
                  
                  if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                      local Data = PegarInformacoesQuest()
                      if not Data then continue end
                      
                      -- Verifica se o jogador já está com uma Quest ativa na tela
                      local HasQuest = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and LocalPlayer.PlayerGui.Main.Quest.Visible
                      
                      if not HasQuest then
                          -- Se não tem quest, voa suavemente até o NPC
                          ToPos(Data.NPC_Pos, 300)
                          if (LocalPlayer.Character.HumanoidRootPart.Position - Data.NPC_Pos.Position).Magnitude < 15 then
                              task.wait(0.3)
                              -- Dispara o evento oficial do jogo para aceitar a missão
                              game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Data.QuestName, Data.QuestNumber)
                          end
                      else
                          -- Se já tem a quest, procura pelo monstro no mapa
                          local Alvo = nil
                          for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == Data.MobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                  Alvo = v
                                  break
                              end
                          end
                          
                          if Alvo and Alvo:FindFirstChild("HumanoidRootPart") then
                              -- Posiciona o seu boneco 5 blocos acima do monstro (para evitar levar dano)
                              ToPos(Alvo.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                              
                              -- Equipa o estilo de luta e ataca usando o sistema nativo da arma ativa
                              EquiparArma()
                              local ArmaAtiva = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                              if ArmaAtiva then
                                  ArmaAtiva:Activate()
                              end
                          else
                              -- Se os monstros ainda não renasceram, vai até o local de spawn deles
                              ToPos(Data.Mob_Pos, 300)
                          end
                      end
                  end
              end
          end)
      end
   end,
})
