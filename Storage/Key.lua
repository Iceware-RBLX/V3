return function(script_id)
    if getgenv().Library then
        getgenv().Library:Unload()
    end

    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
    local theme_manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/addons/ThemeManager.lua"))()
    local sdk = loadstring(game:HttpGet("https://sdk.luaprot.net/"))()

    sdk.scriptId = script_id
    getgenv().Library = library

    theme_manager:SetLibrary(library)
    theme_manager:SetDefaultTheme({ FontColor = "b8b6b9", MainColor = "222226", AccentColor = "a9a9a9", BackgroundColor = "101013", OutlineColor = "28282c" })

    do
        local loading = library:CreateLoading({ Title = "iceware", Icon = 91653242840353, TotalSteps = 3 })

        loading:SetCurrentStep(1)
        loading:SetMessage("Initializing...")
        loading:SetDescription("Waiting for game to load...")
        repeat task.wait(0.5) until game:IsLoaded() and game:GetService("ContentProvider").RequestQueueSize <= 15

        loading:SetCurrentStep(2)
        loading:SetMessage("Verifying files")
        loading:SetDescription("")
        task.wait(0.4)
        if not isfolder("iceware") then makefolder("iceware") end
        if not isfolder("iceware/Key") then makefolder("iceware/Key") end

        loading:SetCurrentStep(3)
        loading:SetMessage("Checking saved key")
        task.wait(0.4)
        if isfile("iceware/Key/key.json") then
            local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("iceware/Key/key.json")) end)
            if ok and data.Key and sdk:checkKey(data.Key).status == "VALID" then
                loading:Destroy()
                library:Notify({ Title = "iceware", Description = "Valid key! Loading script, don't touch anything...", Time = 10 })
                return sdk:loadScript(data.Key)
            end
            delfile("iceware/Key/key.json")
            library:Notify({ Title = "iceware", Description = "Your saved key expired, get a new key to continue using iceware!", Time = 5 })
        end

        loading:Destroy()
    end

    local window = library:CreateWindow({
        Title = "iceware",
        Footer = "Key System",
        Icon = 91653242840353,
        IconSize = UDim2.fromOffset(50, 50),
        Size = UDim2.fromOffset(720, 380),
        NotifySide = "Right",
        Center = true,
        Animations = { ToggleWindow = true, TabSwitch = true, Groupbox = true, Dropdown = true, KeyPicker = true },
        Font = Enum.Font.GothamMedium,
        DisableSearch = true,
    })
    window:SetCompact(true)

    local key_tab = window:AddTab("Key", "key")
    key_tab:UpdateWarningBox({ Title = "Hello!", Text = "Thanks for using iceware", IsNormal = true, Visible = true, LockSize = true })

    do
        local license = key_tab:AddLeftGroupbox("License", "key")

        local key_input = license:AddInput("Key Input", { Text = "Key", Placeholder = "Key goes here!" })
        local remember_me = license:AddCheckbox("Remember Me", { Text = "Remember Me", Default = true, Tooltip = "Skips this screen while your key is valid" })

        license:AddButton("Check Key", function()
            local key = key_input.Value:gsub("%s", "")
            if key == "" then
                return library:Notify({ Title = "iceware", Description = "Please enter a key first!", Time = 5 })
            end

            local result = sdk:checkKey(key)
            if result.status ~= "VALID" then
                return library:Notify({ Title = "iceware", Description = "Invalid key: " .. tostring(result.message or result.status), Time = 5 })
            end

            if remember_me.Value then
                writefile("iceware/Key/key.json", game:GetService("HttpService"):JSONEncode({ Key = key }))
            end

            library:Notify({ Title = "iceware", Description = "Valid key! Loading script, don't touch anything...", Time = 10 })
            library:Toggle(false)
            sdk:loadScript(key)
        end)

        license:AddButton("Get Key", function()
            setclipboard("https://luaprot.net/ad/1fb1557a")
            library:Notify({ Title = "iceware", Description = "Key link copied to clipboard!", Time = 5 })
        end)
    end

    do
        local info = key_tab:AddRightGroupbox("Information", "badge-info")

        info:AddLabel("Get a key by completing the checkpoints on the key link", true)
        info:AddLabel("Your key is securely verified using LuaProt", true)
        info:AddLabel("Keys are tied to your HWID and cannot be shared or transferred", true)

        info:AddButton("Copy Discord Invite", function()
            setclipboard("https://discord.gg/sn2Etx6M8G")
            library:Notify({ Title = "iceware", Description = "Invite copied to clipboard!", Time = 5 })
        end)

        info:AddButton("Unload", function()
            library:Unload()
        end)
    end
end
