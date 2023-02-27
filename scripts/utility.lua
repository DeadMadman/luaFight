function createRect(x, y, w, h)
    local rect = {}
    rect.x = x
    rect.y = y
    rect.w = w
    rect.h = h
    return rect
end

function createSprite(name)
    return love.graphics.newImage(name)
end

function createVec(x, y)
    local vec = {}
    vec.x = x
    vec.y = y

    function vec.add(a)
        vec.x = vec.x + a.x;
        vec.y = vec.y + a.y;
    end

    function vec.multiply(a)
        vec.x = vec.x * a.x;
        vec.y = vec.y * a.y;
    end

    function vec.multiplyScalar(a)
        vec.x = vec.x * a;
        vec.y = vec.y * a;
    end

    function vec.normalize()
        local mag = vec.magnitude()
        if mag > 0 then
            vec.x = vec.x / mag 
            vec.y = vec.y / mag
        end
    end

    function vec.magnitude()
       return math.sqrt(vec.x * vec.x + vec.y * vec.y)
    end
    return vec
end

function clamp(num, min, max)
    if num < min then
        return min
    elseif num > max then
        return max
    end
    return num
end

function clampBounds(rect, screenSize)
    rect.x = clamp(rect.x, screenSize.x, screenSize.w - rect.w)
    rect.y = clamp(rect.y, screenSize.y, screenSize.h - rect.h)
end

function lerp(a, b, t)
    return a + t * (b - a)
end

function getSize(table)
    local size
    for _ in pairs(table) do size = size + 1 end
    return size
end