function createPlayer()
    playerTable = {}
    playerTable.sprite = love.graphics.newImage("player.png")
    playerTable.rect = createRect(100, 100, 40, 60)
    playerTable.speed  = createVec2(400, -400)

    function playerTable.move(dVec2, dt)
        local rect = playerTable.rect;
    
        rect.x = rect.x + dVec2.x * dt
        rect.y = rect.y + dVec2.y * dt
    
        rect.x = clamp(rect.x, screenSize.x, screenSize.w - rect.w)
        rect.y = clamp(rect.y, screenSize.y, screenSize.h - rect.h)
     end

     return playerTable
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