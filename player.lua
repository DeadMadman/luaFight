local player = {}

player.scale = createVec(1, 1)
player.collider = createRect(200, 300, 36 * player.scale.x, 40 * player.scale.y)
player.offset = createVec(player.collider.w * 0.5, player.collider.w * 0.5)

player.speed  = 200
player.lookDir = 1
player.velocity = createVec(0, 0)

player.jumpForce = - (gravity.y + 300)
player.jumpDuration = 0.5

player.canJump = true
player.inJump = false
player.jumpTimer = 0
player.jumpAccumulator = 0

player.bullets = require("bullet")
player.canShoot = true
player.inShoot = false
player.shootTimer = 0
player.fireRate = 0.2

player.hp = 5

--Anims
require("animator")
player.animator = createAnimator()
player.animations = require("animations")

local w = player.collider.w / player.scale.x
local h = player.collider.h / player.scale.y

player.animator.createAnimation("playerSheet.png", "idle", player.animations.getIdleRects(w, h), 6)
player.animator.createAnimation("playerSheet.png", "run", player.animations.getRunRects(w, h), 16)
player.animator.createAnimation("playerSheet.png", "shoot", player.animations.getShootRects(w, h), 16)
player.animator.createAnimation("playerSheet.png", "jump", player.animations.getJumpRects(w, h), 12)

player.currentAnimation = player.animator.setAnimation("idle")
player.sprite = player.currentAnimation.currentFrame

function player.updatePos(velocity, dt)
    velocity.multiplyScalar(dt)
    player.collider.x = player.collider.x + velocity.x
    player.collider.y = player.collider.y + velocity.y
end

function player.update(dt)
    if player.inShoot then
        player.shootCooldown(dt)
    end

    local velocity = createVec(0, 0)
    local inputDir = player.updateInput()
    inputDir.multiplyScalar(player.speed)
    
    if player.inJump then
        velocity.add(player.jump(dt))
    end
    velocity.add(inputDir)
    velocity.add(gravity)
    
    --collider here?

    player.updatePos(velocity, dt)
    player.velocity = velocity
    clampBounds(player.collider, screenSize)
    
    player.updateAnimations(dt)
end

function player.jump(dt)
    local velocity = createVec(0, 0)
    player.jumpAccumulator = player.jumpAccumulator + dt

    while player.jumpAccumulator > 0.016 do
        player.jumpAccumulator = player.jumpAccumulator - 0.016
        player.jumpTimer = player.jumpTimer + 0.016 / player.jumpDuration
        velocity.y = - player.jumpTimer * player.jumpTimer + 1
        velocity.y = velocity.y * player.jumpForce
    
        if player.jumpTimer >= 1 then
            player.jumpTimer = 0
            player.inJump = false
            player.animator.resetState("jump")
        end
    end 
    return velocity
end

function player.shoot()
    local bulletSize = createVec(4, 4)
    player.bullets.createBullet(player.collider.x + player.collider.w / 2 + player.collider.w / 2 * player.lookDir - bulletSize.x, 
                                player.collider.y + player.collider.h / 2 - bulletSize.y * 2, 
                                bulletSize.x, bulletSize.y, createVec(player.lookDir, 0))
    player.canShoot = false
    player.inShoot = true
end

function player.shootCooldown(dt)
    player.shootTimer = player.shootTimer + dt
    if player.shootTimer >= player.fireRate then
        player.canShoot = true
        player.inShoot = false
        player.shootTimer = 0
    end
end

function player.updateInput()
    local dir = createVec(0, 0)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dir.x = dir.x + 1
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dir.x = dir.x - 1
    end
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") or love.keyboard.isDown("space") then
        if player.canJump then
            player.canJump = false
            player.inJump = true
        end
    end
    if love.keyboard.isDown("q") or love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        if player.canShoot then
            player.shoot()
        end
    end
    return dir
 end

function player.updateAnimations(dt)
    if player.inJump then
        player.currentAnimation = player.animator.setAnimation("jump")
    elseif player.inShoot then
        player.currentAnimation = player.animator.setAnimation("shoot")
    elseif player.velocity.x > 0 then
        player.lookDir = 1
        player.currentAnimation = player.animator.setAnimation("run")
    elseif player.velocity.x < 0 then
        player.lookDir = -1
        player.currentAnimation = player.animator.setAnimation("run")
    else
        player.currentAnimation = player.animator.setAnimation("idle")
    end
    player.sprite = player.animator.updateFrame(player.currentAnimation, dt)
    
end

function player.onCollisionBullet(takeDamage)
    if takeDamage then
        player.hp = player.hp - 1
        if player.hp <= 0 then
            print("dead")
        end
    end
end

function player.onCollisionTile(offset)
    player.canJump = true
    local min = math.min(math.abs(offset.x), math.abs(offset.y))
    if math.abs(offset.x) == min then
        offset.y = 0
    else
        offset.x = 0
    end
    player.collider.x = player.collider.x + offset.x
    player.collider.y = player.collider.y + offset.y
end

function player.draw()
    --draw collider
    --love.graphics.rectangle("line", player.collider.x, player.collider.y, player.collider.w, player.collider.h)
    --draw sprite
    love.graphics.draw(player.animator.spriteSheet, player.sprite, player.collider.x + player.offset.x, player.collider.y + player.offset.x, 
                        0, player.scale.x * player.lookDir, player.scale.y, player.offset.x, player.offset.y)
end

return player