local collisions = {}

function collisions.resolve(player, tiles, dt)
    for _, tile in pairs(tiles.currentTiles) do
        collisions.playerTileCollision(player, tile)
    end
end

function collisions.playerTileCollision(player, tile)
    local a = player.collider
    local b = tile.collider

    if collisions.rectOverlap(a, b) then
        --todo collide!
        --player.onCollide()
        print("collide")
    end
end

function collisions.rectOverlap(a, b)
    local overlap = false
    if not(a.x + a.w < b.x  or b.x + b.w < a.x  or
           a.y + a.h < b.y or b.y + b.h < a.y ) then
            overlap = true
    end
    return overlap 
end

return collisions