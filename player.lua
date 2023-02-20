local player = {}

player.scale = createVec(1, 1)
player.collider = createRect(100, 100, 36 * player.scale.x, 40 * player.scale.y)
player.offset = createVec(player.collider.w * 0.5, player.collider.w * 0.5)

player.speed  = createVec(400, -400)
player.dir = 1

player.animator = require("animation")

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
player.animator.animations.idleAnimation = player.animator.createAnimation(idleAnimRects)
player.animator.animations.runAnimation = player.animator.createAnimation(runAnimRects)

player.currentAnimation = player.animator.animations.idleAnimation
player.sprite = player.currentAnimation.currentFrame

player.runJump = false
local timer = 0
local velocity = 20
local gravity = -10

function player.update(dt)
    local newPos = createVec(0, 0)
    newPos = updateInput(newPos)

    if player.runJump then
        --newPos.y = newPos.y - jump(dt)
        --player.pos = updatePos(player.collider, newPos, dt)
    end

    player.pos = updatePos(player.collider, newPos, dt)
    clampBounds(player.collider)

    player.sprite = player.animator.updateFrame(player.currentAnimation, dt)
end

function lerp(a, b, t)
    return a + t * (b - a)
end

function jump(dt)
    local value = 0.5 * gravity * timer * timer + velocity * timer;
    value = lerp(0, 20, timer)
    timer = timer + dt
    

    if timer >= 1 then
        timer = 0
        player.runJump = false
    end


    return value
 end
 
function updateInput(pos)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        pos.x = player.speed.x
        player.dir = 1

        player.currentAnimation = player.animator.animations.runAnimation
    elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        pos.x = -player.speed.x
        player.dir = -1

        player.currentAnimation = player.animator.animations.runAnimation
    else
        player.currentAnimation = player.animator.animations.idleAnimation
    end

    return pos
 end

 function clampBounds(rect)
    rect.x = clamp(rect.x, screenSize.x, screenSize.w - rect.w)
    rect.y = clamp(rect.y, screenSize.y, screenSize.h - rect.h)
end

function updatePos(pos, newPos, dt)
    pos.x = pos.x + newPos.x * dt
    pos.y = pos.y + newPos.y * dt
    return pos
end

function player.draw()
    --draw collider
    love.graphics.rectangle("line", player.collider.x, player.collider.y, player.collider.w, player.collider.h)
    --draw sprite
    love.graphics.draw(player.animator.spriteSheet, player.sprite, player.collider.x + player.offset.x, player.collider.y + player.offset.x, 
                        0, player.scale.x * player.dir, player.scale.y, player.offset.x, player.offset.y)
end

return player