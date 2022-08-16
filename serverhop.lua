
repeat
    wait()
until game:IsLoaded()

function calculateTime(s, d)
    local time = d/s
    return time
end

local vim = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
function antiFrost()
    spawn(function()
        local chr = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        for i,v in pairs(chr:GetChildren()) do
            if v.Name == "Frostbitten" then
                v:Destroy()
            end
        end
        chr.ChildAdded:Connect(function(child)
            if child.Name == "Frostbitten" then
                child:Destroy()
            end
        end)
    end)
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

local common_trinket_ids = {
    ["5196776695"] = "Ring",
    ["5196551436"] = "Amulet",
    ["5204003946"] = "Goblet",
    ["5196782997"] = "Old Ring",
    ["5196577540"] = "Old Amulet",
    ["2765613127"] = "Idol of the Forgotten"
}

local rare_trinket_ids = {
    ["5204453430"] = "Scroll",
    ["4103271893"] = "Candy"
}

local function identify_trinket(trinket)
    local trinket_class = trinket.ClassName
    local is_mesh_part, is_union_operation, is_part = trinket.ClassName == "MeshPart", trinket.ClassName == "UnionOperation", trinket.ClassName == "Part"
    
    if (is_mesh_part or is_union_operation) then
        print("identity stuff")
        local asset_id = is_mesh_part and trinket.MeshId:gsub("%%20", ""):match("%d+") or is_union_operation and gethiddenproperty(trinket, "AssetId"):gsub("%%20", ""):match("%d+")
        local identified_trinket = common_trinket_ids[asset_id]

        if identified_trinket then
            return trinket, "common"
        end
    end

    if is_part then
        local particle_emitter = trinket:FindFirstChild("ParticleEmitter")

        if particle_emitter and tostring(particle_emitter.Color):find("0 1 1 1 0 1 1 1 1 0") then
            local mesh = trinket:FindFirstChild("Mesh")

            if mesh and mesh.MeshId:gsub("%%20", ""):match("%d+") == "2877143560" then 
                local part_color = trinket.Color

                if tostring(part_color) == "0.643137, 0.733333, 0.745098" then 
                    return trinket, "common"
                elseif part_color.G > part_color.R and part_color.G > part_color.B then 
                    return trinket, "common"
                elseif part_color.R > part_color.G and part_color.R > part_color.B then 
                    return trinket, "common"
                elseif part_color.B > part_color.G and part_color.B > part_color.R then 
                    return trinket, "common"
                end
            end
        end
    elseif is_mesh_part then 
        local identified_trinket = rare_trinket_ids[trinket.MeshId:gsub("%%20", ""):match("%d+")]

        if identified_trinket then
            return identified_trinket, "rare"
        end
    end

    if is_part then 
        local particle_emitter = trinket:FindFirstChild("ParticleEmitter")

        if particle_emitter and not tostring(particle_emitter.Color):find("0 1 1 1 0 1 1 1 1 0") then 
            return trinket, "artifact"
        else 
            local orb_particle = trinket:FindFirstChild("OrbParticle")

            if orb_particle then 
                local orb_particle_color = tostring(orb_particle.Color)

                if orb_particle_color:find("0 0.105882 0.596078 0.596078 0 1 0.105882 0.596078 0.596078 0 ") then 
                    return trinket, "ice"
                elseif orb_particle_color:find("0 0.596078 0 0.207843 0 1 0.596078 0 0.207843 0 ") then 
                    return trinket, "common"
                end
            end
        end
    elseif is_mesh_part and trinket.MeshId:gsub("%%20", ""):match("%d+") == "2520762076" then 
        return trinket, "artifact"
    elseif is_union_operation then 
        if trinket.BrickColor.Name == "Black" then 
            return trinket, "artifact"
        else
            local asset_id = gethiddenproperty(trinket, "AssetId"):gsub("%%20", ""):match("%d+")

            if asset_id == "3158350180" then 
                return trinket, "artifact"
            elseif asset_id == "2998499856" then 
                return trinket, "artifact"
            end
        end
    end

    local attachment = trinket:FindFirstChild("Attachment")

    if attachment then
        local particle_emitter = attachment:FindFirstChildOfClass("ParticleEmitter")

        if particle_emitter then 
            local particle_emitter_color = tostring(particle_emitter.Color)
            local size = tostring(trinket.Size)

            if size:find("0.69999998807907, 0.69999998807907, 0.69999998807907") and particle_emitter_color:find("0 0.45098 1 0 0 1 0.482353 1 0 0 ") then 
                return trinket, "artifact"
            elseif size:find("0.69999998807907, 0.69999998807907, 0.69999998807907") and particle_emitter_color:find("0 1 0.8 0 0 1 1 0.501961 0 0 ") then 
                return trinket, "pd"
            end
        end
    end
    return trinket, "common"
