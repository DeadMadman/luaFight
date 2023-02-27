local collisions = {}

function collisions.resolve(player, boss, tiles, dt)
    collisions.bulletDamageCollision(player.shooting.bullets, boss)
    collisions.bulletDamageCollision(boss.shooting.bullets, player)
    for _, tile in pairs(tiles.collidableTiles) do
        collisions.bulletTileCollision(player.shooting.bullets, tile)
        collisions.bulletTileCollision(boss.shooting.bullets, tile)
    end
end

function collisions.bulletTileCollision(bullets, tile)
    local b = tile.collider
    for index, bullet in pairs(bullets.currentBullets) do
        local a = bullet.collider
        if collisions.rectRectIntersect(a, b) then
            bullets.onCollision(index)
        end
    end
end

function collisions.bulletDamageCollision(bullets, other)
    local b = other.collider
    for index, bullet in pairs(bullets.currentBullets) do
        local a = bullet.collider
        if collisions.rectRectIntersect(a, b) then
            other.onCollisionBullet(true)
            bullets.onCollision(index)
        end
    end
end

function collisions.rectRectIntersect(rect1, rect2)
    local offset = createVec(0, 0)
    local intersect = (rect1.x + rect1.w >= rect2.x) and (rect1.x <= rect2.x + rect2.w) and 
        	        (rect1.y + rect1.h >= rect2.y) and (rect1.y <= rect2.y + rect2.h)
    if intersect then
        if (rect1.x + rect1.w / 2) > (rect2.x + rect2.w / 2) then
            offset.x = (rect2.x + rect2.w) - rect1.x
        else
            offset.x = rect2.x - (rect1.w + rect1.x)
        end
        if (rect1.y + rect1.h / 2) > (rect2.y + rect2.h / 2) then
            offset.y = (rect2.y + rect2.h) - rect1.y
        else
            offset.y = rect2.y - (rect1.h + rect1.y)
        end
    end
    return intersect, offset
end

function collisions.lineRectIntersect(line, rect)
    local rect = rect.collider
    local left = collisions.lineLineIntersect(line, createRect(rect.x, rect.y, rect.x, rect.y + rect.h))
    local right = collisions.lineLineIntersect(line, createRect(rect.x + rect.w, rect.y, rect.x + rect.w, rect.y + rect.h))
    local top = collisions.lineLineIntersect(line, createRect(rect.x, rect.y, rect.x + rect.w, rect.y))
    local bottom = collisions.lineLineIntersect(line, createRect(rect.x, rect.y + rect.h, rect.x + rect.w, rect.y + rect.h))
    return left or right or top or bottom
end

function collisions.lineLineIntersect(line1, line2)
    local intersection1 = ((line2.w-line2.x)*(line1.y-line2.y) - (line2.h-line2.y)*(line1.x-line2.x)) / ((line2.h-line2.y)*(line1.w-line1.x) - (line2.w-line2.x)*(line1.h-line1.y));
    local intersection2 = ((line1.w-line1.x)*(line1.y-line2.y) - (line1.h-line1.y)*(line1.x-line2.x)) / ((line2.h-line2.y)*(line1.w-line1.x) - (line2.w-line2.x)*(line1.h-line1.y));
    return intersection1 >= 0 and intersection1 <= 1 and intersection2 >= 0 and intersection2 <= 1
end

return collisions