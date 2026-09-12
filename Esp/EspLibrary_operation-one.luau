--[[
natsuki.pink esp lib lol
wawawawa
]]

if getgenv().ESP and getgenv().ESP.Unload then
    pcall(getgenv().ESP.Unload, getgenv().ESP)
end

-- Services
local Workspace = cloneref(game:GetService("Workspace"))
local Camera = cloneref(Workspace.CurrentCamera)
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local RunService = cloneref(game:GetService("RunService"))

-- Framework
local Framework = {}; Framework.__index = Framework; do
    function Framework:Round_V2(V2)
        return Vector2.new(math.floor(V2.X + 0.5), math.floor(V2.Y + 0.5))
    end
    function Framework:Draw(Object, Properties)
        Object = Drawing.new(Object)
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
        return Object
    end
    function Framework:Drawing_Transparency(Transparency)
        return 1 - Transparency
    end
end

-- Main
if not isfolder("Natsuki") then makefolder("Natsuki") end
if not isfolder("Natsuki/assets") then makefolder("Natsuki/assets") end
if not isfile("Natsuki/assets/Natsuki.faggot") then
    writefile("Natsuki/assets/Natsuki.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/natsuki.png"))
end
if not isfile("Natsuki/assets/Monika.faggot") then
    writefile("Natsuki/assets/Monika.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Monika.png"))
end
if not isfile("Natsuki/assets/Sayori.faggot") then
    writefile("Natsuki/assets/Sayori.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Sayori.png"))
end
if not isfile("Natsuki/assets/Armyane.faggot") then
    writefile("Natsuki/assets/Armyane.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Armyane.png"))
end
if not isfile("Natsuki/assets/Dvizuha.faggot") then
    writefile("Natsuki/assets/Dvizuha.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Dvizuha.png"))
end
if not isfile("Natsuki/assets/Wypher.faggot") then
    writefile("Natsuki/assets/Wypher.faggot", game:HttpGet("https://raw.githubusercontent.com/softwarebusiness/Natsuki/refs/heads/main/Wypher.png"))
end
local Images = {
    Natsuki = readfile("Natsuki/assets/Natsuki.faggot"),
    Monika = readfile("Natsuki/assets/Monika.faggot"),
    Sayori = readfile("Natsuki/assets/Sayori.faggot"),
    Armyane = readfile("Natsuki/assets/Armyane.faggot"),
    Dvizuha = readfile("Natsuki/assets/Dvizuha.faggot"),
    Wypher = readfile("Natsuki/assets/Wypher.faggot")
}

local Skeleton
local Skeleton_Max
local playerViewmodels = {}

