Map = Class{}
require 'Coin'
require 'Enemies'
require 'Menu'
require 'Cronnos'

function Map:init(world)
    self.world = world
    self.plataformas = {}
    self.obstaculos = {}
    self.coins = {}
    self.inimigos = {}
    self.saida = {}
    self.creditos = love.graphics.newImage('imagens/creditos.png')
    self.gameMap = STI("maps/01.lua")
    self.fistTime = true
    self.last = false
    self.timer = Cronnos(30)


    self.layer = '00'
    --self.layer = layer

    self.sound = {}
    self.sound.zero = love.audio.newSource('audios/01_sakura_variation.ogg','stream')
    self.sound.um = love.audio.newSource('audios/02_old city theme.ogg','stream')
    self.sound.dois = love.audio.newSource('audios/03_slow_melancholic_theme_c64_style_long_version_with_refrain.ogg','stream')
    self.sound.win = love.audio.newSource('audios/winner.ogg','stream')

    self:createPlataformas(self.layer)
    self:createObstaculos(self.layer)
    self:createMolas(self.layer)
    self:createMoedas(self.layer)
    self:createEnemies(self.layer)
    self:saidas(self.layer)

    --self.sound.zero:play()

end

function Map:update(dt)
    self.gameMap:update(dt)
    for _, moedas in ipairs(self.coins) do
        moedas:update(dt)      
    end

    for _, bixinhos in ipairs(self.inimigos) do
        bixinhos:update(dt)      
    end

    if self.fistTime then
        self.sound.zero:play()
        self.fistTime = false
    end

    for _, exit in ipairs(self.saida) do
        if exit:enter('Player') then
            if self.layer == '00' then
                self.layer = '01'
                self.sound.zero:stop()
                self.sound.um:play()
            elseif self.layer == '01' then
                self.sound.um:stop()
                if exit:getX() < 500 then
                    self.layer = '00'
                    self.sound.zero:play()
                else
                    self.layer = '02'
                    self.sound.dois:play()
                end
            elseif self.layer == '02' then
                if self.timer.running then
                    if self.timer:getTime() <1 then
                        Menu.inPlay = false
                        love.audio.stop()
                    end
                else
                    love.audio.stop()
                    self.timer:start()
                    self.sound.win:play()
                    self.last = true
                end
                
            end
            --[[
            self.plataformas = {}
            self.obstaculos = {}
            self.coins = {}
            self.inimigos = {}
            self.saida = {}
            --]]
            for i, all in ipairs(self.plataformas) do
                --self.plataformas[i]:destroy()
                all:destroy() -- por algum motivo nao estava removendo todas as plat
                --table.remove(self.plataformas,i)
            end
            self.plataformas = {}
            --self.plataformas:release()
            --]]
            
            for i, all in ipairs(self.obstaculos) do
                --self.obstaculos[i]:destroy()
                all:destroy()
                --table.remove(self.obstaculos,1)
            end
            self.obstaculos = {}

            for i, all in ipairs(self.coins) do
                self.coins[1].shape:destroy()
                --all.shape:release()
                table.remove(self.coins,1)
            end
            self.coins = {}

            for i, all in ipairs(self.inimigos) do
                self.inimigos[1].body:destroy()
                --all.body:destroy()
                table.remove(self.inimigos,1)
            end

            colliders = self.world:queryRectangleArea(0,0,1280,800,{'Plataformas','Obstaculos','Inimigos','Molas'})

            for i, obj in ipairs(colliders) do
                obj:destroy()
            end
            self.inimigos = {}

            for i, all in ipairs(self.saida) do
                --self.saida[i]:destroy()
                all:destroy()
            end
            self.saida = {}

            self:createPlataformas(self.layer)
            self:createObstaculos(self.layer)
            self:createMolas(self.layer)
            self:createMoedas(self.layer)
            self:createEnemies(self.layer)
            self:saidas(self.layer)
            --]]
            --self.chageScene()
        end
    end

    self.timer:update(dt)

end

function Map:draw()

    if self.last then
        love.graphics.draw(self.creditos,0,0,0)
        return
    end


    self.gameMap:drawLayer(self.gameMap.layers['fundo_'..self.layer])
    self.gameMap:drawLayer(self.gameMap.layers['Camada de Tiles '..self.layer])

    for i=# self.coins,1,-1 do 
        if self.coins[i].coletado then
            table.remove(self.coins,i)
        else
            self.coins[i]:draw()
        end
    end

    for i=# self.inimigos,1,-1 do 
        if self.inimigos[i].coletado then
            table.remove(self.inimigos,i)
        else
            self.inimigos[i]:draw()
        end
    end

end

function Map:createPlataformas(layer)
    local Plataformas
    for _, obj in ipairs(self.gameMap.layers['plataformas '..layer].objects) do
        solid = self.world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height,
                                                    {collision_class = 'Plataformas'})
        solid:setType('static')
        table.insert(self.plataformas,solid)
    end
end

function Map:createObstaculos(layer)
    local Obstaculos
    for _, obj in ipairs(self.gameMap.layers['obstaculos '..layer].objects) do
        solid = self.world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height,
                                                    {collision_class = 'Obstaculos'})
        solid:setType('static')
        table.insert(self.obstaculos,solid)
    end
end

function Map:createMolas(layer)
    local Molas
    for _, obj in ipairs(self.gameMap.layers['molas '..layer].objects) do
        solid = self.world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height,
                                                    {collision_class = 'Molas'})
        solid:setType('static')
        solid:setRestitution(0)
        table.insert(self.plataformas,solid)
    end
end


function Map:createMoedas(layer)
    local moedas
    for _, obj in ipairs(self.gameMap.layers['Coins '..layer].objects) do
        moedas = Coin(self.world,obj.x,obj.y)
        table.insert(self.coins,moedas)
    end
end

function Map:createEnemies(layer)
    local bixinhos
    for _, obj in ipairs(self.gameMap.layers['abelhas '..layer].objects) do
        bixinhos = Enemies(self.world,obj.x,obj.y,'bee')
        table.insert(self.inimigos,bixinhos)
    end

    for _, obj in ipairs(self.gameMap.layers['slimes '..layer].objects) do
        bixinhos = Enemies(self.world,obj.x,obj.y,'slime')
        table.insert(self.inimigos,bixinhos)
    end

end

function Map:saidas(layer)
    local saida 
    for _, obj in ipairs(self.gameMap.layers['saida '..layer].objects) do
        saida = self.world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height,
        {collision_class = 'Saida'})
        saida:setType('static')
        table.insert(self.saida,saida)
    end
end