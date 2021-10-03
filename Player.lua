Player = Class{}
anim8 = require 'lib/anim8'
require 'Cronnos'
require 'Menu'

function Player:init(world)
    self.spritesheet = love.graphics.newImage('imagens/Retro-Lines-Player.png')
    self.w = 16
    self.h = 16
    self.x = 150
    --self.x = 30
    self.y = 70
    --self.y = 350
    self.hp = 5
    self.speed = 100
    self.onFloor = false
    self.direction = 1
    self.onHit = false
    self.timer = Cronnos(0.5)
    self.time = Cronnos(6)
    self.onSaida = false

    self.sound = {}
    self.sound.jump = love.audio.newSource('audios/Jump.wav','static')
    self.sound.jump:setVolume(0.15)
    self.sound.death =love.audio.newSource('audios/TragicDeath.wav','stream')
    self.sound.death:setVolume(0.2)
    
    self.body = world:newRectangleCollider(self.x,self.y,self.w,self.h,{collision_class = 'Player'})
    self.body:setFixedRotation(true) 

    g = anim8.newGrid(self.w,self.h,
            self.spritesheet:getWidth(),
            self.spritesheet:getHeight())

    self.animations = {}
    self.animations.idle = anim8.newAnimation(g('1-2',3),0.2)
    self.animations.run = anim8.newAnimation(g('1-4',2),0.2)
    self.animations.jump = anim8.newAnimation(g('1-2',5),0.5)
    self.animations.hit = anim8.newAnimation(g('1-2',6),0.1)
    self.curAnimation = self.animations.idle



end

function Player:update(dt)
    if self.hp <1 then
        if self.sound.death:isPlaying() == false then
            love.audio.stop()
            self.sound.death:play()
            self.time:start()
        end

        if self.time.running == false then
            Menu.inPlay = false
        end
        self.time:update(dt)
        return
    end

    self.x,self.y = self.body:getPosition()
    if love.keyboard.isDown('a') then
        self.x = self.x - self.speed*dt
        self.curAnimation = self.animations.run
        self.direction = -1
    elseif love.keyboard.isDown('d') then
        self.x = self.x + self.speed*dt
        self.curAnimation = self.animations.run
        self.direction = 1
    else
        self.curAnimation = self.animations.idle
    end

    if self.onFloor == false then
        self.curAnimation = self.animations.jump
    end

    if (self.x <= 0) then
        self.x = 0
    elseif self.x >= 1280 then
        self.x = 1280
    end
    if self.y <= 0 then
        self.y = 0
    elseif self.y >= 800 then
        self.y = 800
    end


    self.body:setX(self.x)

    colliders = world:queryRectangleArea(self.x-self.w/2,
            self.y + self.h/2,self.w,4, {'Plataformas','Obstaculos'})

    if #colliders >0 then
        self.onFloor = true
    else
        self.onFloor = false
    end

    if self.onHit == false then

        if self.body:enter('Inimigos') then
            if self.direction == 1 then
                self.body:applyLinearImpulse(-25,-25)
            else
                self.body:applyLinearImpulse(25,-25)
            end
            
            self.hp = self.hp - 1
            self.onHit = true
            self.timer:start()

        end
        if self.body:enter('Obstaculos') then
            if self.direction == 1 then
                self.body:applyLinearImpulse(-25,-25)
            else
                self.body:applyLinearImpulse(25,-25)
            end
            
            self.hp = self.hp - 1
            self.onHit = true
            self.timer:start()
        end
        if self.body:enter('vida')then
            self.hp = self.hp+1
            self.onHit = true
            self.timer:start()
        end

    end

    if self.body:enter('Molas') then
        self.body:applyLinearImpulse(0,-200)  
    end
--[[]] 
    if self.onHit then
        if self.timer.running then
            self.curAnimation = self.animations.hit
        else
            self.onHit = false
        end
        
    end
 --   ]]


    self.timer:update(dt)
    
    self.curAnimation:update(dt)


end

function Player:draw()
    if self.hp < 1 then
        return
    end
    self.curAnimation:draw(self.spritesheet,self.body:getX(),self.body:getY(),
                        0,self.direction,1,self.w/2,self.h/2)

    if self.onHit then
        love.graphics.printf(self.hp,self.x,self.y-25,30,'left')
    end
    

end

function Player:jump()
    if self.hp < 1 then
        return
    end
    if self.onFloor then
        self.body:applyLinearImpulse(0,-100)
        self.sound.jump:play()
    end

end
