local animator = {}

animator.spriteSheet = love.graphics.newImage("playerSheet.png")
animator.spriteSheet:setFilter("nearest", "linear")
animator.animations = {}

function animator.createAnimation(rects)
    local animation = {}
    animation.frames =  {}
    for index, value in ipairs(rects) do
        local rect = animator.createFrame(rects[index])
        animation.frames[index] = rect
        animation.size = index
    end

    animation.currentFrameIndex = 1
    animation.currentFrame = animation.frames[animation.currentFrameIndex]

    animation.duration = 1 / 12
    animation.currentTime = 0
    
    return animation
end

function animator.createFrame(rect)
    return love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h, 
            animator.spriteSheet:getDimensions())
end

function animator.updateFrame(animation, dt)
    local i = animation.currentFrameIndex
    
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime > animation.duration then
        animation.currentTime = 0
        i = animation.currentFrameIndex + 1
    end

    if i >= animation.size then
        i = 1
    end

    animation.currentFrameIndex = i
    animation.currentFrame = animation.frames[i]
    return animation.currentFrame
end

return animator