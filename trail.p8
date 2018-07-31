pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

db = false
corrupt_mode = false

gamescreen = false
menuflash = true

t = 0
tick = 0
tock = false
halftock = false
quartertock = false
eighthtock = false

playerone = {}
playerone.w = 8
playerone.h = 8
playerone.x = 64
playerone.y = 112

playerone.sprite = 0

playerone.speed = 1

playerone.dx = 0
playerone.dy = 0

playerone.moving = false
playerone.up = true
playerone.left = false
playerone.vert = true

playerone.controls = {0, 1, 2, 3}

playerone.up_key = false
playerone.down_key = false
playerone.left_key = false
playerone.right_key = false

playerone.colour = 8
playerone.trail = {}

playerone.particles = {}

players = {playerone}

nx = 1
ny = 1

function move(p)
  p.moving = true
  p.sprite += 1
  if p.sprite > 3 then
   p.sprite = 0
  end
end

function getinputs()
	return
	{
	   [0]=btnp(0, 0),
	   [1]=btnp(1, 0),
	   [2]=btnp(2, 0),
	   [3]=btnp(3, 0),
	   [4]=btnp(4, 0),
	   [5]=btnp(5, 0),
	   [6]=btnp(0, 1),
	   [7]=btnp(1, 1),
	   [8]=btnp(2, 1),
	   [9]=btnp(3, 1),
	   [10]=btnp(4, 1),
	   [11]=btnp(5, 1)
    }
end

function reset()
	gamescreen = false
	
	players[1].x = 64
	players[1].y = 112
	players[1].speed = 1
	players[1].moving = false
	players[1].up = true
	players[1].left = false
	players[1].vert = true

	players[1].trail = {}
end

function make_particle(x, y, particles, colour)

	particle = {}
	particle.x = x
	particle.y = y
	particle.dx = cos(flr(rnd(32))/32)/2
	particle.dy = sin(flr(rnd(32))/32)/2

	particle.t = 0
	particle.max_t = 30
	particle.ddy = 0.01
	
	particle.sprite = 48 + flr(rnd(2))	-- 48 or 49
	particle.colour = colour
	
	add(particles, particle)
end

function update_particles(particle)
	particle.dy += particle.ddy
	particle.t += 1
end

function menu_update()

	local inputs = getinputs()
	t += 1
	ticktock(t)

	if tock then
		menuflash = not menuflash
	end

	if btnp(4) then
	
		gamescreen = true	
	elseif btnp(5) then
	
		gamescreen = true
	end
end

function game_update()

	local inputs = getinputs()
	t += 1
	ticktock(t)

	for p in all(players) do
		
		foreach(p.particles, update_particles)
	
		if not p.moving then
 		p.sprite = 4
  end

		local spd = 1
		while(spd <= p.speed) do
		
			if p.vert then
				if p.up then
					p.y -= 1
				else
					p.y += 1
				end
			else
				if p.left then
					p.x -= 1
				else
					p.x += 1
				end
			end
			
			local trail = {}
			trail.w = 1
			trail.h = 1
			trail.x = p.x + (p.w / 2) - 1
			trail.y = p.y + (p.h / 2) - 1
			
			trail.life = 140
			
			add(p.trail, trail)
			
			spd += 1
		end
		
		if p.x < 0 then
			p.x = 0
		elseif p.x + p.w > 128 then
			p.x = 128 - p.w
		end
		
		if p.y < 0 then
			p.y = 0
		elseif p.y + p.h > 128 then
			p.y = 128 - p.h
		end
		
		if inputs[p.controls[1]] then
		 move(p)
			if p.vert then
				p.vert = false
				p.left = true
			
				p.x -= 2
			end
		
			p.left_key = true
		end
		
		if inputs[p.controls[2]] then
		 move(p)
			if p.vert then
				p.vert = false
				p.left = false
			
				p.x += 2
			end
			
			p.right_key = true
		end
		
		if inputs[p.controls[3]] then
		 move(p)
			if not p.vert then
				p.vert = true
				p.up = true
			
				p.y -= 2
			end
		
			p.up_key = true	
		end
		
		if inputs[p.controls[4]] then
		 move(p)
			if not p.vert then
				p.vert = true
				p.up = false
			
				p.y += 2
			end
		
			p.down_key = true
		end
		
		for t in all(p.trail) do
			t.life -= 1
			
			if t.life < 0 then
				del(p.trail, t)
			end
		end
	end
end

function _update()	
	if not gamescreen then
		menu_update()
	else
		game_update()
	end
end

function ticktock(t)

	if t % 30 == 0 then
		tick += 1
		tock = true
	else
		tock = false
	end
		
	if t % 15 == 0 then
		halftock = true
	else
		halftock = false
	end
	
	if t % 8 == 0 then
		quartertock = true
	else
		quartertock = false
	end
	
	if t % 4 == 0 then
		eighthtock = true
	else
		eighthtock = false
	end
end

function _init()
end

function draw_particle(p)
	spr(p.sprite, p.x + 8, p.y)
	--pal()
end

function menudraw()
	map(16, 0, 0, 0, 16, 16)
	if menuflash then
		print("press z to start", 32, 90, 7)
		print("press x to reset", 32, 100, 7)
	end
end

function gamedraw()	
	map(0, 0, 0, 0, 16, 16)
	for p in all(players) do
		
		for t in all(p.trail) do
			pset(t.x, t.y, p.colour)
		end
	
		if p.vert then
			if p.up then
				spr(p.sprite, p.x, p.y, p.w / 8, p.h / 8, false, false)
			else
				spr(p.sprite, p.x, p.y, p.w / 8, p.h / 8, false, true)
			end
		else
		
			if p.left then
				spr(p.sprite, p.x, p.y, p.w / 8, p.h / 8, false, false)
			else
				spr(p.sprite, p.x, p.y, p.w / 8, p.h / 8, true, false)
			end

		end

		pal()
	end
end

function _draw()
	cls()
	if not gamescreen then
		menudraw()
	else
		gamedraw()
	end
end




__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67700000067770000007760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77770000077770000077770000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7e8780000778e0000077780006778e00000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77770000077770000077760007777600007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77776000076076000077770007777000067778600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60707000060006000677600067070000678777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000


