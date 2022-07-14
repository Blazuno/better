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
        appendfile("path.txt", sphere.Position.x.." "..sphere.Position.y.." "..sphere.Position.z.." ")
        local stuff = readfile("path.txt")
        folderCopy = folderDubs:Clone()
        table.insert(fileSavePoints, count2, stuff)
        table.insert(savePoints, count2, folderCopy)
        print("DEBUG SAVE POINT FILE CHECK: ",stuff)
        print("DEBUG SAVE POINT REVERSION: ",count2)
    end
    if key.KeyCode == Enum.KeyCode.J then
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
        appendfile("path.txt", "("..sphere.Position.x.." ".."("..sphere.Position.y.." ".."("..sphere.Position.z.." ")
        count2 = count2 + 1
        folderCopy = folderDubs:Clone()
        print("DEBUG TYPE CHECK: ",type(count2))
        table.insert(savePoints, count2, folderCopy)
        local stuff = readfile("path.txt")
        table.insert(fileSavePoints, count2, stuff)
        print("DEBUG SAVE POINT REVERSION: ",count2)
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
        stuff = readfile("path.txt")
        print(stuff)
        spawn(function()loadstring(game:HttpGet("https://pastebin.com/raw/ERDp2x5W", true))()
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
                print("DEBUG: ",v, newCoords[i+1], newCoords[i+2])
                table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
            end
        end
        for i,v in pairs(stopPoints2) do
            print("STOP POINTS ",v/3)
        end
        for i,v in pairs(stopPoints) do
            if v % 3 == 0 then
                table.insert(stopPoints2, v)
            end
            print("CFRAME LOOP DEBUG: ",v)
        end
        while true do
            for i,v in pairs(CFrames) do
                if first then
                    local time = calculateTime(speed, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
                    tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                    wait(time)
                    for i2,vd in pairs(stopPoints2) do
                        if i == vd/3 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            wait(trinketSpawnWaitTimes)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
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

