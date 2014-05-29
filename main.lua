--      ==          == == ==       ==       == ==
--      ==          ==    ==    ==    ==    ==    ==
--      ==          ==    ==    == == ==    ==    ==
--      ==          ==    ==    ==    ==    ==    ==
--      == == ==    == == ==    ==    ==    == ==    

function love.load()

	debug = false

	player = { sprite = love.graphics.newImage("player_02a.png"), x = 400, y = 300, w = 0, h = 0, rot = 0, ox = 0, sx = 0.25, sy = 0.25, rotRate = 1, engines = 1, guns  = 1 }

	player.w = player.sprite:getWidth()
	player.h = player.sprite:getHeight()
	player.ox = player.w/2
	player.oy = player.h/2

	-- mountTypes = "engine", "gun", nil
	player.mounts = {
		{id = 1, parent = player, sprite = love.graphics.newImage("engine_02.png"), mountType = "engine", rot = 0, mx = -0.75, my = -0.35, x=0, y=0, sx = 1, sy = 1, visible = true},
		{id = 2, parent = player, sprite = love.graphics.newImage("engine_02.png"), mountType = "engine", rot = 0, mx = -0.75, my = 0.35, x=0, y=0, sx = 1, sy = 1,  visible = true},
		{id = 3, parent = player, sprite = love.graphics.newImage("engine_02.png"), mountType = "engine", rot = 0, mx = -0.65, my = 0, x=0, y=0, sx = 1, sy = 1, visible = true},
		{id = 4, parent = player, sprite = love.graphics.newImage("gun_01.png"), mountType = "gun", rot = 0, mx = 0.80, my = -0.25, x=0, y=0, sx = 0.9, sy = 0.9, visible = true},
		{id = 5, parent = player, sprite = love.graphics.newImage("gun_01.png"), mountType = "gun", rot = 0, mx = 0.80, my = 0.25, x=0, y=0, sx = 0.9, sy = 0.9, visible = true},
		{id = 6, parent = player, sprite = love.graphics.newImage("gun_01.png"), mountType = "gun", rot = 0, mx = 0.95, my = 0, x=0, y=0, sx = 0.9, sy = 0.9, visible = true}
	}

	for id in pairs(player.mounts) do 
		if player.mounts[id].mountType ~= nil then
			player.mounts[id].w = player.mounts[id].sprite:getWidth()
			player.mounts[id].h = player.mounts[id].sprite:getHeight()
			player.mounts[id].ox = player.mounts[id].w/2
			player.mounts[id].oy = player.mounts[id].h/2
		end
	end

end


--      ==    ==    == ==       == ==          ==       == == ==    == == ==
--      ==    ==    ==    ==    ==    ==    ==    ==       ==       ==
--      ==    ==    == ==       ==    ==    == == ==       ==       == ==
--      ==    ==    ==          ==    ==    ==    ==       ==       ==
--      == == ==    ==          == ==       ==    ==       ==       == == ==

function love.update(dt)
	player.rot = player.rot + player.rotRate * dt

	for id in pairs(player.mounts) do
		player.mounts[id].x, player.mounts[id].y = getMountCoords(player, player.mounts[id].mx, player.mounts[id].my)
	end
	
	if player.rot > math.pi*2 then player.rot = player.rot - math.pi*2 end

	if player.engines == 1 then
		player.mounts[1].visible, player.mounts[2].visible = false, false
		player.mounts[3].visible = true
	elseif player.engines == 2 then
		player.mounts[1].visible, player.mounts[2].visible = true, true
		player.mounts[3].visible = false
	else	
		player.mounts[1].visible, player.mounts[2].visible = true, true
		player.mounts[3].visible = true
	end

	if player.guns == 1 then
		player.mounts[4].visible, player.mounts[5].visible = false, false
		player.mounts[6].visible = true
	elseif player.guns == 2 then
		player.mounts[4].visible, player.mounts[5].visible = true, true
		player.mounts[6].visible = false
	else	
		player.mounts[4].visible, player.mounts[5].visible = true, true
		player.mounts[6].visible = true
	end


end


--     == ==       == ==          ==       ==    ==
--     ==    ==    ==    ==    ==    ==    ==    ==
--     ==    ==    == ==       == == ==    ==    ==
--     ==    ==    ==   ==     ==    ==    == == ==
--     == ==       ==   ==     ==    ==    ==    ==

