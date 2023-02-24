local collisions = {}

function collisions.resolve(player, boss, tiles, dt)
    collisions.bulletDamageCollision(player.bullets, boss)
    collisions.bulletDamageCollision(boss.bullets, player)

    for _, tile in pairs(tiles.currentTiles) do
        collisions.playerTileCollision(player, tile)
        collisions.bulletTileCollision(player.bullets, tile)
        collisions.bulletTileCollision(boss.bullets, tile)
    end
end

function collisions.playerTileCollision(player, tile)
    local a = player.collider
    local b = tile.collider

    local intersect = false
    local offset = createVec(0,0)
    intersect, offset = collisions.rectIntersect(a, b) 
    if intersect then
        player.onCollisionTile(offset)
    end
end

function collisions.bulletTileCollision(bullets, tile)
    local b = tile.collider
    for index, bullet in pairs(bullets.currentBullets) do
        local a = bullet.collider
        if collisions.rectIntersect(a, b) then
            bullets.onCollision(index)
        end
    end
end

function collisions.bulletDamageCollision(bullets, obj)
    local b = obj.collider
    for index, bullet in pairs(bullets.currentBullets) do
        local a = bullet.collider
        if collisions.rectIntersect(a, b) then
            obj.onCollisionBullet(true)
        end
    end
end

function collisions.rectIntersect(a, b)
    local intersect = false
    local offsetA = createVec(0, 0)

    local intersect = (a.x + a.w >= b.x) and (a.x <= b.x + b.w) and 
        	        (a.y + a.h >= b.y) and (a.y <= b.y + b.h)
    if intersect then
        if (a.x + a.w / 2) > (b.x + b.w / 2) then
            offsetA.x = (b.x + b.w) - a.x
        else
            offsetA.x = b.x - (a.w + a.x)
        end
        if (a.y + a.h / 2) > (b.y + b.h / 2) then
            offsetA.y = (b.y + b.h) - a.y
        else
            offsetA.y = b.y - (a.h + a.y)
        end
    end
    return intersect, offsetA
end

return collisions