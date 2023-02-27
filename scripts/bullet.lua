function createBullets(fileName, size)
    local bullets = {}
    bullets.currentBullets = {}
    bullets.size = createVec(15, 7)

    function bullets.createBullet(x, y, dir)
        local bullet = {}
        bullet.collider = createRect(x, y, bullets.size.x, bullets.size.y)
        bullet.offset = createVec(0, 0)
        bullet.speed = 400

        require("scripts/animator")
        bullet.animator = createAnimator()
        local w = bullet.collider.w
        local h = bullet.collider.h
        bullet.animator.createAnimation(fileName, "shot", bullet.animator.getStrip(w, h, 0, 4), 8)
        bullet.currentAnimation = bullet.animator.setAnimation("shot")
        bullet.sprite = bullet.currentAnimation.currentFrame
    
        bullet.dir = dir
        bullet.lookDir = 1
        if dir.x < 0 then
            bullet.lookDir = -1
            bullet.offset.x = w
        end
        bullet.audio = require("scripts/audio")
        bullet.audio.playShootSound()

        table.insert(bullets.currentBullets, bullet)
    end
    
    function bullets.onCollision(index)
        bullets.currentBullets[index] = nil
        table.remove(bullets.currentBullets, index)
    end
    
    function bullets.updateBullet(currentBullet, dt)
        local velocity = createVec(0, 0)
        local dir = currentBullet.dir;
        dir.normalize()
        dir.multiplyScalar(currentBullet.speed)
    
        velocity.add(dir)
        velocity.multiplyScalar(dt)

        currentBullet.collider.x = currentBullet.collider.x + velocity.x
        currentBullet.collider.y = currentBullet.collider.y + velocity.y
        currentBullet.sprite = currentBullet.animator.updateFrame(currentBullet.currentAnimation, dt)
    end
    
    function bullets.update(dt)
        for _, bullet in pairs(bullets.currentBullets) do
            bullets.updateBullet(bullet, dt)
        end
    end
    
    function bullets.drawBullet(currentBullet)
        --love.graphics.rectangle("line", currentBullet.collider.x, currentBullet.collider.y, currentBullet.collider.w, currentBullet.collider.h)
        love.graphics.draw(currentBullet.animator.spriteSheet, currentBullet.sprite, currentBullet.collider.x + currentBullet.offset.x, currentBullet.collider.y + currentBullet.offset.y, 
                            0, 1 * currentBullet.lookDir, 1)
    end
    
    function bullets.draw()
        for _, bullet in pairs(bullets.currentBullets) do
            bullets.drawBullet(bullet)
        end
    end
    
    return bullets
end

