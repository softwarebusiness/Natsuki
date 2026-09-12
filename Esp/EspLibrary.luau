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
    function Framework:V3_To_V2(V3)
        return Vector2.new(V3.X, V3.Y)
    end
    function Framework:Draw(Object, Properties)
        Object = Drawing.new(Object)
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
        return Object
    end
    function Framework:Get_Bounding_Vectors(Part)
        local Part_CFrame, Part_Size = Part.CFrame, Part.Size 
        local X, Y, Z = Part_Size.X, Part_Size.Y, Part_Size.Z
        return {
            TBRC = Part_CFrame * CFrame.new(X, Y * 1.3, Z),
            TBLC = Part_CFrame * CFrame.new(-X, Y * 1.3, Z),
            TFRC = Part_CFrame * CFrame.new(X, Y * 1.3, -Z),
            TFLC = Part_CFrame * CFrame.new(-X, Y * 1.3, -Z),
            BBRC = Part_CFrame * CFrame.new(X, -Y * 1.6, Z),
            BBLC = Part_CFrame * CFrame.new(-X, -Y * 1.6, Z),
            BFRC = Part_CFrame * CFrame.new(X, -Y * 1.6, -Z),
            BFLC = Part_CFrame * CFrame.new(-X, -Y * 1.6, -Z),
        };
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
    getgenv().ESP = nil
end

function ESP:Get_Team(Player)
    if self.Overrides.Get_Team ~= nil then
        return self.Overrides.Get_Team(Player)
    end
    return Player.Team
end

function ESP:Get_Character(Player)
    if ESP.Overrides.Get_Character ~= nil then
        return ESP.Overrides.Get_Character(Player)
    end
    return Player.Character
end

function ESP:Get_Tool(Player)
    if self.Overrides.Get_Tool ~= nil then
        return self.Overrides.Get_Tool(Player)
    end
    local Character = self:Get_Character(Player)
    if Character then
        local Tool = Character:FindFirstChildOfClass("Tool")
        if Tool then
            return Tool.Name
        end
    end
    return "Nothing"
end