getgenv().ESP = {
    Settings = {
        Enabled = false,
        Bold_Text = false,
        Team_Check = false,
        Self_Esp = false,
        Visible_Check = false,
        Maximal_Distance = 3000,
        Box = {Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0},
        Box_Outline = {Enabled = false, Color = Color3.new(0, 0, 0), Transparency = 0, Outline_Size = 1},
        Healthbar = {Enabled = false, Position = "Left", Color = Color3.new(1, 1, 1), Color_Lerp = Color3.fromRGB(222, 123, 241)},
        Name = {Enabled = false, Position = "Top", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Distance = {Enabled = false, Position = "Bottom", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Tool = {Enabled = false, Position = "Right", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Health = {Enabled = false, Position = "Right", Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Skeleton = {Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0, Thickness = 1},
        Image = {Enabled = false, Image = "Natsuki"},
    },
    Objects = {},
    Overrides = {},
    Connections = {},
    Current_Image = "Natsuki",
    Viewmodels = playerViewmodels,
}
ESP.__index = ESP

function ESP:UpdateImages()
    ESP.Current_Image = self.Settings.Image.Image
    for _, Object in pairs(self.Objects) do
        local Drawing = Object.Components.Image
        if Drawing then
            Drawing.Data = Images[ESP.Current_Image]
        end
    end
end

function ESP:GetObject(Object)
    return self.Objects[Object]
end

function ESP:Toggle(State)
    self.Settings.Enabled = State
end

function ESP:Set_Color(Color, Target)
    if not Color then return end
    if not Target or Target == "All" then
        self.Settings.Box.Color = Color
        self.Settings.Box_Outline.Color = Color
        self.Settings.Name.Color = Color
        self.Settings.Distance.Color = Color
        self.Settings.Tool.Color = Color
        self.Settings.Healthbar.Color = Color
        self.Settings.Skeleton.Color = Color
        for _, Object in pairs(self.Objects) do
            local C = Object.Components
            if C.Box then C.Box.Color = Color end
            if C.Box_Outline then C.Box_Outline.Color = Color end
            if C.Name then C.Name.Color = Color end
            if C.NameBold then C.NameBold.Color = Color end
            if C.Distance then C.Distance.Color = Color end
            if C.DistanceBold then C.DistanceBold.Color = Color end
            if C.Tool then C.Tool.Color = Color end
            if C.ToolBold then C.ToolBold.Color = Color end
            if C.Skeleton then
                for _, Line in pairs(C.Skeleton) do
                    Line.Color = Color
                end
            end
        end
    else
        local S = self.Settings[Target]
        if S then S.Color = Color end
        for _, Object in pairs(self.Objects) do
            local C = Object.Components[Target]
            if C then
                if Target == "Skeleton" then
                    for _, Line in pairs(C) do
                        Line.Color = Color
                    end
                else
                    C.Color = Color
                end
            end
        end
    end
end

function ESP:Unload()
    local Objects = self.Objects
    for _, Object in pairs(Objects) do
        pcall(function() Object:Destroy() end)
    end

    for _, Connection in pairs(self.Connections) do
        pcall(function() Connection:Disconnect() end)
    end

    table.clear(self.Connections)
    table.clear(self.Objects)
    table.clear(playerViewmodels)
    getgenv().ESP = nil
end

function ESP:Get_Team(Player)
    if self.Overrides.Get_Team ~= nil then
        return self.Overrides.Get_Team(Player)
    end
    return Player.Team
end

function ESP:Get_Character(Player)
    if self.Overrides.Get_Character ~= nil then
        return self.Overrides.Get_Character(Player)
    end
    return Player.Character
end

function ESP:Get_Viewmodel(Player)
    if self.Overrides.Get_Viewmodel ~= nil then
        return self.Overrides.Get_Viewmodel(Player)
    end
    return playerViewmodels[Player]
end

function ESP:Get_Character_For_Viewmodel(Viewmodel)
    if not Viewmodel then return nil end
    local Torso = Viewmodel:FindFirstChild("torso")
    if not Torso then return nil end
    local Motor = Torso:FindFirstChild("JointMotor")
    if Motor and Motor:IsA("Motor6D") and Motor.Part0 then
        local Char = Motor.Part0.Parent
        if Char and Char:IsA("Model") and Char:FindFirstChild("HumanoidRootPart") then
            return Char
        end
    end
    return nil
end

function ESP:Link_Viewmodel(Viewmodel)
    if not Viewmodel or Viewmodel.Name == "LocalViewmodel" then return end
    task.delay(0.3, function()
        if not Viewmodel or not Viewmodel.Parent then return end
        local Torso = Viewmodel:FindFirstChild("torso")
        if not Torso then return end
        local Motor = Torso:FindFirstChild("JointMotor")
        if Motor and Motor:IsA("Motor6D") and Motor.Part0 then
            local Char = Motor.Part0.Parent
            if Char and Char:IsA("Model") then
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player.Character == Char then
                        playerViewmodels[Player] = Viewmodel
                        return
                    end
                end
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player.Name == Char.Name then
                        playerViewmodels[Player] = Viewmodel
                        return
                    end
                end
            end
        end
    end)
end

function ESP:Unlink_Viewmodel(Viewmodel)
    for Player, VM in pairs(playerViewmodels) do
        if VM == Viewmodel then
            playerViewmodels[Player] = nil
            break
        end
    end
end

function ESP:Get_Tool(Player)
    if self.Overrides.Get_Tool ~= nil then
        return self.Overrides.Get_Tool(Player)
    end
    local Viewmodel = self:Get_Viewmodel(Player)
    if Viewmodel then
        for _, Child in pairs(Viewmodel:GetChildren()) do
            if Child:IsA("Model") and Child.Name ~= "Model" then
                return Child.Name
            end
        end
    end
    return "Nothing"
end

function ESP:Get_Health(Player)
    if self.Overrides.Get_Health ~= nil then
        return self.Overrides.Get_Health(Player)
    end
    local Character = self:Get_Character(Player)
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            return Humanoid.Health
        end
    end
    return 100
end

function ESP:Check_Visible(Part)
    if self.Overrides.Visible_Check ~= nil then
        return self.Overrides.Visible_Check(Part)
    end
    if not Part or not Part.Parent then return false end
    local Origin = Camera.CFrame.Position
    local Dir = Part.Position - Origin
    local Ray = Ray.new(Origin, Dir.Unit * Dir.Magnitude)
    local Ignore = {Camera}
    if LocalPlayer.Character then
        table.insert(Ignore, LocalPlayer.Character)
    end
    local Hit = Workspace:FindPartOnRayWithIgnoreList(Ray, Ignore)
    if not Hit then return false end
    return Hit == Part or Hit:IsDescendantOf(Part.Parent)
end

local Component_Keys = {
    "Box", "Box_Outline",
    "Healthbar", "Healthbar_Outline",
    "Name", "NameBold",
    "Distance", "DistanceBold",
    "Tool", "ToolBold",
    "Health", "HealthBold",
    "Image",
}

function ESP:Hide_All(Components)
    for _, Key in pairs(Component_Keys) do
        local C = Components[Key]
        if C then C.Visible = false end
    end
    local Skel = Components.Skeleton
    if Skel then
        for _, Line in pairs(Skel) do
            Line.Visible = false
        end
    end
end

local Player_Metatable = {}
do -- Player Metatable
    Player_Metatable.__index = Player_Metatable
    function Player_Metatable:Destroy()
        for Index, Component in pairs(self.Components) do
            if Index == "Skeleton" then
                for _, Line in pairs(Component) do
                    pcall(function()
                        Line.Visible = false
                        Line:Remove()
                    end)
                end
            else
                pcall(function()
                    Component.Visible = false
                    Component:Remove()
                end)
            end
            self.Components[Index] = nil
        end
        ESP.Objects[self.Player] = nil
    end
    function Player_Metatable:Update()
        local Components = self.Components
        local Box, Box_Outline = Components.Box, Components.Box_Outline
        local Healthbar, Healthbar_Outline = Components.Healthbar, Components.Healthbar_Outline
        local Name, NameBold = Components.Name, Components.NameBold
        local Distance, DistanceBold = Components.Distance, Components.DistanceBold
        local Tool, ToolBold = Components.Tool, Components.ToolBold
        local Health, HealthBold = Components.Health, Components.HealthBold
        local Image = Components.Image

        if Box == nil or Box_Outline == nil or Healthbar == nil or Healthbar_Outline == nil or Name == nil or NameBold == nil or Distance == nil or DistanceBold == nil or Tool == nil or ToolBold == nil or Health == nil or HealthBold == nil or Image == nil then
            self:Destroy()
            return
        end

        local Local_UserId = LocalPlayer and LocalPlayer.UserId
        local Is_Self = Local_UserId and self.Player.UserId == Local_UserId
        if Is_Self and not ESP.Settings.Self_Esp then
            ESP:Hide_All(Components)
            return
        end

        local Character = ESP:Get_Character(self.Player)
        if Character == nil then
            ESP:Hide_All(Components)
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid then
            ESP:Hide_All(Components)
            return
        end

        local Current_Health, Health_Maximum = ESP:Get_Health(self.Player), Humanoid.MaxHealth
        if Current_Health <= 0 then
            ESP:Hide_All(Components)
            return
        end

        local Viewmodel = ESP:Get_Viewmodel(self.Player)
        if not Viewmodel or not Viewmodel.Parent then
            ESP:Hide_All(Components)
            return
        end

        local Head_Part = Viewmodel:FindFirstChild("head")
        local Leg1 = Viewmodel:FindFirstChild("leg1")
        local Leg2 = Viewmodel:FindFirstChild("leg2")

        if not (Head_Part and (Leg1 or Leg2)) then
            ESP:Hide_All(Components)
            return
        end

        local Bottom_Part = Leg1
        if Leg1 and Leg2 then
            Bottom_Part = Leg1.Position.Y < Leg2.Position.Y and Leg1 or Leg2
        end

        local TopPos, Vis1 = Camera:WorldToViewportPoint(Head_Part.Position)
        local BottomPos, Vis2 = Camera:WorldToViewportPoint(Bottom_Part.Position)

        if not (Vis1 and Vis2) then
            ESP:Hide_All(Components)
            return
        end

        local Raw_Height = math.abs(TopPos.Y - BottomPos.Y)
        local Height = Raw_Height * 1.2
        local Top_Y = math.min(TopPos.Y, BottomPos.Y) - (Height - Raw_Height) * 0.5
        local Width = Height / 2

        local Sum_X = TopPos.X + BottomPos.X
        local Count = 2
        if Leg1 and Leg2 then
            local Leg1_Pos = Camera:WorldToViewportPoint(Leg1.Position)
            local Leg2_Pos = Camera:WorldToViewportPoint(Leg2.Position)
            if Leg1_Pos then
                Sum_X = Sum_X + Leg1_Pos.X
                Count = Count + 1
            end
            if Leg2_Pos then
                Sum_X = Sum_X + Leg2_Pos.X
                Count = Count + 1
            end
        end
        local X_Center = Sum_X / Count

        local Box_Size = Framework:Round_V2(Vector2.new(Width, Height))
        local Box_Position = Framework:Round_V2(Vector2.new(X_Center - Width * 0.5, Top_Y))

        local Center_World = Head_Part.Position:Lerp(Bottom_Part.Position, 0.5)
        local Screen_Pos = Camera:WorldToViewportPoint(Center_World)
        local Meter_Distance = math.floor(Screen_Pos.Z / 3.5714285714 + 0.5)
        local On_Screen = Vis1 and Vis2

        local Good = false
        if ESP.Settings.Team_Check then
            if ESP:Get_Team(self.Player) ~= ESP:Get_Team(LocalPlayer) then
                Good = true
            end
        else
            Good = true
        end

        local Visible = true
        if ESP.Settings.Visible_Check then
            Visible = ESP:Check_Visible(Head_Part)
        end

        if ESP.Settings.Enabled and On_Screen and Meter_Distance < ESP.Settings.Maximal_Distance and Good and Visible then
            local Box_Left = Box_Position.X
            local Box_Top = Box_Position.Y
            local Box_Right = Box_Left + Box_Size.X
            local Box_Bottom = Box_Top + Box_Size.Y
            local Box_Center_X = Box_Left + Box_Size.X * 0.5

            local Top_Padding = 8
            local Bottom_Padding = 2
            local Side_Padding = 6

            local Top_Cursor = Top_Padding
            local Bottom_Cursor = Bottom_Padding
            local Left_Cursor = 0
            local Right_Cursor = 0

            -- Box
            local Box_Settings = ESP.Settings.Box
            Box.Size = Box_Size
            Box.Position = Box_Position
            Box.Color = Box_Settings.Color
            Box.Transparency = Framework:Drawing_Transparency(Box_Settings.Transparency)
            Box.Visible = Box_Settings.Enabled

            local Box_Outline_Settings = ESP.Settings.Box_Outline
            Box_Outline.Size = Box_Size
            Box_Outline.Position = Box_Position
            Box_Outline.Color = Box_Outline_Settings.Color
            Box_Outline.Thickness = Box_Outline_Settings.Outline_Size + 2
            Box_Outline.Transparency = Framework:Drawing_Transparency(Box_Outline_Settings.Transparency)
            Box_Outline.Visible = Box_Settings.Enabled and Box_Outline_Settings.Enabled or false

            local Image_Settings = ESP.Settings.Image
            if Image_Settings.Enabled then
                Image.Size = Box_Size
                Image.Position = Box_Position
            end
            Image.Visible = Image_Settings.Enabled

            -- Healthbar
            local Healthbar_Settings = ESP.Settings.Healthbar
            local Healthbar_Enabled = Healthbar_Settings.Enabled
            local Healthbar_Position = Healthbar_Settings.Position
            local Health_Lerp_Color = Healthbar_Settings.Color:Lerp(Healthbar_Settings.Color_Lerp, Current_Health / Health_Maximum)
            local Health_Ratio = math.clamp(Current_Health / Health_Maximum, 0, 1)

            if Healthbar_Enabled then
                if Healthbar_Position == "Left" then
                    local H = Box_Size.Y
                    local Fill_H = H * Health_Ratio
                    Healthbar_Outline.Size = Vector2.new(3, H)
                    Healthbar_Outline.Position = Vector2.new(Box_Left - 7, Box_Top)
                    Healthbar.Size = Vector2.new(1, Fill_H)
                    Healthbar.Position = Vector2.new(Box_Left - 6, Box_Top + (H - Fill_H))
                elseif Healthbar_Position == "Right" then
                    local H = Box_Size.Y
                    local Fill_H = H * Health_Ratio
                    Healthbar_Outline.Size = Vector2.new(3, H)
                    Healthbar_Outline.Position = Vector2.new(Box_Right + 4, Box_Top)
                    Healthbar.Size = Vector2.new(1, Fill_H)
                    Healthbar.Position = Vector2.new(Box_Right + 5, Box_Top + (H - Fill_H))
                elseif Healthbar_Position == "Top" then
                    local W = Box_Size.X
                    local Fill_W = W * Health_Ratio
                    Healthbar_Outline.Size = Vector2.new(W, 3)
                    Healthbar_Outline.Position = Vector2.new(Box_Left, Box_Top - 7)
                    Healthbar.Size = Vector2.new(Fill_W, 1)
                    Healthbar.Position = Vector2.new(Box_Left, Box_Top - 6)
                    Top_Cursor = Top_Cursor + 6
                elseif Healthbar_Position == "Bottom" then
                    local W = Box_Size.X
                    local Fill_W = W * Health_Ratio
                    Healthbar_Outline.Size = Vector2.new(W, 3)
                    Healthbar_Outline.Position = Vector2.new(Box_Left, Box_Bottom + 4)
                    Healthbar.Size = Vector2.new(Fill_W, 1)
                    Healthbar.Position = Vector2.new(Box_Left, Box_Bottom + 5)
                    Bottom_Cursor = Bottom_Cursor + 6
                end
                Healthbar.Color = Health_Lerp_Color
            end
            Healthbar.Visible = Healthbar_Enabled
            Healthbar_Outline.Visible = Healthbar_Enabled

            -- Name
            local Name_Settings = ESP.Settings.Name
            Name.Text = self.Player.Name
            Name.Color = Name_Settings.Color
            Name.OutlineColor = Name_Settings.OutlineColor
            Name.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)
            NameBold.Text = self.Player.Name
            NameBold.Color = Name_Settings.Color
            NameBold.OutlineColor = Name_Settings.OutlineColor
            NameBold.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)

            local NH = Name.TextBounds.Y * 0.5
            local NW = Name.TextBounds.X * 0.5
            local NPos = Name_Settings.Position
            if NPos == "Top" then
                Name.Position = Vector2.new(Box_Center_X, Box_Top - Top_Cursor - NH)
                Top_Cursor = Top_Cursor + Name.TextBounds.Y + 2
            elseif NPos == "Bottom" then
                Name.Position = Vector2.new(Box_Center_X, Box_Bottom + Bottom_Cursor + NH)
                Bottom_Cursor = Bottom_Cursor + Name.TextBounds.Y + 2
            elseif NPos == "Left" then
                Name.Position = Vector2.new(Box_Left - Side_Padding - NW, Box_Top + Left_Cursor + NH)
                Left_Cursor = Left_Cursor + Name.TextBounds.Y + 2
            elseif NPos == "Right" then
                Name.Position = Vector2.new(Box_Right + Side_Padding + NW, Box_Top + Right_Cursor + NH)
                Right_Cursor = Right_Cursor + Name.TextBounds.Y + 2
            end
            NameBold.Position = Name.Position + Vector2.new(1, 0)
            Name.Visible = Name_Settings.Enabled
            NameBold.Visible = Name.Visible and ESP.Settings.Bold_Text

            -- Distance
            local Distance_Settings = ESP.Settings.Distance
            Distance.Text = Meter_Distance .. "m"
            Distance.Color = Distance_Settings.Color
            Distance.OutlineColor = Distance_Settings.OutlineColor
            Distance.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)
            DistanceBold.Text = Meter_Distance .. "m"
            DistanceBold.Color = Distance_Settings.Color
            DistanceBold.OutlineColor = Distance_Settings.OutlineColor
            DistanceBold.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)

            local DH = Distance.TextBounds.Y * 0.5
            local DW = Distance.TextBounds.X * 0.5
            local DPos = Distance_Settings.Position
            if DPos == "Top" then
                Distance.Position = Vector2.new(Box_Center_X, Box_Top - Top_Cursor - DH)
                Top_Cursor = Top_Cursor + Distance.TextBounds.Y + 2
            elseif DPos == "Bottom" then
                Distance.Position = Vector2.new(Box_Center_X, Box_Bottom + Bottom_Cursor + DH)
                Bottom_Cursor = Bottom_Cursor + Distance.TextBounds.Y + 2
            elseif DPos == "Left" then
                Distance.Position = Vector2.new(Box_Left - Side_Padding - DW, Box_Top + Left_Cursor + DH)
                Left_Cursor = Left_Cursor + Distance.TextBounds.Y + 2
            elseif DPos == "Right" then
                Distance.Position = Vector2.new(Box_Right + Side_Padding + DW, Box_Top + Right_Cursor + DH)
                Right_Cursor = Right_Cursor + Distance.TextBounds.Y + 2
            end
            DistanceBold.Position = Distance.Position + Vector2.new(1, 0)
            Distance.Visible = Distance_Settings.Enabled
            DistanceBold.Visible = Distance.Visible and ESP.Settings.Bold_Text

            -- Tool
            local Tool_Settings = ESP.Settings.Tool
            local Tool_Text = ESP:Get_Tool(self.Player)
            Tool.Text = Tool_Text
            Tool.Color = Tool_Settings.Color
            Tool.OutlineColor = Tool_Settings.OutlineColor
            Tool.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)
            ToolBold.Text = Tool_Text
            ToolBold.Color = Tool_Settings.Color
            ToolBold.OutlineColor = Tool_Settings.OutlineColor
            ToolBold.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)

            local TH = Tool.TextBounds.Y * 0.5
            local TW = Tool.TextBounds.X * 0.5
            local TPos = Tool_Settings.Position
            if TPos == "Top" then
                Tool.Position = Vector2.new(Box_Center_X, Box_Top - Top_Cursor - TH)
                Top_Cursor = Top_Cursor + Tool.TextBounds.Y + 2
            elseif TPos == "Bottom" then
                Tool.Position = Vector2.new(Box_Center_X, Box_Bottom + Bottom_Cursor + TH)
                Bottom_Cursor = Bottom_Cursor + Tool.TextBounds.Y + 2
            elseif TPos == "Left" then
                Tool.Position = Vector2.new(Box_Left - Side_Padding - TW, Box_Top + Left_Cursor + TH)
                Left_Cursor = Left_Cursor + Tool.TextBounds.Y + 2
            elseif TPos == "Right" then
                Tool.Position = Vector2.new(Box_Right + Side_Padding + TW, Box_Top + Right_Cursor + TH)
                Right_Cursor = Right_Cursor + Tool.TextBounds.Y + 2
            end
            ToolBold.Position = Tool.Position + Vector2.new(1, 0)
            Tool.Visible = Tool_Settings.Enabled
            ToolBold.Visible = Tool.Visible and ESP.Settings.Bold_Text

            -- Health
            local Health_Settings = ESP.Settings.Health
            local Health_Text = tostring(math.floor(Current_Health + 0.5))
            Health.Text = Health_Text
            Health.Color = Health_Lerp_Color
            Health.OutlineColor = Health_Settings.OutlineColor
            Health.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)
            HealthBold.Text = Health_Text
            HealthBold.Color = Health_Lerp_Color
            HealthBold.OutlineColor = Health_Settings.OutlineColor
            HealthBold.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)

            local HH = Health.TextBounds.Y * 0.5
            local HW = Health.TextBounds.X * 0.5
            local HPos = Health_Settings.Position
            if HPos == "Top" then
                Health.Position = Vector2.new(Box_Center_X, Box_Top - Top_Cursor - HH)
                Top_Cursor = Top_Cursor + Health.TextBounds.Y + 2
            elseif HPos == "Bottom" then
                Health.Position = Vector2.new(Box_Center_X, Box_Bottom + Bottom_Cursor + HH)
                Bottom_Cursor = Bottom_Cursor + Health.TextBounds.Y + 2
            elseif HPos == "Left" then
                Health.Position = Vector2.new(Box_Left - Side_Padding - HW, Box_Top + Left_Cursor + HH)
                Left_Cursor = Left_Cursor + Health.TextBounds.Y + 2
            elseif HPos == "Right" then
                Health.Position = Vector2.new(Box_Right + Side_Padding + HW, Box_Top + Right_Cursor + HH)
                Right_Cursor = Right_Cursor + Health.TextBounds.Y + 2
            end
            HealthBold.Position = Health.Position + Vector2.new(1, 0)
            Health.Visible = Health_Settings.Enabled
            HealthBold.Visible = Health.Visible and ESP.Settings.Bold_Text

            -- Skeleton
            local Skeleton_Settings = ESP.Settings.Skeleton
            local Skeleton_Lines = Components.Skeleton

            if Skeleton_Lines and Skeleton_Settings.Enabled then
                for i, Line in pairs(Skeleton_Lines) do
                    local Conn = Skeleton.ViewModel[i]
                    if Conn then
                        local A = Viewmodel:FindFirstChild(Conn[1])
                        local B = Viewmodel:FindFirstChild(Conn[3])
                        if A and B and A:IsA("BasePart") and B:IsA("BasePart") then
                            local PosA = (A.CFrame * CFrame.new(Conn[2])).Position
                            local PosB = (B.CFrame * CFrame.new(Conn[4])).Position
                            local VA, OA = Camera:WorldToViewportPoint(PosA)
                            local VB, OB = Camera:WorldToViewportPoint(PosB)
                            if OA and OB then
                                Line.From = Vector2.new(VA.X, VA.Y)
                                Line.To = Vector2.new(VB.X, VB.Y)
                                Line.Color = Skeleton_Settings.Color
                                Line.Transparency = Framework:Drawing_Transparency(Skeleton_Settings.Transparency)
                                Line.Thickness = Skeleton_Settings.Thickness
                                Line.Visible = true
                            else
                                Line.Visible = false
                            end
                        else
                            Line.Visible = false
                        end
                    else
                        Line.Visible = false
                    end
                end
            else
                if Skeleton_Lines then
                    for _, Line in pairs(Skeleton_Lines) do
                        Line.Color = Skeleton_Settings.Color
                        Line.Visible = false
                    end
                end
            end
        else
            ESP:Hide_All(Components)
            return
        end
    end
