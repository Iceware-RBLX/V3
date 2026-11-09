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

if isfile("iceware/Version.txt") and readfile("iceware/Version.txt") ~= "V3.0.0" then
    delfolder("iceware")
end

local shared = {
    version = "V3.0.0",
    folders = {
        main = "iceware",
        games = "iceware/Games",
        key = "iceware/Key",
        assets = "iceware/Assets",
    };
}

for _, folder in shared.folders do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

writefile("iceware/Discord.txt", "https://discord.gg/sn2Etx6M8G")
writefile("iceware/Version.txt", shared.version)

local games = {
    [{4793836769}] = "", -- Midnight Chasers
    [{1202096104}] = "", -- Driving Empire
    [{605887098}] = "", -- Car Dealership Tycoon
    [{10173311467}] = "", -- Ghost Drivers
    [{371263894}] = "", -- Greenville
    [{2851381018}] = "00105413212555076990", -- Taxi Boss
    [{7094518649}] = "", -- Restaurant Tycoon 3
    [{6504986360}] = "", -- Bubble Gum Simulator Infinity
    [{6751447237}] = "", -- Car Zone
    [{9979684281}] = "", -- Mechanic Legends
    [{66654135}] = "", -- Murder Mystery 2
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
