local map = {}

map.currentTiles = {}
map.tileSize = createVec(16, 16)
map.gridSize = createVec(11, 8)
map.grid = {
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 2, 3, 4, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 1, 0, 1, 2, 2, 0, 3, 0, 3 },
    { 1, 0, 1, 0, 2, 0, 0, 0, 3, 0, 3 },
    { 1, 0, 1, 0, 2, 2, 0, 0, 0, 3, 0 },
    { 1, 0, 1, 0, 2, 0, 0, 0, 0, 3, 0 },
    { 1, 0, 1, 0, 2, 2, 2, 0, 0, 3, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
} 

function map.createMap()
    local tile = require("tile")

    for rowIndex, row in ipairs(map.grid) do  
        for colIndex, type in ipairs(row) do
            if not (type == 0) then
                local pos = createVec((colIndex - 1) * map.tileSize.x, (rowIndex - 1) * map.tileSize.y)
                local newTile = createTile(pos.x, pos.y, map.tileSize.x, map.tileSize.y, type)
                table.insert(map.currentTiles, newTile)
                print(type)
            end
    
        end
    end
end

function map.draw()
    for _, tile in pairs(map.currentTiles) do
        tile.drawTile(tile)
    end
end

function map.update(dt)
    for _, tile in pairs(map.currentTiles) do
        tile.updateTile(tile, dt)
    end
end

return map