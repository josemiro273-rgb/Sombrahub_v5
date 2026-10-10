local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Sombra Hub",
    SubTitle = "Brookhaven RP | V5",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Casa = Window:AddTab({ Title = "Casa", Icon = "home" }),
    RP = Window:AddTab({ Title = "RP", Icon = "users" }),
    Utils = Window:AddTab({ Title = "Utils", Icon = "zap" })
}

-- ABA CASA
Tabs.Casa:AddParagraph({ Title = "Brookhaven - Casa", Content = "Utilitários de casa para RP" })

Tabs.Casa:AddButton({
    Title = "Teleportar para Casa",
    Description = "Te leva pra tua casa",
    Callback = function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local house = workspace:FindFirstChild("Houses") and workspace.Houses:FindFirstChild(lp.Name.."'s House") or workspace:FindFirstChild("Houses")
        if house then
            local door = house:FindFirstChild("FrontDoor", true) or house:FindFirstChild("Door", true)
            if door and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = door.CFrame + Vector3.new(0,3,0)
            end
        end
        Fluent:Notify({ Title = "Sombra", Content = "Teleportado!", Duration = 2 })
    end
})

Tabs.Casa:AddButton({
    Title = "Permitir todos na casa",
    Description = "Destranca portas (RP)",
    Callback = function()
        local lp = game.Players.LocalPlayer
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "Locked" and v.Parent.Name:find(lp.Name) then
                v:Destroy()
            end
        end
        Fluent:Notify({ Title = "Sombra", Content = "Casa destrancada para RP!", Duration = 2 })
    end
})

-- ABA RP
Tabs.RP:AddButton({
    Title = "Copiar Avatar (View)",
    Description = "Copia roupa de quem você clicar",
    Callback = function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local mouse = lp:GetMouse()
        Fluent:Notify({ Title = "Sombra", Content = "Clique em alguém para copiar o avatar", Duration = 3 })
        mouse.Button1Down:Once(function()
            local target = mouse.Target
            if target and target.Parent:FindFirstChild("Humanoid") then
                local plr = Players:GetPlayerFromCharacter(target.Parent)
                if plr then
                    lp:RequestStreamAroundAsync(target.Parent:GetPivot().Position)
                    -- Apenas visual no seu cliente
                    for _,v in pairs(plr.Character:GetDescendants()) do
                        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                            v:Clone().Parent = lp.Character
                        end
                    end
                end
            end
        end)
    end
})

Tabs.RP:AddButton({
    Title = "Resetar Personagem",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- ABA UTILS
Tabs.Utils:AddButton({
    Title = "Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        Fluent:Notify({ Title = "Sombra", Content = "Anti-AFK ON", Duration = 3 })
    end
})

Tabs.Utils:AddButton({ Title = "FPS Boost", Callback = function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
    end
end})

Tabs.Utils:AddButton({ Title = "Server Hop", Callback = function()
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
end})

Window:SelectTab(1)
Fluent:Notify({ Title = "Sombra Hub", Content = "Brookhaven carregado! 🟣", Duration = 4 })
