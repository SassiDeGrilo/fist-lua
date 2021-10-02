--[[
    Estou criando essa Classe apenas para tentar siplificar o uso da
    da ferramente 'timer' do love2d
]]

Cronnos = Class{}

function Cronnos:init(tempo)
    self.timer = tempo
    --self.velocidade = velocidade
    self.cronnos = self.timer
    self.running = false
end

function Cronnos:getTime()
    return self.cronnos
end

function Cronnos:start()
    self.cronnos = self.timer
    self.running = true
end

function Cronnos:update(dt)
    if self.running then
        self.cronnos = self.cronnos - dt
    end

    if self.cronnos <=0 then
        self.running = false
    end
    
end

function Cronnos:stop()
    self.running = false
end
