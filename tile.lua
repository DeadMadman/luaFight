function createTile(x, y, w, h, rectIndex)
    local tile = {}
    tile.collider = createRect(x, y, w, h)

    require("animator")
    tile.animator = createAnimator() 
    tile.animtions = require("animations")
    local w = tile.collider.w
    local h = tile.collider.h
    tile.animator.createAnimation("tilesets.png", "map", tile.animtions.getTileRects(w, h), 1)
    tile.currentAnimation = tile.animator.setAnimation("map")
    tile.sprite = tile.currentAnimation.frames[rectIndex]

    function tile.updateTile(currentTile, dt)
   
    end
    
    function tile.drawTile(currentTile)
        love.graphics.rectangle("line", currentTile.collider.x, currentTile.collider.y, 
                currentTile.collider.w, currentTile.collider.h)
        love.graphics.draw(currentTile.animator.spriteSheet, currentTile.sprite, 
                currentTile.collider.x, currentTile.collider.y)
    end
    
    return tile
end

