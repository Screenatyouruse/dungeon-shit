--if u get angry from these give me a way to fix dungeon loading too fast
repeat task.wait() until game.Players
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character.Humanoid

local LocalPlayer = game.Players.LocalPlayer
local alreadySent = false
local Gregg = nil
local MoveToPath  = {
    Vector3.new(105, 129, 448),
    Vector3.new(181, 111, 428),
    Vector3.new(247, 111, 392),
    Vector3.new(296, 101, 348),
    Vector3.new(292, 101, 294),
    Vector3.new(265, 101, 198),
    Vector3.new(261, 101, 94),
    Vector3.new(292, 101, -101),
    Vector3.new(299, 102, -161),
    Vector3.new(336, 104, -314),
    Vector3.new(465, 92, -329),
    Vector3.new(537, 96, -323),
    Vector3.new(600, 96, -357),
    Vector3.new(647, 92, -325),
    Vector3.new(669, 88, -298),
    Vector3.new(678, 89, -189),
    Vector3.new(699, 89, -78),
}

local function SendWebhook(msg)
    local data, url
    task.spawn(function()
        url = getgenv().webHook
        if not url then return end
        data = {
            ["embeds"] = {
                {
                    ["footer"] = {
                        ["text"] = "death to all greggs",
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/1015581960711720971/1136896939540090930/image.png"},

                    ["title"] = "Dungeon Quest - Gregg Autofarmer",
                    ["description"] = msg,
                    ["type"] = "rich",
                    ["color"] = tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))),
                }
            }
        }
        repeat task.wait() until data
        local newdata = game:GetService("HttpService"):JSONEncode(data)
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local request = http_request or request or HttpPost or syn.request or http.request
        local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
        request(abcdef)
    end)
end

local function castAll()
    task.spawn(function()
        for _,spell in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if spell.cooldown.Value then
                for _,randombullshit in pairs(spell:GetChildren()) do
                    if randombullshit.Name == "abilityEvent" or randombullshit.Name == "spellEvent" then
                        if getgenv().UseVIM then
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, string.upper(spell.abilitySlot.Value), false, game)
                        else
                            randombullshit:FireServer()
                        end
                    end
                end
                task.wait(getgenv().cooldownEachSpell)
            end
        end

        task.wait(getgenv().cooldownEachSpell2) --so if u dont include this, it crashes LOL

        castAll()
    end)
end

local function WalkSpeedChange() --pasted from inf yield i love u bro!!!
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
        LocalPlayer.Character.Humanoid.WalkSpeed = 32
    end
end

task.spawn(function()
    while true do task.wait(1)
        local ohTable1 = {
            [1] = {
                [utf8.char(3)] = "vote",
                ["vote"] = true
            },
            [2] = utf8.char(28)
        }

        game:GetService("ReplicatedStorage").dataRemoteEvent:FireServer(ohTable1)
        game:GetService("ReplicatedStorage").remotes.changeStartValue:FireServer()
    end
end)


task.spawn(function()
    while true do task.wait()
        WalkSpeedChange()
    end
end)

workspace.dungeon.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Gregg" then
        if not alreadySent then
            SendWebhook("WAKE UP BABE, GREG JUST DROPPED")
            Gregg = descendant
            alreadySent = true
        end
    end
end)


workspace.dungeon.DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "Gregg" then
        task.wait(1)
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Coin" then
        LocalPlayer.Character.Humanoid:MoveTo(child.Coin.Position)
        LocalPlayer.Character.Humanoid.MoveToFinished:Wait()    
        LocalPlayer.Character.Humanoid:MoveTo(Gregg.LowerTorso.Position)
        LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
        LocalPlayer.Character.HumanoidRootPart.CFrame = Gregg.LowerTorso.CFrame
        getgenv().cooldownEachSpell = 0
        getgenv().cooldownEachSpell2 = 0 
    end
end)

castAll()

for i,Path in pairs(MoveToPath) do
    if Gregg then
        return
    end
    
    print(i, " ", Path)
    local balls = true
    LocalPlayer.Character.Humanoid.MoveToFinished:Once(function()
        balls = false
    end)

    while balls and not Gregg do
        LocalPlayer.Character.Humanoid:MoveTo(Path)
        task.wait()
    end
end
