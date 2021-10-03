Hearts = Class{}

require 'Player'

function Hearts:init(world,x,y)
    self.sprite = love.graphics.newImage('imagens/heart.png')
    self.world = world
    self.x = x
    self.y = y
    self.w = self.sprite:getWidth()
    self.h = self.sprite:getHeight()
    self.shape = self.world:newRectangleCollider(self.x,self.y,self.w,self.h,{collision_class = 'vida'})
    self.shape:setType('static')
    self.coletado = false
end

function Hearts:update(dt)
    if coletado then
        return
    end

    if self.shape:enter('Player') then        
        self.shape:destroy()
        self.coletado = true
    end
end


function Hearts:draw()
    if coletado then
        return
    else
        love.graphics.draw(self.sprite,self.x,self.y,0)
    end
    
end