end

do -- ESP Functions
    function ESP:Player(Instance, Data)
        if Instance == nil then
            return warn("error: function ESP.Player argument #1 expected Player, got nil")
        end
        if Data == nil or type(Data) ~= "table" then
            Data = {
                Player = Instance
            }
        end
        local Object = setmetatable({
            Player = Data.Player or Data.player or Data.Plr or Data.plr or Data.Ply or Data.ply or Instance,
            Components = {},
            Type = "Player"
        }, Player_Metatable)
        if self:GetObject(Instance) then
            self:GetObject(Instance):Destroy()
        end
        local Components = Object.Components
        Components.Box = Framework:Draw("Square", {Thickness = 1, ZIndex = 2})
        Components.Box_Outline = Framework:Draw("Square", {Thickness = 3, ZIndex = 1})
        Components.Healthbar = Framework:Draw("Square", {Thickness = 1, ZIndex = 2, Filled = true})
        Components.Healthbar_Outline = Framework:Draw("Square", {Thickness = 3, ZIndex = 1, Filled = true})
        Components.Name = Framework:Draw("Text", {Text = Instance.Name, Font = 2, Size = 13, Outline = true, Center = true})
        Components.NameBold = Framework:Draw("Text", {Text = Instance.Name, Font = 2, Size = 13, Center = true})
        Components.Distance = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.DistanceBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Tool = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.ToolBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Health = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.HealthBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Image = Framework:Draw("Image", {Data = Images[ESP.Current_Image]})
        Components.Skeleton = {}
        for i = 1, Skeleton_Max do
            Components.Skeleton[i] = Framework:Draw("Line", {Thickness = 1, Transparency = 0})
        end
        self.Objects[Instance] = Object
        return Object
    end
