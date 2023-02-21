
local tiles = {}
tiles.currentTiles = {}

function tiles.newTile(x, y, w, h, rectIndex)
    local tile = {}
    tile.collider = createRect(x, y, w, h)

    require("animation")
    tile.animator = createAnimator() 
    local w = tile.collider.w
    local h = tile.collider.h
    local tileRects = {
        createRect(0,   0, w, h),
        createRect(w,   0, w, h),
        createRect(w*2, 0, w, h),
        createRect(w*3, 0, w, h)
    }
    tile.animator.createAnimation("tilesets.png", "map", tileRects, 2)
    tile.currentAnimation = tile.animator.setAnimation("map")
    tile.sprite = tile.currentAnimation.frames[rectIndex]
    
    table.insert(tiles.currentTiles, tile)
end

function tiles.updateTile(currentTile, dt)
   
end

function tiles.update(dt)
    for _, tile in pairs(tiles.currentTiles) do
        tiles.updateTile(tile, dt)
    end
end

function tiles.drawTile(currentTile)
    love.graphics.rectangle("line", currentTile.collider.x, currentTile.collider.y, 
            currentTile.collider.w, currentTile.collider.h)
    love.graphics.draw(currentTile.animator.spriteSheet, currentTile.sprite, 
            currentTile.collider.x, currentTile.collider.y)
end

function tiles.draw()
    for _, tile in pairs(tiles.currentTiles) do
        tiles.drawTile(tile)
    end
end

return tiles