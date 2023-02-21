local player = {}

player.scale = createVec(1, 1)
player.collider = createRect(100, 300, 36 * player.scale.x, 40 * player.scale.y)
player.offset = createVec(player.collider.w * 0.5, player.collider.w * 0.5)

player.speed  = 200
player.lookDir = 1
player.velocity = createVec(0, 0)

player.jumpForce = - (gravity.y + 300)
player.jumpDuration = 0.5

player.canJump = true
player.inJump = false

player.canShoot = true
player.inShoot = false
player.bullets = require("bullet")

require("animation")
player.animator = createAnimator()
local w = player.collider.w / player.scale.x
local h = player.collider.h / player.scale.y
local idleAnimRects = {
    createRect(0,   0, w, h),
    createRect(w,   0, w, h),
    createRect(w*2, 0, w, h),
    createRect(w*3, 0, w, h)
}
local runAnimRects = {
    createRect(0,   h, w, h),
    createRect(w,   h, w, h),
    createRect(w*2, h, w, h),
    createRect(w*3, h, w, h),
    createRect(w*4, h, w, h),
    createRect(w*5, h, w, h),
    createRect(w*6, h, w, h),
    createRect(w*7, h, w, h),
    createRect(w*8, h, w, h),
    createRect(w*9, h, w, h),
}
local jumpAnimRects = {
    createRect(0,   h*3, w, h),
    createRect(w,   h*3, w, h),
    createRect(w*2, h*3, w, h),
    createRect(w*3, h*3, w, h),
    createRect(w*4, h*3, w, h),
    createRect(w*5, h*3, w, h)
}
player.animator.createAnimation("playerSheet.png", "idle", idleAnimRects, 6)
player.animator.createAnimation("playerSheet.png", "run", runAnimRects, 16)
player.animator.createAnimation("playerSheet.png", "jump", jumpAnimRects, 12)

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
    
    player.updatePos(velocity, dt)
    player.velocity = velocity
    clampBounds(player.collider, screenSize)
    
    if player.inJump then
        player.currentAnimation = player.animator.setAnimation("jump")
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

local t = 0
local shootTimer = 0
local shootCooldown = 0.5
local accumulator = 0

function player.jump(dt)
    local velocity = createVec(0, 0)
    accumulator = accumulator + dt

    while accumulator > 0.016 do
        accumulator = accumulator - 0.016
        t = t + 0.016 / player.jumpDuration
        velocity.y = - t * t + 1
        velocity.y = velocity.y * player.jumpForce
    
        if t >= 1 then
            t = 0
            player.inJump = false
            --player.canJump = true
            player.animator.resetState("jump")
        end
    end 
    return velocity
end

function player.shoot()
    player.bullets.createBullet(player.collider.x + player.collider.w / 2, player.collider.y + player.collider.h/2 , 
    8, 8, createVec(player.lookDir, 0))
    player.canShoot = false
    player.inShoot = true
end

function player.shootCooldown(dt)
    shootTimer = shootTimer + dt
    if shootTimer >= shootCooldown then
        player.canShoot = true
        player.inShoot = false
        shootTimer = 0
    end
end

function player.updateInput()
    local dir = createVec(0, 0)

    if not player.inJump then
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
    end
    return dir
 end

function player.draw()
    if player.inJump then
        
        love.graphics.circle("fill", player.collider.x, player.collider.y, 10)
    end

    --draw collider
    love.graphics.rectangle("line", player.collider.x, player.collider.y, player.collider.w, player.collider.h)
    --draw sprite
    love.graphics.draw(player.animator.spriteSheet, player.sprite, player.collider.x + player.offset.x, player.collider.y + player.offset.x, 
                        0, player.scale.x * player.lookDir, player.scale.y, player.offset.x, player.offset.y)
end

return player