require("utility")

screenSize = createRect(0, 0, 500, 500)
gravity = createVec(0, 300)
tileSize = 16

function love.load()
    
    player = require("player")
    
    tiles = require("tile")
    tiles.newTile(0, 0, tileSize, screenSize.w, 2)
    tiles.newTile(screenSize.w - tileSize, 0, tileSize, screenSize.w, 2)
    tiles.newTile(0, 0, screenSize.h, tileSize, 2)
    --tiles.newTile(0, screenSize.h - tileSize, screenSize.h, tileSize, 2)
    
    tiles.newTile(400, 400, tileSize, tileSize, 1)
    tiles.newTile(200, 400, tileSize, tileSize, 2)
    
    collisions = require("collisions")

    love.window.setMode(screenSize.w, screenSize.h)
end

function love.update(dt)
    player.update(dt)
    tiles.update(dt)
    player.bullets.update(dt)

    collisions.resolve(player, tiles, dt)
end

function love.draw()
    player.draw()
    tiles.draw()
    player.bullets.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit()
    end
end


