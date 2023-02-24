require("utility")

function love.load()
    game = require("game")
    game.loadGameData()
end

function love.update(dt)
    game.updateGameState(dt)
end

function love.draw()
    love.graphics.scale(game.screenScale)
    --drawStartState()
    game.drawGameState()
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit()
    end
end