function ESP:Get_Health(Player)
    if self.Overrides.Get_Character ~= nil then
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

        local Character = ESP:Get_Character(self.Player)

        if Character ~= nil and Character == Players.LocalPlayer.Character and not ESP.Settings.Self_Esp then
            ESP:HideAll(Components)
            return
        end

        if Character == nil then
            ESP:HideAll(Components)
            return
        end

        local Head, HumanoidRootPart, Humanoid = Character:FindFirstChild("Head"), Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChildOfClass("Humanoid")
        if not (Head and HumanoidRootPart and Humanoid) then
            ESP:HideAll(Components)
            return
        end

        local Current_Health, Health_Maximum = ESP:Get_Health(self.Player), Humanoid.MaxHealth
        if Current_Health <= 0 then
            ESP:HideAll(Components)
            return
        end

        local Dimensions = Framework:Get_Bounding_Vectors(HumanoidRootPart)
        local HRP_Position, On_Screen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
        local Stud_Distance, Meter_Distance = math.floor(HRP_Position.Z + 0.5), math.floor(HRP_Position.Z / 3.5714285714 + 0.5)

        local Y_Minimal, Y_Maximal = Camera.ViewportSize.X, 0
        local X_Minimal, X_Maximal = Camera.ViewportSize.X, 0

        for _, CF in pairs(Dimensions) do
            local Vector = Camera:WorldToViewportPoint(CF.Position)
            local X, Y = Vector.X, Vector.Y
            if X < X_Minimal then X_Minimal = X end
            if X > X_Maximal then X_Maximal = X end
            if Y < Y_Minimal then Y_Minimal = Y end
            if Y > Y_Maximal then Y_Maximal = Y end
        end

        local Box_Size = Framework:Round_V2(Vector2.new(X_Minimal - X_Maximal, Y_Minimal - Y_Maximal))
        local Box_Position = Framework:Round_V2(Vector2.new(X_Maximal + Box_Size.X / X_Minimal, Y_Maximal + Box_Size.Y / Y_Minimal))
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
            Visible = ESP:Check_Visible(Head) or ESP:Check_Visible(HumanoidRootPart)
        end

        if ESP.Settings.Enabled and On_Screen and Meter_Distance < ESP.Settings.Maximal_Distance and Good and Visible then
            local Top_Offset = 3
            local Bottom_Offset = Y_Maximal + 1
            local Left_Offset = 0
            local Right_Offset = 0

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
            local Image_Enabled = Image_Settings.Enabled
            if Image_Enabled then
                Image.Size = -Box_Size
                Image.Position = Box_Position + Box_Size
            end
            Image.Visible = Image_Enabled

            -- Healthbar
            local Health_Top_Size_Outline = Vector2.new(Box_Size.X - 4, 3)
            local Health_Top_Pos_Outline = Box_Position + Vector2.new(2, Box_Size.Y - 6)
            local Health_Top_Size_Fill = Vector2.new((Current_Health * Health_Top_Size_Outline.X / Health_Maximum) + 2, 1)
            local Health_Top_Pos_Fill = Health_Top_Pos_Outline + Vector2.new(1 + -(Health_Top_Size_Fill.X - Health_Top_Size_Outline.X),1);

            local Health_Left_Size_Outline = Vector2.new(3, Box_Size.Y - 4)
            local Health_Left_Pos_Outline = Vector2.new(X_Maximal + Box_Size.X - 6, Box_Position.Y + 2)
            local Health_Left_Size_Fill = Vector2.new(1, (Current_Health * Health_Left_Size_Outline.Y / Health_Maximum) + 2)
            local Health_Left_Pos_Fill = Health_Left_Pos_Outline + Vector2.new(1,-1 + -(Health_Left_Size_Fill.Y - Health_Left_Size_Fill.Y));

            local Healthbar_Settings = ESP.Settings.Healthbar
            local Healthbar_Enabled = Healthbar_Settings.Enabled
            local Healthbar_Position = Healthbar_Settings.Position
            local Health_Lerp_Color = Healthbar_Settings.Color:Lerp(Healthbar_Settings.Color_Lerp, Current_Health / Health_Maximum)
            if Healthbar_Enabled then
                if Healthbar_Position == "Left" then
                    Healthbar.Size = Health_Left_Size_Fill;
                    Healthbar.Position = Health_Left_Pos_Fill;
                    Healthbar_Outline.Size = Health_Left_Size_Outline;
                    Healthbar_Outline.Position = Health_Left_Pos_Outline;
                elseif Healthbar_Position == "Right" then
                    Healthbar.Size = Health_Left_Size_Fill;
                    Healthbar.Position = Vector2.new(X_Maximal + Box_Size.X + 4, Box_Position.Y + 1) - Vector2.new(Box_Size.X, 0)
                    Healthbar_Outline.Size = Health_Left_Size_Outline
                    Healthbar_Outline.Position = Vector2.new(X_Maximal + Box_Size.X + 3, Box_Position.Y + 2) - Vector2.new(Box_Size.X, 0)
                elseif Healthbar_Position == "Top" then
                    Healthbar.Size = Health_Top_Size_Fill;
                    Healthbar.Position = Health_Top_Pos_Fill;
                    Healthbar_Outline.Size = Health_Top_Size_Outline;
                    Healthbar_Outline.Position = Health_Top_Pos_Outline;
                    Top_Offset = Top_Offset + 6
                elseif Healthbar_Position == "Bottom" then
                    Healthbar.Size = Health_Top_Size_Fill
                    Healthbar.Position = Health_Top_Pos_Fill - Vector2.new(0, Box_Size.Y - 9)
                    Healthbar_Outline.Size = Health_Top_Size_Outline;
                    Healthbar_Outline.Position = Health_Top_Pos_Outline - Vector2.new(0, Box_Size.Y - 9)
                    Bottom_Offset = Bottom_Offset + 6
                end
                Healthbar.Color = Health_Lerp_Color
            end
            Healthbar.Visible = Healthbar_Enabled
            Healthbar_Outline.Visible = Healthbar_Enabled

            -- Name
            local Name_Settings = ESP.Settings.Name
            local Name_Position = Name_Settings.Position
            if Name_Position == "Top" then 
                Name.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Name.TextBounds.Y - Box_Size.Y + Top_Offset) 
                Top_Offset = Top_Offset + 10
            elseif Name_Position == "Bottom" then
                Name.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                Bottom_Offset = Bottom_Offset + 10
            elseif Name_Position == "Left" then
                if Healthbar_Position == "Left" then
                    Name.Position = Health_Left_Pos_Outline - Vector2.new(Name.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                else
                    Name.Position = Health_Left_Pos_Outline - Vector2.new(Name.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                end
                Left_Offset = Left_Offset + 10
            elseif Name_Position == "Right" then
                if Healthbar_Position == "Right" then
                    Name.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Name.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                else
                    Name.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Name.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                end
                Right_Offset = Right_Offset + 10
            end
            Name.Color = Name_Settings.Color
            Name.OutlineColor = Name_Settings.OutlineColor
            Name.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)
            Name.Visible = Name_Settings.Enabled
            NameBold.Color = Name_Settings.Color
            NameBold.OutlineColor = Name_Settings.OutlineColor
            NameBold.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)
            NameBold.Position = Name.Position + Vector2.new(1, 0)
            NameBold.Visible = Name.Visible and ESP.Settings.Bold_Text

            -- Distance
            local Distance_Settings = ESP.Settings.Distance
            local Distance_Position = Distance_Settings.Position
            if Distance_Position == "Top" then 
                Distance.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Distance.TextBounds.Y - Box_Size.Y + Top_Offset) 
                Top_Offset = Top_Offset + 10
            elseif Distance_Position == "Bottom" then
                Distance.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                Bottom_Offset = Bottom_Offset + 10
            elseif Distance_Position == "Left" then
                if Healthbar_Position == "Left" then
                    Distance.Position = Health_Left_Pos_Outline - Vector2.new(Distance.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                else
                    Distance.Position = Health_Left_Pos_Outline - Vector2.new(Distance.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                end
                Left_Offset = Left_Offset + 10
            elseif Distance_Position == "Right" then
                if Healthbar_Position == "Right" then
                    Distance.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Distance.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                else
                    Distance.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Distance.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                end
                Right_Offset = Right_Offset + 10
            end
            Distance.Text = Meter_Distance.."m"
            Distance.Color = Distance_Settings.Color
            Distance.OutlineColor = Distance_Settings.OutlineColor
            Distance.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)
            Distance.Visible = Distance_Settings.Enabled
            DistanceBold.Text = Meter_Distance.."m"
            DistanceBold.Color = Distance_Settings.Color
            DistanceBold.OutlineColor = Distance_Settings.OutlineColor
            DistanceBold.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)
            DistanceBold.Position = Distance.Position + Vector2.new(1, 0)
            DistanceBold.Visible = Distance.Visible and ESP.Settings.Bold_Text

            -- Tool
            local Tool_Settings = ESP.Settings.Tool
            local Tool_Position = Tool_Settings.Position
            if Tool_Position == "Top" then 
                Tool.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Tool.TextBounds.Y - Box_Size.Y + Top_Offset) 
                Top_Offset = Top_Offset + 10
            elseif Tool_Position == "Bottom" then
                Tool.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                Bottom_Offset = Bottom_Offset + 10
            elseif Tool_Position == "Left" then
                if Healthbar_Position == "Left" then
                    Tool.Position = Health_Left_Pos_Outline - Vector2.new(Tool.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                else
                    Tool.Position = Health_Left_Pos_Outline - Vector2.new(Tool.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                end
                Left_Offset = Left_Offset + 10
            elseif Tool_Position == "Right" then
                if Healthbar_Position == "Right" then
                    Tool.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Tool.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                else
                    Tool.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Tool.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                end
                Right_Offset = Right_Offset + 10
            end
            Tool.Text = ESP:Get_Tool(self.Player)
            Tool.Color = Tool_Settings.Color
            Tool.OutlineColor = Tool_Settings.OutlineColor
            Tool.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)
            Tool.Visible = Tool_Settings.Enabled
            ToolBold.Text = ESP:Get_Tool(self.Player)
            ToolBold.Color = Tool_Settings.Color
            ToolBold.OutlineColor = Tool_Settings.OutlineColor
            ToolBold.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)
            ToolBold.Position = Tool.Position + Vector2.new(1, 0)
            ToolBold.Visible = Tool.Visible and ESP.Settings.Bold_Text

            -- Health
            local Health_Settings = ESP.Settings.Health
            local Health_Position = Health_Settings.Position
            if Health_Position == "Top" then 
                Health.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Health.TextBounds.Y - Box_Size.Y + Top_Offset) 
                Top_Offset = Top_Offset + 10
            elseif Health_Position == "Bottom" then
                Health.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                Bottom_Offset = Bottom_Offset + 10
            elseif Health_Position == "Left" then
                if Healthbar_Position == "Left" then
                    Health.Position = Health_Left_Pos_Outline - Vector2.new(Health.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                else
                    Health.Position = Health_Left_Pos_Outline - Vector2.new(Health.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                end
                Left_Offset = Left_Offset + 10
            elseif Health_Position == "Right" then
                if Healthbar_Position == "Right" then
                    Health.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Health.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                else
                    Health.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Health.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                end
                Right_Offset = Right_Offset + 10
            end
            Health.Text = tostring(math.floor(Current_Health + 0.5))
            Health.Color = Health_Lerp_Color
            Health.OutlineColor = Health_Settings.OutlineColor
            Health.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)
            Health.Visible = Health_Settings.Enabled
            HealthBold.Text = tostring(math.floor(Current_Health + 0.5))
            HealthBold.Color = Health_Lerp_Color
            HealthBold.OutlineColor = Health_Settings.OutlineColor
            HealthBold.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)
            HealthBold.Position = Health.Position + Vector2.new(1, 0)
            HealthBold.Visible = Health.Visible and ESP.Settings.Bold_Text

            -- Skeleton
            local Skeleton_Settings = ESP.Settings.Skeleton
            local Skeleton_Lines = Components.Skeleton
            local Connections = nil
            if Character:FindFirstChild("UpperTorso") then
                Connections = Skeleton.R15
            elseif Character:FindFirstChild("Torso") then
                Connections = Skeleton.R6
            end

            if Skeleton_Lines and Connections and Skeleton_Settings.Enabled then
                for i, Line in pairs(Skeleton_Lines) do
                    local Conn = Connections[i]
                    if Conn then
                        local A = Character:FindFirstChild(Conn[1])
                        local B = Character:FindFirstChild(Conn[3])
                        if A and B then
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
                        Line.Visible = false
                    end
                end
            end
        else
            ESP:HideAll(Components)
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
        R15 = {
            {"Head",         V3(0, 0, 0), "UpperTorso",     V3(0, 0, 0)},
            {"UpperTorso",   V3(0, 0, 0), "LowerTorso",     V3(0, 0, 0)},
            {"UpperTorso",   V3(0, 0, 0), "LeftUpperArm",   V3(0, 0, 0)},
            {"LeftUpperArm", V3(0, 0, 0), "LeftLowerArm",   V3(0, 0, 0)},
            {"LeftLowerArm", V3(0, 0, 0), "LeftHand",       V3(0, 0, 0)},
            {"UpperTorso",   V3(0, 0, 0), "RightUpperArm",  V3(0, 0, 0)},
            {"RightUpperArm",V3(0, 0, 0), "RightLowerArm",  V3(0, 0, 0)},
            {"RightLowerArm",V3(0, 0, 0), "RightHand",      V3(0, 0, 0)},
            {"LowerTorso",   V3(0, 0, 0), "LeftUpperLeg",   V3(0, 0, 0)},
            {"LeftUpperLeg", V3(0, 0, 0), "LeftLowerLeg",   V3(0, 0, 0)},
            {"LeftLowerLeg", V3(0, 0, 0), "LeftFoot",       V3(0, 0, 0)},
            {"LowerTorso",   V3(0, 0, 0), "RightUpperLeg",  V3(0, 0, 0)},
            {"RightUpperLeg",V3(0, 0, 0), "RightLowerLeg",  V3(0, 0, 0)},
            {"RightLowerLeg",V3(0, 0, 0), "RightFoot",      V3(0, 0, 0)},
        },
        R6 = {
            {"Head",       V3(0, -0.5, 0), "Torso",     V3(0,  1, 0)},
            {"Torso",      V3(0,  1, 0),   "Torso",     V3(0, -1, 0)},
            {"Torso",      V3(0,  0, 0),   "Left Arm",  V3(0,  1, 0)},
            {"Torso",      V3(0,  0, 0),   "Right Arm", V3(0,  1, 0)},
            {"Left Arm",   V3(0,  1, 0),   "Left Arm",  V3(0, -1, 0)},
            {"Right Arm",  V3(0,  1, 0),   "Right Arm", V3(0, -1, 0)},
            {"Torso",      V3(0, -1, 0),   "Left Leg",  V3(0,  1, 0)},
            {"Torso",      V3(0, -1, 0),   "Right Leg", V3(0,  1, 0)},
            {"Left Leg",   V3(0,  1, 0),   "Left Leg",  V3(0, -1, 0)},
            {"Right Leg",  V3(0,  1, 0),   "Right Leg", V3(0, -1, 0)},
        },
    }
    Skeleton_Max = math.max(#Skeleton.R15, #Skeleton.R6)
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

    for _, Object in pairs(ESP.Objects) do
        Object:Update()
    end
end))