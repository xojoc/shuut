-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

explosions = {}

function explosions.load()
   explosions.img = love.graphics.newImage('assets/explosion_particle.png')
   explosions.sound = love.audio.newSource('assets/explosion.wav')
   explosions.sound:setVolume(0.5)
end

function explosions.reset()
   explosions.explosions = {}
end

function explosions.add(x,y)
   love.audio.play(explosions.sound)
   local psystem = love.graphics.newParticleSystem(explosions.img, 2000)
   psystem:setParticleLifetime(1.4)
   psystem:setEmissionRate(200)
   psystem:setLinearAcceleration(-50, -50, 50, 50)
   psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
   psystem:setEmitterLifetime(1.4)
   table.insert(explosions.explosions, {p = psystem, x = x, y = y})
end

function explosions.update(dt)
   for i, p in ipairs(explosions.explosions) do
      p.p:update(dt)
   end
end

function explosions.draw()
   for i, p in ipairs(explosions.explosions) do
      love.graphics.draw(p.p, p.x, p.y)
   end
end

return explosions
