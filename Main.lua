local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- TEMA SOMBRA ROXO
Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Brookhaven RP | V5.1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Pega a janela e pinta de roxo
local Window = Fluent.Window
Window.AcrylicMainFrame.BackgroundTransparency = 0.2

local Tabs = {
    Casa = Window:AddTab({ Title = "Casa", Icon = "home" }),
    Carros = Window:AddTab({ Title = "Carros", Icon = "car" }),
    RP = Window:AddTab({ Title = "RP", Icon = "users" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "zap" })
}

-- ICONE SOMBRA
Tabs.Casa:AddParagraph({ Title = "🟣 Sombra Hub Brookhaven", Content = "Interface Sombra V5.1 - Tema Roxo Ativado" })

-- ABA CASA (igual antes)
Tabs.Casa:AddButton({
    Title = "Teleportar para Casa",
    Callback = function()
        local lp = game.Players.LocalPlayer
        local plot = workspace:FindFirstChild("Houses")
        if plot and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            for _, house in pairs(plot:GetChildren()) do
                if house.Name:find(lp.Name) then
                    local door = house:FindFirstChild("FrontDoor", true) or house:FindFirstChild("Door", true)
                    if door then lp.Character.HumanoidRootPart.CFrame = door.CFrame + Vector3.new(0,3,0) end
                end
            end
        end
    end
})

-- ABA CARROS NOVA
Tabs.Carros:AddParagraph({ Title = "Veículos", Content = "Atalhos rápidos de carro" })
Tabs.Carros:AddButton({ Title = "Spawnar Carro Rápido", Description = "Abre a garagem", Callback = function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "G", false, game)
    task.wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "G", false, game)
end})

-- ABA RP
Tabs.RP:AddButton({ Title = "Resetar", Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end })
Tabs.RP:AddButton({ Title = "Copiar Avatar (View)", Callback = function()
    Fluent:Notify({ Title = "Sombra", Content = "Clique em alguém", Duration = 3 })
    local mouse = game.Players.LocalPlayer:GetMouse()
    mouse.Button1Down:Once(function()
        local t = mouse.Target and mouse.Target.Parent
        if t and t:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:ApplyDescription(game.Players:GetHumanoidDescriptionFromUserId(game.Players:GetPlayerFromCharacter(t).UserId))
        end
    end)
end})

-- ABA UTILS
Tabs.Utils:AddButton({ Title = "Anti-AFK", Callback = function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
    Fluent:Notify({ Title = "Sombra", Content = "Anti-AFK ON", Duration = 2 })
end})
Tabs.Utils:AddButton({ Title = "FPS Boost", Callback = function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") then v.Transparency = 1 end end end})
Tabs.Utils:AddButton({ Title = "Server Hop", Callback = function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do if s.playing < s.maxPlayers and s.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, s.id) break end end
end})

Window:SelectTab(1)
Fluent:Notify({ Title = "Sombra Hub", Content = "V5.1 Roxa carregada!", Duration = 4 })
