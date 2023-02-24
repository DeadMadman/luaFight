local animations = {}

function animations.getIdleRects(w, h)
    local idleAnimRects = {
        createRect(0,   0, w, h),
        createRect(w,   0, w, h),
        createRect(w*2, 0, w, h),
        createRect(w*3, 0, w, h)
    }
    return idleAnimRects
end

function animations.getRunRects(w, h)
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
    return runAnimRects
end

function animations.getJumpRects(w, h)
    local jumpAnimRects = {
        createRect(0,   h*3, w, h),
        createRect(w,   h*3, w, h),
        createRect(w*2, h*3, w, h),
        createRect(w*3, h*3, w, h),
        createRect(w*4, h*3, w, h),
        createRect(w*5, h*3, w, h)
    }
    return jumpAnimRects
end

function animations.getShootRects(w, h)
    local shootAnimRects = {
        createRect(0,   h*2, w, h),
        createRect(w,   h*2, w, h),
        createRect(w*2, h*2, w, h),
    } 
    return shootAnimRects
end

function animations.getBossIdleRects(w, h)
    local idleAnimRects = {
        createRect(0,   0, w, h),
        createRect(w,   0, w, h),
        createRect(w*2, 0, w, h),
        createRect(w*3, 0, w, h)
    }
    return idleAnimRects
end

function animations.getTileRects(w, h)
    local tileRects = {}
    for r = 1, 10 do
        for c = 1, 10 do
            local index = r * 10 + c
            table.insert(tileRects, createRect(w * (c - 1), h * (r - 1), w, h))
        end
    end
    return tileRects
end

return animations