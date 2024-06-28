local Decimals = 4
local Clock = os.clock()
local ValueText = "Value Is Now :"
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
    cheatname = "Xoloware V2", -- watermark text
    gamename = "Da Hood", -- watermark text
})

library:init()

-- Target Strafe



local targetstrafe = {
    Enabled = false,
    TargetPlr = nil,
    delay = 0,
    highlight = false,
    Tracer = {
        enabled = false
    }
}

local character = {
    speed = {
        enabled = false,
        amount = nil
    },
    tprandom = {
        enabled = false,
        keybind = nil
    },
    tpmouse = {
        enabled = false,
        keybind = nil
    },
    nojumpcooldown = false,
    tpcommand = false
}

local camlock = {
    enabled = false,
    target = nil,
    checkwalls = false,
    prediction = 0.2,
    smoothness = 1,
    lasttick = tick(),
    knockcheck = false,
    alivecheck = false,
    teamcheck = false,
    forcefieldcheck = false,
    distance = 7500,
    wallcheck = false,
    shake = false,
    shakex = 0.1,
    shakey = 0.1,
    shakez = 0.1,
    stutteramount = 0


}


local loopkill = {
    enabled = false,
    target = nil,
    highlight = false,
    method = "Light attack"
}


local skyboxes = {
    ["Normal"] = {600886090,600830446,600831635,600832720,600833862,600835177},
    ["DoomSpire"] = {6050649245,6050664592,6050648475,6050644331,6050649718,6050650083},
    ["CatGirl"] = {444167615,444167615,444167615,444167615,444167615,444167615},
    ["Vibe"] = {1417494402,1417494030,1417494146,1417494253,1417494499,1417494643},
    ["Blue Aurora"] = {12063984,12064107,12064152,12064121,12064115,12064131},
    ["Purple Clouds"] = {151165191,151165214,151165197,151165224,151165206,151165227},
    ["Purple Nebula"] = {159454286,159454299,159454296,159454293,159454300,159454288},
    ["Twighlight"] = {264909758,264908339,264907909,264909420,264908886,264907379},
    ["Vivid Skies"] = {271042310,271042516,271077243,271042556,271042467,271077958},
    ["Purple and Blue"] = {149397684,149397692,149397686,149397697,149397688,149397702}
}

local UpdateLookAt = function()
    if targetstrafe.Enabled and targetstrafe.TargetPlr then
        Players.LocalPlayer.Character.Humanoid.AutoRotate = false
        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(targetstrafe.TargetPlr.Character.HumanoidRootPart.CFrame.X, Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, targetstrafe.TargetPlr.Character.HumanoidRootPart.CFrame.Z))
    else
        Players.LocalPlayer.Character.Humanoid.AutoRotate = true
    end
end




RunService.Stepped:Connect(function()
    local success, result = pcall(function()
          
        
        if targetstrafe.Enabled and targetstrafe.TargetPlr and targetstrafe.TargetPlr.Character and Players.LocalPlayer and Players.LocalPlayer.Character then
            local radius = 10 
            local theta = math.random() * math.pi * 2
            local phi = math.acos(2 * math.random() - 1) 
            local x = radius * math.sin(phi) * math.cos(theta)
            local y = radius * math.sin(phi) * math.sin(theta)
            local z = radius * math.cos(phi)
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetstrafe.TargetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
            UpdateLookAt()
            wait(targetstrafe.delay)
            
        end
        
    end)
    
    if not success then
        local errorMessage = result
        print("Error: " .. errorMessage)
    end
end)


-- Useful functions

local WorldToScreen = function(Position: Vector3)
    if not Position then return end

    local ViewportPointPosition, OnScreen = Camera:WorldToViewportPoint(Position)
    local ScreenPosition = Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y)
    return {
        Position = ScreenPosition,
        OnScreen = OnScreen
    }
end




local GetClosestPlayer = function()
    local Radius = math.huge
    local ClosestPlayer
    local Mouse = UserInputService:GetMouseLocation()

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer then -- Exclude LocalPlayer
            -- Variables
            local ScreenPosition = WorldToScreen(Player.Character.PrimaryPart.Position)
            local Distance = (Mouse - ScreenPosition.Position).Magnitude

            -- OnScreen Check
            if not ScreenPosition.OnScreen then continue end

            -- Checks
            if Distance < Radius then
                Radius = Distance
                ClosestPlayer = Player
            end
        end
    end

    return ClosestPlayer
