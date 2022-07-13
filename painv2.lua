local first = true
local first2 = true
local folderDubs = Instance.new("Folder", game.Workspace)
folderDubs.Name = "folderDubs"
input = game:GetService("UserInputService")
tweenService = game:GetService("TweenService")

function calculateTime(s, d)
    local time = d/s
    return time
end




input.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.E then 
        print("Precheck")
        if first2 then
            writefile("path.txt", "")
            first2 = false
        end
        local sphere = Instance.new('Part')
        sphere.Size = Vector3.new(1, 1, 1) -- Size, 1 is 1 stud by 1 stud.
        sphere.Shape = Enum.PartType.Ball -- Make it a sphere
        sphere.Anchored = true
        sphere.CanCollide = false
        sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -- Position it
        sphere.Parent = game.Workspace.folderDubs -- Parent it
        sphere.Material = Enum.Material.Neon
        appendfile("path.txt", sphere.Position.x.." "..sphere.Position.y.." "..sphere.Position.z.." ")
    end
    if key.KeyCode == Enum.KeyCode.J then
        print("Another precheck")
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
    end
    if key.KeyCode == Enum.KeyCode.Y then
        folderDubs:Destroy()
        folderDubs = Instance.new("Folder", game.Workspace)
        folderDubs.Name = "folderDubs"
        delfile("path.txt")
    end
    if key.KeyCode == Enum.KeyCode.H then
        local count = 0
        print("Check 1")
        local newCoords = {}
        local CFrames = {} 
        local stopPoints = {}
        if not isfile("path.txt") then return end
        stuff = readfile("path.txt")
        print(stuff)
        for word in stuff:gmatch("(.-)".." ") do  
            local count = count + 1
            if tostring(word):find("%(") then
                print(word:sub(2))
                table.insert(stopPoints, count)
                table.insert(newCoords, string.sub(word, 2))
            end
            table.insert(newCoords, word)
            
            print("Check 3")
        end
        for i,v in pairs(newCoords) do
            print("CHECKING COORD TABLE: ", i, v)
        end
        for i,v in pairs(newCoords) do
            if (i+2)%3 == 0 then
                table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
                print("Check 4")
            end
            print("Check 5")
        end
        for i,v in pairs(CFrames) do
            for i,v in pairs(stopPoints) do
                print("STOP POINTS", i,v)
            end
            print("NEW CFRAMES "..i,v)
            if first then
                local time = calculateTime(speed, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
                tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                wait(time)
            else
                local temp = CFrames[i+1]
                local temp1 = Vector3.new(v.x, v.y, v.z)
                local temp2 = Vector3.new(temp.x, temp.y, temp.z)
                local distance = (temp1 - temp2).magnitude
                local newSpeed = speed/32
                local time = calculateTime(speed, distance)
                tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                wait(time)
            end
        end
    end
end)
