local seedPlantingP2 = {}

function seedPlantingP2.load(selectedSeedTypes)
    
    seedPlantingP2.plantedHoles = {}
    seedPlantingP2.seedArray = {}

    seedPlantingP2.selectedSeedTypes = selectedSeedTypes or {"acacia"}

    seedPlantingP2.seedImages = {
        acacia = love.graphics.newImage("images/acaciaSeed.png"),
        africanOlive = love.graphics.newImage("images/africanOliveSeed.png"),
        cedar = love.graphics.newImage("images/cedarSeed.png")
    }

    seedPlantingP2.saplingImages = {
        acacia = love.graphics.newImage("images/acaciaSapling.png"),
        africanOlive = love.graphics.newImage("images/africanOliveSapling.png"),
        cedar = love.graphics.newImage("images/cedarSapling.png")
    }
   

    seedPlantingP2.treeImages = {
        acacia = love.graphics.newImage("images/Acacia Tree.png"),
        africanOlive = love.graphics.newImage("images/Olive Tree.png"),
        cedar = love.graphics.newImage("images/Cedar Tree.png")
    }

    seedPlantingP2.holeImage = love.graphics.newImage("images/hole.png")
    seedPlantingP2.holeImage2 = love.graphics.newImage("images/hole2.png")
    seedPlantingP2.soil = love.graphics.newImage("images/plantedSoil.PNG")

    seedPlantingP2.background = P2S1gamebackground


    seedPlantingP2.plantedSeeds = {}
    seedPlantingP2.coveredHoles = {}
    seedPlantingP2.saplingCount = 0
    seedPlantingP2.gameCompleted = false
end

function seedPlantingP2.update(dt)
   --nothing needed here
end

function seedPlantingP2.draw()
    local tilewidth = 36
    local tileheight = 36

    -- Define exact positions matching previous stages
    local holeCoords = {
        {x = 2, y = 2}, {x = 6, y = 2}, {x = 10, y = 2}, {x = 14, y = 2}, {x = 18, y = 2},
        {x = 2, y = 6}, {x = 6, y = 6}, {x = 10, y = 6}, {x = 14, y = 6}, {x = 18, y = 6},
        {x = 2, y = 10}, {x = 6, y = 10}, {x = 10, y = 10}, {x = 14, y = 10}, {x = 18, y = 10}
    }

    for _, hole in ipairs(holeCoords) do
        local px = hole.x * tilewidth
        local py = hole.y * tileheight

        local isCovered = false
        for _, seed in ipairs(seedPlantingP2.plantedSeeds) do
            if seed.x == px and seed.y == py and seed.state == "covered" then
                isCovered = true
                break
            end
        end

        if not isCovered then
            love.graphics.draw(seedPlantingP2.holeImage, px, py)
        end
    end




    -- Draw planted seeds and saplings
    for _, seed in ipairs(seedPlantingP2.plantedSeeds) do
        local saplingScale = 1
        local offsetX, offsetY = 0, -10

        if seed.type == "cedar" then
            saplingScale = 0.9
            offsetY = -15
        elseif seed.type == "africanOlive" then
            saplingScale = 0.9
            offsetY = -15
        elseif seed.type == "acacia" then
            saplingScale = 0.9
            offsetY = -15
        end

        if seed.state == "seed" then
            love.graphics.draw(seed.image, seed.x + 15, seed.y + 5, 0, 0.5, 0.5) -- scale to 50%
        elseif seed.state == "covered" then
           local scaleX = 36 / seedPlantingP2.soil:getWidth()
           local scaleY = 36 / seedPlantingP2.soil:getHeight()
           love.graphics.draw(seedPlantingP2.soil, seed.x+5, seed.y+7, 0, scaleX * 1.3 , scaleY *1.3)
       -- elseif seed.state == "sapling" then
        --    love.graphics.draw(seed.saplingImage, seed.x + offsetX, seed.y + offsetY, 0, saplingScale, saplingScale)
        end
    end
end

function seedPlantingP2.mousepressed(x, y, button)
    if button == 1 then
        for i, hole in ipairs(seedPlantingP2.holePositions) do
            if not seedPlantingP2.coveredHoles[i] then
                if x >= hole.x and x <= hole.x + 36 and y >= hole.y and y <= hole.y + 36 then
                    local seedOptions = seedPlantingP2.selectedSeedTypes
                    local seedType = seedOptions[math.random(#seedOptions)]

                    table.insert(seedPlantingP2.plantedSeeds, {
                        x = hole.x,
                        y = hole.y,
                        state = "covered",
                        timer = 0,
                        seedType = seedType
                    })

                    seedPlantingP2.coveredHoles[i] = true
                    return
                end
            end
        end
    end
end

function seedPlantingP2.setSelectedSeedType(seedType)
    seedPlantingP2.selectedSeedTypes = {seedType}
end

function seedPlantingP2.spawnSeeds(selectedSeedTypes)

    local i = 0
    local tilewidth = 36
    local tileheight = 36

    local holeCoords = {
        {x = 2, y = 2}, {x = 6, y = 2}, {x = 10, y = 2}, {x = 14, y = 2}, {x = 18, y = 2},
        {x = 2, y = 6}, {x = 6, y = 6}, {x = 10, y = 6}, {x = 14, y = 6}, {x = 18, y = 6},
        {x = 2, y = 10}, {x = 6, y = 10}, {x = 10, y = 10}, {x = 14, y = 10}, {x = 18, y = 10}
    }

    seedPlantingP2.plantedSeeds = {}

   for _, coord in ipairs(holeCoords) do
        local choice = selectedSeedTypes[math.random(#selectedSeedTypes)]
        seedPlantingP2.seedArray[i]=choice;
        table.insert(seedPlantingP2.plantedSeeds, {
            type = choice,
            x = coord.x * tilewidth,
            y = coord.y * tileheight,
            image = seedPlantingP2.seedImages[choice],
            saplingImage = seedPlantingP2.saplingImages[choice],
            treeImage = seedPlantingP2.treeImages[choice],
            state = "seed"
        })
    end
    i=0;
end
return seedPlantingP2