end

-- Management

function TargetSrafe(isEnabled)
    if isEnabled then
        print("targetstrafe enabled!")
        targetstrafe.Enabled = true
        targetstrafe.TargetPlr = GetClosestPlayer()


    else
        print("targetstrafe disabled.")
        targetstrafe.Enabled = false
        Players.LocalPlayer.Character.Humanoid.AutoRotate = true
    end
end

-- Other functions
function TeleportClosestToMouse()
    local selected = GetClosestPlayer()
    if selected and selected.Character and character.tpmouse.enabled then 
        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = selected.Character.HumanoidRootPart.CFrame
    end
end


function TeleportRandomPlayer()
   
    local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]

    if randomPlayer and randomPlayer.Character and character.tprandom.enabled then
        local localPlayer = Players.LocalPlayer
        localPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
    end
end

local Speed = function()
    if character.speed.enabled then
        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Players.LocalPlayer.Character.Humanoid.MoveDirection * character.speed.amount
    end
end

-- Visuals

local TargHighlight = Instance.new("Highlight", CoreGui)
local TargTracerLine = Drawing.new("Line")
TargTracerLine.Thickness = 2


RunService.RenderStepped:Connect(function()
	if targetstrafe.Enabled and targetstrafe.highlight and targetstrafe.TargetPlr and targetstrafe.TargetPlr.Character then
		TargHighlight.Parent = targetstrafe.TargetPlr.Character
	else
		TargHighlight.Parent = CoreGui
	end
end)

RunService.RenderStepped:Connect(function()
    local Position, OnScreen

	if targetstrafe.Enabled and targetstrafe.Tracer.enabled and targetstrafe.TargetPlr and targetstrafe.TargetPlr.Character then
        Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetstrafe.TargetPlr.Character.HumanoidRootPart.Position + Vector3.new(0, 0.06, 0) + (targetstrafe.TargetPlr.Character.HumanoidRootPart.Velocity))
		if OnScreen then
            TargTracerLine.Visible = true
            TargTracerLine.From = UserInputService:GetMouseLocation()
            TargTracerLine.To = Vector2.new(Position.X, Position.Y)
        end
	else
		TargTracerLine.Visible = false
	end
end)

-- Character

RunService.Heartbeat:Connect(function()
    Speed()
end)

local function OnKeyPress(input)
    if character.tprandom.enabled and character.tprandom.keybind then 
        if input.KeyCode == character.tprandom.keybind then
            TeleportRandomPlayer()
            
        end

    elseif character.tpmouse.enabled and character.tpmouse.keybind then
        if input.KeyCode == character.tpmouse.keybind then
            TeleportClosestToMouse()
        end
    end
end

-- Connect the key press event to the function

game:GetService("UserInputService").InputBegan:Connect(OnKeyPress)

RunService.Stepped:Connect(function()
	Players.LocalPlayer.Character.Humanoid.UseJumpPower = not character.nojumpcooldown
end)

function FindPlayer(TargetDisplay)
    for i,v in pairs(game.Players:GetChildren()) do
        if (string.sub(string.lower(v.DisplayName),1,string.len(TargetDisplay))) == string.lower(TargetDisplay) then
            return v
        end
    end
end



game.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", math.huge):WaitForChild("OnMessageDoneFiltering", math.huge).OnClientEvent:Connect(function(data)
    if not character.tpcommand then return end
	if data ~= nil then
		local player = tostring(data.FromSpeaker)
		local message = tostring(data.Message)
        if player == Players.LocalPlayer.Name then
            local text = message:split(' ')
            if text[1] == string.lower(".tp") then 
                if text[2] == nil then 
                    return
                end
                local targetp = FindPlayer(text[2])
                if targetp.Character then 
                    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetp.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
end)
-- Lock




function GetHumanoid(Player, Character)
    return Character:FindFirstChildOfClass("Humanoid")
end

function GetRootPart(Player, Character, Humanoid)
    return Humanoid.RootPart
end
--

function ValidateClient(Player)
    local Object = Player.Character
    local Humanoid = (Object and GetHumanoid(Player, Object))
    local RootPart = (Humanoid and GetRootPart(Player, Object, Humanoid))
    --
    return Object, Humanoid, RootPart
end

