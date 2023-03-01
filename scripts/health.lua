
function createHealth(hp, text)
    local health = {}
    
    health.hp = hp
    health.blinkTimer = 0
    health.inBlink = false
    health.isDead = false

    require("scripts/ui")
    health.label = createLabel(text)

    health.audio = require("scripts/audio")
   
    function health.createHealthDisplay()
        health.display = createHealthDisplay(health.hp, health.hp)
    end

    function health.blink(dt)
        health.blinkTimer = health.blinkTimer + dt
        if health.blinkTimer >= 0.2 then
            health.inBlink = false
            health.blinkTimer = 0
        end
    end
    
    function health.update(dt)
        if health.isDead then
            if love.keyboard.isDown("r") then
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
            health.audio.playHitSound()
            if health.hp <= 0 then
                health.isDead = true
            end 
        end
    end

    function health.draw()
        if health.display ~= nil then
            health.display.draw(health.hp)
        end
        if health.isDead then
            health.label.draw()
        end
    end
    return health
end