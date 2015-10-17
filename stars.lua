-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

stars = {}

function stars.load()
   stars.star = love.graphics.newImage('assets/star.png')
   
   stars.psystem = love.graphics.newParticleSystem(stars.star, 1000)
   stars.psystem:setParticleLifetime(10)
   stars.psystem:setEmissionRate(40)
   stars.psystem:setLinearAcceleration(-20, -20, 20, 50)
   stars.psystem:setTangentialAcceleration(5, 20)
   stars.psystem:setColors(
      {0,0,0xff},
      {0,0xff,0},
      {0xff,0,0},
      {0xff,0xff,0xff})
end

function stars.update(dt)
   stars.psystem:update(dt)
end

function stars.draw()
   love.graphics.draw(stars.psystem, winw/2, winh/4)
end

return stars