function GetPlayerStatus(Player)
    if not Player then Player = Players.LocalPlayer end
    return Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 and true or false
end



function GetClosestPart(Player, List)
    local shortestDistance = math.huge
    local closestPart = nil
    if GetPlayerStatus(Player) then
        for Index, Value in pairs(Player.Character:GetChildren()) do
            if Value:IsA("BasePart") then 
                local pos = Workspace.Camera:WorldToViewportPoint(Value.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y + 36)).magnitude
                if magnitude < shortestDistance and table.find(List, Value.Name) then
                    closestPart = Value
                    shortestDistance = magnitude
                end
            end
        end 
        return closestPart
    end
end 

function RayCast(Part, Origin, Ignore, Distance)
    local IgnoreList = Ignore
    local Distance = Distance or 5000
    --
    local Cast = Ray.new(Origin, (Part.Position - Origin).Unit * Distance)
    local Hit = Workspace:FindPartOnRayWithIgnoreList(Cast, IgnoreList)
    --
    return (Hit and Hit:IsDescendantOf(Part.Parent)) == true, Hit
end

function GetTool() 
    if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") and GetPlayerStatus() then 
        return Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") 
    end 
end 

function GetOrigin(Origin)
    if Origin == "Head" then
        local Object, Humanoid, RootPart = ValidateClient(Players.LocalPlayer)
        local Head = Object:FindFirstChild("Head")
        --
        if Head and Head:IsA("RootPart") then
            return Head.CFrame.Position
        end
    elseif Origin == "Torso" then
        local Object, Humanoid, RootPart = ValidateClient(Players.LocalPlayer)
        --
        if RootPart then
            return RootPart.CFrame.Position
        end
    elseif Origin == "Handle" then 
        local Tool = GetTool()
        -- 
        if Tool then 
            return Tool.Handle.CFrame.Position
        end 
    end 
    --
    return Workspace.CurrentCamera.CFrame.Position
end

function GetHealth(Player, Character, Humanoid)
    if Humanoid then
        return math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth), Humanoid.MaxHealth
    end
end

function ClientAlive(Player, Character, Humanoid)
    local Health, MaxHealth = GetHealth(Player, Character, Humanoid)
    --
    return (Health > 0)
end

function CheckTeam(Player1, Player2)
    return (Player1.Team ~= Player2.Team)
end

function KnockCheck(Player)
    if Player.Character then 
        if Player.Character.BodyEffects ~= nil then
            if Player.Character.BodyEffects["K.O"].Value == true then 
                return false 
            end 
        end 
    end 
    return true
end 

function Camlock()
    if camlock.enabled and camlock.target and GetPlayerStatus(camlock.target) then 
        local Char, Humanoid, RootPart = ValidateClient(camlock.target)
        if Char and Humanoid and RootPart then 
            -- 
            
            --
            local MousePosition = Vector2.new(Mouse.X, Mouse.Y + 36)
            local HitPart = GetClosestPart(camlock.target, {"HumanoidRootPart"}).Name
            local Prediction = camlock.prediction or 0 
            local Shake = camlock.shake and Vector3.new(math.random(0, camlock.shakex * 20)/50, math.random(0, camlock.shakey * 20)/50, math.random(0, camlock.shakez * 20)/50) or Vector3.new(0, 0, 0)
            --
            local Tick = tick()
            -- FOVs 
            local Position1, OnScreen = Camera:WorldToViewportPoint(Char[HitPart].Position)
            local Magn = (MousePosition - Vector2.new(Position1.X, Position1.Y)).Magnitude
            --
            
            -- Dropdown Checks
            if (camlock.wallcheck and not RayCast(Char[HitPart], GetOrigin("Torso"), {Players.LocalPlayer.Character})) then return end
            if (camlock.alivecheck and not ClientAlive(camlock.target, Char, Humanoid)) then return end
            if (camlock.teamcheck and not (CheckTeam(Players.LocalPlayer, camlock.target))) then return end
            if (camlock.forcefieldcheck and Char:FindFirstChildOfClass("ForceField")) then return end 
            if (not ((Camera.CFrame.Position - RootPart.Position).Magnitude <= camlock.distance)) then return end
            if (camlock.knockedcheck and not KnockCheck(camlock.target)) then return end

            -- Moving Camera
            if ((Tick - camlock.lasttick) >= (camlock.stutteramount / 1000)) then 
                camlock.lasttick = Tick
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.p, Char[HitPart].Position + (RootPart.Velocity * Prediction) + (Shake)), (100 - camlock.smoothness) / 100)
            end 
        end
    end 
