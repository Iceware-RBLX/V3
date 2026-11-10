--[[

 _                  _____ 
(_)_      __ __   _|___ / 
| \ \ /\ / / \ \ / / |_ \ 
| |\ V  V /   \ V / ___) |
|_| \_/\_/     \_/ |____/ 


]]
cloneref = cloneref or function(x) return x end

repeat task.wait() until game:IsLoaded() and cloneref(game:GetService("ContentProvider")).RequestQueueSize <= 10

cloneref(game:GetService("Players")).LocalPlayer.Idled:Connect(function()
    cloneref(game:GetService("VirtualUser")):ClickButton2(Vector2.new())
end)

local shared = {
    folders = {
        main = "iw",
        games = "iw/Games",
        key = "iw/Key",
        assets = "iw/Assets",
    };
}

for _, folder in shared.folders do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

writefile("iw/Discord.txt", "https://discord.gg/sn2Etx6M8G")

local games = {
    [{4793836769}] = "92692403819809795006", -- Midnight Chasers
    [{1202096104}] = "25792694393002956600", -- Driving Empire
    [{605887098}] = "12515916467417583288", -- Car Dealership Tycoon
    [{10173311467}] = "81982634389344722755", -- Ghost Drivers
    [{371263894}] = "13415668321463585599", -- Greenville
    [{2851381018}] = "00105413212555076990", -- Taxi Boss
    [{7094518649}] = "10634400818335330310", -- Restaurant Tycoon 3
    [{6504986360}] = "25527719178032843308", -- Bubble Gum Simulator Infinity
    [{6751447237}] = "43978668653069666766", -- Car Zone
    [{9979684281}] = "70091420735372637001", -- Mechanic Legends
    [{66654135}] = "51001665699117764808", -- Murder Mystery 2
}

for ids, id in games do
    if table.find(ids, game.GameId) then
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Iceware-RBLX/V3/refs/heads/main/Storage/Key.lua"))()(id)
        end)
        if not ok then
            --warn("Failed 2 load" .. err)
        end
    end
end
