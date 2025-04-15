local settings = {
    -- Settings state
    masterVolume = 1.0,
    sliderX = 400,
    sliderWidth = 200,
    isDraggingSlider = false,
    
    -- UI elements
    backButton = {
        x = 300,
        y = 500,
        width = 200,  -- Fixed width instead of scaling
        height = 50   -- Fixed height instead of scaling
    }
}

function settings.load(banner1)
    -- No longer scaling button dimensions
end

function settings.update(dt)
    -- Volume updates are now handled directly in main.lua
end

function settings.draw()
    -- Draw the same background as main menu
    love.graphics.draw(background, 0, 0, 0, 2.2, 2.2)

    -- Draw title with a custom color
    love.graphics.setFont(font1)
    love.graphics.setColor(0.2, 0.8, 0.2) -- Green color for the title
    love.graphics.print("SETTINGS", 280, 100)
    
    -- Draw volume control with a custom label
    love.graphics.setFont(font2)
    love.graphics.setColor(1, 1, 1) -- White color for the label
    love.graphics.print("Adjust Volume", 280, 250)
    
    -- Draw slider background (dark gray)
    love.graphics.setColor(0.3, 0.3, 0.3) -- Dark gray
    love.graphics.rectangle("fill", 400, 280, 200, 20) -- Moved slider down to y = 280
    
    -- Draw filled portion (custom green)
    love.graphics.setColor(0.1, 0.7, 0.1) -- Custom green
    love.graphics.rectangle("fill", 400, 280, settings.sliderWidth * settings.masterVolume, 20) -- Moved slider down to y = 280
    
    -- Draw slider handle (custom color)
    love.graphics.setColor(0.9, 0.9, 0.9) -- Light gray
    local handleX = 400 + (settings.sliderWidth * settings.masterVolume)
    love.graphics.rectangle("fill", handleX - 10, 275, 20, 30) -- Moved slider handle down to y = 275
    
    -- Draw back button with a custom color
    love.graphics.setColor(0.8, 0.2, 0.2) -- Red color for the back button
    love.graphics.rectangle("fill", settings.backButton.x, settings.backButton.y, settings.backButton.width, settings.backButton.height)
    love.graphics.setColor(1, 1, 1) -- White text
    love.graphics.setFont(font2)
    love.graphics.print("BACK", settings.backButton.x + 60, settings.backButton.y + 13)
end

function settings.mousepressed(x, y, button)
    if button == 1 then
        -- Check for slider interaction (updated y range)
        if y >= 275 and y <= 305 and x >= 390 and x <= 610 then
            settings.isDraggingSlider = true
            -- Update volume based on click position
            settings.masterVolume = math.max(0, math.min(1, (x - 400) / settings.sliderWidth))
        end
        
        -- Check for back button with more precise hitbox
        if x >= settings.backButton.x and x <= settings.backButton.x + settings.backButton.width
        and y >= settings.backButton.y and y <= settings.backButton.y + settings.backButton.height then
            return 0  -- Return to main menu
        end
    end
    return 2  -- Stay in settings
end

function settings.mousereleased(x, y, button)
    if button == 1 then
        settings.isDraggingSlider = false
    end
end

function settings.mousemoved(x, y)
    if settings.isDraggingSlider then
        -- Update volume based on drag position (updated y range)
        if y >= 275 and y <= 305 then
            settings.masterVolume = math.max(0, math.min(1, (x - 400) / settings.sliderWidth))
        end
    end
end

-- Get current volume
function settings.getVolume()
    return settings.masterVolume
end

return settings