end

RunService.Heartbeat:Connect(function()
    if GetPlayerStatus() then 
        Camlock()
    end
end)

-- Looplkill

local LoopHighlight = Instance.new("Highlight", CoreGui)




RunService.RenderStepped:Connect(function()
	if loopkill.enabled and loopkill.target and loopkill.target.Character and loopkill.highlight then
		LoopHighlight.Parent = loopkill.target.Character
	else
		LoopHighlight.Parent = CoreGui
	end
end)




local isPaused = false    


function BuyKnife()
    for i,v in pairs(game:GetService("Workspace").Ignored.Shop:GetChildren()) do
        if v.Name == "[Knife] - $159" then
            local Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local Teleport = v:FindFirstChild("Head")
            if Teleport then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Teleport.CFrame
                local CD = v:FindFirstChild("ClickDetector")
                if CD then
                    wait(0.75)
                    fireclickdetector(CD)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
                end
            end
        end
        
    end
end
    
-- Deactivate tool
RunService.RenderStepped:Connect(function()
    if not loopkill.target then
        game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Deactivate()
    end
end)

-- Knife method (Beta)
RunService.RenderStepped:Connect(function()
    if not loopkill.enabled or not loopkill.target or not loopkill.target.Character or not loopkill.target.Name or loopkill.method ~= "Knife spam (BETA)" then
        return
    end

    
    
    if Players.LocalPlayer.Backpack:FindFirstChild("[Knife]") then
        Players.LocalPlayer.Character.Humanoid:EquipTool(Players.LocalPlayer.Backpack:FindFirstChild("[Knife]"))
    else
        BuyKnife()
    end


    if isPaused and Players.LocalPlayer.Character then
        Players.LocalPlayer.Character.Humanoid:UnequipTools()
        -- Execute the section of code that should run when paused
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players[loopkill.target.Name].Character.UpperTorso.Position + Vector3.new(0,2,0))
        wait()
        game.ReplicatedStorage.MainEvent:FireServer("Stomp")
        wait()
        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == false and game.Players:FindFirstChild(loopkill.target.Name)) then
                isPaused = false
            end
        end
    else
        -- Execute the section of code that should be paused
        local radius = 25 
        local theta = math.random() * math.pi * 2
        local phi = math.acos(2 * math.random() - 1) 
        local x = radius * math.sin(phi) * math.cos(theta)
        local y = radius * math.sin(phi) * math.sin(theta)
        local z = radius * math.cos(phi)

        local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character
        tool = localCharacter and localCharacter:FindFirstChildWhichIsA("Tool") -- Assign the tool variable

        if localCharacter and tool then
            local humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")

            if tool and humanoidRootPart then
                humanoidRootPart.CFrame = loopkill.target.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
                
                game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Activate()
                wait(1)
                
                humanoidRootPart.CFrame = loopkill.target.Character.HumanoidRootPart.CFrame
            end
        end

        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == true or not game.Players:FindFirstChild(loopkill.target.Name)) then
                
               
                isPaused = true
            end
        end
    end
end)

function LightPunch()
    game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Activate()
    wait(0.1)
    game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Deactivate()

end

