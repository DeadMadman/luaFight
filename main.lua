require("utility")

function love.load()
    player = require("player")
     
    floorY = 200;

    gravity = createVec(0, 100)
    canJump = false

    screenSize = createRect(0, 0, 500, 500)

    love.window.setMode(screenSize.w, screenSize.h)
end

function love.update(dt)
    player.update(dt)
end

function love.draw()
    player.draw()
    end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "w" or "up" or "space" then
        player.runJump = true
    elseif scancode == "escape" then
        love.event.quit()
    end
end


