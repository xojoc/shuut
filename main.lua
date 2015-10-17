-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

require('stars')
require('player')
require('enemies')
require('explosions')

-- playing, paused, game over
local state = 'paused'
local fontMenu
local fontScore

local function reset()
   state = 'paused'
   player.reset()
   enemies.reset()
   explosions.reset()
end

local scale

winw = 600
winh = 800

dimensions = {
   {600, 800, 1},
   {450, 600, 0.75},
   {300, 400, 0.5},
}

function rescale(n)
   if not love.window.setMode(dimensions[n][1], dimensions[n][2]) then
      print("can't set mode")
   end
   scale = dimensions[n][3]
end

function love.load(arg)
   --   math.randomseed(os.time())
   rescale(1)
   local music = love.audio.newSource('assets/jungle_a.ogg')
   music:setVolume(0.3)
   music:setLooping(-1)
   music:play()
   shoot = love.audio.newSource('assets/shoot.wav', 'static')
   shoot:setVolume(0.1)
   fontMenu = love.graphics.newFont(30)
   fontScore = love.graphics.newFont(60)
   stars.load()
   player.load()
   enemies.load()
   explosions.load()
   reset()
end

local function gameOver()
   state = 'game over'
   player.bullets = {}
end

local function collides(ax, ay, aw, ah, bx, by, bw, bh)
   return
      bx < ax + aw and bx + bw > ax and
      by < ay + ah and by + bh > ay 
end

local function checkCollisions()
   for i, e in ipairs(enemies.enemies) do
      for j=#e.xy,1,-1 do
         if e.xy[j] ~= nil then
            if collides(e.xy[j].x, e.xy[j].y, e.img:getWidth(), e.img:getHeight(),
                        player.x, player.y, player.w, player.h) then
               explosions.add(player.x, player.y)
               gameOver()
            end
            if e.xy[j].y > winh then
               gameOver()
            end
         end

         for k=#player.bullets,1,-1 do
            local b = player.bullets[k]
            -- FIXME: checking for nil is a kludge
            if e.xy[j] ~= nil and
               collides(e.xy[j].x, e.xy[j].y, e.img:getWidth(), e.img:getHeight(),
                        b.x, b.y, player.bullet.img:getWidth(), player.bullet.img:getHeight()) then
               e.xy[j].lifes = e.xy[j].lifes - 1
               table.remove(player.bullets, k)
               if e.xy[j].lifes < 1 then
                  player.increaseScore(e.points)
                  explosions.add(e.xy[j].x + e.img:getWidth()/2, e.xy[j].y + e.img:getHeight()/2)
                  table.remove(e.xy, j)
                  break
               end
            end
         end

         for k=#e.bullets,1,-1 do
            if collides(e.bullets[k].x, e.bullets[k].y, enemies.bullet.img:getWidth(), enemies.bullet.img:getHeight(),
                        player.x, player.y, player.w, player.h) then
               explosions.add(player.x + player.w/2, player.y + player.h/2)
               player.lifes = player.lifes - 1
               if player.lifes == 0 then
                  gameOver()
               end
               table.remove(e.bullets, k)
            end
         end
      end
   end
end

function love.update(dt)
   stars.update(dt)
   if state == 'playing' or state == 'game over' then
      if state ~= 'game over' then
         player.update(dt)
      end
      enemies.update(dt)
      explosions.update(dt)
      if state ~= 'game over' then
         checkCollisions()
      end
   end
end

function love.keypressed(k)
   if k == '1' or k == '2' or k == '3' then
      rescale(tonumber(k))
      return
   end
   
   if state == 'paused' then
      state = 'playing'
   end
   
   if k == 'p' and state == 'playing' then
      state = 'paused'
   elseif k == 'r' then
      reset()
   elseif k == 'escape' or k == 'q' then
      love.event.push('quit')
   end
end

function love.draw()
   love.graphics.scale(scale, scale)
   stars.draw()
   if state ~= 'game over' then
      player.draw()
   end
   enemies.draw()
   explosions.draw()
   love.graphics.setFont(fontScore)
   love.graphics.print(player.score, 10, 10)
   local lh = fontMenu:getHeight()
   if state == 'paused' then
      local bw = 50
      local bh = winh/4
      love.graphics.setFont(fontMenu)
      love.graphics.setColor(0xa0,0xff,0xa0)
      love.graphics.setColor(0xff,0xff,0xff)
      love.graphics.print('SPACE - Shoot', bw, bh)
      love.graphics.print('LEFT, RIGHT ARROWS - Move', bw, bh + lh*1 + 10)
      love.graphics.print('P - Pause', bw, bh + lh*2 + 10)
      love.graphics.print('R - Restart', bw, bh + lh*3 + 10)
      love.graphics.print('Q - Quit', bw, bh + lh*4 + 10)
      love.graphics.print('Change window size with:', bw, bh + lh*5 + 10)
      love.graphics.print('1 - ' .. dimensions[1][1] .. 'x' .. dimensions[1][2], bw, bh + lh*6 + 10)
      love.graphics.print('2 - ' .. dimensions[2][1] .. 'x' .. dimensions[2][2], bw, bh + lh*7 + 10)
      love.graphics.print('3 - ' .. dimensions[3][1] .. 'x' .. dimensions[3][2], bw, bh + lh*8 + 10)

      love.graphics.setColor(0xa0,0xff,0xa0)
      love.graphics.print('Press any key to PLAY', bw, bh + lh*9 + 10)
      love.graphics.setColor(0xff,0xff,0xff)
   elseif state == 'game over' then
      local bw = 50
      local bh = winh/4
      love.graphics.setFont(fontMenu)
      love.graphics.setColor(0xdd,0xa,0xa)
      love.graphics.print('GAME OVER', bw + 200, bh)
      love.graphics.setColor(0xff,0xff,0xff)
      love.graphics.print('R - REPLAY', bw, bh + lh + 10)
      love.graphics.print('Q - QUIT', bw, bh + lh*2 + 10)
   end
end