-- Heavy attack method
-- IDK HOW TO LIGHT ATTACK! BUT LIGHT ATTACK IS OP WITH THIS
RunService.RenderStepped:Connect(function()
    if not loopkill.enabled or not loopkill.target or not loopkill.target.Character or not loopkill.target.Name or loopkill.method ~= "Light attack" then
        return
    end



    if isPaused and Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Deactivate()
        -- Execute the section of code that should run when paused
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players[loopkill.target.Name].Character.UpperTorso.Position + Vector3.new(0,2,0))
        wait()
        game.ReplicatedStorage.MainEvent:FireServer("Stomp")
        wait()
        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == false and game.Players:FindFirstChild(loopkill.target.Name)) then
                isPaused = false
            end
        end
    else
        -- Execute the section of code that should be paused
        local radius = 25 
        local theta = math.random() * math.pi * 2
        local phi = math.acos(2 * math.random() - 1) 
        local x = radius * math.sin(phi) * math.cos(theta)
        local y = radius * math.sin(phi) * math.sin(theta)
        local z = radius * math.cos(phi)

        local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character
        tool = localCharacter and localCharacter:FindFirstChildWhichIsA("Tool") -- Assign the tool variable

        if localCharacter and tool then
            local humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")

            if tool and humanoidRootPart then
                humanoidRootPart.CFrame = loopkill.target.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
                
                LightPunch() -- Disable mouse icon
                wait(1.6)
                local targetPosition = loopkill.target.Character["HumanoidRootPart"].Position + (loopkill.target.Character["HumanoidRootPart"].Velocity * 0.11)
                humanoidRootPart.CFrame = CFrame.new(targetPosition)
            end
        end

        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == true or not game.Players:FindFirstChild(loopkill.target.Name)) then
                
               
                isPaused = true
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not loopkill.enabled or not loopkill.target or not loopkill.target.Character or not loopkill.target.Name or loopkill.method ~= "Heavy attack" then
        return
    end



    if isPaused and Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Deactivate()
        -- Execute the section of code that should run when paused
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players[loopkill.target.Name].Character.UpperTorso.Position + Vector3.new(0,2,0))
        wait()
        game.ReplicatedStorage.MainEvent:FireServer("Stomp")
        wait()
        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == false and game.Players:FindFirstChild(loopkill.target.Name)) then
                isPaused = false
            end
        end
    else
        -- Execute the section of code that should be paused
        local radius = 25 
        local theta = math.random() * math.pi * 2
        local phi = math.acos(2 * math.random() - 1) 
        local x = radius * math.sin(phi) * math.cos(theta)
        local y = radius * math.sin(phi) * math.sin(theta)
        local z = radius * math.cos(phi)

        local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character
        tool = localCharacter and localCharacter:FindFirstChildWhichIsA("Tool") -- Assign the tool variable

        if localCharacter and tool then
            local humanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")

            if tool and humanoidRootPart then
                humanoidRootPart.CFrame = loopkill.target.Character.HumanoidRootPart.CFrame * CFrame.new(x, y, z)
                
                game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Activate() -- Disable mouse icon
                wait(1.6)
                local targetPosition = loopkill.target.Character["HumanoidRootPart"].Position + (loopkill.target.Character["HumanoidRootPart"].Velocity * 0.11)
                humanoidRootPart.CFrame = CFrame.new(targetPosition)
            end
        end

        if loopkill.target and loopkill.target.Character then
            local bodyEffects = loopkill.target.Character:FindFirstChild("BodyEffects")
            if bodyEffects and (bodyEffects:FindFirstChild("K.O").Value == true or not game.Players:FindFirstChild(loopkill.target.Name)) then
                
               
                isPaused = true
            end
        end
    end
end)
-- test



-- UI


local Window1  = library.NewWindow({
    title = "Xoloware V2", -- Mainwindow Text
    size = UDim2.new(0, 510, 0.6, 6
)})

local Combat = Window1:AddTab("Combat")
local Character = Window1:AddTab("Character")
local Visuals = Window1:AddTab("Visuals")
local SettingsTab = library:CreateSettingsTab(Window1)

--Tab1:SetText("Text")

local Aimlock = Combat:AddSection("Target Strafe", 1)

local Others = Combat:AddSection("Others", 2)


local Speed = Character:AddSection("Character", 1)
local Skybox = Visuals:AddSection("Skybox", 1)

--Section1:SetText("Text")

Aimlock:AddToggle({
    text = "Target Strafe",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_1",
    risky = false,
    callback = TargetSrafe
}):AddBind({
    enabled = true,
    text = "Keybind1",
    tooltip = "tooltip1",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_1",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = TargetSrafe,
    keycallback = function(v)
        print(ValueText, v)
    end
})


Aimlock:AddToggle({
    text = "Highlight",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_1",
    risky = false,
    callback = function(v)
        targetstrafe.highlight = v
    end

}):AddBind({
    enabled = true,
    text = "Keybind1",
    tooltip = "tooltip1",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_1",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        targetstrafe.highlight = v
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})

Aimlock:AddToggle({
    text = "Tracer",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_1",
    risky = false,
    callback = function(v)
        targetstrafe.Tracer.enabled = v
    end
}):AddBind({
    enabled = true,
    text = "Keybind1",
    tooltip = "tooltip1",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_1",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        targetstrafe.Tracer.enabled = v
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})

