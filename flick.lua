flick_section:AddToggle("Distance Warnings", function(state)
    notificationSettings.distanceWarning = state
end)

flick_section:AddToggle("Method Changes", function(state)
    notificationSettings.methodChange = state
end)

flick_section:AddToggle("Key Changes", function(state)
    notificationSettings.keyChange = state
end)

flick_section:AddToggle("Speed Changes", function(state)
    notificationSettings.speedChange = state
end)

flick_section:AddToggle("Toggle Notifications", function(state)
    notificationSettings.toggles = state
end)

flick_section:AddLabel("?? Advanced Features")

flick_section:AddToggle("Show Tracers", function(state)
    showTracers = state
    if not state and tracer then
        tracer:Destroy()
        tracer = nil
    end
    conditionalNotify("toggles", state and "? Tracers ON" or "? Tracers OFF", 2)
end)

local function handleInput(input)
    if not flickEnabled or isFlicking then return end
    
    if inputType == "Keyboard" then
        local keyName = selectedInput
        
        local specialKeys = {
            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
            ["LeftShift"] = Enum.KeyCode.LeftShift,
            ["LeftControl"] = Enum.KeyCode.LeftControl,
            ["LeftAlt"] = Enum.KeyCode.LeftAlt,
            ["One"] = Enum.KeyCode.One,
            ["Two"] = Enum.KeyCode.Two,
            ["Three"] = Enum.KeyCode.Three,
            ["Four"] = Enum.KeyCode.Four,
            ["Five"] = Enum.KeyCode.Five,
            ["Insert"] = Enum.KeyCode.Insert,
            ["Delete"] = Enum.KeyCode.Delete,
            ["Home"] = Enum.KeyCode.Home,
            ["End"] = Enum.KeyCode.End,
            ["PageUp"] = Enum.KeyCode.PageUp,
            ["PageDown"] = Enum.KeyCode.PageDown
        }
        
        local targetKey
        if specialKeys[keyName] then
            targetKey = specialKeys[keyName]
        elseif keyName:sub(1, 1) == "F" and tonumber(keyName:sub(2)) then
            targetKey = Enum.KeyCode["F" .. keyName:sub(2)]
        else
            targetKey = Enum.KeyCode[keyName]
        end
        
        if input.KeyCode == targetKey then
            performFlick()
        end
    elseif inputType == "Mouse" then
        local mouseMap = {
            ["Left Click"] = Enum.UserInputType.MouseButton1,
            ["Right Click"] = Enum.UserInputType.MouseButton2,
            ["Middle Click"] = Enum.UserInputType.MouseButton3,
            ["Mouse4"] = Enum.UserInputType.MouseButton4,
            ["Mouse5"] = Enum.UserInputType.MouseButton5
        }
        
        if input.UserInputType == mouseMap[selectedInput] then
            performFlick()
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    handleInput(input)
end)

flick_section:AddToggle("Mobile Button", function(state)
    if state then
        if mobileButton then mobileButton:Destroy() end
        
        local gui = Instance.new("ScreenGui")
        gui.Name = "FlickMobileGUI"
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local button = Instance.new("TextButton")
        button.Name = "FlickButton"
        button.Text = "??"
        button.Font = Enum.Font.SourceSansBold
        button.TextScaled = true
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        button.BorderSizePixel = 3
        button.BorderColor3 = Color3.fromRGB(0, 0, 0)
        button.Size = UDim2.new(0, 60, 0, 60)
        button.Position = UDim2.new(0.85, 0, 0.5, 0)
        button.Active = true
        button.Draggable = true
        button.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = button
        
        button.MouseButton1Down:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            button.Size = UDim2.new(0, 55, 0, 55)
        end)
        
        button.MouseButton1Up:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            button.Size = UDim2.new(0, 60, 0, 60)
            performFlick()
        end)
        
        mobileButton = gui
    else
        if mobileButton then
            mobileButton:Destroy()
            mobileButton = nil
        end
    end
end)

flick_section:AddLabel("")
flick_section:AddLabel("?? FINAL FIX v4.9:")
flick_section:AddLabel("• Mobile: Only tool:Activate(), no VirtualInputManager")
flick_section:AddLabel("• PC: VirtualInputManager + tool:Activate()")
flick_section:AddLabel("• Joystick stays visible when shooting!")

notify("? Flick-to-Murderer v4.9 Loaded!", 3)
notify("?? Mobile shooting FIX applied!", 4)
print("=====================================")
print("Flick-to-Murderer Plugin v4.9")
print("THE REAL FINAL FIX - Shooting method")
print("- Mobile: Only tool:Activate()")
print("- PC: VirtualInputManager + tool:Activate()")
print("- No more joystick disappearing on shoot!")
print("=====================================")

return function()
    if mobileButton then mobileButton:Destroy() end
    if tracer then tracer:Destroy() end
    cleanup()
    if wasShiftLockEnabled then
        restoreShiftLock()
    end
end
