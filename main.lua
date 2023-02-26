require("utility")

screenScale = 2
screenSize = createRect(0, 0, 704, 352)

function love.load()
    audio = require("audio")
    audio.load()
    player = require("player")
    boss = require("boss")
    map = require("map")
    map.createMap()
    
    collisions = require("collisions")
    love.window.setMode(screenSize.w * screenScale, screenSize.h * screenScale)
end

function love.update(dt)
    audio.update()
    player.update(dt, map.collidableTiles)
    boss.update(dt)
    map.update(dt)
   
    collisions.resolve(player, boss, map, dt)
end

function love.draw()
    love.graphics.scale(screenScale)
    map.draw()
    player.draw()
    boss.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit()
    end
end
