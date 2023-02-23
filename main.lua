require("utility")

screenScale = 2
screenSize = createRect(0, 0, 704, 352)
gravity = createVec(0, 300)

function love.load()
    player = require("player")
    
    map = require("map")
    map.createMap()
    
    collisions = require("collisions")

    love.window.setMode(screenSize.w * screenScale, screenSize.h * screenScale)
end

function love.update(dt)
    player.update(dt)
    map.update(dt)
    player.bullets.update(dt)
    collisions.resolve(player, map, player.bullets, dt)
end

function love.draw()
    love.graphics.scale(screenScale)

    player.draw()
    map.draw()
    player.bullets.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit()
    end
end


