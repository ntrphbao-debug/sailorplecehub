--// ntrphbao hub FIX 773

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlaceID = game.PlaceId

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ntrphbaoHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,250,0,140)
frame.Position = UDim2.new(0.4,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ntrphbao hub"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)

local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(0.8,0,0.3,0)
button.Position = UDim2.new(0.1,0,0.5,0)
button.BackgroundColor3 = Color3.fromRGB(0,170,255)
button.Text = "Hop Server Garou"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(255,255,255)

Instance.new("UICorner", button)

-- Notify
local function notify(txt)
    pcall(function()
        game.StarterGui:SetCore("SendNotification",{
            Title = "ntrphbao hub",
            Text = txt,
            Duration = 5
        })
    end)
end

-- Check Garou
local function HasGarou()
    for _,v in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(v.Name),"garou") then
            return true
        end
    end
    return false
end

-- Hop Server FIX
local function HopServer()
    notify("Đang hop server...")

    local success, err = pcall(function()
        local req = game:HttpGet(
            "https://games.roblox.com/v1/games/"..
            PlaceID..
            "/servers/Public?sortOrder=Asc&limit=100"
        )

        local data = HttpService:JSONDecode(req)

        for _,server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                
                -- FIX ERROR 773
                TeleportService:TeleportToPlaceInstance(
                    PlaceID,
                    server.id,
                    player
                )

                wait(3)
            end
        end
    end)

    if not success then
        notify("Hop thất bại!")
        warn(err)
    end
end

button.MouseButton1Click:Connect(function()
    if HasGarou() then
        notify("Đã tìm thấy Garou!")
    else
        HopServer()
    end
end)
