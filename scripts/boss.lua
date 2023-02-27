local boss = {}

boss.collider = createRect(632, 32, 54, 57)
boss.offset = createVec(boss.collider.w * 0.5, boss.collider.w * 0.5)

boss.speed  = 200
boss.lookDir = -1
boss.velocity = createVec(0, 0)
boss.moveTimer = 0

require("scripts/shooting")
boss.shooting = createShooting("assets/bulletBoss.png", 0.8)
require("scripts/health")
boss.health = createHealth(50, "Bug Dead")

require("scripts/animator")
boss.animator = createAnimator()
local w = boss.collider.w
local h = boss.collider.h
boss.animator.createAnimation("assets/boss.png", "idle", boss.animator.getStrip(w, h, 0, 8), 6)
boss.currentAnimation = boss.animator.setAnimation("idle")
boss.sprite = boss.currentAnimation.currentFrame

function boss.updatePos(velocity, dt)
    velocity.multiplyScalar(dt)
    boss.collider.x = boss.collider.x + velocity.x
    boss.collider.y = boss.collider.y + velocity.y
end

function boss.update(dt)
    if not boss.health.update(dt) then
        return
    end
    boss.shooting.update(dt)
    if boss.shooting.canShoot and not boss.inShoot then
        boss.shooting.shoot(boss)
    end

    local velocity = createVec(0, 0)
    velocity.add(boss.updateMove(dt))
    boss.updatePos(velocity, dt)
    boss.velocity = velocity
    boss.updateAnimations(dt)
end

function boss.updateMove(dt)
    local velocity = createVec(0, 0)
    boss.moveTimer = boss.moveTimer + dt
    velocity.y = math.sin(boss.moveTimer) * 120

    return velocity
end

function boss.updateAnimations(dt)
    boss.sprite = boss.animator.updateFrame(boss.currentAnimation, dt)
end

function boss.onCollisionBullet(takeDamage)
    if takeDamage then
        boss.health.reduceHealth()
    end
end

function boss.draw()
    boss.health.draw()
    boss.shooting.draw()
    boss.health.setBlinkColor()
    love.graphics.draw(boss.animator.spriteSheet, boss.sprite, boss.collider.x + boss.offset.x, boss.collider.y + boss.offset.x, 
                        0, 1 * boss.lookDir, 1, boss.offset.x, boss.offset.y)
    boss.health.resetBlinkColor()
end

return boss