require("utility")
require("player")

function love.load()
    playerTable = createPlayer()
     
    floorY = 200;

    gravity = createVec2(0, 100)
    canJump = false

    screenSize = createRect(0, 0, 500, 500)

    love.window.setMode(screenSize.w, screenSize.h)
end


function love.update(dt)
    local dVec2 = createVec2(0, 0)
    dVec2 = updateInput(dVec2)
    
    if playerTable.rect.y < floorY then
        playerTable.move(gravity, dt)
    else
        canJump = true
    end

    playerTable.move(dVec2, dt)
end

function love.draw()
    love.graphics.rectangle("fill", playerTable.rect.x, playerTable.rect.y, playerTable.rect.w, playerTable.rect.h)
    love.graphics.draw(playerTable.sprite, playerTable.rect.x, playerTable.rect.y, 0, 1, 1, 20, 10)
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "w" or "up" or "space" then
        jump()
    elseif scancode == "escape" then
        love.event.quit()
    end
 end

 function jump()
    if canJump then
        playerTable.move(createVec2(0, playerTable.speed.y), love.timer.getDelta())
    end
 end

 
 function updateInput(dVec2)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dVec2.x = playerTable.speed.x
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dVec2.x = -playerTable.speed.x
    end
    return dVec2
 end

