local universe = {
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
    { false, false, false, true, false, false, true, true, true, false },
}

function love.load()
    love.window.setMode(666, 666, {
        vsync = true,
        resizable = false,
        fullscreen = false,
    })
    love.window.setTitle('game of life')
    -- for _ = 0, 9 do
    --     local row = {}
    --     for _ = 0, 9 do
    --         table.insert(row, false)
    --     end
    --     table.insert(universe, row)
    -- end
end

local function copyUniverse()
    local copy = {}
    for y, row in pairs(universe) do
        copy[y] = {}
        for x, cell in pairs(row) do
            copy[y][x] = cell
        end
    end
    return copy
end

local function neighbors(y, x)
    return {
        -- adjacent
        {y = y - 1, x = x}, {y = y + 1, x = x}, {y = y, x = x - 1}, {y = y, x = x + 1},
        -- diagonals
        {y = y - 1, x= x - 1}, {y = y + 1, x = x + 1}, {y = y - 1, x = x + 1}, {y = y + 1, x = x - 1},
    }
end

local function aliveNeighbors(y, x)
    local count = 0

    for _, pos in pairs(neighbors(y, x)) do
        if pos.y < 1 or pos.y > #universe or
            pos.x < 1 or pos.x > #universe[1] then
            goto continue
        end

        if universe[pos.y][pos.x] then
            count = count + 1
        end

        ::continue::
    end

    return count
end

local function underpopulation(y, x)
    return aliveNeighbors(y, x) < 2
end

local function overpopulation(y, x)
    return aliveNeighbors(y, x) > 3
end

local function reproduction(y, x)
    return aliveNeighbors(y, x) == 3
end

local function nextGeneration()
    local newUniverse = copyUniverse()

    for y, row in pairs(universe) do
        for x, alive in pairs(row) do
            if alive and (underpopulation(y, x) or overpopulation(y, x)) then
                newUniverse[y][x] = false
            end
            if not alive and reproduction(y, x) then
                newUniverse[y][x] = true
            end
        end
    end

    universe = newUniverse
end

function love.keypressed(key)
    if key == 'n' then
        nextGeneration()
    end
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- background = white
    love.graphics.clear(1, 1, 1, 1)
    -- lines and cells = black
    love.graphics.setColor(0, 0, 0, 1)

    local wwidth, wheight = love.graphics.getDimensions()

    for y, row in pairs(universe) do
        for x, alive in pairs(row) do
            love.graphics.rectangle(
                'line',
                (x - 1) * wwidth / #universe[y],
                (y - 1) * wheight / #universe,
                wwidth / #universe[y],
                wheight / #universe
            )
            if alive then
                local padding = 10
                love.graphics.rectangle(
                    'fill',
                    (x - 1) * wwidth / #universe[y] + padding / 2,
                    (y - 1) * wheight / #universe + padding / 2,
                    wwidth / #universe[y] - padding,
                    wheight / #universe - padding
                )
            end
        end
    end
end
