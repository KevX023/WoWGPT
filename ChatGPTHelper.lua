-- Tabla principal del addon
ChatGPTHelper = {
    Version = 1.0,
    frame = nil
}

-- Función para guardar mensaje
local function SaveMessage(message)
    -- Crear el mensaje con formato simple
    local messageText = message .. "\n"
    
    -- Intentar guardar en la carpeta WTF
    local file = io.open("WTF/chat_messages.txt", "a")
    if file then
        file:write(messageText)
        file:close()
        print("|cFF00FF00ChatGPT Helper:|r Mensaje guardado")
        return true
    else
        print("|cFFFF0000ChatGPT Helper:|r Error al guardar mensaje")
        return false
    end
end

-- Función para crear la interfaz principal
local function CreateMainFrame()
    -- Crear el marco principal
    local frame = CreateFrame("Frame", "ChatGPTHelperFrame", UIParent, "BasicFrameTemplateWithInset")
    ChatGPTHelper.frame = frame
    
    -- Configurar el tamaño y posición
    frame:SetSize(400, 200)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    -- Título
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -5)
    frame.title:SetText("ChatGPT Helper")
    
    -- Crear el contenedor para el texto
    local editContainer = CreateFrame("Frame", nil, frame)
    editContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -30)
    editContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 40)
    
    -- Crear caja de texto
    local editBox = CreateFrame("EditBox", "ChatGPTEditBox", editContainer)
    editBox:SetMultiLine(true)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetSize(editContainer:GetWidth(), editContainer:GetHeight())
    editBox:SetPoint("TOPLEFT", editContainer, "TOPLEFT")
    editBox:SetPoint("BOTTOMRIGHT", editContainer, "BOTTOMRIGHT")
    editBox:SetAutoFocus(false)
    editBox:EnableMouse(true)
    editBox:SetScript("OnEscapePressed", function() editBox:ClearFocus() end)
    
    -- Añadir el script para Enter
    editBox:SetScript("OnEnterPressed", function()
        local message = editBox:GetText()
        if message and message ~= "" then
            if SaveMessage(message) then
                editBox:SetText("")
                editBox:ClearFocus()
            end
        end
    end)
    
    -- Añadir fondo a la caja de texto
    local bg = editBox:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetColorTexture(0, 0, 0, 0.3)
    
    -- Guardar referencias
    frame.editBox = editBox
    
    -- Inicialmente ocultar el marco
    frame:Hide()
end

-- Registrar comandos slash
SLASH_CHATGPT1 = "/chatgpt"
SLASH_CHATGPT2 = "/cgpt"
SlashCmdList["CHATGPT"] = function(msg)
    if ChatGPTHelper.frame:IsShown() then
        ChatGPTHelper.frame:Hide()
    else
        ChatGPTHelper.frame:Show()
    end
end

-- Frame principal para eventos
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "ChatGPTHelper" then
        CreateMainFrame()
        print("|cFF00FF00ChatGPT Helper|r: Escribe /chatgpt o /cgpt para abrir la ventana")
        print("|cFF00FF00ChatGPT Helper|r: Presiona Enter para enviar el mensaje")
    end
end)