Aimlock:AddColor({
    enabled = true,
    text = "Tracer Colour",
    tooltip = "tooltip1",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    trans = 0,
    open = false,
    risky = false,
    callback = function(v)
        TargTracerLine.Color = v
        print(v)
    end
})


--[[Section1:AddBox({
    enabled = true,
    name = "TextBox1",
    flag = "TextBox_1",
    input = "PlaceHolder1",
    focused = false,
    risky = false,
    callback = function(v)
        print(ValueText, v)
    end
})--]]

--[[Section1:AddToggle({
    text = "Toggle1",
    flag = "Toggle_1",
    callback = function(v)
        print(ValueText, v)
    end
}):AddColor({
    text = "Color1",
    color = Color3.fromRGB(255, 255, 255),
    flag = "Color_1",
    callback = function(v)
        print(ValueText, v)
    end
})--]]

--[[Section1:AddBind({
    enabled = true,
    text = "Keybind1",
    tooltip = "tooltip1",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_1",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        print(ValueText, v)
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})--]]

Aimlock:AddSeparator({
    enabled = true,
    text = "Settings"
})

--[[Section1:AddButton({
    enabled = true,
    text = "Button1",
    tooltip = "tooltip1",
    confirm = true,
    risky = false,
    callback = function()
        print("Pressed!")
    end
})--]]

-- Button1:SetText("Text")

Aimlock:AddSlider({
    enabled = true,
    text = "Delay (BROKEN)",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 1,
    increment = 0.01,
    risky = false,
    callback = function(v)
        targetstrafe.delay = v
        print("Delay set to", v)
    end
})

Aimlock:AddSeparator({
    enabled = true,
    text = "Camlock"
})

--Slider_1:SetValue(100)

--[[ Section1:AddList({
    enabled = true,
    text = "Selection", 
    tooltip = "tooltip1",
    selected = "",
    multi = false,
    open = false,
    max = 4,
    values = {"1", "2", "3"},
    risky = false,
    callback = function(v)
        print(ValueText, v)
    end
}) ]]--

Aimlock:AddToggle({
    text = "Enabled",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.enabled = v
        camlock.target = GetClosestPlayer()

    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        camlock.enabled = v
        camlock.target = GetClosestPlayer()
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Prediction",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 1,
    increment = 0.01,
    risky = false,
    callback = function(v)
        camlock.prediction = v
    end
})


Aimlock:AddSlider({
    enabled = true,
    text = "Smoothness Amount",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 1,
    max = 100,
    increment = 1,
    risky = false,
    callback = function(v)
        camlock.smoothness = v
    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Stutter",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 50,
    increment = 0.1,
    risky = false,
    callback = function(v)
        camlock.stutteramount = v
    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Distance",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 1,
    max = 7500,
    increment = 1,
    risky = false,
    callback = function(v)
        camlock.distance = v
    end
})

Aimlock:AddToggle({
    text = "Shake",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.shake = v

    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Shake X",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0.01,
    max = 5,
    increment = 0.01,
    risky = false,
    callback = function(v)
        camlock.shakex = v
    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Shake Y",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0.01,
    max = 5,
    increment = 0.01,
    risky = false,
    callback = function(v)
        camlock.shakey = v
    end
})

Aimlock:AddSlider({
    enabled = true,
    text = "Shake Z",
    tooltip = "Interval between each CFrame change in target strafe",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0.01,
    max = 5,
    increment = 0.01,
    risky = false,
    callback = function(v)
        camlock.shakez = v
    end
})

Aimlock:AddToggle({
    text = "Check walls",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.wallcheck = v
    end
})

Aimlock:AddToggle({
    text = "Check teams",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.teamcheck = v

    end
})

Aimlock:AddToggle({
    text = "Check forcefield",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.forcefieldcheck = v

    end
})

Aimlock:AddToggle({
    text = "Check alive",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.alivecheck = v

    end
})

Aimlock:AddToggle({
    text = "Check knocked",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        camlock.knockedcheck = v

    end
})

Aimlock:AddSeparator({
    enabled = true,
    text = "Loopkill"
})


Aimlock:AddToggle({
    text = "Loopkill",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        print(v)

    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        loopkill.enabled = v
        if loopkill.enabled then
            loopkill.target = GetClosestPlayer()
        else 
            loopkill.target = nil
        end
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})

