function createRect(x, y, w, h)
    rect = {}
    rect.x = x
    rect.y = y
    rect.width = w
    rect.height = h
    return rect
end

function createSprite(name)
    return love.graphics.newImage(name)
end

function createVec2(x, y)
    vec = {}
    vec.x = x
    vec.y = y
    return vec
end
