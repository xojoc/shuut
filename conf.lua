-- Shuut was written by Alexandru Cojocaru (http://xojoc.pw)
-- This source is released in the Public Domain. Do what you want with it.

function love.conf(t)
	t.title = "Shuut"
	t.version = "0.9.2"
--	t.console = true

        t.modules.joystick = false
        t.modules.physics = false
        t.modules.mouse = false
end
