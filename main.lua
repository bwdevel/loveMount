--      ==          == == ==       ==       == ==
--      ==          ==    ==    ==    ==    ==    ==
--      ==          ==    ==    == == ==    ==    ==
--      ==          ==    ==    ==    ==    ==    ==
--      == == ==    == == ==    ==    ==    == ==    

function love.load()
player = {}
player.sprite = love.graphics.newImage("player_02a.png")

player.mounts = {
					{id = 1, parent = player, sprite = love.graphics.newImage("engine_02.png"), mountType = "engine", mx = -0.65, my = 0, x=0, y=0, sx = 0.25, sy = 0.25}

				}

player.x = 400
player.y = 300
player.w = player.sprite:getWidth()
player.h = player.sprite:getHeight()


player.rot = 0
player.ox = player.w/2
player.oy = player.h/2
player.sx = 0.25
player.sy = 0.25

player.rotRate = 1

--mounts = {}
mount = {}

--mount.sprite = love.graphics.newImage("engine_02.png")
mount.sprite = player.mounts[1].sprite
mount.x = player.mounts[1].x
mount.y = player.mounts[1].y
mount.w = mount.sprite:getWidth()
mount.h = mount.sprite:getHeight()
mount.parent = player.mounts[1].parent

mount.rot = 0
mount.ox = mount.w/2 -- mount.w-16
mount.oy = mount.h/2
mount.sx = 1
mount.sy = 1



tempX1 = 0
tempY1 = 0
tempX2 = 0
tempY2 = 0
-- print(getMountCoords(player, 0.5,0.5))
--getMountCoords(player, 1, 0)
--getMountCoords(player, 0, -1)
--getMountCoords(player, -1, 0)
--getMountCoords(player, 0, 1)
--print("-=-=-=-")
--getMountCoords(player,1,1)
--getMountCoords(player,0,0)
--getMountCoords(player,-1,1)



print("Size of Image: " .. player.w .. " x " .. player.h)
end


--      ==    ==    == ==       == ==          ==       == == ==    == == ==
--      ==    ==    ==    ==    ==    ==    ==    ==       ==       ==
--      ==    ==    == ==       ==    ==    == == ==       ==       == ==
--      ==    ==    ==          ==    ==    ==    ==       ==       ==
--      == == ==    ==          == ==       ==    ==       ==       == == ==

function love.update(dt)
	player.rot = player.rot + player.rotRate * dt
	tempX1, tempY1 = getMountCoords(player, -0.5, -0.5)
	tempX2, tempY2 = getMountCoords(player, -0.5, 0.5)
	mount.x, mount.y = getMountCoords(player, -0.65, 0)
	
	if player.rot > math.pi*2 then player.rot = player.rot - math.pi*2 end



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

	love.graphics.draw(	mount.sprite, 	mount.x, 	mount.y, 	player.rot+mount.rot, 	mount.sx*mount.parent.sx, 	mount.sy*mount.parent.sy,	mount.ox,			mount.oy)

	love.graphics.setColor(0, 255, 0,255)
	love.graphics.rectangle("fill", tempX1-5, tempY1-5, 10, 10)

	love.graphics.setColor(0, 255, 255,255)
	love.graphics.rectangle("fill", tempX2-5, tempY2-5, 10, 10)

	love.graphics.print(player.rot, 300, 500)
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

	--- mountX/Y = passed values
	--print("Passed Vals:                " .. mountX .. " " .. mountY)

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



print()


--	return mountX, mountY;
	return xOffset, yOffset;
end

