local bullets = {}
bullets.currentBullets = {}

function bullets.createBullet(x, y, w, h, dir)
    local bullet = {}
    bullet.collider = createRect(x, y, w, h)
    require("animator")
    bullet.animator = createAnimator()

    local w = bullet.collider.w
    local h = bullet.collider.h
    local bulletRects = {
        createRect(0,   0, w, h),
        createRect(w,   0, w, h),
        createRect(w*2, 0, w, h),
        createRect(w*3, 0, w, h)
    }
    bullet.animator.createAnimation("tilesets.png", "map", bulletRects, 2)
    bullet.currentAnimation = bullet.animator.setAnimation("map")
    bullet.sprite = bullet.currentAnimation.frames[1]
    
    bullet.dir = dir
    bullet.speed = 400

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
    dir.x = dir.x * currentBullet.speed
    dir.y = dir.y * currentBullet.speed

    velocity.add(dir)
    velocity.multiplyScalar(dt)
    currentBullet.collider.x = currentBullet.collider.x + velocity.x
    currentBullet.collider.y = currentBullet.collider.y + velocity.y
end

function bullets.update(dt)
    for _, bullet in pairs(bullets.currentBullets) do
        bullets.updateBullet(bullet, dt)
    end
end

function bullets.drawBullet(currentBullet)
    love.graphics.rectangle("line", currentBullet.collider.x, currentBullet.collider.y, 
    currentBullet.collider.w, currentBullet.collider.h)
    love.graphics.draw(currentBullet.animator.spriteSheet, currentBullet.sprite, 
            currentBullet.collider.x, currentBullet.collider.y)
end

function bullets.draw()
    for _, bullet in pairs(bullets.currentBullets) do
        bullets.drawBullet(bullet)
    end
end

return bullets