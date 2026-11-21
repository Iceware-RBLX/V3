return function(library, tab, license)
    cloneref = cloneref or function(x) return x end

    local players = cloneref(game:GetService("Players"))
    local lp = players.LocalPlayer
    local low_end = identifyexecutor and (identifyexecutor():lower():find("solara") or identifyexecutor():lower():find("xeno")) or false
    local start = os.clock()

    local buyer, execs, left
    if license then
        buyer, execs, left = license()
    end
    local expires = left and left > 0 and os.time() + left

    local function create(class, props, theme)
        local obj = Instance.new(class)
        for k, v in props do
            obj[k] = v
        end
        if theme then
            library:AddToRegistry(obj, theme)
        end
        return obj
    end

    local function bold()
        return Font.new(library.Scheme.Font.Family, Enum.FontWeight.Bold)
    end

    local function fmt(s)
        s = math.floor(s)
        if s >= 86400 then
            return math.floor(s / 86400) .. "d " .. math.floor(s % 86400 / 3600) .. "h"
        elseif s >= 3600 then
            return math.floor(s / 3600) .. "h " .. math.floor(s % 3600 / 60) .. "m"
        end
        return math.floor(s / 60) .. "m " .. s % 60 .. "s"
    end

    tab:UpdateWarningBox({ IsNormal = true, Visible = true, Title = "", Text = "\n\n" })
    local header = tab.Container:FindFirstChildOfClass("Frame"):FindFirstChildOfClass("Frame")

    local avatar = create("ImageLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(46, 46), Image = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150", Parent = header }, { BackgroundColor3 = "MainColor" })
    create("UICorner", { CornerRadius = UDim.new(0, library.CornerRadius), Parent = avatar })
    create("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 68, 0.5, 0), Size = UDim2.new(1, -200, 0, 20), Text = lp.DisplayName, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = header }, { TextColor3 = "FontColor", FontFace = bold })
    create("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, 68, 0.5, 2), Size = UDim2.new(1, -200, 0, 16), Text = "@" .. lp.Name, TextSize = 13, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Left, Parent = header }, { TextColor3 = "FontColor", FontFace = "Font" })
    local clock = create("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(120, 20), TextSize = 18, TextXAlignment = Enum.TextXAlignment.Right, Parent = header }, { TextColor3 = "FontColor", FontFace = bold })
    local date = create("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0.5, 2), Size = UDim2.fromOffset(160, 16), TextSize = 12, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Right, Parent = header }, { TextColor3 = "FontColor", FontFace = "Font" })

    local server = tab:AddLeftGroupbox("Server", "server", true, false, true)
    local place = server:AddLabel("Game: ...", true)
    local count = server:AddLabel("Players: ...")
    local ping = server:AddLabel("Ping: ...")
    local age = server:AddLabel("Server Age: ...")
    server:AddButton("Rejoin", function()
        if #players:GetPlayers() <= 1 then
            cloneref(game:GetService("TeleportService")):Teleport(game.PlaceId, lp)
        else
            cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        end
    end):AddButton("Copy Job ID", function()
        setclipboard(game.JobId)
        library:Notify({ Title = "Notification", Description = "Copied Job ID to clipboard", Time = 3 })
    end)

    local client = tab:AddLeftGroupbox("Client", "monitor", true, false, true)
    client:AddLabel("Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"), true)
    local status = client:AddLabel("Status: " .. (low_end and "Limited" or "Supported"))
    library.Registry[status.TextLabel].TextColor3 = function() return low_end and Color3.fromRGB(255, 200, 77) or Color3.fromRGB(77, 255, 77) end
    local fps = client:AddLabel("FPS: ...")
    local session = client:AddLabel("Session: ...")

    local key = tab:AddRightGroupbox("License", "key", true, false, true)
    local plan = key:AddLabel("Plan: ...")
    library.Registry[plan.TextLabel].TextColor3 = function() return buyer and Color3.fromRGB(77, 255, 77) or Color3.fromRGB(255, 166, 77) end
    local executions = key:AddLabel("Executions: ...")
    local expiry = key:AddLabel("Expires: ...")

    local discord = tab:AddRightGroupbox("Discord", "message-square", true, false, true)
    discord:AddLabel("If you have any issues or want any feature requested, head to our Discord server!", true)
    discord:AddButton("Join Discord", function()
        if request then
            pcall(request, {
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = cloneref(game:GetService("HttpService")):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    nonce = cloneref(game:GetService("HttpService")):GenerateGUID(false),
                    args = { code = "GE8S2Seee3" }
                })
            })
        end
    end)

    local log = tab:AddRightGroupbox("Changelog", "scroll-text", true, false, true)
    log.Container:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, 2)
    for _, entry in {
        { "Update 2", "67", { "Hello", "inline", "stuff" } },
        { "Update 1", "Release", { "Meow" } },
    } do
        local title = log:AddLabel({ Text = entry[1], Size = 15 })
        library.Registry[title.TextLabel].TextColor3 = "AccentColor"
        library.Registry[title.TextLabel].FontFace = bold
        create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = entry[2], TextSize = 12, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Right, Parent = title.TextLabel }, { TextColor3 = "FontColor", FontFace = "Font" })
        for _, text in entry[3] do
            log:AddLabel({ Text = "- " .. text, DoesWrap = true, Size = 12 }).TextLabel.TextTransparency = 0.2
        end
    end

    library:UpdateColorsUsingRegistry()

    task.spawn(function()
        local ok, info = pcall(function()
            return cloneref(game:GetService("MarketplaceService")):GetProductInfo(game.PlaceId)
        end)
        place:SetText("Game: " .. (ok and info.Name or "Unknown"))
    end)

    task.spawn(function()
        while not library.Unloaded do
            clock.Text = os.date("%H:%M")
            date.Text = os.date("%d %B %Y")
            count:SetText("Players: " .. #players:GetPlayers() .. " / " .. players.MaxPlayers)
            ping:SetText("Ping: " .. math.floor(cloneref(game:GetService("Stats")).Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms")
            age:SetText("Server Age: " .. fmt(workspace.DistributedGameTime))
            session:SetText("Session: " .. fmt(os.clock() - start))
            fps:SetText("FPS: " .. math.floor(1 / cloneref(game:GetService("RunService")).RenderStepped:Wait()))

            if license then
                buyer, execs = license()
            end
            plan:SetText("Plan: " .. (buyer and "Premium" or "Freemium"))
            plan.TextLabel.TextColor3 = library.Registry[plan.TextLabel].TextColor3()
            executions:SetText("Executions: " .. (execs or "Unavailable"))

            if expires then
                expiry:SetText("Expires: " .. (expires > os.time() and fmt(expires - os.time()) or "Expired"))
            else
                expiry:SetText("Expires: " .. (left == 0 and "Never" or "Unavailable"))
            end

            task.wait(1)
        end
    end)
end
