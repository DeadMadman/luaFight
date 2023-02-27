require("scripts/utility")

local screenScale = 2
screenSize = createRect(0, 0, 704, 352)

function love.load()
    audio = require("scripts/audio")
    audio.load()
    player = require("scripts/player")
    boss = require("scripts/boss")
    map = require("scripts/map")
    map.createMap()
    
    collisions = require("scripts/collisions")
    love.window.setMode(screenSize.w * screenScale, screenSize.h * screenScale)
end

function love.update(dt)
    audio.update()
    player.update(dt, map.collidableTiles)
    boss.update(dt)
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
