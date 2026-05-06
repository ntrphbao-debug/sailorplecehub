--// ntrphbao hub FULL FIX

repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- SEA 2 PLACE ID
local PlaceID = 77747658251236

-- ANTI DUPLICATE UI
pcall(function()
    game.CoreGui.ntrphbaoHub:Destroy()
end)

local hopping = false

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ntrphbaoHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,250,0,140)
frame.Position = UDim2.new(0.4,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true

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

-- NOTIFY
local function notify(txt)

    pcall(function()

        game.StarterGui:SetCore("SendNotification",{
            Title = "ntrphbao hub",
            Text = tostring(txt),
            Duration = 5
        })

    end)
end

-- DRAG UI
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

    local delta = input.Position - dragStart

    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

frame.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input

    end
end)

UIS.InputChanged:Connect(function(input)

    if input == dragInput and dragging then
        update(input)
    end

end)

-- CHECK GAROU
local function HasGarou()

    for _,v in pairs(workspace:GetDescendants()) do

        if string.find(string.lower(v.Name),"garou") then
            return true
        end

    end

    return false
end

-- HTTP REQUEST FIX
local requestfunc =
    (syn and syn.request)
    or (http and http.request)
    or http_request
    or request

if not requestfunc then
    notify("Executor không hỗ trợ request")
    return
end

-- HOP SERVER
local function HopServer()

    notify("Đang tìm server...")

    local success, result = pcall(function()

        local response = requestfunc({
            Url =
            "https://games.roblox.com/v1/games/"..
            game.GameId..
            "/servers/Public?sortOrder=Asc&limit=100",

            Method = "GET"
        })

        return response.Body
    end)

    if not success then
        notify("Lỗi request")
        warn(result)
        return
    end

    local dataSuccess, data =
        pcall(function()
            return HttpService:JSONDecode(result)
        end)

    if not dataSuccess then
        notify("Lỗi decode")
        return
    end

    if not data.data then
        notify("Không load được server")
        return
    end

    local Servers = {}

    for _,server in pairs(data.data) do

        if tonumber(server.playing)
        and tonumber(server.maxPlayers)
        and server.id
        and server.id ~= game.JobId
        and server.playing < server.maxPlayers then

            table.insert(Servers, server.id)

        end
    end

    if #Servers <= 0 then
        notify("Không có server")
        return
    end

    notify("Đang hop...")

    local RandomServer =
        Servers[math.random(1,#Servers)]

    local tpSuccess, tpError =
        pcall(function()

            TeleportService:TeleportToPlaceInstance(
                PlaceID,
                RandomServer,
                player
            )

        end)

    if not tpSuccess then
        notify("Teleport thất bại")
        warn(tpError)
    end
end

-- BUTTON
button.MouseButton1Click:Connect(function()

    if hopping then
        notify("Đợi chút...")
        return
    end

    hopping = true

    if HasGarou() then

        notify("Đã tìm thấy Garou!")

    else

        HopServer()

    end

    wait(5)

    hopping = false

end)
