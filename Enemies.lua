Enemies = Class{}
anim8 = require 'lib/anim8'
math.randomseed(os.time())

function Enemies:init(world,x,y,type)
    self.world = world
    self.spritesheet = love.graphics.newImage('imagens/Expanded-Retro-Lines-Enemies.png')
    self.type = type
    self.x = x
    self.y = y
    self.xO = x
    self.yO = y
    self.h = 16
    self.w = 16
    self.direction = 1

    self.body = world:newRectangleCollider(self.x,self.y,self.w,self.h,
                                            {collision_class = 'Inimigos'})
    self.body:setType('kinematic')
    self.body:setFixedRotation(true) 

    self.dirX = math.random(-10,10)
    self.dirY = math.random(-10,10)

    self.speed = 50

    self.g = anim8.newGrid(self.w,self.h,
            self.spritesheet:getWidth(),
            self.spritesheet:getHeight())
    if self.type == 'bee'then
        self.animation = anim8.newAnimation(self.g('4-7',9),0.2)
    elseif self.type == 'slime' then
        self.animation = anim8.newAnimation(self.g('4-7',12),0.2)
    end
       

end

function Enemies:update(dt)
    if self.body == nil then
        return
    end
    --self.world:setGravity(0,0)
    self.x,self.y = self.body:getPosition()

    if self.type == 'bee' then
        if self.dirY >= 1 then
            if self.y < self.yO + 2*self.w then
                self.y = self.y + self.speed*dt
            else
                self.dirY = -1                
            end
        else
            if self.y > self.yO - 2*self.w then
                self.y = self.y - self.speed*dt
            else
                self.dirY = 1
            end
        end

        vision = world:queryCircleArea(self.body:getX(),self.body:getY(),50,{'Player'})

        if #vision > 0 then
            for _,visor in ipairs(vision) do
                if visor:getX() < self.body:getX() then
                    self.direction = 1
                else
                    self.direction = -1
                end
            end
        end


        
    elseif self.type == 'slime' then
        if self.dirX >= 1 then
            if self.x < self.xO + 2*self.w then
                self.x = self.x + self.speed*dt
            else
                self.dirX = -1
                self.direction = 1
            end
        else
            if self.x > self.xO - 2*self.w then
                self.x = self.x - self.speed*dt
            else
                self.dirX = 1
                self.direction = -1
            end
        end
        
    end
    self.body:setPosition(self.x,self.y)

    self.animation:update(dt)
    --self.world:setGravity(0,600)
end

function Enemies:draw()
    if self.body == nil then
        return
    end
    self.animation:draw(self.spritesheet,self.body:getX(),self.body:getY(),
                        0,self.direction,1,self.w/2,self.h/2)
end
