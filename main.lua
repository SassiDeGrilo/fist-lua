WINDOW_WIDTH = 1280
WINDOW_HEIGTH = 800
-- dimensoes vituais:
WIDTH = 640
HEIGTH = 400

push = require 'lib/push'
wf = require 'lib/windfield'    
Class = require 'lib/class'
STI = require 'lib/sti'
Camera = require 'lib/camera'
require 'Player'
require 'Map'
require 'Enemies'
require 'Menu'

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    push:setupScreen(WIDTH,HEIGTH,WINDOW_WIDTH,WINDOW_HEIGTH)

    world = wf.newWorld(0,600,false)
    world:setQueryDebugDrawing(true)
    world:addCollisionClass('Plataformas')
    world:addCollisionClass('Inimigos')
    world:addCollisionClass('Obstaculos')
    world:addCollisionClass('Molas')
    world:addCollisionClass('Coletavel')
    world:addCollisionClass('Saida')
    world:addCollisionClass('vida')
    world:addCollisionClass('Player', {ignores = {'Saida','Coletavel','vida'}})
    

    map = Map(world)

    cam = Camera()

    player = Player(world)

    Menu:load()

end

function love.update(dt)
    if Menu.inPlay then
        world:update(dt)
        map:update(dt)
        player:update(dt)
    else
        Menu:update(dt)
    end
end

function love.draw()
    love.graphics.clear(28/255,27/255,27/255)
    push:start()
    if Menu.inPlay then
        
        cam:attach()

        if map.last then
            love.graphics.draw(map.creditos,0,0,0)
            cam:lookAt(640,400)
            cam:detach()
            push:finish()
            return
        end
        --world:draw()
        map:draw()
        player:draw()

        cam:lookAt(math.min(math.max(player.x+WIDTH/2, WIDTH),WINDOW_WIDTH),
                    math.min(math.max(player.y+HEIGTH/2,HEIGTH),WINDOW_HEIGTH))


        cam:detach()
        
    else 
        Menu:draw()
        player.hp = 5
        player.body:setPosition(150,70)
        map.layer = '00'
    end
    push:finish()
end

function love.keypressed(key)
    if Menu.inPlay then
        if key == 'w'then
            player:jump()
        end

    else
        if key == 'w' or key == 'up' then
            Menu.option = Menu.option - 1
            if Menu.option < 1 then
                Menu.option = 2
            end
        elseif key == 's' or key == 'down' then
            Menu.option = Menu.option + 1
            if Menu.option > 2 then
                Menu.option = 1
            end
        end
    end
end