end


block_random_player = function()
    local block_player 
    local players_list = game.Players:GetPlayers()

    for index = 1, #players_list do
        local target_player = players_list[index]

        if target_player.Name ~= game.Players.LocalPlayer.Name then
            block_player = target_player
            break
        end
    end

    game:GetService("StarterGui"):SetCore("PromptBlockPlayer", block_player)

    local container_frame = game:GetService("CoreGui").RobloxGui:WaitForChild("PromptDialog"):WaitForChild("ContainerFrame")

    local confirm_button = container_frame:WaitForChild("ConfirmButton")
    
    local confirm_button_text = confirm_button:WaitForChild("ConfirmButtonText")
    
    if confirm_button_text.Text == "Block" then  
        wait()
        for i = 1, 30 do
            local confirm_position = confirm_button.AbsolutePosition
            vim:SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, true, game, 0)
            wait(0.05)
            vim:SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, false, game, 0)
        end
    end
end

function ServerHop(t)
    block_random_player()
    wait(3)
    game.Players.LocalPlayer:Kick(t)
    wait(3)
    game:GetService("TeleportService"):Teleport(3016661674)
end   

function detectIllu(serverhopTable)
    if serverhopTable.illuLog then
        local players = game.Players:GetChildren()
        for i,v in pairs(players) do
            local plrChr = v.Character
            if (plrChr and plrChr:FindFirstChild("Observe")) or v.Backpack:FindFirstChild("Observe") then
                ServerHop("illu is gay")
            end
            wait()
        end
    end
end

function detectMod()
    local players = game.Players:GetChildren()
    for i,v in pairs(players) do
        if v:IsInGroup(4556484) then
            ServerHop("Stinky mod")
        end
        local backpack = v:FindFirstChild("Backpack"):GetChildren()
        for i2,v2 in pairs(backpack) do
            if v2.Name == "Vagrant Soul" then
                ServerHop("Stinky mod")
            end
        end
        wait()
    end
end

function checkNearby(r, serverhopTable)
    if serverhopTable.logNearby then
        local localPlayer = game.Players.LocalPlayer
        local players = game.Players:GetChildren()
        for i,v in pairs(players) do
            if v:DistanceFromCharacter(localPlayer.Character.HumanoidRootPart.Position) < r then
                ServerHop("plr nearby")
            end
            wait()
        end
    end
end

function serverHopAutoPickup()
    spawn(function()
        while game.PlaceId == 5208655184 do
            local rarity 
            local name 
            for i,v in pairs(game.Workspace:GetChildren()) do
                local _, trinket = detectTrinkets(v)
                if _ then
                    local part 
                    local click 
                    trinket, rarity = identify_trinket(trinket)
                    print("beyond the threshhold")
                    if trinket:FindFirstChild("Part") then
                        part = trinket:FindFirstChild("Part")
                    end
                    if part then
                        click = part:FindFirstChild("ClickDetector")
                    end
                    print("part 2, electric boogaloo",serverhopTable.commons, rarity, click.MaxActivationDistance, game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position))
                    if serverhopTable.commons and rarity == "common"  and game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position) <= click.MaxActivationDistance then
                        print("tryna pick up")
                        repeat
                            fireclickdetector(click)
                            wait(0.1)
                        until not trinket or not trinket:IsDescendantOf(game.Workspace)
                    end
                    if serverhopTable.scrolls and rarity == "rare" and game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position) <= click.MaxActivationDistance then
                        spawn(function()
                            repeat                    
                                fireclickdetector(click)
                                wait(0.1)
                            until not trinket or not trinket:IsDescendantOf(game.Workspace)
                        end)
                    end
                    if rarity == "pd" and serverhopTable.pds and game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position) <= click.MaxActivationDistance then
                        spawn(function()
                            repeat                
                                fireclickdetector(click)
                                wait(0.1)
                            until not trinket or not trinket:IsDescendantOf(game.Workspace)
                            if serverhopTable.pdLog then
                                game.Players.LocalPlayer:Kick("Phoenix Down Found")
                            end
                        end)
                    end
                    if rarity == "pd" and serverhopTable.pds and game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position) <= click.MaxActivationDistance then
                        spawn(function()
                            repeat                    
                                fireclickdetector(click)
                                wait(0.1)
                            until not trinket or not trinket:IsDescendantOf(game.Workspace)
                            if serverhopTable.iceLog  then
                                game.Players.LocalPlayer:Kick("Phoenix Down Found")
                            end
                        end)
                    end
                    if rarity == "artifact" and game.Players.LocalPlayer:DistanceFromCharacter(trinket.Position) <= click.MaxActivationDistance then
                        spawn(function()
                            repeat  
                                name = trinket.Name                  
                                fireclickdetector(click)
                                wait(0.1)
                            until not trinket or not trinket:IsDescendantOf(game.Workspace)
                            game.Players.LocalPlayer:Kick("Artifact Found: "..name)
                        end)
                    end
                end
            wait()
            end
        end
    end)
