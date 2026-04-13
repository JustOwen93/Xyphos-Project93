-- [[ CONFIGURATION ]]
local FirebaseURL = "https://xyphos-project-default-rtdb.europe-west1.firebasedatabase.app/Keys"
local MyHubScript = "https://pastebin.com/raw/vH8SvF1r" -- Ton lien Pastebin RAW

-- [[ INTERFACE DE LOGIN ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XyphosAuth"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, -160, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Correction : Utilisation de UDim.new (L'erreur Tool.new est supprimée)
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XYPHOS PROJECT — LOGIN"
Title.TextColor3 = Color3.fromRGB(167, 139, 250)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local TextBox = Instance.new("TextBox", Main)
TextBox.Size = UDim2.new(0.8, 0, 0, 35)
TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
TextBox.PlaceholderText = "Entre ta clé ici..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.ClearTextOnFocus = false
Instance.new("UICorner", TextBox)

local VerifyBtn = Instance.new("TextButton", Main)
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyBtn.Text = "VÉRIFIER"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", VerifyBtn)

-- [[ LOGIQUE DE VÉRIFICATION ]]
VerifyBtn.MouseButton1Click:Connect(function()
    local key = TextBox.Text:gsub("%s+", "") -- Enlève les espaces

    if key == "" then 
        VerifyBtn.Text = "CHAMP VIDE !"
        task.wait(1)
        VerifyBtn.Text = "VÉRIFIER"
        return 
    end

    VerifyBtn.Text = "VÉRIFICATION..."

    -- Requête à Firebase
    local success, response = pcall(function()
        return game:HttpGet(FirebaseURL .. "/" .. key .. ".json")
    end)

    if success and response ~= "null" then
        VerifyBtn.Text = "ACCÈS ACCORDÉ !"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        task.wait(1)
        
        ScreenGui:Destroy() -- On ferme le login
        
        -- CHARGEMENT DU HUB (PASTEBIN)
        local loadSuccess, err = pcall(function()
            loadstring(game:HttpGet(MyHubScript))()
        end)
        
        if not loadSuccess then
            warn("Erreur chargement Hub: " .. tostring(err))
        end
    else
        VerifyBtn.Text = "CLÉ INVALIDE !"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        task.wait(1.5)
        VerifyBtn.Text = "VÉRIFIER"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
    end
end)
