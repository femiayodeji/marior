SnailChasingState = Class{__includes = BaseState}

function SnailChasingState:init(tilemap, player, snail)
    self.tilemap = tilemap
    self.player = player
    self.snail = snail
    self.animation = Animation{
        frames = {49, 50},
        interval = 0.5
    }
    self.snail.currentAnimation = self.animation
end

function SnailChasingState:update(dt)
    self.snail.currentAnimation:update(dt)

    local diffX = math.abs(self.player.x - self.snail.x)
    if diffX > 5 * TILE_SIZE then 
        self.snail:changeState('moving')
    elseif self.player.x < self.snail.x then 
        self.snail.direction = 'left'
        self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt

        local tileLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y + self.snail.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then 
            self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt 
        end
    else
        self.snail.direction = 'right'
        self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt

        local tileRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
        local tileBottomRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y + self.snail.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then 
            self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt 
        end
    end    
end
