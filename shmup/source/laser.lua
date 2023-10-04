import "CoreLibs/graphics"
-- import "const"
import "enemy"

class("Laser").extends(Enemy)

local gfx = playdate.graphics

Laser.AIMING = 1
Laser.FIXED = 2
Laser.FIRING = 3
Laser.DONE = 4

function Laser:init()
    Laser.super.init(self)
    self:setState(Laser.AIMING)
    self.y = 160
end

function Laser:setState(state)
    self.state = state
    self.ticksInState = 0
end

function Laser:addToStage()
    table.insert(Enemy.enemies, self)
end

function Laser:update()    
    Laser.super.update(self)
    self.ticksInState += 1

    if self.state == Laser.AIMING then
        if self.ticksInState < 40 then
            if self.ticksInState % 8 < 4 then
                return
            end
        elseif self.ticksInState < 60 then
            if self.ticksInState % 4 < 2 then
                return
            end
        end
    
        local speedLaser = 8
        local x0 = math.max(0, 400-self.ticksInState*speedLaser)
        drawOutlinedRect(x0, self.y, 400, 3);

        if self.ticksInState >= 70 then
            self:setState(Laser.FIRING)
        end
    elseif self.state == Laser.FIRING then
        local speedLaser = 32
        local x0 = math.max(0, 400-self.ticksInState*speedLaser)
        drawOutlinedRect(0, self.y, 400, 3)
        drawOutlinedRect(x0-7, self.y, 400, 9)
        drawOutlinedRect(x0-3, self.y, 400, 17)
        drawOutlinedRect(x0, self.y, 400, 25)
        if self.ticksInState >= 20 then
            self:setState(Laser.DONE)
        end
    elseif self.state == Laser.DONE then
        local speedLaser = 32
        local x1 = math.max(-11, 400-self.ticksInState*speedLaser)
        drawOutlinedRect(0, self.y, x1+11, 3)
        drawOutlinedRect(0, self.y, x1+7, 9)
        drawOutlinedRect(0, self.y, x1+3, 17)
        drawOutlinedRect(0, self.y, x1, 25)
        if self.ticksInState >= 40 then
            self:remove()
        end        
    end

end

function drawOutlinedRect(x0, y, width, thickness)
    local halfThickness = math.floor(thickness/2)
    local y0 = y - halfThickness
    local y1 = thickness - 1

    -- if self.state == Laser.AIMING then
    gfx.setColor(gfx.kColorBlack)
    gfx.drawRect(x0-1, y0-1, width+2, y1+2)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(x0, y0, width, y1)
end

function Laser:remove()
    Laser.super.remove(self)
end