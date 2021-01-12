SnailMovingState = Class{__includes = BaseState}

function SnailMovingState:init(tilemap, player, snail)
    self.tilemap = tilemap
    self.player = player
    self.snail = snail
    self.animation = Animation{
        frames = {49, 50},
        interval = 0.5
    }
    self.snail.currentAnimation = self.animation
    self.movingDirection = math.random(2) == 1 and 'left' or 'right'
    self.snail.direction = self.movingDirection
    self.movingDuration = math.random(5)
    self.movingTimer = 0
end

function SnailMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.snail.currentAnimation:update(dt)

    if self.movingTimer > self.movingDuration then 
        if math.random(4) == 1 then 
            self.snail:changeState('idle', {
                wait = math.random(5)
            })
        else
            self.movingDirection = math.random(2) == 1 and 'left' or 'right'
            self.snail.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    elseif self.snail.direction == 'left' then 
        self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt 
        local tileLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.snail.x, self.snail.y + self.snail.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then 
            self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt 
            self.movingDirection = 'right'
            self.snail.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    else
        self.snail.direction = 'right'
        self.snail.x = self.snail.x + SNAIL_MOVE_SPEED * dt 
        local tileRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y)
        local tileBottomRight = self.tilemap:pointToTile(self.snail.x + self.snail.width, self.snail.y + self.snail.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then 
            self.snail.x = self.snail.x - SNAIL_MOVE_SPEED * dt 

            self.movingDirection = 'left'
            self.snail.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    end

    local diffX = math.abs(self.player.x - self.snail.x)

    if diffX < 5 * TILE_SIZE then 
        self.snail:changeState('chasing')
    end
end


