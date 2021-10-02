--[[ 
    acho q isso deve facilitar o gerenciamento dos unicos coletaveis do jogo
]]
Coin = Class{}

function Coin:init(world,x,y)
    self.sprite = love.graphics.newImage('imagens/coin.png')
    self.world = world
    self.x = x
    self.y = y
    self.w = self.sprite:getWidth()
    self.h = self.sprite:getHeight()
    self.shape = self.world:newRectangleCollider(self.x,self.y,self.w,self.h,{collision_class = 'Coletavel'})
    self.shape:setType('static')
    self.coletado = false
end

function Coin:update(dt)
    if coletado then
        return
    end

    if self.shape:enter('Player') then
        self.shape:destroy()
        self.coletado = true
    end
end


function Coin:draw()
    if coletado then
        return
    else
        love.graphics.draw(self.sprite,self.x,self.y,0)
    end
    
end