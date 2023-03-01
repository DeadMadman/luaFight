local function getTextSize(font, text)
    return createVec(font:getWidth(text), font:getHeight(text))
end

function createLabel(text)
    local label = {}
    label.font = love.graphics.newFont(16)
    label.font:setFilter( "nearest", "nearest" )
    label.text = text
    label.restartText = "Press R to restart"

    label.textSize = getTextSize(label.font, label.text)
    label.restartTextSize = getTextSize(label.font, label.restartText)

    function label.draw()
        love.graphics.print(label.text, label.font, screenSize.w / 2 - label.textSize.x / 2, 
        screenSize.h / 2 - label.textSize.y / 2)
        love.graphics.print(label.restartText, label.font, screenSize.w / 2 - label.restartTextSize.x / 2, 
        screenSize.h / 2 + label.restartTextSize.y / 2)
    end
    return label
end

function createHealthDisplay(curernt, total)
    local label = {}
    label.bgImage = love.graphics.newImage("assets/stone.png")
    label.bgImage:setFilter("nearest", "nearest")
    label.quad = love.graphics.newQuad(0, 0, label.bgImage:getWidth(), label.bgImage:getHeight(), label.bgImage:getDimensions())
    
    label.font = love.graphics.newFont(16)
    label.font:setFilter( "nearest", "nearest" )
    label.text = createVec(tostring(curernt), tostring(total))
    
    label.currentTextSize = getTextSize(label.font, label.text.x)
    label.totalTextSize = getTextSize(label.font, label.text.y)

    function label.draw(curernt)
        label.text.x = tostring(curernt)
        love.graphics.draw(label.bgImage, label.quad, 0, screenSize.h - label.bgImage:getHeight())
        local margin = 10
        local y = screenSize.h - label.currentTextSize.y - margin / 2
        love.graphics.print(label.text.x, label.font, margin, y)
        love.graphics.print("/", label.font, 
            label.currentTextSize.x + margin, y)
        love.graphics.print(label.text.y, label.font, 
             label.currentTextSize.x + margin + getTextSize(label.font, "/").x, y)
    end
    return label
end