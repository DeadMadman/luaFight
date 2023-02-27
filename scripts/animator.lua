function createAnimator()
    local animator = {}
    animator.animations = {}

    function animator.createAnimation(imageName, name, rects, duration)
        animator.spriteSheet = love.graphics.newImage(imageName)
        animator.spriteSheet:setFilter("nearest", "nearest")

        local animation = {}
        animation.frames =  {}
        for index, value in ipairs(rects) do
            local rect = animator.createFrame(rects[index])
            animation.frames[index] = rect
            animation.size = index
        end
        animation.currentFrameIndex = 1
        animation.currentFrame = animation.frames[animation.currentFrameIndex]
    
        animation.duration = 1 / duration
        animation.currentTime = 0
        
        animator.animations[name] = animation
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
    
    function animator.setAnimation(name)
        return animator.animations[name]
    end
    
    function animator.resetState(name)
        animator.animations[name].currentFrameIndex = 1
        animator.animations[name].currentFrame = 1
        animator.animations[name].currentTime = 0
    end

    function animator.getStrip(w, h, y, frames)
        local rects = {}
        for i = 1, frames do
            table.insert(rects, createRect(w * (i - 1), y, w, h))
        end
        return rects
    end
    
    function animator.getTileRects(w, h)
        local tileRects = {}
        for r = 1, 13 do
            for c = 1, 10 do
                table.insert(tileRects, createRect(w * (c - 1), h * (r - 1), w, h))
            end
        end
        return tileRects
    end

    return animator
end

