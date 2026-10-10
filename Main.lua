local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Brookhaven RP | V5.1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Casa = Window:AddTab({ Title = "Casa", Icon = "home" }),
    Carros = Window:AddTab({ Title = "Carros", Icon = "car" }),
    RP = Window:AddTab({ Title = "RP", Icon = "users" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "zap" })
}

Tabs.Casa:AddParagraph({ Title = "Sombra Hub 🟣", Content = "V5.1 Brookhaven - Sem bug" })

Tabs.Casa:AddButton({
    Title = "Teleportar para Casa",
    Callback = function()
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            for _, house in pairs(workspace:FindFirstChild("Houses"):GetChildren()) do
                if string.find(house.Name, lp.Name) then
                    local door = house:FindFirstChild("FrontDoor", true)
                    if door then
                        lp.Character.HumanoidRootPart.CFrame = CFrame.new(door.Position + Vector3.new(0,3,0))
                    end
                end
            end
        end
        Fluent:Notify({ Title = "Sombra", Content = "Teleportado!", Duration = 2 })
    end
})

Tabs.Carros:AddParagraph({ Title = "Veículos", Content = "Atalhos para Brookhaven" })
Tabs.Carros:AddButton({
    Title = "Abrir Garagem (G)",
    Callback = function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, "G", false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, "G", false, game)
    end
})

Tabs.RP:AddButton({
    Title = "Resetar Personagem",
    Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end
})

Tabs.Utils:AddButton({
    Title = "Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        Fluent:Notify({ Title = "Sombra", Content = "Anti-AFK ON", Duration = 2 })
    end
})

Tabs.Utils:AddButton({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end
})

Tabs.Utils:AddButton({
    Title = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local servers = Http:JSONDecode(game:HttpGet(Api)).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
})

Window:SelectTab(1)
Fluent:Notify({ Title = "Sombra Hub", Content = "V5.1 Carregada sem bug!", Duration = 3 })
