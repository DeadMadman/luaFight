local player = {}

require("scripts/collisions")
player.collider = createRect(32, 32, 36, 40)
player.offset = createVec(player.collider.w * 0.5, player.collider.w * 0.5)

player.speed  = 200
player.lookDir = 1
player.velocity = createVec(0, 0)

player.gravity = createVec(0, 300)
player.jumpForce = - (player.gravity.y + 300)
player.jumpDuration = 0.5

player.canJump = true
player.inJump = false
player.jumpTimer = 0
player.fixedTimeStepAccumulator = 0
player.fixedTimeStep = 0.001

require("scripts/shooting")
player.shooting = createShooting("assets/bullet.png", 0.2)
require("scripts/health")
player.health = createHealth(5, "Player Dead") 
player.health.createHealthDisplay()

--Anims
require("scripts/animator")
player.animator = createAnimator()

local w = player.collider.w
local h = player.collider.h
player.animator.createAnimation("assets/playerSheet.png", "idle", player.animator.getStrip(w, h, 0, 4), 6)
player.animator.createAnimation("assets/playerSheet.png", "run", player.animator.getStrip(w, h, h, 10), 16)
player.animator.createAnimation("assets/playerSheet.png", "shoot", player.animator.getStrip(w, h, h * 2, 4), 16)
player.animator.createAnimation("assets/playerSheet.png", "jump", player.animator.getStrip(w, h, h * 3, 6), 12)

player.currentAnimation = player.animator.setAnimation("idle")
player.sprite = player.currentAnimation.currentFrame

function player.updatePos(velocity, dt)
    velocity.multiplyScalar(dt)
    player.collider.x = player.collider.x + velocity.x
    player.collider.y = player.collider.y + velocity.y
end

function player.update(dt, tiles)
    if not player.health.update(dt) then
        return
    end
    player.shooting.update(dt) 

    local velocity = createVec(0, 0)
    local inputDir = player.updateInput()
    inputDir.multiplyScalar(player.speed)
    
    velocity.add(inputDir)
    velocity.add(player.gravity)
    
    player.onCollisionBottom(tiles, velocity)
    player.onCollison(tiles)
    
    if player.inJump then
        velocity.add(player.jump(dt))
    end
    player.onCollisionTop(tiles)
    
    player.updatePos(velocity, dt)
    player.velocity = velocity
    
    player.updateAnimations(dt)
end

function player.jump(dt)
    local velocity = createVec(0, 0)
    player.fixedTimeStepAccumulator = player.fixedTimeStepAccumulator + dt

    while player.fixedTimeStepAccumulator > player.fixedTimeStep do
        player.fixedTimeStepAccumulator = player.fixedTimeStepAccumulator - player.fixedTimeStep
        player.jumpTimer = player.jumpTimer + player.fixedTimeStep / player.jumpDuration
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

function player.cancelJump()
    player.inJump = false
    player.jumpTimer = 0
end

function player.updateInput()
    local dir = createVec(0, 0)

    if love.keyboard.isDown("q") or love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        if player.shooting.canShoot then
            player.shooting.shoot(player)
        end
    else
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            dir.x = dir.x + 1
        end
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            dir.x = dir.x - 1
        end
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") or love.keyboard.isDown("space") then
            if player.canJump and not player.inJump then
                player.canJump = false
                player.inJump = true
                player.collider.y = player.collider.y - 2
            end
        end
    end
    return dir
 end

function player.updateAnimations(dt)
    if player.inJump then
        player.currentAnimation = player.animator.setAnimation("jump")
    elseif player.shooting.inShoot then
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
        player.health.reduceHealth()
    end
end

function player.offsetCollision(offset)
    local min = math.min(math.abs(offset.x), math.abs(offset.y))
    if math.abs(offset.x) <= min then
        offset.y = 0
    else
        offset.x = 0
    end
    player.collider.x = player.collider.x + offset.x
    player.collider.y = player.collider.y + offset.y
end

function player.onCollisionTop(tiles)
    local upLine = createRect(player.collider.x + (player.collider.w / 2), player.collider.y + (player.collider.h / 2), player.collider.x + (player.collider.w / 2), player.collider.y)
    for _, tile in pairs(tiles) do
        if collisions.lineRectIntersect(upLine, tile) then
            player.cancelJump()
        end
    end
end

function player.onCollisionBottom(tiles, velocity)
    local downLine = createRect(player.collider.x + (player.collider.w / 2), player.collider.y + (player.collider.h / 2), player.collider.x + (player.collider.w / 2), player.collider.y + player.collider.h)
    for _, tile in pairs(tiles) do
        if collisions.lineRectIntersect(downLine, tile) then
            player.canJump = true
            velocity.y = 0
            local difference = (player.collider.y + player.collider.h) - (tile.collider.y);
            player.collider.y = player.collider.y - difference;
        end
    end
end

function player.onCollison(tiles)
    for _, tile in pairs(tiles) do
        local intersect = false
        local offset = createVec(0, 0)
        intersect, offset = collisions.rectRectIntersect(player.collider, tile.collider)
        if intersect then
            player.offsetCollision(offset)
        end
    end
end

function player.draw()
    player.health.draw()
    player.shooting.draw()
    player.health.setBlinkColor()
    love.graphics.draw(player.animator.spriteSheet, player.sprite, player.collider.x + player.offset.x, player.collider.y + player.offset.x, 
                        0, 1 * player.lookDir, 1, player.offset.x, player.offset.y)
    player.health.resetBlinkColor()
end

return player