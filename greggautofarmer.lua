local LocalPlayer = game.Players.LocalPlayer
local HumanModCons = {}
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
            if spell.cooldown.Value <= 0.1 then
                spell.abilityEvent:FireServer()
                task.wait(getgenv().cooldownEachSpell)
            end
        end

        task.wait(getgenv().cooldownEachSpell2)

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
    --[[
    HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
    HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or LocalPlayer.CharacterAdded:Connect(function(nChar)
        LocalPlayer.Character, LocalPlayer.Character.Humanoid = nChar, nChar:WaitForChild("Humanoid")
        WalkSpeedChange()
        HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
    end)
    ]]
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
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Coin" then
        LocalPlayer.Character.Humanoid:MoveTo(child.Coin.Position)
        LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
        LocalPlayer.Character.Humanoid:MoveTo(Gregg.UpperTorso.Position)
        for i=1,100 do
            for _,spell in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                spell.abilityEvent:FireServer()
            end
            task.wait(0.1)
        end
    end
end)

for i,Path in pairs(MoveToPath) do
    if Gregg then
        return
    end
    
    print(i, " ", Path)
    local balls = true
    LocalPlayer.Character.Humanoid.MoveToFinished:Once(function()
        balls = false
    end)

    while balls do
        castAll()
        LocalPlayer.Character.Humanoid:MoveTo(Path)
        LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
    end
end
