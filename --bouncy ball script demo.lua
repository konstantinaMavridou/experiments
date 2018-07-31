--bouncy ball script demo


--made from scratch by deco
--as a beginner project, 2017

ball = {}
ball.x=64
ball.y=64
ball.scale=0
ball.dx=0
ball.dy=0
ball.onground=false
gravity=0.2
decay=0.7
friction=0.95
effect=true --press z to turn effect on and off

function _init()
	cls()
end

function checkcol()
	if ball.x<20 then
		sfx(0)
		ball.dx=-ball.dx
		ball.x=20
	end
	if ball.x>108 then
		sfx(0)
		ball.dx=-ball.dx
		ball.x=108
	end
	if ball.y>105 then
		sfx(0)
		ball.onground=true
		ball.dy=-ball.dy*decay
		ball.y=105
		if abs(ball.dy)<3 then
			ball.dy=0
			ball.y=104
		end		
	end
	if ball.y<104 then
		ball.onground=false
	end
end

function updateball()
	checkcol()
	ball.x+=ball.dx
	ball.y+=ball.dy
	if not ball.onground then
		ball.dy+=gravity
	else
		ball.dx*=friction
		if abs(ball.dx)<0.1 then
			ball.dx=0
		end
	end
end

function _update60()
	if (btnp(0)) then ball.dx-=4 end
	if (btnp(1)) then ball.dx+=4 end
	if (btnp(2)) then ball.dy-=5 end
	if (btnp(4)) then	effect=not effect end
	updateball()
	ball.scale=(2+(ball.y/6))
end

function _draw()


	if effect then
		for i=1,1999 do
			local x=flr(rnd(128))
			local y=flr(rnd(128))
			if pget(x,y)>0 then
				pset(x,y,pget(x,y)*0.6)
			end
		end
	else
		cls()
	end
	circfill(ball.x,ball.y,ball.scale,8)
	circ(ball.x,ball.y,ball.scale,2)
	circfill(ball.x+(ball.scale/5),ball.y-(ball.scale/5),ball.scale*.6,9)
	circfill(ball.x+(ball.scale/4),ball.y-(ball.scale/4),ball.scale*.4,10)
	circfill(ball.x+(ball.scale/3),ball.y-(ball.scale/3),ball.scale*.2,7)
	//rect(20,-1,108,105,1)
	//print(ball.dx,20,20,7)
	//print(ball.dy,20,26,7)
	//print(ball.scale,20,32,7)
	print("deco - 2017",80,120,7)

end