end

do -- Skeleton
    local V3 = Vector3.new
    Skeleton = {
        ViewModel = {
            {"torso",     V3(0, 0, 0), "head",      V3(0, 0, 0)},
            {"torso",     V3(0, 0, 0), "shoulder1", V3(0, 0, 0)},
            {"shoulder1", V3(0, 0, 0), "arm1",      V3(0, 0, 0)},
            {"torso",     V3(0, 0, 0), "shoulder2", V3(0, 0, 0)},
            {"shoulder2", V3(0, 0, 0), "arm2",      V3(0, 0, 0)},
            {"torso",     V3(0, 0, 0), "hip1",      V3(0, 0, 0)},
            {"hip1",      V3(0, 0, 0), "leg1",      V3(0, 0, 0)},
            {"torso",     V3(0, 0, 0), "hip2",      V3(0, 0, 0)},
            {"hip2",      V3(0, 0, 0), "leg2",      V3(0, 0, 0)},
        },
    }
    Skeleton_Max = #Skeleton.ViewModel
end

do -- Viewmodels Tracking
    local function Setup_Folder(Folder)
        if not Folder then return end
        for _, Child in pairs(Folder:GetChildren()) do
            if Child:IsA("Model") then
                ESP:Link_Viewmodel(Child)
            end
        end
        table.insert(ESP.Connections, Folder.ChildAdded:Connect(function(Child)
            if Child:IsA("Model") then ESP:Link_Viewmodel(Child) end
        end))
        table.insert(ESP.Connections, Folder.ChildRemoved:Connect(function(Child)
            ESP:Unlink_Viewmodel(Child)
        end))
    end

    local Viewmodels_Folder = Workspace:FindFirstChild("Viewmodels")
    if Viewmodels_Folder then
        Setup_Folder(Viewmodels_Folder)
    end

    table.insert(ESP.Connections, Workspace.ChildAdded:Connect(function(Child)
        if Child.Name == "Viewmodels" then
            Setup_Folder(Child)
        end
    end))

    for _, Player in pairs(Players:GetPlayers()) do
        table.insert(ESP.Connections, Player.CharacterAdded:Connect(function()
            playerViewmodels[Player] = nil
        end))
    end

    table.insert(ESP.Connections, Players.PlayerAdded:Connect(function(Player)
        table.insert(ESP.Connections, Player.CharacterAdded:Connect(function()
            playerViewmodels[Player] = nil
        end))
    end))

    table.insert(ESP.Connections, Players.PlayerRemoving:Connect(function(Player)
        playerViewmodels[Player] = nil
    end))
