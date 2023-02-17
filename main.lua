require("utility")

function love.load()
    playerTable = {}
    playerTable.rect = createRect(0, 0, 0, 0)
    playerTable.sprite = createSprite("player.png")
    playerTable.speed  = createVec2(100, 100)

    floorY = 200;
    gravity = {}
    gravity = createVec2(0, 90)

    screenWidth = 300;
    screenHeight = 300;
end

function love.update(dt)

    local dVec2 = createVec2(0, 0)
    dVec2 = updateInput(dVec2)
    
    if playerTable.rect.y < floorY then
        move(gravity)
    end

    move (dVec2)
end

function love.draw()
    love.graphics.draw(player, 100 + playerTable.rect.x, 200 + playerTable.rect.y)
end

function love.keypressed( key, scancode, isrepeat )
    if scancoe == "escape" then
        love.event.quit()
    end
 end

 function move(dVec2)
    -- addbound chewck
    playerTable.rect.x = playerTable.rect.x + dVec2.x
    playerTable.rect.y = playerTable.rect.y + dVec2.y
 end

 function updateInput(dVec2)
    if love.keyboard.isDown("d") then
        dVec2.x = playerTable.speed.x
    elseif love.keyboard.isDown("a") then
        dVec2.x = -playerTable.speed.x
    elseif love.keyboard.isDown("w") then
        dVec2.y = -playerTable.speed.y
    end
    return dVec2
 end

 function bounds(dVec2)
    if dVec2.x < 0 or dVec2.x > screenWidth or dVec2.y < 0 or dVec2.y > screenHeight then
        return false
    end
    return true
 end