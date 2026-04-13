-- [[ CONFIGURATION ]]
local FirebaseURL = "https://xyphos-project-default-rtdb.europe-west1.firebasedatabase.app/Keys"
local PastebinRaw = "https://pastebin.com/raw/vH8SvF1r" -- Ton nouveau lien

-- [[ INTERFACE DE LOGIN ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "XyphosAuth"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, -160, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8) -- CORRIGÉ (pas de Tool.new)

local TextBox = Instance.new("TextBox", Main)
TextBox.Size = UDim2.new(0.8, 0, 0, 35)
TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
TextBox.PlaceholderText = "Entre ta clé..."
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TextBox)

local VerifyBtn = Instance.new("TextButton", Main)
VerifyBtn.Size = UDim2.new(0.8, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyBtn.Text = "VÉRIFIER"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 250)
VerifyBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", VerifyBtn)

-- [[ LOGIQUE ]]
VerifyBtn.MouseButton1Click:Connect(function()
    local key = TextBox.Text:gsub("%s+", "")
    
    -- Vérification Firebase
    local success, response = pcall(function()
        return game:HttpGet(FirebaseURL .. "/" .. key .. ".json")
    end)

    if success and response ~= "null" then
        VerifyBtn.Text = "ACCÈS ACCORDÉ !"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        task.wait(1)
        ScreenGui:Destroy()
        
        -- Chargement du script depuis ton Pastebin
        loadstring(game:HttpGet(PastebinRaw))()
    else
        VerifyBtn.Text = "CLÉ INVALIDE"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    end
end)