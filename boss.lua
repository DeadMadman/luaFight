local boss = {}

boss.collider = createRect(608, 32, 25, 31)
boss.offset = createVec(boss.collider.w * 0.5, boss.collider.w * 0.5)

boss.speed  = 200
boss.lookDir = 1
boss.velocity = createVec(0, 0)
boss.moveTimer = 0

require("bullet")
boss.bullets = createBullets()
boss.canShoot = true
boss.inShoot = false
boss.shootTimer = 0
boss.fireRate = 0.4

boss.hp = 5

require("animator")
boss.animator = createAnimator()
boss.animations = require("animations")

local w = boss.collider.w
local h = boss.collider.h
boss.animator.createAnimation("octopus.png", "idle", boss.animations.getIdleRects(w, h), 6)
boss.animator.createAnimation("octopus.png", "shoot", boss.animations.getIdleRects(w, h), 6)

boss.currentAnimation = boss.animator.setAnimation("idle")
boss.sprite = boss.currentAnimation.currentFrame

function boss.updatePos(velocity, dt)
    velocity.multiplyScalar(dt)
    boss.collider.x = boss.collider.x + velocity.x
    boss.collider.y = boss.collider.y + velocity.y
end

function boss.update(dt)
    if boss.inShoot then
        boss.shootCooldown(dt)
    elseif boss.canShoot and not boss.inShoot then
        boss.shoot()
    end

    local velocity = createVec(0, 0)
    velocity.add(boss.updateMove(dt))
    boss.updatePos(velocity, dt)
    boss.velocity = velocity
 
    boss.updateAnimations(dt)
    boss.bullets.update(dt)
end

function boss.shoot()
    local bulletSize = createVec(4, 4)
    boss.bullets.createBullet(boss.collider.x + boss.collider.w / 2 + boss.collider.w / 2 * boss.lookDir - bulletSize.x, 
                                boss.collider.y + boss.collider.h / 2 - bulletSize.y * 2, 
                                bulletSize.x, bulletSize.y, createVec(-boss.lookDir, 0))
    boss.canShoot = false
    boss.inShoot = true
end

function boss.shootCooldown(dt)
    boss.shootTimer = boss.shootTimer + dt
    if boss.shootTimer >= boss.fireRate then
        boss.canShoot = true
        boss.inShoot = false
        boss.shootTimer = 0
    end
end

function boss.updateMove(dt)
    local velocity = createVec(0, 0)
    boss.moveTimer = boss.moveTimer + dt
    velocity.y = math.sin(boss.moveTimer) * 123

    return velocity
end

function boss.updateAnimations(dt)
    if boss.inShoot then
        boss.currentAnimation = boss.animator.setAnimation("shoot")
    elseif boss.velocity.x > 0 then
        boss.currentAnimation = boss.animator.setAnimation("run")
    elseif boss.velocity.x < 0 then
        boss.currentAnimation = boss.animator.setAnimation("run")
    else
        boss.currentAnimation = boss.animator.setAnimation("idle")
    end
    boss.sprite = boss.animator.updateFrame(boss.currentAnimation, dt)
end

function boss.onCollisionBullet(takeDamage)
    if takeDamage then
        boss.hp = boss.hp - 1
        if boss.hp <= 0 then
            print("dead")
        end
    end
end

function boss.onCollisionTile(offset)
    local min = math.min(math.abs(offset.x), math.abs(offset.y))
    if math.abs(offset.x) == min then
        offset.y = 0
    else
        offset.x = 0
    end
    boss.collider.x = boss.collider.x + offset.x
    boss.collider.y = boss.collider.y + offset.y
end

function boss.draw()
    boss.bullets.draw()
    --draw collider
    love.graphics.rectangle("line", boss.collider.x, boss.collider.y, boss.collider.w, boss.collider.h)
    --draw sprite
    love.graphics.draw(boss.animator.spriteSheet, boss.sprite, boss.collider.x + boss.offset.x, boss.collider.y + boss.offset.x, 
                        0, 1 * boss.lookDir, 1, boss.offset.x, boss.offset.y)
end

return boss