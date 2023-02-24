local game = {}

game.screenScale = 2
game.screenSize = createRect(0, 0, 704, 352)

function game.loadGameData()
    player = require("player")
    boss = require("boss")
    map = require("map")
    map.createMap()
    
    collisions = require("collisions")

    love.window.setMode(game.screenSize.w * game.screenScale, 
    game.screenSize.h * game.screenScale)
end

function game.updateStartState(dt)    
    if love.keyboard.isDown("space") then
        
    end
end

function game.drawStartState()
    
end

function game.updateGameState(dt)
    player.update(dt)
    boss.update(dt)
    map.update(dt)
   
    collisions.resolve(player, boss, map, dt)
end

function game.drawGameState()
    map.draw()
    player.draw()
    boss.draw()
end

return game 