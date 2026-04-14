-- [[ CONFIGURATION ]]
local FirebaseURL = "https://xyphos-project-default-rtdb.europe-west1.firebasedatabase.app/Keys"
local MyHubScript = "https://pastebin.com/raw/vH8SvF1r" -- Ton lien Pastebin RAW vers xyphohub.lua

-- [[ INTERFACE DE LOGIN ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XyphosAuth"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 180)
Main.Position = UDim2.new(0.5, -160, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XYPHOS PROJECT — AUTH"
Title.TextColor3 = Color3.fromRGB(167, 139, 250)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local TextBox = Instance.new("TextBox", Main)
TextBox.Size = UDim2.new(0, 260, 0, 40)
TextBox.Position = UDim2.new(0.5, -130, 0.4, 0)
TextBox.PlaceholderText = "Entrez votre clé ici..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Font = Enum.Font.Gotham
Instance.new("UICorner", TextBox)

local VerifyBtn = Instance.new("TextButton", Main)
VerifyBtn.Size = UDim2.new(0, 260, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, -130, 0.7, 5)
VerifyBtn.Text = "VÉRIFIER"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
VerifyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", VerifyBtn)

-- [[ LOGIQUE DE VÉRIFICATION AVEC TEMPS ]]
VerifyBtn.MouseButton1Click:Connect(function()
    local key = TextBox.Text:gsub("%s+", "") -- Nettoyage des espaces

    if key == "" then 
        VerifyBtn.Text = "CHAMP VIDE !"
        task.wait(1)
        VerifyBtn.Text = "VÉRIFIER"
        return 
    end

    VerifyBtn.Text = "VÉRIFICATION EN COURS..."

    -- Requête à Firebase
    local success, response = pcall(function()
        return game:HttpGet(FirebaseURL .. "/" .. key .. ".json")
    end)

    if success and response ~= "null" then
        local data = game:GetService("HttpService"):JSONDecode(response)
        local currentTime = os.time()
        
        -- On vérifie si la clé est expirée
        -- data.expires == 0 signifie "Lifetime"
        if data.expires == 0 or currentTime < data.expires then
            VerifyBtn.Text = "ACCÈS ACCORDÉ !"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
            task.wait(1)
            
            ScreenGui:Destroy() -- Ferme le menu de login
            
            -- CHARGEMENT DU HUB PRINCIPAL
            local loadSuccess, err = pcall(function()
                loadstring(game:HttpGet(MyHubScript))()
            end)
            
            if not loadSuccess then
                warn("Erreur de chargement du Hub: " .. tostring(err))
            end
        else
            -- La clé existe mais le temps est écoulé
            VerifyBtn.Text = "CLÉ EXPIRÉE !"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
            task.wait(2)
            VerifyBtn.Text = "VÉRIFIER"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
        end
    else
        -- La clé n'existe pas du tout
        VerifyBtn.Text = "CLÉ INVALIDE !"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        task.wait(2)
        VerifyBtn.Text = "VÉRIFIER"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
    end
end)
