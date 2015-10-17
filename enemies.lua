-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

enemies = {}

function enemies.load()
   enemies.enemies = {
      {
         img = love.graphics.newImage('assets/enemy_swarm.png'),
         xy = {},
         bullets = {},
         bulletSpeedDef = 200,
         update = swarmEnemyUpdate,
         lifesDef = 2,
         points = 1,
      },
      {
         img = love.graphics.newImage('assets/enemy_fighter.png'),
         xy = {},
         bullets = {},
         bulletSpeedDef = 500,
         update = fighterEnemyUpdate,
         lifesDef = 16,
         points = 4,
      },
      {
         img = love.graphics.newImage('assets/enemy_boss.png'),
         xy = {},
         bullets = {},
         bulletSpeedDef = 400,
         update = bossEnemyUpdate,
         lifesDef = 400,
         points = 30,
      },
   }

   enemies.bullet = { img = love.graphics.newImage('assets/enemy_bullet.png') }
end

function enemies.reset()
   for i, e in ipairs(enemies.enemies) do
      e.xy = {}
      e.bullets = {}
      e.bulletSpeed = e.bulletSpeedDef
      e.lifes = e.lifesDef
   end
end   

function swarmEnemyUpdate(e, dt)
   local w = e.img:getWidth()
   if next(e.xy) == nil then
      if love.math.random(1,2/dt) == 1 then
         local ww = 0
         local sign = -1
         if love.math.random(1,2) == 1 then
            ww = winw
            sign = 1
         end
         e.sign = sign
         for i=1,5 do
            e.xy[i] = {
               x = ww+sign*(w*i+love.math.random(50*(i-1),50*i)),
               y = love.math.random(10, 200),
               lifes = e.lifes
            }
         end
      end
   else
      for i=#e.xy,1,-1 do
         e.xy[i].x = e.xy[i].x - e.sign*150*dt
         e.xy[i].y = e.xy[i].y + love.math.random(10,100)*dt
         if e.sign == -1 and e.xy[i].x > winw or
            e.sign == 1 and e.xy[i].x + w < 0
         then
            table.remove(e.xy, i)
         end
      end
   end

   for i, xy in ipairs(e.xy) do
      if love.math.random(1, 2/dt) == 1 then
         table.insert(e.bullets, {
                         x = xy.x + e.img:getWidth()/2,
                         y = xy.y + e.img:getHeight(),
         })
         shoot:play()
      end
   end
end

function fighterEnemyUpdate(e, dt)
   local w = e.img:getWidth()
   local ww = winw
   for i=1,2 do
      if e.xy[i] == nil and love.math.random(1,2/dt) == 1 then
         local x
         if love.math.random(1, 2) == 1 then
            x = love.math.random(-w-20, -w-5)
         else
            x = love.math.random(ww+5, ww+20)
         end
         e.xy[i] = {
            x = x,
            y = love.math.random(20, 200),
            lifes = e.lifes,
            moveTimer = 0,
         }
      end
   end

   for i, xy in ipairs(e.xy) do
      if xy.moveTimer <= 0 then
         xy.moveTimer = love.math.random(1.0, 4.0)
         if xy.x < 0 then
            xy.movex = love.math.random(0, 200)
         elseif xy.x < winw/4 then
            xy.movex = love.math.random(-50, 70)
         elseif xy.x > winw then
            xy.movex = love.math.random(-200, 0)
         elseif xy.x > winw*3/4 then
            xy.movex = love.math.random(-70, 50)
         else
            xy.movex = love.math.random(-50, 50)
         end
         if xy.y < 0 then
            xy.movey = love.math.random(0, 50)
         elseif xy.y > winh/2 then
            xy.movey = love.math.random(-50, 20)
         else
            xy.movey = love.math.random(-20, 20)
         end
      end
      xy.x = xy.x + xy.movex * dt
      xy.y = xy.y + xy.movey * dt
      xy.moveTimer = xy.moveTimer - dt
   end

   for i, xy in ipairs(e.xy) do
      if love.math.random(1, 2/dt) == 1 then
         table.insert(e.bullets, {
                         x = xy.x + e.img:getWidth()/2,
                         y = xy.y + e.img:getHeight(),
         })
      end
   end
end

function bossEnemyUpdate(e, dt)
   if e.xy[1] == nil and player.score > 50 and love.math.random(1, 200/dt) == 1 then
      e.xy[1] = {
         x = winw/2 - e.img:getWidth()/2,
         y = -e.img:getHeight() + 10,
         lifes = e.lifes,
      }
   end

   if e.xy[1] ~= nil then
      e.xy[1].y = e.xy[1].y + 8*dt
      if love.math.random(1, 10/dt) == 1 then
         table.insert(e.bullets, {x = e.xy[1].x + e.img:getWidth()*2/7,
                                  y = e.xy[1].y + e.img:getHeight()})
         
         table.insert(e.bullets, {x = e.xy[1].x + e.img:getWidth()*4/7,
                                  y = e.xy[1].y + e.img:getHeight()})
         table.insert(e.bullets, {x = e.xy[1].x + e.img:getWidth()*6/7,
                                  y = e.xy[1].y + e.img:getHeight()})
      end
   end
end

function enemies.update(dt)
   for i, e in ipairs(enemies.enemies) do
      e.update(e, dt)
      for i=#e.bullets,1,-1 do
         local b = e.bullets[i]
         b.y = b.y + e.bulletSpeed*dt
         if b.y > winh then
            table.remove(e.bullets, i)
         end
      end
   end
end

function enemies.draw()
   for i, e in ipairs(enemies.enemies) do
      for j, xy in ipairs(e.xy) do
         love.graphics.draw(e.img, xy.x, xy.y)
      end
      for i, b in ipairs(e.bullets) do
         love.graphics.draw(enemies.bullet.img, b.x, b.y)
      end
   end
end

return enemies