end

do -- Auto Tracking
    local function Track(Player)
        if ESP:GetObject(Player) then return end
        ESP:Player(Player)
    end
    for _, Player in pairs(Players:GetPlayers()) do
        Track(Player)
    end
    table.insert(ESP.Connections, Players.PlayerAdded:Connect(Track))
    table.insert(ESP.Connections, Players.PlayerRemoving:Connect(function(Player)
        local Object = ESP:GetObject(Player)
        if Object then
            Object:Destroy()
        end
        playerViewmodels[Player] = nil
    end))
end

table.insert(ESP.Connections, RunService.RenderStepped:Connect(function()
    local Wanted = ESP.Settings.Image.Image
    if ESP.Current_Image ~= Wanted then
        ESP.Current_Image = Wanted
        local Data = Images[Wanted]
        if Data then
            for _, Object in pairs(ESP.Objects) do
                local Image = Object.Components.Image
                if Image then
                    Image.Data = Data
                end
            end
        end
    end

    if not ESP._Last_Colors then
        ESP._Last_Colors = {
            Skeleton = ESP.Settings.Skeleton.Color,
            Box = ESP.Settings.Box.Color,
            Box_Outline = ESP.Settings.Box_Outline.Color,
            Name = ESP.Settings.Name.Color,
            Distance = ESP.Settings.Distance.Color,
            Tool = ESP.Settings.Tool.Color,
        }
    end

    local LC = ESP._Last_Colors
    local S = ESP.Settings
    if LC.Skeleton ~= S.Skeleton.Color then
        LC.Skeleton = S.Skeleton.Color
        for _, Object in pairs(ESP.Objects) do
            local Skel = Object.Components.Skeleton
            if Skel then
                for _, Line in pairs(Skel) do
                    Line.Color = LC.Skeleton
                end
            end
        end
    end
    if LC.Box ~= S.Box.Color then
        LC.Box = S.Box.Color
        for _, Object in pairs(ESP.Objects) do
            if Object.Components.Box then Object.Components.Box.Color = LC.Box end
        end
    end
    if LC.Box_Outline ~= S.Box_Outline.Color then
        LC.Box_Outline = S.Box_Outline.Color
        for _, Object in pairs(ESP.Objects) do
            if Object.Components.Box_Outline then Object.Components.Box_Outline.Color = LC.Box_Outline end
        end
    end
    if LC.Name ~= S.Name.Color then
        LC.Name = S.Name.Color
        for _, Object in pairs(ESP.Objects) do
            if Object.Components.Name then Object.Components.Name.Color = LC.Name end
            if Object.Components.NameBold then Object.Components.NameBold.Color = LC.Name end
        end
    end
    if LC.Distance ~= S.Distance.Color then
        LC.Distance = S.Distance.Color
        for _, Object in pairs(ESP.Objects) do
            if Object.Components.Distance then Object.Components.Distance.Color = LC.Distance end
            if Object.Components.DistanceBold then Object.Components.DistanceBold.Color = LC.Distance end
        end
    end
    if LC.Tool ~= S.Tool.Color then
        LC.Tool = S.Tool.Color
        for _, Object in pairs(ESP.Objects) do
            if Object.Components.Tool then Object.Components.Tool.Color = LC.Tool end
            if Object.Components.ToolBold then Object.Components.ToolBold.Color = LC.Tool end
        end
    end

    local Viewmodels_Folder = Workspace:FindFirstChild("Viewmodels")
    if Viewmodels_Folder then
        for _, Child in pairs(Viewmodels_Folder:GetChildren()) do
            if Child:IsA("Model") and Child.Name ~= "LocalViewmodel" then
                local Linked = false
                for _, VM in pairs(playerViewmodels) do
                    if VM == Child then
                        Linked = true
                        break
                    end
                end
                if not Linked then
                    ESP:Link_Viewmodel(Child)
                end
            end
        end
    end

    for _, Player in pairs(Players:GetPlayers()) do
        if not playerViewmodels[Player] then
            local Character = ESP:Get_Character(Player)
            if Character then
                for _, Child in pairs(Workspace:GetChildren()) do
                    if Child:IsA("Model") and Child.Name == Character.Name then
                        local Torso = Child:FindFirstChild("torso")
                        if Torso then
                            playerViewmodels[Player] = Child
                            break
                        end
                    end
                end
            end
        end
    end

    for _, Object in pairs(ESP.Objects) do
        Object:Update()
    end
end))