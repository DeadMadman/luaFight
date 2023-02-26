
function createHealth(hp)
    local health = {}
    
    health.hp = hp
    health.blinkTimer = 0
    health.inBlink = false
    health.isDead = false

    function health.blink(dt)
        health.blinkTimer = health.blinkTimer + dt
        if health.blinkTimer >= 0.1 then
            health.inBlink = false
            health.blinkTimer = 0
        end
    end
    function health.update(dt)
        if health.isDead then
            if love.keyboard.isDown("space") then
                love.event.quit('restart')
            end
            return false
        end
        if health.inBlink then
            health.blink(dt)
        end
        return true
    end

    function health.setBlinkColor()
        if health.inBlink then
            love.graphics.setColor(1, 1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    function health.resetBlinkColor()
        love.graphics.setColor(1, 1, 1, 1)
    end

    function health.reduceHealth()
        if not health.inBlink then
            health.inBlink = true
            health.hp = health.hp - 1
            if health.hp <= 0 then
                health.isDead = true
                print("isDead")
            end 
        end
    end

    function health.drawState(text)
        if health.isDead then
            love.graphics.print(text, screenSize.w / 2, screenSize.h / 2)
        end
    end

    return health
end