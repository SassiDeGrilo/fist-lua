Menu = {}
--[[
    como nao existe a nessecidade de criar varios objetos dessa classe
    eu dicidi por nao usar a biblioteca Class.lua, e ao inves disso
    usar o proprio sistema de POO do lua
]]

function Menu:load()
    self.inPlay = false
    self.bkg = love.graphics.newImage('imagens/bkg.png')
    self.audio = love.audio.newSource('audios/00_Forgotten Place.ogg','stream')
    self.button_play = love.graphics.newImage('imagens/Button_play.png')
    self.button_quit = love.graphics.newImage('imagens/Button_quit.png')
    self.escala_play = 1
    self.escala_quit = 1
    self.option = 0
end

function Menu:update(dt)
    -- self.audio:play()

    if self.audio:isPlaying() == false  and love.audio.getActiveSourceCount() <1 then
        self.audio:play() 
    end
--[[
    if self.enterMouse(400*2) then
        self.escala_play = 1.5
    else
        self.escala_play = 1
    end

    if self.enterMouse(460*2) then
        self.escala_quit = 1.5
    else
        self.escala_quit = 1
    end
--]]
    

    if self.option == 1 then
        self.escala_play = 1.2
        self.escala_quit = 1
    elseif self.option == 2 then
        self.escala_quit = 1.2
        self.escala_play = 1
    end

    if love.keyboard.isDown('return') then
        if self.option == 1 then
            self.inPlay = true
            love.audio.stop()
        end
        if self.option == 2 then
            --love.window.close()
            love.event.quit()
        end

    end
    
end

function Menu:draw()
    love.graphics.draw(self.bkg,0,0)
    love.graphics.draw(self.button_play,320,200,0,self.escala_play,self.escala_play,self.button_play:getWidth()/2)
    love.graphics.draw(self.button_quit,320,230,0,self.escala_quit,self.escala_quit,self.button_play:getWidth()/2)
end

function Menu:exit()

end


