getgenv().speed = 16
getgenv().trinketSpawnWaitTimes = 5 -- in seconds
getgenv().lootCycleWaitTimes = 0.25 -- in minutes
getgenv().key = "" -- KEY GOES HERE 
--E TO PLACE NORMAL POINT
--J TO PLACE TRINKET WAIT POINT
--Y TO RESTART/DESTROY PATH (NOTE THAT THIS APPLIES TO THE SAVED PATH)
--H TO START PATH
--T TO UNDO WHEN MAKING PATH
-- DONT TOUCH ANYTHING BEYOND THIS POINT
getgenv().code = nil
getgenv().something = true
if not code then
    code = game:HttpGet(("https://raw.githubusercontent.com/Blazuno/better/main/painv2.lua"),true)
end

if code == game:HttpGet(("https://raw.githubusercontent.com/Blazuno/better/main/painv2.lua"),true) then
    if not reexec then
        loadstring(code)()
    end
else
    print("Script updated")
    something = false
    wait(2)
    something = true
    code = nil
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Blazuno/better/main/painv2.lua"),true))()
end