function love.draw()
	love.graphics.setBackgroundColor(39,40,34)

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(	player.sprite, 	player.x, 	player.y, 	player.rot, 			player.sx, 				player.sy, 			player.ox, 			player.oy)

	for id in pairs(player.mounts) do
		if player.mounts[id].sprite ~= nil and player.mounts[id].visible then
			love.graphics.draw(	player.mounts[id].sprite, 
								player.mounts[id].x, 
								player.mounts[id].y,
								player.mounts[id].parent.rot 	+ player.mounts[id].rot,
								player.mounts[id].parent.sx 	* player.mounts[id].sx,
								player.mounts[id].parent.sy 	* player.mounts[id].sy,
								player.mounts[id].ox,
								player.mounts[id].oy
								)
		end
	end

	if debug then
		for id in pairs(player.mounts) do
			love.graphics.setColor(0,255,255,255)
			love.graphics.circle("fill", player.mounts[id].x, player.mounts[id].y, 5, 5)
		end
			love.graphics.print("engines: ".. player.engines .. "   guns: " .. player.guns.. "    player.rot: ".. string.format("%.2f", player.rot), 300, 500)
	end
	love.graphics.setColor(255,128,64,255)
	love.graphics.print("P = Debug    1 / 2 = Zoom In/Out     3 / 4 = Cycle Engines/Weapons      R = Rotation Direction", 125,550)

end

function love.focus(bool)
end


--      == == ==    ==    ==    == ==       ==    ==    == == ==
--         ==       == == ==    ==    ==    ==    ==       ==
--         ==       == == ==    == ==       ==    ==       ==
--         ==       ==    ==    ==          ==    ==       ==
--      == == ==    ==    ==    ==          == == ==       ==

function love.keypressed(key, unicode)
	if key == "1" then
		player.sx = player.sx + 0.10
		player.sy = player.sy + 0.10
	elseif key == "2" then
		player.sx = player.sx - 0.10
		player.sy = player.sy - 0.10
	end
	if key == "p" then
		if debug then debug = false
		else debug = true end
	end
	if key == "3" then
		player.engines = player.engines + 1
		if player.engines > 3 then player.engines = 1 end
	end
	if key == "4" then
		player.guns = player.guns + 1
		if player.guns > 3 then player.guns = 1 end
	end

	if key == "r" then
		player.rotRate = -(player.rotRate)
	end

end

function love.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end


--      == == ==    ==    ==    == == ==    == == ==
--      ==    ==    ==    ==       ==          ==
--      ==    ==    ==    ==       ==          ==
--      == == ==    ==    ==       ==          ==
--            ==    == == ==    == == ==       ==

function love.quit()
end


function getMountCoords(parent, mountX, mountY)

	-- find out the pixelized coordinates of a relative -1 <-> +1
	-- real 1:1 cordiantes on full scale image
	mountX = parent.w/2*mountX + parent.w/2
	mountY = parent.h/2*mountY + parent.h/2
	--	print("local coords on object:       " .. mountX .. " " .. mountY) -- WAS "1:1 coords on object: ..."

	-- relative to pivot/offest point
	mountX = mountX - parent.ox
	mountY = mountY - parent.oy
	--	print("Coords relative to pivot:   " .. mountX .. " " .. mountY)

	--  radian of pivot -> mount
	--	print("Rads to mount: " .. angleToMount)

	distanceFromPivot = math.sqrt( math.pow( mountX, 2 ) + math.pow( mountY, 2 ) )
	--	print("Distance to point from pivot " .. distanceFromPivot)

	--screen location
	mountX = (mountX*parent.sx) + parent.x 
	mountY = (mountY*parent.sy) + parent.y
	--	print("real Coords w/o rotation:    " .. mountX .. " " .. mountY)

	--radian of pivot -> mount
	local angleToMount = math.atan2( (mountY - parent.y  ), ( mountX - parent.x  ) )
	angleToMount = angleToMount + player.rot
	local xOffset = math.cos(angleToMount)*distanceFromPivot
	local yOffset = math.sin(angleToMount)*distanceFromPivot
	--	print("Rads to mount: " .. angleToMount .. " | x-Offset: " .. xOffset .. " | y-Offset: " .. yOffset)

	xOffset = player.x+ (xOffset*player.sx)
	yOffset = player.y + (yOffset * player.sy)

	--- now need to get offset point and apply distanceFromPivot and rotation in raidans to find real mount point
	--enemy.rot = math.atan2((player.y - enemy.y), (player.x - enemy.x))

	return xOffset, yOffset;
end
