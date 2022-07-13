--E TO MAKE A POINT
--Y TO DELETE PATH
--H TO START THE BOT
--NOTE THAT IF YOU HAVE A PATH SAVED AND WANT TO START A NEW ONE THAT YOU PRESS Y BEFORE STARTING OTHERWISE IT WILL HEAVILY BUG AND MAYBE CRASH/BAN YOU

--touch nothing beyond this point
local first = true
local coordTable = {}
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
        writefile("path.txt", "")
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
    if key.KeyCode == Enum.KeyCode.H then
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
    if key.KeyCode == Enum.KeyCode.Y then
        folderDubs:Destroy()
        folderDubs = Instance.new("Folder", game.Workspace)
        folderDubs.Name = "folderDubs"
        delfile("path.txt")
    end
    if key.KeyCode == Enum.KeyCode.H then
        local newCoords = {}
        local CFrames = {} 
        local stopPoints = {}
        if isfile("path.txt") then
            stuff = readfile("path.txt")
            for word in stuff:gmatch("(.-)".." ") do  table.insert(newCoords, word) end
            for i,v in pairs(newCoords) do
                if (i+2)%3 == 0 then
                    if stuff:find("(") then
                        table.insert(stopPoints, i)
                    table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
                end
            end
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