Aimlock:AddToggle({
    text = "Highlight",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        loopkill.highlight = v

    end
})



Aimlock:AddList({
    enabled = true,
    text = "Loopkill method (Default : Light attack)",
    tooltip = "Nigganiggernigganigger",
    selected = "",
    multi = false,
    open = false,
    max = 4,
    values = {"Heavy attack", "Knife spam (BETA)", "Light attack"},
    risky = false,
    callback = function(v)
        
        loopkill.method = v
    end

})




-- Others UI


Others:AddToggle({
    text = "Teleport to random player",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        character.tprandom.enabled = v
    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        print("v")
    end,
    keycallback = function(v)
        character.tprandom.keybind = v
    end
})

Others:AddToggle({
    text = "Mouse TP",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        character.tpmouse.enabled = true
    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        print("e")
    end,
    keycallback = function(v)
        character.tpmouse.keybind = v
    end
})


Others:AddToggle({
    text = "LightPUnch test",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        print(v)
    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        print(v)
    end,
    keycallback = function(v)
        print(v)
    end
})


Speed:AddToggle({
    text = "Speed",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        character.speed.enabled = v
    end
}):AddBind({
    enabled = true,
    text = "Keybind2",
    tooltip = "tooltip2",
    mode = "toggle",
    bind = "None",
    flag = "ToggleKey_2",
    state = false,
    nomouse = false,
    risky = false,
    noindicator = false,
    callback = function(v)
        character.speed.enabled = v
    end,
    keycallback = function(v)
        print(ValueText, v)
    end
})

Speed:AddSlider({
    enabled = true,
    text = "Amount",
    tooltip = "Fast ass nigga",
    flag = "Slider_1",
    suffix = "",
    dragging = true,
    focused = false,
    min = 0,
    max = 10,
    increment = 0.1,
    risky = false,
    callback = function(v)
        character.speed.amount = v
    end
})

Speed:AddToggle({
    text = "No Jump Cooldown",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        character.nojumpcooldown = v
    end
})

Speed:AddSeparator({
    enabled = true,
    text = "Commands"
})

Speed:AddToggle({
    text = "TP Command (Prefix: .)",
    state = false,
    risky = true,
    tooltip = "Enabled or no",
    flag = "Toggle_2",
    risky = false,
    callback = function(v)
        character.tpcommand = v
    end
})

Skybox:AddSeparator({
    enabled = true,
    text = "Only works on dahood"
})

Skybox:AddList({
    enabled = true,
    text = "Select skybox",
    tooltip = "Nigganiggernigganigger",
    selected = "",
    multi = false,
    open = false,
    max = 4,
    values = {"Normal", "DoomSpire", "CatGirl", "Vibe", "Blue Aurora", "Purple Clouds", "Purple Nebula", "Twighlight", "Vivid Skies", "Purple and Blue"},
    risky = false,
    callback = function(v)
        
        local selectedSkybox = skyboxes[v]
        if selectedSkybox then
            
            local Sky = Lighting:FindFirstChildWhichIsA("Sky")
            Sky.SkyboxLf = "rbxassetid://" .. selectedSkybox[1]
            Sky.SkyboxBk = "rbxassetid://" .. selectedSkybox[2]
            Sky.SkyboxDn = "rbxassetid://" .. selectedSkybox[3]
            Sky.SkyboxFt = "rbxassetid://" .. selectedSkybox[4]
            Sky.SkyboxRt = "rbxassetid://" .. selectedSkybox[5]
            Sky.SkyboxUp = "rbxassetid://" .. selectedSkybox[6]
			
        end
    end

})

--[[ Section1:AddList({
    enabled = true,
    text = "Selection", 
    tooltip = "tooltip1",
    selected = "",
    multi = false,
    open = false,
    max = 4,
    values = {"1", "2", "3"},
    risky = false,
    callback = function(v)
        print(ValueText, v)
    end
}) ]]--


local Time = (string.format("%."..tostring(Decimals).."f", os.clock() - Clock))
library:SendNotification(("Loaded In "..tostring(Time)), 6)

--[[
    --Window1:SetOpen(false)
    makefolder("Title Here")
    library:SetTheme(Default)
    library:GetConfig(Default)
    library:LoadConfig(Default)
    library:SaveConfig(Default)
]]


