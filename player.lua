-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

player = {}

local heartImg

function player.load()
   heartImg = love.graphics.newImage('assets/heart.png')
   player.img = love.graphics.newImage('assets/player.png')
   player.w = player.img:getWidth()
   player.h = player.img:getHeight()
   player.bullet = { img = love.graphics.newImage('assets/player_bullet.png') }
end

local shootDelay = 0.1
local shootTimer = shootDelay
local loaderMax = 15
local loader = loaderMax

function player.reset()
   player.lifes = 3
   player.score = 0
   player.x = winw/2
   player.y = winh - player.img:getHeight() - 20
   player.bullets = {}
   shootTimer = shootDelay
   loader = loaderMax
end

function player.update(dt)
   if love.keyboard.isDown(' ') then
      shootTimer = shootTimer + dt
      if shootTimer >= shootDelay and loader >= 1 then
         shoot:play()
         table.insert(player.bullets, {
                         x = player.x + player.w/2 - 5 - player.bullet.img:getWidth(),
                         y = player.y
         })
         table.insert(player.bullets, {
                         x = player.x + player.w/2 + 5,
                         y = player.y
         })
         shootTimer = 0
         loader = loader - 1
      end
   else
      shootTimer = shootDelay
      loader = loader + 30 * dt
      loader = math.min(loader, loaderMax)
   end

   if love.keyboard.isDown('left') then
      player.x = player.x - 500*dt
      if player.x < 0 then
         player.x = 0
      end
   end
   if love.keyboard.isDown('right') then
      player.x = player.x + 500*dt
      if player.x + player.w > winw then
         player.x = winw - player.w
      end
   end

   for i=#player.bullets,1,-1 do
      local b = player.bullets[i]
      b.y = b.y - 500*dt
      if b.y + player.bullet.img:getHeight() < 0 then
         table.remove(player.bullets, i)
      end
   end
end   

function player.draw()
   for i, b in ipairs(player.bullets) do
      love.graphics.draw(player.bullet.img, b.x, b.y)
   end
   love.graphics.draw(player.img, player.x, player.y)

   -- loader indicator
   local li = {x = 5, y = winh - 15, w = 90, h = 5 }
   love.graphics.setColor(0xff, 0x0, 0x0)
   love.graphics.rectangle('line', li.x-1, li.y-1, li.w+2, li.h+2)
   love.graphics.setColor(0x0, 0xff, 0x0)
   local w = li.w*loader/loaderMax
   w = w - math.fmod(w, li.w/loaderMax)
   love.graphics.rectangle('fill', li.x, li.y, w, li.h)
   -- reset color
   love.graphics.setColor(0xff, 0xff, 0xff)

   local w = heartImg:getWidth()
   local h = heartImg:getHeight()
   for i=1,player.lifes do
      love.graphics.draw(heartImg, winw-w*i-5*i, winh-h - 5)
   end
end

function player.increaseScore(p)
   player.score = player.score + p
   -- increase difficulty
   for i, e in ipairs(enemies.enemies) do
      e.bulletSpeed = e.bulletSpeed + p
      e.lifes = e.lifes + 0.02*p
   end
end

return player
