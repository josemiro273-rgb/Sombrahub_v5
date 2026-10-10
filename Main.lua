local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Sombra Hub | Blox Fruits",
   LoadingTitle = "Sombra Hub",
   LoadingSubtitle = "by Sombra",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateLabel("Sombra Hub - Online 🟢")

MainTab:CreateButton({
   Name = "Copiar Discord",
   Callback = function()
       setclipboard("discord.gg/sombra")
   end,
})

Rayfield:LoadConfiguration()