end



syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Blazuno/better/main/serverhop.lua'))()")
repeat
    wait()
until game:IsLoaded()
repeat 
    wait()
until game.PlaceId == 5208655184
local serverhopTable = game:GetService("HttpService"):JSONDecode(readfile("BlazeHub/temp.txt"))
print(serverhopTable)
if serverhopTable.serverhop then
    local encrypted = readfile("BlazeHub/Paths/"..serverhopTable.path..".txt")
    local placeholder = syn.crypt.decrypt(encrypted, "joy")
    local count = 0
    serverHopAutoPickup()
    detectIllu(serverhopTable)
    checkNearby(serverhopTable.logRadius, serverhopTable)
    antiFrost()
    game:GetService("Workspace").MonsterSpawns.Triggers:Destroy()
    local newCoords = {}
    local CFrames = {} 
    local stopPoints = {}
    local stopPoints2 = {}
    local lootPoints = {}
    local lootPoints2 = {}
    local first = true
    local trinket 
    local rarity
    if string.len(placeholder) == 0 then return end
    local stuff = placeholder
    for word in stuff:gmatch("(.-)".." ") do  
    count = count + 1
    print("COUNT CHECK: ",count)
    if word:sub(1, 1) == "(" then
        print("STOP POINT FOUND: ",count)
        table.insert(stopPoints, count)
        table.insert(newCoords, string.sub(word, 2))
    elseif word:sub(1,1) == ")" then
        print("LOOT POINT FOUND: ",count)
        table.insert(lootPoints, count)
        table.insert(newCoords, string.sub(word, 2))
    else
        table.insert(newCoords, word)
    end
    end
    for i,v in pairs(newCoords) do
    if (i+2)%3 == 0 then
        table.insert(CFrames, CFrame.new(v, newCoords[i+1], newCoords[i+2]))
    end
    end
    for i,v in pairs(stopPoints) do
    if (v + 2) % 3 == 0 then
        table.insert(stopPoints2, v)
    end
    end
    for i,v in pairs(lootPoints) do
    if (v + 2) % 3 == 0 then
        table.insert(lootPoints2, v)
    end
    end
    if not game.Players.LocalPlayer.Character then
        repeat
            local confirm_button = game.Players.LocalPlayer.PlayerGui.StartMenu.Choices.Play
            for i = 1, 30 do
                local confirm_position = confirm_button.AbsolutePosition
                vim:SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, true, game, 0)
                wait(0.05)
                vim:SendMouseButtonEvent(confirm_position.X + 10, confirm_position.Y + 45, 0, false, game, 0)
            end
        until game.Players.LocalPlayer.Character
    end
    spawn(function()
        local Players = game:GetService("Players")
        local ScriptContext = game:GetService("ScriptContext")
        
        for i,v in next, getconnections(ScriptContext.Error) do
            v:Disable()
        end
        
        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character.HumanoidRootPart
        
        local hook = hookfunction or detour_function
        
        local old
        old = hook(Instance.new("RemoteEvent").FireServer, function(self,...)
            local args = {...}
            
            if Player.Character ~= nil and Player.Character:FindFirstChild("CharacterHandler") and Player.Character.CharacterHandler:FindFirstChild("Remotes") and self.Parent == Player.Character.CharacterHandler.Remotes then
                if #args == 2 and typeof(args[2]) == "table" then
                    return nil
                end
            end
        
            return old(self,...)
        end)
    end)
    spawn(function()
        while true do
            if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then game.Players.LocalPlayer:Kick("Somehow died") end
            wait()
        end
    end)
    game.Workspace.Gravity = 0
    for i,v in pairs(CFrames) do
        if first then
            local time = calculateTime(serverhopTable.speed, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
            game.Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "0"
            wait(time)
            for i2,vd in pairs(stopPoints2) do
                if i == (vd+2)/3 then
                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                    wait(trinket_wait:Get())
                    game.Players.LocalPlayer.Character.Torso.Anchored = false
                end
            end 
            for i2, vd in pairs(lootPoints2) do
                if i == (vd+2)/3 then
                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                    local party = game.Workspace:WaitForChild("Part", 5)
                    local id = party:WaitForChild("ID", 5)
                    for i3,v3 in pairs(game.Workspace:GetChildren()) do
                        local _, t = detectTrinkets(v3)
                        if _ then
                            trinket, rarity = identify_trinket(t)
                        end

                        if (_ and game.Players.LocalPlayer:DistanceFromCharacter(v3.Position) <= 300) and (rarity == "common" and serverhopTable.commons) or (rarity == "rare" and serverhopTable.scrolls) or (rarity == "pd" and serverhopTable.pds) or (rarity == "ice" and serverhopTable.ices) or rarity == "artifact" then
                            local time = calculateTime(serverhopTable.speed, game.Players.LocalPlayer:DistanceFromCharacter(v3.Position)) 
                            game.Players.LocalPlayer.Character.Torso.Anchored = false
                            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v3.CFrame}):Play()
                            wait(time)
                            game.Workspace.Gravity = 196.2
                            fireclickdetector(v3.Part.ClickDetector)
                            wait(1)
                            game.Workspace.Gravity = 0
                        end
                    end
                    local time = calculateTime(serverhopTable.speed, game.Players.LocalPlayer:DistanceFromCharacter(v.Position))
                    game.Players.LocalPlayer.Character.Torso.Anchored = false 
                    tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                end
            end
        else
            local temp = CFrames[i+1]
            local temp1 = Vector3.new(v.x, v.y, v.z)
            local temp2 = Vector3.new(temp.x, temp.y, temp.z)
            local distance = (temp1 - temp2).magnitude
            local time = calculateTime(serverhopTable.speed, distance)
            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
            game.Players.LocalPlayer.Character.Animate.fall.FallAnim.AnimationId = "0"
                        wait(time)
            for i2, v2 in pairs(stopPoints2) do
                if i == v2/3 then
                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                    wait(trinket_wait:Get())
                    game.Players.LocalPlayer.Character.Torso.Anchored = false
                end
            end
            for i2, vd in pairs(lootPoints2) do
                if i == (vd+2)/3 then
                    game.Players.LocalPlayer.Character.Torso.Anchored = true
                    local party = game.Workspace:WaitForChild("Part", 5)
                    local id = party:WaitForChild("ID", 5)
                    for i3,v3 in pairs(game.Workspace:GetChildren()) do
                        local _, t = detecttrinkets(v3)
                        if _ then
                            trinket, rarity = identify_trinket(t)
                        end

                        if (_ and game.Players.LocalPlayer:DistanceFromCharacter(v3.Position) <= 300) and (rarity == "common" and serverhopTable.commons) or (rarity == "rare" and serverhopTable.scrolls) or (rarity == "pd" and serverhopTable.pds) or (rarity == "ice" and serverhopTable.ices) or rarity == "artifact" then
                            local time = calculateTime(serverhopTable.speed, game.Players.LocalPlayer:DistanceFromCharacter(v3.Position)) 
                            game.Players.LocalPlayer.Character.Torso.Anchored = false
                            tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v3.CFrame}):Play()
                            wait(time)
                            game.Workspace.Gravity = 196.2
                            fireclickdetector(v3.Part.ClickDetector)
                            wait(1)
                            game.Workspace.Gravity = 0
                        end
                    end
                    local time = calculateTime(serverhopTable.speed, game.Players.LocalPlayer:DistanceFromCharacter(v.Position))
                    game.Players.LocalPlayer.Character.Torso.Anchored = false 
                    tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                end
            end
        end
    end
    game.Workspace.Gravity = 196.2
    ServerHop("Hopping")
end
